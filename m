Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYFJUwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYFJUwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYFJUu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:28 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30333 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbYFJUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ljaCHBgSL6xvRvPT8pMLxqB22OcFPe3w6pfbVOjbeP2GdY5sYX+YCQaverzixiFPQC
         MsNCkCEk2QEynH3aKXF8v0uPb19Pn9d841duMoQNhLlU/ZLSXWlW1WaXmHtVbSSFE0LI
         JB9Wt3QctSScTADkLSWujp54hfqRVPzqk5aio=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:51:59 +0200
Message-Id: <20080610205159.18469.72812.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/14] ide: print message on error in ide_find_port_slot()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add DRV_NAME define to ide-h8300.c.

* Fix ide-h8300.c, swarm.c and sgiioc4.c to set .name field in
  struct ide_port_info to DRV_NAME, then convert these host drivers
  to use ide_find_port_slot() instead of ide_find_port().

* Print message on error in ide_find_port_slot().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    8 ++++----
 drivers/ide/ide-probe.c       |    3 +++
 drivers/ide/mips/swarm.c      |    7 +++----
 drivers/ide/pci/scc_pata.c    |    7 ++-----
 drivers/ide/pci/sgiioc4.c     |    8 +++-----
 drivers/ide/setup-pci.c       |    5 +----
 6 files changed, 16 insertions(+), 22 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -8,6 +8,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_NAME "ide-h8300"
+
 #define bswap(d) \
 ({					\
 	u16 r;				\
@@ -196,11 +198,9 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
+	hwif = ide_find_port_slot(&h8300_port_info);
+	if (hwif == NULL)
 		return -ENOENT;
-	}
 
 	index = hwif->index;
 	ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1496,6 +1496,9 @@ ide_hwif_t *ide_find_port_slot(const str
 		}
 	}
 
+	printk(KERN_ERR "%s: no free slot for interface\n",
+			d ? d->name : "ide");
+
 	return NULL;
 
 out_found:
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -62,6 +62,7 @@ static struct resource swarm_ide_resourc
 static struct platform_device *swarm_ide_dev;
 
 static const struct ide_port_info swarm_port_info = {
+	.name			= DRV_NAME,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 };
 
@@ -81,11 +82,9 @@ static int __devinit swarm_ide_probe(str
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR DRV_NAME ": no free slot for interface\n");
+	hwif = ide_find_port_slot(&swarm_port_info);
+	if (hwif == NULL)
 		return -ENOMEM;
-	}
 
 	base = ioremap(A_IO_EXT_BASE, 0x800);
 	offset = __raw_readq(base + R_IO_EXT_REG(R_IO_EXT_START_ADDR, IDE_CS));
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -558,12 +558,9 @@ static int scc_ide_setup_pci_device(stru
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, "
-				"no room in table\n", SCC_PATA_NAME);
+	hwif = ide_find_port_slot(d);
+	if (hwif == NULL)
 		return -ENOMEM;
-	}
 
 	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i <= 8; i++)
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -568,6 +568,7 @@ static const struct ide_dma_ops sgiioc4_
 };
 
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
+	.name			= DRV_NAME,
 	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
@@ -587,12 +588,9 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n",
-				DRV_NAME);
+	hwif = ide_find_port_slot(&d);
+	if (hwif == NULL)
 		return -ENOMEM;
-	}
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -332,11 +332,8 @@ static ide_hwif_t *ide_hwif_configure(st
 	}
 
 	hwif = ide_find_port_slot(d);
-	if (hwif == NULL) {
-		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
-				"table\n", d->name);
+	if (hwif == NULL)
 		return NULL;
-	}
 
 	memset(&hw, 0, sizeof(hw));
 	hw.irq = irq;
