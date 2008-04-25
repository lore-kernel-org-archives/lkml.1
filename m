Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbYDYKT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbYDYKT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbYDYKTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:19:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35489 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYDYKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:19:48 -0400
Subject: Re: [git pull] scheduler/misc fixes
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1209109710.7115.400.camel@twins>
References: <20080424225530.GA8717@elte.hu>
	 <20080424.204620.88617191.davem@davemloft.net>
	 <1209109710.7115.400.camel@twins>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 12:19:38 +0200
Message-Id: <1209118778.7115.417.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 09:48 +0200, Peter Zijlstra wrote:

>  a) 15934a37324f32e0fda633dc7984a671ea81cd75 does indeed fix a bug in
>     rq->clock; without that patch it compresses nohz time to a single
>     jiffie, so cpu_clock() which (without the above hack) is based on
>     rq->clock will be short on nohz time. This can 'hide' the clock jump
>     and thus hide false positives.
> 
> 
>  b) there is commit:
> 
> ---
> commit d3938204468dccae16be0099a2abf53db4ed0505
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Nov 28 15:52:56 2007 +0100
>     softlockup: fix false positives on CONFIG_NOHZ
> 
>     David Miller reported soft lockup false-positives that trigger
>     on NOHZ due to CPUs idling for more than 10 seconds.
> 
>     The solution is touch the softlockup watchdog when we return from
>     idle. (by definition we are not 'locked up' when we were idle)
> 
>      http://bugzilla.kernel.org/show_bug.cgi?id=9409
> 
>     Reported-by: David Miller <davem@davemloft.net>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 27a2338..cb89fa8 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
>  	if (!ts->tick_stopped)
>  		return;
>  
> +	touch_softlockup_watchdog();
> +
>  	cpu_clear(cpu, nohz_cpu_mask);
>  	now = ktime_get();
> 
> ---
> 
>     which should 'fix' this problem.
> 
> 
>  c) there are 'IPI' handlers on SPARC64 that look like they can wake
>     the CPU from idle sleep but do not appear to call irq_enter() which
>     has the above patch's touch_softlock_watchdog() in its callchain.
> 
> tl0_irq1:       TRAP_IRQ(smp_call_function_client, 1)
> tl0_irq2:       TRAP_IRQ(smp_receive_signal_client, 2)
> tl0_irq3:       TRAP_IRQ(smp_penguin_jailcell, 3)
> tl0_irq4:       TRAP_IRQ(smp_new_mmu_context_version_client, 4)


OK, so David came up with the idea that it might be the reschedule IPI
(smp_receive_signal_client) that did the wakeup resulting in the
following scenario:

 <idle > 60s >
 <resched-IPI> -> nohz_restart() -> restart timer
                                 -> schedule()

 <run stuff>
 <timer> -> softlockup_tick() -> BUG!
 
doing irq_enter/exit() for smp_receive_signal_client() did indeed fix
the whole issue. (x86 also has this bug - its just darn hard to generate
60s+ nohz periods due to the shitty clocks/timers)

So per b) any nohz wake needs to be done with an interrupt _and_ all
such interrupts must pass through irq_enter().

As far as I can tell this is not nessecarily true (or desired from a
performance POV) for all platforms, imagine the core2 monitor/mwait idle
that wakes up because of a memory write. This doesn't require an
interrupt at all to wake up.

So, are we going to require all waking interrupts (IPIs and regular) to
do the irq_enter/exit() dance and add the perhaps unneeded overhead to
these paths and require the non-interrupt driven wake-ups like
monitor/mwait to do the touch_softlockup_watchdog() themselves?

Or,

Is Ingo's initial patch to make nohz_restart() also touch the softlockup
watchdog the best fix (now that we understand what happens)?



