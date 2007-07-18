Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbXGRV33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbXGRV33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXGRV3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:29:20 -0400
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:45180 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348AbXGRV3T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:29:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [RFC] Deferred interrupt handling.
Date: Wed, 18 Jul 2007 14:29:13 -0700
Message-ID: <64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net>
In-Reply-To: <20070718183358.0a0886aa@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [RFC] Deferred interrupt handling.
Thread-Index: AcfJYOTJIKvWN1iWTES0RmzKhTSfSwAGbBaQ
References: <005901c7c921$79c006c0$6d401440$@com><20070718123040.615795b7@the-village.bc.nu><64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net><20070718174736.0baf6d0e@the-village.bc.nu><469E43D5.70802@qumranet.com><64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net> <20070718183358.0a0886aa@the-village.bc.nu>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Avi Kivity" <avik@qumranet.com>, <kvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2007 21:29:18.0621 (UTC) FILETIME=[B2CF4CD0:01C7C982]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> 	Guest0	-	blocked on I/O
>> >>
>> >> 	IRQ14 from your hardware
>> >> 		Block IRQ14
>> >> 		Sent to guest (guest is blocked)
>> >>
>> >> 	IRQ14 from hard disk
>> >> 		Ignored (as blocked)
>> >>
>>
>>
>> But now the timer will pop and the hard disk will get its irq.
>> The guest will be released right after.
>
>How do you plan to do this ? If you unmask the interrupt then it will
>immediately jam solid with IRQs from your hardware and the line will be
>disabled.

Hope it should work like the following [Please correct me if I'm wrong]:
- Make the device the last irqaction in the list
- Our dummy handler will always return IRQ_HANDLED in case any other
previous
  irqaction did not return such. It will also issue the timer and mask
the irq in this case.
  The line is temporarily jammed but not disabled - note_interrupt()
will not consider 
  our irq unhandled and won't disable it.
  btw, if I'm not mistaken only after bad 99900/100000 the irq is
disabled.
- If the timer pops before the guest acks the irq, the timer handler
will
  ack the irq and unmask it. The timer's job is only to prevent
deadlocks.

Maybe it's better to code it first then send RFC.
Or wanted to get a feed back before hand to hear opinions and to know
whether to use the 
deferred option or the irq polarity option. Both of them can lead to the
above deadlock 
without the timer hack.
Best regards, Dor.


