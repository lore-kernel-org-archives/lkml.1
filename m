Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYKIQ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYKIQ2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYKIQZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:25:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbYKIQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Mg/YanzjMArDLV4hrsAZtG/LEe7CTeDm+eSnU7AZAQUF9dTsbIl/nGr2aGUSWkW07M
         v2hsK5256+ZICqNycgnyzRmT+u+jgQ7BZKQu/e3LzwMbOYVehyZAyAoeRbr3zbtTEVrk
         SiPps5klxTymmjdDKJ1zf1o4jYlJG2zfttXmA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:23:31 +0100
Message-Id: <20081109162331.18999.93299.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/11] ide: push local_irq_{save,restore}() to do_identify()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: push local_irq_{save,restore}() to do_identify()

Push local_irq_{save,restore}() from actual_try_to_identify()
to do_identify() and remove no longer needed local_irq_enable().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -116,14 +116,16 @@ static inline void do_identify (ide_driv
 	ide_hwif_t *hwif = HWIF(drive);
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
+	unsigned long flags;
 	int bswap = 1, is_cfa;
 
+	/* local CPU only; some systems need this */
+	local_irq_save(flags);
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
+	local_irq_restore(flags);
 
 	drive->dev_flags |= IDE_DFLAG_ID_READ;
-
-	local_irq_enable();
 #ifdef DEBUG
 	printk(KERN_INFO "%s: dumping identify data\n", drive->name);
 	ide_dump_identify((u8 *)id);
@@ -305,17 +307,12 @@ static int actual_try_to_identify (ide_d
 	s = tp_ops->read_status(hwif);
 
 	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
-		unsigned long flags;
-
-		/* local CPU only; some systems need this */
-		local_irq_save(flags);
 		/* drive returned ID */
 		do_identify(drive, cmd);
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
 		(void)tp_ops->read_status(hwif);
-		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
 		rc = 2;
