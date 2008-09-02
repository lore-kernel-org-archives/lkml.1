Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYIBTtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYIBTtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYIBTt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:49:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:11245 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYIBTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z7Kor1pbgG+6H7ra9y4rA88JU60yURqVttG5PhIIX9C3SJHa+zf8to9ge69GcMMsJ+
         oEwAiPcOw+gRlrqjvAi8iw+GT2PqdhMGfykHIJ2Vu4ZHioXyOPlMjD5dbBsdUe2kPWch
         e0kCA1o8zpgVJNJzQQq6QQ5DhHIRgOg2BS+eA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:18 +0200
Message-Id: <20080902194718.14564.27048.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] ide: make ide_dma_lost_irq() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ide_dma_lost_irq() available also for CONFIG_BLK_DEV_IDEDMA_SFF=n
and convert {ics,au1xxx-}ide.c to use it.

While at it:
- use EXPORT_SYMBOL_GPL() to match the rest of SFF DMA functions

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c      |    7 +------
 drivers/ide/ide-dma.c         |    9 ++++-----
 drivers/ide/mips/au1xxx-ide.c |    7 +------
 include/linux/ide.h           |    3 ++-
 4 files changed, 8 insertions(+), 18 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -386,11 +386,6 @@ static void icside_dma_timeout(ide_drive
 	icside_dma_end(drive);
 }
 
-static void icside_dma_lost_irq(ide_drive_t *drive)
-{
-	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-}
-
 static int icside_dma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	hwif->dmatable_cpu	= NULL;
@@ -407,7 +402,7 @@ static const struct ide_dma_ops icside_v
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
 	.dma_timeout		= icside_dma_timeout,
-	.dma_lost_irq		= icside_dma_lost_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
 };
 #else
 #define icside_v6_dma_ops NULL
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -823,14 +823,13 @@ void ide_check_dma_crc(ide_drive_t *driv
 		ide_dma_on(drive);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-void ide_dma_lost_irq (ide_drive_t *drive)
+void ide_dma_lost_irq(ide_drive_t *drive)
 {
-	printk("%s: DMA interrupt recovery\n", drive->name);
+	printk(KERN_ERR "%s: DMA interrupt recovery\n", drive->name);
 }
+EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
-EXPORT_SYMBOL(ide_dma_lost_irq);
-
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 void ide_dma_timeout (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -340,11 +340,6 @@ static void auide_dma_host_set(ide_drive
 {
 }
 
-static void auide_dma_lost_irq(ide_drive_t *drive)
-{
-	printk(KERN_ERR "%s: IRQ lost\n", drive->name);
-}
-
 static void auide_ddma_tx_callback(int irq, void *param)
 {
 	_auide_hwif *ahwif = (_auide_hwif*)param;
@@ -390,7 +385,7 @@ static const struct ide_dma_ops au1xxx_d
 	.dma_start		= auide_dma_start,
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
-	.dma_lost_irq		= auide_dma_lost_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= auide_dma_timeout,
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1432,11 +1432,12 @@ void ide_dma_exec_cmd(ide_drive_t *, u8)
 extern void ide_dma_start(ide_drive_t *);
 int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
-extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
 extern const struct ide_dma_ops sff_dma_ops;
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
+void ide_dma_lost_irq(ide_drive_t *);
+
 #else
 static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
