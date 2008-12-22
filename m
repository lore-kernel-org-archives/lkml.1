Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYLVWLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYLVWLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbYLVWHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:07:22 -0500
Received: from www.tglx.de ([62.245.132.106]:36908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbYLVWHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:07:20 -0500
Date: Mon, 22 Dec 2008 23:05:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>  <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>  <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>  <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com> 
 <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>  <20081222150021.GA13839@elte.hu>  <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>  <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>  <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
  <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain> <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

On Mon, 22 Dec 2008, Fabio Comolli wrote:
> On Mon, Dec 22, 2008 at 10:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Can please you revert the last patch and apply the following ? Does
> > the WARN_ON trigger ?
> >

> Yes, it does:
 
> [  159.768005]  [<c01389a2>] getnstimeofday+0x21/0xcd
> [  159.768005]  [<c0135e26>] ktime_get_ts+0x1d/0x3f
> [  159.768005]  [<c0135e57>] ktime_get+0xf/0x2b
> [  159.768005]  [<c013736b>] sched_clock_tick+0x46/0x83
> [  159.768005]  [<c01373ad>] sched_clock_idle_wakeup_event+0x5/0xa
> [  159.768005]  [<c0108670>] set_cyc2ns_scale+0x3f/0x5e
> [  159.768005]  [<c01088af>] time_cpufreq_notifier+0xf9/0x103
> [  159.768005]  [<c0136782>] notifier_call_chain+0x2a/0x52
> [  159.768005]  [<c0136866>] __srcu_notifier_call_chain+0x35/0x4a
> [  159.768005]  [<c0136884>] srcu_notifier_call_chain+0x9/0xc
> [  159.768005]  [<c031cbca>] cpufreq_resume+0xf3/0x112
> [  159.768005]  [<c028c3f3>] __sysdev_resume+0x24/0x34
> [  159.768005]  [<c028c421>] sysdev_resume+0x1e/0x50

Thanks for testing. It's exaclty the code path I described :)

So my code analysis holds and your test confirms my suspicion that
Shaggy's patch just unearthed some other weirdness in the
suspend/resume code.

Can you please apply the following hack^Wpatch and retest ? It
restores Shaggys patch, but prevents the sched_clock_tick() call when
timekeeping is not resumed. The WARN_ON should not longer trigger
except there is some other code path which fiddles with that as well.

If I'm not completely nuts then this should solve your suspend/resume
problem really instead of papering over the root cause.

The patch should work on top of 2.6.27.10 as well, so whatever is
easier to verify for you is fine.

Thanks,

	tglx
---
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..dd97801 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
@@ -222,11 +222,16 @@ void sched_clock_idle_sleep_event(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
 
+extern int timekeeping_suspended;
+
 /*
  * We just idled delta nanoseconds (called with irqs disabled):
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
+	if (timekeeping_suspended)
+		return;
+
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fa05e88..50ba3d0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/* flag for if timekeeping is suspended */
+int timekeeping_suspended;
+
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
@@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
 	unsigned long seq;
 	s64 nsecs;
 
+	WARN_ON(timekeeping_suspended);
+
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
@@ -299,8 +304,6 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 
