Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXCFATx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXCFATx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXCFATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:19:53 -0500
Received: from www.osadl.org ([213.239.205.134]:47785 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752443AbXCFATw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:19:52 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 01:25:53 +0100
Message-Id: <1173140753.24738.246.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 15:45 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> > > 
> > > Subject    : macbook pro suspend to ram broken  (clockevents)
> > > References : http://lkml.org/lkml/2007/3/4/110
> > > Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> > > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > > Status     : unknown
> > 
> > I can reproduce this on my dual core VAIO. There are some issues:
> 
> Yeah, I think I can too, on my dual-core Mac Mini. 
> 
> I'm not done with my bisection, but e9e2cdb4 is among the 28 commits left, 
> so I'm pretty sure I'm hitting the same bug. I'll do a few more bootups to 
> be 100% sure.

I just got the resume fix cleaned up. The suspend / resume thing was
dropped unintentionally during the -mm code reshuffling.

It still needs the broadcast fix though.

Does this make the problem go away ?

	tglx

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
 


