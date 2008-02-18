Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYBRSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYBRSFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYBRSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:05:40 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:62983 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYBRSFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:05:39 -0500
X-IronPort-AV: E=Sophos;i="4.25,372,1199682000"; 
   d="scan'208";a="48681797"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Date: Mon, 18 Feb 2008 18:04:54 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC125CC53A@limkexm2.ad.analog.com>
In-Reply-To: <alpine.LFD.1.00.0802181814550.7583@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Thread-Index: AchyVpdNF7DIuTKZRjqg/Qo9s+AKiQAAQmQQ
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Feb 2008 18:04:56.0555 (UTC) FILETIME=[C4DCC3B0:01C87258]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: Thomas Gleixner Montag, 18. Februar 2008 18:49
>
>On Mon, 18 Feb 2008, Hennerich, Michael wrote:
>> RESENT: Add Maintainers
>>
>> free_irq() does not disable/mask the irq, in case disable or shutdown
in
>struct irq_chip is left uninitilazied.
>>
>> /**
>>  * struct irq_chip - hardware interrupt chip descriptor
>>  *
>>  * @name:	name for /proc/interrupts
>>  * @startup:	start up the interrupt (defaults to ->enable if NULL)
>>  * @shutdown:	shut down the interrupt (defaults to ->disable
if NULL)
>>  * @enable:		enable the interrupt (defaults to chip->unmask
if
>NULL)
>>  * @disable:	disable the interrupt (defaults to chip->mask if NULL)
>>
>>
>> According to linux/irq.h struct irq_chip information,
>> chip->disable should default to chip->mask if NULL.
>> However irq_chip_set_defaults(struct irq_chip *chip) will set it to
>default_disable an empty function.
>>
>> In earlier kernel versions such as 2.6.19 default_disable called
chip-
>>mask.
>> In 2.6.22 and 2.6.24 default_disable is an empty function.
>>
>> Looking through various architectures, it's still pretty common that
>disable and shutdown is NULL.
>
>Yeah, you are right. This was broken by commit
>76d2160147f43f982dfe881404cfde9fd0a9da21
>
>> Do I miss something here?
>
>Just a small detail. The commit optimized the irq_disable/enable logic
>by defaulting to delayed disable. So we want to keep that logic intact
>in case that we still have a device which is handling this
>interrupt. For the free_irq() case your patch is correct.
>
>The patch below fixes the shutdown case and keeps the delayed disable
>logic intact.
>
>How did you notice ? I guess you got spurious interrupts after calling
>free_irq(), right ?

Exactly

-Michael 


>
>Thanks for analyzing and reporting,
>
>	tglx
>
>------------->
>Subject: genirq: do not leave interupts enabled on free_irq
>From: Thomas Gleixner <tglx@linutronix.de>
>Date: Mon, 18 Feb 2008 18:25:17 +0100
>
>The default_disable() function was changed in commit:
>
> 76d2160147f43f982dfe881404cfde9fd0a9da21
> genirq: do not mask interrupts by default
>
>It removed the mask function in favour of the default delayed
>interrupt disable handling. Unfortunately this also broke the shutdown
>in free_irq() when the last handler is removed from the interrupt for
>those architectures which rely on the default implementations. Now we
>can end up with a enabled interrupt line after the last handler was
>removed.
>
>Fix this by adding a default_shutdown function, which is only
>installed, when the irqchip implementation does provide neither a
>shutdown nor a disable function.
>
>Pointed-out-by: Michael Hennerich <Michael.Hennerich@analog.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>CC: stable@kernel.org
>
>---
> kernel/irq/chip.c |   14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)
>
>Index: linux-2.6/kernel/irq/chip.c
>===================================================================
>--- linux-2.6.orig/kernel/irq/chip.c
>+++ linux-2.6/kernel/irq/chip.c
>@@ -246,6 +246,17 @@ static unsigned int default_startup(unsi
> }
>
> /*
>+ * default shutdown function
>+ */
>+static void default_shutdown(unsigned int irq)
>+{
>+	struct irq_desc *desc = irq_desc + irq;
>+
>+	desc->chip->mask(irq);
>+	desc->status &= ~IRQ_MASKED;
>+}
>+
>+/*
>  * Fixup enable/disable function pointers
>  */
> void irq_chip_set_defaults(struct irq_chip *chip)
>@@ -257,7 +268,8 @@ void irq_chip_set_defaults(struct irq_ch
> 	if (!chip->startup)
> 		chip->startup = default_startup;
> 	if (!chip->shutdown)
>-		chip->shutdown = chip->disable;
>+		chip->shutdown = chip->disable != default_disable ?
>+			chip_disable : default_shutdown;
> 	if (!chip->name)
> 		chip->name = chip->typename;
> 	if (!chip->end)
