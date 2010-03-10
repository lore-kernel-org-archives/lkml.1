Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0CJNRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:17:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:43240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0CJNRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:17:43 -0500
Date: Wed, 10 Mar 2010 13:15:08 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267804269-22660-5-git-send-email-acme@infradead.org>
References: <1267804269-22660-5-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Change perf_session post processing functions to take histogram tree
Message-ID: <tip-eefc465cdd49cb89a742083fac2807c718ddad31@git.kernel.org>
Git-Commit-ID: eefc465cdd49cb89a742083fac2807c718ddad31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:15:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eefc465cdd49cb89a742083fac2807c718ddad31
Gitweb:     http://git.kernel.org/tip/eefc465cdd49cb89a742083fac2807c718ddad31
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Fri, 5 Mar 2010 12:51:08 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:53:49 +0100

perf session: Change perf_session post processing functions to take histogram tree

Now that report can store historgrams for multiple events we
need to be able to do the post processing work for each
histogram. This patch changes the post processing functions so
that they can be called individually for each event's histogram.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
[ Guarantee bisectabilty by fixing up builtin-report.c ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1267804269-22660-5-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-diff.c     |   10 ++++++----
 tools/perf/builtin-report.c   |    8 +++++---
 tools/perf/util/hist.c        |   39 ++++++++++++++++++++-------------------
 tools/perf/util/hist.h        |    9 +++++----
 5 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4b734c7..6ad7148 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -564,8 +564,8 @@ static int __cmd_annotate(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, session->event_total[0]);
+	perf_session__collapse_resort(&session->hists);
+	perf_session__output_resort(&session->hists, session->event_total[0]);
 	perf_session__find_annotations(session);
 out_delete:
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 20df735..1ea15d8 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -115,7 +115,7 @@ static void perf_session__resort_hist_entries(struct perf_session *self)
 
 static void perf_session__set_hist_entries_positions(struct perf_session *self)
 {
-	perf_session__output_resort(self, self->events_stats.total);
+	perf_session__output_resort(&self->hists, self->events_stats.total);
 	perf_session__resort_hist_entries(self);
 }
 
@@ -167,13 +167,15 @@ static int __cmd_diff(void)
 			goto out_delete;
 	}
 
-	perf_session__output_resort(session[1], session[1]->events_stats.total);
+	perf_session__output_resort(&session[1]->hists,
+				    session[1]->events_stats.total);
 	if (show_displacement)
 		perf_session__set_hist_entries_positions(session[0]);
 
 	perf_session__match_hists(session[0], session[1]);
-	perf_session__fprintf_hists(session[1], session[0],
-				    show_displacement, stdout);
+	perf_session__fprintf_hists(&session[1]->hists, session[0],
+				    show_displacement, stdout,
+				    session[1]->events_stats.total);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cd16e6a..294b4cf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -225,10 +225,12 @@ static int __cmd_report(void)
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	perf_session__collapse_resort(session);
-	perf_session__output_resort(session, session->events_stats.total);
+	perf_session__collapse_resort(&session->hists);
+	perf_session__output_resort(&session->hists,
+				    session->events_stats.total);
 	fprintf(stdout, "# Samples: %Ld\n#\n", session->events_stats.total);
-	perf_session__fprintf_hists(session, NULL, false, stdout);
+	perf_session__fprintf_hists(&session->hists, NULL, false, stdout,
+				    session->events_stats.total);
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
 		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 55dd911..73ebb6f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -130,7 +130,7 @@ static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__collapse_resort(struct perf_session *self)
+void perf_session__collapse_resort(struct rb_root *hists)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -140,17 +140,17 @@ void perf_session__collapse_resort(struct perf_session *self)
 		return;
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->hists);
+	next = rb_first(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->hists);
+		rb_erase(&n->rb_node, hists);
 		collapse__insert_entry(&tmp, n);
 	}
 
-	self->hists = tmp;
+	*hists = tmp;
 }
 
 /*
@@ -183,7 +183,7 @@ static void perf_session__insert_output_hist_entry(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-void perf_session__output_resort(struct perf_session *self, u64 total_samples)
+void perf_session__output_resort(struct rb_root *hists, u64 total_samples)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -194,18 +194,18 @@ void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 		total_samples * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->hists);
+	next = rb_first(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->hists);
+		rb_erase(&n->rb_node, hists);
 		perf_session__insert_output_hist_entry(&tmp, n,
 						       min_callchain_hits);
 	}
 
-	self->hists = tmp;
+	*hists = tmp;
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -456,10 +456,10 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 }
 
 static size_t hist_entry__fprintf(struct hist_entry *self,
-				  struct perf_session *session,
 				  struct perf_session *pair_session,
 				  bool show_displacement,
-				  long displacement, FILE *fp)
+				  long displacement, FILE *fp,
+				  u64 session_total)
 {
 	struct sort_entry *se;
 	u64 count, total;
@@ -474,7 +474,7 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 		total = pair_session->events_stats.total;
 	} else {
 		count = self->count;
-		total = session->events_stats.total;
+		total = session_total;
 	}
 
 	if (total)
@@ -496,8 +496,8 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 
 		if (total > 0)
 			old_percent = (count * 100.0) / total;
-		if (session->events_stats.total > 0)
-			new_percent = (self->count * 100.0) / session->events_stats.total;
+		if (session_total > 0)
+			new_percent = (self->count * 100.0) / session_total;
 
 		diff = new_percent - old_percent;
 
@@ -544,16 +544,17 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 			left_margin -= thread__comm_len(self->thread);
 		}
 
-		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
+		hist_entry_callchain__fprintf(fp, self, session_total,
 					      left_margin);
 	}
 
 	return ret;
 }
 
-size_t perf_session__fprintf_hists(struct perf_session *self,
+size_t perf_session__fprintf_hists(struct rb_root *hists,
 				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp)
+				   bool show_displacement, FILE *fp,
+				   u64 session_total)
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
@@ -641,7 +642,7 @@ size_t perf_session__fprintf_hists(struct perf_session *self,
 	fprintf(fp, "\n#\n");
 
 print_entries:
-	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (show_displacement) {
@@ -652,8 +653,8 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, self, pair, show_displacement,
-					   displacement, fp);
+		ret += hist_entry__fprintf(h, pair, show_displacement,
+					   displacement, fp, session_total);
 	}
 
 	free(rem_sq_bracket);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7b48590..16f360c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -20,9 +20,10 @@ extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 void hist_entry__free(struct hist_entry *);
 
-void perf_session__output_resort(struct perf_session *self, u64 total_samples);
-void perf_session__collapse_resort(struct perf_session *self);
-size_t perf_session__fprintf_hists(struct perf_session *self,
+void perf_session__output_resort(struct rb_root *hists, u64 total_samples);
+void perf_session__collapse_resort(struct rb_root *hists);
+size_t perf_session__fprintf_hists(struct rb_root *hists,
 				   struct perf_session *pair,
-				   bool show_displacement, FILE *fp);
+				   bool show_displacement, FILE *fp,
+				   u64 session_total);
 #endif	/* __PERF_HIST_H */
