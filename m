Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYE3Wxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYE3Wxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYE3Wt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:49:56 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47674 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYE3Wtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:49:42 -0400
Message-Id: <20080530224933.755433659@ldl.fc.hp.com>
References: <20080530224853.976744229@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 16:49:05 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 12/15] PNPACPI: ignore _PRS interrupt numbers larger than PNP_IRQ_NR
Content-Disposition: inline; filename=pnpacpi-extended-irq-option
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI Extended Interrupt Descriptors can encode 32-bit interrupt
numbers, so an interrupt number may exceed the size of the bitmap
we use to track possible IRQ settings.

To avoid corrupting memory, complain and ignore too-large interrupt
numbers.

There's similar code in pnpacpi_parse_irq_option(), but I didn't
change that because the small IRQ descriptor can only encode
IRQs 0-15, which do not exceed bitmap size.

In the future, we could handle IRQ numbers greater than PNP_IRQ_NR
by replacing the bitmap with a table or list.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-05-30 13:23:34.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-05-30 14:45:52.000000000 -0600
@@ -421,9 +421,16 @@ static __init void pnpacpi_parse_ext_irq
 		return;
 
 	bitmap_zero(map.bits, PNP_IRQ_NR);
-	for (i = 0; i < p->interrupt_count; i++)
-		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], map.bits);
+	for (i = 0; i < p->interrupt_count; i++) {
+		if (p->interrupts[i]) {
+			if (p->interrupts[i] < PNP_IRQ_NR)
+				__set_bit(p->interrupts[i], map.bits);
+			else
+				dev_err(&dev->dev, "ignoring IRQ %d option "
+					"(too large for %d entry bitmap)\n",
+					p->interrupts[i], PNP_IRQ_NR);
+		}
+	}
 
 	flags = irq_flags(p->triggering, p->polarity, p->sharable);
 	pnp_register_irq_resource(dev, option, &map, flags);

-- 
