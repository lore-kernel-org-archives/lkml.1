Return-Path: <linux-kernel-owner+w=401wt.eu-S964809AbZGQOP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbZGQOP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934698AbZGQOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:15:54 -0400
Received: from www.tglx.de ([62.245.132.106]:48867 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934684AbZGQOPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:15:52 -0400
Date: Fri, 17 Jul 2009 16:13:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Barry Song <21cnbao@gmail.com>
cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
In-Reply-To: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
Message-ID: <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Barry Song wrote:
> Signed-off-by: Barry Song <21cnbao@gmail.com>

> I think it is completely redundant to check IRQ_DISABLED to decide
> whether thread_fn will be called.

I do not :)

> At first, the irq_thread is waken up by HARDIRQ handler, if
> IRQ_DISABLED is true, HARDIRQ will have no chance to run, then
> irq_thread will not run. So there is only a situation that both
> HARDIRQ can run and IRQ_DISABLED is set.
>
> The case is that the flag is set in the interval of HARDIRQ enter
> and irq_thread is scheduled to run. I think there is nobody which is
> interested to disable irq in the interval except HARDIRQ handler
> itself. Then that causes the second problem I will explain.

Err. It's not a question whether somebody is interested or not. 

Fact is that the interrupt can be disabled between the thread wake up
and the handler thread calling the handler function. So it's a
question of correctness not to call the handler when the irq is
disabled for the following reason:

CPU 0	     	      	CPU 1
hard irq
     -> thread is woken
                        disable_irq()
			synchronize_irq() returns because
			there is no thread running the handler

thread runs		code which assumes that no irq handler
     -> calls handler   can run continues.

That would happen with your patch applied.

We would need more complex accounting when we want to cover the full
chain from hardirq->wakeup->thread to avoid the above scenario, but
that'd be a nightmare as we would have to deal with accounting wakeups
of an already running irq thread as well.

We optimize for the normal and fast case so the current logic is
correct and stays that way.

> Secondly, checking the flag causes some problems in fact. We often
> call disable_irq_nosync to diable irq in HARDIRQ to avoid flooding
> irq to follow. But the disable_irq_nosync will set IRQ_DISABLED
> flag, then that will prevent the execution of thread_fn. That's not
> the original idea to call disable_irq_nosync in HARDIRQ.

Calling disable_irq_nosync in the hard irq handler is wrong with
threaded interrupts and I even consider it wrong with non threaded irq
handlers. 

The hard interrupt handler of a threaded irq needs to check whether
the interrupt originated from the device and if that's the case it
needs to disable the irq in the device rather than disabling the
interrupt line completely. Simply because it would disable shared
interrupts on the same irq line until the thread reenables them.

The correct thing to do is disabling it at the device level if you
need to prevent interrupt storms.

Thanks,

	tglx
