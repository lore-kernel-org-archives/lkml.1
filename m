Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYF0EqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYF0EqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYF0EqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:46:15 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:52739 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYF0EqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:46:13 -0400
Date: Fri, 27 Jun 2008 10:17:38 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080627044738.GC3419@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626152728.GA24972@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:27:28AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 24, 2008 at 01:01:44PM +0200, Ingo Molnar wrote:
> > 
> > * Gautham R Shenoy <ego@in.ibm.com> wrote:
> > 
> > > > hm, not sure - we might just be fighting the symptom and we might 
> > > > now create a silent resource leak instead. Isnt a full RCU quiescent 
> > > > state forced (on all CPUs) before a CPU is cleared out of 
> > > > cpu_online_map? That way the to-be-offlined CPU should never 
> > > > actually show up in rcp->cpumask.
> > > 
> > > No, this does not happen currently. The rcp->cpumask is always 
> > > initialized to cpu_online_map&~nohz_cpu_mask when we start a new 
> > > batch. Hence, before the batch ends, if a cpu goes offline we _can_ 
> > > have a stale rcp->cpumask, till the RCU subsystem has handled it's 
> > > CPU_DEAD notification.
> > > 
> > > Thus for a tiny interval, the rcp->cpumask would contain the offlined 
> > > CPU. One of the alternatives is probably to handle this using 
> > > CPU_DYING notifier instead of CPU_DEAD where we can call 
> > > __rcu_offline_cpu().
> > > 
> > > The warn_on that dhaval was hitting was because of some cpu-offline 
> > > that was called just before we did a local_irq_save inside call_rcu(). 
> > > But at that time, the rcp->cpumask was still stale, and hence we ended 
> > > up sending a smp_reschedule() to an offlined cpu. So the check may not 
> > > create any resource leak.
> > 
> > the check may not - but the problem it highlights might and with the 
> > patch we'd end up hiding potential problems in this area.
> > 
> > Paul, what do you think about this mixed CPU hotplug plus RCU workload?
> 
> RCU most certainly needs to work correctly in face of arbitrary sequences
> of CPU-hotplug events, and should therefore be tested with arbitrary
> CPU-hotplug tests.  And RCU also most certainly needs to refrain from
> issuing spurious warning messages that might over time be ignored,
> possibly causing someone to miss a real bug.  My concern with this patch
> is in the second spurious-warning area.

IMHO the warning is a spurious one.
Here's the timeline.
CPU_A						 CPU_B
--------------------------------------------------------------
cpu_down():					.
.					   	.
.						.
stop_machine(): /* disables preemption,		.
		 * and irqs */			.
.						.
.						.
take_cpu_down();				.
.						.
.						.
.						.
cpu_disable(); /*this removes cpu 		.
		*from cpu_online_map 		.
		*/				.
.						.
.						.
restart_machine(); /* enables irqs */		.
------WINDOW DURING WHICH rcp->cpumask is stale ---------------
.						call_rcu();
.						/* disables irqs here */
.						.force_quiescent_state();
.CPU_DEAD:					.for_each_cpu(rcp->cpumask)
.						.   smp_send_reschedule();
.						.
.						.   WARN_ON() for offlined CPU!
.
.
.
rcu_cpu_notify:
.
-------- WINDOW ENDS ------------------------------------------
rcu_offline_cpu() /* Which calls cpu_quiet()
		   * which removes
		   * cpu from rcp->cpumask.
		   */


If a new batch was started just before calling stop_machine_run(), the
"tobe-offlined" cpu is still present in rcp-cpumask.

During a cpu-offline, from take_cpu_down(),
we queue an rt-prio idle task
as the next task to be picked by the scheduler.
We also call cpu_disable() which will disable any further
interrupts and remove the cpu's bit from the cpu_online_map.

Once the stop_machine_run() successfully calls take_cpu_down(),
it calls schedule(). That's the last time a schedule is called
on the offlined cpu, and hence the last time when rdp->passed_quiesc
will be set to 1 through rcu_qsctr_inc().

But the cpu_quiet() will be on this cpu will be called only when the
next RCU_SOFTIRQ occurs on this CPU. So at this time, the offlined CPU
is still set in rcp->cpumask.

Now coming back to the idle_task which truely offlines the CPU, it does
check for a pending RCU and raises the softirq, since it will find
rdp->passed_quiesc to be 0 in this case. However, since the cpu is offline
I am not sure if the softirq will trigger on the CPU.

Even if it doesn't the rcu_offline_cpu() will find that rcp->completed
is not the same as rcp->cur, which means that our cpu could be holding
up the grace period progression. Hence we call cpu_quiet() and move
ahead.

But because of the window explained in the timeline, we could still have
a call_rcu() before the RCU subsystem executes it's CPU_DEAD
notification, and we send smp_send_reschedule() to offlined cpu while
trying to force the quiescent states. The appended patch adds comments
and prevents checking for offlined cpu everytime.

Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Fri Jun 27 09:33:55 2008 +0530

    cpu_online_map is updated by the _cpu_down()
    using stop_machine_run(). Since force_quiescent_state is invoked from
    irqs disabled section, stop_machine_run() won't be executing while
    a cpu is executing force_quiescent_state(). Hence the
    cpu_online_map is stable while we're in the irq disabled section.

    However,  a cpu might have been offlined _just_ before
    we disabled irqs while entering force_quiescent_state().
    And rcu subsystem might not yet have handled the CPU_DEAD
    notification, leading to the offlined cpu's bit
    being set in the rcp->cpumask.

    Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
    sending smp_reschedule() to an offlined CPU.

    Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
    Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index f4ffbd0..a38895a 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -89,8 +89,22 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		/*
 		 * Don't send IPI to itself. With irqs disabled,
 		 * rdp->cpu is the current cpu.
+		 *
+		 * cpu_online_map is updated by the _cpu_down()
+		 * using stop_machine_run(). Since we're in irqs disabled
+		 * section, stop_machine_run() is not exectuting, hence
+		 * the cpu_online_map is stable.
+		 *
+		 * However,  a cpu might have been offlined _just_ before
+		 * we disabled irqs while entering here.
+		 * And rcu subsystem might not yet have handled the CPU_DEAD
+		 * notification, leading to the offlined cpu's bit
+		 * being set in the rcp->cpumask.
+		 *
+		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
+		 * sending smp_reschedule() to an offlined CPU.
 		 */
-		cpumask = rcp->cpumask;
+		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
 		cpu_clear(rdp->cpu, cpumask);
 		for_each_cpu_mask(cpu, cpumask)
 			smp_send_reschedule(cpu);



> 
> Not sure I answered the actual question, though...
> 
> 							Thanx, Paul

-- 
Thanks and Regards
gautham
