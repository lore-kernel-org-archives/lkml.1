Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbXFNVbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbXFNVbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXFNVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:31:07 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:34122 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXFNVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:31:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 14 Jun 2007 15:30:55 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706101503.29156.bjorn.helgaas@hp.com> <200706111804.49752.arvidjaar@mail.ru>
In-Reply-To: <200706111804.49752.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QObcGIA+wStdQOa"
Message-Id: <200706141530.56176.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QObcGIA+wStdQOa
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrey,

If you have a chance, can you try the attached two patches?  The
smsc-preconfig patch makes the HP nx5000 work, and the smsc-quirk
patch makes the nw8000/nc8000 work, too.

I've heard rumors that Windows does basically the same thing as the
smsc-quirk patch, so I think there's a chance it might make your
Toshiba work as well.

I sent the smsc-preconfig patch to Andrew this morning.  I'm going
to do some more testing other HP laptops before sending him the
smsc-quirk patch.

Bjorn

--Boundary-00=_QObcGIA+wStdQOa
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="smsc-preconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="smsc-preconfig"

[patch] smsc-ircc2: skip preconfiguration for PNP devices

If we rely on the device resources from PNPBIOS, we also have to
rely on the BIOS to configure any bridges on the way to the device.

Using the PNPBIOS resources but changing the configuration of a
bridge behind the back of the firmware is likely to make things
inconsistent.

This patch addresses part of this regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"
It fixes smsc-ircc2 PNP device detection on HP nx5000 laptops.
Other laptops, including HP nc6000, HP nc8000, HP nw8000, and Toshiba
Portege 4000, still need PNP quirks to make this work.

With "smsc-ircc2.nopnp", we do the legacy device probe, including
manual bridge preconfiguration, as before.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/net/irda/smsc-ircc2.c
===================================================================
--- w.orig/drivers/net/irda/smsc-ircc2.c	2007-06-06 15:45:14.000000000 -0600
+++ w/drivers/net/irda/smsc-ircc2.c	2007-06-06 15:50:40.000000000 -0600
@@ -416,6 +416,13 @@
 {
 	int ret = 0;
 
+#ifdef CONFIG_PCI
+	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
+		/* Ignore errors from preconfiguration */
+		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
+	}
+#endif
+
 	if (ircc_fir > 0 && ircc_sir > 0) {
 		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
 		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
@@ -459,13 +466,6 @@
 		return ret;
 	}
 
-#ifdef CONFIG_PCI
-	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
-		/* Ignore errors from preconfiguration */
-		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
-	}
-#endif
-
 	dev_count = 0;
 
 	if (smsc_nopnp || !pnp_platform_devices ||

--Boundary-00=_QObcGIA+wStdQOa
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="smsc-quirk"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="smsc-quirk"

[patch] PNP SMCf010 quirk: auto-config device if BIOS left it broken

Some HP firmware leaves the SMCf010 IRDA device incompletely configured,
or reports the wrong resources in _CRS.  As a workaround, when we find
such a device, try to auto-configure the device.

This ignores the _CRS data, picks a config from _PRS, and runs _SRS to
configure the device.  This makes smsc-ircc2 work correctly with PNP
resources on HP nx5000 and nc8000/nw8000 system.

I think Windows does something like this by default for all devices,
so we might want to consider doing the same thing in Linux.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pnp/quirks.c
===================================================================
--- w.orig/drivers/pnp/quirks.c	2007-06-14 15:08:45.000000000 -0600
+++ w/drivers/pnp/quirks.c	2007-06-14 15:09:56.000000000 -0600
@@ -107,31 +107,61 @@
 	return;
 }
 
-static void quirk_smc_enable(struct pnp_dev *dev)
+static int quirk_smc_fir_enabled(struct pnp_dev *dev)
 {
-	unsigned int firbase;
+	unsigned long firbase;
+	u8 bank, high, low, chip;
+
+	if (!pnp_port_valid(dev, 1))
+		return 0;
+
+	firbase = pnp_port_start(dev, 1);
 
-	if (!dev->active || !pnp_port_valid(dev, 1))
+	/* Select register bank 3 */
+	bank = inb(firbase + 7);
+	bank &= 0xf0;
+	bank |= 3;
+	outb(bank, firbase + 7);
+
+	high = inb(firbase + 0);
+	low  = inb(firbase + 1);
+	chip = inb(firbase + 2);
+
+	/* This corresponds to the check in smsc_ircc_present() */
+	if (high == 0x10 && low == 0xb8 && (chip == 0xf1 || chip == 0xf2))
+		return 1;
+
+	return 0;
+}
+
+static void quirk_smc_enable(struct pnp_dev *dev)
+{
+	/*
+	 * If the BIOS left the device disabled, or it is enabled and
+	 * responding correctly, we're in good shape.
+	 */
+	if (!dev->active || quirk_smc_fir_enabled(dev))
 		return;
 
 	/*
-	 * On the HP/Compaq nw8240 (and probably other similar machines),
-	 * there is an SMCF010 device with two I/O port regions:
-	 *
-	 *	0x3e8-0x3ef SIR
-	 *	0x100-0x10f FIR
+	 * Sometimes the BIOS claims the device is enabled, but it reports
+	 * the wrong FIR resources or doesn't properly configure ISA or LPC
+	 * bridges on the way to the device.
 	 *
-	 * _STA reports the device is enabled, but in fact, the BIOS
-	 * neglects to enable the FIR range.  Fortunately, it does fully
-	 * enable the device if we call _SRS.
+	 * HP nc6000 and nc8000/nw8000 laptops have known problems like
+	 * this.  Fortunately, they do fix things up if we auto-configure
+	 * the device using its _PRS and _SRS methods.
 	 */
-	firbase = pnp_port_start(dev, 1);
-	if (inb(firbase + 0x7 /* IRCC_MASTER */) == 0xff) {
-		pnp_err("%s (%s) enabled but not responding, disabling and "
-			"re-enabling", dev->dev.bus_id, pnp_dev_name(dev));
-		pnp_disable_dev(dev);
-		pnp_activate_dev(dev);
-	}
+	dev_err(&dev->dev, "%s device not responding, auto-configuring "
+		"resources\n", dev->id->id);
+
+	pnp_disable_dev(dev);
+	pnp_init_resource_table(&dev->res);
+	pnp_auto_config_dev(dev);
+	pnp_activate_dev(dev);
+
+	if (!quirk_smc_fir_enabled(dev))
+		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
 }
 
 

--Boundary-00=_QObcGIA+wStdQOa--
