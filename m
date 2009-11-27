Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZK0S3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZK0S3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZK0S3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZK0S3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 03/12] perf symbols: Split the dsos list into kernel and user parts
Date: Fri, 27 Nov 2009 16:29:14 -0200
Message-Id: <1259346563-12568-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259346563-12568-2-git-send-email-acme@infradead.org>
References: <1259346563-12568-1-git-send-email-acme@infradead.org>
 <1259346563-12568-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We don't need to look at modules in dsos__findnew because the kernel
events come only with user DSOs. Also we need a way to list just the
module DSOs so that we can create multiple sets of maps, now that we
will support maps for the variables in a symtab.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   12 ++++++++-
 tools/perf/util/symbol.c |   56 ++++++++++++++++++++++++++++++---------------
 tools/perf/util/symbol.h |    2 +-
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4b58656..4805e6d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -185,11 +185,11 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
-static int dsos__write_buildid_table(int fd)
+static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
 	struct dso *pos;
 
-	list_for_each_entry(pos, &dsos, node) {
+	list_for_each_entry(pos, head, node) {
 		int err;
 		struct build_id_event b;
 		size_t len;
@@ -212,6 +212,14 @@ static int dsos__write_buildid_table(int fd)
 	return 0;
 }
 
+static int dsos__write_buildid_table(int fd)
+{
+	int err = __dsos__write_buildid_table(&dsos__kernel, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&dsos__user, fd);
+	return err;
+}
+
 static int perf_header__adds_write(struct perf_header *self, int fd)
 {
 	int nr_sections;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 687fb7f..dc25231 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -28,8 +28,7 @@ enum dso_origin {
 	DSO__ORIG_NOT_FOUND,
 };
 
-static void dsos__add(struct dso *dso);
-static struct dso *dsos__find(const char *name);
+static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso);
 static void kernel_maps__insert(struct map *map);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
@@ -855,7 +854,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
 				kernel_maps__insert(curr_map);
-				dsos__add(curr_dso);
+				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
 
@@ -907,12 +906,12 @@ static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
 	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
 }
 
-bool dsos__read_build_ids(void)
+static bool __dsos__read_build_ids(struct list_head *head)
 {
 	bool have_build_id = false;
 	struct dso *pos;
 
-	list_for_each_entry(pos, &dsos, node)
+	list_for_each_entry(pos, head, node)
 		if (filename__read_build_id(pos->long_name, pos->build_id,
 					    sizeof(pos->build_id)) > 0) {
 			have_build_id	  = true;
@@ -922,6 +921,12 @@ bool dsos__read_build_ids(void)
 	return have_build_id;
 }
 
+bool dsos__read_build_ids(void)
+{
+	return __dsos__read_build_ids(&dsos__kernel) ||
+	       __dsos__read_build_ids(&dsos__user);
+}
+
 /*
  * Align offset to 4 bytes as needed for note name and descriptor data.
  */
@@ -1343,7 +1348,7 @@ static int kernel_maps__create_module_maps(void)
 
 		dso->origin = DSO__ORIG_KMODULE;
 		kernel_maps__insert(map);
-		dsos__add(dso);
+		dsos__add(&dsos__kernel, dso);
 	}
 
 	free(line);
@@ -1445,19 +1450,20 @@ out_fixup:
 	return err;
 }
 
-LIST_HEAD(dsos);
+LIST_HEAD(dsos__user);
+LIST_HEAD(dsos__kernel);
 struct dso *vdso;
 
-static void dsos__add(struct dso *dso)
+static void dsos__add(struct list_head *head, struct dso *dso)
 {
-	list_add_tail(&dso->node, &dsos);
+	list_add_tail(&dso->node, head);
 }
 
-static struct dso *dsos__find(const char *name)
+static struct dso *dsos__find(struct list_head *head, const char *name)
 {
 	struct dso *pos;
 
-	list_for_each_entry(pos, &dsos, node)
+	list_for_each_entry(pos, head, node)
 		if (strcmp(pos->name, name) == 0)
 			return pos;
 	return NULL;
@@ -1465,12 +1471,12 @@ static struct dso *dsos__find(const char *name)
 
 struct dso *dsos__findnew(const char *name)
 {
-	struct dso *dso = dsos__find(name);
+	struct dso *dso = dsos__find(&dsos__user, name);
 
 	if (!dso) {
 		dso = dso__new(name);
 		if (dso != NULL) {
-			dsos__add(dso);
+			dsos__add(&dsos__user, dso);
 			dso__set_basename(dso);
 		}
 	}
@@ -1478,26 +1484,38 @@ struct dso *dsos__findnew(const char *name)
 	return dso;
 }
 
-void dsos__fprintf(FILE *fp)
+static void __dsos__fprintf(struct list_head *head, FILE *fp)
 {
 	struct dso *pos;
 
-	list_for_each_entry(pos, &dsos, node)
+	list_for_each_entry(pos, head, node)
 		dso__fprintf(pos, fp);
 }
 
-size_t dsos__fprintf_buildid(FILE *fp)
+void dsos__fprintf(FILE *fp)
+{
+	__dsos__fprintf(&dsos__kernel, fp);
+	__dsos__fprintf(&dsos__user, fp);
+}
+
+static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp)
 {
 	struct dso *pos;
 	size_t ret = 0;
 
-	list_for_each_entry(pos, &dsos, node) {
+	list_for_each_entry(pos, head, node) {
 		ret += dso__fprintf_buildid(pos, fp);
 		ret += fprintf(fp, " %s\n", pos->long_name);
 	}
 	return ret;
 }
 
+size_t dsos__fprintf_buildid(FILE *fp)
+{
+	return (__dsos__fprintf_buildid(&dsos__kernel, fp) +
+		__dsos__fprintf_buildid(&dsos__user, fp));
+}
+
 static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 {
 	struct dso *kernel = dso__new(conf->vmlinux_name ?: "[kernel.kallsyms]");
@@ -1523,8 +1541,8 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 		kernel->has_build_id = true;
 
 	kernel_maps__insert(kernel_map__functions);
-	dsos__add(kernel);
-	dsos__add(vdso);
+	dsos__add(&dsos__kernel, kernel);
+	dsos__add(&dsos__user, vdso);
 
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b42d196..5d0371f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -104,7 +104,7 @@ size_t kernel_maps__fprintf(FILE *fp);
 
 int symbol__init(struct symbol_conf *conf);
 
-extern struct list_head dsos;
+extern struct list_head dsos__user, dsos__kernel;
 extern struct map *kernel_map__functions;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

