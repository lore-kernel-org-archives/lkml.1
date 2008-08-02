Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYHBRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYHBRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBRQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:16:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:7151 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYHBRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=pHiO6vAe81pvxRvqgQdIK1hRMXZJVKnGbvvN0L0pJ1lxh5lvYGt6k1S7xzh2PN6Dhj
         gtqKJMixnfd+jtfN6ae01UxY7lrfaqDtpiAjd/nNxRAI8i2/aiMI2ahkohRRdwxi07qm
         Y6FV2zdO+RyR2Dt13gMA9lgf1DswTFNeGy8IA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@kernel.org
Subject: [PATCH 1/3] ide: use ata_id_is_cfa()
Date: Sat, 2 Aug 2008 19:08:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021908.13984.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ata_id_is_cfa() in do_identify() instead of open-coding
check for CompactFlash devices (the inline helper also takes
care of detecting CFs advertising themselves as ATA disks).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -116,7 +116,7 @@ static inline void do_identify (ide_driv
 	ide_hwif_t *hwif = HWIF(drive);
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
-	int bswap = 1;
+	int bswap = 1, is_cfa;
 
 	/* read 512 bytes of id info */
 	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
@@ -212,17 +212,15 @@ static inline void do_identify (ide_driv
 	 * Not an ATAPI device: looks like a "regular" hard disk
 	 */
 
-	/*
-	 * 0x848a = CompactFlash device
-	 * These are *not* removable in Linux definition of the term
-	 */
-	if (id[ATA_ID_CONFIG] != 0x848a && (id[ATA_ID_CONFIG] & (1 << 7)))
+	is_cfa = ata_id_is_cfa(id);
+
+	/* CF devices are *not* removable in Linux definition of the term */
+	if (is_cfa == 0 && (id[ATA_ID_CONFIG] & (1 << 7)))
 		drive->removable = 1;
 
 	drive->media = ide_disk;
 
-	printk(KERN_CONT "%s DISK drive\n",
-		(id[ATA_ID_CONFIG] == 0x848a) ? "CFA" : "ATA");
+	printk(KERN_CONT "%s DISK drive\n", is_cfa ? "CFA" : "ATA");
 
 	return;
 
