Return-Path: <linux-kernel-owner+w=401wt.eu-S2993113AbXEBMxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993113AbXEBMxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993114AbXEBMxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:53:22 -0400
Received: from rtr.ca ([64.26.128.89]:1473 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993113AbXEBMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:53:18 -0400
Message-ID: <463889B5.7040204@rtr.ca>
Date: Wed, 02 May 2007 08:53:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca>	<46364F5A.2030208@rtr.ca>	<463653A3.5040606@rtr.ca>	<46367D7E.6060502@rtr.ca>	<1177976798.12796.286.camel@imap.mvista.com>	<463683A6.4010505@rtr.ca>	<1178026458.5791.305.camel@localhost.localdomain>	<4637419D.8010303@rtr.ca>	<463741F1.7050706@rtr.ca>	<1178027285.5791.307.camel@localhost.localdomain>	<46374B1D.6050509@rtr.ca>	<1178035058.5791.333.camel@localhost.localdomain>	<46377055.2060605@rtr.ca>	<1178092035.5791.349.camel@localhost.localdomain> <20070502010527.e64dcce9.akpm@linux-foundation.org>
In-Reply-To: <20070502010527.e64dcce9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

re: [PATCH] highres/dyntick: prevent xtime lock contention

|mark> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 2.1Ghz.
|mark> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
|mark> the 2.6.21 kernel hangs on startup just after printing one/both of these:
|mark>
|mark> kernel: switched to high resolution mode on cpu 1
|mark> kernel: switched to high resolution mode on cpu 0 
|
|thomas> Can you apply this patch please:
|thomas> http://lkml.org/lkml/2007/4/13/190
|thomas> It somehow did not make it into 2.6.21.
|
|andrew> Alas, poor me.  I ain't going to merge a contention-reduction patch when
|andrew> we're at -rc6.  If a patch fixes a bug, please tell me!

Okay, patch applied to 2.6.21.1, and I'm typing this email
from thunderbird while running the patched kernel (woo-hoo!).

So I guess it boots, works, and we need this patch in 2.6.21.2 & 2.6.22.

>Subject [PATCH] highres/dyntick: prevent xtime lock contention
>From	Thomas Gleixner <>
>Date	Fri, 13 Apr 2007 21:05:57 +0200
>Digg This
>
>While the !highres/!dyntick code assigns the duty of the do_timer() call
>to one specific CPU, this was dropped in the highres/dyntick part during
>development.
>
>Steven Rostedt discovered the xtime lock contention on highres/dyntick
>due to several CPUs trying to update jiffies.
>
>Add the single CPU assignment back. In the dyntick case this needs to
>be handled carefully, as the CPU which has the do_timer() duty must drop
>the assignement and let it be grabbed by another CPU, which is active.
>Otherwise the do_timer() calls would not happen during the long sleep.
>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Mark Lord <mlord@pobox.com>

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c index bfda3f7..a96ec9a 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-static int tick_do_timer_cpu = -1;
+int tick_do_timer_cpu __read_mostly = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -295,6 +295,12 @@ static void tick_shutdown(unsigned int *cpup)
 		clockevents_exchange_device(dev, NULL);
 		td->evtdev = NULL;
 	}
+	/* Transfer the do_timer job away from this cpu */
+	if (*cpup == tick_do_timer_cpu) {
+		int cpu = first_cpu(cpu_online_map);
+
+		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu : -1;
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h index c9d203b..5645e6a 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -5,6 +5,7 @@ DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
+extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c index 51556b9..3a8e524 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,6 +221,18 @@ void tick_nohz_stop_sched_tick(void)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 		}
+
+		/*
+		 * If this cpu is the one which updates jiffies, then
+		 * give up the assignment and let it be taken by the
+		 * cpu which runs the tick timer next, which might be
+		 * this cpu as well. If we don't drop this here the
+		 * jiffies might be stale and do_timer() never
+		 * invoked.
+		 */
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer
@@ -338,12 +350,24 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
+	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
@@ -431,9 +455,23 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
+	int cpu = smp_processor_id();
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * xtime_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == -1))
+		tick_do_timer_cpu = cpu;
+#endif
 
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
 
 	/*
 	 * Do not call, when we are not in irq context and have

