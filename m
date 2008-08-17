Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYHQRR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYHQRR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYHQRRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:17:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYHQRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Iwh5U9j04Rq/r1//GbCaQfygXggv6SGsoI8drVyAIdquQQT28CHpil2bJkqUwAroS2
         MmlrEf1n61eJnlnK87ZkDgbk9VzfQxZfptu6xExF2Lc1jw15NLv1UhCImlgMcJnRAVhB
         x5i3r7D7+7lyMXMqYCysurqYxqb/TaGyZYqAE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:14:54 +0200
Message-Id: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] ide: fix IDE ACPI for slave device-only configurations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI _GTM / _PS0 / _STM were not called if only slave device was present.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -365,15 +365,15 @@ __IDE_DEVSET(pio_mode, 0, NULL, set_pio_
 
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
-	ide_drive_t *drive = dev->driver_data;
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = HWIF(drive);
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int ret;
 
-	/* Call ACPI _GTM only once */
-	if (!(drive->dn % 2))
+	/* call ACPI _GTM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
@@ -389,26 +389,25 @@ static int generic_ide_suspend(struct de
 
 	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
-	/* only call ACPI _PS3 after both drivers are suspended */
-	if (!ret && (((drive->dn % 2) && hwif->drives[0].present
-		 && hwif->drives[1].present)
-		 || !hwif->drives[0].present
-		 || !hwif->drives[1].present))
+
+	/* call ACPI _PS3 only after both devices are suspended */
+	if (ret == 0 && ((drive->dn & 1) || pair == NULL))
 		ide_acpi_set_state(hwif, 0);
+
 	return ret;
 }
 
 static int generic_ide_resume(struct device *dev)
 {
-	ide_drive_t *drive = dev->driver_data;
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = HWIF(drive);
 	struct request *rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
 	int err;
 
-	/* Call ACPI _STM only once */
-	if (!(drive->dn % 2)) {
+	/* call ACPI _PS0 / _STM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL) {
 		ide_acpi_set_state(hwif, 1);
 		ide_acpi_push_timing(hwif);
 	}
