Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXLTB6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXLTB6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbXLTBea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbXLTBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xs0CkR3TgwB+SAnN2l0ZIUlBuN7sw/aUZMy+t+Ujra9qfsMsrUU3920oblWHGBuBZFICPINOKqzdILiL8AMojGH4F7cLwnCmWcgcdr/6w62+URDHZqAol21M+cAZrLw3xRzpzKlrpurF0JEzee7ULjgpDabArYugMYULcD8I0KU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 03/63] ide-cd: use ide_cd_release() in ide_cd_probe()
Date: Thu, 20 Dec 2007 01:52:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200152.28958.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use ide_cd_release() to do the cleanup if ide_cdrom_setup() fails.

It fixes:
- the default drive->dsc_overlap value not being restored
- the default drive->queue's prep_rq_fn not being restored
- struct gendisk 'g' not being freed
- wrong function name being reported on unregister_cdrom() error

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-164 bytes
 drivers/ide/ide-cd.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -3501,15 +3501,8 @@ static int ide_cd_probe(ide_drive_t *dri
 	g->driverfs_dev = &drive->gendev;
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
-		struct cdrom_device_info *devinfo = &info->devinfo;
 		ide_proc_unregister_driver(drive, &ide_cdrom_driver);
-		kfree(info->buffer);
-		kfree(info->toc);
-		kfree(info->changer_info);
-		if (devinfo->handle == drive && unregister_cdrom(devinfo))
-			printk (KERN_ERR "%s: ide_cdrom_cleanup failed to unregister device from the cdrom 
driver.\n", drive->name);
-		kfree(info);
-		drive->driver_data = NULL;
+		ide_cd_release(&info->kref);
 		goto failed;
 	}
 
