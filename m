Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZKTWv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZKTWv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZKTWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:51:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:39209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZKTWvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/6] perf symbols: Remove unrelated actions from dso__load_kernel_sym
Date: Fri, 20 Nov 2009 20:51:24 -0200
Message-Id: <1258757489-5978-1-git-send-email-acme@infradead.org>
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

It should just load kernel symbols, not load the list of modules. There
are more stuff to move to other routines, but lets do it in several
steps.

End goal is to be able to defer symbol table loading till we find a hit
for that map address range. So that the kernel & modules are handled
just like all the other DSOs in the system.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    5 ++-
 tools/perf/builtin-report.c   |    3 +-
 tools/perf/builtin-top.c      |   10 ++++++++-
 tools/perf/util/data_map.c    |    2 +-
 tools/perf/util/symbol.c      |   46 +++++++++++++++++------------------------
 tools/perf/util/symbol.h      |    7 +++--
 6 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 77d50a6..b6da147 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -33,6 +33,7 @@ static int		input;
 static int		full_paths;
 
 static int		print_line;
+static bool		use_modules;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -636,7 +637,7 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (load_kernel(symbol_filter) < 0) {
+	if (load_kernel(symbol_filter, use_modules) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
 	}
@@ -742,7 +743,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
-	OPT_BOOLEAN('m', "modules", &modules,
+	OPT_BOOLEAN('m', "modules", &use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('l', "print-line", &print_line,
 		    "print matching source lines (may be slow)"),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1a806d5..0af4840 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -38,6 +38,7 @@ static char		*dso_list_str, *comm_list_str, *sym_list_str,
 static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
+static bool		use_modules;
 
 static int		full_paths;
 static int		show_nr_samples;
@@ -1023,7 +1024,7 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-	OPT_BOOLEAN('m', "modules", &modules,
+	OPT_BOOLEAN('m', "modules", &use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
 		    "Show a column with the number of samples"),
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6d770ac..48cc108 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -953,8 +953,16 @@ static int parse_symbols(void)
 	if (kernel == NULL)
 		return -1;
 
+	if (dsos__load_modules() < 0)
+		pr_debug("Couldn't read the complete list of modules, "
+			 "continuing...\n");
+
+	if (dsos__load_modules_sym(symbol_filter) < 0)
+		pr_warning("Failed to read module symbols, continuing...\n");
+
 	if (dso__load_kernel_sym(kernel, symbol_filter, 1) <= 0)
-		return -1;
+		pr_debug("Couldn't read the complete list of kernel symbols, "
+			 "continuing...\n");
 
 	if (dump_symtab)
 		dsos__fprintf(stderr);
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 5543e7d..a444a26 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -171,7 +171,7 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		goto out_delete;
 
 	err = -ENOMEM;
-	if (load_kernel(NULL) < 0) {
+	if (load_kernel(NULL, 1) < 0) {
 		pr_err("failed to load kernel symbols\n");
 		goto out_delete;
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4d75e74..3b23c18 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1230,7 +1230,7 @@ failure:
 	return -1;
 }
 
-static int dsos__load_modules_sym(symbol_filter_t filter)
+int dsos__load_modules_sym(symbol_filter_t filter)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1352,33 +1352,18 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter, int use_modules)
+int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter,
+			 int use_modules)
 {
-	int err = -1;
+	int err;
 
 	kernel_map = map__new2(0, self);
 	if (kernel_map == NULL)
-		goto out_delete_dso;
+		return -1;
 
 	kernel_map->map_ip = kernel_map->unmap_ip = identity__map_ip;
 
-	if (use_modules && dsos__load_modules() < 0) {
-		pr_warning("Failed to load list of modules in use! "
-			   "Continuing...\n");
-		use_modules = 0;
-	}
-
 	err = dso__load_vmlinux(self, kernel_map, self->name, filter);
-	if (err > 0 && use_modules) {
-		int syms = dsos__load_modules_sym(filter);
-
-		if (syms < 0)
-			pr_warning("Failed to read module symbols!"
-				   " Continuing...\n");
-		else
-			err += syms;
-	}
-
 	if (err <= 0)
 		err = kernel_maps__load_kallsyms(filter, use_modules);
 
@@ -1404,17 +1389,12 @@ int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter, int use_modul
 	}
 
 	return err;
-
-out_delete_dso:
-	dso__delete(self);
-	return -1;
 }
 
 LIST_HEAD(dsos);
 struct dso	*vdso;
 
 const char	*vmlinux_name = "vmlinux";
-int		modules;
 
 static void dsos__add(struct dso *dso)
 {
@@ -1488,14 +1468,26 @@ struct dso *dsos__load_kernel(void)
 	return kernel;
 }
 
-int load_kernel(symbol_filter_t filter)
+int load_kernel(symbol_filter_t filter, bool use_modules)
 {
 	struct dso *kernel = dsos__load_kernel();
 
 	if (kernel == NULL)
 		return -1;
 
-	return dso__load_kernel_sym(kernel, filter, modules);
+	if (use_modules) {
+		if (dsos__load_modules() < 0)
+			pr_warning("Failed to load list of modules in use, "
+				   "continuing...\n");
+		else if (dsos__load_modules_sym(filter) < 0)
+			pr_warning("Failed to read module symbols, "
+				   "continuing...\n");
+	}
+
+	if (dso__load_kernel_sym(kernel, filter, use_modules) < 0)
+		pr_warning("Failed to read kernel symbols, continuing...\n");
+
+	return 0;
 }
 
 void symbol__init(unsigned int priv_size)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f0593a6..3d9d346 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -78,9 +78,11 @@ void dso__delete(struct dso *self);
 struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dsos__load_modules(void);
+int dsos__load_modules_sym(symbol_filter_t filter);
 struct dso *dsos__findnew(const char *name);
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
-int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter, int modules);
+int dso__load_kernel_sym(struct dso *self, symbol_filter_t filter,
+			 int use_modules);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp);
 
@@ -95,7 +97,7 @@ bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
 struct dso *dsos__load_kernel(void);
-int load_kernel(symbol_filter_t filter);
+int load_kernel(symbol_filter_t filter, bool use_modules);
 
 void symbol__init(unsigned int priv_size);
 
@@ -103,5 +105,4 @@ extern struct list_head dsos;
 extern struct map *kernel_map;
 extern struct dso *vdso;
 extern const char *vmlinux_name;
-extern int   modules;
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

