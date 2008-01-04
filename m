Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYADVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYADVSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYADVOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:14:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbYADVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:14:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AdB0jlezZjsNSl0f7gvFdCuXZabHMyQu3IexoXEM17f4ctRO4h4aQSazDZL0gaJxhvXEf5gLXZ6khs6qWAqQCrcBfkXHSi66270Jkp+8LJZepDAIPJBZg8+uus23EE2PM/hPYfrsz7TEZcf1ae+1xz5fMjUBOMHeD7P4iI/ony8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:26:21 +0100
Message-Id: <20080104212621.6978.60873.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/15] ide: move hwif_register() call out of ide_probe_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add BUG_ON(hwif->present) at the start of ide_probe_port().

* Move hwif_register() call (along with setting hwif->present) from
  ide_probe_port() to ide_device_add_all().

  As a result the port will be registered with the device tree _after_:
  - probing both devices (if both are present)
  - port reset (if hwif->reset is set)
  - restoring local IRQs state and re-enabling port IRQ

While at it:

* Rename hwif_register() to ide_register_port().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+17 bytes
 drivers/ide/ide-probe.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -613,7 +613,7 @@ static void hwif_release_dev (struct dev
 	complete(&hwif->gendev_rel_comp);
 }
 
-static void hwif_register (ide_hwif_t *hwif)
+static void ide_register_port(ide_hwif_t *hwif)
 {
 	int ret;
 
@@ -742,7 +742,9 @@ static int ide_probe_port(ide_hwif_t *hw
 {
 	unsigned long flags;
 	unsigned int irqd;
-	int unit;
+	int unit, rc = -ENODEV;
+
+	BUG_ON(hwif->present);
 
 	if (hwif->noprobe)
 		return -EACCES;
@@ -767,14 +769,8 @@ static int ide_probe_port(ide_hwif_t *hw
 		ide_drive_t *drive = &hwif->drives[unit];
 		drive->dn = (hwif->channel ? 2 : 0) + unit;
 		(void) probe_for_drive(drive);
-		if (drive->present && !hwif->present) {
-			hwif->present = 1;
-			if (hwif->chipset != ide_4drives ||
-			    !hwif->mate || 
-			    !hwif->mate->present) {
-				hwif_register(hwif);
-			}
-		}
+		if (drive->present)
+			rc = 0;
 	}
 	if (hwif->io_ports[IDE_CONTROL_OFFSET] && hwif->reset) {
 		printk(KERN_WARNING "%s: reset\n", hwif->name);
@@ -791,10 +787,7 @@ static int ide_probe_port(ide_hwif_t *hw
 	if (irqd)
 		enable_irq(irqd);
 
-	if (!hwif->present)
-		return -ENODEV;
-
-	return 0;
+	return rc;
 }
 
 static void ide_port_tune_devices(ide_hwif_t *hwif)
@@ -1319,6 +1312,12 @@ int ide_device_add_all(u8 *idx)
 			continue;
 		}
 
+		hwif->present = 1;
+
+		if (hwif->chipset != ide_4drives || !hwif->mate ||
+		    !hwif->mate->present)
+			ide_register_port(hwif);
+
 		ide_port_tune_devices(hwif);
 	}
 
