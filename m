Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZHGFLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZHGFLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 01:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZHGFLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 01:11:10 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42831 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZHGFLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 01:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ua5J32IHglTFHvVNZp2wYOw+zq1uTV5RVAwC5F0ylNLWIhvXf2Xb9jl3ukJdWhu7bC
         wAFm46fEtg3DkWsfmOkYnACJDB3xEpKcQGNWHxtk/1rxlLTOdt9zU4U+L9xzp9lRqiIA
         GJSlOaN4bwpW4/nJFEQI5zJtqirJErM9iFGQI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] perf tools: Fix cumul hit based sub-total
Date: Fri,  7 Aug 2009 07:11:05 +0200
Message-Id: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchain fractal mode builds each new total hits in a new branch
of profiling by using the parent's hits of the current branch plus the
hits of the children.

This is wrong, the total hits of a branch should be made of the sum of
every children hits, we must ignore the parent hits in this scope.

This patch also fixes another mistakes with the hit counting.

Now the rates are corrects.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-report.c |    4 ++--
 tools/perf/util/callchain.c |   27 ++++++++++++++++-----------
 tools/perf/util/callchain.h |    7 ++++++-
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cb58d6..da402e1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -901,7 +901,7 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	int i;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->cumul_hit;
+		new_total = self->children_hit;
 	else
 		new_total = total_samples;
 
@@ -930,7 +930,7 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
 						      new_total,
-						      child->cumul_hit);
+						      cumul_hits(child));
 		}
 		ret += callchain__fprintf_graph(fp, child, new_total,
 						depth + 1,
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9d3c814..98c5627 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -26,10 +26,14 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct callchain_node *rnode;
+	u64 chain_cumul = cumul_hits(chain);
 
 	while (*p) {
+		u64 rnode_cumul;
+
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
+		rnode_cumul = cumul_hits(rnode);
 
 		switch (mode) {
 		case CHAIN_FLAT:
@@ -40,7 +44,7 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 			break;
 		case CHAIN_GRAPH_ABS: /* Falldown */
 		case CHAIN_GRAPH_REL:
-			if (rnode->cumul_hit < chain->cumul_hit)
+			if (rnode_cumul < chain_cumul)
 				p = &(*p)->rb_left;
 			else
 				p = &(*p)->rb_right;
@@ -87,7 +91,7 @@ static void __sort_chain_graph_abs(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_abs(child, min_hit);
-		if (child->cumul_hit >= min_hit)
+		if (cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_ABS);
 	}
@@ -108,11 +112,11 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
-	min_hit = node->cumul_hit * min_percent / 100.0;
+	min_hit = node->children_hit * min_percent / 100.0;
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
-		if (child->cumul_hit >= min_hit)
+		if (cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_REL);
 	}
@@ -211,7 +215,8 @@ add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	new = create_child(parent, false);
 	fill_node(new, chain, start, syms);
 
-	new->cumul_hit = new->hit = 1;
+	new->children_hit = 0;
+	new->hit = 1;
 }
 
 /*
@@ -241,7 +246,8 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 
 	/* split the hits */
 	new->hit = parent->hit;
-	new->cumul_hit = parent->cumul_hit;
+	new->children_hit = parent->children_hit;
+	parent->children_hit = cumul_hits(new);
 	new->val_nr = parent->val_nr - idx_local;
 	parent->val_nr = idx_local;
 
@@ -249,6 +255,7 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	if (idx_total < chain->nr) {
 		parent->hit = 0;
 		add_child(parent, chain, idx_total, syms);
+		parent->children_hit++;
 	} else {
 		parent->hit = 1;
 	}
@@ -269,13 +276,13 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
 		unsigned int ret = __append_chain(rnode, chain, start, syms);
 
 		if (!ret)
-			goto cumul;
+			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
 	add_child(root, chain, start, syms);
 
-cumul:
-	root->cumul_hit++;
+inc_children_hit:
+	root->children_hit++;
 }
 
 static int
@@ -317,8 +324,6 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	/* we match 100% of the path, increment the hit */
 	if (i - start == root->val_nr && i == chain->nr) {
 		root->hit++;
-		root->cumul_hit++;
-
 		return 0;
 	}
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7812122..b2d128e 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -21,7 +21,7 @@ struct callchain_node {
 	struct rb_root		rb_root; /* sorted tree of children */
 	unsigned int		val_nr;
 	u64			hit;
-	u64			cumul_hit; /* hit + hits of children */
+	u64			children_hit;
 };
 
 struct callchain_param;
@@ -48,6 +48,11 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 }
 
+static inline u64 cumul_hits(struct callchain_node *node)
+{
+	return node->hit + node->children_hit;
+}
+
 int register_callchain_param(struct callchain_param *param);
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
-- 
1.6.2.3

