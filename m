Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbZHGHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbZHGHkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbZHGHkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbZHGHkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:40:40 -0400
Date: Fri, 7 Aug 2009 07:39:36 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, penberg@cs.helsinki.fi, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
References: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf tools: Fix call-chain cumul hit based sub-total (fractal mode)
Message-ID: <tip-35281b7c4d6f4ae33e6c3e3b0920e86a99c60aa2@git.kernel.org>
Git-Commit-ID: 35281b7c4d6f4ae33e6c3e3b0920e86a99c60aa2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 07:39:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35281b7c4d6f4ae33e6c3e3b0920e86a99c60aa2
Gitweb:     http://git.kernel.org/tip/35281b7c4d6f4ae33e6c3e3b0920e86a99c60aa2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 7 Aug 2009 07:11:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 09:37:23 +0200

perf tools: Fix call-chain cumul hit based sub-total (fractal mode)

The callchain fractal mode builds each new total hits in a new
branch of profiling by using the parent's hits of the current
branch plus the hits of the children.

This is wrong, the total hits of a branch should be made of the
sum of every children hits, we must ignore the parent hits in
this scope.

This patch also fixes another mistake with the hit counting.

Now the rates are correct.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1249621865-9325-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
