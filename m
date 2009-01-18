Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZARUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZARUWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZARUWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:22:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZARUWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:22:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Sun, 18 Jan 2009 21:21:24 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <200901181642.00886.arvidjaar@mail.ru> <200901182232.57186.arvidjaar@mail.ru> <20090118195645.GA6634@elte.hu>
In-Reply-To: <20090118195645.GA6634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901182121.24863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Ingo Molnar wrote:
> 
> * Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> 
> > On 18 января 2009 20:25:11 Ingo Molnar wrote:
> > 
> > > Rafael, can you think of anything in the s2ram code that would have
> > >
> > > changed the irqs-off status of hres_timers_resume() in this codepath:
> > > > > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > > > > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > > > > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > > > > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > > > > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > > > > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > > > > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > > > > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > > > > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
> > >
> > > ?
> > >
> > 
> > As far as I can tell, timekeeping_resume is called via class ->resume 
> > method; and according to comments in sysdev_resume() and 
> > device_power_up(), they are called with interrupts disabled.
> > 
> > Looking at suspend_enter, irqs *are* disabled at this point.
> > 
> > So it actually looks like something (may be some driver) unconditionally 
> > enabled irqs in resume path.
> > 
> > I believe the patch should be hold back until this is clarified.
> 
> That's a nice theory!

That would be a bad bug.

> I've queued up the debug check below instead. Probably the resume code 
> should include a similar check at a higher level and print out the 
> callback that enables irqs?
> 
> 	Ingo
> 
> 
> ---------------->
> From 2f93dd9df9654b157c9a6a08efaf6f2b08cc3d06 Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sun, 18 Jan 2009 16:39:29 +0100
> Subject: [PATCH] hrtimers: fix inconsistent lock state on resume in hres_timers_resume
> 
> Andrey Borzenkov reported this lockdep assert:
> 
> > [17854.688347] =================================
> > [17854.688347] [ INFO: inconsistent lock state ]
> > [17854.688347] 2.6.29-rc2-1avb #1
> > [17854.688347] ---------------------------------
> > [17854.688347] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> > [17854.688347] pm-suspend/18240 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [17854.688347]  (&cpu_base->lock){++..}, at: [<c0136fcc>] retrigger_next_event+0x5c/0xa0
> > [17854.688347] {in-hardirq-W} state was registered at:
> > [17854.688347]   [<c01443cd>] __lock_acquire+0x79d/0x1930
> > [17854.688347]   [<c01455bc>] lock_acquire+0x5c/0x80
> > [17854.688347]   [<c03092e5>] _spin_lock+0x35/0x70
> > [17854.688347]   [<c0136e61>] hrtimer_run_queues+0x31/0x140
> > [17854.688347]   [<c0128d98>] run_local_timers+0x8/0x20
> > [17854.688347]   [<c0128dd3>] update_process_times+0x23/0x60
> > [17854.688347]   [<c013e274>] tick_periodic+0x24/0x80
> > [17854.688347]   [<c013e2e2>] tick_handle_periodic+0x12/0x70
> > [17854.688347]   [<c0104e24>] timer_interrupt+0x14/0x20
> > [17854.688347]   [<c01607b9>] handle_IRQ_event+0x29/0x60
> > [17854.688347]   [<c0161c59>] handle_level_irq+0x69/0xe0
> > [17854.688347]   [<ffffffff>] 0xffffffff
> > [17854.688347] irq event stamp: 55771
> > [17854.688347] hardirqs last  enabled at (55771): [<c0309125>] _spin_unlock_irqrestore+0x35/0x60
> > [17854.688347] hardirqs last disabled at (55770): [<c0309419>] _spin_lock_irqsave+0x19/0x80
> > [17854.688347] softirqs last  enabled at (54836): [<c0124f54>] __do_softirq+0xc4/0x110
> > [17854.688347] softirqs last disabled at (54831): [<c01049ae>] do_softirq+0x8e/0xe0
> > [17854.688347]
> > [17854.688347] other info that might help us debug this:
> > [17854.688347] 3 locks held by pm-suspend/18240:
> > [17854.688347]  #0:  (&buffer->mutex){--..}, at: [<c01dd4c5>] sysfs_write_file+0x25/0x100
> > [17854.688347]  #1:  (pm_mutex){--..}, at: [<c015056f>] enter_state+0x4f/0x140
> > [17854.688347]  #2:  (dpm_list_mtx){--..}, at: [<c027880f>] device_pm_lock+0xf/0x20
> > [17854.688347]
> > [17854.688347] stack backtrace:
> > [17854.688347] Pid: 18240, comm: pm-suspend Not tainted 2.6.29-rc2-1avb #1
> > [17854.688347] Call Trace:
> > [17854.688347]  [<c0306248>] ? printk+0x18/0x20
> > [17854.688347]  [<c0141fac>] print_usage_bug+0x16c/0x1d0
> > [17854.688347]  [<c0142bcf>] mark_lock+0x8bf/0xc90
> > [17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
> > [17854.688347]  [<c01441b0>] __lock_acquire+0x580/0x1930
> > [17854.688347]  [<c030916d>] ? _spin_unlock+0x1d/0x20
> > [17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
> > [17854.688347]  [<c013dd38>] ? clockevents_program_event+0x98/0x160
> > [17854.688347]  [<c0142fe8>] ? mark_held_locks+0x48/0x90
> > [17854.688347]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
> > [17854.688347]  [<c0143229>] ? trace_hardirqs_on_caller+0x139/0x190
> > [17854.688347]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
> > [17854.688347]  [<c01455bc>] lock_acquire+0x5c/0x80
> > [17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c03092e5>] _spin_lock+0x35/0x70
> > [17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c0136fcc>] retrigger_next_event+0x5c/0xa0
> > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
> > [17854.688347]  [<c0150660>] ? state_store+0x0/0xc0
> > [17854.688347]  [<c0202da4>] kobj_attr_store+0x24/0x30
> > [17854.688347]  [<c01dd53c>] sysfs_write_file+0x9c/0x100
> > [17854.688347]  [<c019916c>] vfs_write+0x9c/0x160
> > [17854.688347]  [<c0103494>] ? restore_nocheck_notrace+0x0/0xe
> > [17854.688347]  [<c01dd4a0>] ? sysfs_write_file+0x0/0x100
> > [17854.688347]  [<c01992ed>] sys_write+0x3d/0x70
> > [17854.688347]  [<c0103371>] sysenter_do_call+0x12/0x31
> 
> Andrey's analysis:
> 
> > timekeeping_resume() is called via class ->resume
> > method; and according to comments in sysdev_resume() and
> > device_power_up(), they are called with interrupts disabled.
> >
> > Looking at suspend_enter, irqs *are* disabled at this point.
> >
> > So it actually looks like something (may be some driver)
> > unconditionally enabled irqs in resume path.
> 
> Add a debug check to test this theory. If it triggers then it
> triggers because the resume code calls it with irqs enabled,
> which is a no-no not just for timekeeping_resume(), but also
> bad for a number of other resume handlers.
> 
> Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/hrtimer.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 1455b76..f87e047 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -614,7 +614,8 @@ void clock_was_set(void)
>   */
>  void hres_timers_resume(void)
>  {
> -	/* Retrigger the CPU local events: */
> +	WARN_ONCE(1, KERN_INFO "hres_timers_resume() called with IRQs enabled!");
> +
>  	retrigger_next_event(NULL);
>  }

Why WARN_ONCE(1, ), actually?

I would very much prefer adding a WARN_ONCE() or two into the resume part
suspend_enter().  Like this:

---
 kernel/power/main.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -301,7 +301,12 @@ static int suspend_enter(suspend_state_t
 	if (!suspend_test(TEST_CORE))
 		error = suspend_ops->enter(state);
 
+	WARN_ONCE(!irqs_disabled(), "PM: Interrupts should be off here!\n");
+
 	device_power_up(PMSG_RESUME);
+
+	WARN_ONCE(!irqs_disabled(), "PM: Interrupts should be off here!\n");
+
  Done:
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
---

Rafael
