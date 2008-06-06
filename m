Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbYFFVk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbYFFVk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYFFVkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:40:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:8741 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbYFFVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=PJfzYBd9BvtrFWScczjCxYG4o/ysdS3f2Xrm0DHOA3miu0qd9pgMsKb4Z5uQVhWGLf
         DlYOdQt3r1Dg2asqkPXzMkcCfU3ykMpXisiM0HJbvjVIJGBrMYPHRpCQsatBhlvJxrEc
         PhV14wYZs5lTfWhO/Bg0ofDb3SJEf19uk6wCk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] icside: don't use hwif->hwif_data
Date: Fri, 6 Jun 2008 23:31:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806062331.53382.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move ecard_set_drvdata() from icside_probe() to icside_register_v{5,6}(),
  then use state->ioc_base instead of hwif->hwif_data in icside_maskproc()
  and icside_dma_test_irq().

While at it:

* Add sel field to struct icside_state, then use state->{sel,ioc_base}
  instead of ->{select,config}_data in icside_dma_setup().

There should be no functional changes caused by this patch.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -68,6 +68,7 @@ struct icside_state {
 	unsigned int enabled;
 	void __iomem *irq_port;
 	void __iomem *ioc_base;
+	unsigned int sel;
 	unsigned int type;
 	ide_hwif_t *hwif[2];
 };
@@ -165,7 +166,8 @@ static const expansioncard_ops_t icside_
 static void icside_maskproc(ide_drive_t *drive, int mask)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct icside_state *state = hwif->hwif_data;
+	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -308,6 +310,7 @@ static int icside_dma_setup(ide_drive_t 
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 	struct request *rq = hwif->hwgroup->rq;
 	unsigned int dma_mode;
 
@@ -331,7 +334,7 @@ static int icside_dma_setup(ide_drive_t 
 	/*
 	 * Route the DMA signals to the correct interface.
 	 */
-	writeb(hwif->select_data, hwif->config_data);
+	writeb(state->sel | hwif->channel, state->ioc_base);
 
 	/*
 	 * Select the correct timing for this drive.
@@ -359,7 +362,8 @@ static void icside_dma_exec_cmd(ide_driv
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct icside_state *state = hwif->hwif_data;
+	struct expansion_card *ec = ECARD_DEV(hwif->dev);
+	struct icside_state *state = ecard_get_drvdata(ec);
 
 	return readb(state->irq_port +
 		     (hwif->channel ?
@@ -472,6 +476,8 @@ icside_register_v5(struct icside_state *
 
 	state->hwif[0] = hwif;
 
+	ecard_set_drvdata(ec, state);
+
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, NULL);
@@ -525,6 +531,7 @@ icside_register_v6(struct icside_state *
 
 	state->irq_port   = easi_base;
 	state->ioc_base   = ioc_base;
+	state->sel	  = sel;
 
 	/*
 	 * Be on the safe side - disable interrupts
@@ -545,13 +552,7 @@ icside_register_v6(struct icside_state *
 	state->hwif[0]    = hwif;
 	state->hwif[1]    = mate;
 
-	hwif->hwif_data   = state;
-	hwif->config_data = (unsigned long)ioc_base;
-	hwif->select_data = sel;
-
-	mate->hwif_data   = state;
-	mate->config_data = (unsigned long)ioc_base;
-	mate->select_data = sel | 1;
+	ecard_set_drvdata(ec, state);
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		d.init_dma = icside_dma_init;
@@ -627,10 +628,8 @@ icside_probe(struct expansion_card *ec, 
 		break;
 	}
 
-	if (ret == 0) {
-		ecard_set_drvdata(ec, state);
+	if (ret == 0)
 		goto out;
-	}
 
 	kfree(state);
  release:
