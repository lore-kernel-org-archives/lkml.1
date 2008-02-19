Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbYBSI6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbYBSI6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYBSI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:58:40 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39173 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYBSI6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:58:39 -0500
X-IronPort-AV: E=Sophos;i="4.25,375,1199682000"; 
   d="scan'208";a="48709026"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Date: Tue, 19 Feb 2008 08:58:34 -0000
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC125CC945@limkexm2.ad.analog.com>
In-Reply-To: <alpine.LFD.1.00.0802182135580.7583@apollo.tec.linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown / disable
Thread-Index: Achybil+sUcwyFWpQ1OEo0QjZvppbQAZpqAw
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Feb 2008 08:58:37.0491 (UTC) FILETIME=[9D6E4830:01C872D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Thomas Gleixner Montag, 18. Februar 2008 21:38
>
>On Mon, 18 Feb 2008, Hennerich, Michael wrote:
>> >The patch below fixes the shutdown case and keeps the delayed
disable
>> >logic intact.
>>
>> >How did you notice ? I guess you got spurious interrupts after
calling
>> >free_irq(), right ?
>>
>> Exactly
>
>Can you please confirm, whether my version of the fix works for you as
>well.
>
>Thanks,
>
>	tglx

Thomas,

Works - no problems.
There was another typo 

>+			chip_disable : default_shutdown;
Should be better:
+                       chip->disable : default_shutdown;

Best regards,
Michael

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>

Index: kernel/irq/chip.c
===================================================================
--- kernel/irq/chip.c   (revision 4270)
+++ kernel/irq/chip.c   (working copy)
@@ -245,7 +245,20 @@
        return 0;
 }

+
 /*
+ * default shutdown function
+ */
+static void default_shutdown(unsigned int irq)
+{
+       struct irq_desc *desc = irq_desc + irq;
+
+       desc->chip->mask(irq);
+       desc->status |= IRQ_MASKED;
+}
+
+
+/*
  * Fixup enable/disable function pointers
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
@@ -257,7 +270,8 @@
        if (!chip->startup)
                chip->startup = default_startup;
        if (!chip->shutdown)
-               chip->shutdown = chip->disable;
+               chip->shutdown = chip->disable != default_disable ?
+                       chip->disable : default_shutdown;
        if (!chip->name)
                chip->name = chip->typename;
        if (!chip->end)
