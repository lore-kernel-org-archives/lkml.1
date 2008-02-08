Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbYBHAdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbYBHAdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762984AbYBHAa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:3804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762716AbYBHAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=V0PqkMIrsDZo6j6eqYOO0nsnRDPt6aOLoWuF6RL4CZEKwdykpPDiXRe+xh7dz0AYueEljM/udzvs2JEzypHNOyf9/HDpQBg0HCYhb8mfPUXL7XAmkVDuqwGXYfV097zszwg7CNgNQETD/lYFeSW+tKgYo/+Dt+k38kXRlwb7sTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:02 +0100
Message-Id: <20080208004502.17746.73284.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/18] ide: factor out code unregistering devices from ide_unregister()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out code unregistering devices from ide_unregister() to
ide_port_unregister_devices().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -494,6 +494,23 @@ void ide_remove_port_from_hwgroup(ide_hw
 	spin_unlock_irq(&ide_lock);
 }
 
+/* Called with ide_lock held. */
+static void ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (drive->present) {
+			spin_unlock_irq(&ide_lock);
+			device_unregister(&drive->gendev);
+			wait_for_completion(&drive->gendev_rel_comp);
+			spin_lock_irq(&ide_lock);
+		}
+	}
+}
+
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
@@ -520,11 +537,10 @@ void ide_remove_port_from_hwgroup(ide_hw
 
 void ide_unregister(unsigned int index, int init_default, int restore)
 {
-	ide_drive_t *drive;
 	ide_hwif_t *hwif, *g;
 	static ide_hwif_t tmp_hwif; /* protected by ide_cfg_mtx */
 	ide_hwgroup_t *hwgroup;
-	int irq_count = 0, unit;
+	int irq_count = 0;
 
 	BUG_ON(index >= MAX_HWIFS);
 
@@ -535,15 +551,7 @@ void ide_unregister(unsigned int index, 
 	hwif = &ide_hwifs[index];
 	if (!hwif->present)
 		goto abort;
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		drive = &hwif->drives[unit];
-		if (!drive->present)
-			continue;
-		spin_unlock_irq(&ide_lock);
-		device_unregister(&drive->gendev);
-		wait_for_completion(&drive->gendev_rel_comp);
-		spin_lock_irq(&ide_lock);
-	}
+	ide_port_unregister_devices(hwif);
 	hwif->present = 0;
 
 	spin_unlock_irq(&ide_lock);
