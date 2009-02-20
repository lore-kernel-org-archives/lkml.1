Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbZBTRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbZBTRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZBTRKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:37 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:65258 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbZBTRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ojGFgm9QosZOCQOC9ov4SrS9QAWmeOQzupdAlwsMV6OkLAJ3hPQs8rEUtD/uCXEsCK
         lasYHaF81kVIBRcPg7sASZ1vcAT4yWCrMH5HoAFGNU1xfKCR/KAUUruCO4/JjxKOe7T4
         K9/xjoJGFixjCDlwIKq8wNwrDx2dn22zjwcjU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:29 +0100
Message-Id: <20090220171229.25429.16478.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/10] ide: add ->dma_check method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ->dma_check method

* Add (an optional) ->dma_check method for checking if DMA can be
  used for a given command and fail DMA setup in ide_dma_prepare()
  if necessary.

* Convert alim15x3 and trm290 host drivers to use ->dma_check.

* Rename ali15x3_dma_setup() to ali_dma_setup() while at it.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |    9 +++++----
 drivers/ide/ide-dma.c  |    5 ++++-
 drivers/ide/trm290.c   |   17 ++++++++++-------
 include/linux/ide.h    |    1 +
 4 files changed, 20 insertions(+), 12 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -189,20 +189,20 @@ static void ali_set_dma_mode(ide_drive_t
 }
 
 /**
- *	ali15x3_dma_setup	-	begin a DMA phase
+ *	ali_dma_check	-	DMA check
  *	@drive:	target device
  *	@cmd: command
  *
  *	Returns 1 if the DMA cannot be performed, zero on success.
  */
 
-static int ali15x3_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+static int ali_dma_check(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
 		if (cmd->tf_flags & IDE_TFLAG_WRITE)
 			return 1;	/* try PIO instead of DMA */
 	}
-	return ide_dma_setup(drive, cmd);
+	return 0;
 }
 
 /**
@@ -503,11 +503,12 @@ static const struct ide_port_ops ali_por
 
 static const struct ide_dma_ops ali_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ali15x3_dma_setup,
+	.dma_setup		= ide_dma_setup,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_check		= ali_dma_check,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -562,9 +562,12 @@ EXPORT_SYMBOL_GPL(ide_allocate_dma_engin
 
 int ide_dma_prepare(ide_drive_t *drive, struct ide_cmd *cmd)
 {
+	const struct ide_dma_ops *dma_ops = drive->hwif->dma_ops;
+
 	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+	    (dma_ops->dma_check && dma_ops->dma_check(drive, cmd)) ||
 	    ide_build_sglist(drive, cmd) == 0 ||
-	    drive->hwif->dma_ops->dma_setup(drive, cmd))
+	    dma_ops->dma_setup(drive, cmd))
 		return 1;
 	return 0;
 }
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -176,19 +176,21 @@ static void trm290_selectproc (ide_drive
 	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
-static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+static int trm290_dma_check(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	unsigned int count, rw;
-
 	if (cmd->tf_flags & IDE_TFLAG_WRITE) {
 #ifdef TRM290_NO_DMA_WRITES
 		/* always use PIO for writes */
 		return 1;
 #endif
-		rw = 1;
-	} else
-		rw = 2;
+	}
+	return 0;
+}
+
+static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned int count, rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 2;
 
 	count = ide_build_dmatable(drive, cmd);
 	if (count == 0) {
@@ -312,6 +314,7 @@ static struct ide_dma_ops trm290_dma_ops
 	.dma_end		= trm290_dma_end,
 	.dma_test_irq		= trm290_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_check		= trm290_dma_check,
 };
 
 static const struct ide_port_info trm290_chipset __devinitdata = {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -716,6 +716,7 @@ struct ide_dma_ops {
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
 	/* below ones are optional */
+	int	(*dma_check)(struct ide_drive_s *, struct ide_cmd *);
 	int	(*dma_timer_expiry)(struct ide_drive_s *);
 	void	(*dma_clear)(struct ide_drive_s *);
 	/*
