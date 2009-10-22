Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZJVVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZJVVXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZJVVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:23:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:55906 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbZJVVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u2nVHPuvf99ja59Haj7YP4KC5yBSh6g0pmuBCwWPMw5BOLlBPQP5hqF+evMIyjDfHr
         SoBIy2E4HZ751FubaGWK/LkKfg8s/UhgUSn750mrqi3KpOC4tU81XArvlfzOEykZ02tI
         74Rt/baOWoQw4XdDMlI6inBldYfVXvpoPzmu0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>
Subject: [PATCH 2/3] perf tools: Bind callchains to the first sort dimension column
Date: Thu, 22 Oct 2009 23:23:23 +0200
Message-Id: <1256246604-17156-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
References: <1256246604-17156-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the callchains are displayed using a constant left margin.
So depending on the current sort dimension configuration, callchains
may appear to be well attached to the first sort dimension column field
which is mostly the case, except when the first dimension of sorting is
done by comm, because these are right aligned.

This patch binds the callchain to the first letter in the first column,
whatever type of column it is (dso, comm, symbol).
Before:

     0.80%             perf  [k] __lock_acquire
             __lock_acquire
             lock_acquire
             |
             |--58.33%-- _spin_lock
             |          |
             |          |--28.57%-- inotify_should_send_event
             |          |          fsnotify
             |          |          __fsnotify_parent

After:

     0.80%             perf  [k] __lock_acquire
                       __lock_acquire
                       lock_acquire
                       |
                       |--58.33%-- _spin_lock
                       |          |
                       |          |--28.57%-- inotify_should_send_event
                       |          |          fsnotify
                       |          |          __fsnotify_parent

Also, for clarity, we don't put anymore the callchain as is but:

- If we have a top level ancestor in the callchain, start it with a
  first ascii hook.

  Before:

     0.80%             perf  [kernel]                        [k] __lock_acquire
                       __lock_acquire
                         lock_acquire
                       |
                       |--58.33%-- _spin_lock
                       |          |
                       |          |--28.57%-- inotify_should_send_event
                       |          |          fsnotify
                      [..]       [..]

   After:

     0.80%             perf  [kernel]                         [k] __lock_acquire
                       |
                       --- __lock_acquire
                           lock_acquire
                          |
                          |--58.33%-- _spin_lock
                          |          |
                          |          |--28.57%-- inotify_should_send_event
                          |          |          fsnotify
                         [..]       [..]

- Otherwise, if we have several top level ancestors, then display these
  like we did before:

       1.69%           Xorg
                       |
                       |--21.21%-- vread_hpet
                       |          0x7fffd85b46fc
                       |          0x7fffd85b494d
                       |          0x7f4fafb4e54d
                       |
                       |--15.15%-- exaOffscreenAlloc
                       |
                       |--9.09%-- I830WaitLpRing

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
---
 tools/perf/builtin-report.c |   82 +++++++++++++++++++++++++++++++++----------
 tools/perf/util/sort.c      |   18 +++++++--
 tools/perf/util/sort.h      |   10 +++++-
 tools/perf/util/thread.c    |   11 ++++++
 tools/perf/util/thread.h    |    2 +
 5 files changed, 99 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3d8c522..72d5842 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -59,12 +59,28 @@ static struct perf_header *header;
 
 static u64		sample_type;
 
-static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask)
+
+static size_t
+callchain__fprintf_left_margin(FILE *fp, int left_margin)
+{
+	int i;
+	int ret;
+
+	ret = fprintf(fp, "            ");
+
+	for (i = 0; i < left_margin; i++)
+		ret += fprintf(fp, " ");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
+					  int left_margin)
 {
 	int i;
 	size_t ret = 0;
 
-	ret += fprintf(fp, "%s", "                ");
+	ret += callchain__fprintf_left_margin(fp, left_margin);
 
 	for (i = 0; i < depth; i++)
 		if (depth_mask & (1 << i))
@@ -79,12 +95,12 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask)
 static size_t
 ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
 		       int depth_mask, int count, u64 total_samples,
-		       int hits)
+		       int hits, int left_margin)
 {
 	int i;
 	size_t ret = 0;
 
-	ret += fprintf(fp, "%s", "                ");
+	ret += callchain__fprintf_left_margin(fp, left_margin);
 	for (i = 0; i < depth; i++) {
 		if (depth_mask & (1 << i))
 			ret += fprintf(fp, "|");
@@ -123,7 +139,8 @@ static void init_rem_hits(void)
 
 static size_t
 __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			   u64 total_samples, int depth, int depth_mask)
+			   u64 total_samples, int depth, int depth_mask,
+			   int left_margin)
 {
 	struct rb_node *node, *next;
 	struct callchain_node *child;
@@ -164,7 +181,8 @@ __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		 * But we keep the older depth mask for the line seperator
 		 * to keep the level link until we reach the last child
 		 */
-		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask);
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
+						   left_margin);
 		i = 0;
 		list_for_each_entry(chain, &child->val, list) {
 			if (chain->ip >= PERF_CONTEXT_MAX)
@@ -172,11 +190,13 @@ __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
 						      new_total,
-						      cumul);
+						      cumul,
+						      left_margin);
 		}
 		ret += __callchain__fprintf_graph(fp, child, new_total,
 						  depth + 1,
-						  new_depth_mask | (1 << depth));
+						  new_depth_mask | (1 << depth),
+						  left_margin);
 		node = next;
 	}
 
@@ -190,17 +210,19 @@ __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 
 		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
 					      new_depth_mask, 0, new_total,
-					      remaining);
+					      remaining, left_margin);
 	}
 
 	return ret;
 }
 
+
 static size_t
 callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			 u64 total_samples)
+			 u64 total_samples, int left_margin)
 {
 	struct callchain_list *chain;
+	bool printed = false;
 	int i = 0;
 	int ret = 0;
 
@@ -208,17 +230,27 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		if (chain->ip >= PERF_CONTEXT_MAX)
 			continue;
 
-		if (!i++ && sort_by_sym_first)
+		if (!i++ && sort__first_dimension == SORT_SYM)
 			continue;
 
+		if (!printed) {
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "|\n");
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "---");
+
+			left_margin += 3;
+			printed = true;
+		} else
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+
 		if (chain->sym)
-			ret += fprintf(fp, "                %s\n", chain->sym->name);
+			ret += fprintf(fp, " %s\n", chain->sym->name);
 		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
+			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
 	}
 
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1);
+	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
 
 	return ret;
 }
@@ -251,7 +283,7 @@ callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 
 static size_t
 hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
-			      u64 total_samples)
+			      u64 total_samples, int left_margin)
 {
 	struct rb_node *rb_node;
 	struct callchain_node *chain;
@@ -271,7 +303,8 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 			break;
 		case CHAIN_GRAPH_ABS: /* Falldown */
 		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples);
+			ret += callchain__fprintf_graph(fp, chain, total_samples,
+							left_margin);
 		case CHAIN_NONE:
 		default:
 			break;
@@ -316,8 +349,19 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 
 	ret += fprintf(fp, "\n");
 
-	if (callchain)
-		hist_entry_callchain__fprintf(fp, self, total_samples);
+	if (callchain) {
+		int left_margin = 0;
+
+		if (sort__first_dimension == SORT_COMM) {
+			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
+						list);
+			left_margin = se->width ? *se->width : 0;
+			left_margin -= thread__comm_len(self->thread);
+		}
+
+		hist_entry_callchain__fprintf(fp, self, total_samples,
+					      left_margin);
+	}
 
 	return ret;
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 60ced70..b490354 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -7,7 +7,8 @@ char		default_sort_order[] = "comm,dso,symbol";
 char		*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
-int		sort_by_sym_first;
+
+enum sort_type	sort__first_dimension;
 
 unsigned int dsos__col_width;
 unsigned int comms__col_width;
@@ -266,9 +267,18 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}
 
-		if (list_empty(&hist_entry__sort_list) &&
-		    !strcmp(sd->name, "symbol"))
-			sort_by_sym_first = true;
+		if (list_empty(&hist_entry__sort_list)) {
+			if (!strcmp(sd->name, "pid"))
+				sort__first_dimension = SORT_PID;
+			else if (!strcmp(sd->name, "comm"))
+				sort__first_dimension = SORT_COMM;
+			else if (!strcmp(sd->name, "dso"))
+				sort__first_dimension = SORT_DSO;
+			else if (!strcmp(sd->name, "symbol"))
+				sort__first_dimension = SORT_SYM;
+			else if (!strcmp(sd->name, "parent"))
+				sort__first_dimension = SORT_PARENT;
+		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 24c2b70..333e664 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -39,7 +39,7 @@ extern struct sort_entry sort_parent;
 extern unsigned int dsos__col_width;
 extern unsigned int comms__col_width;
 extern unsigned int threads__col_width;
-extern int sort_by_sym_first;
+extern enum sort_type sort__first_dimension;
 
 struct hist_entry {
 	struct rb_node		rb_node;
@@ -54,6 +54,14 @@ struct hist_entry {
 	struct rb_root		sorted_chain;
 };
 
+enum sort_type {
+	SORT_PID,
+	SORT_COMM,
+	SORT_DSO,
+	SORT_SYM,
+	SORT_PARENT
+};
+
 /*
  * configurable sorting bits
  */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index f53fad7..8cb47f1 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -33,6 +33,17 @@ int thread__set_comm(struct thread *self, const char *comm)
 	return self->comm ? 0 : -ENOMEM;
 }
 
+int thread__comm_len(struct thread *self)
+{
+	if (!self->comm_len) {
+		if (!self->comm)
+			return 0;
+		self->comm_len = strlen(self->comm);
+	}
+
+	return self->comm_len;
+}
+
 static size_t thread__fprintf(struct thread *self, FILE *fp)
 {
 	struct rb_node *nd;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1abef3b..53addd7 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -12,9 +12,11 @@ struct thread {
 	pid_t			pid;
 	char			shortname[3];
 	char			*comm;
+	int			comm_len;
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
+int thread__comm_len(struct thread *self);
 struct thread *threads__findnew(pid_t pid);
 struct thread *register_idle_thread(void);
 void thread__insert_map(struct thread *self, struct map *map);
-- 
1.6.2.3

