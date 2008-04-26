Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYDZTkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYDZTkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbYDZTjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:39:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbYDZTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:39:53 -0400
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080424150324.802695381@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 21:38:54 +0200
Message-Id: <1209238735.6441.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> Hi Ingo,
> 
> Here is a rather large patchset applying kernel instrumentation to
> sched-devel.git. It includes, mainly :

I saw this land in sched-devel, how about this:

---
Subject: sched: de-uglyfy marker impact

These trace_mark() things look like someone puked all over the code,
lets hide the ugly bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |   24 ++++++++----------------
 kernel/sched_trace.h |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 16 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -71,7 +71,6 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
-#include <linux/marker.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -745,6 +744,8 @@ static void update_rq_clock(struct rq *r
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
+#include "sched_trace.h"
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -2258,8 +2259,7 @@ void wait_task_inactive(struct task_stru
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_mark(kernel_sched_wait_task, "pid %d state %ld",
-			p->pid, p->state);
+		trace_kernel_sched_wait(p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		task_rq_unlock(rq, &flags);
@@ -2603,9 +2603,7 @@ out_activate:
 	success = 1;
 
 out_running:
-	trace_mark(kernel_sched_wakeup,
-		"pid %d state %ld ## rq %p task %p rq->curr %p",
-		p->pid, p->state, rq, p, rq->curr);
+	trace_kernel_sched_wakeup(rq, p);
 	check_preempt_curr(rq, p);
 
 	p->state = TASK_RUNNING;
@@ -2736,9 +2734,7 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
-	trace_mark(kernel_sched_wakeup_new,
-		"pid %d state %ld ## rq %p task %p rq->curr %p",
-		p->pid, p->state, rq, p, rq->curr);
+	trace_kernel_sched_wakeup_new(rq, p);
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -2911,11 +2907,8 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_mark(kernel_sched_schedule,
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		prev->pid, next->pid, prev->state,
-		rq, prev, next);
+
+	trace_kernel_sched_switch(rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3148,8 +3141,7 @@ static void sched_migrate_task(struct ta
 	    || unlikely(cpu_is_offline(dest_cpu)))
 		goto out;
 
-	trace_mark(kernel_sched_migrate_task, "pid %d state %ld dest_cpu %d",
-		p->pid, p->state, dest_cpu);
+	trace_kernel_sched_migrate_task(p, cpu_of(rq), dest_cpu);
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
Index: linux-2.6-2/kernel/sched_trace.h
===================================================================
--- /dev/null
+++ linux-2.6-2/kernel/sched_trace.h
@@ -0,0 +1,41 @@
+#include <linux/marker.h>
+
+static inline void trace_kernel_sched_wait(struct task_struct *p)
+{
+	trace_mark(kernel_sched_wait_task, "pid %d state %ld",
+			p->pid, p->state);
+}
+
+static inline
+void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)
+{
+	trace_mark(kernel_sched_wakeup,
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			p->pid, p->state, rq, p, rq->curr);
+}
+
+static inline
+void trace_kernel_sched_wakeup_new(struct rq *rq, struct task_struct *p)
+{
+	trace_mark(kernel_sched_wakeup_new,
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			p->pid, p->state, rq, p, rq->curr);
+}
+
+static inline void trace_kernel_sched_switch(struct rq *rq,
+		struct task_struct *prev, struct task_struct *next)
+{
+	trace_mark(kernel_sched_schedule,
+			"prev_pid %d next_pid %d prev_state %ld "
+			"## rq %p prev %p next %p",
+			prev->pid, next->pid, prev->state,
+			rq, prev, next);
+}
+
+static inline void
+trace_kernel_sched_migrate_task(struct task_struct *p, int src, int dst)
+{
+	trace_mark(kernel_sched_migrate_task,
+			"pid %d state %ld dest_cpu %d",
+			p->pid, p->state, dst);
+}


