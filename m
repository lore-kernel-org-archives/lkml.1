Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXCFH3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXCFH3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXCFH3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:29:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38013 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbXCFH3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:29:05 -0500
Date: Tue, 6 Mar 2007 08:25:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306072542.GA30153@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain> <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Compiling right now - delayed because I just had to pick up one of 
> > the kids from gymnastics.
> 
> Ok, it does indeed solve the problem for me.
> 
> Mind sending a signed-off thing with explanations etc?

here's Thomas' patch with explanations:

------------------------->
From: Thomas Gleixner <tglx@linutronix.de>

The programming of periodic tick devices needs to be saved/restored 
across suspend/resume - otherwise we might end up with a system coming 
up that relies on getting a PIT (or HPET) interrupt, while those devices 
default to 'no interrupts' after powerup. (To confuse things it worked 
to a certain degree on some systems because the lapic gets initialized 
as a side-effect of SMP bootup.)

This suspend / resume thing was dropped unintentionally during the 
last-minute -mm code reshuffling.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 12b3efe..5567745 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -284,6 +284,42 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+void tick_suspend_broadcast(void)
+{
+	struct clock_event_device *bc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	bc = tick_broadcast_device.evtdev;
+	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+int tick_resume_broadcast(void)
+{
+	struct clock_event_device *bc;
+	unsigned long flags;
+	int broadcast = 0;
+
+	spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	bc = tick_broadcast_device.evtdev;
+	if (bc) {
+		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC &&
+		    !cpus_empty(tick_broadcast_mask))
+			tick_broadcast_start_periodic(bc);
+
+		broadcast = cpu_isset(smp_processor_id(), tick_broadcast_mask);
+	}
+	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+
+	return broadcast;
+}
+
+
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_t tick_broadcast_oneshot_mask;
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0986a2b..43ba1bd 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -298,6 +298,28 @@ static void tick_shutdown(unsigned int *cpup)
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
+static void tick_suspend_periodic(void)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+}
+
+static void tick_resume_periodic(void)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tick_device_lock, flags);
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(td->evtdev, 0);
+	spin_unlock_irqrestore(&tick_device_lock, flags);
+}
+
 /*
  * Notification about clock event devices
  */
@@ -325,6 +347,16 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 		tick_shutdown(dev);
 		break;
 
+	case CLOCK_EVT_NOTIFY_SUSPEND:
+		tick_suspend_periodic();
+		tick_suspend_broadcast();
+		break;
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		if (!tick_resume_broadcast())
+			tick_resume_periodic();
+		break;
+
 	default:
 		break;
 	}
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 54861a0..75890ef 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -67,6 +67,8 @@ extern int tick_check_broadcast_device(struct clock_event_device *dev);
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
 extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
 extern void tick_shutdown_broadcast(unsigned int *cpup);
+extern void tick_suspend_broadcast(void);
+extern int tick_resume_broadcast(void);
 
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
@@ -90,6 +92,8 @@ static inline int tick_device_uses_broadcast(struct clock_event_device *dev,
 static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
 static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
 static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
+static inline void tick_suspend_broadcast(void) { }
+static inline int tick_resume_broadcast(void) { return 0; }
 
 /*
  * Set the periodic handler in non broadcast mode
diff --git a/kernel/timer.c b/kernel/timer.c
index 6663a87..718437f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -997,6 +997,9 @@ static int timekeeping_resume(struct sys_device *dev)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+
 	/* Resume hrtimers */
 	clock_was_set();
 
@@ -1011,6 +1014,9 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 	timekeeping_suspended = 1;
 	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+
 	return 0;
 }
 

