Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXH2Qgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXH2Qgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXH2QgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:36:22 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:32904 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXH2QgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:36:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches: 8250 claims nonexisting device blocking IO port
Date: Wed, 29 Aug 2007 10:35:44 -0600
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org
References: <46D59081.2040605@googlemail.com>
In-Reply-To: <46D59081.2040605@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291035.44244.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 09:28:01 am Michal Piotrowski wrote:
> Subject         : 8250 claims non existing device blocking IO port
> References      : http://lkml.org/lkml/2007/8/18/20
> Last known good : ?
> Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
> Caused-By       : ?
> Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch           : http://lkml.org/lkml/2007/8/21/291
> Status          : patch was suggested

The following patch fixes this regression (confirmed by Andrey).
Please queue it for 2.6.23.  I'll come back later for another
try at sorting this all out.


PNP: remove SMCf010 quirk

If the quirk enables the SIR part of the SMCf010 device, the 8250 driver
may claim it as a legacy ttyS device, which makes the legacy probe in the
smsc-ircc2 driver fail.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-08-29 10:23:52.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-08-29 10:24:01.000000000 -0600
@@ -107,108 +107,6 @@
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
-static int quirk_smc_fir_enabled(struct pnp_dev *dev)
-{
-	unsigned long firbase;
-	u8 bank, high, low, chip;
-
-	if (!pnp_port_valid(dev, 1))
-		return 0;
-
-	firbase = pnp_port_start(dev, 1);
-
-	/* Select register bank 3 */
-	bank = inb(firbase + 7);
-	bank &= 0xf0;
-	bank |= 3;
-	outb(bank, firbase + 7);
-
-	high = inb(firbase + 0);
-	low = inb(firbase + 1);
-	chip = inb(firbase + 2);
-
-	/* This corresponds to the check in smsc_ircc_present() */
-	if (high == 0x10 && low == 0xb8 && (chip == 0xf1 || chip == 0xf2))
-		return 1;
-
-	return 0;
-}
-
-static void quirk_smc_enable(struct pnp_dev *dev)
-{
-	struct resource fir, sir, irq;
-
-	pnp_activate_dev(dev);
-	if (quirk_smc_fir_enabled(dev))
-		return;
-
-	/*
-	 * Sometimes the BIOS claims the device is enabled, but it reports
-	 * the wrong FIR resources or doesn't properly configure ISA or LPC
-	 * bridges on the way to the device.
-	 *
-	 * HP nc6000 and nc8000/nw8000 laptops have known problems like
-	 * this.  Fortunately, they do fix things up if we auto-configure
-	 * the device using its _PRS and _SRS methods.
-	 */
-	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
-		"auto-configuring\n", dev->id->id,
-		(unsigned long)pnp_port_start(dev, 0),
-		(unsigned long)pnp_port_start(dev, 1));
-
-	pnp_disable_dev(dev);
-	pnp_init_resource_table(&dev->res);
-	pnp_auto_config_dev(dev);
-	pnp_activate_dev(dev);
-	if (quirk_smc_fir_enabled(dev)) {
-		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long)pnp_port_start(dev, 0),
-			(unsigned long)pnp_port_start(dev, 1));
-		return;
-	}
-
-	/*
-	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
-	 * followed by the SIR region.  The BIOS will configure the bridge,
-	 * but only if we call _SRS with SIR first, then FIR.  It also
-	 * reports the IRQ as active high, when it is really active low.
-	 */
-	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
-		"swapping SIR/FIR and reconfiguring\n",
-		(unsigned long)pnp_port_start(dev, 0),
-		(unsigned long)pnp_port_start(dev, 1));
-
-	/*
-	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
-	 * these resources any more.
-	 */
-	fir = dev->res.port_resource[0];
-	sir = dev->res.port_resource[1];
-	fir.flags &= ~IORESOURCE_AUTO;
-	sir.flags &= ~IORESOURCE_AUTO;
-
-	irq = dev->res.irq_resource[0];
-	irq.flags &= ~IORESOURCE_AUTO;
-	irq.flags &= ~IORESOURCE_BITS;
-	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
-
-	pnp_disable_dev(dev);
-	dev->res.port_resource[0] = sir;
-	dev->res.port_resource[1] = fir;
-	dev->res.irq_resource[0] = irq;
-	pnp_activate_dev(dev);
-
-	if (quirk_smc_fir_enabled(dev)) {
-		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long)pnp_port_start(dev, 0),
-			(unsigned long)pnp_port_start(dev, 1));
-		return;
-	}
-
-	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
-		"email bjorn.helgaas@hp.com\n");
-}
-
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -229,7 +127,6 @@
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
-	{"SMCf010", quirk_smc_enable},
 	{""}
 };
 
