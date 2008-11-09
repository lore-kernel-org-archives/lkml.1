Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYKIQ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYKIQ2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYKIQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:25:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYKIQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=f76K3xuC+MsByQKMeSJ/5+a1MatsbUOyQarR9eiR2JGMss4tP9fdSc8k+8OIAuSmLu
         X2TxDTirkUX3zF8WMP/qvUuWATDpEInAKwJeH6Yav5gAT9zufvVNmi2wTpa2rTb1Qj4t
         JE+nXacHJLz+UKWRAbkAR0+jAHlSzWdVhiL1U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:23:17 +0100
Message-Id: <20081109162317.18999.68185.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/11] ide: move legacy ISA/VLB ports handling to ide-legacy.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move legacy ISA/VLB ports handling to ide-legacy.c

* Move legacy ISA/VLB ports handling from ide-probe.c to ide-legacy.c.

* Add CONFIG_IDE_LEGACY config option to be selected by host drivers
  needing ide-legacy.c.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig      |    5 ++++
 drivers/ide/Makefile     |    1 
 drivers/ide/ide-legacy.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-probe.c  |   56 ---------------------------------------------
 4 files changed, 64 insertions(+), 56 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -864,6 +864,7 @@ config BLK_DEV_4DRIVES
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
 	select IDE_TIMINGS
+	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "ali14xx.probe" kernel
 	  boot parameter.  It enables support for the secondary IDE interface
@@ -874,6 +875,7 @@ config BLK_DEV_ALI14XX
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
+	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "dtc2278.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
@@ -884,6 +886,7 @@ config BLK_DEV_DTC2278
 config BLK_DEV_HT6560B
 	tristate "Holtek HT6560B support"
 	select IDE_TIMINGS
+	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "ht6560b.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
@@ -894,6 +897,7 @@ config BLK_DEV_HT6560B
 config BLK_DEV_QD65XX
 	tristate "QDI QD65xx support"
 	select IDE_TIMINGS
+	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
@@ -902,6 +906,7 @@ config BLK_DEV_QD65XX
 
 config BLK_DEV_UMC8672
 	tristate "UMC-8672 support"
+	select IDE_LEGACY
 	help
 	  This driver is enabled at runtime using the "umc8672.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -15,6 +15,7 @@ ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide
 ide-core-$(CONFIG_BLK_DEV_IDEDMA_SFF)	+= ide-dma-sff.o
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
+ide-core-$(CONFIG_IDE_LEGACY)		+= ide-legacy.o
 
 obj-$(CONFIG_IDE)			+= ide-core.o
 
Index: b/drivers/ide/ide-legacy.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-legacy.c
@@ -0,0 +1,58 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
+				u8 port_no, const struct ide_port_info *d,
+				unsigned long config)
+{
+	unsigned long base, ctl;
+	int irq;
+
+	if (port_no == 0) {
+		base = 0x1f0;
+		ctl  = 0x3f6;
+		irq  = 14;
+	} else {
+		base = 0x170;
+		ctl  = 0x376;
+		irq  = 15;
+	}
+
+	if (!request_region(base, 8, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				d->name, base, base + 7);
+		return;
+	}
+
+	if (!request_region(ctl, 1, d->name)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				d->name, ctl);
+		release_region(base, 8);
+		return;
+	}
+
+	ide_std_init_ports(hw, base, ctl);
+	hw->irq = irq;
+	hw->chipset = d->chipset;
+	hw->config = config;
+
+	hws[port_no] = hw;
+}
+
+int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
+{
+	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
+
+	memset(&hw, 0, sizeof(hw));
+
+	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
+		ide_legacy_init_one(hws, &hw[0], 0, d, config);
+	ide_legacy_init_one(hws, &hw[1], 1, d, config);
+
+	if (hws[0] == NULL && hws[1] == NULL &&
+	    (d->host_flags & IDE_HFLAG_SINGLE))
+		return -ENOENT;
+
+	return ide_host_add(d, hws, NULL);
+}
+EXPORT_SYMBOL_GPL(ide_legacy_device_add);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1754,59 +1754,3 @@ void ide_port_scan(ide_hwif_t *hwif)
 	ide_proc_port_register_devices(hwif);
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
-
-static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
-				u8 port_no, const struct ide_port_info *d,
-				unsigned long config)
-{
-	unsigned long base, ctl;
-	int irq;
-
-	if (port_no == 0) {
-		base = 0x1f0;
-		ctl  = 0x3f6;
-		irq  = 14;
-	} else {
-		base = 0x170;
-		ctl  = 0x376;
-		irq  = 15;
-	}
-
-	if (!request_region(base, 8, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				d->name, base, base + 7);
-		return;
-	}
-
-	if (!request_region(ctl, 1, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				d->name, ctl);
-		release_region(base, 8);
-		return;
-	}
-
-	ide_std_init_ports(hw, base, ctl);
-	hw->irq = irq;
-	hw->chipset = d->chipset;
-	hw->config = config;
-
-	hws[port_no] = hw;
-}
-
-int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
-{
-	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
-
-	memset(&hw, 0, sizeof(hw));
-
-	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
-		ide_legacy_init_one(hws, &hw[0], 0, d, config);
-	ide_legacy_init_one(hws, &hw[1], 1, d, config);
-
-	if (hws[0] == NULL && hws[1] == NULL &&
-	    (d->host_flags & IDE_HFLAG_SINGLE))
-		return -ENOENT;
-
-	return ide_host_add(d, hws, NULL);
-}
-EXPORT_SYMBOL_GPL(ide_legacy_device_add);
