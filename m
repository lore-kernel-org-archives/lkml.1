Return-Path: <linux-kernel-owner+w=401wt.eu-S965143AbXCBTKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143AbXCBTKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXCBTKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:10:23 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:59371 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822AbXCBTKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:10:21 -0500
Date: Fri, 2 Mar 2007 20:08:36 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070302190836.GA7942@osiris.ibm.com>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com> <20070302125848.GA8226@osiris.boeblingen.de.ibm.com> <20070302130433.GA4391@elte.hu> <20070302142308.GB8226@osiris.boeblingen.de.ibm.com> <20070302084833.732d09dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302084833.732d09dd.akpm@linux-foundation.org>
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
 kernel/hrtimer.c |   39 ++++++++++++++++++++++++++++++++++-----
 kernel/timer.c   |   38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1343,6 +1343,38 @@ static void migrate_hrtimer_list(struct 
 	}
 }
 
+/*
+ * double_hrtimer_lock/unlock are used to ensure that on cpu hotplug the
+ * per cpu timer locks are always taken in the same order.
+ */
+static void double_hrtimer_lock(struct hrtimer_cpu_base *base1,
+				struct hrtimer_cpu_base *base2, int ind)
+	__acquires(base1->lock)
+	__acquires(base2->lock)
+{
+	if (ind < 0) {
+		spin_lock(&base1->lock);
+		spin_lock(&base2->lock);
+	} else {
+		spin_lock(&base2->lock);
+		spin_lock(&base1->lock);
+	}
+}
+
+static void double_hrtimer_unlock(struct hrtimer_cpu_base *base1,
+				  struct hrtimer_cpu_base *base2, int ind)
+	__releases(base1->lock)
+	__releases(base2->lock)
+{
+	if (ind < 0) {
+		spin_unlock(&base2->lock);
+		spin_unlock(&base1->lock);
+	} else {
+		spin_unlock(&base1->lock);
+		spin_unlock(&base2->lock);
+	}
+}
+
 static void migrate_hrtimers(int cpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
@@ -1355,17 +1387,14 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_hrtimer_lock(new_base, old_base, smp_processor_id() - cpu);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
 
+	double_hrtimer_unlock(new_base, old_base, smp_processor_id() - cpu);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1640,6 +1640,38 @@ static void migrate_timer_list(tvec_base
 	}
 }
 
+/*
+ * double_timer_lock/unlock are used to ensure that on cpu hotplug the
+ * per cpu timer locks are always taken in the same order.
+ */
+static void __devinit double_timer_lock(tvec_base_t *base1,
+					tvec_base_t *base2, int ind)
+	__acquires(base1->lock)
+	__acquires(base2->lock)
+{
+	if (ind < 0) {
+		spin_lock(&base1->lock);
+		spin_lock(&base2->lock);
+	} else {
+		spin_lock(&base2->lock);
+		spin_lock(&base1->lock);
+	}
+}
+
+static void __devinit double_timer_unlock(tvec_base_t *base1,
+					  tvec_base_t *base2, int ind)
+	__releases(base1->lock)
+	__releases(base2->lock)
+{
+	if (ind < 0) {
+		spin_unlock(&base2->lock);
+		spin_unlock(&base1->lock);
+	} else {
+		spin_unlock(&base1->lock);
+		spin_unlock(&base2->lock);
+	}
+}
+
 static void __devinit migrate_timers(int cpu)
 {
 	tvec_base_t *old_base;
@@ -1651,8 +1683,7 @@ static void __devinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_timer_lock(new_base, old_base, smp_processor_id() - cpu);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1665,8 +1696,7 @@ static void __devinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	double_timer_unlock(new_base, old_base, smp_processor_id() - cpu);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
