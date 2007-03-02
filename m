Return-Path: <linux-kernel-owner+w=401wt.eu-S2992699AbXCBWtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992699AbXCBWtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992702AbXCBWti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:49:38 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:48076 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992699AbXCBWth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:49:37 -0500
Date: Fri, 2 Mar 2007 23:47:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070302224752.GB9514@osiris.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com> <20070302125848.GA8226@osiris.boeblingen.de.ibm.com> <20070302130433.GA4391@elte.hu> <20070302142308.GB8226@osiris.boeblingen.de.ibm.com> <20070302084833.732d09dd.akpm@linux-foundation.org> <20070302190836.GA7942@osiris.ibm.com> <20070302114524.1c61cf22.akpm@linux-foundation.org> <20070302213959.GA9514@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302213959.GA9514@osiris.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

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

The same problem exists in kernel/timer.c: migrate_timers().

As pointed out by Christian Borntraeger one possible solution to avoid
the locking order complaints would be to make sure that the locks are
always taken in the same order. E.g. by taking the lock of the cpu with
the lower number first.

To achieve this we introduce two new spinlock functions double_spin_lock
and double_spin_unlock which lock or unlock two locks in a given order.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Christian Borntraeger <cborntra@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Next try. Hopefully the interface with "l1_first" and "l1_taken_first"
is not confusing?

 include/linux/spinlock.h |   37 +++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c         |    9 ++++-----
 kernel/timer.c           |    8 ++++----
 3 files changed, 45 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1355,17 +1355,16 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_spin_lock(&new_base->lock, &old_base->lock,
+			 smp_processor_id() < cpu);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
 
+	double_spin_unlock(&new_base->lock, &old_base->lock,
+			   smp_processor_id() < cpu);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1651,8 +1651,8 @@ static void __devinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_spin_lock(&new_base->lock, &old_base->lock,
+			 smp_processor_id() < cpu);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1665,8 +1665,8 @@ static void __devinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	double_spin_unlock(&new_base->lock, &old_base->lock,
+			   smp_processor_id() < cpu);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
Index: linux-2.6/include/linux/spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock.h
+++ linux-2.6/include/linux/spinlock.h
@@ -283,6 +283,43 @@ do {						\
 })
 
 /*
+ * Locks two spinlocks l1 and l2.
+ * l1_first indicates if spinlock l1 should be taken first.
+ */
+static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
+				    bool l1_first)
+	__acquires(l1)
+	__acquires(l2)
+{
+	if (l1_first) {
+		spin_lock(l1);
+		spin_lock(l2);
+	} else {
+		spin_lock(l2);
+		spin_lock(l1);
+	}
+}
+
+/*
+ * Unlocks two spinlocks l1 and l2.
+ * l1_taken_first indicates if spinlock l1 was taken first and therefore
+ * should be released after spinlock l2.
+ */
+static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
+				      bool l1_taken_first)
+	__releases(l1)
+	__releases(l2)
+{
+	if (l1_taken_first) {
+		spin_unlock(l2);
+		spin_unlock(l1);
+	} else {
+		spin_unlock(l1);
+		spin_unlock(l2);
+	}
+}
+
+/*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
