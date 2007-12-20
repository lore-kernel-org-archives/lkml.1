Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbXLTBnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbXLTBnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbXLTBfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbXLTBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S3Qugi93r+V16p7enanCgj9pggkE+52Yd8zPRNL9kbzZ4hpkizZGNpM8wtuYOrT4bZrdtso/SzG+/OiqjounmgV7NdIYbPf7jeYvFSQNcQwTJ/d3M5hYCY9u8osOjfcJcUvNQZwncdjNkrfQsKDE5/dg3VxmjBTUaNLMm4qyyGM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 38/63] ide-cd: merge cdrom_play_audio() into ide_cd_fake_play_trkind()
Date: Thu, 20 Dec 2007 02:22:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200222.10008.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2047,21 +2047,6 @@ static int cdrom_select_speed(ide_drive_
 	return cdrom_queue_packet_command(drive, &req);
 }
 
-static int cdrom_play_audio(ide_drive_t *drive, int lba_start, int lba_end)
-{
-	struct request_sense sense;
-	struct request req;
-
-	cdrom_prepare_request(drive, &req);
-
-	req.sense = &sense;
-	req.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
-	lba_to_msf(lba_start, &req.cmd[3], &req.cmd[4], &req.cmd[5]);
-	lba_to_msf(lba_end-1, &req.cmd[6], &req.cmd[7], &req.cmd[8]);
-
-	return cdrom_queue_packet_command(drive, &req);
-}
-
 static int cdrom_get_toc_entry(ide_drive_t *drive, int track,
 				struct atapi_toc_entry **ent)
 {
@@ -2118,6 +2103,8 @@ static int ide_cd_fake_play_trkind(ide_d
 	struct atapi_toc_entry *first_toc, *last_toc;
 	unsigned long lba_start, lba_end;
 	int stat;
+	struct request rq;
+	struct request_sense sense;
 
 	stat = cdrom_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
 	if (stat)
@@ -2135,7 +2122,14 @@ static int ide_cd_fake_play_trkind(ide_d
 	if (lba_end <= lba_start)
 		return -EINVAL;
 
-	return cdrom_play_audio(drive, lba_start, lba_end);
+	cdrom_prepare_request(drive, &rq);
+
+	rq.sense = &sense;
+	rq.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
+	lba_to_msf(lba_start,   &rq.cmd[3], &rq.cmd[4], &rq.cmd[5]);
+	lba_to_msf(lba_end - 1, &rq.cmd[6], &rq.cmd[7], &rq.cmd[8]);
+
+	return cdrom_queue_packet_command(drive, &rq);
 }
 
 /* the generic packet interface to cdrom.c */
