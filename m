Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZKTWve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZKTWve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKTWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:51:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZKTWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/6] perf symbols: filename__read_build_id should look at .notes section too
Date: Fri, 20 Nov 2009 20:51:25 -0200
Message-Id: <1258757489-5978-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258757489-5978-1-git-send-email-acme@infradead.org>
References: <1258757489-5978-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In the kernel we have more than one notes section, so the linker script
combines all and puts them into a ".notes" combined section. So we need
to look at both sections and also traverse them looking at multiple
GElf_Nhdr entries till we find the one we want, with the build_id.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   47 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3b23c18..d220308 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -899,13 +899,19 @@ bool dsos__read_build_ids(void)
 	return have_build_id;
 }
 
+/*
+ * Align offset to 4 bytes as needed for note name and descriptor data.
+ */
+#define NOTE_ALIGN(n) (((n) + 3) & -4U)
+
 int filename__read_build_id(const char *filename, void *bf, size_t size)
 {
 	int fd, err = -1;
 	GElf_Ehdr ehdr;
 	GElf_Shdr shdr;
-	Elf_Data *build_id_data;
+	Elf_Data *data;
 	Elf_Scn *sec;
+	void *ptr;
 	Elf *elf;
 
 	if (size < BUILD_ID_SIZE)
@@ -928,14 +934,37 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 	sec = elf_section_by_name(elf, &ehdr, &shdr,
 				  ".note.gnu.build-id", NULL);
-	if (sec == NULL)
-		goto out_elf_end;
+	if (sec == NULL) {
+		sec = elf_section_by_name(elf, &ehdr, &shdr,
+					  ".notes", NULL);
+		if (sec == NULL)
+			goto out_elf_end;
+	}
 
-	build_id_data = elf_getdata(sec, NULL);
-	if (build_id_data == NULL)
+	data = elf_getdata(sec, NULL);
+	if (data == NULL)
 		goto out_elf_end;
-	memcpy(bf, build_id_data->d_buf + 16, BUILD_ID_SIZE);
-	err = BUILD_ID_SIZE;
+
+	ptr = data->d_buf;
+	while (ptr < (data->d_buf + data->d_size)) {
+		GElf_Nhdr *nhdr = ptr;
+		int namesz = NOTE_ALIGN(nhdr->n_namesz),
+		    descsz = NOTE_ALIGN(nhdr->n_descsz);
+		const char *name;
+
+		ptr += sizeof(*nhdr);
+		name = ptr;
+		ptr += namesz;
+		if (nhdr->n_type == NT_GNU_BUILD_ID &&
+		    nhdr->n_namesz == sizeof("GNU")) {
+			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
+				memcpy(bf, ptr, BUILD_ID_SIZE);
+				err = BUILD_ID_SIZE;
+				break;
+			}
+		}
+		ptr += descsz;
+	}
 out_elf_end:
 	elf_end(elf);
 out_close:
@@ -963,8 +992,8 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
 		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
 			break;
 
-		namesz = (nhdr.n_namesz + 3) & -4U;
-		descsz = (nhdr.n_descsz + 3) & -4U;
+		namesz = NOTE_ALIGN(nhdr.n_namesz);
+		descsz = NOTE_ALIGN(nhdr.n_descsz);
 		if (nhdr.n_type == NT_GNU_BUILD_ID &&
 		    nhdr.n_namesz == sizeof("GNU")) {
 			if (read(fd, bf, namesz) != namesz)
-- 
1.6.2.5

