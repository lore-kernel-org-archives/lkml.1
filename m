Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0CEPvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:51:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:33375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0CEPv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:51:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf report: Add multiple event support
Date: Fri,  5 Mar 2010 12:51:09 -0300
Message-Id: <1267804269-22660-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1267804269-22660-1-git-send-email-acme@infradead.org>
References: <1267804269-22660-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <ebmunson@us.ibm.com>

Perf report does not handle multiple events being reported, even though perf
record stores them properly on disk.  This patch addresses that issue by adding
the logic to perf report to use the event stream id that is saved by record and
the new data structures to seperate the event streams and report them
individually.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  115 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 100 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 294b4cf..f815de2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -45,29 +45,71 @@ static char		*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
+static struct event_stat_id *get_stats(struct perf_session *self,
+				       u64 event_stream, u32 type, u64 config)
+{
+	struct rb_node **p = &self->stats_by_id.rb_node;
+	struct rb_node *parent = NULL;
+	struct event_stat_id *iter, *new;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct event_stat_id, rb_node);
+		if (iter->config == config)
+			return iter;
+
+
+		if (config > iter->config)
+			p = &(*p)->rb_right;
+		else
+			p = &(*p)->rb_left;
+	}
+
+	new = malloc(sizeof(struct event_stat_id));
+	if (new == NULL)
+		return NULL;
+	memset(new, 0, sizeof(struct event_stat_id));
+	new->event_stream = event_stream;
+	new->config = config;
+	new->type = type;
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, &self->stats_by_id);
+	return new;
+}
+
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al,
-					struct ip_callchain *chain, u64 count)
+					struct sample_data *data)
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
 	struct hist_entry *he;
+	struct event_stat_id *stats;
+	struct perf_event_attr *attr;
 
-	if ((sort__has_parent || symbol_conf.use_callchain) && chain)
+	if ((sort__has_parent || symbol_conf.use_callchain) && data->callchain)
 		syms = perf_session__resolve_callchain(self, al->thread,
-						       chain, &parent);
-	he = __perf_session__add_hist_entry(&self->hists, al, parent,
-					    count, &hit);
+						       data->callchain, &parent);
+
+	attr = perf_header__find_attr(data->id, &self->header);
+	if (attr)
+		stats = get_stats(self, data->id, attr->type, attr->config);
+	else
+		stats = get_stats(self, data->id, 0, 0);
+	if (stats == NULL)
+		return -ENOMEM;
+	he = __perf_session__add_hist_entry(&stats->hists, al, parent,
+					    data->period, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
 	if (hit)
-		he->count += count;
+		he->count += data->period;
 
 	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
-		append_chain(&he->callchain, chain, syms);
+		append_chain(&he->callchain, data->callchain, syms);
 		free(syms);
 	}
 
@@ -87,10 +129,30 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
+static int add_event_total(struct perf_session *session,
+			   struct sample_data *data,
+			   struct perf_event_attr *attr)
+{
+	struct event_stat_id *stats;
+
+	if (attr)
+		stats = get_stats(session, data->id, attr->type, attr->config);
+	else
+		stats = get_stats(session, data->id, 0, 0);
+
+	if (!stats)
+		return -ENOMEM;
+
+	stats->stats.total += data->period;
+	session->events_stats.total += data->period;
+	return 0;
+}
+
 static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data = { .period = 1, };
 	struct addr_location al;
+	struct perf_event_attr *attr;
 
 	event__parse_sample(event, session->sample_type, &data);
 
@@ -124,12 +186,18 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
+	if (perf_session__add_hist_entry(session, &al, &data)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	session->events_stats.total += data.period;
+	attr = perf_header__find_attr(data.id, &session->header);
+
+	if (add_event_total(session, &data, attr)) {
+		pr_debug("problem adding event count\n");
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -198,6 +266,7 @@ static int __cmd_report(void)
 {
 	int ret = -EINVAL;
 	struct perf_session *session;
+	struct rb_node *next;
 
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
@@ -225,12 +294,28 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	perf_session__collapse_resort(&session->hists);
-	perf_session__output_resort(&session->hists,
-				    session->events_stats.total);
-	fprintf(stdout, "# Samples: %Ld\n#\n", session->events_stats.total);
-	perf_session__fprintf_hists(&session->hists, NULL, false, stdout,
-				    session->events_stats.total);
+	next = rb_first(&session->stats_by_id);
+	while (next) {
+		struct event_stat_id *stats;
+
+		stats = rb_entry(next, struct event_stat_id, rb_node);
+		perf_session__collapse_resort(&stats->hists);
+		perf_session__output_resort(&stats->hists, stats->stats.total);
+		if (rb_first(&session->stats_by_id) ==
+		    rb_last(&session->stats_by_id))
+			fprintf(stdout, "# Samples: %Ld\n#\n",
+				stats->stats.total);
+		else
+			fprintf(stdout, "# Samples: %Ld %s\n#\n",
+				stats->stats.total,
+				__event_name(stats->type, stats->config));
+
+		perf_session__fprintf_hists(&stats->hists, NULL, false, stdout,
+					    stats->stats.total);
+		fprintf(stdout, "\n\n");
+		next = rb_next(&stats->rb_node);
+	}
+
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
 		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
-- 
1.5.5.6

