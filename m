Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZCILE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZCILE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZCILEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:04:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZCILEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:04:45 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <20090309080714.GB24904@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:04:24 +0100
Message-Id: <1236596664.8389.331.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 09:07 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:

> > I see it as a problem, but it's your call.  Dunno if I'd apply it or
> > hold back, given these conflicting reports.
> 
> I think we still want it - as the purpose of the overlap metric 
> is to measure reality. If preemption causes overlap in execution 
> we should not ignore that.
> 
> The fact that your hw triggers it currently is enough of a 
> justification. Gautham's change to load-balancing might have 
> shifted the preemption and migration characteristics on his box 
> just enough to not trigger this - but it does not 'fix' the 
> problem per se.
> 
> Peter, what do you think?

Mostly confusion... trying to reverse engineer wth the patch does, and
why, as the changelog is somewhat silent on the issue, nor are there
comments added to clarify things.

Having something of a cold doesn't really help either..

OK, so staring at this:

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..c670050 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1712,12 +1712,17 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+       u64 runtime;
+
        if (sleep && p->se.last_wakeup) {
-               update_avg(&p->se.avg_overlap,
-                          p->se.sum_exec_runtime - p->se.last_wakeup);
+               runtime = p->se.sum_exec_runtime - p->se.last_wakeup;
                p->se.last_wakeup = 0;
+       } else {
+               runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
        }
 
+       update_avg(&p->se.avg_overlap, runtime);
+
        sched_info_dequeued(p);
        p->sched_class->dequeue_task(rq, p, sleep);
        p->se.on_rq = 0;
---

The idea of avg_overlap is to measure the time between waking someone
and going to sleep yourself. If this overlap time is short for both
tasks, we infer a mutal relation and try to keep these tasks on the same
cpu.

The above patch changes this definition by adding the full run-time on !
sleep dequeues.

We reset prev_sum_exec_runtime in set_next_entity(), iow every time we
start running a task.

Now !sleep dequeues happen mostly with preemption, but also with things
like migration, nice, etc..

Take migration, that would simply add the last full runtime again, even
though it hasn't ran -- that seems most odd.

OK, talked a bit with Ingo, the reason you're doing is that avg_overlap
can easily grow stale.. I can see that happen indeed.

So the 'perfect' thing would be a task-runtime decay, barring that the
preemption thing seems a sane enough hart-beat of a task.

How does the below look to you?

---
 kernel/sched.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4414926..ec7ffdc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4692,6 +4692,19 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->state == TASK_RUNNING) {
+		/*
+		 * In order to avoid avg_overlap growing stale when we are
+		 * indeed overlapping and hence not getting put to sleep, grow
+		 * the avg_overlap on preemption.
+		 */
+		update_avg(&prev->se.avg_overlap, sysctl_sched_migration_cost);
+	}
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 /*
  * Pick up the highest-prio task:
  */
@@ -4768,7 +4781,7 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 
 	if (likely(prev != next)) {


