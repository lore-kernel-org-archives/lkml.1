Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbXLTByS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbXLTByS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbXLTBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbXLTBeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=R3CMEo5sdeX+XBFoSNHP+UShC4zXA/endxINPYNXl8AEmDze8NvEVDA64ARRvu3zGe4XnhMq2LtBCOtISAwTYMU9I89VKpCSBv7kI6mVytG/IJX4kN2hjqDJgrOflLf0DrVJOux1znmbKqVs6rfhL6BCgbYMTtPiMaFNF0OvGkw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 39/63] ide-cd: merge cdrom_read_subchannel() into ide_cdrom_get_mcn()
Date: Thu, 20 Dec 2007 02:22:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200222.51336.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-19 bytes
 drivers/ide/ide-cd.c |   53 ++++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1996,25 +1996,6 @@ static int ide_cd_read_tochdr(ide_drive_
 	return 0;
 }
 
-static int cdrom_read_subchannel(ide_drive_t *drive, int format, char *buf,
-				 int buflen, struct request_sense *sense)
-{
-	struct request req;
-
-	cdrom_prepare_request(drive, &req);
-
-	req.sense = sense;
-	req.data = buf;
-	req.data_len = buflen;
-	req.cmd[0] = GPCMD_READ_SUBCHANNEL;
-	req.cmd[1] = 2;     /* MSF addressing */
-	req.cmd[2] = 0x40;  /* request subQ data */
-	req.cmd[3] = format;
-	req.cmd[7] = (buflen >> 8);
-	req.cmd[8] = (buflen & 0xff);
-	return cdrom_queue_packet_command(drive, &req);
-}
-
 /* ATAPI cdrom drives are free to select the speed you request or any slower
    rate :-( Requesting too fast a speed will _not_ produce an error. */
 static int cdrom_select_speed(ide_drive_t *drive, int speed,
@@ -2356,28 +2337,36 @@ int ide_cdrom_get_last_session (struct c
 	return 0;
 }
 
-static
-int ide_cdrom_get_mcn (struct cdrom_device_info *cdi,
-		       struct cdrom_mcn *mcn_info)
+static int ide_cdrom_get_mcn(struct cdrom_device_info *cdi,
+			     struct cdrom_mcn *mcn_info)
 {
-	int stat;
-	char mcnbuf[24];
 	ide_drive_t *drive = cdi->handle;
+	int stat, mcnlen;
+	struct request rq;
+	char buf[24];
+
+	cdrom_prepare_request(drive, &rq);
+
+	rq.data = buf;
+	rq.data_len = sizeof(buf);
 
-/* get MCN */
-	if ((stat = cdrom_read_subchannel(drive, 2, mcnbuf, sizeof (mcnbuf), NULL)))
+	rq.cmd[0] = GPCMD_READ_SUBCHANNEL;
+	rq.cmd[1] = 2;		/* MSF addressing */
+	rq.cmd[2] = 0x40;	/* request subQ data */
+	rq.cmd[3] = 2;		/* format */
+	rq.cmd[8] = sizeof(buf);
+
+	stat = cdrom_queue_packet_command(drive, &rq);
+	if (stat)
 		return stat;
 
-	memcpy (mcn_info->medium_catalog_number, mcnbuf+9,
-		sizeof (mcn_info->medium_catalog_number)-1);
-	mcn_info->medium_catalog_number[sizeof (mcn_info->medium_catalog_number)-1]
-		= '\0';
+	mcnlen = sizeof(mcn_info->medium_catalog_number) - 1;
+	memcpy(mcn_info->medium_catalog_number, buf + 9, mcnlen);
+	mcn_info->medium_catalog_number[mcnlen] = '\0';
 
 	return 0;
 }
 
-
-
 /****************************************************************************
  * Other driver requests (open, close, check media change).
  */
