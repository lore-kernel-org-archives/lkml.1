Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYINLib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYINLib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYINLgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:9557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYINLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=MfrSSYwk0F/dczKNvG1oMLY8k6u8q74i/ZSdDFzLaS7k3l2rUJka3Lf2om053tTCDC
         9QLcev59/Pw4VUTtYOTeJ68SLGl8TdAzo41xx+eBAIeIC9JwWYHEynQPpytRN4RH0psj
         +MyPIpn8W5JCXgfk3yZxX4MjW5kSCW7gyRIS0=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/10] ide-atapi: assign taskfile flags per device type
Date: Sun, 14 Sep 2008 13:35:52 +0200
Message-Id: <1221392158-3848-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 763acd7..df17401 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -550,6 +550,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
+	u32 tf_flags;
 	u16 bcount;
 	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
@@ -582,8 +583,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	if (!drive->dma)
 		pc->flags &= ~PC_FLAG_DMA_OK;
 
-	ide_pktcmd_tf_load(drive, scsi ? 0 : IDE_TFLAG_OUT_DEVICE, bcount,
-			   drive->dma);
+	if (scsi)
+		tf_flags = 0;
+	else if (drive->media == ide_cdrom || drive->media == ide_optical)
+		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
+	else
+		tf_flags = IDE_TFLAG_OUT_DEVICE;
+
+	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-- 
1.5.5.1

