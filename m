Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYGAIeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYGAIeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYGAId5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:33:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbYGAIdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:33:52 -0400
Date: Tue, 1 Jul 2008 10:32:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701083252.GA2796@elte.hu>
References: <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com> <20080701061600.GF14658@elte.hu> <20080701062854.GD6131@linux.vnet.ibm.com> <20080701063531.GD16642@elte.hu> <20080701065226.GA24639@elte.hu> <20080701074824.GA19400@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701074824.GA19400@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> ------WINDOW DURING WHICH rcp->cpumask is stale ---------------
> .						call_rcu();
> .						/* disables irqs here */
> .						.force_quiescent_state();
> .CPU_DEAD:					.for_each_cpu(rcp->cpumask)
> .						.   smp_send_reschedule();
> .						.
> .						.   WARN_ON() for offlined CPU!
> --

hm, for some reason the "-- WINDOW ENDS" line has cut off processing 
somewhere along the mail route. Here it is again, with that line 
removed.

----------->
commit 8558f8f81680a43d383abd1b5f23d3501fedfa65
Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Fri Jun 27 10:17:38 2008 +0530

    rcu: fix hotplug vs rcu race
    
    Dhaval Giani reported this warning during cpu hotplug stress-tests:
    
    | On running kernel compiles in parallel with cpu hotplug:
    |
    | WARNING: at arch/x86/kernel/smp.c:118
    | native_smp_send_reschedule+0x21/0x36()
    | Modules linked in:
    | Pid: 27483, comm: cc1 Not tainted 2.6.26-rc7 #1
    | [...]
    |  [<c0110355>] native_smp_send_reschedule+0x21/0x36
    |  [<c014fe8f>] force_quiescent_state+0x47/0x57
    |  [<c014fef0>] call_rcu+0x51/0x6d
    |  [<c01713b3>] __fput+0x130/0x158
    |  [<c0171231>] fput+0x17/0x19
    |  [<c016fd99>] filp_close+0x4d/0x57
    |  [<c016fdff>] sys_close+0x5c/0x97
    
    IMHO the warning is a spurious one.
    
    cpu_online_map is updated by the _cpu_down() using stop_machine_run().
    Since force_quiescent_state is invoked from irqs disabled section,
    stop_machine_run() won't be executing while a cpu is executing
    force_quiescent_state(). Hence the cpu_online_map is stable while we're
    in the irq disabled section.
    
    However, a cpu might have been offlined _just_ before we disabled irqs
    while entering force_quiescent_state(). And rcu subsystem might not yet
    have handled the CPU_DEAD notification, leading to the offlined cpu's
    bit being set in the rcp->cpumask.
    
    Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent sending
    smp_reschedule() to an offlined CPU.
    
    Here's the timeline:
    
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
    [ -- line removed -- ]
    rcu_offline_cpu() /* Which calls cpu_quiet()
    		   * which removes
    		   * cpu from rcp->cpumask.
    		   */
    
    If a new batch was started just before calling stop_machine_run(), the
    "tobe-offlined" cpu is still present in rcp-cpumask.
    
    During a cpu-offline, from take_cpu_down(), we queue an rt-prio idle
    task as the next task to be picked by the scheduler. We also call
    cpu_disable() which will disable any further interrupts and remove the
    cpu's bit from the cpu_online_map.
    
    Once the stop_machine_run() successfully calls take_cpu_down(), it calls
    schedule(). That's the last time a schedule is called on the offlined
    cpu, and hence the last time when rdp->passed_quiesc will be set to 1
    through rcu_qsctr_inc().
    
    But the cpu_quiet() will be on this cpu will be called only when the
    next RCU_SOFTIRQ occurs on this CPU. So at this time, the offlined CPU
    is still set in rcp->cpumask.
    
    Now coming back to the idle_task which truely offlines the CPU, it does
    check for a pending RCU and raises the softirq, since it will find
    rdp->passed_quiesc to be 0 in this case. However, since the cpu is
    offline I am not sure if the softirq will trigger on the CPU.
    
    Even if it doesn't the rcu_offline_cpu() will find that rcp->completed
    is not the same as rcp->cur, which means that our cpu could be holding
    up the grace period progression. Hence we call cpu_quiet() and move
    ahead.
    
    But because of the window explained in the timeline, we could still have
    a call_rcu() before the RCU subsystem executes it's CPU_DEAD
    notification, and we send smp_send_reschedule() to offlined cpu while
    trying to force the quiescent states. The appended patch adds comments
    and prevents checking for offlined cpu everytime.
    
    cpu_online_map is updated by the _cpu_down() using stop_machine_run().
    Since force_quiescent_state is invoked from irqs disabled section,
    stop_machine_run() won't be executing while a cpu is executing
    force_quiescent_state(). Hence the cpu_online_map is stable while we're
    in the irq disabled section.
    
    Reported-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
    Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
    Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
    Cc: Dipankar Sarma <dipankar@in.ibm.com>
    Cc: laijs@cn.fujitsu.com
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Rusty Russel <rusty@rustcorp.com.au>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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
