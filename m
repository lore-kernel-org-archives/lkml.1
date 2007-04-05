Return-Path: <linux-kernel-owner+w=401wt.eu-S1767210AbXDESps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767210AbXDESps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767211AbXDESps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:45:48 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:43401 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767210AbXDESpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:45:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 4/5] smsc-ircc2: add PNP support
Date: Thu, 5 Apr 2007 12:45:03 -0600
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Keith Owens <kaos@ocs.com.au>,
       Len Brown <lenb@kernel.org>, Adam Belay <ambx1@neo.rr.com>,
       Matthieu CASTET <castet.matthieu@free.fr>,
       Jean Tourrilhes <jt@hpl.hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ville Syrjala <syrjala@sci.fi>,
       Russell King <rmk+serial@arm.linux.org.uk>,
       linux-serial@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
       linux-kernel@vger.kernel.org
References: <20070404224536.337573000@ldl.fc.hp.com> <20070404224609.042716000@ldl.fc.hp.com> <20070404161650.e05049e4.randy.dunlap@oracle.com>
In-Reply-To: <20070404161650.e05049e4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200704051245.03748.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 17:16, Randy Dunlap wrote:
> On Wed, 04 Apr 2007 16:45:40 -0600 Bjorn Helgaas wrote:
> > +static int smsc_nopnp;
> > +module_param_named(nopnp, smsc_nopnp, bool, 0);
> > +MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
> 
> Document this parameter (like you did "legacy_serial.force" in the
> other patch -- thanks).

Thanks for the reminder.  Here's an updated patch with documentation.


Subject: smsc-ircc2: add PNP support

Claim devices using PNP, unless the user explicitly specified device
addresses.  This can be disabled with the "smsc-ircc2.nopnp" option.

This removes the need for probing legacy addresses and helps untangle
IR devices from serial8250 devices.

Sometimes the SMC device is at a legacy COM port address but does not
use the legacy COM IRQ.  In this case, claiming the device using PNP
rather than 8250 legacy probe means we can automatically use the
correct IRQ rather than forcing the user to use "setserial" to set the
IRQ manually.

If the PNP claim doesn't work, make sure you don't have a setserial init
script, e.g., /etc/init.d/setserial, configured to poke in legacy COM
port resources for the IRDA device.  That causes the serial driver to
claim resources needed by this driver.

Based on this patch by Ville Syrjälä:
    http://www.hpl.hp.com/personal/Jean_Tourrilhes/IrDA/ir260_smsc_pnp.diff

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/net/irda/smsc-ircc2.c
===================================================================
--- w.orig/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:45:18.000000000 -0600
+++ w/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:47:00.000000000 -0600
@@ -79,6 +79,10 @@
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
+static int smsc_nopnp;
+module_param_named(nopnp, smsc_nopnp, bool, 0);
+MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
+
 #define DMA_INVAL 255
 static int ircc_dma = DMA_INVAL;
 module_param(ircc_dma, int, 0);
@@ -362,7 +366,6 @@
                iobase + IRCC_MASTER);
 }
 
-#ifdef	CONFIG_PNP
 /* PNP hotplug support */
 static const struct pnp_device_id smsc_ircc_pnp_table[] = {
 	{ .id = "SMCf010", .driver_data = 0 },
@@ -370,7 +373,35 @@
 	{ }
 };
 MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
-#endif
+
+static int pnp_driver_registered;
+
+static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
+				      const struct pnp_device_id *dev_id)
+{
+	unsigned int firbase, sirbase;
+	u8 dma, irq;
+
+	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) &&
+	      pnp_dma_valid(dev, 0) && pnp_irq_valid(dev, 0)))
+		return -EINVAL;
+
+	sirbase = pnp_port_start(dev, 0);
+	firbase = pnp_port_start(dev, 1);
+	dma = pnp_dma(dev, 0);
+	irq = pnp_irq(dev, 0);
+
+	if (smsc_ircc_open(firbase, sirbase, dma, irq))
+		return -ENODEV;
+
+	return 0;
+}
+
+static struct pnp_driver smsc_ircc_pnp_driver = {
+	.name		= "smsc-ircc2",
+	.id_table	= smsc_ircc_pnp_table,
+	.probe		= smsc_ircc_pnp_probe,
+};
 
 
 /*******************************************************************************
@@ -381,6 +412,35 @@
  *
  *******************************************************************************/
 
+static int __init smsc_ircc_legacy_probe(void)
+{
+	int ret = 0;
+
+	if (ircc_fir > 0 && ircc_sir > 0) {
+		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
+		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
+
+		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
+			ret = -ENODEV;
+	} else {
+		ret = -ENODEV;
+
+		/* try user provided configuration register base address */
+		if (ircc_cfg > 0) {
+			IRDA_MESSAGE(" Overriding configuration address "
+				     "0x%04x\n", ircc_cfg);
+			if (!smsc_superio_fdc(ircc_cfg))
+				ret = 0;
+			if (!smsc_superio_lpc(ircc_cfg))
+				ret = 0;
+		}
+
+		if (smsc_ircc_look_for_chips() > 0)
+			ret = 0;
+	}
+	return ret;
+}
+
 /*
  * Function smsc_ircc_init ()
  *
@@ -408,31 +468,20 @@
 
 	dev_count = 0;
 
-	if (ircc_fir > 0 && ircc_sir > 0) {
-		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
-		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
-
-		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
-			ret = -ENODEV;
+	if (smsc_nopnp || !pnp_platform_devices ||
+	    ircc_cfg || ircc_fir || ircc_sir ||
+	    ircc_dma != DMA_INVAL || ircc_irq != IRQ_INVAL) {
+		ret = smsc_ircc_legacy_probe();
 	} else {
-		ret = -ENODEV;
-
-		/* try user provided configuration register base address */
-		if (ircc_cfg > 0) {
-			IRDA_MESSAGE(" Overriding configuration address "
-				     "0x%04x\n", ircc_cfg);
-			if (!smsc_superio_fdc(ircc_cfg))
-				ret = 0;
-			if (!smsc_superio_lpc(ircc_cfg))
-				ret = 0;
-		}
-
-		if (smsc_ircc_look_for_chips() > 0)
-			ret = 0;
+		if (pnp_register_driver(&smsc_ircc_pnp_driver) == 0)
+			pnp_driver_registered = 1;
 	}
 
-	if (ret)
+	if (ret) {
+		if (pnp_driver_registered)
+			pnp_unregister_driver(&smsc_ircc_pnp_driver);
 		platform_driver_unregister(&smsc_ircc_driver);
+	}
 
 	return ret;
 }
@@ -1842,6 +1891,9 @@
 			smsc_ircc_close(dev_self[i]);
 	}
 
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&smsc_ircc_pnp_driver);
+
 	platform_driver_unregister(&smsc_ircc_driver);
 }
 
Index: w/Documentation/kernel-parameters.txt
===================================================================
--- w.orig/Documentation/kernel-parameters.txt	2007-04-05 11:56:34.000000000 -0600
+++ w/Documentation/kernel-parameters.txt	2007-04-05 12:07:53.000000000 -0600
@@ -1557,6 +1557,17 @@
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
+	smsc-ircc2.nopnp	[HW] Don't use PNP to discover SMC devices
+	smsc-ircc2.ircc_cfg=	[HW] Device configuration I/O port
+	smsc-ircc2.ircc_sir=	[HW] SIR base I/O port
+	smsc-ircc2.ircc_fir=	[HW] FIR base I/O port
+	smsc-ircc2.ircc_irq=	[HW] IRQ line
+	smsc-ircc2.ircc_dma=	[HW] DMA channel
+	smsc-ircc2.ircc_transceiver= [HW] Transceiver type:
+				0: Toshiba Satellite 1800 (GP data pin select)
+				1: Fast pin select (default)
+				2: ATC IRMode
+
 	snd-ad1816a=	[HW,ALSA]
 
 	snd-ad1848=	[HW,ALSA]
