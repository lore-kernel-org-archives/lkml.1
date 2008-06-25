Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYFYOXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYFYOXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYFYOWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:22:52 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2518 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752290AbYFYOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:22:50 -0400
Date: Wed, 25 Jun 2008 18:22:49 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080625142249.GA21630@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <486244FF.8060805@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <486244FF.8060805@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 05:15:43PM +0400, Sergei Shtylyov wrote:
> Hello.
>
> Anton Vorontsov wrote:
>
>>>>> IDE interrupt handler relies on the fact that, if necessary, 
>>>>> hardirqs will re-trigger on ISR exit. With fully preemtable IRQs 
>>>>> this seems to be not true, since if hardirq thread is currently 
>>>>> running, and the same IRQ raised again, then this IRQ will be 
>>>>> simply lost.
>
>>>> actually no, that should not happen - if -rt loses an IRQ then 
>>>> something broke in the threaded IRQ code. It's supposed to be a 
>>>> drop-in, compatible IRQ flow with no driver changes needed.
>
>>> ..just as I thought, the bug somewhere deeper... heh.
>
>> Ok, a bit more investigation showed that this is indeed not RT specific
>> per see, but issue emerges only on RT-style IRQ handlers + alim15x3 IDE
>> controller (for example, PDC20269 works ok).
>
>    Does it happen only with ATAPI devices also or with ATA disks too?

So far I own two ATAPI devices, IDE disks are quire rare nowadays,
should find one. ;-)

>> The difference is that that with RT: low-level (non-threaded) IRQ
>> handler masks IDE IRQ, then wakes up appropriate IRQ thread, which calls
>> IDE handler, and then, after IDE handler exits, thread routine unmasks
>> IDE IRQ.
>
>> Without RT: low-level non-threaded IRQ handler does not mask specific
>> IRQ, but disables local interrupts, and calls IDE handler directly.
>
>    Hm, handle_level_irq() (and PCI IRQs are level-triggered) calls  
> mask_ack_irq() which should *mask* IRQ and send EOI (at least on i8259). 
> By IRQ18 I can assume it's I/O APIC 

No, it's not Intel I/O APIC. IRQ18 is the virtual "Linux IRQ", no
correlations with the PIC IRQ number.

> -- this one may be using different 
> methods of handling IRQ depending on whether hardirq preemption is on or 
> off (at least it was so in 2.6.18-rt time).

Hardirq preemption is on, of course. The whole problem is when hardirqs
preempted.

> The default, "fasteoi" path 
> doesn't mask off the IRQ indeed (it should be disabled from re-occuring 
> anyway until the code issues EOI)...

What do you mean by doesn't mask off? With hardirqs preemption it does
mask off IDE interrupt, and then sends an EOI. But it doesn't mask
processors' IRQs (i.e. local_irq_disable()), true. And MPIC is using
fasteoi path indeed.

>    So, which machine and PIC you have?

It is PowerPC MPC8610 + ULi "Super South Bridge" connected through
PCI Express. This south bridge contains lots of devices (and lots of
PCI quirks, see arch/powerpc/platforms/86xx/mpc8610_hpcd.c).

PIC is OpenPIC-compatible (MPIC, built-in into MPC8610 SOC).

Note: I don't have any specifications on that ULi bridge, neither I have
any schematics for that board (so far, let's hope). So I can't say
exactly how things are inter-connected or what these PCI quirks are
actually doing (despite few comments in them).

And since it is PCI-E, interrupt things are quite troublesome to
debug without serial logic analyzer. :-)

>> The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
>> reason it does not hold IRQ line, but rises it for some short period
>> of time (while the drive itself rises and holds it correctly -- I'm
>> seeing it via oscilloscope).
>
>    That's surely an invalid behavior for a level triggered interrupt that 
> can also result in spurious IRQs...  I'm not even sure how it can 
> reliably work without masking since there should be no latching for level 
> triggered interupts...

Yeah.

>> So this scheme does not work:
>> mask_irq()
>> ...do something that will trigger IDE interrupt...
>> unmask_irq()
>
>> Also, further testing showed that this issue isn't drive-specific, i.e.
>> with a delay inserted before the unmask_irq(), the bug shows with any
>> drive I have.
>
>    So, "shit happens" even with the ATA drives?

Will try as soon as I'll get one.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
