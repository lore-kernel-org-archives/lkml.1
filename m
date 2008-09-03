Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYICVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYICVi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYICVhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:37:41 -0400
Received: from www.tglx.de ([62.245.132.106]:41400 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbYICVhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:39 -0400
Message-Id: <20080903212753.342810660@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:37:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 5/6] clockevents: prevent endless loop lockup
Content-Disposition: inline;
	filename=clockevents-prevent-endless-loop-lockup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C1E/HPET bug reports on AMDX2/RS690 systems where tracked down to a
too small value of the HPET minumum delta for programming an event.

The clockevents code needs to enforce an interrupt event on the clock event
device in some cases. The enforcement code was stupid and naive, as it just
added the minimum delta to the current time and tried to reprogram the device.
When the minimum delta is too small, then this loops forever.

Add a sanity check. Allow reprogramming to fail 3 times, then print a warning
and double the minimum delta value to make sure, that this does not happen again.
Use the same function for both tick-oneshot and tick-broadcast code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   10 +---------
 kernel/time/tick-internal.h  |    2 ++
 kernel/time/tick-oneshot.c   |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -372,16 +372,8 @@ cpumask_t *tick_get_broadcast_oneshot_ma
 static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
-	ktime_t now = ktime_get();
-	int res;
 
-	for(;;) {
-		res = clockevents_program_event(bc, expires, now);
-		if (!res || !force)
-			return res;
-		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, bc->min_delta_ns));
-	}
+	return tick_dev_program_event(bc, expires, force);
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
Index: linux-2.6/kernel/time/tick-internal.h
===================================================================
--- linux-2.6.orig/kernel/time/tick-internal.h
+++ linux-2.6/kernel/time/tick-internal.h
@@ -17,6 +17,8 @@ extern void tick_handle_periodic(struct 
 extern void tick_setup_oneshot(struct clock_event_device *newdev,
 			       void (*handler)(struct clock_event_device *),
 			       ktime_t nextevt);
+extern int tick_dev_program_event(struct clock_event_device *dev,
+				  ktime_t expires, int force);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
Index: linux-2.6/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-oneshot.c
+++ linux-2.6/kernel/time/tick-oneshot.c
@@ -25,18 +25,42 @@
 /**
  * tick_program_event internal worker function
  */
-static int __tick_program_event(struct clock_event_device *dev,
-				ktime_t expires, int force)
+int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
+			   int force)
 {
 	ktime_t now = ktime_get();
+	int i;
 
-	while (1) {
+	for (i = 0;;) {
 		int ret = clockevents_program_event(dev, expires, now);
 
 		if (!ret || !force)
 			return ret;
+
+		/*
+		 * We tried 2 times to program the device with the given
+		 * min_delta_ns. If that's not working then we double it
+		 * and emit a warning.
+		 */
+		if (++i > 2) {
+			printk(KERN_WARNING "CE: __tick_program_event of %s is "
+			       "stuck %llx %llx\n", dev->name ? dev->name : "?",
+			       now.tv64, expires.tv64);
+			printk(KERN_WARNING
+			       "CE: increasing min_delta_ns %ld to %ld nsec\n",
+			       dev->min_delta_ns, dev->min_delta_ns << 1);
+			WARN_ON(1);
+
+			/* Double the min. delta and try again */
+			if (!dev->min_delta_ns)
+				dev->min_delta_ns = 5000;
+			else
+				dev->min_delta_ns <<= 1;
+			i = 0;
+		}
+
 		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, dev->min_delta_ns));
+		expires = ktime_add_ns(now, dev->min_delta_ns);
 	}
 }
 
@@ -47,7 +71,7 @@ int tick_program_event(ktime_t expires, 
 {
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 
-	return __tick_program_event(dev, expires, force);
+	return tick_dev_program_event(dev, expires, force);
 }
 
 /**
@@ -71,7 +95,7 @@ void tick_setup_oneshot(struct clock_eve
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	__tick_program_event(newdev, next_event, 1);
+	tick_dev_program_event(newdev, next_event, 1);
 }
 
 /**

-- 

