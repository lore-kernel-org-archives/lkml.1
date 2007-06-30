Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbXF3LsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbXF3LsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 07:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXF3Lrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 07:47:55 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:34113 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbXF3Lrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 07:47:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 30 Jun 2007 05:45:42 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706292041.31291.bjorn.helgaas@hp.com> <200706301116.19501.arvidjaar@mail.ru>
In-Reply-To: <200706301116.19501.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706300545.43181.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 01:16:18 am Andrey Borzenkov wrote:
> > This patch fixes the 2.6.22 regression:
> >     "no irda0 interface (2.6.21 was OK), smsc does not find chip"
> 
> does not work, sorry.

Sigh ;-)  Thanks for your patience in dealing with this.

> [  958.125710]  00:0a: SMCf010 not responding at SIR 0x2e800000100, FIR 0x2e8def5a6d4; auto-configuring
> [  958.132837]  00:0a: not responding at SIR 0x2e800000100, FIR 0xded782bc000002e8; swapping SIR/FIR and reconfiguring
> [  958.140954]  00:0a: responds at SIR 0x100000002e8, FIR 0xded782bc000002e8

This means that the SMCf010 device *did* respond, I think at the
FIR address 0x100.  (I can't figure out the "right" way to print
those resource_size_t things, so I added some casts in the appended
patch.)

> [  524.426614] smsc_ircc_present(), addr 0x0100 - no device found!

But by the time the smsc_ircc2 driver got loaded, the device stopped
responding.  That means something happened in between that messed it up.

> as already mentioned, port 100 cannot work:
> 
> 0100-013f : pcmcia_socket0
> {pts/1}% sudo 
> cat /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io
> 0x00000100 - 0x000003af
> 0x000003e0 - 0x000004ff
> 0x00000820 - 0x000008ff
> 0x00000a00 - 0x00000aff
> 0x00000c00 - 0x00000cf7

Well, the whole problem I'm trying to fix is that we aren't doing
resource allocation correctly.  The BIOS has configured the IR
device to use port 0x100, and then something else came along and
decided to also use port 0x100.

It looks like the something else is the wlags49_h1_cs driver for
the PCMCIA card you have inserted.  Can you temporarily remove that
card and driver and try the patch below?  If the IR device works
without the wlags49_h1_cs driver, then we'll have to look at
wlags49_h1_cs to see whether it's doing something wrong.

Bjorn


[patch] PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues

When we enable the SMCf010 IR device, the Toshiba Portege 4000 BIOS claims
the device is working, but it really isn't configured correctly.  The BIOS
*will* configure it, but only if we call _SRS after (1) reversing the order
of the SIR and FIR I/O port regions and (2) changing the IRQ from active-high
to active-low.

This patch addresses the 2.6.22 regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"

I tested this on a Portege 4000.  The smsc-ircc2 driver correctly detects
the device, and "irattach irda0 -s && irdadump" shows transmitted and
received packets.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-06-27 20:07:45.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-06-30 05:27:03.000000000 -0600
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
@@ -152,16 +151,62 @@
 	 * this.  Fortunately, they do fix things up if we auto-configure
 	 * the device using its _PRS and _SRS methods.
 	 */
-	dev_err(&dev->dev, "%s device not responding, auto-configuring "
-		"resources\n", dev->id->id);
+	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
+		"auto-configuring\n", dev->id->id,
+		(unsigned long) pnp_port_start(dev, 0), 
+		(unsigned long) pnp_port_start(dev, 1));
 
 	pnp_disable_dev(dev);
 	pnp_init_resource_table(&dev->res);
 	pnp_auto_config_dev(dev);
 	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev)) {
+		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
+			(unsigned long) pnp_port_start(dev, 0),
+			(unsigned long) pnp_port_start(dev, 1));
+		return;
+	}
+
+	/*
+	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
+	 * followed by the SIR region.  The BIOS will configure the bridge,
+	 * but only if we call _SRS with SIR first, then FIR.  It also
+	 * reports the IRQ as active high, when it is really active low.
+	 */
+	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
+		"swapping SIR/FIR and reconfiguring\n",
+		(unsigned long) pnp_port_start(dev, 0),
+		(unsigned long) pnp_port_start(dev, 1));
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
+		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
+			(unsigned long) pnp_port_start(dev, 0),
+			(unsigned long) pnp_port_start(dev, 1));
+		return;
+	}
 
-	if (!quirk_smc_fir_enabled(dev))
-		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
+	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
+		"email bjorn.helgaas@hp.com\n");
 }
 
 
