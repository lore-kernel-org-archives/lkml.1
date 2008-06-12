Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYFLXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYFLXL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbYFLXK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:10:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:25204 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbYFLXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oaWuXL8m2CfDis6L8IudTYyVu8LOxv0mgUVuZ35lRPemePpoHd3JqJEDrYDCdUeYxr
         Wy3yDQWNQUvwZVRv2ieTkTjjh21jZkXfhliKBfMIxUeg4i15EpXxWcZpHoKPIVd1VjKT
         97nm3WQea8h2YolABxJ125qZull8I60WJgAZo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2008 01:12:34 +0200
Message-Id: <20080612231234.18335.85898.sendpatchset@localhost.localdomain>
In-Reply-To: <20080612231224.18335.91182.sendpatchset@localhost.localdomain>
References: <20080612231224.18335.91182.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/7] ide-pmac: add ->cable_detect method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->cable_detect method and remove no longer needed pmif->cable_80 flag
(there is also no need to mask ->udma_mask now).

This fixes:

- forced ignoring of cable detection (needed for some CF devices & debug)

- cable detection for warm-plug

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   55 +++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -57,7 +57,6 @@ typedef struct pmac_ide_hwif {
 	int				irq;
 	int				kind;
 	int				aapl_bus_id;
-	unsigned			cable_80 : 1;
 	unsigned			mediabay : 1;
 	unsigned			broken_dma : 1;
 	unsigned			broken_dma_warn : 1;
@@ -915,10 +914,40 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 	return 0;
 }
 
+static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
+{
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)ide_get_hwifdata(hwif);
+	struct device_node *np = pmif->node;
+	const char *cable = of_get_property(np, "cable-type", NULL);
+
+	/* Get cable type from device-tree. */
+	if (cable && !strncmp(cable, "80-", 3))
+		return ATA_CBL_PATA80;
+
+	/*
+	 * G5's seem to have incorrect cable type in device-tree.
+	 * Let's assume they have a 80 conductor cable, this seem
+	 * to be always the case unless the user mucked around.
+	 */
+	if (of_device_is_compatible(np, "K2-UATA") ||
+	    of_device_is_compatible(np, "shasta-ata"))
+		return ATA_CBL_PATA80;
+
+	return ATA_CBL_PATA40;
+}
+
 static const struct ide_port_ops pmac_ide_ata6_port_ops = {
 	.set_pio_mode		= pmac_ide_set_pio_mode,
 	.set_dma_mode		= pmac_ide_set_dma_mode,
 	.selectproc		= pmac_ide_kauai_selectproc,
+	.cable_detect		= pmac_ide_cable_detect,
+};
+
+static const struct ide_port_ops pmac_ide_ata4_port_ops = {
+	.set_pio_mode		= pmac_ide_set_pio_mode,
+	.set_dma_mode		= pmac_ide_set_dma_mode,
+	.selectproc		= pmac_ide_selectproc,
+	.cable_detect		= pmac_ide_cable_detect,
 };
 
 static const struct ide_port_ops pmac_ide_port_ops = {
@@ -959,7 +988,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = pmac_port_info;
 
-	pmif->cable_80 = 0;
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
@@ -976,6 +1004,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	} else if (of_device_is_compatible(np, "keylargo-ata")) {
 		if (strcmp(np->name, "ata-4") == 0) {
 			pmif->kind = controller_kl_ata4;
+			d.port_ops = &pmac_ide_ata4_port_ops;
 			d.udma_mask = ATA_UDMA4;
 		} else
 			pmif->kind = controller_kl_ata3;
@@ -989,22 +1018,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	bidp = of_get_property(np, "AAPL,bus-id", NULL);
 	pmif->aapl_bus_id =  bidp ? *bidp : 0;
 
-	/* Get cable type from device-tree */
-	if (pmif->kind == controller_kl_ata4 || pmif->kind == controller_un_ata6
-	    || pmif->kind == controller_k2_ata6
-	    || pmif->kind == controller_sh_ata6) {
-		const char* cable = of_get_property(np, "cable-type", NULL);
-		if (cable && !strncmp(cable, "80-", 3))
-			pmif->cable_80 = 1;
-	}
-	/* G5's seem to have incorrect cable type in device-tree. Let's assume
-	 * they have a 80 conductor cable, this seem to be always the case unless
-	 * the user mucked around
-	 */
-	if (of_device_is_compatible(np, "K2-UATA") ||
-	    of_device_is_compatible(np, "shasta-ata"))
-		pmif->cable_80 = 1;
-
 	/* On Kauai-type controllers, we make sure the FCR is correct */
 	if (pmif->kauai_fcr)
 		writel(KAUAI_FCR_UATA_MAGIC |
@@ -1050,7 +1063,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
-	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
@@ -1067,11 +1079,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 		}
 	}
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
-	if (pmif->cable_80 == 0)
-		d.udma_mask &= ATA_UDMA2;
-#endif
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
