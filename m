Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbZGBGJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbZGBGJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZGBGJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:09:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:41681 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751425AbZGBGJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:09:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18a+e8NRrUaYQhxwbufvane/Z8Ik3A0VXTcUvFjRH
	39Yp/giM3czVjB
Subject: [patch 4/4] perf_counter tools: Enable kernel module symbol
 loading in tools
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1246514639.13293.40.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:09:46 +0200
Message-Id: <1246514986.13293.48.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: Enable kernel module symbol loading in tools.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-annotate.c |   25 ++++++++++++++++++++-----
 tools/perf/builtin-report.c   |    9 ++++++++-
 tools/perf/builtin-top.c      |   12 ++++++++++--
 3 files changed, 38 insertions(+), 8 deletions(-)

Index: linux-2.6/tools/perf/builtin-annotate.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-annotate.c
+++ linux-2.6/tools/perf/builtin-annotate.c
@@ -43,6 +43,10 @@ static int		dump_trace = 0;
 
 static int		verbose;
 
+static int		modules;
+
+static int		full_paths;
+
 static int		print_line;
 
 static unsigned long	page_size;
@@ -171,7 +175,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
@@ -1268,19 +1272,25 @@ static void print_summary(char *filename
 
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
-	char *filename = dso->name;
+	char *filename = dso->name, *d_filename;
 	u64 start, end, len;
 	char command[PATH_MAX*2];
 	FILE *file;
 
 	if (!filename)
 		return;
-	if (dso == kernel_dso)
+	if (sym->module)
+		filename = sym->module->path;
+	else if (dso == kernel_dso)
 		filename = vmlinux;
 
 	start = sym->obj_start;
 	if (!start)
 		start = sym->start;
+	if (full_paths)
+		d_filename = filename;
+	else
+		d_filename = basename(filename);
 
 	end = start + sym->end - sym->start + 1;
 	len = sym->end - sym->start;
@@ -1291,13 +1301,14 @@ static void annotate_sym(struct dso *dso
 	}
 
 	printf("\n\n------------------------------------------------\n");
-	printf(" Percent |	Source code & Disassembly of %s\n", filename);
+	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
 	if (verbose >= 2)
 		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
 
-	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (u64)start, (u64)end, filename);
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
+			(u64)start, (u64)end, filename, filename);
 
 	if (verbose >= 3)
 		printf("doing: %s\n", command);
@@ -1472,8 +1483,12 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('l', "print-line", &print_line,
 		    "print matching source lines (may be slow)"),
+	OPT_BOOLEAN('P', "full-paths", &full_paths,
+		    "Don't shorten the displayed pathnames"),
 	OPT_END()
 };
 
Index: linux-2.6/tools/perf/builtin-report.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-report.c
+++ linux-2.6/tools/perf/builtin-report.c
@@ -46,6 +46,8 @@ static int		dump_trace = 0;
 static int		verbose;
 #define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
 
+static int		modules;
+
 static int		full_paths;
 
 static unsigned long	page_size;
@@ -188,7 +190,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, 0);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
 	if (err <= 0) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
@@ -648,6 +650,9 @@ sort__sym_print(FILE *fp, struct hist_en
 		ret += fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' :
 			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
+
+		if (self->sym->module)
+			ret += fprintf(fp, "\t[%s]", self->sym->module->name);
 	} else {
 		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
@@ -1710,6 +1715,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_BOOLEAN('m', "modules", &modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -66,6 +66,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			freq				=  0;
 static int			verbose				=  0;
+static char			*vmlinux			=  NULL;
 
 static char			*sym_filter;
 static unsigned long		filter_start;
@@ -265,7 +266,10 @@ static void print_sym_table(void)
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
 		color_fprintf(stdout, color, "%4.1f%%", pcnt);
-		printf(" - %016llx : %s\n", sym->start, sym->name);
+		printf(" - %016llx : %s", sym->start, sym->name);
+		if (sym->module)
+			printf("\t[%s]", sym->module->name);
+		printf("\n");
 	}
 }
 
@@ -359,12 +363,13 @@ static int parse_symbols(void)
 {
 	struct rb_node *node;
 	struct symbol  *sym;
+	int modules = vmlinux ? 1 : 0;
 
 	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, NULL, symbol_filter, 1, 0) <= 0)
+	if (dso__load_kernel(kernel_dso, vmlinux, symbol_filter, verbose, modules) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
@@ -680,6 +685,7 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
 		    "CPU to profile on"),
+	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
@@ -709,6 +715,8 @@ int cmd_top(int argc, const char **argv,
 {
 	int counter;
 
+	symbol__init();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	argc = parse_options(argc, argv, options, top_usage, 0);


