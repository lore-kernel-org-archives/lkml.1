Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZLOP6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZLOP6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZLOP6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:58:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:51632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZLOP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:58:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf symbols: Move symbol filtering to event__preprocess_sample
Date: Tue, 15 Dec 2009 13:58:37 -0200
Message-Id: <1260892717-20841-3-git-send-email-acme@infradead.org>
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

So that --dsos, --comm, --symbols can bem used in more tools, like in
perf diff:

$ perf record -f find / > /dev/null
$ perf record -f find / > /dev/null
$ perf diff --dsos /lib64/libc-2.10.1.so | head -5
   1        +22392124     /lib64/libc-2.10.1.so   _IO_vfprintf_internal
   2         +6410655     /lib64/libc-2.10.1.so   __GI_memmove
   3    +1   +9192692     /lib64/libc-2.10.1.so   _int_malloc
   4    -1  -15158605     /lib64/libc-2.10.1.so   _int_free
   5           +45669     /lib64/libc-2.10.1.so   _IO_new_file_xsputn
$

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |   19 ++++++++-
 tools/perf/builtin-report.c   |   86 ++++++++---------------------------------
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/event.c       |   42 ++++++++++++++++++++
 tools/perf/util/symbol.c      |    5 ++
 tools/perf/util/symbol.h      |    4 +-
 7 files changed, 84 insertions(+), 76 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 645d580..593ff25 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -141,7 +141,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (perf_session__add_hist_entry(session, &al, 1)) {
+	if (!al.filtered && perf_session__add_hist_entry(session, &al, 1)) {
 		fprintf(stderr, "problem incrementing symbol count, "
 				"skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4fde606..ff91e9c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -50,6 +50,9 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 		return -1;
 	}
 
+	if (al.filtered)
+		return 0;
+
 	event__parse_sample(event, session->sample_type, &data);
 
 	if (al.sym && perf_session__add_hist_entry(session, &al, data.period)) {
@@ -182,10 +185,14 @@ blank:		memset(displacement, ' ', sizeof(displacement));
 	printed = fprintf(fp, "%4lu %5.5s ", pos, displacement);
 
 	if (show_percent) {
-		double old_percent = (old_count * 100) / pair_session->events_stats.total,
-		       new_percent = (self->count * 100) / session->events_stats.total;
-		double diff = old_percent - new_percent;
+		double old_percent = 0, new_percent = 0, diff;
+
+		if (pair_session->events_stats.total > 0)
+			old_percent = (old_count * 100) / pair_session->events_stats.total;
+		if (session->events_stats.total > 0)
+			new_percent = (self->count * 100) / session->events_stats.total;
 
+		diff = old_percent - new_percent;
 		if (verbose)
 			printed += fprintf(fp, " %3.2f%% %3.2f%%", old_percent, new_percent);
 
@@ -260,6 +267,12 @@ static const struct option options[] = {
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 03afac3..9c59534 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -316,14 +316,14 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 
 	if (total_samples)
 		ret = percent_color_fprintf(fp,
-					    field_sep ? "%.2f" : "   %6.2f%%",
+					    symbol_conf.field_sep ? "%.2f" : "   %6.2f%%",
 					(self->count * 100.0) / total_samples);
 	else
-		ret = fprintf(fp, field_sep ? "%lld" : "%12lld ", self->count);
+		ret = fprintf(fp, symbol_conf.field_sep ? "%lld" : "%12lld ", self->count);
 
 	if (show_nr_samples) {
-		if (field_sep)
-			fprintf(fp, "%c%lld", *field_sep, self->count);
+		if (symbol_conf.field_sep)
+			fprintf(fp, "%c%lld", *symbol_conf.field_sep, self->count);
 		else
 			fprintf(fp, "%11lld", self->count);
 	}
@@ -332,7 +332,7 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 		if (se->elide)
 			continue;
 
-		fprintf(fp, "%s", field_sep ?: "  ");
+		fprintf(fp, "%s", symbol_conf.field_sep ?: "  ");
 		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
@@ -355,28 +355,11 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-/*
- *
- */
-
-static void dso__calc_col_width(struct dso *self)
-{
-	if (!symbol_conf.col_width_list_str && !field_sep &&
-	    (!symbol_conf.dso_list ||
-	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
-		unsigned int slen = strlen(self->name);
-		if (slen > dsos__col_width)
-			dsos__col_width = slen;
-	}
-
-	self->slen_calculated = 1;
-}
-
 static void thread__comm_adjust(struct thread *self)
 {
 	char *comm = self->comm;
 
-	if (!symbol_conf.col_width_list_str && !field_sep &&
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 	    (!symbol_conf.comm_list ||
 	     strlist__has_entry(symbol_conf.comm_list, comm))) {
 		unsigned int slen = strlen(comm);
@@ -452,16 +435,16 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 
 	fprintf(fp, "# Overhead");
 	if (show_nr_samples) {
-		if (field_sep)
-			fprintf(fp, "%cSamples", *field_sep);
+		if (symbol_conf.field_sep)
+			fprintf(fp, "%cSamples", *symbol_conf.field_sep);
 		else
 			fputs("  Samples  ", fp);
 	}
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
-		if (field_sep) {
-			fprintf(fp, "%c%s", *field_sep, se->header);
+		if (symbol_conf.field_sep) {
+			fprintf(fp, "%c%s", *symbol_conf.field_sep, se->header);
 			continue;
 		}
 		width = strlen(se->header);
@@ -480,7 +463,7 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 	}
 	fprintf(fp, "\n");
 
-	if (field_sep)
+	if (symbol_conf.field_sep)
 		goto print_entries;
 
 	fprintf(fp, "# ........");
@@ -542,13 +525,8 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
-	struct sample_data data;
-	int cpumode;
+	struct sample_data data = { .period = 1, };
 	struct addr_location al;
-	struct thread *thread;
-
-	memset(&data, 0, sizeof(data));
-	data.period = 1;
 
 	event__parse_sample(event, session->sample_type, &data);
 
@@ -576,39 +554,13 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		}
 	}
 
-	thread = perf_session__findnew(session, data.pid);
-	if (thread == NULL) {
-		pr_debug("problem processing %d event, skipping it.\n",
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
-	if (symbol_conf.comm_list &&
-	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
-		return 0;
-
-	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	thread__find_addr_location(thread, session, cpumode,
-				   MAP__FUNCTION, data.ip, &al, NULL);
-	/*
-	 * We have to do this here as we may have a dso with no symbol hit that
-	 * has a name longer than the ones with symbols sampled.
-	 */
-	if (al.map && !sort_dso.elide && !al.map->dso->slen_calculated)
-		dso__calc_col_width(al.map->dso);
-
-	if (symbol_conf.dso_list &&
-	    (!al.map || !al.map->dso ||
-	     !(strlist__has_entry(symbol_conf.dso_list, al.map->dso->short_name) ||
-	       (al.map->dso->short_name != al.map->dso->long_name &&
-		strlist__has_entry(symbol_conf.dso_list, al.map->dso->long_name)))))
-		return 0;
-
-	if (symbol_conf.sym_list && al.sym &&
-	    !strlist__has_entry(symbol_conf.sym_list, al.sym->name))
+	if (al.filtered)
 		return 0;
 
 	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
@@ -834,7 +786,7 @@ static const struct option options[] = {
 	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
 		   "width[,width...]",
 		   "don't try to adjust column width, use these fixed values"),
-	OPT_STRING('t', "field-separator", &field_sep, "separator",
+	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
 	OPT_END()
@@ -877,11 +829,5 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
-	if (field_sep && *field_sep == '.') {
-		fputs("'.' is the only non valid --field-separator argument\n",
-		      stderr);
-		exit(129);
-	}
-
 	return __cmd_report();
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cd89b6d..ddc584b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -948,7 +948,7 @@ static void event__process_sample(const event_t *self,
 	}
 
 	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
-	    al.sym == NULL)
+	    al.sym == NULL || al.filtered)
 		return;
 
 	syme = symbol__priv(al.sym);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 375fb6d..bf491fd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -2,7 +2,9 @@
 #include "event.h"
 #include "debug.h"
 #include "session.h"
+#include "sort.h"
 #include "string.h"
+#include "strlist.h"
 #include "thread.h"
 
 static pid_t event__synthesize_comm(pid_t pid, int full,
@@ -299,6 +301,19 @@ try_again:
 	}
 }
 
+static void dso__calc_col_width(struct dso *self)
+{
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.dso_list ||
+	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
+		unsigned int slen = strlen(self->name);
+		if (slen > dsos__col_width)
+			dsos__col_width = slen;
+	}
+
+	self->slen_calculated = 1;
+}
+
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     struct addr_location *al, symbol_filter_t filter)
 {
@@ -308,6 +323,10 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 	if (thread == NULL)
 		return -1;
 
+	if (symbol_conf.comm_list &&
+	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
+		goto out_filtered;
+
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	thread__find_addr_location(thread, session, cpumode, MAP__FUNCTION,
@@ -315,6 +334,29 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
+	/*
+	 * We have to do this here as we may have a dso with no symbol hit that
+	 * has a name longer than the ones with symbols sampled.
+	 */
+	if (al->map && !sort_dso.elide && !al->map->dso->slen_calculated)
+		dso__calc_col_width(al->map->dso);
+
+	if (symbol_conf.dso_list &&
+	    (!al->map || !al->map->dso ||
+	     !(strlist__has_entry(symbol_conf.dso_list, al->map->dso->short_name) ||
+	       (al->map->dso->short_name != al->map->dso->long_name &&
+		strlist__has_entry(symbol_conf.dso_list, al->map->dso->long_name)))))
+		goto out_filtered;
+
+	if (symbol_conf.sym_list && al->sym &&
+	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
+		goto out_filtered;
+
+	al->filtered = false;
+	return 0;
+
+out_filtered:
+	al->filtered = true;
 	return 0;
 }
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 164286a..7707897 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1764,6 +1764,11 @@ int symbol__init(void)
 	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
+	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
+		pr_err("'.' is the only non valid --field-separator argument\n");
+		return -1;
+	}
+
 	if (setup_list(&symbol_conf.dso_list,
 		       symbol_conf.dso_list_str, "dso") < 0)
 		return -1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d61f350..6015152 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -56,7 +56,8 @@ struct symbol_conf {
 	bool		try_vmlinux_path,
 			use_modules,
 			sort_by_name;
-	const char	*vmlinux_name;
+	const char	*vmlinux_name,
+			*field_sep;
 	char            *dso_list_str,
 			*comm_list_str,
 			*sym_list_str,
@@ -79,6 +80,7 @@ struct addr_location {
 	struct symbol *sym;
 	u64	      addr;
 	char	      level;
+	bool	      filtered;
 };
 
 struct dso {
-- 
1.6.2.5

