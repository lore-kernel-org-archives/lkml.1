Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYFYNPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYFYNPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYFYNPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:15:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:54838 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754187AbYFYNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:15:35 -0400
Message-ID: <486244FF.8060805@ru.mvista.com>
Date: Wed, 25 Jun 2008 17:15:43 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with	preempt-able
 hardirqs
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru>
In-Reply-To: <20080625123431.GA25452@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

>>>>IDE interrupt handler relies on the fact that, if necessary, hardirqs 
>>>>will re-trigger on ISR exit. With fully preemtable IRQs this seems to 
>>>>be not true, since if hardirq thread is currently running, and the 
>>>>same IRQ raised again, then this IRQ will be simply lost.

>>>actually no, that should not happen - if -rt loses an IRQ then something 
>>>broke in the threaded IRQ code. It's supposed to be a drop-in, 
>>>compatible IRQ flow with no driver changes needed.

>>..just as I thought, the bug somewhere deeper... heh.

> Ok, a bit more investigation showed that this is indeed not RT specific
> per see, but issue emerges only on RT-style IRQ handlers + alim15x3 IDE
> controller (for example, PDC20269 works ok).

    Does it happen only with ATAPI devices also or with ATA disks too?

> The difference is that that with RT: low-level (non-threaded) IRQ
> handler masks IDE IRQ, then wakes up appropriate IRQ thread, which calls
> IDE handler, and then, after IDE handler exits, thread routine unmasks
> IDE IRQ.

> Without RT: low-level non-threaded IRQ handler does not mask specific
> IRQ, but disables local interrupts, and calls IDE handler directly.

    Hm, handle_level_irq() (and PCI IRQs are level-triggered) calls 
mask_ack_irq() which should *mask* IRQ and send EOI (at least on i8259). By 
IRQ18 I can assume it's I/O APIC -- this one may be using different methods of 
handling IRQ depending on whether hardirq preemption is on or off (at least it 
was so in 2.6.18-rt time). The default, "fasteoi" path doesn't mask off the 
IRQ indeed (it should be disabled from re-occuring anyway until the code 
issues EOI)...
    So, which machine and PIC you have?

> The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
> reason it does not hold IRQ line, but rises it for some short period
> of time (while the drive itself rises and holds it correctly -- I'm
> seeing it via oscilloscope).

    That's surely an invalid behavior for a level triggered interrupt that can 
also result in spurious IRQs...  I'm not even sure how it can reliably work 
without masking since there should be no latching for level triggered interupts...

> So this scheme does not work:
> mask_irq()
> ...do something that will trigger IDE interrupt...
> unmask_irq()

> Also, further testing showed that this issue isn't drive-specific, i.e.
> with a delay inserted before the unmask_irq(), the bug shows with any
> drive I have.

    So, "shit happens" even with the ATA drives?

> So, in summary: I think that the patch is still correct as a hw bug
> workaround (I'll need to correct its comments and description though).

   Well, the patch seemed sane (and the hardware absolutely insane :-)...

WBR, Sergei
