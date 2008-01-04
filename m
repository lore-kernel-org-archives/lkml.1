Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYADVNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYADVNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYADVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:12:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYADVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PoMVwLadXFFSUPopxj0Pc00bKME3nNy+Ldd3wXwr9KJvlXVlk64YNAet4HvtODGmsW3J4HG5m7nx6aJ9QraNVF+Ky7sVy4Zi7gKnqXt4IJHEk3tODMmWpxSm6yaid4Og9W/zv+KN3zYqQI4M1J0C5awqTdBVUP+G62K0SicYVgc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:24:31 +0100
Message-Id: <20080104212431.6978.35188.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/15] ide: fix handling of busy I/O resources in probe_hwif()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It could be that I/O resources are busy because some other host driver
has already claimed them so don't unregister the devices.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-94 bytes
 drivers/ide/ide-probe.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -727,18 +727,7 @@ static void probe_hwif(ide_hwif_t *hwif)
 
 	if ((hwif->chipset != ide_4drives || !hwif->mate || !hwif->mate->present) &&
 	    (ide_hwif_request_regions(hwif))) {
-		u16 msgout = 0;
-		for (unit = 0; unit < MAX_DRIVES; ++unit) {
-			ide_drive_t *drive = &hwif->drives[unit];
-			if (drive->present) {
-				drive->present = 0;
-				printk(KERN_ERR "%s: ERROR, PORTS ALREADY IN USE\n",
-					drive->name);
-				msgout = 1;
-			}
-		}
-		if (!msgout)
-			printk(KERN_ERR "%s: ports already in use, skipping probe\n",
+		printk(KERN_ERR "%s: ports already in use, skipping probe\n",
 				hwif->name);
 		return;	
 	}
