Return-Path: <linux-kernel-owner+w=401wt.eu-S1945925AbXCBNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925AbXCBNAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945924AbXCBNAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:00:32 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:45567 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945916AbXCBNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:00:30 -0500
Date: Fri, 2 Mar 2007 13:58:48 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070302125848.GA8226@osiris.boeblingen.de.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doing something like this on a two cpu system

# echo 0 > /sys/devices/system/cpu/cpu0/online 
# echo 1 > /sys/devices/system/cpu/cpu0/online 
# echo 0 > /sys/devices/system/cpu/cpu1/online 

will give me this:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-rc2-g562aa1d4-dirty #7
-------------------------------------------------------
bash/1282 is trying to acquire lock:
 (&cpu_base->lock_key){.+..}, at: [<000000000005f17e>] hrtimer_cpu_notify+0xc6/0x240

but task is already holding lock:
 (&cpu_base->lock_key#2){.+..}, at: [<000000000005f174>] hrtimer_cpu_notify+0xbc/0x240

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&cpu_base->lock_key#2){.+..}:
       [<000000000006585e>] __lock_acquire+0x8d6/0x1184
       [<000000000006661c>] lock_acquire+0x90/0xc0
       [<000000000036c70a>] _spin_lock+0x4e/0x68
       [<000000000005f17e>] hrtimer_cpu_notify+0xc6/0x240
       [<000000000036e544>] notifier_call_chain+0x54/0x78
       [<00000000000508ba>] raw_notifier_call_chain+0x26/0x34
       [<000000000006d4b2>] cpu_down+0x276/0x36c
       [<00000000001c5764>] store_online+0x60/0xc0
       [<00000000001bf874>] sysdev_store+0x40/0x58
       [<000000000010aa3a>] sysfs_write_file+0x12e/0x1d0
       [<00000000000b0584>] vfs_write+0xa8/0x15c
       [<00000000000b0716>] sys_write+0x56/0x88
       [<000000000002275c>] sysc_noemu+0x10/0x16
       [<0000020000118da8>] 0x20000118da8

-> #0 (&cpu_base->lock_key){.+..}:
       [<00000000000656b8>] __lock_acquire+0x730/0x1184
       [<000000000006661c>] lock_acquire+0x90/0xc0
       [<000000000036c70a>] _spin_lock+0x4e/0x68
       [<000000000005f17e>] hrtimer_cpu_notify+0xc6/0x240
       [<000000000036e544>] notifier_call_chain+0x54/0x78
       [<00000000000508ba>] raw_notifier_call_chain+0x26/0x34
       [<000000000006d4b2>] cpu_down+0x276/0x36c
       [<00000000001c5764>] store_online+0x60/0xc0
       [<00000000001bf874>] sysdev_store+0x40/0x58
       [<000000000010aa3a>] sysfs_write_file+0x12e/0x1d0
       [<00000000000b0584>] vfs_write+0xa8/0x15c
       [<00000000000b0716>] sys_write+0x56/0x88
       [<000000000002275c>] sysc_noemu+0x10/0x16
       [<0000020000118da8>] 0x20000118da8

other info that might help us debug this:

4 locks held by bash/1282:
 #0:  (cpu_add_remove_lock){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #1:  (cache_chain_mutex){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #2:  (workqueue_mutex){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #3:  (&cpu_base->lock_key#2){.+..}, at: [<000000000005f174>] hrtimer_cpu_notify+0xbc/0x240

stack backtrace:
4141e8b900000000 4141e8b900000000 3ff2c76e1deacc92 0000000000000000 
       0000000000000000 0000000000420498 0000000000420498 000000000001595e 
       0000000000000000 0000000000000004 0000000000000000 00000000004fadf0 
       0000000000000000 0000336e0000000d 000000000ce0f970 000000000ce0f9e8 
       0000000000375c30 000000000001595e 000000000ce0f970 000000000ce0f9c0 
Call Trace:
([<000000000001588a>] show_trace+0x92/0xe8)
 [<0000000000015980>] show_stack+0xa0/0xd0
 [<00000000000159de>] dump_stack+0x2e/0x3c
 [<0000000000062cdc>] print_circular_bug_tail+0xa0/0xa4
 [<00000000000656b8>] __lock_acquire+0x730/0x1184
 [<000000000006661c>] lock_acquire+0x90/0xc0
 [<000000000036c70a>] _spin_lock+0x4e/0x68
 [<000000000005f17e>] hrtimer_cpu_notify+0xc6/0x240
 [<000000000036e544>] notifier_call_chain+0x54/0x78
 [<00000000000508ba>] raw_notifier_call_chain+0x26/0x34
 [<000000000006d4b2>] cpu_down+0x276/0x36c
 [<00000000001c5764>] store_online+0x60/0xc0
 [<00000000001bf874>] sysdev_store+0x40/0x58
 [<000000000010aa3a>] sysfs_write_file+0x12e/0x1d0
 [<00000000000b0584>] vfs_write+0xa8/0x15c
 [<00000000000b0716>] sys_write+0x56/0x88
 [<000000000002275c>] sysc_noemu+0x10/0x16
 [<0000020000118da8>] 0x20000118da8

4 locks held by bash/1282:
 #0:  (cpu_add_remove_lock){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #1:  (cache_chain_mutex){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #2:  (workqueue_mutex){--..}, at: [<000000000036a472>] mutex_lock+0x3e/0x4c
 #3:  (&cpu_base->lock_key#2){.+..}, at: [<000000000005f174>] hrtimer_cpu_notify+0xbc/0x240

This happens because we have the following code in kernel/hrtimer.c:

migrate_hrtimers(int cpu)
[...]
old_base = &per_cpu(hrtimer_bases, cpu);
new_base = &get_cpu_var(hrtimer_bases);
[...]
spin_lock(&new_base->lock);
spin_lock(&old_base->lock);

Which means the spinlocks are taken in an order which depends on which cpu
gets shut down from which other cpu. Therefore lockdep complains that there
might be an ABBA deadlock. Since migrate_hrtimers() gets only called on
cpu hotplug it's safe to assume that it isn't executed concurrently on a
different cpu and therefore the locking should be ok.

The same problem exists in kernel/timer.c: migrate_timers(). As an added
bonus we get there a locked up system on s390, since the lock that lockdep
want's to complain about via printk is also needed by our 3215 console
driver (calls del_timer). So we end up in a deadlock.

As pointed out by Christian Borntraeger one possible solution to avoid
the locking order complaints would be to make sure that the locks are
always taken in the same order. E.g. by taking the lock of the cpu with
the lower number first. AFIACS this should be safe and that is what this
patch does.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Christian Borntraeger <cborntra@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/hrtimer.c |   17 ++++++++++++-----
 kernel/timer.c   |   16 ++++++++++++----
 2 files changed, 24 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1346,6 +1346,7 @@ static void migrate_hrtimer_list(struct 
 static void migrate_hrtimers(int cpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
+	spinlock_t *lock1, *lock2;
 	int i;
 
 	BUG_ON(cpu_online(cpu));
@@ -1355,16 +1356,22 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	/*
+	 * If we take a lock from a different cpu, make sure we have always
+	 * the same locking order. That is the lock that belongs to the cpu
+	 * with the lowest number is taken first.
+	 */
+	lock1 = smp_processor_id() < cpu ? &new_base->lock : &old_base->lock;
+	lock2 = smp_processor_id() < cpu ? &old_base->lock : &new_base->lock;
+	spin_lock(lock1);
+	spin_lock(lock2);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	spin_unlock(lock2);
+	spin_unlock(lock1);
 
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1644,6 +1644,7 @@ static void __devinit migrate_timers(int
 {
 	tvec_base_t *old_base;
 	tvec_base_t *new_base;
+	spinlock_t *lock1, *lock2;
 	int i;
 
 	BUG_ON(cpu_online(cpu));
@@ -1651,8 +1652,15 @@ static void __devinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	/*
+	 * If we take a lock from a different cpu, make sure we have always
+	 * the same locking order. That is the lock that belongs to the cpu
+	 * with the lowest number is taken first.
+	 */
+	lock1 = smp_processor_id() < cpu ? &new_base->lock : &old_base->lock;
+	lock2 = smp_processor_id() < cpu ? &old_base->lock : &new_base->lock;
+	spin_lock(lock1);
+	spin_lock(lock2);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1665,8 +1673,8 @@ static void __devinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	spin_unlock(lock2);
+	spin_unlock(lock1);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
