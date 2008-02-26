Return-Path: <linux-kernel-owner+w=401wt.eu-S1764922AbYBZXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764922AbYBZXAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764050AbYBZXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:00:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58502 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763883AbYBZW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:59:59 -0500
Message-ID: <47C499CF.2000605@pobox.com>
Date: Tue, 26 Feb 2008 17:59:27 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org> <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de> <47C34CEA.7060307@pobox.com> <20080226083904.GC9857@elte.hu> <47C43F18.6060207@pobox.com> <20080226101928.f6c16c66.akpm@linux-foundation.org> <20080226204943.GD14350@elte.hu> <20080226133715.d9cd32e7.akpm@linux-foundation.org>
In-Reply-To: <20080226133715.d9cd32e7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 26 Feb 2008 21:49:43 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> i.e. to introduce a kmap_atomic_irqsave(...,flags) and 
>> kunmap_atomic_irqrestore() API variant. _That_ then could be mapped by 
>> -rt to a non-irq disabling thing.

> Sure.  But iirc we haven't had a need for this before.  Which is a bit odd.

We have such a need -- we just always paper over it with 
spin_lock_irqsave() or local_irq_save() because those are "the rules." 
grep around :)

See ata_pio_sector() in libata-core.c, where we do:

>         if (PageHighMem(page)) {
>                 unsigned long flags;
> 
>                 /* FIXME: use a bounce buffer */
>                 local_irq_save(flags);
>                 buf = kmap_atomic(page, KM_IRQ0);
> 
>                 /* do the actual data transfer */
>                 ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
> 
>                 kunmap_atomic(buf, KM_IRQ0);
>                 local_irq_restore(flags);
>         } else {
>                 buf = page_address(page);
>                 ap->ops->data_xfer(qc->dev, buf + offset, qc->sect_size, do_write);
>         }

This is a core non-DMA data transfer routine.  Given the high cost of 
disabling interrupts during the relatively-slow PIO data transfer, we 
added extra logic to only disable interrupts for the highmem case.

The code in libata-scsi generally only deals with a single buffer, on 
average less than 128 bytes in length.  So the memcpy() isn't really 
that expensive in the case being discussed -- unlike the 
ata_pio_sector() case, where the cost is very, very high.

Aside: The "FIXME: use bounce buffer" comment above indicates the more 
optimal PIO data xfer approach of

	local_irq_save()
	kmap_atomic()
	memcpy into bounce buffer
	kunmap_atomic()
	local_irq_restore()

	/* do slow PIO bitbanging data transfer */
	ap->ops->data_xfer(...)

Regards,

	Jeff


