Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYKCUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYKCUHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYKCUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:05:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:36760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYKCUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lHvME8DTrMO/TUKqdTyVHrEEHYcRtNRJFz3uQvGKTweiG6LnzYUo5rLFNqKYW3a9KD
         CbFv78Dv3r68kui64gm2Wt2MGkA/FGwoKSjM2eBEdnLXKBGgjR3vV1pL85t8kEq+eroC
         OeCWWUMh2tHwNSLdWDs5ahMp+owt1RTSG8Zic=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 03 Nov 2008 21:03:26 +0100
Message-Id: <20081103200326.5098.2058.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/6] ide: rework handling of serialized ports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: rework handling of serialized ports

* hpt366: set IDE_HFLAG_SERIALIZE in hwif->host_flags if needed
  in init_hwif_hpt366().  Remove HPT_SERIALIZE_IO while at it.

* Set IDE_HFLAG_SERIALIZE in hwif->host_flags if needed in
  ide_init_port().

* Convert init_irq() to use IDE_HFLAG_SERIALIZE together with
  hwif->host to find out ports which need to be serialized.

* Remove no longer needed save_match() and ide_hwif_t.serialized.

This patch should fix the incorrect grouping of port(s) from
host(s) that need serialization with port(s) that happen to use
the same IRQ(s) but are from the host(s) that don't need it.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/hpt366.c    |    8 -------
 drivers/ide/ide-probe.c |   50 ++++--------------------------------------------
 include/linux/ide.h     |    1 
 3 files changed, 6 insertions(+), 53 deletions(-)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -135,7 +135,6 @@
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
-#define HPT_SERIALIZE_IO	0
 
 static const char *quirk_drives[] = {
 	"QUANTUM FIREBALLlct08 08",
@@ -1288,7 +1287,6 @@ static u8 hpt3xx_cable_detect(ide_hwif_t
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
-	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
 
 	/* Cache the channel's MISC. control registers' offset */
@@ -1305,13 +1303,9 @@ static void __devinit init_hwif_hpt366(i
 		 * Clock is shared between the channels,
 		 * so we'll have to serialize them... :-(
 		 */
-		serialize = 1;
+		hwif->host_flags |= IDE_HFLAG_SERIALIZE;
 		hwif->rw_disk = &hpt3xxn_rw_disk;
 	}
-
-	/* Serialize access to this device if needed */
-	if (serialize && hwif->mate)
-		hwif->serialized = hwif->mate->serialized = 1;
 }
 
 static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -863,31 +863,6 @@ static void ide_port_tune_devices(ide_hw
 }
 
 /*
- * save_match() is used to simplify logic in init_irq() below.
- *
- * A loophole here is that we may not know about a particular
- * hwif's irq until after that hwif is actually probed/initialized..
- * This could be a problem for the case where an hwif is on a
- * dual interface that requires serialization (eg. cmd640) and another
- * hwif using one of the same irqs is initialized beforehand.
- *
- * This routine detects and reports such situations, but does not fix them.
- */
-static void save_match(ide_hwif_t *hwif, ide_hwif_t *new, ide_hwif_t **match)
-{
-	ide_hwif_t *m = *match;
-
-	if (m && m->hwgroup && m->hwgroup != new->hwgroup) {
-		if (!new->hwgroup)
-			return;
-		printk(KERN_WARNING "%s: potential IRQ problem with %s and %s\n",
-			hwif->name, new->name, m->name);
-	}
-	if (!m || m->irq != hwif->irq) /* don't undo a prior perfect match */
-		*match = new;
-}
-
-/*
  * init request queue
  */
 static int ide_init_queue(ide_drive_t *drive)
@@ -1051,26 +1026,13 @@ static int init_irq (ide_hwif_t *hwif)
 	mutex_lock(&ide_cfg_mtx);
 	hwif->hwgroup = NULL;
 
-	/*
-	 * Group up with any other hwifs that share our irq(s).
-	 */
 	for (index = 0; index < MAX_HWIFS; index++) {
 		ide_hwif_t *h = ide_ports[index];
 
 		if (h && h->hwgroup) {  /* scan only initialized ports */
-			if (hwif->irq == h->irq) {
-				if (hwif->chipset != ide_pci ||
-				    h->chipset != ide_pci) {
-					save_match(hwif, h, &match);
-				}
-			}
-			if (hwif->serialized) {
-				if (hwif->mate && hwif->mate->irq == h->irq)
-					save_match(hwif, h, &match);
-			}
-			if (h->serialized) {
-				if (h->mate && hwif->irq == h->mate->irq)
-					save_match(hwif, h, &match);
+			if (hwif->host_flags & IDE_HFLAG_SERIALIZE) {
+				if (hwif->host == h->host)
+					match = h;
 			}
 		}
 	}
@@ -1436,10 +1398,8 @@ static void ide_init_port(ide_hwif_t *hw
 	}
 
 	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
-	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
-		if (hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-	}
+	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base))
+		hwif->host_flags |= IDE_HFLAG_SERIALIZE;
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -832,7 +832,6 @@ typedef struct hwif_s {
 	unsigned	extra_ports;	/* number of extra dma ports */
 
 	unsigned	present    : 1;	/* this interface exists */
-	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 
 	struct device		gendev;
