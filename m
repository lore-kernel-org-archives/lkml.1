Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYADVR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYADVR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYADVOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:14:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbYADVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qyVUvQh4y5hkVx5W+IDJ+ghHUEaUPuPfuDi5PeGNolz7sgBoTEeAqlPiFxwoKnE51dQo0N0o8PXzGyrecAWBrDprVup+G9kzpS7b7TIjPA9jAU6wpRDOeEw5KjKyQ9YRApjJisECrSIOjVp5qlOAacwS9yuqY13WQqAqcncWieE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:56 +0100
Message-Id: <20080104212556.6978.80043.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/15] ide: make probe_hwif() return an error value
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make probe_hwif() return an error value.

While at it:

* Remove comment about MAX_DRIVES == 2 limitation (it is not special to
  probe_hwif(), it is a general assumption taken by a lot of IDE code).

* Rename probe_hwif() to ide_probe_port().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c    |    2 +-
 drivers/ide/ide-probe.c   |   16 +++++++---------
 drivers/ide/pci/ns87415.c |    4 ++--
 3 files changed, 10 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1166,7 +1166,7 @@ EXPORT_SYMBOL(ide_do_reset);
 
 /*
  * ide_wait_not_busy() waits for the currently selected device on the hwif
- * to report a non-busy status, see comments in probe_hwif().
+ * to report a non-busy status, see comments in ide_probe_port().
  */
 int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout)
 {
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -738,24 +738,20 @@ void ide_undecoded_slave(ide_drive_t *dr
 
 EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 
-/*
- * This routine only knows how to look for drive units 0 and 1
- * on an interface, so any setting of MAX_DRIVES > 2 won't work here.
- */
-static void probe_hwif(ide_hwif_t *hwif)
+static int ide_probe_port(ide_hwif_t *hwif)
 {
 	unsigned long flags;
 	unsigned int irqd;
 	int unit;
 
 	if (hwif->noprobe)
-		return;
+		return -EACCES;
 
 	if ((hwif->chipset != ide_4drives || !hwif->mate || !hwif->mate->present) &&
 	    (ide_hwif_request_regions(hwif))) {
 		printk(KERN_ERR "%s: ports already in use, skipping probe\n",
 				hwif->name);
-		return;	
+		return -EBUSY;
 	}
 
 	/*
@@ -804,7 +800,7 @@ static void probe_hwif(ide_hwif_t *hwif)
 
 	if (!hwif->present) {
 		ide_hwif_release_regions(hwif);
-		return;
+		return -ENODEV;
 	}
 
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
@@ -840,6 +836,8 @@ static void probe_hwif(ide_hwif_t *hwif)
 		else
 			drive->no_io_32bit = drive->id->dword_io ? 1 : 0;
 	}
+
+	return 0;
 }
 
 #if MAX_HWIFS > 1
@@ -1311,7 +1309,7 @@ int ide_device_add_all(u8 *idx)
 		if (idx[i] == 0xff)
 			continue;
 
-		probe_hwif(&ide_hwifs[idx[i]]);
+		(void)ide_probe_port(&ide_hwifs[idx[i]]);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -229,8 +229,8 @@ static void __devinit init_hwif_ns87415 
 
 #ifdef __sparc_v9__
 		/*
-		 * XXX: Reset the device, if we don't it will not respond
-		 *      to SELECT_DRIVE() properly during first probe_hwif().
+		 * XXX: Reset the device, if we don't it will not respond to
+		 *      SELECT_DRIVE() properly during first ide_probe_port().
 		 */
 		timeout = 10000;
 		outb(12, hwif->io_ports[IDE_CONTROL_OFFSET]);
