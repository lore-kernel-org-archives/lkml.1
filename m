Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYF1Vof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYF1Vof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYF1Vmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 17:42:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYF1Vmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 17:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MWsx9/OxJHS7aHwSu4PM9V8sgZcbrM1PPcs6kzQ2YzCNO+pNLtPrxEA6ZDh68fUB1R
         CNqfNkNppa0Bqbv9If+Kay9CIjyf+2QhRTgc2hfC5nUyDDWcpUwabuQnPvkA1xpyd7Pj
         ZEIQQo7l9uc4BAk6mKf7FDvKM5JENz3RsqdWw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 28 Jun 2008 23:44:45 +0200
Message-Id: <20080628214445.21345.36769.sendpatchset@localhost.localdomain>
In-Reply-To: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
References: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/7] ide: add ide_host_free() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_host_free() helper and convert ide_host_remove() to use it.

* Fix handling of ide_host_register() failure in ide_host_add(),
  icside.c, ide-generic.c, falconide.c and sgiioc4.c.

While at it:

* Fix handling of ide_host_alloc_all() failure in ide-generic.c.

* Fix handling of ide_host_alloc() failure in falconide.c
  (also return the correct error value if no device is found).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |   21 +++++++++++++++++----
 drivers/ide/ide-generic.c      |   27 +++++++++++++++++++++++----
 drivers/ide/ide-probe.c        |   23 ++++++++++++++++++++---
 drivers/ide/legacy/falconide.c |   22 +++++++++++++++++-----
 drivers/ide/pci/sgiioc4.c      |   14 ++++++++++----
 include/linux/ide.h            |    1 +
 6 files changed, 88 insertions(+), 20 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -445,6 +445,7 @@ icside_register_v5(struct icside_state *
 	void __iomem *base;
 	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	int ret;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -472,9 +473,15 @@ icside_register_v5(struct icside_state *
 
 	ecard_set_drvdata(ec, state);
 
-	ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, NULL, hws);
+	if (ret)
+		goto err_free;
 
 	return 0;
+err_free:
+	ide_host_free(host);
+	ecard_set_drvdata(ec, NULL);
+	return ret;
 }
 
 static const struct ide_port_info icside_v6_port_info __initdata = {
@@ -547,11 +554,17 @@ icside_register_v6(struct icside_state *
 		d.dma_ops = NULL;
 	}
 
-	ide_host_register(host, &d, hws);
+	ret = ide_host_register(host, NULL, hws);
+	if (ret)
+		goto err_free;
 
 	return 0;
-
- out:
+err_free:
+	ide_host_free(host);
+	if (d.dma_ops)
+		free_dma(ec->dma);
+	ecard_set_drvdata(ec, NULL);
+out:
 	return ret;
 }
 
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -84,13 +84,14 @@ static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
 	struct ide_host *host;
-	int i;
+	unsigned long io_addr;
+	int i, rc;
 
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		unsigned long io_addr = ide_default_io_base(i);
+		io_addr = ide_default_io_base(i);
 
 		hws[i] = NULL;
 
@@ -120,14 +121,32 @@ static int __init ide_generic_init(void)
 	}
 
 	host = ide_host_alloc_all(NULL, hws);
-	if (host)
-		ide_host_register(host, NULL, hws);
+	if (host == NULL) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = ide_host_register(host, NULL, hws);
+	if (rc)
+		goto err_free;
 
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
 					 "class\n");
 
 	return 0;
+err_free:
+	ide_host_free(host);
+err:
+	for (i = 0; i < MAX_HWIFS; i++) {
+		if (hws[i] == NULL)
+			continue;
+
+		io_addr = hws[i]->io_ports.data_addr;
+		release_region(io_addr + 0x206, 1);
+		release_region(io_addr, 8);
+	}
+	return rc;
 }
 
 module_init(ide_generic_init);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1735,12 +1735,17 @@ int ide_host_add(const struct ide_port_i
 		 struct ide_host **hostp)
 {
 	struct ide_host *host;
+	int rc;
 
 	host = ide_host_alloc(d, hws);
 	if (host == NULL)
 		return -ENOMEM;
 
-	ide_host_register(host, d, hws);
+	rc = ide_host_register(host, d, hws);
+	if (rc) {
+		ide_host_free(host);
+		return rc;
+	}
 
 	if (hostp)
 		*hostp = host;
@@ -1749,7 +1754,7 @@ int ide_host_add(const struct ide_port_i
 }
 EXPORT_SYMBOL_GPL(ide_host_add);
 
-void ide_host_remove(struct ide_host *host)
+void ide_host_free(struct ide_host *host)
 {
 	ide_hwif_t *hwif;
 	int i;
@@ -1760,13 +1765,25 @@ void ide_host_remove(struct ide_host *ho
 		if (hwif == NULL)
 			continue;
 
-		ide_unregister(hwif);
 		ide_free_port_slot(hwif->index);
 		kfree(hwif);
 	}
 
 	kfree(host);
 }
+EXPORT_SYMBOL_GPL(ide_host_free);
+
+void ide_host_remove(struct ide_host *host)
+{
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		if (host->ports[i])
+			ide_unregister(host->ports[i]);
+	}
+
+	ide_host_free(host);
+}
 EXPORT_SYMBOL_GPL(ide_host_remove);
 
 void ide_port_scan(ide_hwif_t *hwif)
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -114,9 +114,10 @@ static int __init falconide_init(void)
 {
 	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
+	int rc;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
-		return 0;
+		return -NODEV;
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
@@ -128,13 +129,24 @@ static int __init falconide_init(void)
 	falconide_setup_ports(&hw);
 
 	host = ide_host_alloc(&falconide_port_info, hws);
-	if (host) {
-		ide_get_lock(NULL, NULL);
-		ide_host_register(host, &falconide_port_info, hws);
-		ide_release_lock();
+	if (host == NULL) {
+		rc = -ENOMEM;
+		goto err;
 	}
 
+	ide_get_lock(NULL, NULL);
+	rc = ide_host_register(host, &falconide_port_info, hws);
+	ide_release_lock();
+
+	if (rc)
+		goto err_free;
+
 	return 0;
+err_free:
+	ide_host_free(host);
+err:
+	release_mem_region(ATA_HD_BASE, 0x40);
+	return rc;
 }
 
 module_init(falconide_init);
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -603,6 +603,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	struct ide_port_info d = sgiioc4_port_info;
+	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
@@ -638,17 +639,22 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
 	host = ide_host_alloc(&d, hws);
-	if (host == NULL)
+	if (host == NULL) {
+		rc = -ENOMEM;
 		goto err;
+	}
 
-	if (ide_host_register(host, &d, hws))
-		return -EIO;
+	rc = ide_host_register(host, &d, hws);
+	if (rc)
+		goto err_free;
 
 	return 0;
+err_free:
+	ide_host_free(host);
 err:
 	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
 	iounmap(virt_base);
-	return -ENOMEM;
+	return rc;
 }
 
 static unsigned int __devinit
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1221,6 +1221,7 @@ void ide_port_apply_params(ide_hwif_t *)
 
 struct ide_host *ide_host_alloc_all(const struct ide_port_info *, hw_regs_t **);
 struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
+void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
 		      hw_regs_t **);
 int ide_host_add(const struct ide_port_info *, hw_regs_t **,
