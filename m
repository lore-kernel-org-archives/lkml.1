Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZHSU0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZHSU0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZHSU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:26:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZHSU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:26:08 -0400
Date: Wed, 19 Aug 2009 22:25:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [circular locking bug] Re: [patch 00/15] clocksource /
	timekeeping rework V4 (resend V3 + bug fix)
Message-ID: <20090819202554.GA19482@elte.hu>
References: <20090814134717.859098725@de.ibm.com> <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu> <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain> <20090817094042.03fe5d38@skybase> <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain> <20090817092807.GA10460@elte.hu> <20090818170942.3ab80c91@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818170942.3ab80c91@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, with all the latest patches i re-added these bits to 
-tip, and it triggered this lockdep assert on a testbox:

=================================
[ INFO: inconsistent lock state ]
2.6.31-rc6-tip-01234-gcc9be0e-dirty #1054
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/1 [HC0[0]:SC1[1]:HE0:SE0] takes:
 (clocksource_mutex){+.?.+.}, at: [<c10664d7>] clocksource_unregister+0x17/0x50
{SOFTIRQ-ON-W} state was registered at:
  [<c106fb77>] mark_irqflags+0xf7/0x190
  [<c107177a>] __lock_acquire+0x29a/0x520
  [<c1071a6a>] lock_acquire+0x6a/0xc0
  [<c175719b>] __mutex_lock_common+0x3b/0x340
  [<c1757551>] mutex_lock_nested+0x31/0x40
  [<c10666b7>] clocksource_register+0x17/0x40
  [<c1bc68bd>] init_jiffies_clocksource+0xd/0x10

see fuller log below.

	Ingo

Switching to clocksource acpi_pm
initcall init_acpi_pm_clocksource+0x0/0x1a0 returned 0 after 38256 usecs

=================================
[ INFO: inconsistent lock state ]
2.6.31-rc6-tip-01234-gcc9be0e-dirty #1054
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/1 [HC0[0]:SC1[1]:HE0:SE0] takes:
 (clocksource_mutex){+.?.+.}, at: [<c10664d7>] clocksource_unregister+0x17/0x50
{SOFTIRQ-ON-W} state was registered at:
  [<c106fb77>] mark_irqflags+0xf7/0x190
  [<c107177a>] __lock_acquire+0x29a/0x520
  [<c1071a6a>] lock_acquire+0x6a/0xc0
  [<c175719b>] __mutex_lock_common+0x3b/0x340
  [<c1757551>] mutex_lock_nested+0x31/0x40
  [<c10666b7>] clocksource_register+0x17/0x40
  [<c1bc68bd>] init_jiffies_clocksource+0xd/0x10
  [<c1001129>] do_one_initcall+0x29/0x160
  [<c1bb33f7>] do_initcalls+0x27/0x40
  [<c1bb3436>] do_basic_setup+0x26/0x30
  [<c1bb3b17>] kernel_init+0x57/0xa0
  [<c1003ae7>] kernel_thread_helper+0x7/0x10
irq event stamp: 1135959
hardirqs last  enabled at (1135958): [<c1045810>] __do_softirq+0x60/0x1d0
hardirqs last disabled at (1135959): [<c105e328>] hrtimer_switch_to_hres+0x48/0x100
softirqs last  enabled at (1135840): [<c10458d1>] __do_softirq+0x121/0x1d0
softirqs last disabled at (1135957): [<c1005b22>] call_on_stack+0x12/0x20

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (i8253_lock){-.-...}, at: [<c1008ba8>] init_pit_timer+0x18/0xb0

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.31-rc6-tip-01234-gcc9be0e-dirty #1054
Call Trace:
 [<c106f430>] print_usage_bug+0x130/0x180
 [<c106f5eb>] mark_lock_irq+0x16b/0x260
 [<c106f240>] ? check_usage_forwards+0x0/0xc0
 [<c106f7fe>] mark_lock+0x11e/0x3a0
 [<c106fbff>] mark_irqflags+0x17f/0x190
 [<c107177a>] __lock_acquire+0x29a/0x520
 [<c1071a6a>] lock_acquire+0x6a/0xc0
 [<c10664d7>] ? clocksource_unregister+0x17/0x50
 [<c175719b>] __mutex_lock_common+0x3b/0x340
 [<c10664d7>] ? clocksource_unregister+0x17/0x50
 [<c1757551>] mutex_lock_nested+0x31/0x40
 [<c10664d7>] ? clocksource_unregister+0x17/0x50
 [<c10664d7>] clocksource_unregister+0x17/0x50
 [<c1008b3a>] pit_disable_clocksource+0x2a/0x40
 [<c1008bb9>] init_pit_timer+0x29/0xb0
 [<c106825a>] clockevents_set_mode+0x1a/0x50
 [<c1069a96>] tick_switch_to_oneshot+0x96/0xc0
 [<c1069ad2>] tick_init_highres+0x12/0x20
 [<c105e32d>] hrtimer_switch_to_hres+0x4d/0x100
 [<c105ebbd>] hrtimer_run_pending+0x4d/0x50
 [<c104bb85>] run_timer_softirq+0x25/0x230
 [<c1092df4>] ? cpu_quiet+0x54/0x90
 [<c1092968>] ? cpu_has_callbacks_ready_to_invoke+0x8/0x20
 [<c10932d5>] ? rcu_do_batch+0x15/0x190
 [<c1092ed3>] ? rcu_check_quiescent_state+0x33/0x50
 [<c1045810>] ? __do_softirq+0x60/0x1d0
 [<c10457b0>] ? __do_softirq+0x0/0x1d0
 [<c106fe6a>] ? trace_hardirqs_on_caller+0x7a/0x1b0
 [<c1045868>] __do_softirq+0xb8/0x1d0
 [<c10457b0>] ? __do_softirq+0x0/0x1d0
 <IRQ>  [<c10459f5>] ? irq_exit+0x75/0x80
 [<c175906e>] ? do_IRQ+0x4e/0xb0
 [<c100356e>] ? common_interrupt+0x2e/0x40
 [<c1758b94>] ? _spin_unlock_irqrestore+0x34/0x50
 [<c103007b>] ? set_curr_task_fair+0xb/0x40
 [<c10401c4>] ? vprintk+0x114/0x2a0
 [<c1756f25>] ? __mutex_unlock_slowpath+0xa5/0x160
 [<c106ff4c>] ? trace_hardirqs_on_caller+0x15c/0x1b0
 [<c106ffab>] ? trace_hardirqs_on+0xb/0x10
 [<c1756fed>] ? mutex_unlock+0xd/0x10
 [<c1be9320>] ? init_acpi_pm_clocksource+0x0/0x1a0
 [<c104036b>] ? printk+0x1b/0x20
 [<c1001200>] ? do_one_initcall+0x100/0x160
 [<c1be9320>] ? init_acpi_pm_clocksource+0x0/0x1a0
 [<c1138a45>] ? create_proc_entry+0x65/0xc0
 [<c1092383>] ? register_irq_proc+0xa3/0xc0
 [<c1138981>] ? proc_create_data+0x71/0xd0
 [<c1bb33f7>] ? do_initcalls+0x27/0x40
 [<c1bb3436>] ? do_basic_setup+0x26/0x30
 [<c1bb3b17>] ? kernel_init+0x57/0xa0
 [<c1bb3ac0>] ? kernel_init+0x0/0xa0
 [<c1003ae7>] ? kernel_thread_helper+0x7/0x10
Switched to high resolution mode on CPU 0
calling  ssb_modinit+0x0/0x60 @ 1

