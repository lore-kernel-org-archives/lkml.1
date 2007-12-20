Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbXLTByy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbXLTByy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbXLTBhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:37:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817AbXLTBem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=selYA12CAk0yyxNs/COutlrT3dKm/07I/OnLxZplacsMzdYDLZlQyBfRonr7J+CrBpVSol96zPcmEhjFbUga1107ZVk9KQHyo1gb/88fvwoc+vZLODF4S8pU2F0QqWc1lRhQJMAEyqKS8GfbQ3RJe8DogcGOZHMyKa47YBNoHgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 37/63] ide-cd: factor out ioctl handlers from ide_cdrom_audio_ioctl()
Date: Thu, 20 Dec 2007 02:21:32 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200221.32174.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |  142 ++++++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 67 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1977,6 +1977,24 @@ static int cdrom_read_toc(ide_drive_t *d
 	return 0;
 }
 
+static int ide_cd_read_tochdr(ide_drive_t *drive, void *arg)
+{
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_tochdr *tochdr = arg;
+	struct atapi_toc *toc;
+	int stat;
+
+	/* Make sure our saved TOC is valid. */
+	stat = cdrom_read_toc(drive, NULL);
+	if (stat)
+		return stat;
+
+	toc = cd->toc;
+	tochdr->cdth_trk0 = toc->hdr.first_track;
+	tochdr->cdth_trk1 = toc->hdr.last_track;
+
+	return 0;
+}
 
 static int cdrom_read_subchannel(ide_drive_t *drive, int format, char *buf,
 				 int buflen, struct request_sense *sense)
@@ -2071,6 +2089,55 @@ static int cdrom_get_toc_entry(ide_drive
 	return 0;
 }
 
+static int ide_cd_read_tocentry(ide_drive_t *drive, void *arg)
+{
+	struct cdrom_tocentry *tocentry = arg;
+	struct atapi_toc_entry *toce;
+	int stat;
+
+	stat = cdrom_get_toc_entry(drive, tocentry->cdte_track, &toce);
+	if (stat)
+		return stat;
+
+	tocentry->cdte_ctrl = toce->control;
+	tocentry->cdte_adr  = toce->adr;
+	if (tocentry->cdte_format == CDROM_MSF) {
+		lba_to_msf(toce->addr.lba,
+			   &tocentry->cdte_addr.msf.minute,
+			   &tocentry->cdte_addr.msf.second,
+			   &tocentry->cdte_addr.msf.frame);
+	} else
+		tocentry->cdte_addr.lba = toce->addr.lba;
+
+	return 0;
+}
+
+static int ide_cd_fake_play_trkind(ide_drive_t *drive, void *arg)
+{
+	struct cdrom_ti *ti = arg;
+	struct atapi_toc_entry *first_toc, *last_toc;
+	unsigned long lba_start, lba_end;
+	int stat;
+
+	stat = cdrom_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
+	if (stat)
+		return stat;
+
+	stat = cdrom_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
+	if (stat)
+		return stat;
+
+	if (ti->cdti_trk1 != CDROM_LEADOUT)
+		++last_toc;
+	lba_start = first_toc->addr.lba;
+	lba_end   = last_toc->addr.lba;
+
+	if (lba_end <= lba_start)
+		return -EINVAL;
+
+	return cdrom_play_audio(drive, lba_start, lba_end);
+}
+
 /* the generic packet interface to cdrom.c */
 static int ide_cdrom_packet(struct cdrom_device_info *cdi,
 			    struct packet_command *cgc)
@@ -2102,81 +2169,22 @@ static int ide_cdrom_packet(struct cdrom
 	return cgc->stat;
 }
 
-static
-int ide_cdrom_audio_ioctl (struct cdrom_device_info *cdi,
-			   unsigned int cmd, void *arg)
-			   
+static int ide_cdrom_audio_ioctl(struct cdrom_device_info *cdi,
+				 unsigned int cmd, void *arg)
 {
 	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *info = drive->driver_data;
-	int stat;
 
 	switch (cmd) {
 	/*
 	 * emulate PLAY_AUDIO_TI command with PLAY_AUDIO_10, since
 	 * atapi doesn't support it
 	 */
-	case CDROMPLAYTRKIND: {
-		unsigned long lba_start, lba_end;
-		struct cdrom_ti *ti = arg;
-		struct atapi_toc_entry *first_toc, *last_toc;
-
-		stat = cdrom_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
-		if (stat)
-			return stat;
-
-		stat = cdrom_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
-		if (stat)
-			return stat;
-
-		if (ti->cdti_trk1 != CDROM_LEADOUT)
-			++last_toc;
-		lba_start = first_toc->addr.lba;
-		lba_end   = last_toc->addr.lba;
-
-		if (lba_end <= lba_start)
-			return -EINVAL;
-
-		return cdrom_play_audio(drive, lba_start, lba_end);
-	}
-
-	case CDROMREADTOCHDR: {
-		struct cdrom_tochdr *tochdr = arg;
-		struct atapi_toc *toc;
-
-		/* Make sure our saved TOC is valid. */
-		stat = cdrom_read_toc(drive, NULL);
-		if (stat)
-			return stat;
-
-		toc = info->toc;
-		tochdr->cdth_trk0 = toc->hdr.first_track;
-		tochdr->cdth_trk1 = toc->hdr.last_track;
-
-		return 0;
-	}
-
-	case CDROMREADTOCENTRY: {
-		struct cdrom_tocentry *tocentry = arg;
-		struct atapi_toc_entry *toce;
-
-		stat = cdrom_get_toc_entry(drive, tocentry->cdte_track, &toce);
-		if (stat)
-			return stat;
-
-		tocentry->cdte_ctrl = toce->control;
-		tocentry->cdte_adr  = toce->adr;
-		if (tocentry->cdte_format == CDROM_MSF) {
-			lba_to_msf (toce->addr.lba,
-				   &tocentry->cdte_addr.msf.minute,
-				   &tocentry->cdte_addr.msf.second,
-				   &tocentry->cdte_addr.msf.frame);
-		} else
-			tocentry->cdte_addr.lba = toce->addr.lba;
-
-		return 0;
-	}
-
+	case CDROMPLAYTRKIND:
+		return ide_cd_fake_play_trkind(drive, arg);
+	case CDROMREADTOCHDR:
+		return ide_cd_read_tochdr(drive, arg);
+	case CDROMREADTOCENTRY:
+		return ide_cd_read_tocentry(drive, arg);
 	default:
 		return -EINVAL;
 	}
