Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZKDLLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZKDLLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZKDLLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:11:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:39801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbZKDLLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:11:39 -0500
Date: Wed, 4 Nov 2009 11:10:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257291970-8208-1-git-send-email-acme@infradead.org>
References: <1257291970-8208-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Factor out buildid reading routine
Message-ID: <tip-2643ce11457a99a85c5bed8dd631e35968e6ca5a@git.kernel.org>
Git-Commit-ID: 2643ce11457a99a85c5bed8dd631e35968e6ca5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2643ce11457a99a85c5bed8dd631e35968e6ca5a
Gitweb:     http://git.kernel.org/tip/2643ce11457a99a85c5bed8dd631e35968e6ca5a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Nov 2009 21:46:10 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 12:03:32 +0100

perf symbols: Factor out buildid reading routine

So that we can run it without having a DSO instance.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1257291970-8208-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |   51 ++++++++++++++++++++++++++++++---------------
 tools/perf/util/symbol.h |    2 +
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ac94d7b..e7c7cdb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -825,27 +825,27 @@ out_close:
 	return err;
 }
 
-#define BUILD_ID_SIZE 128
+#define BUILD_ID_SIZE 20
 
-static char *dso__read_build_id(struct dso *self)
+int filename__read_build_id(const char *filename, void *bf, size_t size)
 {
-	int i;
+	int fd, err = -1;
 	GElf_Ehdr ehdr;
 	GElf_Shdr shdr;
 	Elf_Data *build_id_data;
 	Elf_Scn *sec;
-	char *build_id = NULL, *bid;
-	unsigned char *raw;
 	Elf *elf;
-	int fd = open(self->long_name, O_RDONLY);
 
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
 	if (fd < 0)
 		goto out;
 
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		pr_err("%s: cannot read %s ELF file.\n", __func__,
-		       self->long_name);
+		pr_err("%s: cannot read %s ELF file.\n", __func__, filename);
 		goto out_close;
 	}
 
@@ -854,29 +854,46 @@ static char *dso__read_build_id(struct dso *self)
 		goto out_elf_end;
 	}
 
-	sec = elf_section_by_name(elf, &ehdr, &shdr, ".note.gnu.build-id", NULL);
+	sec = elf_section_by_name(elf, &ehdr, &shdr,
+				  ".note.gnu.build-id", NULL);
 	if (sec == NULL)
 		goto out_elf_end;
 
 	build_id_data = elf_getdata(sec, NULL);
 	if (build_id_data == NULL)
 		goto out_elf_end;
-	build_id = malloc(BUILD_ID_SIZE);
+	memcpy(bf, build_id_data->d_buf + 16, BUILD_ID_SIZE);
+	err = BUILD_ID_SIZE;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+out:
+	return err;
+}
+
+static char *dso__read_build_id(struct dso *self)
+{
+	int i, len;
+	char *build_id = NULL, *bid;
+	unsigned char rawbf[BUILD_ID_SIZE], *raw;
+
+	len = filename__read_build_id(self->long_name, rawbf, sizeof(rawbf));
+	if (len < 0)
+		goto out;
+
+	build_id = malloc(len * 2 + 1);
 	if (build_id == NULL)
-		goto out_elf_end;
-	raw = build_id_data->d_buf + 16;
+		goto out;
 	bid = build_id;
 
-	for (i = 0; i < 20; ++i) {
+	raw = rawbf;
+	for (i = 0; i < len; ++i) {
 		sprintf(bid, "%02x", *raw);
 		++raw;
 		bid += 2;
 	}
 	pr_debug2("%s(%s): %s\n", __func__, self->long_name, build_id);
-out_elf_end:
-	elf_end(elf);
-out_close:
-	close(fd);
 out:
 	return build_id;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0884330..e0d4a58 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -82,6 +82,8 @@ void dsos__fprintf(FILE *fp);
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 
+int filename__read_build_id(const char *filename, void *bf, size_t size);
+
 int load_kernel(symbol_filter_t filter);
 
 void symbol__init(unsigned int priv_size);
