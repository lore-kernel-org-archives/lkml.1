Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYF1QQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYF1QQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYF1QQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:16:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43580 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYF1QQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:16:17 -0400
Date: Sat, 28 Jun 2008 20:18:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] migrate_timers: add comment, use spinlock_irq()
Message-ID: <20080628161856.GA7030@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the comment to explain why the double lock in migrate_timers()
can't deadlock.

Change the code to use spinlock_irq() instead of local_irq_disable()
+ spin_lock().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/timer.c~MIGRATE_TIMERS	2008-05-18 15:44:19.000000000 +0400
+++ 26-rc2/kernel/timer.c	2008-06-28 20:07:49.000000000 +0400
@@ -1443,9 +1443,11 @@ static void __cpuinit migrate_timers(int
 	BUG_ON(cpu_online(cpu));
 	old_base = per_cpu(tvec_bases, cpu);
 	new_base = get_cpu_var(tvec_bases);
-
-	local_irq_disable();
-	spin_lock(&new_base->lock);
+	/*
+	 * The caller is globally serialized and nobody else
+	 * takes two locks at once, deadlock is not possible.
+	 */
+	spin_lock_irq(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
@@ -1460,8 +1462,7 @@ static void __cpuinit migrate_timers(int
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_enable();
+	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(tvec_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
--- 26-rc2/kernel/hrtimer.c~MIGRATE_TIMERS	2008-05-18 15:44:18.000000000 +0400
+++ 26-rc2/kernel/hrtimer.c	2008-06-28 20:08:15.000000000 +0400
@@ -1615,9 +1615,11 @@ static void migrate_hrtimers(int cpu)
 	new_base = &get_cpu_var(hrtimer_bases);
 
 	tick_cancel_sched_timer(cpu);
-
-	local_irq_disable();
-	spin_lock(&new_base->lock);
+	/*
+	 * The caller is globally serialized and nobody else
+	 * takes two locks at once, deadlock is not possible.
+	 */
+	spin_lock_irq(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
@@ -1626,8 +1628,7 @@ static void migrate_hrtimers(int cpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_enable();
+	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */

