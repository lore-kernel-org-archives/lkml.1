Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZLOP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZLOP7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZLOP6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:58:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:51633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbZLOP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:58:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf symbols: Adopt the strlists for dso, comm,
Date: Tue, 15 Dec 2009 13:58:36 -0200
Message-Id: <1260892717-20841-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260892717-20841-1-git-send-email-acme@infradead.org>
References: <1260892717-20841-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in perf diff too.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |    4 +-
 tools/perf/builtin-diff.c      |    9 ++---
 tools/perf/builtin-kmem.c      |    4 +-
 tools/perf/builtin-record.c    |    6 ++--
 tools/perf/builtin-report.c    |   73 +++++++++++++++++----------------------
 tools/perf/builtin-timechart.c |    4 +-
 tools/perf/builtin-trace.c     |    4 +-
 tools/perf/util/symbol.c       |   33 ++++++++++++++++++
 tools/perf/util/symbol.h       |    9 +++++
 9 files changed, 89 insertions(+), 57 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e656e25..645d580 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -518,14 +518,14 @@ static const struct option options[] = {
 
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
+	argc = parse_options(argc, argv, options, annotate_usage, 0);
+
 	symbol_conf.priv_size = sizeof(struct sym_priv);
 	symbol_conf.try_vmlinux_path = true;
 
 	if (symbol__init() < 0)
 		return -1;
 
-	argc = parse_options(argc, argv, options, annotate_usage, 0);
-
 	setup_sorting(annotate_usage, options);
 
 	if (argc) {
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 67328d1..4fde606 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -265,11 +265,6 @@ static const struct option options[] = {
 
 int cmd_diff(int argc, const char **argv, const char *prefix __used)
 {
-	if (symbol__init() < 0)
-		return -1;
-
-	setup_sorting(diff_usage, options);
-
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 	if (argc) {
 		if (argc > 2)
@@ -281,6 +276,10 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
 			input_new = argv[0];
 	}
 
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_sorting(diff_usage, options);
 	setup_pager();
 	return __cmd_diff();
 }
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index e078797..fc21ad7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -766,13 +766,13 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
-
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
+	symbol__init();
+
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1da48a8..65301c5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -632,13 +632,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
-	symbol__init();
-
 	argc = parse_options(argc, argv, options, record_usage,
-		PARSE_OPT_STOP_AT_NON_OPTION);
+			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
+	symbol__init();
+
 	if (!nr_counters) {
 		nr_counters	= 1;
 		attrs[0].type	= PERF_TYPE_HARDWARE;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c349bdb..03afac3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,10 +33,6 @@
 
 static char		const *input_name = "perf.data";
 
-static char		*dso_list_str, *comm_list_str, *sym_list_str,
-			*col_width_list_str;
-static struct strlist	*dso_list, *comm_list, *sym_list;
-
 static int		force;
 static bool		use_callchain;
 
@@ -365,8 +361,9 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 
 static void dso__calc_col_width(struct dso *self)
 {
-	if (!col_width_list_str && !field_sep &&
-	    (!dso_list || strlist__has_entry(dso_list, self->name))) {
+	if (!symbol_conf.col_width_list_str && !field_sep &&
+	    (!symbol_conf.dso_list ||
+	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
 		unsigned int slen = strlen(self->name);
 		if (slen > dsos__col_width)
 			dsos__col_width = slen;
@@ -379,8 +376,9 @@ static void thread__comm_adjust(struct thread *self)
 {
 	char *comm = self->comm;
 
-	if (!col_width_list_str && !field_sep &&
-	    (!comm_list || strlist__has_entry(comm_list, comm))) {
+	if (!symbol_conf.col_width_list_str && !field_sep &&
+	    (!symbol_conf.comm_list ||
+	     strlist__has_entry(symbol_conf.comm_list, comm))) {
 		unsigned int slen = strlen(comm);
 
 		if (slen > comms__col_width) {
@@ -442,7 +440,7 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 	struct rb_node *nd;
 	size_t ret = 0;
 	unsigned int width;
-	char *col_width = col_width_list_str;
+	char *col_width = symbol_conf.col_width_list_str;
 	int raw_printing_style;
 
 	raw_printing_style = !strcmp(pretty_printing_style, "raw");
@@ -468,7 +466,7 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 		}
 		width = strlen(se->header);
 		if (se->width) {
-			if (col_width_list_str) {
+			if (symbol_conf.col_width_list_str) {
 				if (col_width) {
 					*se->width = atoi(col_width);
 					col_width = strchr(col_width, ',');
@@ -587,7 +585,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
+	if (symbol_conf.comm_list &&
+	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
 		return 0;
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -601,14 +600,15 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (al.map && !sort_dso.elide && !al.map->dso->slen_calculated)
 		dso__calc_col_width(al.map->dso);
 
-	if (dso_list &&
+	if (symbol_conf.dso_list &&
 	    (!al.map || !al.map->dso ||
-	     !(strlist__has_entry(dso_list, al.map->dso->short_name) ||
+	     !(strlist__has_entry(symbol_conf.dso_list, al.map->dso->short_name) ||
 	       (al.map->dso->short_name != al.map->dso->long_name &&
-		strlist__has_entry(dso_list, al.map->dso->long_name)))))
+		strlist__has_entry(symbol_conf.dso_list, al.map->dso->long_name)))))
 		return 0;
 
-	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
+	if (symbol_conf.sym_list && al.sym &&
+	    !strlist__has_entry(symbol_conf.sym_list, al.sym->name))
 		return 0;
 
 	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
@@ -825,13 +825,13 @@ static const struct option options[] = {
 	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
 		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
-	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
+	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only consider symbols in these comms"),
-	OPT_STRING('S', "symbols", &sym_list_str, "symbol[,symbol...]",
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
-	OPT_STRING('w', "column-widths", &col_width_list_str,
+	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
 		   "width[,width...]",
 		   "don't try to adjust column width, use these fixed values"),
 	OPT_STRING('t', "field-separator", &field_sep, "separator",
@@ -840,32 +840,25 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void setup_list(struct strlist **list, const char *list_str,
-		       struct sort_entry *se, const char *list_name,
-		       FILE *fp)
+static void sort_entry__setup_elide(struct sort_entry *self,
+				    struct strlist *list,
+				    const char *list_name, FILE *fp)
 {
-	if (list_str) {
-		*list = strlist__new(true, list_str);
-		if (!*list) {
-			fprintf(stderr, "problems parsing %s list\n",
-				list_name);
-			exit(129);
-		}
-		if (strlist__nr_entries(*list) == 1) {
-			fprintf(fp, "# %s: %s\n", list_name,
-				strlist__entry(*list, 0)->s);
-			se->elide = true;
-		}
+	if (list && strlist__nr_entries(list) == 1) {
+		fprintf(fp, "# %s: %s\n", list_name, strlist__entry(list, 0)->s);
+		self->elide = true;
 	}
 }
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
+	argc = parse_options(argc, argv, options, report_usage, 0);
+
+	setup_pager();
+
 	if (symbol__init() < 0)
 		return -1;
 
-	argc = parse_options(argc, argv, options, report_usage, 0);
-
 	setup_sorting(report_usage, options);
 
 	if (parent_pattern != default_parent_pattern) {
@@ -880,11 +873,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(report_usage, options);
 
-	setup_pager();
-
-	setup_list(&dso_list, dso_list_str, &sort_dso, "dso", stdout);
-	setup_list(&comm_list, comm_list_str, &sort_comm, "comm", stdout);
-	setup_list(&sym_list, sym_list_str, &sort_sym, "symbol", stdout);
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
 	if (field_sep && *field_sep == '.') {
 		fputs("'.' is the only non valid --field-separator argument\n",
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9c98b7a..a589a43 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1137,11 +1137,11 @@ static const struct option options[] = {
 
 int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init();
-
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
+	symbol__init();
+
 	if (argc && !strncmp(argv[0], "rec", 3))
 		return __cmd_record(argc, argv);
 	else if (argc)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 07ad25c..e2285e2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -579,13 +579,13 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		exit(-1);
 	}
 
-	symbol__init();
-
 	setup_scripting();
 
 	argc = parse_options(argc, argv, options, annotate_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (symbol__init() < 0)
+		return -1;
 	setup_pager();
 
 	session = perf_session__new(input_name, O_RDONLY, 0);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 17ce012..164286a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,6 +1,7 @@
 #include "util.h"
 #include "../perf.h"
 #include "session.h"
+#include "sort.h"
 #include "string.h"
 #include "symbol.h"
 #include "thread.h"
@@ -1739,6 +1740,20 @@ out_fail:
 	return -1;
 }
 
+static int setup_list(struct strlist **list, const char *list_str,
+		      const char *list_name)
+{
+	if (list_str == NULL)
+		return 0;
+
+	*list = strlist__new(true, list_str);
+	if (!*list) {
+		pr_err("problems parsing %s list\n", list_name);
+		return -1;
+	}
+	return 0;
+}
+
 int symbol__init(void)
 {
 	elf_version(EV_CURRENT);
@@ -1749,7 +1764,25 @@ int symbol__init(void)
 	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
+	if (setup_list(&symbol_conf.dso_list,
+		       symbol_conf.dso_list_str, "dso") < 0)
+		return -1;
+
+	if (setup_list(&symbol_conf.comm_list,
+		       symbol_conf.comm_list_str, "comm") < 0)
+		goto out_free_dso_list;
+
+	if (setup_list(&symbol_conf.sym_list,
+		       symbol_conf.sym_list_str, "symbol") < 0)
+		goto out_free_comm_list;
+
 	return 0;
+
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
+out_free_comm_list:
+	strlist__delete(symbol_conf.comm_list);
+	return -1;
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 7662947..d61f350 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,12 +49,21 @@ struct symbol {
 	char		name[0];
 };
 
+struct strlist;
+
 struct symbol_conf {
 	unsigned short	priv_size;
 	bool		try_vmlinux_path,
 			use_modules,
 			sort_by_name;
 	const char	*vmlinux_name;
+	char            *dso_list_str,
+			*comm_list_str,
+			*sym_list_str,
+			*col_width_list_str;
+       struct strlist	*dso_list,
+			*comm_list,
+			*sym_list;
 };
 
 extern struct symbol_conf symbol_conf;
-- 
1.6.2.5

