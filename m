Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXF3Cls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXF3Cls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 22:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXF3Clk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 22:41:40 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:57391 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXF3Clj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 22:41:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Fri, 29 Jun 2007 20:41:31 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706191731.24085.bjorn.helgaas@hp.com> <200706272156.05865.bjorn.helgaas@hp.com>
In-Reply-To: <200706272156.05865.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706292041.31291.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[patch] PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues

When we enable the SMCf010 IR device, the Toshiba Portege 4000 BIOS claims
the device is working, but it really isn't configured correctly.  The BIOS
*will* configure it, but only if we call _SRS after (1) reversing the order
of the SIR and FIR I/O port regions and (2) changing the IRQ from active-high
to active-low.

This patch fixes the 2.6.22 regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"

I tested this on a Portege 4000.  The smsc-ircc2 driver correctly detects
the device, and "irattach irda0 -s && irdadump" shows transmitted and
received packets.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-06-27 20:07:45.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-06-29 19:28:02.000000000 -0600
@@ -136,11 +136,10 @@
 
 static void quirk_smc_enable(struct pnp_dev *dev)
 {
-	/*
-	 * If the BIOS left the device disabled, or it is enabled and
-	 * responding correctly, we're in good shape.
-	 */
-	if (!dev->active || quirk_smc_fir_enabled(dev))
+	struct resource fir, sir, irq;
+
+	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev))
 		return;
 
 	/*
@@ -152,16 +151,58 @@
 	 * this.  Fortunately, they do fix things up if we auto-configure
 	 * the device using its _PRS and _SRS methods.
 	 */
-	dev_err(&dev->dev, "%s device not responding, auto-configuring "
-		"resources\n", dev->id->id);
+	dev_err(&dev->dev, "%s not responding at SIR 0x%llx, FIR 0x%llx; "
+		"auto-configuring\n", dev->id->id,
+		pnp_port_start(dev, 0), pnp_port_start(dev, 1));
 
 	pnp_disable_dev(dev);
 	pnp_init_resource_table(&dev->res);
 	pnp_auto_config_dev(dev);
 	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev)) {
+		dev_err(&dev->dev, "responds at SIR 0x%llx, FIR 0x%llx\n",
+			pnp_port_start(dev, 0), pnp_port_start(dev, 1));
+		return;
+	}
+
+	/*
+	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
+	 * followed by the SIR region.  The BIOS will configure the bridge,
+	 * but only if we call _SRS with SIR first, then FIR.  It also
+	 * reports the IRQ as active high, when it is really active low.
+	 */
+	dev_err(&dev->dev, "not responding at SIR 0x%llx, FIR 0x%llx; "
+		"swapping SIR/FIR and reconfiguring\n",
+		pnp_port_start(dev, 0), pnp_port_start(dev, 1));
+
+	/*
+	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
+	 * these resources any more.
+	 */
+	fir = dev->res.port_resource[0];
+	sir = dev->res.port_resource[1];
+	fir.flags &= ~IORESOURCE_AUTO;
+	sir.flags &= ~IORESOURCE_AUTO;
+
+	irq = dev->res.irq_resource[0];
+	irq.flags &= ~IORESOURCE_AUTO;
+	irq.flags &= ~IORESOURCE_BITS;
+	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
+
+	pnp_disable_dev(dev);
+	dev->res.port_resource[0] = sir;
+	dev->res.port_resource[1] = fir;
+	dev->res.irq_resource[0] = irq;
+	pnp_activate_dev(dev);
+
+	if (quirk_smc_fir_enabled(dev)) {
+		dev_err(&dev->dev, "responds at SIR 0x%llx, FIR 0x%llx\n",
+			pnp_port_start(dev, 0), pnp_port_start(dev, 1));
+		return;
+	}
 
-	if (!quirk_smc_fir_enabled(dev))
-		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
+	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
+		"email bjorn.helgaas@hp.com\n");
 }
 
 
