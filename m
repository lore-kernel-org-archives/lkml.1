Return-Path: <linux-kernel-owner+w=401wt.eu-S2992462AbXCPXTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992462AbXCPXTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992463AbXCPXTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:19:04 -0400
Received: from www.osadl.org ([213.239.205.134]:55161 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992462AbXCPXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:19:03 -0400
Subject: [PATCH] clockevents: Fix suspend/resume to disk hangs
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <1174078066.13341.279.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <200703162134.14265.rjw@sisk.pl>
	 <1174078066.13341.279.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:25:52 +0100
Message-Id: <1174087552.13341.332.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I finally found a dual core box, which survives suspend/resume without
crashing in the middle of nowhere. Sigh, I never figured out from the
code and the bug reports what's going on.

The observed hangs are caused by a stale state transition of the clock
event devices, which keeps the RCU synchronization away from completion,
when the non boot CPU is brought back up.

The suspend/resume in oneshot mode needs the similar care as the
periodic mode during suspend to RAM. My assumption that the state
transitions during the different shutdown/bringups of s2disk would go
through the periodic boot phase and then switch over to highres resp.
nohz mode were simply wrong.

Add the appropriate suspend / resume handling for the non periodic
modes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 5567745..eadfce2 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -307,12 +307,19 @@ int tick_resume_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc) {
-		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC &&
-		    !cpus_empty(tick_broadcast_mask))
-			tick_broadcast_start_periodic(bc);
 
-		broadcast = cpu_isset(smp_processor_id(), tick_broadcast_mask);
+	if (bc) {
+		switch (tick_broadcast_device.mode) {
+		case TICKDEV_MODE_PERIODIC:
+			if(!cpus_empty(tick_broadcast_mask))
+				tick_broadcast_start_periodic(bc);
+			broadcast = cpu_isset(smp_processor_id(),
+					      tick_broadcast_mask);
+			break;
+		case TICKDEV_MODE_ONESHOT:
+			broadcast = tick_resume_broadcast_oneshot(bc);
+			break;
+		}
 	}
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 
@@ -347,6 +354,16 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
 	}
 }
 
+int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
+{
+	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+
+	if(!cpus_empty(tick_broadcast_oneshot_mask))
+		tick_broadcast_set_event(ktime_get(), 1);
+
+	return cpu_isset(smp_processor_id(), tick_broadcast_oneshot_mask);
+}
+
 /*
  * Reprogram the broadcast device:
  *
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 43ba1bd..bfda3f7 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -298,18 +298,17 @@ static void tick_shutdown(unsigned int *cpup)
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-static void tick_suspend_periodic(void)
+static void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	if (td->mode == TICKDEV_MODE_PERIODIC)
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
+	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-static void tick_resume_periodic(void)
+static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
@@ -317,6 +316,8 @@ static void tick_resume_periodic(void)
 	spin_lock_irqsave(&tick_device_lock, flags);
 	if (td->mode == TICKDEV_MODE_PERIODIC)
 		tick_setup_periodic(td->evtdev, 0);
+	else
+		tick_resume_oneshot();
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -348,13 +349,13 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
-		tick_suspend_periodic();
+		tick_suspend();
 		tick_suspend_broadcast();
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
 		if (!tick_resume_broadcast())
-			tick_resume_periodic();
+			tick_resume();
 		break;
 
 	default:
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 75890ef..c9d203b 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -19,12 +19,13 @@ extern void tick_setup_oneshot(struct clock_event_device *newdev,
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
-
+extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
 extern void tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
+extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -43,6 +44,10 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
 {
 	BUG();
 }
+static inline void tick_resume_oneshot(void)
+{
+	BUG();
+}
 static inline int tick_program_event(ktime_t expires, int force)
 {
 	return 0;
@@ -54,6 +59,10 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 }
 static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
+{
+	return 0;
+}
 #endif /* !TICK_ONESHOT */
 
 /*
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2e8b7ff..f6997ab 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -41,6 +41,18 @@ int tick_program_event(ktime_t expires, int force)
 }
 
 /**
+ * tick_resume_onshot - resume oneshot mode
+ */
+void tick_resume_oneshot(void)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct clock_event_device *dev = td->evtdev;
+
+	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+	tick_program_event(ktime_get(), 1);
+}
+
+/**
  * tick_setup_oneshot - setup the event device for oneshot mode (hres or nohz)
  */
 void tick_setup_oneshot(struct clock_event_device *newdev,


