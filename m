Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZDFUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZDFUPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZDFUP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:15:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38535 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZDFUP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:15:27 -0400
Date: Mon, 6 Apr 2009 13:15:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090406201524.GF6988@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com> <1238916865.7989.212.camel@tropicana> <20090405171146.GK6893@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061155120.4317@gandalf.stny.rr.com> <20090406161527.GD6988@linux.vnet.ibm.com> <alpine.DEB.2.00.0904061529370.4317@gandalf.stny.rr.com> <20090406194417.GA5936@nowhere> <alpine.DEB.2.00.0904061552260.23509@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904061552260.23509@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 03:52:55PM -0400, Steven Rostedt wrote:
> 
> On Mon, 6 Apr 2009, Frederic Weisbecker wrote:
> > > > 
> > > > > > > So assuming we can't use rcu for this, it would be nice to have a way to
> > > > > > > 'pause' tracing so the current filter can be removed i.e. some version
> > > > > > > of stop_trace()/start_trace() that make sure nothing is still executing
> > > > > > > or can enter filter_match_preds() while the current call->preds is being
> > > > > > > destroyed.  Seems like it would be straightforward to implement for the
> > > > > > > event tracer, since each event maps to a tracepoint that could be
> > > > > > > temporarily unregistered/reregistered, but maybe not so easy for the
> > > > > > > ftrace tracers...
> > > > > > 
> > > > > > In principle, it would be possible to rework RCU so that instead of the
> > > > > > whole idle loop being a quiescent state, there is a single quiescent state
> > > > > > at one point in each idle loop.  The reason that I have been avoiding this
> > > > > > is that there are a lot of idle loops out there, and it would be a bit
> > > > > > annoying to (1) find them all and update them and (2) keep track of all of
> > > > > > them to ensure that new ones cannot slip in without the quiescent state.
> > > > > > 
> > > > > > But it could be done if the need is there.  Simple enough change.
> > > > > > The following patch shows the general approach, assuming that CPUs
> > > > > > are never put to sleep without entering nohz mode.
> > > > > > 
> > > > > > Thoughts?
> > > > > 
> > > > > I think using synchronize_sched() should be good enough for what we need.
> > > > 
> > > > Again, as long as either (1) you are OK with synchronize_sched()
> > > > ignoring preempt-disable sequences in the idle loop or (2) we rework RCU
> > > > to add something like an rcu_idle() call in each idle loop.
> > > 
> > > 3) add "notrace" to the idle functions ;-)
> > > 
> > > But perhaps the rcu_idle might be the best idea.
> > 
> > 
> > And tracing the idle time is also sometimes very useful :-)
> 
> Agreed. I guess choice 2 is the best answer.

Fair enough!

Would one of you please check the placement of the rcu_idle() in the
patch?  Patch reproduced below for convenience.

							Thanx, Paul

------------------------------------------------------------------------

>From 7e08c37b20cb3d93ba67f8ad5d46f2c38acb8fe5 Mon Sep 17 00:00:00 2001
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date: Sun, 5 Apr 2009 10:09:54 -0700
Subject: [PATCH] Make idle loop (mostly) safe for RCU read-side critical sections.

Not for inclusion, demo only.  Untested, probably fails to compile.

This patch is for demonstration purposes only.  It adds a facility to
rcutree.c to allow RCU read-side critical sections to be used in
idle loops, as long as those RCU read-side critical sections do not
lap over the call to rcu_idle().

If this were a real patch, it would have the following:

o	A config variable to allow architectures to opt out of this
	sort of behavior.  (But then again, maybe not.)

o	Follow-up patches that added a call to rcu_idle() to each
	idle loop in the kernel, probably grouped by architecture.

o	Documentation updates to explain the new loosened restrictions
	regarding RCU read-side critical sections and idle loops.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/x86/kernel/process.c |    1 +
 include/linux/rcupdate.h  |    1 +
 kernel/rcutree.c          |   21 ++++++++++++++-------
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 156f875..adbaf13 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -310,6 +310,7 @@ void default_idle(void)
 		current_thread_info()->status |= TS_POLLING;
 		trace_power_end(&it);
 	} else {
+		rcu_idle();
 		local_irq_enable();
 		/* loop is done by the caller */
 		cpu_relax();
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 528343e..3905f54 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -265,6 +265,7 @@ extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
+extern void rcu_idle(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97ce315..4c61b71 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -937,6 +937,17 @@ static void rcu_do_batch(struct rcu_data *rdp)
 }
 
 /*
+ * Called from each idle loop to enable RCU to treat the idle loop as
+ * a quiescent state.  Note that this code assumes that idle CPUs continue
+ * executing instructions until they enter nohz mode.
+ */
+void rcu_idle(void)
+{
+	rcu_qsctr_inc(cpu);
+	rcu_bh_qsctr_inc(cpu);
+}
+
+/*
  * Check to see if this CPU is in a non-context-switch quiescent state
  * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
  * Also schedule the RCU softirq handler.
@@ -947,15 +958,11 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
-	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	if (user) {
 
 		/*
-		 * Get here if this CPU took its interrupt from user
-		 * mode or from the idle loop, and if this is not a
-		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so count it.
+		 * Get here if this CPU took its interrupt from user mode.
+		 * In this case, the CPU is in a quiescent state, so count it.
 		 *
 		 * No memory barrier is required here because both
 		 * rcu_qsctr_inc() and rcu_bh_qsctr_inc() reference
-- 
1.5.2.5

