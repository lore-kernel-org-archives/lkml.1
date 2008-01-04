Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYADVRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYADVRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYADVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:14:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYADVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xOliWBLrExY4AUS4Ov+Hlk/FjipNITx99Xc7rGU/ochD69f8NAkWn4Tjpf6ts9oZvYC5HqBkWszoz6LqpF40WakGSmYC3chFhabR2giJaIts2JwrsK+kD/R0yEtY5FdKTCrr2PjVYbEP/plNpRaObCupbh6tCer31a/igD4IaAw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:26:04 +0100
Message-Id: <20080104212604.6978.5744.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/15] ide: move handling of I/O resources out of ide_probe_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve/release I/O resources in ide_device_add_all() instead of
ide_probe_port().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -747,13 +747,6 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (hwif->noprobe)
 		return -EACCES;
 
-	if ((hwif->chipset != ide_4drives || !hwif->mate || !hwif->mate->present) &&
-	    (ide_hwif_request_regions(hwif))) {
-		printk(KERN_ERR "%s: ports already in use, skipping probe\n",
-				hwif->name);
-		return -EBUSY;
-	}
-
 	/*
 	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
 	 * we'll install our IRQ driver much later...
@@ -798,10 +791,8 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		enable_irq(irqd);
 
-	if (!hwif->present) {
-		ide_hwif_release_regions(hwif);
+	if (!hwif->present)
 		return -ENODEV;
-	}
 
 	for (unit = 0; unit < MAX_DRIVES; unit++) {
 		ide_drive_t *drive = &hwif->drives[unit];
@@ -1309,7 +1300,17 @@ int ide_device_add_all(u8 *idx)
 		if (idx[i] == 0xff)
 			continue;
 
-		(void)ide_probe_port(&ide_hwifs[idx[i]]);
+		hwif = &ide_hwifs[idx[i]];
+
+		if ((hwif->chipset != ide_4drives || !hwif->mate ||
+		     !hwif->mate->present) && ide_hwif_request_regions(hwif)) {
+			printk(KERN_ERR "%s: ports already in use, "
+					"skipping probe\n", hwif->name);
+			continue;
+		}
+
+		if (ide_probe_port(hwif) < 0)
+			ide_hwif_release_regions(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
