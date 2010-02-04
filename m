Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0BDTKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:10:21 -0500
Received: from www.tglx.de ([62.245.132.106]:44187 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0BDTKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:10:19 -0500
Date: Thu, 4 Feb 2010 20:09:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] core fixes for 2.6.33
Message-ID: <alpine.LFD.2.00.1002041845020.3006@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	tglx

------------------>
Jason Wessel (1):
      softlockup: Add sched_clock_tick() to avoid kernel warning on kgdb resume

Mikael Pettersson (1):
      futex_lock_pi() key refcnt fix

Thomas Gleixner (2):
      futex: Handle user space corruption gracefully
      futex: Handle futex value corruption gracefully


 include/linux/sched.h |    4 ++++
 kernel/futex.c        |   30 +++++++++++++++++++++++++++---
 kernel/kgdb.c         |    6 +++---
 kernel/softlockup.c   |   15 +++++++++++++++
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6f7bba9..8923215 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -310,6 +310,7 @@ extern void sched_show_task(struct task_struct *p);
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
+extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 				    void __user *buffer,
@@ -323,6 +324,9 @@ static inline void softlockup_tick(void)
 static inline void touch_softlockup_watchdog(void)
 {
 }
+static inline void touch_softlockup_watchdog_sync(void)
+{
+}
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
diff --git a/kernel/futex.c b/kernel/futex.c
index d9b3a22..e7a35f1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -530,8 +530,25 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 				return -EINVAL;
 
 			WARN_ON(!atomic_read(&pi_state->refcount));
-			WARN_ON(pid && pi_state->owner &&
-				pi_state->owner->pid != pid);
+
+			/*
+			 * When pi_state->owner is NULL then the owner died
+			 * and another waiter is on the fly. pi_state->owner
+			 * is fixed up by the task which acquires
+			 * pi_state->rt_mutex.
+			 *
+			 * We do not check for pid == 0 which can happen when
+			 * the owner died and robust_list_exit() cleared the
+			 * TID.
+			 */
+			if (pid && pi_state->owner) {
+				/*
+				 * Bail out if user space manipulated the
+				 * futex value.
+				 */
+				if (pid != task_pid_vnr(pi_state->owner))
+					return -EINVAL;
+			}
 
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;
@@ -758,6 +775,13 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	if (!pi_state)
 		return -EINVAL;
 
+	/*
+	 * If current does not own the pi_state then the futex is
+	 * inconsistent and user space fiddled with the futex value.
+	 */
+	if (pi_state->owner != current)
+		return -EINVAL;
+
 	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
@@ -1971,7 +1995,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	goto out;
+	goto out_put_key;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2eb517e..87f2cc5 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -596,7 +596,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1450,7 +1450,7 @@ acquirelock:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
-		touch_softlockup_watchdog();
+		touch_softlockup_watchdog_sync();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1550,7 +1550,7 @@ kgdb_restore:
 	}
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index d225790..0d4c789 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -25,6 +25,7 @@ static DEFINE_SPINLOCK(print_lock);
 static DEFINE_PER_CPU(unsigned long, softlockup_touch_ts); /* touch timestamp */
 static DEFINE_PER_CPU(unsigned long, softlockup_print_ts); /* print timestamp */
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
+static DEFINE_PER_CPU(bool, softlock_touch_sync);
 
 static int __read_mostly did_panic;
 int __read_mostly softlockup_thresh = 60;
@@ -79,6 +80,12 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
+void touch_softlockup_watchdog_sync(void)
+{
+	__raw_get_cpu_var(softlock_touch_sync) = true;
+	__raw_get_cpu_var(softlockup_touch_ts) = 0;
+}
+
 void touch_all_softlockup_watchdogs(void)
 {
 	int cpu;
@@ -118,6 +125,14 @@ void softlockup_tick(void)
 	}
 
 	if (touch_ts == 0) {
+		if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			per_cpu(softlock_touch_sync, this_cpu) = false;
+			sched_clock_tick();
+		}
 		__touch_softlockup_watchdog();
 		return;
 	}
