Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZLNNhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZLNNhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZLNNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:37:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZLNNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:37:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: No need for three rb_trees for sorting hist entries
Date: Mon, 14 Dec 2009 11:37:11 -0200
Message-Id: <1260797831-11220-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

All hist entries are in only one of them, so use just one and a
temporary rb_root while sorting/collapsing.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/util/hist.c        |   36 ++++++++++++++++++++----------------
 tools/perf/util/hist.h        |   10 ----------
 4 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e44c54c..f25e89e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -432,7 +432,7 @@ static void find_annotations(void)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hist); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3487224..9cbdcbc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -567,7 +567,7 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	fprintf(fp, "#\n");
 
 print_entries:
-	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hist); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
 		ret += hist_entry__fprintf(fp, pos, total_samples);
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0ebf6ee..b40e37d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,8 +1,6 @@
 #include "hist.h"
 
 struct rb_root hist;
-struct rb_root collapse_hists;
-struct rb_root output_hists;
 int callchain;
 
 struct callchain_param	callchain_param = {
@@ -102,9 +100,9 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-void collapse__insert_entry(struct hist_entry *he)
+static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 {
-	struct rb_node **p = &collapse_hists.rb_node;
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 	int64_t cmp;
@@ -128,34 +126,40 @@ void collapse__insert_entry(struct hist_entry *he)
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &collapse_hists);
+	rb_insert_color(&he->rb_node, root);
 }
 
 void collapse__resort(void)
 {
+	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
 
 	if (!sort__need_collapse)
 		return;
 
+	tmp = RB_ROOT;
 	next = rb_first(&hist);
+
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, &hist);
-		collapse__insert_entry(n);
+		collapse__insert_entry(&tmp, n);
 	}
+
+	hist = tmp;
 }
 
 /*
  * reverse the map, sort on count.
  */
 
-void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
+static void output__insert_entry(struct rb_root *root, struct hist_entry *he,
+				 u64 min_callchain_hits)
 {
-	struct rb_node **p = &output_hists.rb_node;
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
@@ -174,29 +178,29 @@ void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &output_hists);
+	rb_insert_color(&he->rb_node, root);
 }
 
 void output__resort(u64 total_samples)
 {
+	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
-	struct rb_root *tree = &hist;
 	u64 min_callchain_hits;
 
 	min_callchain_hits =
 		total_samples * (callchain_param.min_percent / 100);
 
-	if (sort__need_collapse)
-		tree = &collapse_hists;
-
-	next = rb_first(tree);
+	tmp = RB_ROOT;
+	next = rb_first(&hist);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n, min_callchain_hits);
+		rb_erase(&n->rb_node, &hist);
+		output__insert_entry(&tmp, n, min_callchain_hits);
 	}
+
+	hist = tmp;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3020db0..a6cb148 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -25,16 +25,8 @@
 #include "sort.h"
 
 extern struct rb_root hist;
-extern struct rb_root collapse_hists;
-extern struct rb_root output_hists;
 extern int callchain;
 extern struct callchain_param callchain_param;
-extern unsigned long total;
-extern unsigned long total_mmap;
-extern unsigned long total_comm;
-extern unsigned long total_fork;
-extern unsigned long total_unknown;
-extern unsigned long total_lost;
 
 struct hist_entry *__hist_entry__add(struct addr_location *al,
 				     struct symbol *parent,
@@ -42,9 +34,7 @@ struct hist_entry *__hist_entry__add(struct addr_location *al,
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 extern void hist_entry__free(struct hist_entry *);
-extern void collapse__insert_entry(struct hist_entry *);
 extern void collapse__resort(void);
-extern void output__insert_entry(struct hist_entry *, u64);
 extern void output__resort(u64);
 
 #endif	/* __PERF_HIST_H */
-- 
1.6.2.5

