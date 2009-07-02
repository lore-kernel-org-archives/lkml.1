Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZGBS7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZGBS7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZGBS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbZGBS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:58:56 -0400
Date: Thu, 2 Jul 2009 18:58:23 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246550301-8954-3-git-send-email-fweisbec@gmail.com>
References: <1246550301-8954-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf report: Add support for callchain graph output
Message-ID: <tip-4eb3e4788b8a5e220a0aeb590f88c28850726ebe@git.kernel.org>
Git-Commit-ID: 4eb3e4788b8a5e220a0aeb590f88c28850726ebe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 18:58:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4eb3e4788b8a5e220a0aeb590f88c28850726ebe
Gitweb:     http://git.kernel.org/tip/4eb3e4788b8a5e220a0aeb590f88c28850726ebe
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 17:58:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 20:47:15 +0200

perf report: Add support for callchain graph output

Currently, the printing of callchains is done in a single
vertical level, this is the "flat" mode:

8.25%  [k] copy_user_generic_string
             4.19%
                copy_user_generic_string
                generic_file_aio_read
                do_sync_read
                vfs_read
                sys_pread64
                system_call_fastpath
                pread64

This patch introduces a new "graph" mode which provides a
hierarchical output of factorized paths recursively sorted:

 8.25%  [k] copy_user_generic_string
                |
                |--4.31%-- generic_file_aio_read
                |          do_sync_read
                |          vfs_read
                |          |
                |          |--4.19%-- sys_pread64
                |          |          system_call_fastpath
                |          |          pread64
                |          |
                |           --0.12%-- sys_read
                |                     system_call_fastpath
                |                     __read
                |
                |--3.24%-- generic_file_buffered_write
                |          __generic_file_aio_write_nolock
                |          generic_file_aio_write
                |          do_sync_write
                |          reiserfs_file_write
                |          vfs_write
                |          |
                |          |--3.14%-- sys_pwrite64
                |          |          system_call_fastpath
                |          |          __pwrite64
                |          |
                |           --0.10%-- sys_write
[...]

The command line has then changed.

By providing the -c option, the callchain will output in the
flat mode by default.

But you can override it:

    perf report -c graph

or

    perf report -c flat

You can also pass the abreviated mode:

    perf report -c g

or

    perf report -c gra

will both make use of the graph mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246550301-8954-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |  141 ++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/callchain.c |   51 +++++++++++++---
 tools/perf/util/callchain.h |   11 +++-
 3 files changed, 185 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b44476c..0ca4638 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -59,6 +59,7 @@ static regex_t		parent_regex;
 
 static int		exclude_other = 1;
 static int		callchain;
+static enum chain_mode	callchain_mode;
 
 static u64		sample_type;
 
@@ -787,8 +788,103 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	return cmp;
 }
 
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%s", "                ");
+
+	for (i = 0; i < depth; i++)
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|          ");
+		else
+			ret += fprintf(fp, "           ");
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
 static size_t
-callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
+ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
+		       int depth_mask, int count, u64 total_samples,
+		       int hits)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%s", "                ");
+	for (i = 0; i < depth; i++) {
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|");
+		else
+			ret += fprintf(fp, " ");
+		if (!count && i == depth - 1) {
+			double percent;
+
+			percent = hits * 100.0 / total_samples;
+			ret += fprintf(fp, "--%2.2f%%-- ", percent);
+		} else
+			ret += fprintf(fp, "%s", "          ");
+	}
+	if (chain->sym)
+		ret += fprintf(fp, "%s\n", chain->sym->name);
+	else
+		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+
+	return ret;
+}
+
+static size_t
+callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+			u64 total_samples, int depth, int depth_mask)
+{
+	struct rb_node *node, *next;
+	struct callchain_node *child;
+	struct callchain_list *chain;
+	int new_depth_mask = depth_mask;
+	size_t ret = 0;
+	int i;
+
+	node = rb_first(&self->rb_root);
+	while (node) {
+		child = rb_entry(node, struct callchain_node, rb_node);
+
+		/*
+		 * The depth mask manages the output of pipes that show
+		 * the depth. We don't want to keep the pipes of the current
+		 * level for the last child of this depth
+		 */
+		next = rb_next(node);
+		if (!next)
+			new_depth_mask &= ~(1 << (depth - 1));
+
+		/*
+		 * But we keep the older depth mask for the line seperator
+		 * to keep the level link until we reach the last child
+		 */
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask);
+		i = 0;
+		list_for_each_entry(chain, &child->val, list) {
+			if (chain->ip >= PERF_CONTEXT_MAX)
+				continue;
+			ret += ipchain__fprintf_graph(fp, chain, depth,
+						      new_depth_mask, i++,
+						      total_samples,
+						      child->cumul_hit);
+		}
+		ret += callchain__fprintf_graph(fp, child, total_samples,
+						depth + 1,
+						new_depth_mask | (1 << depth));
+		node = next;
+	}
+
+	return ret;
+}
+
+static size_t
+callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
+			u64 total_samples)
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
@@ -796,7 +892,7 @@ callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
 	if (!self)
 		return 0;
 
-	ret += callchain__fprintf(fp, self->parent, total_samples);
+	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
 
 
 	list_for_each_entry(chain, &self->val, list) {
@@ -826,8 +922,13 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
-		ret += fprintf(fp, "           %6.2f%%\n", percent);
-		ret += callchain__fprintf(fp, chain, total_samples);
+		if (callchain_mode == FLAT) {
+			ret += fprintf(fp, "           %6.2f%%\n", percent);
+			ret += callchain__fprintf_flat(fp, chain, total_samples);
+		} else if (callchain_mode == GRAPH) {
+			ret += callchain__fprintf_graph(fp, chain,
+							total_samples, 1, 1);
+		}
 		ret += fprintf(fp, "\n");
 		rb_node = rb_next(rb_node);
 	}
@@ -1129,8 +1230,12 @@ static void output__insert_entry(struct hist_entry *he)
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
-	if (callchain)
-		sort_chain_to_rbtree(&he->sorted_chain, &he->callchain);
+	if (callchain) {
+		if (callchain_mode == FLAT)
+			sort_chain_flat(&he->sorted_chain, &he->callchain);
+		else if (callchain_mode == GRAPH)
+			sort_chain_graph(&he->sorted_chain, &he->callchain);
+	}
 
 	while (*p != NULL) {
 		parent = *p;
@@ -1702,6 +1807,26 @@ done:
 	return rc;
 }
 
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset __used)
+{
+	callchain = 1;
+
+	if (!arg)
+		return 0;
+
+	if (!strncmp(arg, "graph", strlen(arg)))
+		callchain_mode = GRAPH;
+
+	else if (!strncmp(arg, "flat", strlen(arg)))
+		callchain_mode = FLAT;
+	else
+		return -1;
+
+	return 0;
+}
+
 static const char * const report_usage[] = {
 	"perf report [<options>] <command>",
 	NULL
@@ -1725,7 +1850,9 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
+	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type",
+		     "Display callchains with output_type: flat, graph. "
+		     "Default to flat", &parse_callchain_opt, "flat"),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 3c4a91f..a9873aa 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -19,9 +19,9 @@
 #define chain_for_each_child(child, parent)	\
 	list_for_each_entry(child, &parent->children, brothers)
 
-
 static void
-rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
+rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
+		    enum chain_mode mode)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -31,10 +31,22 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
 
-		if (rnode->hit < chain->hit)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
+		switch (mode) {
+		case FLAT:
+			if (rnode->hit < chain->hit)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			break;
+		case GRAPH:
+			if (rnode->cumul_hit < chain->cumul_hit)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			break;
+		default:
+			break;
+		}
 	}
 
 	rb_link_node(&chain->rb_node, parent, p);
@@ -45,15 +57,36 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
  * Once we get every callchains from the stream, we can now
  * sort them by hit
  */
-void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
+void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node)
 {
 	struct callchain_node *child;
 
 	chain_for_each_child(child, node)
-		sort_chain_to_rbtree(rb_root, child);
+		sort_chain_flat(rb_root, child);
 
 	if (node->hit)
-		rb_insert_callchain(rb_root, node);
+		rb_insert_callchain(rb_root, node, FLAT);
+}
+
+static void __sort_chain_graph(struct callchain_node *node)
+{
+	struct callchain_node *child;
+
+	node->rb_root = RB_ROOT;
+	node->cumul_hit = node->hit;
+
+	chain_for_each_child(child, node) {
+		__sort_chain_graph(child);
+		rb_insert_callchain(&node->rb_root, child, GRAPH);
+		node->cumul_hit += child->cumul_hit;
+	}
+}
+
+void
+sort_chain_graph(struct rb_root *rb_root, struct callchain_node *chain_root)
+{
+	__sort_chain_graph(chain_root);
+	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
 /*
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index e9bd5e8..dfa5600 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -6,15 +6,21 @@
 #include <linux/rbtree.h>
 #include "symbol.h"
 
+enum chain_mode {
+	FLAT,
+	GRAPH
+};
 
 struct callchain_node {
 	struct callchain_node	*parent;
 	struct list_head	brothers;
 	struct list_head	children;
 	struct list_head	val;
-	struct rb_node		rb_node;
+	struct rb_node		rb_node; /* to sort nodes in an rbtree */
+	struct rb_root		rb_root; /* sorted tree of children */
 	unsigned int		val_nr;
 	u64			hit;
+	u64			cumul_hit; /* hit + hits of children */
 };
 
 struct callchain_list {
@@ -32,5 +38,6 @@ static inline void callchain_init(struct callchain_node *node)
 
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
-void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node);
+void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node);
+void sort_chain_graph(struct rb_root *rb_root, struct callchain_node *node);
 #endif
