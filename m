Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZJHTE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZJHTE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759417AbZJHTE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:04:56 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53854 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbZJHTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l59f+h9hjO5JUjLEPGwZKJNCvrgOjPuhR8P79JzklqcKf+Kp3iWwOpPM62y9dRxLp+
         LWc2UrAfZ4GvdWsYzUeZ7xYRrdD6dnbyk+BW72iOGESDqlZwc4KOd9iIVdQISA5M8m3J
         FDSJku408OPcftn8aIJRwKFzWWx+CgAmn6Vxw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Fix thread comm resolution in perf sched
Date: Thu,  8 Oct 2009 21:04:17 +0200
Message-Id: <1255028657-11158-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255027712-10768-1-git-send-email-fweisbec@gmail.com>
References: <1255027712-10768-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 9a92b479b2f088ee2d3194243f4c8e59b1b8c9c2.
("perf tools: Improve thread comm resolution in perf sched")

The fix was wrong.

We are failing to resolve thread names in perf sched because the table
of threads we are building, on top of comm events, has a per process
granularity. But perf sched, unlike the other perf tools, needs a per
thread granularity as we are profiling every tasks individually.

So fix it by building our threads table using the tid instead of the pid
as the thread identifier.

v2: Revert the previous fix that was wrong

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-sched.c |   46 +++++--------------------------------------
 tools/perf/util/thread.c   |   32 ++++++-----------------------
 tools/perf/util/thread.h   |    3 --
 3 files changed, 13 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 25b91e7..6b00529 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -638,7 +638,7 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct thread *thread;
 
-	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	thread = threads__findnew(event->comm.tid, &threads, &last_match);
 
 	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
 		(void *)(offset + head),
@@ -1034,36 +1034,6 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 	atoms->nb_atoms++;
 }
 
-static struct thread *
-threads__findnew_from_ctx(u32 pid, struct trace_switch_event *switch_event)
-{
-	struct thread *th;
-
-	th = threads__findnew_nocomm(pid, &threads, &last_match);
-	if (th->comm)
-		return th;
-
-	if (pid == switch_event->prev_pid)
-		thread__set_comm(th, switch_event->prev_comm);
-	else
-		thread__set_comm(th, switch_event->next_comm);
-	return th;
-}
-
-static struct thread *
-threads__findnew_from_wakeup(struct trace_wakeup_event *wakeup_event)
-{
-	struct thread *th;
-
-	th =  threads__findnew_nocomm(wakeup_event->pid, &threads, &last_match);
-	if (th->comm)
-		return th;
-
-	thread__set_comm(th, wakeup_event->comm);
-
-	return th;
-}
-
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
 		     struct event *event __used,
@@ -1089,10 +1059,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew_from_ctx(switch_event->prev_pid,
-					      switch_event);
-	sched_in = threads__findnew_from_ctx(switch_event->next_pid,
-					     switch_event);
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1158,7 +1126,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = threads__findnew_from_wakeup(wakeup_event);
+	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1418,10 +1386,8 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew_from_ctx(switch_event->prev_pid,
-					      switch_event);
-	sched_in = threads__findnew_from_ctx(switch_event->next_pid,
-					     switch_event);
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
 
 	curr_thread[this_cpu] = sched_in;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8bd5ca2..3b56aeb 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -6,17 +6,15 @@
 #include "util.h"
 #include "debug.h"
 
-static struct thread *thread__new(pid_t pid, int set_comm)
+static struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = calloc(1, sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
-		if (set_comm) {
-			self->comm = malloc(32);
-			if (self->comm)
-				snprintf(self->comm, 32, ":%d", self->pid);
-		}
+		self->comm = malloc(32);
+		if (self->comm)
+			snprintf(self->comm, 32, ":%d", self->pid);
 		self->maps = RB_ROOT;
 		INIT_LIST_HEAD(&self->removed_maps);
 	}
@@ -52,10 +50,8 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	return ret;
 }
 
-static struct thread *
-__threads__findnew(pid_t pid, struct rb_root *threads,
-		   struct thread **last_match,
-		   int set_comm)
+struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
 {
 	struct rb_node **p = &threads->rb_node;
 	struct rb_node *parent = NULL;
@@ -84,8 +80,7 @@ __threads__findnew(pid_t pid, struct rb_root *threads,
 			p = &(*p)->rb_right;
 	}
 
-	th = thread__new(pid, set_comm);
-
+	th = thread__new(pid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, threads);
@@ -96,19 +91,6 @@ __threads__findnew(pid_t pid, struct rb_root *threads,
 }
 
 struct thread *
-threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
-{
-	return __threads__findnew(pid, threads, last_match, 1);
-}
-
-struct thread *
-threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
-			struct thread **last_match)
-{
-	return __threads__findnew(pid, threads, last_match, 0);
-}
-
-struct thread *
 register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 75bc843..845d9b6 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,9 +18,6 @@ int thread__set_comm(struct thread *self, const char *comm);
 struct thread *
 threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
 struct thread *
-threads__findnew_nocomm(pid_t pid, struct rb_root *threads,
-			struct thread **last_match);
-struct thread *
 register_idle_thread(struct rb_root *threads, struct thread **last_match);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-- 
1.6.2.3

