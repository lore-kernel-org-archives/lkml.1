Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYIQJ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYIQJ7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYIQJ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:59:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYIQJ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:59:32 -0400
Date: Wed, 17 Sep 2008 11:59:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fixes
Message-ID: <20080917095908.GA9597@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Dominik Brodowski (1):
      clocksource, acpi_pm.c: fix check for monotonicity

Thomas Gleixner (2):
      clockevents: remove WARN_ON which was used to gather information
      clockevents: make device shutdown robust


 drivers/clocksource/acpi_pm.c |   21 ++++++++++-----------
 kernel/time/clockevents.c     |   12 +++++++++++-
 kernel/time/tick-broadcast.c  |    9 ++++-----
 kernel/time/tick-common.c     |    4 ++--
 kernel/time/tick-internal.h   |    2 ++
 5 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 4eee533..71d2ac4 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -178,11 +178,13 @@ static int verify_pmtmr_rate(void)
 
 /* Number of monotonicity checks to perform during initialization */
 #define ACPI_PM_MONOTONICITY_CHECKS 10
+/* Number of reads we try to get two different values */
+#define ACPI_PM_READ_CHECKS 10000
 
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
-	unsigned int i, j, good = 0;
+	unsigned int i, j = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -192,29 +194,26 @@ static int __init init_acpi_pm_clocksource(void)
 
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
+		udelay(100 * j);
 		value1 = clocksource_acpi_pm.read();
-		for (i = 0; i < 10000; i++) {
+		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
 			value2 = clocksource_acpi_pm.read();
 			if (value2 == value1)
 				continue;
 			if (value2 > value1)
-				good++;
 				break;
 			if ((value2 < value1) && ((value2) < 0xFFF))
-				good++;
 				break;
 			printk(KERN_INFO "PM-Timer had inconsistent results:"
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
 			return -EINVAL;
 		}
-		udelay(300 * i);
-	}
-
-	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
-		printk(KERN_INFO "PM-Timer failed consistency check "
-		       " (0x%#llx) - aborting.\n", value1);
-		return -ENODEV;
+		if (i == ACPI_PM_READ_CHECKS) {
+			printk(KERN_INFO "PM-Timer failed consistency check "
+			       " (0x%#llx) - aborting.\n", value1);
+			return -ENODEV;
+		}
 	}
 
 	if (verify_pmtmr_rate() != 0)
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1876b52..f8d9680 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -72,6 +72,16 @@ void clockevents_set_mode(struct clock_event_device *dev,
 }
 
 /**
+ * clockevents_shutdown - shutdown the device and clear next_event
+ * @dev:	device to shutdown
+ */
+void clockevents_shutdown(struct clock_event_device *dev)
+{
+	clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+	dev->next_event.tv64 = KTIME_MAX;
+}
+
+/**
  * clockevents_program_event - Reprogram the clock event device.
  * @expires:	absolute expiry time (monotonic clock)
  *
@@ -206,7 +216,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 
 	if (new) {
 		BUG_ON(new->mode != CLOCK_EVT_MODE_UNUSED);
-		clockevents_set_mode(new, CLOCK_EVT_MODE_SHUTDOWN);
+		clockevents_shutdown(new);
 	}
 	local_irq_restore(flags);
 }
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 2f5a382..f1f3eee 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -236,8 +236,7 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
 			if (td->mode == TICKDEV_MODE_PERIODIC)
-				clockevents_set_mode(dev,
-						     CLOCK_EVT_MODE_SHUTDOWN);
+				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
 			tick_broadcast_force = 1;
@@ -254,7 +253,7 @@ static void tick_do_broadcast_on_off(void *why)
 
 	if (cpus_empty(tick_broadcast_mask)) {
 		if (!bc_stopped)
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+			clockevents_shutdown(bc);
 	} else if (bc_stopped) {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
@@ -306,7 +305,7 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
 		if (bc && cpus_empty(tick_broadcast_mask))
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+			clockevents_shutdown(bc);
 	}
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -321,7 +320,7 @@ void tick_suspend_broadcast(void)
 
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+		clockevents_shutdown(bc);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index c477719..019315e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -249,7 +249,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	 * not give it back to the clockevents layer !
 	 */
 	if (tick_is_broadcast_device(curdev)) {
-		clockevents_set_mode(curdev, CLOCK_EVT_MODE_SHUTDOWN);
+		clockevents_shutdown(curdev);
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
@@ -311,7 +311,7 @@ static void tick_suspend(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
+	clockevents_shutdown(td->evtdev);
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 0ffc291..6e9db97 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -10,6 +10,8 @@ extern int tick_do_timer_cpu __read_mostly;
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
 
+extern void clockevents_shutdown(struct clock_event_device *dev);
+
 /*
  * NO_HZ / high resolution timer shared code
  */
