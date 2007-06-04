Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbXFDQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbXFDQeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXFDQeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:34:12 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:47713 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbXFDQeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:34:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Mon, 4 Jun 2007 10:34:06 -0600
User-Agent: KMail/1.9.6
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <200706031200.07514.arvidjaar@mail.ru> <200706031216.06172.arvidjaar@mail.ru>
In-Reply-To: <200706031216.06172.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041034.06353.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 June 2007 02:16:05 am Andrey Borzenkov wrote:
> On Sunday 03 June 2007, Andrey Borzenkov wrote:
> > Under 2.6.22-rc I lost irda0 interface - smsc claims no device present.
> > Nothing was changed in setup except kernel version.
> >
> > 2.6.21:
> >
> > Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
> > pre-configuring device.
> > Activated ALi 1533 ISA bridge port 0x02e8.
> > Activated ALi 1533 ISA bridge port 0x02f8.
> > found SMC SuperIO Chip (devid=0x5a rev=00 base=0x002e): LPC47N227
> > smsc_superio_flat(): IrDA not enabled

The "IrDA not enabled" makes me think that even in the working case,
the BIOS left the IR port disabled.  Are there any BIOS setup switches
that affect this port?

> > smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode: 0x02
> > SMsC IrDA Controller found
> >  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3, irq=7

It seems strange that both FIR and SIR would use legacy COM ports
(0x2f8 == COM2, 0x2e8 == COM4).  My HP nw8240 has SIR at 0x3e8 (COM3)
and FIR at 0x100.

Do you know if both the FIR and SIR interfaces work?  I'm wondering if
your irda0 only uses SIR at 0x2e8, and FIR has always been broken.

> > No transceiver found. Defaulting to Fast pin select
> > IrDA: Registered device irda0
> >
> >
> > 2.6.22-rc3:
> > Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip,
> > pre-configuring device.
> > Activated ALi 1533 ISA bridge port 0x02e8.
> > Activated ALi 1533 ISA bridge port 0x02f8.
> > pnp: Device 00:0a activated.
> > smsc_ircc_present(), addr 0x02e8 - no device found!
> > pnp: Device 00:0a disabled.

> {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> state = active
> io 0x100-0x107
> io 0x2e8-0x2ef
> irq 5
> dma 1

The PNP probe I added expects SIR at the first range and FIR at the
second.  I would think the 0x2e8 range would be SIR, since it's compatible
with a COM port.  Is it possible the BIOS just reports these in the
opposite order, with FIR first and SIR second?  Can you try the patch
below?

Index: linux-2.6/drivers/net/irda/smsc-ircc2.c
===================================================================
--- linux-2.6.orig/drivers/net/irda/smsc-ircc2.c	2007-06-04 10:21:46.000000000 -0600
+++ linux-2.6/drivers/net/irda/smsc-ircc2.c	2007-06-04 10:21:57.000000000 -0600
@@ -386,8 +386,8 @@
 	      pnp_dma_valid(dev, 0) && pnp_irq_valid(dev, 0)))
 		return -EINVAL;
 
-	sirbase = pnp_port_start(dev, 0);
-	firbase = pnp_port_start(dev, 1);
+	firbase = pnp_port_start(dev, 0);
+	sirbase = pnp_port_start(dev, 1);
 	dma = pnp_dma(dev, 0);
 	irq = pnp_irq(dev, 0);
 
