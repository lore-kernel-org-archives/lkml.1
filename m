Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbXLTByh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbXLTByh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbXLTBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbXLTBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d9Q5X3jn7fBUP9wQ27SozPH6V38lEQ0frsPGfPts6vMAgizMhuF0X9beRpYduzcHOBpVpblhQx32wX9jLhfGvthHY2mGJHADMRUmm+dCRc8Qpdd3oavICfabcmEmw9tW4VMaaoTRV6vRXqXDBXKTyJz7aqgl2T9mdb4iPP0a2To=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 40/63] ide-cd: merge cdrom_select_speed() into ide_cdrom_select_speed()
Date: Thu, 20 Dec 2007 02:23:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200223.31134.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-13 bytes
 drivers/ide/ide-cd.c |   66 ++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 37 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1996,38 +1996,6 @@ static int ide_cd_read_tochdr(ide_drive_
 	return 0;
 }
 
-/* ATAPI cdrom drives are free to select the speed you request or any slower
-   rate :-( Requesting too fast a speed will _not_ produce an error. */
-static int cdrom_select_speed(ide_drive_t *drive, int speed,
-			      struct request_sense *sense)
-{
-	struct cdrom_info *cd = drive->driver_data;
-	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct request req;
-	cdrom_prepare_request(drive, &req);
-
-	req.sense = sense;
-	if (speed == 0)
-		speed = 0xffff; /* set to max */
-	else
-		speed *= 177;   /* Nx to kbytes/s */
-
-	req.cmd[0] = GPCMD_SET_SPEED;
-	/* Read Drive speed in kbytes/second MSB */
-	req.cmd[2] = (speed >> 8) & 0xff;	
-	/* Read Drive speed in kbytes/second LSB */
-	req.cmd[3] = speed & 0xff;
-	if ((cdi->mask & (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) !=
-	    (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) {
-		/* Write Drive speed in kbytes/second MSB */
-		req.cmd[4] = (speed >> 8) & 0xff;
-		/* Write Drive speed in kbytes/second LSB */
-		req.cmd[5] = speed & 0xff;
-       }
-
-	return cdrom_queue_packet_command(drive, &req);
-}
-
 static int cdrom_get_toc_entry(ide_drive_t *drive, int track,
 				struct atapi_toc_entry **ent)
 {
@@ -2251,23 +2219,47 @@ static void ide_cdrom_update_speed(ide_d
 	cd->max_speed = (maxspeed + (176/2)) / 176;
 }
 
-static
-int ide_cdrom_select_speed (struct cdrom_device_info *cdi, int speed)
+/*
+ * ATAPI devices are free to select the speed you request or any slower
+ * rate. :-(  Requesting too fast a speed will _not_ produce an error.
+ */
+static int ide_cdrom_select_speed(struct cdrom_device_info *cdi, int speed)
 {
 	ide_drive_t *drive = cdi->handle;
 	struct cdrom_info *cd = drive->driver_data;
+	struct request rq;
 	struct request_sense sense;
 	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
 	int stat;
 
-	if ((stat = cdrom_select_speed(drive, speed, &sense)) < 0)
-		return stat;
+	cdrom_prepare_request(drive, &rq);
+
+	rq.sense = &sense;
+
+	if (speed == 0)
+		speed = 0xffff; /* set to max */
+	else
+		speed *= 177;   /* Nx to kbytes/s */
+
+	rq.cmd[0] = GPCMD_SET_SPEED;
+	/* Read Drive speed in kbytes/second MSB/LSB */
+	rq.cmd[2] = (speed >> 8) & 0xff;
+	rq.cmd[3] = speed & 0xff;
+	if ((cdi->mask & (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) !=
+	    (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) {
+		/* Write Drive speed in kbytes/second MSB/LSB */
+		rq.cmd[4] = (speed >> 8) & 0xff;
+		rq.cmd[5] = speed & 0xff;
+	}
+
+	stat = cdrom_queue_packet_command(drive, &rq);
 
 	if (!ide_cdrom_get_capabilities(drive, buf)) {
 		ide_cdrom_update_speed(drive, buf);
 		cdi->speed = cd->current_speed;
 	}
-        return 0;
+
+	return 0;
 }
 
 /*
