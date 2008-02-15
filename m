Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbYBOR7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbYBOR7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbYBOR6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:38 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58477 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbYBOR6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:37 -0500
Date: Fri, 15 Feb 2008 21:01:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] timers: simplify lockdep stuff
Message-ID: <20080215180154.GA4347@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid the false positive from lockdep, each per-cpu base->lock has
the separate lock class and migrate_timers() uses double_spin_lock().

This all is overcomplicated: except for migrate_timers() we never take 2 locks
at once, and migrate_timers() can use spin_lock_nested().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/timer.c~2_TIMERS	2008-02-15 16:59:18.000000000 +0300
+++ 25/kernel/timer.c	2008-02-15 19:17:29.000000000 +0300
@@ -1220,13 +1220,6 @@ asmlinkage long sys_sysinfo(struct sysin
 	return 0;
 }
 
-/*
- * lockdep: we want to track each per-CPU base as a separate lock-class,
- * but timer-bases are kmalloc()-ed, so we need to attach separate
- * keys to them:
- */
-static struct lock_class_key base_lock_keys[NR_CPUS];
-
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
@@ -1269,7 +1262,6 @@ static int __cpuinit init_timers_cpu(int
 	}
 
 	spin_lock_init(&base->lock);
-	lockdep_set_class(&base->lock, base_lock_keys + cpu);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
@@ -1308,8 +1300,8 @@ static void __cpuinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1322,8 +1314,8 @@ static void __cpuinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }

