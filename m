Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYBSLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYBSLvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYBSLv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:51:28 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:3778 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYBSLv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:51:27 -0500
X-IronPort-AV: E=Sophos;i="4.25,375,1199682000"; 
   d="scan'208";a="48716783"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ feature not functional for handle_simple_irq
Date: Tue, 19 Feb 2008 11:51:21 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC12622A36@limkexm2.ad.analog.com>
In-Reply-To: <alpine.LFD.1.00.0802191143050.7583@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ feature not functional for handle_simple_irq
Thread-Index: Achy5RFVdBF1ELamQ6m1EVhfbA6I5wAAE23A
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Feb 2008 11:51:22.0868 (UTC) FILETIME=[BFAD4B40:01C872ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Thomas Gleixner, Dienstag, 19. Februar 2008 11:49
>Subject: Re: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ
>feature not functional for handle_simple_irq
>
>On Tue, 19 Feb 2008, Hennerich, Michael wrote:
>> Thomas,
>>
>> I have reasonable doubt that the delayed disable feature on
>> linux-2.6.24 for handle_simple_irq is broken.
>>
>> In 2.6.22 there was something like this:
>>
>> 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
>> 		if (desc->chip->mask)
>> 			desc->chip->mask(irq);
>> ...
>>
>> However in 2.6.24 the "DISABLED" IRQ in case it happens is never
going to
>be masked.
>>
>> 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
>> 		goto out_unlock;
>>
>>
>> I see a disabled IRQ being invoked in an endless loop.
>
>Simple irq's are special, see the comment above handle_simple_irq:
>
>Simple interrupts are either sent from a demultiplexing interrupt
>handler or come from hardware, where no interrupt hardware control
>is necessary.
>
>Note: The caller is expected to handle the ack, clear, mask and
>unmask issues if necessary.
>
>Simple irqs are used for low level demultiplex handlers, where the full
>control of the irqchip is in the low level handler.
>
>See also the commit log of 971e5b35fb02c5088d49e6c024aab73582a35b71
>
>    In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq
disabling
>    was implemented, and the simple irq handler had a masking set to
it.
>
>    Remy Bohmer discovered that some devices in the ARM architecture
>    would trigger the mask, but never unmask it. His patch to do the
>    unmasking was questioned by Russell King about masking simple irqs
>    to begin with. Looking further, it was discovered that the problems
>    Remy was seeing was due to improper use of the simple handler by
>    devices, and he later submitted patches to fix those. But the issue
>    that was uncovered was that the simple handler should never mask.
>
>    This patch reverts the masking in the simple handler.
>
>Thanks,
>
>	tglx


Ok - I see no problem that the simple handler doesn't mask the IRQ by
default like the level irq handler does.

However if I use disable_irq(irq) I would expect that the irq is somehow
disabled afterwards.

Our internal system IRQs doesn't need to be acked on the System
Interrupt Controller Level and we have simply just mask and unmask.


So I think I have two alternatives.

1) Bypass the delayed disable feature by implementing chip->disable and
chip->enable (simply map to mask and unmask)

2) Use level irq

Best regards,
Michael 
