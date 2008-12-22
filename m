Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYLVOuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYLVOuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYLVOuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:50:37 -0500
Received: from www.tglx.de ([62.245.132.106]:59896 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYLVOuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:50:37 -0500
Date: Mon, 22 Dec 2008 15:48:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>  <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu>  <200812182319.57235.rjw@sisk.pl>  <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>  <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

On Sun, 21 Dec 2008, Fabio Comolli wrote:
> Well, I'm the submitter of bug 12155 and I never had hpet=force on my
> command line. I don't know where you found it.
> Actually my command line is:

My bad. I confused it with the HPET force enable. (Your BIOS does not
advertise HPET).
 
> By the way, I don't know if it matters but the problema happened with
> in-kernel hibernation and also in out-of-tree TuxOnIce hibernation.
> Maybe this can help debugging the issue, I don't know.

Hmm, does not ring a bell here. Can you please apply the patch below
to mainline and retest ?

Thanks,

	tglx
-----
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..c18a6dd 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -86,6 +86,14 @@ void sched_clock_init(void)
 	sched_clock_running = 1;
 }
 
+void sched_clock_debug(void)
+{
+	struct sched_clock_data *scd = this_scd();
+
+	printk(KERN_INFO "SCD raw %llu gtod %llu clock %llu now %llu\n",
+	       scd->tick_raw, scd->tick_gtod, scd->clock, sched_clock());
+}
+
 /*
  * min,max except they take wrapping into account
  */
@@ -118,13 +126,13 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      max(scd->clock, scd->tick_gtod + TICK_NSEC));
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fa05e88..bafbd2d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -304,6 +304,8 @@ static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 
+extern void sched_clock_debug(void);
+
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  * @dev:	unused
@@ -336,6 +338,8 @@ static int timekeeping_resume(struct sys_device *dev)
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	sched_clock_debug();
+
 	touch_softlockup_watchdog();
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
@@ -357,6 +361,8 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	sched_clock_debug();
+
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 
 	return 0;

