Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYKCUGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYKCUGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYKCUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:05:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:36760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYKCUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kGiELAX6/RP0EX5KWPs9SniDg1j/mAVQ4byYFl77kC0fT18cHSnqI+iBnlE25poXDT
         CcLyV950RpbQK8/B7++4KsjJJvUZ/PzxpgJ9IUlw7UnrtAx6NiYckYwNyJ+mx/RYZL7a
         q2RkmYj8O8Sy73q3n2qwLU7zIV8nPausCzPvk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 03 Nov 2008 21:03:06 +0100
Message-Id: <20081103200306.5098.41565.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] rz1000: apply chipset quirks early
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rz1000: apply chipset quirks early

* Use pci_name(dev) instead of hwif->name in init_hwif_rz1000().

* init_hwif_rz1000() -> rz1000_init_chipset().  Update rz1000_init_one()
  to use rz1000_init_chipset() and add now required rz1000_remove().

* Remove superfluous ide_rz1000 chipset type.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-proc.c |    1 -
 drivers/ide/rz1000.c   |   36 +++++++++++++++++++++++++-----------
 include/linux/ide.h    |    3 +--
 3 files changed, 26 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -46,7 +46,6 @@ static int proc_ide_read_imodel
 	case ide_qd65xx:	name = "qd65xx";	break;
 	case ide_umc8672:	name = "umc8672";	break;
 	case ide_ht6560b:	name = "ht6560b";	break;
-	case ide_rz1000:	name = "rz1000";	break;
 	case ide_trm290:	name = "trm290";	break;
 	case ide_cy82c693:	name = "cy82c693";	break;
 	case ide_4drives:	name = "4drives";	break;
Index: b/drivers/ide/rz1000.c
===================================================================
--- a/drivers/ide/rz1000.c
+++ b/drivers/ide/rz1000.c
@@ -22,34 +22,48 @@
 
 #define DRV_NAME "rz1000"
 
-static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
+static unsigned int __devinit rz1000_init_chipset(struct pci_dev *dev)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 reg;
 
 	if (!pci_read_config_word (dev, 0x40, &reg) &&
 	    !pci_write_config_word(dev, 0x40, reg & 0xdfff)) {
 		printk(KERN_INFO "%s: disabled chipset read-ahead "
-			"(buggy RZ1000/RZ1001)\n", hwif->name);
+			"(buggy RZ1000/RZ1001)\n", pci_name(dev));
+		return 0;
 	} else {
-		if (hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-		hwif->host_flags |= IDE_HFLAG_NO_UNMASK_IRQS;
 		printk(KERN_INFO "%s: serialized, disabled unmasking "
-			"(buggy RZ1000/RZ1001)\n", hwif->name);
+			"(buggy RZ1000/RZ1001)\n", pci_name(dev));
+		return 1;
 	}
 }
 
 static const struct ide_port_info rz1000_chipset __devinitdata = {
 	.name		= DRV_NAME,
-	.init_hwif	= init_hwif_rz1000,
-	.chipset	= ide_rz1000,
 	.host_flags	= IDE_HFLAG_NO_DMA,
 };
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_pci_init_one(dev, &rz1000_chipset, NULL);
+	struct ide_port_info d = rz1000_chipset;
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
+
+	if (rz1000_init_chipset(dev)) {
+		d.host_flags |= IDE_HFLAG_SERIALIZE;
+		d.host_flags |= IDE_HFLAG_NO_UNMASK_IRQS;
+	}
+
+	return ide_pci_init_one(dev, &d, NULL);
+}
+
+static void rz1000_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_disable_device(dev);
 }
 
 static const struct pci_device_id rz1000_pci_tbl[] = {
@@ -63,7 +77,7 @@ static struct pci_driver rz1000_pci_driv
 	.name		= "RZ1000_IDE",
 	.id_table	= rz1000_pci_tbl,
 	.probe		= rz1000_init_one,
-	.remove		= ide_pci_remove,
+	.remove		= rz1000_remove,
 };
 
 static int __init rz1000_ide_init(void)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -163,8 +163,7 @@ typedef int (ide_ack_intr_t)(struct hwif
 enum {		ide_unknown,	ide_generic,	ide_pci,
 		ide_cmd640,	ide_dtc2278,	ide_ali14xx,
 		ide_qd65xx,	ide_umc8672,	ide_ht6560b,
-		ide_rz1000,	ide_trm290,
-		ide_cy82c693,	ide_4drives,
+		ide_trm290,	ide_cy82c693,	ide_4drives,
 		ide_pmac,	ide_acorn,
 		ide_au1xxx,	ide_palm3710
 };
