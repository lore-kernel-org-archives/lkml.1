Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZGBTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZGBTnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZGBTnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:43:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZGBTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:43:11 -0400
Date: Thu, 2 Jul 2009 19:42:31 GMT
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
In-Reply-To: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
References: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Set the minimum percent for callchains to be displayed
Message-ID: <tip-c20ab37ef30f4a874cf27e84c12c73e584e6f5cc@git.kernel.org>
Git-Commit-ID: c20ab37ef30f4a874cf27e84c12c73e584e6f5cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 19:42:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c20ab37ef30f4a874cf27e84c12c73e584e6f5cc
Gitweb:     http://git.kernel.org/tip/c20ab37ef30f4a874cf27e84c12c73e584e6f5cc
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 20:14:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 21:38:37 +0200

perf_counter tools: Set the minimum percent for callchains to be displayed

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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   45 ++++++++++++++++++++++++++++++++----------
 tools/perf/util/callchain.c |   19 ++++++++++-------
 tools/perf/util/callchain.h |    6 +++-
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0ca4638..e8c9817 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -60,6 +60,7 @@ static regex_t		parent_regex;
 static int		exclude_other = 1;
 static int		callchain;
 static enum chain_mode	callchain_mode;
+static double		callchain_min_percent = 0.0;
 
 static u64		sample_type;
 
@@ -1224,7 +1225,7 @@ static void collapse__resort(void)
 
 static struct rb_root output_hists;
 
-static void output__insert_entry(struct hist_entry *he)
+static void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 {
 	struct rb_node **p = &output_hists.rb_node;
 	struct rb_node *parent = NULL;
@@ -1232,9 +1233,11 @@ static void output__insert_entry(struct hist_entry *he)
 
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
@@ -1251,11 +1254,14 @@ static void output__insert_entry(struct hist_entry *he)
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
@@ -1267,7 +1273,7 @@ static void output__resort(void)
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n);
+		output__insert_entry(n, min_callchain_hits);
 	}
 }
 
@@ -1801,7 +1807,7 @@ done:
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort();
+	output__resort(total);
 	output__fprintf(stdout, total);
 
 	return rc;
@@ -1811,19 +1817,36 @@ static int
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
 
@@ -1850,9 +1873,9 @@ static const struct option options[] = {
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
