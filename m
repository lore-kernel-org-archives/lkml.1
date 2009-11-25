Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZKYRJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZKYRJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932935AbZKYRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:09:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbZKYRJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IdF/743H2nhtKSc4T0OkdIeBR4wUI7O/bTKGxnHFvqsQG1ESDznUuIVSyIo2C8+64w
         WY3PgNyB4ImT628nXo+aSGb5C6U/FjgPsyjEq3lVrqgxQ1CM42iDECkODKXtORMenKeN
         s1uEyC/mXJgufgfW2qk3R6/7n9ef2BAU8PR0M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:08:33 +0100
Message-Id: <20091125170833.5446.48138.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 52/86] libata: remove no longer needed pata_winbond driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: remove no longer needed pata_winbond driver

Winbond W83759A controller is fully supported by pata_legacy driver
so remove no longer needed pata_winbond driver.

Leave PATA_WINBOND_VLB config option for compatibility reasons
and teach pata_legacy to preserve the old behavior of pata_winbond
driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig        |    1 
 drivers/ata/Makefile       |    1 
 drivers/ata/pata_legacy.c  |   13 +-
 drivers/ata/pata_winbond.c |  282 ---------------------------------------------
 4 files changed, 12 insertions(+), 285 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -695,6 +695,7 @@ config PATA_WINBOND
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select PATA_LEGACY
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -64,7 +64,6 @@ obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_s
 obj-$(CONFIG_PATA_SIL680)	+= pata_sil680.o
 obj-$(CONFIG_PATA_VIA)		+= pata_via.o
 obj-$(CONFIG_PATA_WINBOND)	+= pata_sl82c105.o
-obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
 obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
Index: b/drivers/ata/pata_legacy.c
===================================================================
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -44,6 +44,9 @@
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
  *  opti82c465mv/promise 20230c/20630/qdi65x0/winbond83759A
  *
+ *  Support for the Winbond 83759A when operating in advanced mode.
+ *  Multichip mode is not currently supported.
+ *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
  *  Use the jumpers, autospeed and set pio_mask to the mode on the jumpers with
@@ -139,8 +142,12 @@ static int qdi = 1;
 #else
 static int qdi;
 #endif
-static int winbond;		/* Set to probe Winbond controllers,
-					give I/O port if non standard */
+/* Set to probe Winbond controllers, give I/O port if non standard */
+#ifdef PATA_WINBOND_VLB_MODULE
+static int winbond = 1;
+#else
+static int winbond;
+#endif
 static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = ATA_PIO4;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
@@ -1251,6 +1258,7 @@ MODULE_DESCRIPTION("low-level driver for
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("pata_qdi");
+MODULE_ALIAS("pata_winbond");
 
 module_param(probe_all, int, 0);
 module_param(autospeed, int, 0);
@@ -1260,6 +1268,7 @@ module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
 module_param(qdi, int, 0);
 module_param_named(probe_qdi, qdi, int, 0);
+module_param_named(probe_winbond, winbond, int, 0);
 module_param(pio_mask, int, 0);
 module_param(iordy_mask, int, 0);
 
Index: b/drivers/ata/pata_winbond.c
===================================================================
--- a/drivers/ata/pata_winbond.c
+++ /dev/null
@@ -1,282 +0,0 @@
-/*
- *    pata_winbond.c - Winbond VLB ATA controllers
- *	(C) 2006 Red Hat
- *
- *    Support for the Winbond 83759A when operating in advanced mode.
- *    Multichip mode is not currently supported.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <scsi/scsi_host.h>
-#include <linux/libata.h>
-#include <linux/platform_device.h>
-
-#define DRV_NAME "pata_winbond"
-#define DRV_VERSION "0.0.3"
-
-#define NR_HOST 4	/* Two winbond controllers, two channels each */
-
-struct winbond_data {
-	unsigned long config;
-	struct platform_device *platform_dev;
-};
-
-static struct ata_host *winbond_host[NR_HOST];
-static struct winbond_data winbond_data[NR_HOST];
-static int nr_winbond_host;
-
-#ifdef MODULE
-static int probe_winbond = 1;
-#else
-static int probe_winbond;
-#endif
-
-static DEFINE_SPINLOCK(winbond_lock);
-
-static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&winbond_lock, flags);
-	outb(reg, port + 0x01);
-	outb(val, port + 0x02);
-	spin_unlock_irqrestore(&winbond_lock, flags);
-}
-
-static u8 winbond_readcfg(unsigned long port, u8 reg)
-{
-	u8 val;
-
-	unsigned long flags;
-	spin_lock_irqsave(&winbond_lock, flags);
-	outb(reg, port + 0x01);
-	val = inb(port + 0x02);
-	spin_unlock_irqrestore(&winbond_lock, flags);
-
-	return val;
-}
-
-static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct ata_timing t;
-	struct winbond_data *winbond = ap->host->private_data;
-	int active, recovery;
-	u8 reg;
-	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
-
-	reg = winbond_readcfg(winbond->config, 0x81);
-
-	/* Get the timing data in cycles */
-	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
-		ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
-	else
-		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
-
-	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
-	timing = (active << 4) | recovery;
-	winbond_writecfg(winbond->config, timing, reg);
-
-	/* Load the setup timing */
-
-	reg = 0x35;
-	if (adev->class != ATA_DEV_ATA)
-		reg |= 0x08;	/* FIFO off */
-	if (!ata_pio_need_iordy(adev))
-		reg |= 0x02;	/* IORDY off */
-	reg |= (clamp_val(t.setup, 0, 3) << 6);
-	winbond_writecfg(winbond->config, timing + 1, reg);
-}
-
-
-static unsigned int winbond_data_xfer(struct ata_device *dev,
-			unsigned char *buf, unsigned int buflen, int rw)
-{
-	struct ata_port *ap = dev->link->ap;
-	int slop = buflen & 3;
-
-	if (ata_id_has_dword_io(dev->id)) {
-		if (rw == READ)
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == READ) {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			} else {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			}
-			buflen += 4 - slop;
-		}
-	} else
-		buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
-
-	return buflen;
-}
-
-static struct scsi_host_template winbond_sht = {
-	ATA_PIO_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations winbond_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= winbond_data_xfer,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= winbond_set_piomode,
-};
-
-/**
- *	winbond_init_one		-	attach a winbond interface
- *	@type: Type to display
- *	@io: I/O port start
- *	@irq: interrupt line
- *	@fast: True if on a > 33Mhz VLB
- *
- *	Register a VLB bus IDE interface. Such interfaces are PIO and we
- *	assume do not support IRQ sharing.
- */
-
-static __init int winbond_init_one(unsigned long port)
-{
-	struct platform_device *pdev;
-	u8 reg;
-	int i, rc;
-
-	reg = winbond_readcfg(port, 0x81);
-	reg |= 0x80;	/* jumpered mode off */
-	winbond_writecfg(port, 0x81, reg);
-	reg = winbond_readcfg(port, 0x83);
-	reg |= 0xF0;	/* local control */
-	winbond_writecfg(port, 0x83, reg);
-	reg = winbond_readcfg(port, 0x85);
-	reg |= 0xF0;	/* programmable timing */
-	winbond_writecfg(port, 0x85, reg);
-
-	reg = winbond_readcfg(port, 0x81);
-
-	if (!(reg & 0x03))		/* Disabled */
-		return -ENODEV;
-
-	for (i = 0; i < 2 ; i ++) {
-		unsigned long cmd_port = 0x1F0 - (0x80 * i);
-		unsigned long ctl_port = cmd_port + 0x206;
-		struct ata_host *host;
-		struct ata_port *ap;
-		void __iomem *cmd_addr, *ctl_addr;
-
-		if (!(reg & (1 << i)))
-			continue;
-
-		pdev = platform_device_register_simple(DRV_NAME, nr_winbond_host, NULL, 0);
-		if (IS_ERR(pdev))
-			return PTR_ERR(pdev);
-
-		rc = -ENOMEM;
-		host = ata_host_alloc(&pdev->dev, 1);
-		if (!host)
-			goto err_unregister;
-		ap = host->ports[0];
-
-		rc = -ENOMEM;
-		cmd_addr = devm_ioport_map(&pdev->dev, cmd_port, 8);
-		ctl_addr = devm_ioport_map(&pdev->dev, ctl_port, 1);
-		if (!cmd_addr || !ctl_addr)
-			goto err_unregister;
-
-		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", cmd_port, ctl_port);
-
-		ap->ops = &winbond_port_ops;
-		ap->pio_mask = ATA_PIO4;
-		ap->flags |= ATA_FLAG_SLAVE_POSS;
-		ap->ioaddr.cmd_addr = cmd_addr;
-		ap->ioaddr.altstatus_addr = ctl_addr;
-		ap->ioaddr.ctl_addr = ctl_addr;
-		ata_sff_std_ports(&ap->ioaddr);
-
-		/* hook in a private data structure per channel */
-		host->private_data = &winbond_data[nr_winbond_host];
-		winbond_data[nr_winbond_host].config = port;
-		winbond_data[nr_winbond_host].platform_dev = pdev;
-
-		/* activate */
-		rc = ata_host_activate(host, 14 + i, ata_sff_interrupt, 0,
-				       &winbond_sht);
-		if (rc)
-			goto err_unregister;
-
-		winbond_host[nr_winbond_host++] = dev_get_drvdata(&pdev->dev);
-	}
-
-	return 0;
-
- err_unregister:
-	platform_device_unregister(pdev);
-	return rc;
-}
-
-/**
- *	winbond_init		-	attach winbond interfaces
- *
- *	Attach winbond IDE interfaces by scanning the ports it may occupy.
- */
-
-static __init int winbond_init(void)
-{
-	static const unsigned long config[2] = { 0x130, 0x1B0 };
-
-	int ct = 0;
-	int i;
-
-	if (probe_winbond == 0)
-		return -ENODEV;
-
-	/*
- 	 *	Check both base addresses
-	 */
-
-	for (i = 0; i < 2; i++) {
-		if (probe_winbond & (1<<i)) {
-			int ret = 0;
-			unsigned long port = config[i];
-
-			if (request_region(port, 2, "pata_winbond")) {
-				ret = winbond_init_one(port);
-				if (ret <= 0)
-					release_region(port, 2);
-				else ct+= ret;
-			}
-		}
-	}
-	if (ct != 0)
-		return 0;
-	return -ENODEV;
-}
-
-static __exit void winbond_exit(void)
-{
-	int i;
-
-	for (i = 0; i < nr_winbond_host; i++) {
-		ata_host_detach(winbond_host[i]);
-		release_region(winbond_data[i].config, 2);
-		platform_device_unregister(winbond_data[i].platform_dev);
-	}
-}
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for Winbond VL ATA");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
-module_init(winbond_init);
-module_exit(winbond_exit);
-
-module_param(probe_winbond, int, 0);
-
