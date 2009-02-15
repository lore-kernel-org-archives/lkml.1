Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZBOMJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZBOMJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBOMIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:24 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46201 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZBOMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fkr24GdCR2CnkXrGk4h3ZN8DuRmKiq8OUPWZ6v6jqN0hLP+17cAylzIklBiNYJy/Oy
         YrGjvYNOXq7zPfKYKgv4uV022GHuhE+Su0+Cl0SKWSjuaT00hzwqK6VNU6aM95G1+qrr
         v0GGcSvLJUYdJsnOhPYjXmI1ky2Mlli5dAjbQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/10] ide-tape: use flags query macros
Date: Sun, 15 Feb 2009 13:08:06 +0100
Message-Id: <1234699692-9452-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1b97d7a..fb391b9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -792,11 +792,11 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	stat = hwif->tp_ops->read_status(hwif);
 
-	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
+	if (!ide_drv_dsc_overlap(drive) &&
 	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
-	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
+	if (ide_drv_post_reset(drive)) {
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
@@ -1328,7 +1328,7 @@ static int idetape_init_read(ide_drive_t *drive)
 		 * No point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		if (ide_drv_dsc_overlap(drive)) {
 			bytes_read = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_READ, 0,
 							tape->merge_bh);
@@ -1604,7 +1604,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		 * point in issuing this if DSC overlap isn't supported, some
 		 * drives (Seagate STT3401A) will return an error.
 		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		if (ide_drv_dsc_overlap(drive)) {
 			ssize_t retval = idetape_queue_rw_tail(drive,
 							REQ_IDETAPE_WRITE, 0,
 							tape->merge_bh);
@@ -2216,7 +2216,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		(*(u16 *)&tape->caps[16] * 512) / tape->buffer_size,
 		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
-		(drive->dev_flags & IDE_DFLAG_USING_DMA) ? ", DMA" : "");
+		ide_drv_using_dma(drive) ? ", DMA" : "");
 
 	ide_proc_register_driver(drive, tape->driver);
 }
@@ -2357,7 +2357,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 	if (drive->media != ide_tape)
 		goto failed;
 
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) &&
+	if (ide_drv_id_read(drive) &&
 	    ide_check_atapi_device(drive, DRV_NAME) == 0) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
-- 
1.6.0.4

