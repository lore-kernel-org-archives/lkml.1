Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYAIL5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYAIL5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYAIL53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:57:29 -0500
Received: from www.tglx.de ([62.245.132.106]:41949 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYAIL52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:57:28 -0500
Date: Wed, 9 Jan 2008 12:56:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <alpine.LFD.0.99999.0712172208500.3670@localhost.localdomain>
Message-ID: <alpine.LFD.0.99999.0801091248310.31637@localhost.localdomain>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>  <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>  <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>  <200712141817.47581.lenb@kernel.org> 
 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>  <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>  <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>  <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net> 
 <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>  <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain> <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com> <alpine.LFD.0.99999.0712172208500.3670@localhost.localdomain>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Thomas Gleixner wrote:
> I try to come up with some more debug patches tomorrow.

Sorry took a bit longer than a day :(

Can you apply the patch below + the debug patch which prints the timer
stats on softlockup and provide the output of this.

Thanks,

	tglx

diff --git a/include/linux/tick.h b/include/linux/tick.h
index f4a1395..22d921f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -39,6 +39,8 @@ enum tick_nohz_mode {
  * @idle_calls:		Total number of idle calls
  * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
  * @idle_entrytime:	Time when the idle call was entered
+ * @idle_waketime:	Time when the idle was interrupted
+ * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
  * @sleep_length:	Duration of the current idle sleep
  */
@@ -52,6 +54,8 @@ struct tick_sched {
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
 	ktime_t				idle_entrytime;
+	ktime_t				idle_waketime;
+	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cb89fa8..206a436 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -133,14 +133,15 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	touch_softlockup_watchdog();
-
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
+
+	ts->idle_waketime = now;
+	touch_softlockup_watchdog();
 }
 
 /**
@@ -369,6 +370,7 @@ void tick_nohz_restart_sched_tick(void)
 	 * Cancel the scheduled timer and restore the tick
 	 */
 	ts->tick_stopped  = 0;
+	ts->idle_exittime = now;
 	hrtimer_cancel(&ts->sched_timer);
 	ts->sched_timer.expires = ts->idle_tick;
 
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..d3d94c1 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -166,6 +166,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(idle_calls);
 		P(idle_sleeps);
 		P_ns(idle_entrytime);
+		P_ns(idle_waketime);
+		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);


