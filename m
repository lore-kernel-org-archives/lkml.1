Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbZJGNCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbZJGNCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbZJGNCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:02:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:62205 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbZJGNCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:02:22 -0400
X-IronPort-AV: E=Sophos;i="4.44,519,1249272000"; 
   d="scan'208";a="7285873"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Wed, 7 Oct 2009 14:01:42 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E443077@limkexm3.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpHNeGj/gwW09AJQUS2/H1MYJjuPgABC5ogAATbiQA=
References: <20091006115543.GH27168@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com> <20091006123658.GA31079@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com> <20091006135836.GA3926@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com> <20091006144805.GA10987@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com> <20091006160549.GA8881@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com> <20091007100638.GB3169@rakim.wolfsonmicro.main> 
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 07 Oct 2009 13:01:45.0286 (UTC) FILETIME=[52A22660:01CA474E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Hennerich, Michael
>>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>>Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
KeypadInput Device Driver
>>
>>On Wed, Oct 07, 2009 at 09:50:43AM +0100, Hennerich, Michael wrote:
>>
>>> As you said there are chip internal interrupt sources for I/Os,
keypad
>>> presses and releases, ambient light sensor comparator states, and
>>> overvoltage conditions.
>>> The current state of the driver uses only interrupts for the keypad.
>>> I think you agree that its common practice to only implement
>>> functionality for chip features that are typically used.
>>
>>Yes, but equally well it's good to avoid future issues as the driver
is
>>enhanced.  To be honest the main thing that made me notice when
reading
>>the patch was the use of the blocking notifier pattern to implement
the
>>interrupt infrastructure, mostly since it doesn't look like an IRQ
>>driver and the naming hides the fat that that's what it is.
>
>In case I would have done the whole ADP5520 in a single file exposing
functionality to the input,
>backlight, led and gpio infrastructure - I probably wouldn't find a
subtree maintainer that is likely
>to merge this blob.
>But apart from the GPIO interrupt capabilities - I wouldn't need doing
an interrupt controller.
>I think you agree.
>
>So this notifier chain seemed like a good approach to notifiy the
input/keypad/adp5520-keys about
>some work. BTW - this approach is used by other drivers for exactly the
same reason too.
>
>Honestly - I'm not yet convinced that this new irq stuff really works
in combination with my ADP5520
>Low Level IRQ.
>My chained_handler (for demux) as well as irq_desc .mask .unmask .ack
and .set_type need to also be
>allowed to invoke sleeping i2c transfers!!!?
>
>If I understood you right:
>
>Instead of request_threaded_irq() in my MFD core:
>
>I should do following: (unfortunately this is all on the bleeding edge
of technology, with no example
>driver actually using this craft)
>
>
>static struct irq_chip adp5520_irqchip = {
>	.name		= "ADP5520",
>	.mask		= adp5520_irq_mask, /* MAYSLEEP */
>	.unmask	= adp5520_irq_unmask, /* MAYSLEEP */
>	.set_type	= adp5520_irq_type, /* MAYSLEEP */
>};
>
>static void adp5520_irq_handler(unsigned irq, struct irq_desc *desc)
>{
>
>	/* MAYSLEEP */
>
>}
>
>--snip--
>
>	set_irq_data(client->irq, chip);
>	set_irq_chained_handler(client->irq, adp5520_irq_handler);
>
>Or instead of using the set_irq_chained_handler
>- I should use request_threaded_irq() and do whatever I wanted to do in
adp5520_irq_handler(unsigned
>irq, struct irq_desc *desc), in my irq_thread???
>
>For the additional interrupts exposed by the ADP5520 MFD Core Interrupt
Controller I do this:
>
>
>	set_irq_chip_and_handler_name(chip->irq_base +
ADP5520_KEYPAD_IRQ, &adp5520_irqchip,
>					handle_nested_irq,
"adp5520-demux");
>	set_irq_chip_data(chip->irq_base + ADP5520_KEYPAD_IRQ, chip);
>
>	set_irq_nested_thread(chip->irq_base + ADP5520_KEYPAD_IRQ, 1);
>
>	for (i = ADP5520_KEYPAD_IRQ; i < ngpio; i++) {
>		set_irq_chip_and_handler_name(i + chip->irq_base,
&adp5520_irqchip,
>					handle_nested_irq,
"adp5520-demux");
>		set_irq_chip_data(i + chip->irq_base, chip);
>		set_irq_nested_thread(chip->irq_base + i, 1);
>	}
>
>

Mark,

Most architectures define NR_IRQS to exactly the number of on-chip IRQs.
Therefore irq_desc pointers > NR_IRQS will fail on most architectures.
This driver should be usable out of the box - but I guess this may
prevent this.

-Michael

