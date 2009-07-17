Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbZGQO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbZGQO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbZGQO6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:58:43 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46884 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbZGQO6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IGAiKCqsPh5p64fdaMqp3QXEf/lYOjgEhDwXKHZ2A2xMHk4+d1mu2VjgAi43yd9cHe
         wtnsCmjqePr7/MOZUmH3UjjL7Zf4jqC1A3tetOXC1j2XMwT56CGP6zmBOGN0v3IAxi+S
         JEaMVrK/452FLTzc+h5ho9pBrxTAym5kQA3xA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
	 <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>
Date: Fri, 17 Jul 2009 22:58:41 +0800
Message-ID: <3c17e3570907170758g337703b7l12e1c262d6f385bf@mail.gmail.com>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
From: Barry Song <21cnbao@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/17 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 17 Jul 2009, Barry Song wrote:
>> Signed-off-by: Barry Song <21cnbao@gmail.com>
>
>> I think it is completely redundant to check IRQ_DISABLED to decide
>> whether thread_fn will be called.
>
> I do not :)
>
>> At first, the irq_thread is waken up by HARDIRQ handler, if
>> IRQ_DISABLED is true, HARDIRQ will have no chance to run, then
>> irq_thread will not run. So there is only a situation that both
>> HARDIRQ can run and IRQ_DISABLED is set.
>>
>> The case is that the flag is set in the interval of HARDIRQ enter
>> and irq_thread is scheduled to run. I think there is nobody which is
>> interested to disable irq in the interval except HARDIRQ handler
>> itself. Then that causes the second problem I will explain.
>
> Err. It's not a question whether somebody is interested or not.
>
> Fact is that the interrupt can be disabled between the thread wake up
> and the handler thread calling the handler function. So it's a
> question of correctness not to call the handler when the irq is
> disabled for the following reason:
>
> CPU 0                   CPU 1
> hard irq
>     -> thread is woken
>                        disable_irq()
>                        synchronize_irq() returns because
>                        there is no thread running the handler
>
> thread runs             code which assumes that no irq handler
>     -> calls handler   can run continues.
>
> That would happen with your patch applied.
>
> We would need more complex accounting when we want to cover the full
> chain from hardirq->wakeup->thread to avoid the above scenario, but
> that'd be a nightmare as we would have to deal with accounting wakeups
> of an already running irq thread as well.
>
> We optimize for the normal and fast case so the current logic is
> correct and stays that way.
>
>> Secondly, checking the flag causes some problems in fact. We often
>> call disable_irq_nosync to diable irq in HARDIRQ to avoid flooding
>> irq to follow. But the disable_irq_nosync will set IRQ_DISABLED
>> flag, then that will prevent the execution of thread_fn. That's not
>> the original idea to call disable_irq_nosync in HARDIRQ.
>
> Calling disable_irq_nosync in the hard irq handler is wrong with
> threaded interrupts and I even consider it wrong with non threaded irq
> handlers.
>
> The hard interrupt handler of a threaded irq needs to check whether
> the interrupt originated from the device and if that's the case it
> needs to disable the irq in the device rather than disabling the
> interrupt line completely. Simply because it would disable shared
> interrupts on the same irq line until the thread reenables them.
>
> The correct thing to do is disabling it at the device level if you
> need to prevent interrupt storms.
For some devices which use level trigger and  buses like spi, i2c.
Checking the interrupt source and clear IRQ probably need to
read/write the registers of devices by i2c,spi. But i2c, spi access
maybe causes schedule based on their driver framework. So the checking
operation and clear operation can only be done in process switch. So
the only way to avoid interrupt storms is disabling the irq line at
hardirq, after clearing irq in the bottom-half by work-queue or
thread, then enable it again.
For example, a spi touchscreen is touched, then it gives a high level
in a GPIO irq line to CPU. CPU enter hardirq, but to clear the high
level, it must write the touchscreen by spi, how could it avoid the
interrupt storms betweem hardirq and bottom-half if it doesn't disable
the irq line since it can't write the spi in hardirq?
>
> Thanks,
>
>        tglx
>
