Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZGBSPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZGBSPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZGBSOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:14:38 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:37552 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbZGBSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mOZqStPEx60w5vceTMmNl7g0c8UeYpMuMk/uF2h2H/E0ANlwXiLJ6ssnU1Fquz+Gin
         R2ZSYE9dE6Xhu9S6bz1KVMHz7isd+QYS0x+rNduY0qbavYFa47lNsP6XPf4VurmgpDrp
         t3rwE5nA4jE42xTX5P5NsFpytfVNv4UfFcXxU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perfcounter: Set the minimum percent for callchains to be displayed
Date: Thu,  2 Jul 2009 20:14:33 +0200
Message-Id: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callchains output may become a burden on a trace because even
rarely hit site are exposed. This can be too much information.

Let the user set a threshold as a minimum percent of hits using
the new pattern for the -c option:

-c mode,min_percent

Example:

$ perf report -s sym -c flat,4

     8.25%  [k] copy_user_generic_string
             4.19%
                copy_user_generic_string
                generic_file_aio_read
                do_sync_read
                vfs_read
                sys_pread64
                system_call_fastpath
                pread64

     5.39%  [k] search_by_key
     4.63%  0x00000000009e0a
     2.36%  [k] memcpy_c
[...]

$ perf report -s sym -c graph,2

     8.25%  [k] copy_user_generic_string
                |
                |--4.31%-- generic_file_aio_read
                |          do_sync_read
                |          vfs_read
                |          |
                |           --4.19%-- sys_pread64
                |                     system_call_fastpath
                |                     pread64
                |
                 --3.24%-- generic_file_buffered_write
                           __generic_file_aio_write_nolock
                           generic_file_aio_write
                           do_sync_write
                           reiserfs_file_write
                           vfs_write
                           |
                            --3.14%-- sys_pwrite64
                                      system_call_fastpath
                                      __pwrite64

     5.39%  [k] search_by_key
                |
                 --2.23%-- reiserfs_update_sd_size

     4.63%  0x00000000009e0a

     2.36%  [k] memcpy_c
[...]

You can also omit it and it will default to 0.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |   45 ++++++++++++++++++++++++++++++++----------
 tools/perf/util/callchain.c |   19 ++++++++++-------
 tools/perf/util/callchain.h |    6 +++-
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a3ec4bd..0e2317d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -58,6 +58,7 @@ static regex_t		parent_regex;
 static int		exclude_other = 1;
 static int		callchain;
 static enum chain_mode	callchain_mode;
+static double		callchain_min_percent = 0.0;
 
 static u64		sample_type;
 
@@ -1219,7 +1220,7 @@ static void collapse__resort(void)
 
 static struct rb_root output_hists;
 
-static void output__insert_entry(struct hist_entry *he)
+static void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 {
 	struct rb_node **p = &output_hists.rb_node;
 	struct rb_node *parent = NULL;
@@ -1227,9 +1228,11 @@ static void output__insert_entry(struct hist_entry *he)
 
 	if (callchain) {
 		if (callchain_mode == FLAT)
-			sort_chain_flat(&he->sorted_chain, &he->callchain);
+			sort_chain_flat(&he->sorted_chain, &he->callchain,
+					min_callchain_hits);
 		else if (callchain_mode == GRAPH)
-			sort_chain_graph(&he->sorted_chain, &he->callchain);
+			sort_chain_graph(&he->sorted_chain, &he->callchain,
+					 min_callchain_hits);
 	}
 
 	while (*p != NULL) {
@@ -1246,11 +1249,14 @@ static void output__insert_entry(struct hist_entry *he)
 	rb_insert_color(&he->rb_node, &output_hists);
 }
 
-static void output__resort(void)
+static void output__resort(u64 total_samples)
 {
 	struct rb_node *next;
 	struct hist_entry *n;
 	struct rb_root *tree = &hist;
+	u64 min_callchain_hits;
+
+	min_callchain_hits = total_samples * (callchain_min_percent / 100);
 
 	if (sort__need_collapse)
 		tree = &collapse_hists;
@@ -1262,7 +1268,7 @@ static void output__resort(void)
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n);
+		output__insert_entry(n, min_callchain_hits);
 	}
 }
 
@@ -1796,7 +1802,7 @@ done:
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort();
+	output__resort(total);
 	output__fprintf(stdout, total);
 
 	return rc;
@@ -1806,19 +1812,36 @@ static int
 parse_callchain_opt(const struct option *opt __used, const char *arg,
 		    int unset __used)
 {
+	char *tok;
+	char *endptr;
+
 	callchain = 1;
 
 	if (!arg)
 		return 0;
 
-	if (!strncmp(arg, "graph", strlen(arg)))
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
 		callchain_mode = GRAPH;
 
-	else if (!strncmp(arg, "flat", strlen(arg)))
+	else if (!strncmp(tok, "flat", strlen(arg)))
 		callchain_mode = FLAT;
 	else
 		return -1;
 
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		return 0;
+
+	callchain_min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
 	return 0;
 }
 
@@ -1843,9 +1866,9 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type",
-		     "Display callchains with output_type: flat, graph. "
-		     "Default to flat", &parse_callchain_opt, "flat"),
+	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
+		     "Display callchains using output_type and min percent threshold. "
+		     "Default: flat,0", &parse_callchain_opt, "flat,100"),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index a9873aa..c9900fe 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -57,18 +57,19 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
  * Once we get every callchains from the stream, we can now
  * sort them by hit
  */
-void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node)
+void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		     u64 min_hit)
 {
 	struct callchain_node *child;
 
 	chain_for_each_child(child, node)
-		sort_chain_flat(rb_root, child);
+		sort_chain_flat(rb_root, child, min_hit);
 
-	if (node->hit)
+	if (node->hit && node->hit >= min_hit)
 		rb_insert_callchain(rb_root, node, FLAT);
 }
 
-static void __sort_chain_graph(struct callchain_node *node)
+static void __sort_chain_graph(struct callchain_node *node, u64 min_hit)
 {
 	struct callchain_node *child;
 
@@ -76,16 +77,18 @@ static void __sort_chain_graph(struct callchain_node *node)
 	node->cumul_hit = node->hit;
 
 	chain_for_each_child(child, node) {
-		__sort_chain_graph(child);
-		rb_insert_callchain(&node->rb_root, child, GRAPH);
+		__sort_chain_graph(child, min_hit);
+		if (child->cumul_hit >= min_hit)
+			rb_insert_callchain(&node->rb_root, child, GRAPH);
 		node->cumul_hit += child->cumul_hit;
 	}
 }
 
 void
-sort_chain_graph(struct rb_root *rb_root, struct callchain_node *chain_root)
+sort_chain_graph(struct rb_root *rb_root, struct callchain_node *chain_root,
+		 u64 min_hit)
 {
-	__sort_chain_graph(chain_root);
+	__sort_chain_graph(chain_root, min_hit);
 	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dfa5600..f3e4776 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -38,6 +38,8 @@ static inline void callchain_init(struct callchain_node *node)
 
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
-void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node);
-void sort_chain_graph(struct rb_root *rb_root, struct callchain_node *node);
+void sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+		     u64 min_hit);
+void sort_chain_graph(struct rb_root *rb_root, struct callchain_node *node,
+		      u64 min_hit);
 #endif
-- 
1.6.2.3

