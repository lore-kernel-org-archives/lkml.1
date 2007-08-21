Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXHUTfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXHUTfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXHUTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:35:20 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:35607 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbXHUTfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:35:17 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Tue, 21 Aug 2007 13:34:57 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708201111.19023.bjorn.helgaas@hp.com> <200708212228.50877.arvidjaar@mail.ru>
In-Reply-To: <200708212228.50877.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211334.58157.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007 12:28:49 pm Andrey Borzenkov wrote:
> On Monday 20 August 2007, Bjorn Helgaas wrote:
> > On Monday 20 August 2007 10:28:22 am Andrey Borzenkov wrote:
> > > This worked in 2.6.22 with the same quirks. I will test without later but
> > > I fail to see how they are related.
> >
> > OK, let me know what happens.  The way it's related is that the quirk
> > fiddles with the IRDA device, and it probably changes the SIR config
> > so that it starts responding at the ttyS3 address.
> 
> You are probably right. Disabling quirk makes it work again (with pnp off in 
> smsc-ircc2 of course).

I think pnp is off in smsc-ircc2 by default, right?

> Hmm ... is there any reason why this quirk is in PnP core in the first place? 
> Would not it be more logical to have it in (PnP) part of smsc-ircc2? This way 
> it could share code with legacy detection; and it even may have chance to 
> work - assuming BIOS is aware that 0x100 is claimed by PCMCIA it could 
> allocate different port when we try to activate device after that ... should 
> I give it a try?

I agree it would make sense to put the quirk in smsc-ircc2, since
we only need it if we want to use the smsc-ircc2 driver.  But I don't
think we have a mechanism for calling quirks at module load-time, so
it has to be part of the static kernel.  And we don't have anything
like DECLARE_PCI_FIXUP_SECTION, so it really has to be in quirks.c for
now.

How does the following patch look?



PNP: remove SMCf010 quirk

If the quirk enables the SIR part of the SMCf010 device, the 8250 driver
may claim it as a legacy ttyS device, which makes the legacy probe in the
smsc-ircc2 driver fail.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-08-21 12:34:51.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-08-21 12:35:08.000000000 -0600
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
 



