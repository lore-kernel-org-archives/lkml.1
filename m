Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0BAH20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:28:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0BAH2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:28:24 -0500
Date: Mon, 1 Feb 2010 07:27:38 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jason.wessel@windriver.com, tglx@linutronix.de, mingo@elte.hu,
       Dongdong.Deng@windriver.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com, tglx@linutronix.de,
       Dongdong.Deng@windriver.com, mingo@elte.hu
In-Reply-To: <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
References: <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] softlockup: Add sched_clock_tick() to avoid kernel warning on kgdb resume
Message-ID: <tip-d6ad3e286d2c075a60b9f11075a2c55aeeeca2ad@git.kernel.org>
Git-Commit-ID: d6ad3e286d2c075a60b9f11075a2c55aeeeca2ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Feb 2010 07:27:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6ad3e286d2c075a60b9f11075a2c55aeeeca2ad
Gitweb:     http://git.kernel.org/tip/d6ad3e286d2c075a60b9f11075a2c55aeeeca2ad
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Wed, 27 Jan 2010 16:25:22 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Feb 2010 08:22:32 +0100

softlockup: Add sched_clock_tick() to avoid kernel warning on kgdb resume

When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set, sched_clock() gets
the time from hardware such as the TSC on x86. In this
configuration kgdb will report a softlock warning message on
resuming or detaching from a debug session.

Sequence of events in the problem case:

 1) "cpu sched clock" and "hardware time" are at 100 sec prior
    to a call to kgdb_handle_exception()

 2) Debugger waits in kgdb_handle_exception() for 80 sec and on
    exit the following is called ...  touch_softlockup_watchdog() -->
    __raw_get_cpu_var(touch_timestamp) = 0;

 3) "cpu sched clock" = 100s (it was not updated, because the
    interrupt was disabled in kgdb) but the "hardware time" = 180 sec

 4) The first timer interrupt after resuming from
    kgdb_handle_exception updates the watchdog from the "cpu sched clock"

update_process_times() { ...  run_local_timers() -->
softlockup_tick() --> check (touch_timestamp == 0) (it is "YES"
here, we have set "touch_timestamp = 0" at kgdb) -->
__touch_softlockup_watchdog() ***(A)--> reset "touch_timestamp"
to "get_timestamp()" (Here, the "touch_timestamp" will still be
set to 100s.)  ...

    scheduler_tick() ***(B)--> sched_clock_tick() (update "cpu sched
    clock" to "hardware time" = 180s) ...  }

 5) The Second timer interrupt handler appears to have a large
    jump and trips the softlockup warning.

update_process_times() { ...  run_local_timers() -->
softlockup_tick() --> "cpu sched clock" - "touch_timestamp" =
180s-100s > 60s --> printk "soft lockup error messages" ...  }

note: ***(A) reset "touch_timestamp" to
"get_timestamp(this_cpu)"

Why is "touch_timestamp" 100 sec, instead of 180 sec?

When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set, the call trace of
get_timestamp() is:

get_timestamp(this_cpu)
 -->cpu_clock(this_cpu)
 -->sched_clock_cpu(this_cpu)
 -->__update_sched_clock(sched_clock_data, now)

The __update_sched_clock() function uses the GTOD tick value to
create a window to normalize the "now" values.  So if "now"
value is too big for sched_clock_data, it will be ignored.

The fix is to invoke sched_clock_tick() to update "cpu sched
clock" in order to recover from this state.  This is done by
introducing the function touch_softlockup_watchdog_sync(). This
allows kgdb to request that the sched clock is updated when the
watchdog thread runs the first time after a resume from kgdb.

[yong.zhang0@gmail.com: Use per cpu instead of an array]
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: peterz@infradead.org
LKML-Reference: <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 ++++
 kernel/kgdb.c         |    6 +++---
 kernel/softlockup.c   |   15 +++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

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
