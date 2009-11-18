Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZKRWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZKRWVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbZKRWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:21:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZKRWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:20:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf symbols: Record the build_ids of kernel modules too
Date: Wed, 18 Nov 2009 20:20:52 -0200
Message-Id: <1258582853-8579-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258582853-8579-2-git-send-email-acme@infradead.org>
References: <1258582853-8579-1-git-send-email-acme@infradead.org>
 <1258582853-8579-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@doppio linux-2.6-tip]# perf record -a sleep 2s;perf buildid-list|tail
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.162 MB perf.data (~7078 samples) ]
881588fa57b3c1696bc91e5e804a11304f093535 [cfg80211]
4d47ce1da9d16bad00c962c072451b7c681e82df [snd_page_alloc]
5146377e89a7caac617f9782f1a02e46263d3a31 [rfkill]
2153b937bff0d345fea83b63a2e1d3138569f83d [i915]
4e6fb1bb97362e3ee4d306988b9ad6912d5fb9ae [drm_kms_helper]
f56ef2bf853e3a798f0d8d51f797622e5dc4420e [drm]
b0d157a3b5c4e017329ffc07c64623cd6ad65e95 [i2c_algo_bit]
8125374b905ef9fa8b65d98e166b008ad952f198 [i2c_core]
fc875c6e5a90e7b915e9d445d0efc859e1b2678c [video]
4b43c5006589f977e9762fdfc7ac1a92b72fca52 [output]
[root@doppio linux-2.6-tip]#

elfutils libdwfl/linux-kernel-modules.c was used as reference, as
suggested by Roland McGrath.

Cc: Roland McGrath <roland@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    5 ++++
 tools/perf/util/symbol.c |   53 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h |    2 +
 3 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 31731f1..d3d656f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -241,6 +241,11 @@ perf_header__adds_write(struct perf_header *self, int fd)
 
 		buildid_sec = &feat_sec[idx++];
 
+		/*
+		 * Read the list of loaded modules with its build_ids
+		 */
+		dsos__load_modules();
+
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
 		if (dsos__write_buildid_table(fd) < 0)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 946ec31..7b4cede 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -9,6 +9,7 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+#include <limits.h>
 #include <sys/utsname.h>
 
 enum dso_origin {
@@ -943,6 +944,50 @@ out:
 	return err;
 }
 
+int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
+{
+	int fd, err = -1;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	while (1) {
+		char bf[BUFSIZ];
+		GElf_Nhdr nhdr;
+		int namesz, descsz;
+
+		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
+			break;
+
+		namesz = (nhdr.n_namesz + 3) & -4U;
+		descsz = (nhdr.n_descsz + 3) & -4U;
+		if (nhdr.n_type == NT_GNU_BUILD_ID &&
+		    nhdr.n_namesz == sizeof("GNU")) {
+			if (read(fd, bf, namesz) != namesz)
+				break;
+			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
+				if (read(fd, build_id,
+				    BUILD_ID_SIZE) == BUILD_ID_SIZE) {
+					err = 0;
+					break;
+				}
+			} else if (read(fd, bf, descsz) != descsz)
+				break;
+		} else {
+			int n = namesz + descsz;
+			if (read(fd, bf, n) != n)
+				break;
+		}
+	}
+	close(fd);
+out:
+	return err;
+}
+
 char dso__symtab_origin(const struct dso *self)
 {
 	static const char origin[] = {
@@ -1218,7 +1263,7 @@ static struct map *map__new2(u64 start, struct dso *dso)
 	return self;
 }
 
-static int dsos__load_modules(void)
+int dsos__load_modules(void)
 {
 	char *line = NULL;
 	size_t n;
@@ -1268,6 +1313,12 @@ static int dsos__load_modules(void)
 			goto out_delete_line;
 		}
 
+		snprintf(name, sizeof(name),
+			 "/sys/module/%s/notes/.note.gnu.build-id", line);
+		if (sysfs__read_build_id(name, dso->build_id,
+					 sizeof(dso->build_id)) == 0)
+			dso->has_build_id = true;
+
 		dso->origin = DSO__ORIG_KMODULE;
 		kernel_maps__insert(map);
 		dsos__add(dso);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 546eb76..da7ec1a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -78,6 +78,7 @@ void dso__delete(struct dso *self);
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dsos__load_kernel(const char *vmlinux, symbol_filter_t filter, int modules);
+int dsos__load_modules(void);
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
@@ -89,6 +90,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_build_id(struct dso *self, void *build_id);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
+int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-- 
1.6.2.5

