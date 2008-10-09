Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYJIBdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYJIBdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYJIBdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:33:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37343 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYJIBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:33:24 -0400
Date: Wed, 8 Oct 2008 18:33:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081009013321.GA11291@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007212215.GN6384@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:22:15PM -0700, Paul E. McKenney wrote:
> On Tue, Oct 07, 2008 at 11:09:47PM +0200, Andi Kleen wrote:
> > On Tue, Oct 07, 2008 at 09:34:01AM -0700, Paul E. McKenney wrote:
> > > Thank you!  Hmmm, classic RCU, worked just fine in 2.6.27-rc7 with
> > > Thomas's patch.  I was doing random onlines and offlines in a loop,
> > > with about 3 seconds between each operation continuously for more than
> > > ten hours, both x86 and Power.  So could you please try 2.6.27-rc7 with
> > > Thomas's patch as follows?
> > > 
> > > http://www.rdrop.com/users/paulmck/patches/2.6.27-rc7-tglx-timer-1.patch
> > 
> > Same effect. Hung on the first try
> > 
> > bash          D 00000000ffff25c1     0  4755   4742
> >  ffff88027b127bf8 0000000000000086 ffff88027b127c18 0000000000000296
> >  ffff88027c80b330 ffff8804be488b90 ffff88027c80b578 0000000300000296
> >  ffff88027b127c18 ffffffff808cbd18 ffff88002805d600 ffff88027d182098
> > Call Trace:
> >  [<ffffffff805c318d>] schedule_timeout+0x22/0xb4
> >  [<ffffffff8020a029>] ? __switch_to+0x320/0x330
> >  [<ffffffff8025fa65>] ? cpupri_set+0xc5/0xd8
> >  [<ffffffff805c2fe7>] wait_for_common+0xcd/0x131
> >  [<ffffffff8022d297>] ? default_wake_function+0x0/0xf
> >  [<ffffffff805c30d5>] wait_for_completion+0x18/0x1a
> >  [<ffffffff8024374b>] synchronize_rcu+0x35/0x3c
> >  [<ffffffff802437ca>] ? wakeme_after_rcu+0x0/0x12
> >  [<ffffffff8022e435>] partition_sched_domains+0x9b/0x1dd
> >  [<ffffffff8022d2c3>] ? wake_up_process+0x10/0x12
> >  [<ffffffff8022e5a5>] update_sched_domains+0x2e/0x35
> >  [<ffffffff805c6bb2>] notifier_call_chain+0x33/0x5b
> >  [<ffffffff80248a29>] __raw_notifier_call_chain+0x9/0xb
> >  [<ffffffff80248a3a>] raw_notifier_call_chain+0xf/0x11
> >  [<ffffffff805c06e6>] _cpu_up+0xd3/0x10c
> >  [<ffffffff805c0776>] cpu_up+0x57/0x67
> >  [<ffffffff805a4ab7>] store_online+0x4d/0x75
> >  [<ffffffff803e5d0b>] sysdev_store+0x1b/0x1d
> >  [<ffffffff802cc49c>] sysfs_write_file+0xe0/0x11c
> >  [<ffffffff8028ad1d>] vfs_write+0xae/0x137
> >  [<ffffffff8028b1c6>] sys_write+0x47/0x6f
> >  [<ffffffff8020b36b>] system_call_fastpath+0x16/0x1b
> 
> Thus far, as usual, I cannot reproduce, either on x86 or Power.  You are
> running on hyperthreaded machines?  If so, what happens if you disable
> CONFIG_SCHED_SMT and CONFIG_SCHED_MC?
> 
> You are running on a 16-CPU x86-64 box?

The attached patch (similar to one in -tip, but set up for mainline and
tweaked to make stall-checking on by default) should get you a stack
trace of any CPUs holding up RCU grace periods for more than about
three seconds.

On the off-chance that this helps.

							Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 4ab8436..cab055b 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -40,6 +40,10 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK	3 * HZ	/* for rcp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK	30 * HZ	/* for rcp->jiffies_stall */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
@@ -52,6 +56,11 @@ struct rcu_ctrlblk {
 	spinlock_t	lock	____cacheline_internodealigned_in_smp;
 	cpumask_t	cpumask; /* CPUs that need to switch in order    */
 				 /* for current batch to proceed.        */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;	 /* Time at which GP started in jiffies. */
+	unsigned long jiffies_stall;
+				 /* Time at which to check for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 } ____cacheline_internodealigned_in_smp;
 
 /* Is batch a before batch b ? */
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index aad93cd..a299876 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -118,6 +118,87 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 }
 #endif
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rcp->lock, flags);
+	delta = jiffies - rcp->jiffies_stall;
+	if (delta < 2 || rcp->cur != rcp->completed) {
+		spin_unlock_irqrestore(&rcp->lock, flags);
+		return;
+	}
+	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "RCU detected CPU stalls:");
+	for_each_possible_cpu(cpu) {
+		if (cpu_isset(cpu, rcp->cpumask))
+			printk(" %d", cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
+}
+
+static void print_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
+			smp_processor_id(), jiffies,
+			jiffies - rcp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rcp->lock, flags);
+	if ((long)(jiffies - rcp->jiffies_stall) >= 0)
+		rcp->jiffies_stall =
+			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	long delta;
+
+	delta = jiffies - rcp->jiffies_stall;
+	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
+		
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rcp);
+
+	} else if (rcp->cur != rcp->completed && delta >= 2) {
+
+		/* They had two seconds to dump stack, so complain. */
+		print_other_cpu_stall(rcp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+}
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -285,6 +366,7 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 */
 		smp_wmb();
 		rcp->cur++;
+		record_gp_stall_check_time(rcp);
 
 		/*
 		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
@@ -468,6 +550,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rcp);
+
 	/* This cpu has pending rcu entries and the grace period
 	 * for them has completed.
 	 */
@@ -558,6 +643,9 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
+#ifdef CONFIG_DEBUG_RCU_STALL
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
 	memset(rdp, 0, sizeof(*rdp));
 	rdp->curtail = &rdp->curlist;
 	rdp->nxttail = &rdp->nxtlist;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..9fee969 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -597,6 +597,19 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU
+	default y
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
