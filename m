Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbZHFT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbZHFT7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZHFT7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:59:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52880 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbZHFT7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:59:34 -0400
Date: Thu, 6 Aug 2009 21:59:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
Message-ID: <20090806195924.GA22411@elte.hu>
References: <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7B28EA.20903@inria.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> $ /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf report -D |
> grep _READ | sort -k5
> 0x8bb8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000001e0 494628
> 0x8fc0 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000002e0 209113
> 0x9698 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000004e0 307215
> 0x9cf8 [0x30]: PERF_EVENT_READ: 6268 6268 raw 0x1000008e0 9203221
> 0x8a08 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000001e0 9210788
> 0x9020 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000002e0 302344
> 0x9608 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000004e0 198705
> 0x9d28 [0x30]: PERF_EVENT_READ: 6268 6269 raw 0x1000008e0 473471
> [...]
> 
> Now I know which thread actually reads from where.
> Looks like we're good to go now! thanks a lot Peter!
> 
> Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

Thanks Brice.

It would be nice to add this as some "perf report -s/--stats" flag, 
to not have to go via -D (which is a 'print debug output' kind of 
ad-hoc thing and subject to format changes in the future).

Would you be interested in sending a patch that adds that flag to 
'perf report', to print out these statistics entries (if any), in a 
tabular form suitable for your purposes? Below is a past patch to 
builtin-report.c that shows how to add new options.

	Ingo

-------------------->
>From 429764873cf3fc3e73142872a674bb27cda589c1 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Thu, 2 Jul 2009 08:09:46 +0200
Subject: [PATCH] perf_counter tools: Enable kernel module symbol loading in tools

Add the -m/--modules option to perf report and perf annotate,
which enables live module symbol/image loading. To be used
with -k/--vmlinux.

(Also give perf annotate a -P/--full-paths option.)

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246514986.13293.48.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |   25 ++++++++++++++++++++-----
 tools/perf/builtin-report.c   |    9 ++++++++-
 tools/perf/builtin-top.c      |   12 ++++++++++--
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 8820568..08ea6c5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
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
@@ -1268,19 +1272,25 @@ static void print_summary(char *filename)
 
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
@@ -1291,13 +1301,14 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
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
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 38d136f..b44476c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
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
@@ -648,6 +650,9 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
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
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9bb25fc..aa044ea 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
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
@@ -709,6 +715,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
+	symbol__init();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	argc = parse_options(argc, argv, options, top_usage, 0);
