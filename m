Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZKXOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZKXOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbZKXOFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:05:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:41344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbZKXOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:05:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf symbols: Symplify symbol machinery setup
Date: Tue, 24 Nov 2009 12:05:15 -0200
Message-Id: <1259071517-3242-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259071517-3242-1-git-send-email-acme@infradead.org>
References: <1259071517-3242-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And also express its configuration toggles via a struct.

Now all one has to do is to call symbol__init(NULL) if the defaults are
OK, or pass a struct symbol_conf pointer with the desired configuration.

If a tool uses kernel_maps__find_symbol to look on the kernel and
modules mappings for a symbol but didn't call symbol__init first, that
will generate a one time warning too, alerting the subcommand developer
that symbol__init() must be called.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |   20 ++++++++++----------
 tools/perf/builtin-kmem.c         |    2 +-
 tools/perf/builtin-report.c       |   15 ++++++++-------
 tools/perf/builtin-sched.c        |    2 +-
 tools/perf/builtin-top.c          |   24 +++++++++++++-----------
 tools/perf/builtin-trace.c        |    2 +-
 tools/perf/util/data_map.c        |    8 --------
 tools/perf/util/data_map.h        |    2 --
 tools/perf/util/header.c          |    6 ------
 tools/perf/util/include/asm/bug.h |   22 ++++++++++++++++++++++
 tools/perf/util/symbol.c          |   31 +++++++++++++++++++++----------
 tools/perf/util/symbol.h          |   11 ++++++++---
 12 files changed, 85 insertions(+), 60 deletions(-)
 create mode 100644 tools/perf/util/include/asm/bug.h

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6b13a1e..45069a4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -33,11 +33,9 @@ static int		input;
 static int		full_paths;
 
 static int		print_line;
-static bool		use_modules;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
-const char		*vmlinux_name;
 
 struct sym_hist {
 	u64		sum;
@@ -55,6 +53,11 @@ struct sym_priv {
 	struct sym_ext	*ext;
 };
 
+static struct symbol_conf symbol_conf = {
+	.priv_size	  = sizeof(struct sym_priv),
+	.try_vmlinux_path = true,
+};
+
 static const char *sym_hist_filter;
 
 static int symbol_filter(struct map *map __used, struct symbol *sym)
@@ -638,11 +641,6 @@ static int __cmd_annotate(void)
 		exit(0);
 	}
 
-	if (kernel_maps__init(vmlinux_name, true, use_modules) < 0) {
-		pr_err("failed to create kernel maps for symbol resolution\b");
-		return -1;
-	}
-
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -743,8 +741,9 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
-	OPT_BOOLEAN('m', "modules", &use_modules,
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('l', "print-line", &print_line,
 		    "print matching source lines (may be slow)"),
@@ -770,7 +769,8 @@ static void setup_sorting(void)
 
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(sizeof(struct sym_priv));
+	if (symbol__init(&symbol_conf) < 0)
+		return -1;
 
 	page_size = getpagesize();
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 256d18f..38b01a9 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -291,7 +291,7 @@ static int read_events(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, NULL, false, 0, 0,
+	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
 				       &cwdlen, &cwd);
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fe474b7..b16f86d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -38,7 +38,6 @@ static char		*dso_list_str, *comm_list_str, *sym_list_str,
 static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
-static bool		use_modules;
 
 static int		full_paths;
 static int		show_nr_samples;
@@ -52,7 +51,6 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
-const char		*vmlinux_name;
 
 static char		*cwd;
 static int		cwdlen;
@@ -61,6 +59,8 @@ static struct perf_header *header;
 
 static u64		sample_type;
 
+struct symbol_conf	symbol_conf;
+
 
 static size_t
 callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -926,8 +926,7 @@ static int __cmd_report(void)
 
 	register_perf_file_handler(&file_handler);
 
-	ret = mmap_dispatch_perf_file(&header, input_name, vmlinux_name,
-				      !vmlinux_name, force,
+	ret = mmap_dispatch_perf_file(&header, input_name, force,
 				      full_paths, &cwdlen, &cwd);
 	if (ret)
 		return ret;
@@ -1024,9 +1023,10 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-	OPT_BOOLEAN('m', "modules", &use_modules,
+	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
 		    "Show a column with the number of samples"),
@@ -1096,7 +1096,8 @@ static void setup_list(struct strlist **list, const char *list_str,
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
+	if (symbol__init(&symbol_conf) < 0)
+		return -1;
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 260f57a..dbf089b 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1718,7 +1718,7 @@ static int read_events(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, NULL, false, 0, 0,
+	return mmap_dispatch_perf_file(&header, input_name, 0, 0,
 				       &cwdlen, &cwd);
 }
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b9a321f..a212475 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -79,7 +79,7 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
-const char 			*vmlinux_name;
+struct symbol_conf		symbol_conf;
 
 /*
  * Source
@@ -128,7 +128,7 @@ struct sym_entry {
 
 static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
 {
-       return ((void *)self) + symbol__priv_size;
+       return ((void *)self) + symbol_conf.priv_size;
 }
 
 static void get_term_dimensions(struct winsize *ws)
@@ -695,7 +695,7 @@ static void print_mapped_keys(void)
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 
-	if (vmlinux_name) {
+	if (symbol_conf.vmlinux_name) {
 		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
 		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 		fprintf(stdout, "\t[S]     stop annotation.\n");
@@ -732,7 +732,7 @@ static int key_mapped(int c)
 		case 'F':
 		case 's':
 		case 'S':
-			return vmlinux_name ? 1 : 0;
+			return symbol_conf.vmlinux_name ? 1 : 0;
 		default:
 			break;
 	}
@@ -1261,7 +1261,8 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
 		    "CPU to profile on"),
-	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &hide_kernel_symbols,
 		    "hide kernel symbols"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
@@ -1295,7 +1296,7 @@ static const struct option options[] = {
 
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
-	int counter, err;
+	int counter;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1313,15 +1314,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	if (!nr_counters)
 		nr_counters = 1;
 
-	symbol__init(sizeof(struct sym_entry) +
-		     (nr_counters + 1) * sizeof(unsigned long));
+	symbol_conf.priv_size = (sizeof(struct sym_entry) +
+				 (nr_counters + 1) * sizeof(unsigned long));
+	if (symbol_conf.vmlinux_name == NULL)
+		symbol_conf.try_vmlinux_path = true;
+	if (symbol__init(&symbol_conf) < 0)
+		return -1;
 
 	if (delay_secs < 1)
 		delay_secs = 1;
 
-	err = kernel_maps__init(vmlinux_name, !vmlinux_name, true);
-	if (err < 0)
-		return err;
 	parse_source(sym_filter_entry);
 
 	/*
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b71198e..75972fd 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -131,7 +131,7 @@ static int __cmd_trace(void)
 	register_idle_thread();
 	register_perf_file_handler(&file_handler);
 
-	return mmap_dispatch_perf_file(&header, input_name, NULL, false,
+	return mmap_dispatch_perf_file(&header, input_name,
 				       0, 0, &cwdlen, &cwd);
 }
 
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index f318d19..b238462 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -101,8 +101,6 @@ out:
 
 int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    const char *input_name,
-			    const char *vmlinux_name,
-			    bool try_vmlinux_path,
 			    int force,
 			    int full_paths,
 			    int *cwdlen,
@@ -172,12 +170,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 	    curr_handler->sample_type_check(sample_type) < 0)
 		goto out_delete;
 
-	err = -ENOMEM;
-	if (kernel_maps__init(vmlinux_name, try_vmlinux_path, true) < 0) {
-		pr_err("failed to setup the kernel maps to resolve symbols\n");
-		goto out_delete;
-	}
-
 	if (!full_paths) {
 		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
 			pr_err("failed to get the current directory\n");
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 3f0d21b..ae036ec 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -23,8 +23,6 @@ struct perf_file_handler {
 void register_perf_file_handler(struct perf_file_handler *handler);
 int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    const char *input_name,
-			    const char *vmlinux_name,
-			    bool try_vmlinux_path,
 			    int force,
 			    int full_paths,
 			    int *cwdlen,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1332f8e..271a160 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -253,12 +253,6 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 
 		buildid_sec = &feat_sec[idx++];
 
-		/*
-		 * Read the kernel buildid nad the list of loaded modules with
-		 * its build_ids:
-		 */
-		kernel_maps__init(NULL, false, true);
-
 		/* Write build-ids */
 		buildid_sec->offset = lseek(fd, 0, SEEK_CUR);
 		err = dsos__write_buildid_table(fd);
diff --git a/tools/perf/util/include/asm/bug.h b/tools/perf/util/include/asm/bug.h
new file mode 100644
index 0000000..7fcc681
--- /dev/null
+++ b/tools/perf/util/include/asm/bug.h
@@ -0,0 +1,22 @@
+#ifndef _PERF_ASM_GENERIC_BUG_H
+#define _PERF_ASM_GENERIC_BUG_H
+
+#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
+
+#define WARN(condition, format...) ({		\
+	int __ret_warn_on = !!(condition);	\
+	if (unlikely(__ret_warn_on))		\
+		__WARN_printf(format);		\
+	unlikely(__ret_warn_on);		\
+})
+
+#define WARN_ONCE(condition, format...)	({	\
+	static int __warned;			\
+	int __ret_warn_once = !!(condition);	\
+						\
+	if (unlikely(__ret_warn_once))		\
+		if (WARN(!__warned, format)) 	\
+			__warned = 1;		\
+	unlikely(__ret_warn_once);		\
+})
+#endif
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 44d81d5..c4ca974 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -6,6 +6,7 @@
 
 #include "debug.h"
 
+#include <asm/bug.h>
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
@@ -37,6 +38,11 @@ unsigned int symbol__priv_size;
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
+static struct symbol_conf symbol_conf__defaults = {
+	.use_modules	  = true,
+	.try_vmlinux_path = true,
+};
+
 static struct rb_root kernel_maps;
 
 static void dso__fixup_sym_end(struct dso *self)
@@ -1166,7 +1172,9 @@ struct symbol *kernel_maps__find_symbol(u64 ip, struct map **mapp,
 	if (map) {
 		ip = map->map_ip(map, ip);
 		return map__find_symbol(map, ip, filter);
-	}
+	} else
+		WARN_ONCE(RB_EMPTY_ROOT(&kernel_maps),
+			  "Empty kernel_maps, was symbol__init() called?\n");
 
 	return NULL;
 }
@@ -1485,9 +1493,9 @@ size_t dsos__fprintf_buildid(FILE *fp)
 	return ret;
 }
 
-static int kernel_maps__create_kernel_map(const char *vmlinux_name)
+static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 {
-	struct dso *kernel = dso__new(vmlinux_name ?: "[kernel.kallsyms]");
+	struct dso *kernel = dso__new(conf->vmlinux_name ?: "[kernel.kallsyms]");
 
 	if (kernel == NULL)
 		return -1;
@@ -1577,18 +1585,21 @@ out_fail:
 	return -1;
 }
 
-int kernel_maps__init(const char *vmlinux_name, bool try_vmlinux_path,
-		      bool use_modules)
+static int kernel_maps__init(const struct symbol_conf *conf)
 {
-	if (try_vmlinux_path && vmlinux_path__init() < 0)
+	const struct symbol_conf *pconf = conf ?: &symbol_conf__defaults;
+
+	symbol__priv_size = pconf->priv_size;
+
+	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (kernel_maps__create_kernel_map(vmlinux_name) < 0) {
+	if (kernel_maps__create_kernel_map(pconf) < 0) {
 		vmlinux_path__exit();
 		return -1;
 	}
 
-	if (use_modules && kernel_maps__create_module_maps() < 0)
+	if (pconf->use_modules && kernel_maps__create_module_maps() < 0)
 		pr_debug("Failed to load list of modules in use, "
 			 "continuing...\n");
 	/*
@@ -1598,8 +1609,8 @@ int kernel_maps__init(const char *vmlinux_name, bool try_vmlinux_path,
 	return 0;
 }
 
-void symbol__init(unsigned int priv_size)
+int symbol__init(struct symbol_conf *conf)
 {
 	elf_version(EV_CURRENT);
-	symbol__priv_size = priv_size;
+	return kernel_maps__init(conf);
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 8c4d026..5538691 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,6 +49,13 @@ struct symbol {
 	char		name[0];
 };
 
+struct symbol_conf {
+	unsigned short	priv_size;
+	bool		try_vmlinux_path,
+			use_modules;
+	const char	*vmlinux_name;
+};
+
 extern unsigned int symbol__priv_size;
 
 static inline void *symbol__priv(struct symbol *self)
@@ -93,11 +100,9 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-int kernel_maps__init(const char *vmlinux_name, bool try_vmlinux_path,
-		      bool use_modules);
 size_t kernel_maps__fprintf(FILE *fp);
 
-void symbol__init(unsigned int priv_size);
+int symbol__init(struct symbol_conf *conf);
 
 extern struct list_head dsos;
 extern struct map *kernel_map;
-- 
1.6.2.5

