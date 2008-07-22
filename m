Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYGVVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYGVVQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYGVVOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:50809 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYGVVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Vt+hGyBkGmVZ/TSlDvlVUCG7KOSHk4rpNWiZbYtblTBqOuIILZh0C0710B6GOqw3wD
         VNh8FS6m27VAUg+Qy1kyJdoUWItbt6yyRrT3lPXlsQD9HlFLlF68YbxVvyHE/VwR728k
         +qxayOPGp2eHc3cBFg0E2mNSLxQ98wfFh1J1E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:34 +0200
Message-Id: <20080722211234.20478.22003.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/10] ide: cleanup ide_fix_driveid()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do all __le16_to_cpu() swapping in one loop.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |  105 ++++++++-----------------------------------------
 1 file changed, 19 insertions(+), 86 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -400,97 +400,30 @@ const struct ide_tp_ops default_tp_ops =
 	.output_data		= ide_output_data,
 };
 
-void ide_fix_driveid (struct hd_driveid *id)
+void ide_fix_driveid(struct hd_driveid *driveid)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
+	u16 *id = (u16 *)driveid;
 	int i;
-	u16 *stringcast;
 
-	id->config         = __le16_to_cpu(id->config);
-	id->cyls           = __le16_to_cpu(id->cyls);
-	id->reserved2      = __le16_to_cpu(id->reserved2);
-	id->heads          = __le16_to_cpu(id->heads);
-	id->track_bytes    = __le16_to_cpu(id->track_bytes);
-	id->sector_bytes   = __le16_to_cpu(id->sector_bytes);
-	id->sectors        = __le16_to_cpu(id->sectors);
-	id->vendor0        = __le16_to_cpu(id->vendor0);
-	id->vendor1        = __le16_to_cpu(id->vendor1);
-	id->vendor2        = __le16_to_cpu(id->vendor2);
-	stringcast = (u16 *)&id->serial_no[0];
-	for (i = 0; i < (20/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->buf_type       = __le16_to_cpu(id->buf_type);
-	id->buf_size       = __le16_to_cpu(id->buf_size);
-	id->ecc_bytes      = __le16_to_cpu(id->ecc_bytes);
-	stringcast = (u16 *)&id->fw_rev[0];
-	for (i = 0; i < (8/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	stringcast = (u16 *)&id->model[0];
-	for (i = 0; i < (40/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->dword_io       = __le16_to_cpu(id->dword_io);
-	id->reserved50     = __le16_to_cpu(id->reserved50);
-	id->field_valid    = __le16_to_cpu(id->field_valid);
-	id->cur_cyls       = __le16_to_cpu(id->cur_cyls);
-	id->cur_heads      = __le16_to_cpu(id->cur_heads);
-	id->cur_sectors    = __le16_to_cpu(id->cur_sectors);
-	id->cur_capacity0  = __le16_to_cpu(id->cur_capacity0);
-	id->cur_capacity1  = __le16_to_cpu(id->cur_capacity1);
-	id->lba_capacity   = __le32_to_cpu(id->lba_capacity);
-	id->dma_1word      = __le16_to_cpu(id->dma_1word);
-	id->dma_mword      = __le16_to_cpu(id->dma_mword);
-	id->eide_pio_modes = __le16_to_cpu(id->eide_pio_modes);
-	id->eide_dma_min   = __le16_to_cpu(id->eide_dma_min);
-	id->eide_dma_time  = __le16_to_cpu(id->eide_dma_time);
-	id->eide_pio       = __le16_to_cpu(id->eide_pio);
-	id->eide_pio_iordy = __le16_to_cpu(id->eide_pio_iordy);
-	for (i = 0; i < 2; ++i)
-		id->words69_70[i] = __le16_to_cpu(id->words69_70[i]);
-	for (i = 0; i < 4; ++i)
-		id->words71_74[i] = __le16_to_cpu(id->words71_74[i]);
-	id->queue_depth    = __le16_to_cpu(id->queue_depth);
-	for (i = 0; i < 4; ++i)
-		id->words76_79[i] = __le16_to_cpu(id->words76_79[i]);
-	id->major_rev_num  = __le16_to_cpu(id->major_rev_num);
-	id->minor_rev_num  = __le16_to_cpu(id->minor_rev_num);
-	id->command_set_1  = __le16_to_cpu(id->command_set_1);
-	id->command_set_2  = __le16_to_cpu(id->command_set_2);
-	id->cfsse          = __le16_to_cpu(id->cfsse);
-	id->cfs_enable_1   = __le16_to_cpu(id->cfs_enable_1);
-	id->cfs_enable_2   = __le16_to_cpu(id->cfs_enable_2);
-	id->csf_default    = __le16_to_cpu(id->csf_default);
-	id->dma_ultra      = __le16_to_cpu(id->dma_ultra);
-	id->trseuc         = __le16_to_cpu(id->trseuc);
-	id->trsEuc         = __le16_to_cpu(id->trsEuc);
-	id->CurAPMvalues   = __le16_to_cpu(id->CurAPMvalues);
-	id->mprc           = __le16_to_cpu(id->mprc);
-	id->hw_config      = __le16_to_cpu(id->hw_config);
-	id->acoustic       = __le16_to_cpu(id->acoustic);
-	id->msrqs          = __le16_to_cpu(id->msrqs);
-	id->sxfert         = __le16_to_cpu(id->sxfert);
-	id->sal            = __le16_to_cpu(id->sal);
-	id->spg            = __le32_to_cpu(id->spg);
-	id->lba_capacity_2 = __le64_to_cpu(id->lba_capacity_2);
-	for (i = 0; i < 22; i++)
-		id->words104_125[i]   = __le16_to_cpu(id->words104_125[i]);
-	id->last_lun       = __le16_to_cpu(id->last_lun);
-	id->word127        = __le16_to_cpu(id->word127);
-	id->dlf            = __le16_to_cpu(id->dlf);
-	id->csfo           = __le16_to_cpu(id->csfo);
-	for (i = 0; i < 26; i++)
-		id->words130_155[i] = __le16_to_cpu(id->words130_155[i]);
-	id->word156        = __le16_to_cpu(id->word156);
-	for (i = 0; i < 3; i++)
-		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
-	id->cfa_power      = __le16_to_cpu(id->cfa_power);
-	for (i = 0; i < 15; i++)
-		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
-	for (i = 0; i < 30; i++)
-		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
-	for (i = 0; i < 49; i++)
-		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
-	id->integrity_word  = __le16_to_cpu(id->integrity_word);
+	for (i = 0; i < 256; i++) {
+		/*  these words are accessed as two 8-bit values */
+		if (i == 47 || i == 49 || i == 51 || i == 52 || i == 59)
+			continue;
+		if (i == 60 || i == 61)	/* ->lba_capacity is 32-bit */
+			continue;
+		if (i == 98 || i == 99)	/* ->spg is 32-bit */
+			continue;
+		if (i > 99 && i < 104)	/* ->lba_capacity_2 is 64-bit */
+			continue;
+
+		id[i] = __le16_to_cpu(id[i]);
+	}
+
+	driveid->lba_capacity	= __le32_to_cpu(driveid->lba_capacity);
+	driveid->spg		= __le32_to_cpu(driveid->spg);
+	driveid->lba_capacity_2	= __le64_to_cpu(driveid->lba_capacity_2);
 # else
 #  error "Please fix <asm/byteorder.h>"
 # endif
