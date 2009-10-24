Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZJXBGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZJXBGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZJXBEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZJXBEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:44 -0400
Date: Sat, 24 Oct 2009 01:03:59 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
References: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Fix missing top level callchain
Message-ID: <tip-af0a6fa46388e1e0c2d1a672aad84f8f6ef0b20b@git.kernel.org>
Git-Commit-ID: af0a6fa46388e1e0c2d1a672aad84f8f6ef0b20b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af0a6fa46388e1e0c2d1a672aad84f8f6ef0b20b
Gitweb:     http://git.kernel.org/tip/af0a6fa46388e1e0c2d1a672aad84f8f6ef0b20b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 22 Oct 2009 23:23:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 07:55:16 +0200

perf tools: Fix missing top level callchain

While recursively printing the branches of each callchains, we
forget to display the root. It is never printed.

Say we have:

    symbol
    f1
    f2
     |
     -------- f3
     |        f4
     |
     ---------f5
              f6

Actually we never see that, instead it displays:

    symbol
    |
    --------- f3
    |         f4
    |
    --------- f5
              f6

However f1 is always the same than "symbol" and if we are
sorting by symbols first then "symbol", f1 and f2 will be well
aligned like in the above example, so displaying f1 looks
redundant here.

But if we are sorting by something else first (dso, comm,
etc...), displaying f1 doesn't look redundant but rather
necessary because the symbol is not well aligned anymore with
its callchain:

     comm     dso        symbol
     f1
     f2
     |
     --------- [...]

And we want the callchain to be obvious.
So we fix the bug by printing the root branch, but we also
filter its first entry if we are sorting by symbols first.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c |   40 +++++++++++++++++++++++++++++++++-------
 tools/perf/util/sort.c      |   10 +++++++---
 tools/perf/util/sort.h      |    1 +
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bee207c..3d8c522 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -122,8 +122,8 @@ static void init_rem_hits(void)
 }
 
 static size_t
-callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			u64 total_samples, int depth, int depth_mask)
+__callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+			   u64 total_samples, int depth, int depth_mask)
 {
 	struct rb_node *node, *next;
 	struct callchain_node *child;
@@ -174,9 +174,9 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 						      new_total,
 						      cumul);
 		}
-		ret += callchain__fprintf_graph(fp, child, new_total,
-						depth + 1,
-						new_depth_mask | (1 << depth));
+		ret += __callchain__fprintf_graph(fp, child, new_total,
+						  depth + 1,
+						  new_depth_mask | (1 << depth));
 		node = next;
 	}
 
@@ -197,6 +197,33 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 }
 
 static size_t
+callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+			 u64 total_samples)
+{
+	struct callchain_list *chain;
+	int i = 0;
+	int ret = 0;
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+
+		if (!i++ && sort_by_sym_first)
+			continue;
+
+		if (chain->sym)
+			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)(long)chain->ip);
+	}
+
+	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1);
+
+	return ret;
+}
+
+static size_t
 callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 			u64 total_samples)
 {
@@ -244,8 +271,7 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 			break;
 		case CHAIN_GRAPH_ABS: /* Falldown */
 		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain,
-							total_samples, 1, 1);
+			ret += callchain__fprintf_graph(fp, chain, total_samples);
 		case CHAIN_NONE:
 		default:
 			break;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 40c9acd..60ced70 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -5,8 +5,9 @@ char		default_parent_pattern[] = "^sys_|^do_page_fault";
 char		*parent_pattern = default_parent_pattern;
 char		default_sort_order[] = "comm,dso,symbol";
 char		*sort_order = default_sort_order;
-int sort__need_collapse = 0;
-int sort__has_parent = 0;
+int		sort__need_collapse = 0;
+int		sort__has_parent = 0;
+int		sort_by_sym_first;
 
 unsigned int dsos__col_width;
 unsigned int comms__col_width;
@@ -265,6 +266,10 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}
 
+		if (list_empty(&hist_entry__sort_list) &&
+		    !strcmp(sd->name, "symbol"))
+			sort_by_sym_first = true;
+
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
 
@@ -273,4 +278,3 @@ int sort_dimension__add(const char *tok)
 
 	return -ESRCH;
 }
-
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 13806d7..24c2b70 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -39,6 +39,7 @@ extern struct sort_entry sort_parent;
 extern unsigned int dsos__col_width;
 extern unsigned int comms__col_width;
 extern unsigned int threads__col_width;
+extern int sort_by_sym_first;
 
 struct hist_entry {
 	struct rb_node		rb_node;
