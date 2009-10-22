Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZJVVX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZJVVX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZJVVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:23:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:38015 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZJVVX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x+P5Ygy36e7Dpz80+V/aCQW/Zi3BCJ+rRVOQVmJISt6JsnrsBqH8V38q7wOpS2luV2
         eFVkLrd2zfBV4uSPexeiMb+NvYAfnQuqc9gx1EFdV3H8Ebtyi6HtfZpUbWJv69gJdMUa
         +CbZxAahMlT0+/JG2YWmprvaRiM7A2q+4lcUw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>
Subject: [PATCH 1/3] perf tools: Fix missing top level callchain
Date: Thu, 22 Oct 2009 23:23:22 +0200
Message-Id: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While recursively printing the branches of each callchains, we forget
to display the root. It is never printed.

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

However f1 is always the same than "symbol" and if we are sorting by
symbols first then "symbol", f1 and f2 will be well aligned like in the
above example, so displaying f1 looks redundant here.

But if we are sorting by something else first (dso, comm, etc...),
displaying f1 doesn't look redundant but rather necessary because the
symbol is not well aligned anymore with its callchain:

     comm     dso        symbol
     f1
     f2
     |
     --------- [...]

And we want the callchain to be obvious.
So we fix the bug by printing the root branch, but we also filter its
first entry if we are sorting by symbols first.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
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
-- 
1.6.2.3

