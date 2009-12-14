Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZLNPLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZLNPLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZLNPLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:11:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:52092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbZLNPK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:10:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf session: Move the hist_entries rb tree to perf_session
Date: Mon, 14 Dec 2009 13:10:39 -0200
Message-Id: <1260803439-16783-1-git-send-email-acme@infradead.org>
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

As we'll need to sort multiple times for multiple perf sessions, so that
we can then do a diff.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |   19 +++++++------
 tools/perf/builtin-kmem.c      |    2 +-
 tools/perf/builtin-report.c    |   55 +++++++++++++++++++++------------------
 tools/perf/builtin-sched.c     |    2 +-
 tools/perf/builtin-timechart.c |    2 +-
 tools/perf/builtin-trace.c     |    2 +-
 tools/perf/util/data_map.c     |    2 +-
 tools/perf/util/hist.c         |   43 ++++++++++++++++--------------
 tools/perf/util/hist.h         |   43 ++++++++++---------------------
 tools/perf/util/session.h      |    5 +++-
 10 files changed, 86 insertions(+), 89 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f25e89e..1f1341f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -121,10 +121,12 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 			h->ip[offset]);
 }
 
-static int hist_entry__add(struct addr_location *al, u64 count)
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __hist_entry__add(al, NULL, count, &hit);
+	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+							       count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 	hist_hit(he, al->addr);
@@ -144,7 +146,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (hist_entry__add(&al, 1)) {
+	if (perf_session__add_hist_entry(session, &al, 1)) {
 		fprintf(stderr, "problem incrementing symbol count, "
 				"skipping event\n");
 		return -1;
@@ -428,11 +430,11 @@ static void annotate_sym(struct hist_entry *he)
 		free_source_line(he, len);
 }
 
-static void find_annotations(void)
+static void perf_session__find_annotations(struct perf_session *self)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&hist); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
@@ -484,10 +486,9 @@ static int __cmd_annotate(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	collapse__resort();
-	output__resort(event__total[0]);
-
-	find_annotations();
+	perf_session__collapse_resort(session);
+	perf_session__output_resort(session, event__total[0]);
+	perf_session__find_annotations(session);
 out_delete:
 	perf_session__delete(session);
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index e79ecbc..3b329c6 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -344,7 +344,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(u64 type, struct perf_session *session __used)
 {
 	sample_type = type;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9cbdcbc..854427f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -38,6 +38,7 @@ static char		*dso_list_str, *comm_list_str, *sym_list_str,
 static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		force;
+static bool		use_callchain;
 
 static int		show_nr_samples;
 
@@ -312,8 +313,9 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-static size_t
-hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
+static size_t hist_entry__fprintf(FILE *fp, struct hist_entry *self,
+				  struct perf_session *session,
+				  u64 total_samples)
 {
 	struct sort_entry *se;
 	size_t ret;
@@ -345,7 +347,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 
 	ret += fprintf(fp, "\n");
 
-	if (callchain) {
+	if (session->use_callchain) {
 		int left_margin = 0;
 
 		if (sort__first_dimension == SORT_COMM) {
@@ -422,7 +424,7 @@ static struct symbol **resolve_callchain(struct thread *thread,
 	struct symbol **syms = NULL;
 	unsigned int i;
 
-	if (callchain) {
+	if (session->use_callchain) {
 		syms = calloc(chain->nr, sizeof(*syms));
 		if (!syms) {
 			fprintf(stderr, "Can't allocate memory for symbols\n");
@@ -454,7 +456,7 @@ static struct symbol **resolve_callchain(struct thread *thread,
 			if (sort__has_parent && !*parent &&
 			    call__match(al.sym))
 				*parent = al.sym;
-			if (!callchain)
+			if (!session->use_callchain)
 				break;
 			syms[i] = al.sym;
 		}
@@ -467,25 +469,25 @@ static struct symbol **resolve_callchain(struct thread *thread,
  * collect histogram counts
  */
 
-static int hist_entry__add(struct addr_location *al,
-			   struct perf_session *session,
-			   struct ip_callchain *chain, u64 count)
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al,
+					struct ip_callchain *chain, u64 count)
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
 	struct hist_entry *he;
 
-	if ((sort__has_parent || callchain) && chain)
-		syms = resolve_callchain(al->thread, session, chain, &parent);
+	if ((sort__has_parent || self->use_callchain) && chain)
+		syms = resolve_callchain(al->thread, self, chain, &parent);
 
-	he = __hist_entry__add(al, parent, count, &hit);
+	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
 	if (hit)
 		he->count += count;
 
-	if (callchain) {
+	if (self->use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
 		append_chain(&he->callchain, chain, syms);
@@ -495,7 +497,8 @@ static int hist_entry__add(struct addr_location *al,
 	return 0;
 }
 
-static size_t output__fprintf(FILE *fp, u64 total_samples)
+static size_t perf_session__fprintf_hist_entries(struct perf_session *self,
+						 u64 total_samples, FILE *fp)
 {
 	struct hist_entry *pos;
 	struct sort_entry *se;
@@ -567,9 +570,9 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	fprintf(fp, "#\n");
 
 print_entries:
-	for (nd = rb_first(&hist); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
-		ret += hist_entry__fprintf(fp, pos, total_samples);
+		ret += hist_entry__fprintf(fp, pos, self, total_samples);
 	}
 
 	if (sort_order == default_sort_order &&
@@ -671,7 +674,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
 		return 0;
 
-	if (hist_entry__add(&al, session, data.callchain, data.period)) {
+	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
@@ -719,7 +722,7 @@ static int process_read_event(event_t *event, struct perf_session *session __use
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(u64 type, struct perf_session *session)
 {
 	sample_type = type;
 
@@ -730,14 +733,14 @@ static int sample_type_check(u64 type)
 					" perf record without -g?\n");
 			return -1;
 		}
-		if (callchain) {
+		if (session->use_callchain) {
 			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			return -1;
 		}
-	} else if (callchain_param.mode != CHAIN_NONE && !callchain) {
-			callchain = 1;
+	} else if (callchain_param.mode != CHAIN_NONE && !session->use_callchain) {
+			session->use_callchain = true;
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
@@ -769,6 +772,8 @@ static int __cmd_report(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	session->use_callchain = use_callchain;
+
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
@@ -787,9 +792,9 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	collapse__resort();
-	output__resort(event__stats.total);
-	output__fprintf(stdout, event__stats.total);
+	perf_session__collapse_resort(session);
+	perf_session__output_resort(session, event__stats.total);
+	perf_session__fprintf_hist_entries(session, event__stats.total, stdout);
 
 	if (show_threads)
 		perf_read_values_destroy(&show_threads_values);
@@ -805,7 +810,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	char *tok;
 	char *endptr;
 
-	callchain = 1;
+	use_callchain = true;
 
 	if (!arg)
 		return 0;
@@ -826,7 +831,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		callchain = 0;
+		use_callchain = true;
 
 		return 0;
 	}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index bce05df..412ae92 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1655,7 +1655,7 @@ static int process_lost_event(event_t *event __used,
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(u64 type, struct perf_session *session __used)
 {
 	sample_type = type;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 2701853..3a0a89e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1033,7 +1033,7 @@ static void process_samples(void)
 	}
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(u64 type, struct perf_session *session __used)
 {
 	sample_type = type;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9d89ae4..adce442 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -103,7 +103,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(u64 type, struct perf_session *session __used)
 {
 	sample_type = type;
 
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 44dea21..08c4cf5 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -161,7 +161,7 @@ int perf_session__process_events(struct perf_session *self,
 
 	err = -EINVAL;
 	if (ops->sample_type_check &&
-	    ops->sample_type_check(sample_type) < 0)
+	    ops->sample_type_check(sample_type, self) < 0)
 		goto out_err;
 
 	if (!ops->full_paths) {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b40e37d..b9828fc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,7 +1,6 @@
 #include "hist.h"
-
-struct rb_root hist;
-int callchain;
+#include "session.h"
+#include "sort.h"
 
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -12,11 +11,12 @@ struct callchain_param	callchain_param = {
  * histogram, sorted on item, collects counts
  */
 
-struct hist_entry *__hist_entry__add(struct addr_location *al,
-				     struct symbol *sym_parent,
-				     u64 count, bool *hit)
+struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+						  struct addr_location *al,
+						  struct symbol *sym_parent,
+						  u64 count, bool *hit)
 {
-	struct rb_node **p = &hist.rb_node;
+	struct rb_node **p = &self->hists.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -52,7 +52,7 @@ struct hist_entry *__hist_entry__add(struct addr_location *al,
 		return NULL;
 	*he = entry;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &hist);
+	rb_insert_color(&he->rb_node, &self->hists);
 	*hit = false;
 	return he;
 }
@@ -129,7 +129,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 	rb_insert_color(&he->rb_node, root);
 }
 
-void collapse__resort(void)
+void perf_session__collapse_resort(struct perf_session *self)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -139,31 +139,33 @@ void collapse__resort(void)
 		return;
 
 	tmp = RB_ROOT;
-	next = rb_first(&hist);
+	next = rb_first(&self->hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &hist);
+		rb_erase(&n->rb_node, &self->hists);
 		collapse__insert_entry(&tmp, n);
 	}
 
-	hist = tmp;
+	self->hists = tmp;
 }
 
 /*
  * reverse the map, sort on count.
  */
 
-static void output__insert_entry(struct rb_root *root, struct hist_entry *he,
-				 u64 min_callchain_hits)
+static void perf_session__insert_output_hist_entry(struct perf_session *self,
+						   struct rb_root *root,
+						   struct hist_entry *he,
+						   u64 min_callchain_hits)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
-	if (callchain)
+	if (self->use_callchain)
 		callchain_param.sort(&he->sorted_chain, &he->callchain,
 				      min_callchain_hits, &callchain_param);
 
@@ -181,7 +183,7 @@ static void output__insert_entry(struct rb_root *root, struct hist_entry *he,
 	rb_insert_color(&he->rb_node, root);
 }
 
-void output__resort(u64 total_samples)
+void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -192,15 +194,16 @@ void output__resort(u64 total_samples)
 		total_samples * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
-	next = rb_first(&hist);
+	next = rb_first(&self->hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &hist);
-		output__insert_entry(&tmp, n, min_callchain_hits);
+		rb_erase(&n->rb_node, &self->hists);
+		perf_session__insert_output_hist_entry(self, &tmp, n,
+						       min_callchain_hits);
 	}
 
-	hist = tmp;
+	self->hists = tmp;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a6cb148..7efdb1b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -1,40 +1,25 @@
 #ifndef __PERF_HIST_H
 #define __PERF_HIST_H
-#include "../builtin.h"
 
-#include "util.h"
-
-#include "color.h"
-#include <linux/list.h>
-#include "cache.h"
-#include <linux/rbtree.h>
-#include "symbol.h"
-#include "string.h"
+#include <linux/types.h>
 #include "callchain.h"
-#include "strlist.h"
-#include "values.h"
-
-#include "../perf.h"
-#include "debug.h"
-#include "header.h"
-
-#include "parse-options.h"
-#include "parse-events.h"
 
-#include "thread.h"
-#include "sort.h"
-
-extern struct rb_root hist;
-extern int callchain;
 extern struct callchain_param callchain_param;
 
-struct hist_entry *__hist_entry__add(struct addr_location *al,
-				     struct symbol *parent,
-				     u64 count, bool *hit);
+struct perf_session;
+struct hist_entry;
+struct addr_location;
+struct symbol;
+
+struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+						  struct addr_location *al,
+						  struct symbol *parent,
+						  u64 count, bool *hit);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-extern void hist_entry__free(struct hist_entry *);
-extern void collapse__resort(void);
-extern void output__resort(u64);
+void hist_entry__free(struct hist_entry *);
+
+void perf_session__output_resort(struct perf_session *self, u64 total_samples);
+void perf_session__collapse_resort(struct perf_session *self);
 
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 20b2c9c..759d960 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -16,10 +16,12 @@ struct perf_session {
 	struct map_groups	kmaps;
 	struct rb_root		threads;
 	struct thread		*last_match;
+	struct rb_root		hists;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
 	bool			use_modules;
+	bool			use_callchain;
 	char filename[0];
 };
 
@@ -35,7 +37,8 @@ struct perf_event_ops {
 	event_op	process_read_event;
 	event_op	process_throttle_event;
 	event_op	process_unthrottle_event;
-	int		(*sample_type_check)(u64 sample_type);
+	int		(*sample_type_check)(u64 sample_type,
+					     struct perf_session *session);
 	unsigned long	total_unknown;
 	bool		full_paths;
 };
-- 
1.6.2.5

