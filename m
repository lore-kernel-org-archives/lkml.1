Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0CJNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:18:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:43250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab0CJNR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:17:58 -0500
Date: Wed, 10 Mar 2010 13:15:25 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267804269-22660-6-git-send-email-acme@infradead.org>
References: <1267804269-22660-6-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report: Add multiple event support
Message-ID: <tip-cbbc79a53278b83bf7f834127751459f9299e402@git.kernel.org>
Git-Commit-ID: cbbc79a53278b83bf7f834127751459f9299e402
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:15:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbbc79a53278b83bf7f834127751459f9299e402
Gitweb:     http://git.kernel.org/tip/cbbc79a53278b83bf7f834127751459f9299e402
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Fri, 5 Mar 2010 12:51:09 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:53:50 +0100

perf report: Add multiple event support

Perf report does not handle multiple events being reported, even
though perf record stores them properly on disk.  This patch
addresses that issue by adding the logic to perf report to use
the event stream id that is saved by record and the new data
structures to seperate the event streams and report them
individually.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1267804269-22660-6-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
