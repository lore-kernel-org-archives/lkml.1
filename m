Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbXF1D40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbXF1D40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbXF1D4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:56:18 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:53779 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759575AbXF1D4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:56:17 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Wed, 27 Jun 2007 21:56:05 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706162038.57296.arvidjaar@mail.ru> <200706191731.24085.bjorn.helgaas@hp.com>
In-Reply-To: <200706191731.24085.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272156.05865.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey,

Can you try the following patch?  It applies on top of the previous
two patches, and it is enough to make the driver find the device on
my Portege 4000.  Unfortunately, I can't tell whether it really works
because I don't have a clue about how to make two IR devices talk
to each other.

Bjorn

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-06-27 20:07:45.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-06-27 20:57:47.000000000 -0600
@@ -136,11 +136,11 @@
 
 static void quirk_smc_enable(struct pnp_dev *dev)
 {
-	/*
-	 * If the BIOS left the device disabled, or it is enabled and
-	 * responding correctly, we're in good shape.
-	 */
-	if (!dev->active || quirk_smc_fir_enabled(dev))
+	unsigned int irq;
+	unsigned long flags;
+
+	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev))
 		return;
 
 	/*
@@ -159,9 +159,34 @@
 	pnp_init_resource_table(&dev->res);
 	pnp_auto_config_dev(dev);
 	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev))
+		return;
+
+	/*
+	 * The Toshiba Portege 4000 reports the IRQ as active high,
+	 * edge-triggered, but the device only seems to work when we
+	 * program it as something else.
+	 */
+	irq = pnp_irq(dev, 0);
+	flags = pnp_irq_flags(dev, 0);
+	pnp_disable_dev(dev);
+	dev->res.irq_resource[0].start = irq;
+	dev->res.irq_resource[0].end   = irq;
+	flags &= ~IORESOURCE_AUTO;
+	if ((flags & IORESOURCE_BITS) == IORESOURCE_IRQ_HIGHEDGE) {
+		flags &= ~IORESOURCE_BITS;
+		flags |= IORESOURCE_IRQ_LOWEDGE;
+		dev_err(&dev->dev, "still not responding, changing high-edge "
+			"IRQ to low-edge\n");
+	}
+	dev->res.irq_resource[0].flags = flags;
+	pnp_activate_dev(dev);
+
+	if (quirk_smc_fir_enabled(dev))
+		return;
 
-	if (!quirk_smc_fir_enabled(dev))
-		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
+	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
+		"email bjorn.helgaas@hp.com\n");
 }
 
 
