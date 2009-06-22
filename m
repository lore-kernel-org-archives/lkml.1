Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZFVO1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZFVO1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZFVO06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:26:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62746 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbZFVO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:26:57 -0400
Date: Mon, 22 Jun 2009 16:26:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 0/2] NOHZ vs. profile/oprofile v2
Message-ID: <20090622162631.4b4dcee4@skybase>
In-Reply-To: <alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
References: <20090603152223.083010123@de.ibm.com>
	<alpine.LFD.2.00.0906092252150.3351@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 22:52:51 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > version 2 of the profile patches. The only change is the in_interrupt()
> > fix in tick_nohz_stop_idle(). I would like to know how to proceed with
> > the issue.
> > Andy, do you still prefer to handle the old style profiler analog to
> > the oprofile patch? If yes I would drop patch #1 and extend patch #2
> > with another tick_nohz_disable().  
> 
> Any update on this one ?

A solution to this problem should go upstream soon, no? How about this
patch, it uses the tick_nohz_disable/tick_nohz_enable mechanic for 
oprofile and the old style kernel profiler. Good enough ?

---
Subject: [PATCH] keep on ticking if a profiler is active

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On a NOHZ system with oprofile or the old style kernel profiler enabled
the timer tick should not be stopped when a cpu goes idle. Currently
a maximum of 1 tick is accounted if a cpu sleeps for a longer period of
time. This does bad things to the percentages in the profiler output.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/oprofile/oprof.c |    3 +++
 include/linux/tick.h     |    4 ++++
 kernel/profile.c         |    4 ++++
 kernel/time/tick-sched.c |   27 ++++++++++++++++++++++++++-
 4 files changed, 37 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/oprofile/oprof.c linux-2.6-patched/drivers/oprofile/oprof.c
--- linux-2.6/drivers/oprofile/oprof.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6-patched/drivers/oprofile/oprof.c	2009-06-22 11:26:50.000000000 +0200
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
 
+	tick_nohz_disable(1);
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
diff -urpN linux-2.6/include/linux/tick.h linux-2.6-patched/include/linux/tick.h
--- linux-2.6/include/linux/tick.h	2009-06-22 11:26:26.000000000 +0200
+++ linux-2.6-patched/include/linux/tick.h	2009-06-22 11:26:50.000000000 +0200
@@ -119,6 +119,8 @@ extern void tick_nohz_stop_sched_tick(in
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern void tick_nohz_enable(void);
+extern void tick_nohz_disable(int wakeup);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -129,6 +131,8 @@ static inline ktime_t tick_nohz_get_slee
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline void tick_nohz_enable(void) { }
+static inline void tick_nohz_disable(int wakeup) { }
 # endif /* !NO_HZ */
 
 #endif
diff -urpN linux-2.6/kernel/profile.c linux-2.6-patched/kernel/profile.c
--- linux-2.6/kernel/profile.c	2009-06-22 11:26:26.000000000 +0200
+++ linux-2.6-patched/kernel/profile.c	2009-06-22 11:26:50.000000000 +0200
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/tick.h>
 #include <asm/sections.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
@@ -97,6 +98,8 @@ int profile_setup(char *str)
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
+	if (prof_on)
+		tick_nohz_disable(0);
 	return 1;
 }
 __setup("profile=", profile_setup);
@@ -582,6 +585,7 @@ static int create_hash_tables(void)
 	return 0;
 out_cleanup:
 	prof_on = 0;
+	tick_nohz_enable();
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 1);
 	for_each_online_cpu(cpu) {
diff -urpN linux-2.6/kernel/time/tick-sched.c linux-2.6-patched/kernel/time/tick-sched.c
--- linux-2.6/kernel/time/tick-sched.c	2009-06-22 11:26:26.000000000 +0200
+++ linux-2.6-patched/kernel/time/tick-sched.c	2009-06-22 11:26:50.000000000 +0200
@@ -124,6 +124,30 @@ static int __init setup_tick_nohz(char *
 
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
+void tick_nohz_disable(int wakeup)
+{
+	if (atomic_inc_return(&tick_nohz_disable_counter) == 1)
+		if (wakeup)
+			/* Wake up all cpus to make them start ticking. */
+			smp_call_function(__tick_nohz_disable, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(tick_nohz_disable);
+
 /**
  * tick_nohz_update_jiffies - update jiffies when idle was interrupted
  *
@@ -276,7 +300,8 @@ void tick_nohz_stop_sched_tick(int inidl
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
