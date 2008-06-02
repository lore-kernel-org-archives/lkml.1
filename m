Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYFBUWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYFBUWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYFBUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYFBUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VFZNlopeoIbJ9/7S+0GJot+XW0ooiGUN1h2qJ2XM30pASjrUKAUClfsEDB2n6fq6WfiDLIaPxU2hwyS47mbd1sVrUoWr62uokwooqS9R+R+M4fpFaVI0TGoxNAGgeWv64hwZ0mKQiU7LfupsIzzoepj0YiESe5lcwkk8JrgWtGM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:01 +0200
Message-Id: <20080602202301.7265.71596.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: set hwif->dev in ide_init_port_hw()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'parent' field to hw_regs_t for optional parent device pointer (needed
  by macio PMAC IDE controllers) and set hwif->dev in ide_init_port_hw().

* Update au1xxx-ide.c, sgiioc4.c, pmac.c and setup-pci.c accordingly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c             |    3 ++-
 drivers/ide/mips/au1xxx-ide.c |    2 --
 drivers/ide/pci/sgiioc4.c     |    2 --
 drivers/ide/ppc/pmac.c        |    6 ++----
 drivers/ide/setup-pci.c       |    2 --
 include/linux/ide.h           |    2 +-
 6 files changed, 5 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -297,7 +297,8 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
 	hwif->chipset = hw->chipset;
-	hwif->gendev.parent = hw->dev;
+	hwif->dev = hw->dev;
+	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -600,8 +600,6 @@ static int au_ide_probe(struct device *d
 
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = dev;
-
 	/* If the user has selected DDMA assisted copies,
 	   then set up a few local I/O function entry points 
 	*/
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -625,8 +625,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw.dev = &dev->dev;
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = &dev->dev;
-
 	/* The IOC4 uses MMIO rather than Port IO. */
 	default_hwif_mmiops(hwif);
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1144,8 +1144,6 @@ pmac_ide_macio_attach(struct macio_dev *
 	base = ioremap(macio_resource_start(mdev, 0), 0x400);
 	regbase = (unsigned long) base;
 
-	hwif->dev = &mdev->bus->pdev->dev;
-
 	pmif->mdev = mdev;
 	pmif->node = mdev->ofdev.node;
 	pmif->regbase = regbase;
@@ -1167,7 +1165,8 @@ pmac_ide_macio_attach(struct macio_dev *
 	memset(&hw, 0, sizeof(hw));
 	pmac_ide_init_ports(&hw, pmif->regbase);
 	hw.irq = irq;
-	hw.dev = &mdev->ofdev.dev;
+	hw.dev = &mdev->bus->pdev->dev;
+	hw.parent = &mdev->ofdev.dev;
 
 	rc = pmac_ide_setup_device(pmif, hwif, &hw);
 	if (rc != 0) {
@@ -1267,7 +1266,6 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 		goto out_free_pmif;
 	}
 
-	hwif->dev = &pdev->dev;
 	pmif->mdev = NULL;
 	pmif->node = np;
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -346,8 +346,6 @@ static ide_hwif_t *ide_hwif_configure(st
 
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->dev = &dev->dev;
-
 	return hwif;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -171,7 +171,7 @@ typedef struct hw_regs_s {
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
 	hwif_chipset_t  chipset;
-	struct device	*dev;
+	struct device	*dev, *parent;
 } hw_regs_t;
 
 void ide_init_port_data(struct hwif_s *, unsigned int);
