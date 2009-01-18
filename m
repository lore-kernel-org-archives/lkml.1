Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbZARRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbZARRZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761010AbZARRZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:25:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790AbZARRZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:25:31 -0500
Date: Sun, 18 Jan 2009 18:25:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.29-rc2] Inconsistent lock state on resume in
	hres_timers_resume
Message-ID: <20090118172511.GA22624@elte.hu>
References: <200901181642.00886.arvidjaar@mail.ru> <1232293169.5204.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232293169.5204.14.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-01-18 at 16:41 +0300, Andrey Borzenkov wrote:
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
> Not sure what caused this to trigger, but it looks like
> timekeeping_resume() isn't called with IRQs disabled (and the code
> doesn't seem to expect that since it uses write_seqlock_irqsave).
> 
> hres_timers_resume() however calls retrigger_next_event() which does
> require IRQs disabled and doesn't do that.
> 
> Like said, I'm not sure what caused this since the code in question
> doesn't seem to have changed since April 2007.
> 
> Anyway, does the below patch cure trouble?

i've queued this up in tip/timers/urgent as it seems correct.

Rafael, can you think of anything in the s2ram code that would have 
changed the irqs-off status of hres_timers_resume() in this codepath:

> > [17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
> > [17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
> > [17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
> > [17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
> > [17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
> > [17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
> > [17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
> > [17854.688347]  [<c0150614>] enter_state+0xf4/0x140
> > [17854.688347]  [<c01506dd>] state_store+0x7d/0xc0

?

If not then maybe Andrey is the first one to get a successful lockdep 
report out of such a situation - and this might have been a historic 
high-res timers bug.

	Ingo
