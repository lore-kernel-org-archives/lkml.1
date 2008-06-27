Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYF0APm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYF0APm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYF0APW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:15:22 -0400
Received: from saeurebad.de ([85.214.36.134]:59897 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbYF0APU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:15:20 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 02:08:05 2008
Message-Id: <20080627000805.078016926@saeurebad.de>
References: <20080627000445.346130358@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 02:04:46 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] softlockup: only reset timestamp from NMI code
Content-Disposition: inline; filename=softlockup-only-reset-from-nmi-code.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 9c106c119e "softlockup: fix NMI hangs due to lock race -
2.6.26-rc regression", touching the softlockup watchdog from the
outside world means resetting the timestamp to zero instead of
updating it to the current time.

However, the following code sequence is an example of where this
causes the watchdog task not getting awakened for quite some time:

tick_nohz_handler()
  touch_softlockup_watchdog()	/* reset timestamp */
  update_process_times()
    softlockup_tick()		/* update timestamp */

The same path is in tick_sched_timer().

The idea is to just not warn about an expected delay here, but it
prevents the watchdog task from being woken, too, and no check for
hung tasks will be performed.

This patch introduces reset_softlockup_watchdog() for the NMI users
and reverts touch_softlockup_watchdog() to its old behaviour.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/x86/kernel/nmi_32.c |    2 +-
 arch/x86/kernel/nmi_64.c |    2 +-
 include/linux/nmi.h      |    2 +-
 include/linux/sched.h    |    4 ++++
 kernel/softlockup.c      |   15 ++++++++-------
 5 files changed, 15 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -310,7 +310,7 @@ void touch_nmi_watchdog(void)
 	/*
 	 * Tickle the softlockup detector too:
 	 */
-	touch_softlockup_watchdog();
+	reset_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -309,7 +309,7 @@ void touch_nmi_watchdog(void)
 		}
 	}
 
-	touch_softlockup_watchdog();
+	reset_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -22,7 +22,7 @@ extern void acpi_nmi_enable(void);
 #else
 static inline void touch_nmi_watchdog(void)
 {
-	touch_softlockup_watchdog();
+	reset_softlockup_watchdog();
 }
 static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -293,6 +293,7 @@ extern void sched_show_task(struct task_
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
+extern void reset_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned long  softlockup_thresh;
 extern unsigned long sysctl_hung_task_check_count;
@@ -308,6 +309,9 @@ static inline void spawn_softlockup_task
 static inline void touch_softlockup_watchdog(void)
 {
 }
+static inline void reset_softlockup_watchdog(void)
+{
+}
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -49,18 +49,19 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static void __touch_softlockup_watchdog(void)
+void touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
 
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
+EXPORT_SYMBOL(touch_softlockup_watchdog);
 
-void touch_softlockup_watchdog(void)
+void reset_softlockup_watchdog(void)
 {
 	__raw_get_cpu_var(touch_timestamp) = 0;
 }
-EXPORT_SYMBOL(touch_softlockup_watchdog);
+EXPORT_SYMBOL(reset_softlockup_watchdog);
 
 void touch_all_softlockup_watchdogs(void)
 {
@@ -85,7 +86,7 @@ void softlockup_tick(void)
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
-		__touch_softlockup_watchdog();
+		touch_softlockup_watchdog();
 		return;
 	}
 
@@ -100,7 +101,7 @@ void softlockup_tick(void)
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		__touch_softlockup_watchdog();
+		touch_softlockup_watchdog();
 		return;
 	}
 
@@ -219,7 +220,7 @@ static int watchdog(void *__bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	/* initialize timestamp */
-	__touch_softlockup_watchdog();
+	touch_softlockup_watchdog();
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
@@ -228,7 +229,7 @@ static int watchdog(void *__bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		__touch_softlockup_watchdog();
+		touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())

-- 

