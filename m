Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbZLOWFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbZLOWFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbZLOWE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:04:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:46408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858AbZLOWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:04:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf report: Generalize perf_session__fprintf_hists
Date: Tue, 15 Dec 2009 20:04:42 -0200
Message-Id: <1260914682-29652-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260914682-29652-1-git-send-email-acme@infradead.org>
References: <1260914682-29652-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Further changes will be made and it will then be usable in 'perf diff'
as well.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  114 +++++++++++--------------------------------
 tools/perf/util/event.c     |   30 +++++++++++-
 tools/perf/util/hist.c      |    7 +--
 tools/perf/util/session.c   |    4 +-
 tools/perf/util/session.h   |    1 -
 tools/perf/util/symbol.c    |    1 +
 tools/perf/util/symbol.h    |    5 ++-
 7 files changed, 68 insertions(+), 94 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9c59534..26f4de6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -34,9 +34,6 @@
 static char		const *input_name = "perf.data";
 
 static int		force;
-static bool		use_callchain;
-
-static int		show_nr_samples;
 
 static int		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -44,8 +41,6 @@ static struct perf_read_values	show_threads_values;
 static char		default_pretty_printing_style[] = "normal";
 static char		*pretty_printing_style = default_pretty_printing_style;
 
-static int		exclude_other = 1;
-
 static char		callchain_default_opt[] = "fractal,0.5";
 
 static size_t
@@ -305,23 +300,22 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 }
 
 static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
-				  struct perf_session *session,
-				  u64 total_samples)
+				  struct perf_session *session)
 {
 	struct sort_entry *se;
 	size_t ret;
 
-	if (exclude_other && !self->parent)
+	if (symbol_conf.exclude_other && !self->parent)
 		return 0;
 
-	if (total_samples)
+	if (session->events_stats.total)
 		ret = percent_color_fprintf(fp,
 					    symbol_conf.field_sep ? "%.2f" : "   %6.2f%%",
-					(self->count * 100.0) / total_samples);
+					(self->count * 100.0) / session->events_stats.total);
 	else
 		ret = fprintf(fp, symbol_conf.field_sep ? "%lld" : "%12lld ", self->count);
 
-	if (show_nr_samples) {
+	if (symbol_conf.show_nr_samples) {
 		if (symbol_conf.field_sep)
 			fprintf(fp, "%c%lld", *symbol_conf.field_sep, self->count);
 		else
@@ -338,7 +332,7 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 
 	ret += fprintf(fp, "\n");
 
-	if (session->use_callchain) {
+	if (symbol_conf.use_callchain) {
 		int left_margin = 0;
 
 		if (sort__first_dimension == SORT_COMM) {
@@ -348,41 +342,13 @@ static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
 			left_margin -= thread__comm_len(self->thread);
 		}
 
-		hist_entry_callchain__fprintf(fp, self, total_samples,
+		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
 					      left_margin);
 	}
 
 	return ret;
 }
 
-static void thread__comm_adjust(struct thread *self)
-{
-	char *comm = self->comm;
-
-	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-	    (!symbol_conf.comm_list ||
-	     strlist__has_entry(symbol_conf.comm_list, comm))) {
-		unsigned int slen = strlen(comm);
-
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
-	}
-}
-
-static int thread__set_comm_adjust(struct thread *self, const char *comm)
-{
-	int ret = thread__set_comm(self, comm);
-
-	if (ret)
-		return ret;
-
-	thread__comm_adjust(self);
-
-	return 0;
-}
-
 /*
  * collect histogram counts
  */
@@ -395,7 +361,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	bool hit;
 	struct hist_entry *he;
 
-	if ((sort__has_parent || self->use_callchain) && chain)
+	if ((sort__has_parent || symbol_conf.use_callchain) && chain)
 		syms = perf_session__resolve_callchain(self, al->thread,
 						       chain, &parent);
 	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
@@ -405,7 +371,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	if (hit)
 		he->count += count;
 
-	if (self->use_callchain) {
+	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
 		append_chain(&he->callchain, chain, syms);
@@ -415,8 +381,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	return 0;
 }
 
-static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
-						 u64 total_samples, FILE *fp)
+static size_t perf_session__fprintf_hists(struct perf_session *self, FILE *fp)
 {
 	struct hist_entry *pos;
 	struct sort_entry *se;
@@ -424,17 +389,14 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 	size_t ret = 0;
 	unsigned int width;
 	char *col_width = symbol_conf.col_width_list_str;
-	int raw_printing_style;
-
-	raw_printing_style = !strcmp(pretty_printing_style, "raw");
 
 	init_rem_hits();
 
-	fprintf(fp, "# Samples: %Ld\n", (u64)total_samples);
+	fprintf(fp, "# Samples: %ld\n", self->events_stats.total);
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
-	if (show_nr_samples) {
+	if (symbol_conf.show_nr_samples) {
 		if (symbol_conf.field_sep)
 			fprintf(fp, "%cSamples", *symbol_conf.field_sep);
 		else
@@ -467,7 +429,7 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 		goto print_entries;
 
 	fprintf(fp, "# ........");
-	if (show_nr_samples)
+	if (symbol_conf.show_nr_samples)
 		fprintf(fp, " ..........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
@@ -490,7 +452,7 @@ static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
 print_entries:
 	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
-		ret += hist_entry__fprintf(fp, pos, self, total_samples);
+		ret += hist_entry__fprintf(fp, pos, self);
 	}
 
 	if (sort_order == default_sort_order &&
@@ -503,10 +465,6 @@ print_entries:
 
 	free(rem_sq_bracket);
 
-	if (show_threads)
-		perf_read_values_display(fp, &show_threads_values,
-					 raw_printing_style);
-
 	return ret;
 }
 
@@ -572,21 +530,6 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int process_comm_event(event_t *event, struct perf_session *session)
-{
-	struct thread *thread = perf_session__findnew(session, event->comm.pid);
-
-	dump_printf(": %s:%d\n", event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm_adjust(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
 static int process_read_event(event_t *event, struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
@@ -619,14 +562,14 @@ static int sample_type_check(struct perf_session *session)
 					" perf record without -g?\n");
 			return -1;
 		}
-		if (session->use_callchain) {
+		if (symbol_conf.use_callchain) {
 			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			return -1;
 		}
-	} else if (callchain_param.mode != CHAIN_NONE && !session->use_callchain) {
-			session->use_callchain = true;
+	} else if (callchain_param.mode != CHAIN_NONE && !symbol_conf.use_callchain) {
+			symbol_conf.use_callchain = true;
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
@@ -640,7 +583,7 @@ static int sample_type_check(struct perf_session *session)
 static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
-	.process_comm_event	= process_comm_event,
+	.process_comm_event	= event__process_mmap,
 	.process_exit_event	= event__process_task,
 	.process_fork_event	= event__process_task,
 	.process_lost_event	= event__process_lost,
@@ -658,8 +601,6 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	session->use_callchain = use_callchain;
-
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -680,10 +621,13 @@ static int __cmd_report(void)
 
 	perf_session__collapse_resort(session);
 	perf_session__output_resort(session, session->events_stats.total);
-	perf_session__fprintf_hist_entries(session, session->events_stats.total, stdout);
-
-	if (show_threads)
+	perf_session__fprintf_hists(session, stdout);
+	if (show_threads) {
+		bool raw_printing_style = !strcmp(pretty_printing_style, "raw");
+		perf_read_values_display(stdout, &show_threads_values,
+					 raw_printing_style);
 		perf_read_values_destroy(&show_threads_values);
+	}
 out_delete:
 	perf_session__delete(session);
 	return ret;
@@ -696,7 +640,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	char *tok;
 	char *endptr;
 
-	use_callchain = true;
+	symbol_conf.use_callchain = true;
 
 	if (!arg)
 		return 0;
@@ -717,7 +661,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		use_callchain = true;
+		symbol_conf.use_callchain = true;
 
 		return 0;
 	}
@@ -760,7 +704,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
+	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_BOOLEAN('T', "threads", &show_threads,
 		    "Show per-thread event counters"),
@@ -772,7 +716,7 @@ static const struct option options[] = {
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
-	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
+	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
@@ -817,7 +761,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		sort_dimension__add("parent");
 		sort_parent.elide = 1;
 	} else
-		exclude_other = 0;
+		symbol_conf.exclude_other = false;
 
 	/*
 	 * Any (unrecognized) arguments left?
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bf491fd..bb0fd6d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -189,13 +189,41 @@ void event__synthesize_threads(int (*process)(event_t *event,
 	closedir(proc);
 }
 
+static void thread__comm_adjust(struct thread *self)
+{
+	char *comm = self->comm;
+
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.comm_list ||
+	     strlist__has_entry(symbol_conf.comm_list, comm))) {
+		unsigned int slen = strlen(comm);
+
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+}
+
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
+{
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	thread__comm_adjust(self);
+
+	return 0;
+}
+
 int event__process_comm(event_t *self, struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->comm.pid);
 
 	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
 
-	if (thread == NULL || thread__set_comm(thread, self->comm.comm)) {
+	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b9828fc..d9a5a19 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -156,8 +156,7 @@ void perf_session__collapse_resort(struct perf_session *self)
  * reverse the map, sort on count.
  */
 
-static void perf_session__insert_output_hist_entry(struct perf_session *self,
-						   struct rb_root *root,
+static void perf_session__insert_output_hist_entry(struct rb_root *root,
 						   struct hist_entry *he,
 						   u64 min_callchain_hits)
 {
@@ -165,7 +164,7 @@ static void perf_session__insert_output_hist_entry(struct perf_session *self,
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
-	if (self->use_callchain)
+	if (symbol_conf.use_callchain)
 		callchain_param.sort(&he->sorted_chain, &he->callchain,
 				      min_callchain_hits, &callchain_param);
 
@@ -201,7 +200,7 @@ void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, &self->hists);
-		perf_session__insert_output_hist_entry(self, &tmp, n,
+		perf_session__insert_output_hist_entry(&tmp, n,
 						       min_callchain_hits);
 	}
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bceaa09..ce3a6c8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -108,7 +108,7 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 	struct symbol **syms = NULL;
 	unsigned int i;
 
-	if (self->use_callchain) {
+	if (symbol_conf.use_callchain) {
 		syms = calloc(chain->nr, sizeof(*syms));
 		if (!syms) {
 			fprintf(stderr, "Can't allocate memory for symbols\n");
@@ -140,7 +140,7 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 			if (sort__has_parent && !*parent &&
 			    symbol__match_parent_regex(al.sym))
 				*parent = al.sym;
-			if (!self->use_callchain)
+			if (!symbol_conf.use_callchain)
 				break;
 			syms[i] = al.sym;
 		}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index faf18a8..32eaa1b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -25,7 +25,6 @@ struct perf_session {
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
-	bool			use_callchain;
 	char filename[0];
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7707897..ab92763 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -38,6 +38,7 @@ static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
+	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 };
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6015152..8aded23 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -55,7 +55,10 @@ struct symbol_conf {
 	unsigned short	priv_size;
 	bool		try_vmlinux_path,
 			use_modules,
-			sort_by_name;
+			sort_by_name,
+			show_nr_samples,
+			use_callchain,
+			exclude_other;
 	const char	*vmlinux_name,
 			*field_sep;
 	char            *dso_list_str,
-- 
1.6.2.5

