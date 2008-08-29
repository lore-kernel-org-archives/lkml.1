Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYH2Vql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYH2Vql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYH2Vqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:46:30 -0400
Received: from nebensachen.de ([195.34.83.29]:49281 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYH2Vq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:46:29 -0400
X-Hashcash: 1:20:080829:bzolnier@gmail.com::wAaqHaLOlk2GIjXM:00000000000000000000000000000000000000000002hwy
X-Hashcash: 1:20:080829:linux-ide@vger.kernel.org::a9KXzhynFx6AREZx:0000000000000000000000000000000000000vek
X-Hashcash: 1:20:080829:linux-kernel@vger.kernel.org::t8WeBO/t/FoEGa+3:0000000000000000000000000000000004IjA
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide: Two fixes regarding memory allocation
Message-ID: <20080829213217.4826.43132.stgit@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Aug 2008 23:45:32 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function ide_devset_execute() we should use __GFP_WAIT rather than
GFP_KERNEL. Also, the allocation cannot possibly fail at that point.
More importantly, there is a potential memory leak in the device probing
code. The infrastructure seems rather complex and I hope I haven't messed
anything up by trying to fix this.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
Applies to next-20080829.

 drivers/ide/ide-io.c    |    5 +----
 drivers/ide/ide-probe.c |   22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index d0579f1..e205f46 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -655,10 +655,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	if (!(setting->flags & DS_SYNC))
 		return setting->set(drive, arg);
 
-	rq = blk_get_request(q, READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
-
+	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 5;
 	rq->cmd[0] = REQ_DEVSET_EXEC;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index b5e54d2..1c4cd5e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -958,9 +958,9 @@ static void ide_add_drive_to_hwgroup(ide_drive_t *drive)
  * - allocate the block device queue
  * - link drive into the hwgroup
  */
-static void ide_port_setup_devices(ide_hwif_t *hwif)
+static int ide_port_setup_devices(ide_hwif_t *hwif)
 {
-	int i;
+	int i, j = 0;
 
 	mutex_lock(&ide_cfg_mtx);
 	for (i = 0; i < MAX_DRIVES; i++) {
@@ -972,12 +972,21 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
 		if (ide_init_queue(drive)) {
 			printk(KERN_ERR "ide: failed to init %s\n",
 					drive->name);
+			spin_lock_irq(&ide_lock);
+			kfree(drive->id);
+			drive->id = NULL;
+			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
+			spin_unlock_irq(&ide_lock);
 			continue;
 		}
 
+		j++;
+
 		ide_add_drive_to_hwgroup(drive);
 	}
 	mutex_unlock(&ide_cfg_mtx);
+
+	return j;
 }
 
 static ide_hwif_t *ide_ports[MAX_HWIFS];
@@ -1663,10 +1672,13 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			continue;
 		}
 
-		j++;
-
 		if (hwif->present)
-			ide_port_setup_devices(hwif);
+			if (ide_port_setup_devices(hwif) == 0) {
+				hwif->present = 0;
+				continue;
+			}
+
+		j++;
 
 		ide_acpi_init(hwif);
 


