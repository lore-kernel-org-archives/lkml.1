Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZGEFkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZGEFkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 01:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZGEFjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 01:39:33 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53375 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZGEFj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 01:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=isYk9ujMOldyXAn2v+6rLEtc77ZCINAtR/OZhb/34nh6nGFdm37y+reS5f4v8VifhW
         zJJoE/wX2F/BSmWctBxqIECjQ7qfcfRQEdJfljeCnOlF49cTaYI7APMfCb7vJ5bU3/K0
         Ktaf4hou0wzp6g4A9bKPPxPIVxsgDuPxk0HM4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] perf report: Support callchains with relative overhead rate
Date: Sun,  5 Jul 2009 07:39:21 +0200
Message-Id: <1246772361-9960-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current callchain displays the overhead rates as absolute:
relative to the total overhead.

This patch provides relative overhead percentage, in which each
branch of the callchain tree is a independant instrumentated object.

You can produce such output by using the "relative" mode
that you can lower in r, re, rel, etc...

./perf report -s sym -c relative

Example:

     8.46%  [k] copy_user_generic_string
                |
                |--52.01%-- generic_file_aio_read
                |          do_sync_read
                |          vfs_read
                |          |
                |          |--97.20%-- sys_pread64
                |          |          system_call_fastpath
                |          |          pread64
                |          |
                |           --2.81%-- sys_read
                |                     system_call_fastpath
                |                     __read
                |
                |--39.85%-- generic_file_buffered_write
                |          __generic_file_aio_write_nolock
                |          generic_file_aio_write
                |          do_sync_write
                |          reiserfs_file_write
                |          vfs_write
                |          |
                |          |--97.05%-- sys_pwrite64
                |          |          system_call_fastpath
                |          |          __pwrite64
                |          |
                |           --2.95%-- sys_write
                |                     system_call_fastpath
                |                     __write_nocancel
[...]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |   58 ++++++++++++++++++++----------
 tools/perf/util/callchain.c |   84 +++++++++++++++++++++++++++++++++++--------
 tools/perf/util/callchain.h |   21 ++++++++---
 3 files changed, 123 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8bd5865..ac9fb56 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -60,9 +60,14 @@ static regex_t		parent_regex;
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "graph,0.5";
+
 static int		callchain;
-static enum chain_mode	callchain_mode;
-static double		callchain_min_percent = 0.5;
+
+static
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_ABS,
+	.min_percent = 0.5
+};
 
 static u64		sample_type;
 
@@ -846,9 +851,15 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	struct callchain_node *child;
 	struct callchain_list *chain;
 	int new_depth_mask = depth_mask;
+	u64 new_total;
 	size_t ret = 0;
 	int i;
 
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->cumul_hit;
+	else
+		new_total = total_samples;
+
 	node = rb_first(&self->rb_root);
 	while (node) {
 		child = rb_entry(node, struct callchain_node, rb_node);
@@ -873,10 +884,10 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 				continue;
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
-						      total_samples,
+						      new_total,
 						      child->cumul_hit);
 		}
-		ret += callchain__fprintf_graph(fp, child, total_samples,
+		ret += callchain__fprintf_graph(fp, child, new_total,
 						depth + 1,
 						new_depth_mask | (1 << depth));
 		node = next;
@@ -925,13 +936,18 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
-		if (callchain_mode == FLAT) {
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
 			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
 						     percent);
 			ret += callchain__fprintf_flat(fp, chain, total_samples);
-		} else if (callchain_mode == GRAPH) {
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
 			ret += callchain__fprintf_graph(fp, chain,
 							total_samples, 1, 1);
+		default:
+			break;
 		}
 		ret += fprintf(fp, "\n");
 		rb_node = rb_next(rb_node);
@@ -1219,14 +1235,9 @@ static void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
-	if (callchain) {
-		if (callchain_mode == FLAT)
-			sort_chain_flat(&he->sorted_chain, &he->callchain,
-					min_callchain_hits);
-		else if (callchain_mode == GRAPH)
-			sort_chain_graph(&he->sorted_chain, &he->callchain,
-					 min_callchain_hits);
-	}
+	if (callchain)
+		callchain_param.sort(&he->sorted_chain, &he->callchain,
+				      min_callchain_hits, &callchain_param);
 
 	while (*p != NULL) {
 		parent = *p;
@@ -1249,7 +1260,7 @@ static void output__resort(u64 total_samples)
 	struct rb_root *tree = &hist;
 	u64 min_callchain_hits;
 
-	min_callchain_hits = total_samples * (callchain_min_percent / 100);
+	min_callchain_hits = total_samples * (callchain_param.min_percent / 100);
 
 	if (sort__need_collapse)
 		tree = &collapse_hists;
@@ -1829,22 +1840,31 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	/* get the output mode */
 	if (!strncmp(tok, "graph", strlen(arg)))
-		callchain_mode = GRAPH;
+		callchain_param.mode = CHAIN_GRAPH_ABS;
 
 	else if (!strncmp(tok, "flat", strlen(arg)))
-		callchain_mode = FLAT;
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "relative", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
 	else
 		return -1;
 
 	/* get the min percentage */
 	tok = strtok(NULL, ",");
 	if (!tok)
-		return 0;
+		goto setup;
 
-	callchain_min_percent = strtod(tok, &endptr);
+	callchain_param.min_percent = strtod(tok, &endptr);
 	if (tok == endptr)
 		return -1;
 
+setup:
+	if (register_callchain_param(&callchain_param) < 0) {
+		fprintf(stderr, "Can't register callchain params\n");
+		return -1;
+	}
 	return 0;
 }
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 5d244af..9d3c814 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -32,13 +32,14 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
 
 		switch (mode) {
-		case FLAT:
+		case CHAIN_FLAT:
 			if (rnode->hit < chain->hit)
 				p = &(*p)->rb_left;
 			else
 				p = &(*p)->rb_right;
 			break;
-		case GRAPH:
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
 			if (rnode->cumul_hit < chain->cumul_hit)
 				p = &(*p)->rb_left;
 			else
@@ -53,43 +54,96 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 	rb_insert_color(&chain->rb_node, root);
 }
 
+static void
+__sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		  u64 min_hit)
+{
+	struct callchain_node *child;
+
+	chain_for_each_child(child, node)
+		__sort_chain_flat(rb_root, child, min_hit);
+
+	if (node->hit && node->hit >= min_hit)
+		rb_insert_callchain(rb_root, node, CHAIN_FLAT);
+}
+
 /*
  * Once we get every callchains from the stream, we can now
  * sort them by hit
  */
-void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
-		     u64 min_hit)
+static void
+sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		u64 min_hit, struct callchain_param *param __used)
+{
+	__sort_chain_flat(rb_root, node, min_hit);
+}
+
+static void __sort_chain_graph_abs(struct callchain_node *node,
+				   u64 min_hit)
 {
 	struct callchain_node *child;
 
-	chain_for_each_child(child, node)
-		sort_chain_flat(rb_root, child, min_hit);
+	node->rb_root = RB_ROOT;
 
-	if (node->hit && node->hit >= min_hit)
-		rb_insert_callchain(rb_root, node, FLAT);
+	chain_for_each_child(child, node) {
+		__sort_chain_graph_abs(child, min_hit);
+		if (child->cumul_hit >= min_hit)
+			rb_insert_callchain(&node->rb_root, child,
+					    CHAIN_GRAPH_ABS);
+	}
+}
+
+static void
+sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_node *chain_root,
+		     u64 min_hit, struct callchain_param *param __used)
+{
+	__sort_chain_graph_abs(chain_root, min_hit);
+	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
-static void __sort_chain_graph(struct callchain_node *node, u64 min_hit)
+static void __sort_chain_graph_rel(struct callchain_node *node,
+				   double min_percent)
 {
 	struct callchain_node *child;
+	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
+	min_hit = node->cumul_hit * min_percent / 100.0;
 
 	chain_for_each_child(child, node) {
-		__sort_chain_graph(child, min_hit);
+		__sort_chain_graph_rel(child, min_percent);
 		if (child->cumul_hit >= min_hit)
-			rb_insert_callchain(&node->rb_root, child, GRAPH);
+			rb_insert_callchain(&node->rb_root, child,
+					    CHAIN_GRAPH_REL);
 	}
 }
 
-void
-sort_chain_graph(struct rb_root *rb_root, struct callchain_node *chain_root,
-		 u64 min_hit)
+static void
+sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
+		     u64 min_hit __used, struct callchain_param *param)
 {
-	__sort_chain_graph(chain_root, min_hit);
+	__sort_chain_graph_rel(chain_root, param->min_percent);
 	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
+int register_callchain_param(struct callchain_param *param)
+{
+	switch (param->mode) {
+	case CHAIN_GRAPH_ABS:
+		param->sort = sort_chain_graph_abs;
+		break;
+	case CHAIN_GRAPH_REL:
+		param->sort = sort_chain_graph_rel;
+		break;
+	case CHAIN_FLAT:
+		param->sort = sort_chain_flat;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
 /*
  * Create a child for a parent. If inherit_children, then the new child
  * will become the new parent of it's parent children
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index f3e4776..7812122 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,8 +7,9 @@
 #include "symbol.h"
 
 enum chain_mode {
-	FLAT,
-	GRAPH
+	CHAIN_FLAT,
+	CHAIN_GRAPH_ABS,
+	CHAIN_GRAPH_REL
 };
 
 struct callchain_node {
@@ -23,6 +24,17 @@ struct callchain_node {
 	u64			cumul_hit; /* hit + hits of children */
 };
 
+struct callchain_param;
+
+typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_node *,
+				 u64, struct callchain_param *);
+
+struct callchain_param {
+	enum chain_mode 	mode;
+	double			min_percent;
+	sort_chain_func_t	sort;
+};
+
 struct callchain_list {
 	u64			ip;
 	struct symbol		*sym;
@@ -36,10 +48,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 }
 
+int register_callchain_param(struct callchain_param *param);
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
-void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
-		     u64 min_hit);
-void sort_chain_graph(struct rb_root *rb_root, struct callchain_node *node,
-		      u64 min_hit);
 #endif
-- 
1.6.2.3

