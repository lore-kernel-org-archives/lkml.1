Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbYCDF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbYCDF0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYCDF0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:26:38 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59785 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbYCDF0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:26:37 -0500
Date: Tue, 4 Mar 2008 10:56:13 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Yi Yang <yi.y.yang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080304052613.GA28632@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:45:04PM +0800, Yi Yang wrote:
> On Mon, 2008-03-03 at 21:01 +0530, Gautham R Shenoy wrote:
> > > This issue seems such one, but i tried to change it to follow this rule but
> > > the issue is still there.
> > > 
> > > Why isn't the kernel thread [watchdog/1] reaped by its parent? its state
> > > is TASK_RUNNING with high priority (R< means this), why it isn't done?
> > > 
> > > Anyone ever met such a problem? Your thought?
> > 
> > Hi Yi,
> > 
> > This is indeed strange. I am able to reproduce this problem on my 4-way
> > box. From what I see in the past two runs, we're waiting in the
> > cpu-hotplug callback path for the watchdog/1 thread to stop.
> > 
> > During cpu-offline, once the cpu goes offline, in the migration_call(), 
> > we migrate any tasks associated with the offline cpus
> > to some other cpu. This also mean breaking affinity for tasks which were
> > affined to the cpu which went down. So watchdog/1 has been migrated to
> > some other cpu.
> No, [watchdog/1] is just for CPU #1, if CPU #1 has been offline, it
> should be killed but not migrated to other CPU because other CPU has
> such a kthread.

Yes, it is killed once it gets a chance to run *after* cpu goes offline.
The moment it runs on some other cpu, it will see the kthread_should_stop()
because in the cpu-hotplug callback path we've issues a 
kthread_stop(watchdog/1)

Again, we can argue that we could issue a kthread_stop() 
in CPU_DOWN_PREPARE, rather than in CPU_DEAD and restart 
it in CPU_DOWN_FAILED if the cpu-hotplug operation does fail.

> 
> Maybe migration_call was doing such a bad thing. :-)

Nope, from what I see migration call is not having any problems. It is
behaving the way it is supposed to behave :)

The other observation I noted was the WARN_ON_ONCE() in hrtick() [1]
that I am consistently hitting after the first cpu goes offline.

So at times, the callback thread is blocked on kthread_stop(k) in
softlockup.c, while other time, it was blocked in
cleanup_workqueue_threads() in workqueue.c. 

This was with the debug patch[2]

Not sure if this is linked to the problem that Yi has pointed out
but looks like a regression. I'll see if this can be reproduced on
2.6.24, 2.6.25-rc1 and 2.6.25-rc2.

[1] The WARN_ON_ONCE() trace.

------------[ cut here ]------------
WARNING: at kernel/sched.c:1007 hrtick+0x32/0x6a()
Modules linked in: dock
Pid: 4451, comm: bash Not tainted 2.6.25-rc3 #26
 [<c011f6c8>] warn_on_slowpath+0x41/0x51
 [<c013a0dd>] ? trace_hardirqs_on+0xd3/0x111
 [<c04e43a3>] ? _spin_unlock_irqrestore+0x42/0x58
 [<c02767e7>] ? blk_run_queue+0x64/0x68
 [<c033ae6e>] ? scsi_run_queue+0x18d/0x195
 [<c027fd7b>] ? kobject_put+0x14/0x16
 [<c02e1c3f>] ? put_device+0x11/0x13
 [<c013af7b>] ? __lock_acquire+0xaae/0xaf6
 [<c01320bf>] ? __run_hrtimer+0x35/0x70
 [<c0119a8a>] hrtick+0x32/0x6a
 [<c0119a58>] ? hrtick+0x0/0x6a
 [<c01320c3>] __run_hrtimer+0x39/0x70
 [<c01328e8>] hrtimer_interrupt+0xed/0x156
 [<c0112db9>] smp_apic_timer_interrupt+0x6c/0x7f
 [<c010568b>] apic_timer_interrupt+0x33/0x38
 [<c01202ed>] ? vprintk+0x2d0/0x328
 [<c027fe47>] ? kobject_release+0x4b/0x50
 [<c027fdfc>] ? kobject_release+0x0/0x50
 [<c04dea24>] ? cpuid_class_cpu_callback+0x0/0x50
 [<c0280931>] ? kref_put+0x39/0x44
 [<c027fd7b>] ? kobject_put+0x14/0x16
 [<c02e1c3f>] ? put_device+0x11/0x13
 [<c014e2e3>] ? cpu_swap_callback+0x0/0x3d
 [<c012035a>] printk+0x15/0x17
 [<c04e61d0>] notifier_call_chain+0x40/0x9b
 [<c04e2d25>] ? mutex_unlock+0x8/0xa
 [<c0143c29>] ? __stop_machine_run+0x8c/0x95
 [<c013e1b3>] ? take_cpu_down+0x0/0x27
 [<c01331e8>] __raw_notifier_call_chain+0xe/0x10
 [<c01331f6>] raw_notifier_call_chain+0xc/0xe
 [<c013e37e>] _cpu_down+0x1a4/0x269
 [<c013e466>] cpu_down+0x23/0x30
 [<c02e58e7>] store_online+0x27/0x5a
 [<c02e58c0>] ? store_online+0x0/0x5a
 [<c02e2a9c>] sysdev_store+0x20/0x25
 [<c0197e65>] sysfs_write_file+0xad/0xdf
 [<c0197db8>] ? sysfs_write_file+0x0/0xdf
 [<c0165099>] vfs_write+0x8c/0x108
 [<c0165623>] sys_write+0x3b/0x60
 [<c0104b12>] sysenter_past_esp+0x5f/0xa5
 =======================
---[ end trace 22cbd9e369049151 ]---



[2] The debug patch
----->

Index: linux-2.6.25-rc3/kernel/cpu.c
===================================================================
--- linux-2.6.25-rc3.orig/kernel/cpu.c
+++ linux-2.6.25-rc3/kernel/cpu.c
@@ -18,7 +18,7 @@
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+__cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
@@ -207,11 +207,14 @@ static int _cpu_down(unsigned int cpu, i
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	printk("[HOTPLUG] calling cpu_hotplug_begin\n");
 	cpu_hotplug_begin();
+	printk("[HOTPLUG] calling CPU_DOWN_PREPARE\n");
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
 		nr_calls--;
+		printk("[HOTPLUG] calling CPU_DOWN_FAILED\n");
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -226,10 +229,12 @@ static int _cpu_down(unsigned int cpu, i
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed(current, tmp);
 
+	printk("[HOTPLUG] calling stop_machine_run()\n");
 	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
+		printk("[HOTPLUG] calling CPU_DOWN_FAILED\n");
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
 			BUG();
@@ -241,13 +246,16 @@ static int _cpu_down(unsigned int cpu, i
 		goto out_thread;
 	}
 
+	printk("[HOTPLUG] waiting for idle_cpu()\n");
 	/* Wait for it to sleep (leaving idle task). */
 	while (!idle_cpu(cpu))
 		yield();
 
+	printk("[HOTPLUG] calling __cpu_die()\n");
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
 
+	printk("[HOTPLUG] calling CPU_DEAD\n");
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
 	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
 				    hcpu) == NOTIFY_BAD)
@@ -256,11 +264,14 @@ static int _cpu_down(unsigned int cpu, i
 	check_for_tasks(cpu);
 
 out_thread:
+	printk("[HOTPLUG] calling kthread_stop_machine\n");
 	err = kthread_stop(p);
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
+	printk("[HOTPLUG] calling cpu_hotplug_done()\n");
 	cpu_hotplug_done();
+	printk("[HOTPLUG] returning from _cpu_down()\n");
 	return err;
 }
 
Index: linux-2.6.25-rc3/kernel/notifier.c
===================================================================
--- linux-2.6.25-rc3.orig/kernel/notifier.c
+++ linux-2.6.25-rc3/kernel/notifier.c
@@ -5,7 +5,7 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
-
+#include <linux/kallsyms.h>
 /*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
@@ -44,6 +44,7 @@ static int notifier_chain_unregister(str
 	return -ENOENT;
 }
 
+extern struct raw_notifier_head cpu_chain;
 /**
  * notifier_call_chain - Informs the registered notifiers about an event.
  *	@nl:		Pointer to head of the blocking notifier chain
@@ -62,12 +63,21 @@ static int __kprobes notifier_call_chain
 {
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
+	char name_buf[100];
 
 	nb = rcu_dereference(*nl);
 
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference(nb->next);
+		if (nl == &cpu_chain.head) {
+			sprint_symbol(name_buf, (unsigned long)nb->notifier_call);
+			printk("[HOTPLUG] calling callback:%s\n", name_buf);
+		}
 		ret = nb->notifier_call(nb, val, v);
+		if (nl == &cpu_chain.head) {
+			sprint_symbol(name_buf, (unsigned long)nb->notifier_call);
+			printk("[HOTPLUG] returned from callback:%s\n", name_buf);
+		}
 
 		if (nr_calls)
 			(*nr_calls)++;



> > 
> > However, it remains in R< state and has not executed the
> > kthread_should_stop() instruction.
> > 
> > I'm trying to probe further by inserting a few more printk's in there.
> > 
> > Will post the findings in a couple of hours.
> > 
> > Thanks for reporting the problem.
> > 
> > Regards
> > gautham.
> 

-- 
Thanks and Regards
gautham
