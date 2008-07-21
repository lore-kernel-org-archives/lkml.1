Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYGUTPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYGUTPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbYGUTNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:13:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:33271 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYGUTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ipVcMNQwmyOzooDwBC7DqGql0Crho6YhshUOqdIxsP/zFzL7nC48WzZ7X2euH80MZA
         rIatfyIGc0wBnp1nVNTAWkldxLMw/70POKDOJrY1qMZKKN5VeXgCLbMolQr7hrEDoZl9
         2czFCkesu3ccGXjPfaD5mMPOAzRWtJdb0XAm4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: enable local IRQs in all handlers for TASKFILE_NO_DATA data phase
Date: Mon, 21 Jul 2008 21:09:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807212109.09858.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is already done by task_no_data_intr() and there is no reason
not to do it in other TASKFILE_NO_DATA data phase handlers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -126,7 +126,10 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 stat;
+
+	local_irq_enable_in_hardirq();
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -147,6 +150,8 @@ static ide_startstop_t set_geometry_intr
 	int retries = 5;
 	u8 stat;
 
+	local_irq_enable_in_hardirq();
+
 	while (1) {
 		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
@@ -170,7 +175,10 @@ static ide_startstop_t set_geometry_intr
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->tp_ops->read_status(hwif);
+	u8 stat;
+
+	local_irq_enable_in_hardirq();
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
