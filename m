Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZFXJod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZFXJod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZFXJoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:44:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZFXJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:44:24 -0400
Date: Wed, 24 Jun 2009 02:44:28 -0700 (PDT)
Message-Id: <20090624.024428.215194313.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624075342.GL6760@one.firstfloor.org>
References: <20090624071555.GK6760@one.firstfloor.org>
	<20090624.001729.155964457.davem@davemloft.net>
	<20090624075342.GL6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 09:53:42 +0200

>> > Ah you have a one shot timer and it gets rescheduled in the softirq?
>> > If yes why not in doing that directly in the hardirq handler?
>> 
>> Then what's the point of the generic timer code supporting one-shot
>> clock sources? :-)
> 
> Well it would avoid that problem at least (I think based on your
> description). Somehow you need to reschedule the timer before the softirq.
> 
> I guess you could have a generic function that is callable from hardirq
> directly?

Thinking about this some more, the issue I'm hitting has nothing to
do with how the timer fires.

The problem occurs when the cpu goes into NOHZ mode, and the timer
is not firing.  And I suspect x86 would hit this problem too as
currently coded.

Using sparc64 first as a concrete example, the idle loop is essentially:

	while(1) {
		tick_nohz_stop_sched_tick(1);

		while (!need_resched() && !cpu_is_offline(cpu))
			sparc64_yield(cpu);

		tick_nohz_restart_sched_tick();

		preempt_enable_no_resched();
 ...
		schedule();
		preempt_disable();
	}

And on this particular CPU type sparc64_yield() is simply

	touch_nmi_watchdog();

since this cpu doesn't support yielding.

So if we get that 5+ second qla2xxx interrupt storm during the
"while (!need_resched() ..." loop, no matter what we do the NMI
watchdog is going to trigger on us once the qla2xxx firmware
upload is complete.

X86 32-bit's cpu_idle() looks roughly like this:

	while (1) {
		tick_nohz_stop_sched_tick(1);
		while (!need_resched()) {

			check_pgt_cache();
			rmb();

			if (cpu_is_offline(cpu))
				play_dead();

			local_irq_disable();
			/* Don't trace irqs off for idle */
			stop_critical_timings();
			pm_idle();
			start_critical_timings();
		}
		tick_nohz_restart_sched_tick();
		preempt_enable_no_resched();
		schedule();
		preempt_disable();
	}

And similarly to sparc64, if that 5+ second qla2xxx interrupt
sequence happens after the tick_nohz_stop_sched_tick() call
we can run into the same situation.

Because the timer interrupt count is not incrementing, and it won't do
so for at least "5 * nmi_hz".
