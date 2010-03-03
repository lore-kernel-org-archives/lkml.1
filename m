Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0CCPit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:38:49 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:38907 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0CCPik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:38:40 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 4/5] Change perf_session post processing functions to take histogram tree
Date: Wed,  3 Mar 2010 15:38:26 +0000
Message-Id: <e6862a7256b24aad7d326b84058654763883ca02.1267630395.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1267630395.git.ebmunson@us.ibm.com>
References: <cover.1267630395.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1267630395.git.ebmunson@us.ibm.com>
References: <cover.1267630395.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that report can store historgrams for multiple events we need
to be able to do the post processing work for each histogram.
This patch changes the post processing functions so that they can
be called individually for each event's histogram.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-diff.c     |    9 +++++----
 tools/perf/util/hist.c        |   39 ++++++++++++++++++++-------------------
 tools/perf/util/hist.h        |    9 +++++----
 4 files changed, 32 insertions(+), 29 deletions(-)

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
index 20df735..d2781fb 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -115,7 +115,7 @@ static void perf_session__resort_hist_entries(struct perf_session *self)
 
 static void perf_session__set_hist_entries_positions(struct perf_session *self)
 {
-	perf_session__output_resort(self, self->events_stats.total);
+	perf_session__output_resort(&self->hists, self->events_stats.total);
 	perf_session__resort_hist_entries(self);
 }
 
@@ -167,13 +167,14 @@ static int __cmd_diff(void)
 			goto out_delete;
 	}
 
-	perf_session__output_resort(session[1], session[1]->events_stats.total);
+	perf_session__output_resort(&(session[1]->hists), session[1]->events_stats.total);
 	if (show_displacement)
 		perf_session__set_hist_entries_positions(session[0]);
 
 	perf_session__match_hists(session[0], session[1]);
-	perf_session__fprintf_hists(session[1], session[0],
-				    show_displacement, stdout);
+	perf_session__fprintf_hists(&(session[1]->hists), session[0],
+				    show_displacement, stdout,
+				    session[1]->events_stats.total);
 out_delete:
 	for (i = 0; i < 2; ++i)
 		perf_session__delete(session[i]);
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
-- 
1.6.3.3

