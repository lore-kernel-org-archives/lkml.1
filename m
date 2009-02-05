Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZBEVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZBEVfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZBEVet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:34:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35382 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZBEVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=lKNT6RhTpsUrByMWWgPfaaDPfXdJGk0l5xDFIVXJd6+xFWA41d3EkjqUsRRkqlFoZi
         o45g+hJx0CbFTZdVlrywz45WEwP6K5z/RWxiExRGiKatW48jtA8zzd4hW+DjxytQnuPo
         m3XuYBQe0fqgLn+1xFmgyEl3O28+NWtrNI/8I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: use ide_complete_cmd() for REQ_UNPARK_HEADS
Date: Thu, 5 Feb 2009 21:29:51 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc3-next-20090204; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902052129.52047.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ide_complete_cmd() for REQ_UNPARK_HEADS

* Fixup ->tf_flags in ide_do_park_unpark() to match their current use.

* Use ide_complete_cmd() for REQ_UNPARK_HEADS.

While at it:

* No need to read Error register for PM requests in task_no_data_intr().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replaces "ide: use ide_complete_cmd() for PM commands" patch

[ as a result of 'take 2' of "ide: move request type specific
  code from ide_end_drive_cmd() to callers" patch ]

 drivers/ide/ide-park.c     |    4 ++--
 drivers/ide/ide-taskfile.c |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -74,11 +74,11 @@ ide_startstop_t ide_do_park_unpark(ide_d
 		tf->lbal = 0x4c;
 		tf->lbam = 0x4e;
 		tf->lbah = 0x55;
-		cmd.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	} else		/* cmd == REQ_UNPARK_HEADS */
 		tf->command = ATA_CMD_CHK_POWER;
 
-	cmd.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
 	cmd.protocol = ATA_PROT_NODATA;
 
 	cmd.rq = rq;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -149,16 +149,16 @@ static ide_startstop_t task_no_data_intr
 	if (custom && tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
-	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE) {
+	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE ||
+	    tf->command == ATA_CMD_CHK_POWER) {
 		struct request *rq = hwif->rq;
-		u8 err = ide_read_error(drive);
 
 		if (blk_pm_request(rq))
 			ide_complete_pm_rq(drive, rq);
 		else {
-			if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE ||
-			    tf->command == ATA_CMD_IDLEIMMEDIATE)
-				ide_complete_cmd(drive, cmd, stat, err);
+			u8 err = ide_read_error(drive);
+
+			ide_complete_cmd(drive, cmd, stat, err);
 			ide_complete_rq(drive, err);
 		}
 	}
