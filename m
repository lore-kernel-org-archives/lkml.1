Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbZIOJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbZIOJfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZIOJf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:35:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:57328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZIOJfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:35:16 -0400
Date: Tue, 15 Sep 2009 09:34:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Clean up PID sorting logic
Message-ID: <tip-b5fae128e41021889777f8ead810cbd2a8b249fc@git.kernel.org>
Git-Commit-ID: b5fae128e41021889777f8ead810cbd2a8b249fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:34:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5fae128e41021889777f8ead810cbd2a8b249fc
Gitweb:     http://git.kernel.org/tip/b5fae128e41021889777f8ead810cbd2a8b249fc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:50 +0200

perf sched: Clean up PID sorting logic

Use a sort list for thread atoms insertion as well - instead of
hardcoded for PID.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   88 +++++++++++++++++++++++--------------------
 tools/perf/util/thread.h   |    8 ++--
 2 files changed, 51 insertions(+), 45 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index cc2dbd5..b72544f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -144,7 +144,7 @@ struct task_atoms {
 	u64			total_runtime;
 };
 
-typedef int (*sort_thread_lat)(struct task_atoms *, struct task_atoms *);
+typedef int (*sort_fn_t)(struct task_atoms *, struct task_atoms *);
 
 static struct rb_root		atom_root, sorted_atom_root;
 
@@ -869,41 +869,22 @@ static struct trace_sched_handler replay_ops  = {
 	.fork_event		= replay_fork_event,
 };
 
-static struct task_atoms *
-thread_atoms_search(struct rb_root *root, struct thread *thread)
-{
-	struct rb_node *node = root->rb_node;
-
-	while (node) {
-		struct task_atoms *atoms;
-
-		atoms = container_of(node, struct task_atoms, node);
-		if (thread->pid > atoms->thread->pid)
-			node = node->rb_left;
-		else if (thread->pid < atoms->thread->pid)
-			node = node->rb_right;
-		else {
-			return atoms;
-		}
-	}
-	return NULL;
-}
-
 struct sort_dimension {
 	const char		*name;
-	sort_thread_lat		cmp;
+	sort_fn_t		cmp;
 	struct list_head	list;
 };
 
 static LIST_HEAD(cmp_pid);
 
 static int
-thread_lat_cmp(struct list_head *list, struct task_atoms *l,
-	       struct task_atoms *r)
+thread_lat_cmp(struct list_head *list, struct task_atoms *l, struct task_atoms *r)
 {
 	struct sort_dimension *sort;
 	int ret = 0;
 
+	BUG_ON(list_empty(list));
+
 	list_for_each_entry(sort, list, list) {
 		ret = sort->cmp(l, r);
 		if (ret)
@@ -913,6 +894,32 @@ thread_lat_cmp(struct list_head *list, struct task_atoms *l,
 	return ret;
 }
 
+static struct task_atoms *
+thread_atoms_search(struct rb_root *root, struct thread *thread,
+			 struct list_head *sort_list)
+{
+	struct rb_node *node = root->rb_node;
+	struct task_atoms key = { .thread = thread };
+
+	while (node) {
+		struct task_atoms *atoms;
+		int cmp;
+
+		atoms = container_of(node, struct task_atoms, node);
+
+		cmp = thread_lat_cmp(sort_list, &key, atoms);
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else {
+			BUG_ON(thread != atoms->thread);
+			return atoms;
+		}
+	}
+	return NULL;
+}
+
 static void
 __thread_latency_insert(struct rb_root *root, struct task_atoms *data,
 			 struct list_head *sort_list)
@@ -1049,18 +1056,18 @@ latency_switch_event(struct trace_switch_event *switch_event,
 	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
 	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
 
-	in_atoms = thread_atoms_search(&atom_root, sched_in);
+	in_atoms = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
 	if (!in_atoms) {
 		thread_atoms_insert(sched_in);
-		in_atoms = thread_atoms_search(&atom_root, sched_in);
+		in_atoms = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
 		if (!in_atoms)
 			die("in-atom: Internal tree error");
 	}
 
-	out_atoms = thread_atoms_search(&atom_root, sched_out);
+	out_atoms = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_atoms) {
 		thread_atoms_insert(sched_out);
-		out_atoms = thread_atoms_search(&atom_root, sched_out);
+		out_atoms = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 		if (!out_atoms)
 			die("out-atom: Internal tree error");
 	}
@@ -1085,7 +1092,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 		return;
 
 	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
-	atoms = thread_atoms_search(&atom_root, wakee);
+	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
 		return;
@@ -1136,7 +1143,6 @@ static void output_lat_thread(struct task_atoms *atom_list)
 
 static int pid_cmp(struct task_atoms *l, struct task_atoms *r)
 {
-
 	if (l->thread->pid < r->thread->pid)
 		return -1;
 	if (l->thread->pid > r->thread->pid)
@@ -1146,8 +1152,8 @@ static int pid_cmp(struct task_atoms *l, struct task_atoms *r)
 }
 
 static struct sort_dimension pid_sort_dimension = {
-	.name = "pid",
-	.cmp = pid_cmp,
+	.name			= "pid",
+	.cmp			= pid_cmp,
 };
 
 static int avg_cmp(struct task_atoms *l, struct task_atoms *r)
@@ -1172,8 +1178,8 @@ static int avg_cmp(struct task_atoms *l, struct task_atoms *r)
 }
 
 static struct sort_dimension avg_sort_dimension = {
-	.name 	= "avg",
-	.cmp	= avg_cmp,
+	.name			= "avg",
+	.cmp			= avg_cmp,
 };
 
 static int max_cmp(struct task_atoms *l, struct task_atoms *r)
@@ -1187,8 +1193,8 @@ static int max_cmp(struct task_atoms *l, struct task_atoms *r)
 }
 
 static struct sort_dimension max_sort_dimension = {
-	.name 	= "max",
-	.cmp	= max_cmp,
+	.name			= "max",
+	.cmp			= max_cmp,
 };
 
 static int switch_cmp(struct task_atoms *l, struct task_atoms *r)
@@ -1202,8 +1208,8 @@ static int switch_cmp(struct task_atoms *l, struct task_atoms *r)
 }
 
 static struct sort_dimension switch_sort_dimension = {
-	.name 	= "switch",
-	.cmp	= switch_cmp,
+	.name			= "switch",
+	.cmp			= switch_cmp,
 };
 
 static int runtime_cmp(struct task_atoms *l, struct task_atoms *r)
@@ -1217,8 +1223,8 @@ static int runtime_cmp(struct task_atoms *l, struct task_atoms *r)
 }
 
 static struct sort_dimension runtime_sort_dimension = {
-	.name 	= "runtime",
-	.cmp	= runtime_cmp,
+	.name			= "runtime",
+	.cmp			= runtime_cmp,
 };
 
 static struct sort_dimension *available_sorts[] = {
@@ -1666,8 +1672,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
 			if (argc)
 				usage_with_options(latency_usage, latency_options);
-			setup_sorting();
 		}
+		setup_sorting();
 		__cmd_lat();
 	} else if (!strncmp(argv[0], "rep", 3)) {
 		trace_handler = &replay_ops;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 634f280..665d1f3 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -4,10 +4,10 @@
 #include "symbol.h"
 
 struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
+	struct rb_node		rb_node;
+	struct list_head	maps;
+	pid_t			pid;
+	char			*comm;
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
