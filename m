Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYLVSsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYLVSsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYLVSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:48:21 -0500
Received: from www.tglx.de ([62.245.132.106]:58647 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYLVSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:48:20 -0500
Date: Mon, 22 Dec 2008 19:47:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Fabio Comolli <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <20081222150021.GA13839@elte.hu>
Message-ID: <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain> <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com> <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain> <20081222150021.GA13839@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > By the way, I don't know if it matters but the problema happened with 
> > > in-kernel hibernation and also in out-of-tree TuxOnIce hibernation. 
> > > Maybe this can help debugging the issue, I don't know.
> > 
> > Hmm, does not ring a bell here. Can you please apply the patch below to 
> > mainline and retest ?
> 
> ... and he should send a dmesg after a suspend cycle, right?

Yes :)

I digged more in the bugzillas. Toralf added some debug to
__update_sched_clock():

-       max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
+       max_clock = scd->tick_gtod + TICK_NSEC;
+       if (scd->clock > max_clock)
+               printk(KERN_INFO "%d %d\n", scd->clock, max_clock);

The interesting output is:

Dec 14 21:55:55 n22 Back to C!
Dec 14 21:55:55 n22 Extended CMOS year: 2000
Dec 14 21:55:55 n22 Force enabled HPET at resume
Dec 14 21:55:55 n22 212611283 77

The 77 is totaly bogus and it's likely not just a truncation of the
64bit value because (scd->clock > max_clock) evaluates to true. This
output is _AFTER_ timekeeping resume because the HPET force enable
message comes from timekeeping resume.

Toralf, can you please try the patch below on top of mainline ? Make
sure that CONFIG_PRINTK_TIME is off, otherwise the kernel
deadlocks. Please send the dmesg output from a suspend/resume cycle.

Thanks,

	tglx
----
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..9c307a2 100644
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
@@ -125,6 +133,11 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
 	max_clock = scd->tick_gtod + TICK_NSEC;
+	if (scd->clock > max_clock) {
+		printk(KERN_INFO "SC: %llu %llu %llu %llu %llu %llu\n",
+		       scd->clock, scd->tick_raw, scd->tick_gtod, now,
+		       max_clock, clock);
+	}
 
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




