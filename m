Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbZFCPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbZFCPXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZFCPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:23:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35060 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZFCPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:23:13 -0400
Message-Id: <20090603152313.554915470@de.ibm.com>
References: <20090603152223.083010123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 17:22:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/2] keep on ticking if oprofile is active
Content-Disposition: inline; filename=profile-stop-nohz.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On a NOHZ system with oprofile enabled the timer tick should not be
stopped when a cpu goes idle. Oprofile needs the pt_regs structure
of the interrupt and allocates memory in the ring buffer for each
sample. Current a maximum of 1 tick is accounted with oprofile if a
cpu sleeps for a longer period of time. This does bad things to the
percentages in the oprofile output. To postpone the oprofile tick to
tick_nohz_restart_sched_tick analog to the in kernel profiler is not
possible as there is no pt_regs structure in the context the
tick_nohz_restart_sched_tick function is called and it is not a good
idea to create hundreds of samples at once.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/oprofile/oprof.c |    3 +++
 include/linux/tick.h     |    4 ++++
 kernel/time/tick-sched.c |   26 +++++++++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/oprofile/oprof.c
===================================================================
--- quilt-2.6.orig/drivers/oprofile/oprof.c
+++ quilt-2.6/drivers/oprofile/oprof.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/oprofile.h>
 #include <linux/moduleparam.h>
+#include <linux/tick.h>
 #include <asm/mutex.h>
 
 #include "oprof.h"
@@ -103,6 +104,7 @@ int oprofile_start(void)
 	if (oprofile_started)
 		goto out;
 
+	tick_nohz_disable();
 	oprofile_reset_stats();
 
 	if ((err = oprofile_ops.start()))
@@ -123,6 +125,7 @@ void oprofile_stop(void)
 		goto out;
 	oprofile_ops.stop();
 	oprofile_started = 0;
+	tick_nohz_enable();
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
 out:
Index: quilt-2.6/include/linux/tick.h
===================================================================
--- quilt-2.6.orig/include/linux/tick.h
+++ quilt-2.6/include/linux/tick.h
@@ -117,6 +117,8 @@ extern void tick_nohz_stop_sched_tick(in
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern void tick_nohz_enable(void);
+extern void tick_nohz_disable(void);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -127,6 +129,8 @@ static inline ktime_t tick_nohz_get_slee
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline void tick_nohz_enable(void) { }
+static inline void tick_nohz_disable(void) { }
 # endif /* !NO_HZ */
 
 #endif
Index: quilt-2.6/kernel/time/tick-sched.c
===================================================================
--- quilt-2.6.orig/kernel/time/tick-sched.c
+++ quilt-2.6/kernel/time/tick-sched.c
@@ -124,6 +124,29 @@ static int __init setup_tick_nohz(char *
 
 __setup("nohz=", setup_tick_nohz);
 
+/*
+ * NO HZ currently disabled ?
+ */
+static atomic_t tick_nohz_disable_counter = ATOMIC_INIT(0);
+
+void tick_nohz_enable(void)
+{
+	atomic_dec(&tick_nohz_disable_counter);
+}
+EXPORT_SYMBOL_GPL(tick_nohz_enable);
+
+static void __tick_nohz_disable(void *dummy)
+{
+}
+
+void tick_nohz_disable(void)
+{
+	if (atomic_inc_return(&tick_nohz_disable_counter) == 1)
+		/* Wake up all cpus to make them start ticking. */
+		smp_call_function(__tick_nohz_disable, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(tick_nohz_disable);
+
 /**
  * tick_nohz_update_jiffies - update jiffies when idle was interrupted
  *
@@ -272,7 +295,8 @@ void tick_nohz_stop_sched_tick(int inidl
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+	    atomic_read(&tick_nohz_disable_counter) > 0)
 		delta_jiffies = 1;
 	/*
 	 * Do not stop the tick, if we are only one off

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

