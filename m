Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZDERL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZDERL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZDERLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:11:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57796 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZDERLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:11:47 -0400
Date: Sun, 5 Apr 2009 10:11:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090405171146.GK6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com> <1238916865.7989.212.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238916865.7989.212.camel@tropicana>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 02:34:25AM -0500, Tom Zanussi wrote:
> On Sat, 2009-04-04 at 11:49 -0400, Steven Rostedt wrote:
> > On Sat, 4 Apr 2009, Tom Zanussi wrote:
> > > 
> > > Hmm, after reading Paul's replies, it sounds like this approach might be
> > > more trouble than it's worth.  Maybe going back to the idea of
> > > temporarily stopping/starting tracing would be a better idea, but with a
> > > little more heavyweight version of the current 'quick' tracing
> > > start/stop (that would prevent entering the tracing functions (and ththe
> > > filter_check_discard()).
> > 
> > 
> > Actually, I forgot what the general problem we are avoiding here with the
> > RCU locks. Could you explain that again. Just so that I can get a better
> > idea without having to read between the lines of the previous messages in 
> > this thread.
> > 
> 
> Basically the problem is that the tracing functions call
> filter_match_preds(call,...) where call->preds is an array of predicates
> that get checked to determine whether the current event matches or not.
> When an existing filter is deleted (or an old one replaced), the
> call->preds array is freed and set to NULL (which happens only via a
> write to the 'filter' debugfs file).  So without any protection, while
> one cpu is freeing the preds array, the others may still be using it,
> and if so, it will crash the box.  You can easily see the problem with
> e.g. the function tracer:
> 
> # echo function > /debug/tracing/current_tracer
> 
> Function tracing is now live
> 
> # echo 'common_pid == 0' > /debug/tracing/events/ftrace/function/filter
> 
> No problem, no preds are freed the first time
> 
> # echo 0 > /debug/tracing/events/ftrace/function/filter
> 
> Crash.
> 
> My first patch took the safe route and completely disallowed filters
> from being set when any tracing was live i.e. you had to for example
> echo 0 > tracing_enabled or echo 0 > enable for a particular event, etc.
> 
> This wasn't great for usability, though - it would be much nicer to be
> able to remove or set new filters on the fly, while tracing is active,
> which rcu seemed perfect for - the preds wouldn't actually be destroyed
> until all the current users were finished with them.  My second patch
> implemented that and it seemed to nicely fix the problem, but it
> apparently can cause other problems...
> 
> So assuming we can't use rcu for this, it would be nice to have a way to
> 'pause' tracing so the current filter can be removed i.e. some version
> of stop_trace()/start_trace() that make sure nothing is still executing
> or can enter filter_match_preds() while the current call->preds is being
> destroyed.  Seems like it would be straightforward to implement for the
> event tracer, since each event maps to a tracepoint that could be
> temporarily unregistered/reregistered, but maybe not so easy for the
> ftrace tracers...

In principle, it would be possible to rework RCU so that instead of the
whole idle loop being a quiescent state, there is a single quiescent state
at one point in each idle loop.  The reason that I have been avoiding this
is that there are a lot of idle loops out there, and it would be a bit
annoying to (1) find them all and update them and (2) keep track of all of
them to ensure that new ones cannot slip in without the quiescent state.

But it could be done if the need is there.  Simple enough change.
The following patch shows the general approach, assuming that CPUs
are never put to sleep without entering nohz mode.

Thoughts?

							Thanx, Paul

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

