Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYAPXTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYAPXTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYAPXPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYAPXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=EyWVOmA83/0W8fAMfstRcz8vEa3uZwLbfUKWsE7WDt2JzJzHMEy1LSKo45GzhSu0Xx9utHjnmu1iQdjm7W62/4NrALktGd261LpflqBGHdnF5SeiHBq5zLsEo89i+ZLjbxK5HxDYa8uRb5Ik/TsOel4IiGSD5VO9CB0wPQL+eW4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:57 +0100
Message-Id: <20080116232757.9166.7078.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/22] ide: factor out devices setup from init_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out devices setup from init_irq() to ide_port_setup_devices().

While at it:
* Do devices setup after printing port information.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -929,6 +929,31 @@ static void ide_add_drive_to_hwgroup(ide
 }
 
 /*
+ * For any present drive:
+ * - allocate the block device queue
+ * - link drive into the hwgroup
+ */
+static void ide_port_setup_devices(ide_hwif_t *hwif)
+{
+	int i;
+
+	for (i = 0; i < MAX_DRIVES; i++) {
+		ide_drive_t *drive = &hwif->drives[i];
+
+		if (!drive->present)
+			continue;
+
+		if (ide_init_queue(drive)) {
+			printk(KERN_ERR "ide: failed to init %s\n",
+					drive->name);
+			continue;
+		}
+
+		ide_add_drive_to_hwgroup(drive);
+	}
+}
+
+/*
  * This routine sets up the irq for an ide interface, and creates a new
  * hwgroup for the irq/hwif if none was previously assigned.
  *
@@ -1037,22 +1062,6 @@ static int init_irq (ide_hwif_t *hwif)
 			hwif->rqsize = 65536;
 	}
 
-	/*
-	 * For any present drive:
-	 * - allocate the block device queue
-	 * - link drive into the hwgroup
-	 */
-	for (index = 0; index < MAX_DRIVES; ++index) {
-		ide_drive_t *drive = &hwif->drives[index];
-		if (!drive->present)
-			continue;
-		if (ide_init_queue(drive)) {
-			printk(KERN_ERR "ide: failed to init %s\n",drive->name);
-			continue;
-		}
-		ide_add_drive_to_hwgroup(drive);
-	}
-
 #if !defined(__mc68000__) && !defined(CONFIG_APUS)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
@@ -1066,6 +1075,9 @@ static int init_irq (ide_hwif_t *hwif)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
 	printk("\n");
+
+	ide_port_setup_devices(hwif);
+
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_unlink:
