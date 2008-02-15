Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYBOR7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYBOR7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbYBOR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:44 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58482 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760172AbYBOR6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:42 -0500
Date: Fri, 15 Feb 2008 21:01:56 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] hrtimers: simplify lockdep stuff
Message-ID: <20080215180156.GA4350@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid the false positive from lockdep, each per-cpu base->lock has
the separate lock class and migrate_hrtimers() uses double_spin_lock().

This is overcomplicated: except for migrate_hrtimers() we never take 2 locks at
once, and migrate_hrtimers() can use spin_lock_nested().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/hrtimer.h~3_HRTIMERS	2008-02-15 16:59:17.000000000 +0300
+++ 25/include/linux/hrtimer.h	2008-02-15 19:23:02.000000000 +0300
@@ -173,7 +173,6 @@ struct hrtimer_clock_base {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
- * @lock_key:		the lock_class_key for use with lockdep
  * @clock_base:		array of clock bases for this cpu
  * @curr_timer:		the timer which is executing a callback right now
  * @expires_next:	absolute time of the next event which was scheduled
@@ -189,7 +188,6 @@ struct hrtimer_clock_base {
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
-	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 	struct list_head		cb_pending;
 #ifdef CONFIG_HIGH_RES_TIMERS
--- 25/kernel/hrtimer.c~3_HRTIMERS	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/hrtimer.c	2008-02-15 19:51:05.000000000 +0300
@@ -1411,7 +1411,6 @@ static void __cpuinit init_hrtimers_cpu(
 	int i;
 
 	spin_lock_init(&cpu_base->lock);
-	lockdep_set_class(&cpu_base->lock, &cpu_base->lock_key);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
@@ -1452,16 +1451,16 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }

