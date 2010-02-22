Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0BVSQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:16:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:54820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0BVSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:16:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf symbols: Improve debugging information about symtab origins
Date: Mon, 22 Feb 2010 16:15:39 -0300
Message-Id: <1266866139-6361-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Be more clear about DSO long names and tell from which file kernel symbols were
obtained, all in --verbose mode:

    [root@mica ~]# perf report -v > /dev/null
    Looking at the vmlinux_path (5 entries long)
    Using /lib/modules/2.6.33-rc8-tip-00777-g0918527-dirty/build/vmlinux for symbols
    [root@mica ~]# mv /lib/modules/2.6.33-rc8-tip-00777-g0918527-dirty/build/vmlinux /tmp/dd
    [root@mica ~]# perf report -v > /dev/null
    Looking at the vmlinux_path (5 entries long)
    Using /proc/kallsyms for symbols
    [root@mica ~]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c    |    5 +++++
 tools/perf/util/map.h    |    2 ++
 tools/perf/util/symbol.c |   16 ++++++++++++++--
 tools/perf/util/thread.c |    5 -----
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 138e3cb..e509cd5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -5,6 +5,11 @@
 #include <stdio.h>
 #include "debug.h"
 
+const char *map_type__name[MAP__NR_TYPES] = {
+	[MAP__FUNCTION] = "Functions",
+	[MAP__VARIABLE] = "Variables",
+};
+
 static inline int is_anon_memory(const char *filename)
 {
 	return strcmp(filename, "//anon") == 0;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 86f77cb..b756368 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -13,6 +13,8 @@ enum map_type {
 
 #define MAP__NR_TYPES (MAP__VARIABLE + 1)
 
+extern const char *map_type__name[MAP__NR_TYPES];
+
 struct dso;
 struct ref_reloc_sym;
 struct map_groups;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ee9c37e..a3cfdd9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -367,6 +367,10 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 	struct rb_node *nd;
 	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
 
+	if (self->short_name != self->long_name)
+		ret += fprintf(fp, "%s, ", self->long_name);
+	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
+		       self->loaded ? "" : "NOT ");
 	ret += dso__fprintf_buildid(self, fp);
 	ret += fprintf(fp, ")\n");
 	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
@@ -1580,6 +1584,9 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	err = dso__load_sym(self, map, vmlinux, fd, filter, 0);
 	close(fd);
 
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", vmlinux);
+
 	return err;
 }
 
@@ -1594,7 +1601,6 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
 		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
 		if (err > 0) {
-			pr_debug("Using %s for symbols\n", vmlinux_path[i]);
 			dso__set_long_name(self, strdup(vmlinux_path[i]));
 			break;
 		}
@@ -1661,12 +1667,16 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 
 		if (asprintf(&kallsyms_allocated_filename,
 			     "%s/.debug/[kernel.kallsyms]/%s",
-			     getenv("HOME"), sbuild_id) == -1)
+			     getenv("HOME"), sbuild_id) == -1) {
+			pr_err("Not enough memory for kallsyms file lookup\n");
 			return -1;
+		}
 
 		kallsyms_filename = kallsyms_allocated_filename;
 
 		if (access(kallsyms_filename, F_OK)) {
+			pr_err("No kallsyms or vmlinux with build-id %s "
+			       "was found\n", sbuild_id);
 			free(kallsyms_allocated_filename);
 			return -1;
 		}
@@ -1680,6 +1690,8 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 
 do_kallsyms:
 	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
 
 out_try_fixup:
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9e8995e..c090654 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -53,11 +53,6 @@ int thread__comm_len(struct thread *self)
 	return self->comm_len;
 }
 
-static const char *map_type__name[MAP__NR_TYPES] = {
-	[MAP__FUNCTION] = "Functions",
-	[MAP__VARIABLE] = "Variables",
-};
-
 static size_t __map_groups__fprintf_maps(struct map_groups *self,
 					 enum map_type type, FILE *fp)
 {
-- 
1.5.5.1

