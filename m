Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZJHOh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZJHOh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZJHOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:37:55 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47559 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZJHOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hEgZ5MGiXZFq0BpjMRPIZLmd4Jh8UoFGmCDhquKYwA8S5SY+SCBfKMAxoDJEZlN9F/
         ruwuxBZI6wQ5pToJOl9Fu6hDEg6N3O5eXQug5H8musNPsP3t0uAzCrQ0iqHJ7w/nBAPo
         qY0c8d/T4yh+XDTEegtOLrwU2CtMjg7CWvxcQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Improve thread comm resolution in perf sched
Date: Thu,  8 Oct 2009 16:37:12 +0200
Message-Id: <1255012632-7882-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we get sched traces that involve a task that was already
created before opening the event, we won't have the comm event
for it.

So if we can't find the comm event for a given thread, we look at the
traces that may contain these informations.

Before:

 ata/1:371             |      0.000 ms |        1 | avg: 3988.693 ms | max: 3988.693 ms |
 kondemand/1:421       |      0.096 ms |        3 | avg:  345.346 ms | max: 1035.989 ms |
 kondemand/0:420       |      0.025 ms |        3 | avg:  421.332 ms | max:  964.014 ms |
 :5124:5124            |      0.103 ms |        5 | avg:   74.082 ms | max:  277.194 ms |
 :6244:6244            |      0.691 ms |        9 | avg:  125.655 ms | max:  271.306 ms |
 firefox:5080          |      0.924 ms |        5 | avg:   53.833 ms | max:  257.828 ms |
 npviewer.bin:6225     |     21.871 ms |       53 | avg:   22.462 ms | max:  220.835 ms |
 :6245:6245            |      9.631 ms |       21 | avg:   41.864 ms | max:  213.349 ms |

After:

 ata/1:371             |      0.000 ms |        1 | avg: 3988.693 ms | max: 3988.693 ms |
 kondemand/1:421       |      0.096 ms |        3 | avg:  345.346 ms | max: 1035.989 ms |
 kondemand/0:420       |      0.025 ms |        3 | avg:  421.332 ms | max:  964.014 ms |
 firefox:5124          |      0.103 ms |        5 | avg:   74.082 ms | max:  277.194 ms |
 npviewer.bin:6244     |      0.691 ms |        9 | avg:  125.655 ms | max:  271.306 ms |
 firefox:5080          |      0.924 ms |        5 | avg:   53.833 ms | max:  257.828 ms |
 npviewer.bin:6225     |     21.871 ms |       53 | avg:   22.462 ms | max:  220.835 ms |
 npviewer.bin:6245     |      9.631 ms |       21 | avg:   41.864 ms | max:  213.349 ms |

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-sched.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/thread.c   |   32 +++++++++++++++++++++++++-------
 tools/perf/util/thread.h   |    3 +++
 3 files changed, 67 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index e1df705..25b91e7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1034,6 +1034,36 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 	atoms->nb_atoms++;
 }
 
+static struct thread *
+threads__findnew_from_ctx(u32 pid, struct trace_switch_event *switch_event)
+{
+	struct thread *th;
+
+	th = threads__findnew_nocomm(pid, &threads, &last_match);
+	if (th->comm)
+		return th;
+
+	if (pid == switch_event->prev_pid)
+		thread__set_comm(th, switch_event->prev_comm);
+	else
+		thread__set_comm(th, switch_event->next_comm);
+	return th;
+}
+
+static struct thread *
+threads__findnew_from_wakeup(struct trace_wakeup_event *wakeup_event)
+{
+	struct thread *th;
+
+	th =  threads__findnew_nocomm(wakeup_event->pid, &threads, &last_match);
+	if (th->comm)
+		return th;
+
+	thread__set_comm(th, wakeup_event->comm);
+
+	return th;
+}
+
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
 		     struct event *event __used,
@@ -1059,8 +1089,10 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
-	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+	sched_out = threads__findnew_from_ctx(switch_event->prev_pid,
+					      switch_event);
+	sched_in = threads__findnew_from_ctx(switch_event->next_pid,
+					     switch_event);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1126,7 +1158,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
+	wakee = threads__findnew_from_wakeup(wakeup_event);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1386,8 +1418,10 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
-	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+	sched_out = threads__findnew_from_ctx(switch_event->prev_pid,
+					      switch_event);
+	sched_in = threads__findnew_from_ctx(switch_event->next_pid,
+					     switch_event);
 
 	curr_thread[this_cpu] = sched_in;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3b56aeb..8bd5ca2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -6,15 +6,17 @@
 #include "util.h"
 #include "debug.h"
 
-static struct thread *thread__new(pid_t pid)
+static struct thread *thread__new(pid_t pid, int set_comm)
 {
 	struct thread *self = calloc(1, sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
+		if (set_comm) {
+			self->comm = malloc(32);
+			if (self->comm)
+				snprintf(self->comm, 32, ":%d", self->pid);
+		}
 		self->maps = RB_ROOT;
 		INIT_LIST_HEAD(&self->removed_maps);
 	}
@@ -50,8 +52,10 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	return ret;
 }
 
-struct thread *
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+static struct thread *
+__threads__findnew(pid_t pid, struct rb_root *threads,
+		   struct thread **last_match,
+		   int set_comm)
 {
 	struct rb_node **p = &threads->rb_node;
 	struct rb_node *parent = NULL;
@@ -80,7 +84,8 @@ threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 			p = &(*p)->rb_right;
 	}
 
-	th = thread__new(pid);
+	th = thread__new(pid, set_comm);
+
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, threads);
@@ -91,6 +96,19 @@ threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 }
 
 struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+{
+	return __threads__findnew(pid, threads, last_match, 1);
+}
+
+struct thread *
+threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
+			struct thread **last_match)
+{
+	return __threads__findnew(pid, threads, last_match, 0);
+}
+
+struct thread *
 register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 845d9b6..75bc843 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,6 +18,9 @@ int thread__set_comm(struct thread *self, const char *comm);
 struct thread *
 threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
 struct thread *
+threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
+			struct thread **last_match);
+struct thread *
 register_idle_thread(struct rb_root *threads, struct thread **last_match);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-- 
1.6.2.3

