Return-Path: <linux-kernel-owner+w=401wt.eu-S935012AbXFFTKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbXFFTKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbXFFTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:09:52 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:46713 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbXFFTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:09:51 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Wed, 6 Jun 2007 13:09:28 -0600
User-Agent: KMail/1.9.6
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706051723.56436.bjorn.helgaas@hp.com> <200706060729.13338.arvidjaar@mail.ru>
In-Reply-To: <200706060729.13338.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061309.28633.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 09:29:11 pm Andrey Borzenkov wrote:
> On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> > Something's wrong with this strategy.  The BIOS is telling us that an
> > SMCf010 device is present, active, and responds at io ports 0x100-0x107
> > and 0x2e8-0x2ef.  The fact that it happens to be on the other side of
> > an ISA or LPC bridge should be immaterial to the OS driver.
> 
> I thought this as well.

If this is really true, it also means we shouldn't twiddle with the
bridge.  If the BIOS left us a working setup, the preconfiguration
is certainly going to change it to something incompatible with the
PNP info.

What if we try the following patch, which keeps the FIR/SIR swap and
just removes the preconfiguration?

Index: linux-2.6/drivers/net/irda/smsc-ircc2.c
===================================================================
--- linux-2.6.orig/drivers/net/irda/smsc-ircc2.c	2007-06-04 10:35:03.000000000 -0600
+++ linux-2.6/drivers/net/irda/smsc-ircc2.c	2007-06-06 13:05:31.000000000 -0600
@@ -232,9 +232,7 @@
 #ifdef CONFIG_PCI
 static int __init preconfigure_smsc_chip(struct smsc_ircc_subsystem_configuration *conf);
 static int __init preconfigure_through_82801(struct pci_dev *dev, struct smsc_ircc_subsystem_configuration *conf);
-static void __init preconfigure_ali_port(struct pci_dev *dev,
 					 unsigned short port);
-static int __init preconfigure_through_ali(struct pci_dev *dev, struct smsc_ircc_subsystem_configuration *conf);
 static int __init smsc_ircc_preconfigure_subsystems(unsigned short ircc_cfg,
 						    unsigned short ircc_fir,
 						    unsigned short ircc_sir,
@@ -386,8 +384,8 @@
 	      pnp_dma_valid(dev, 0) && pnp_irq_valid(dev, 0)))
 		return -EINVAL;
 
-	sirbase = pnp_port_start(dev, 0);
-	firbase = pnp_port_start(dev, 1);
+	firbase = pnp_port_start(dev, 0);
+	sirbase = pnp_port_start(dev, 1);
 	dma = pnp_dma(dev, 0);
 	irq = pnp_irq(dev, 0);
 
@@ -2511,20 +2509,6 @@
 		.preconfigure = preconfigure_through_82801,
 		.name = "Toshiba laptop with Intel 8281DBM LPC bridge",
 	},
-	{
-		/* ALi M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+] */
-		.vendor = PCIID_VENDOR_ALI,
-		.device = 0x1533,
-		.subvendor = 0x1179,
-		.subdevice = 0xffff, /* 0xffff is "any" */
-		.sir_io = 0x02e8,
-		.fir_io = 0x02f8,
-		.fir_irq = 0x07,
-		.fir_dma = 0x03,
-		.cfg_base = 0x002e,
-		.preconfigure = preconfigure_through_ali,
-		.name = "Toshiba laptop with ALi ISA bridge",
-	},
 	{ } // Terminator
 };
 
@@ -2783,63 +2767,6 @@
 	return preconfigure_smsc_chip(conf);
 }
 
-/*
- * Pre-configure a certain port on the ALi 1533 bridge.
- * This is based on reverse-engineering since ALi does not
- * provide any data sheet for the 1533 chip.
- */
-static void __init preconfigure_ali_port(struct pci_dev *dev,
-					 unsigned short port)
-{
-	unsigned char reg;
-	/* These bits obviously control the different ports */
-	unsigned char mask;
-	unsigned char tmpbyte;
-
-	switch(port) {
-	case 0x0130:
-	case 0x0178:
-		reg = 0xb0;
-		mask = 0x80;
-		break;
-	case 0x03f8:
-		reg = 0xb4;
-		mask = 0x80;
-		break;
-	case 0x02f8:
-		reg = 0xb4;
-		mask = 0x30;
-		break;
-	case 0x02e8:
-		reg = 0xb4;
-		mask = 0x08;
-		break;
-	default:
-		IRDA_ERROR("Failed to configure unsupported port on ALi 1533 bridge: 0x%04x\n", port);
-		return;
-	}
-
-	pci_read_config_byte(dev, reg, &tmpbyte);
-	/* Turn on the right bits */
-	tmpbyte |= mask;
-	pci_write_config_byte(dev, reg, tmpbyte);
-	IRDA_MESSAGE("Activated ALi 1533 ISA bridge port 0x%04x.\n", port);
-	return;
-}
-
-static int __init preconfigure_through_ali(struct pci_dev *dev,
-					   struct
-					   smsc_ircc_subsystem_configuration
-					   *conf)
-{
-	/* Configure the two ports on the ALi 1533 */
-	preconfigure_ali_port(dev, conf->sir_io);
-	preconfigure_ali_port(dev, conf->fir_io);
-
-	/* Pre-configure chip */
-	return preconfigure_smsc_chip(conf);
-}
-
 static int __init smsc_ircc_preconfigure_subsystems(unsigned short ircc_cfg,
 						    unsigned short ircc_fir,
 						    unsigned short ircc_sir,
