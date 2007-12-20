Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbXLTBwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbXLTBwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXLTBg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:12581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbXLTBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fpXWwc2xVev5g46POqCXELSt5QGj+S3LoMvzHU3Q/QOksBqqB+F9WvlRCBP4vjdKA/ydRW+HTbRPxPxebyob94Cp3/RF6TVKSVgPvVD7gKfVcwuu1EOxpYpdYbuM8Q9n++NP3hGB/JpVXCNrux7H1GsymqkwO8os6A6Czwa4JY8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 44/63] ide-cd: move code handling cdrom.c IOCTLs to ide-cd_ioctl.c
Date: Thu, 20 Dec 2007 02:26:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200226.27127.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile       |    2 
 drivers/ide/ide-cd.c       |  271 +--------------------------------------------
 drivers/ide/ide-cd.h       |   17 ++
 drivers/ide/ide-cd_ioctl.c |  265 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 290 insertions(+), 265 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp
 obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 
-ide-cd_mod-y += ide-cd.o ide-cd_verbose.o
+ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 
 obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -206,7 +206,7 @@ void cdrom_analyze_sense_data(ide_drive_
 /*
  * Initialize a ide-cd packet command request
  */
-static void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
+void ide_cd_init_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
 
@@ -1168,7 +1168,7 @@ static ide_startstop_t cdrom_do_packet_c
 	return cdrom_start_packet_command(drive, len, cdrom_do_pc_continuation);
 }
 
-static int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
+int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
 {
 	struct request_sense sense;
 	int retries = 10;
@@ -1664,8 +1664,8 @@ static int cdrom_check_status(ide_drive_
 }
 
 /* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
-static int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
-			   struct request_sense *sense)
+int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
+		    struct request_sense *sense)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct request_sense my_sense;
@@ -1796,9 +1796,8 @@ static int cdrom_read_tocentry(ide_drive
 	return ide_cd_queue_pc(drive, &req);
 }
 
-
 /* Try to read the entire TOC for the disk into our internal buffer. */
-static int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
+int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 {
 	int stat, ntracks, i;
 	struct cdrom_info *info = drive->driver_data;
@@ -1958,112 +1957,6 @@ static int ide_cd_read_toc(ide_drive_t *
 	return 0;
 }
 
-static int ide_cd_read_tochdr(ide_drive_t *drive, void *arg)
-{
-	struct cdrom_info *cd = drive->driver_data;
-	struct cdrom_tochdr *tochdr = arg;
-	struct atapi_toc *toc;
-	int stat;
-
-	/* Make sure our saved TOC is valid. */
-	stat = ide_cd_read_toc(drive, NULL);
-	if (stat)
-		return stat;
-
-	toc = cd->toc;
-	tochdr->cdth_trk0 = toc->hdr.first_track;
-	tochdr->cdth_trk1 = toc->hdr.last_track;
-
-	return 0;
-}
-
-static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
-				struct atapi_toc_entry **ent)
-{
-	struct cdrom_info *info = drive->driver_data;
-	struct atapi_toc *toc = info->toc;
-	int ntracks;
-
-	/*
-	 * don't serve cached data, if the toc isn't valid
-	 */
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0)
-		return -EINVAL;
-
-	/* Check validity of requested track number. */
-	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
-
-	if (toc->hdr.first_track == CDROM_LEADOUT)
-		ntracks = 0;
-
-	if (track == CDROM_LEADOUT)
-		*ent = &toc->ent[ntracks];
-	else if (track < toc->hdr.first_track || track > toc->hdr.last_track)
-		return -EINVAL;
-	else
-		*ent = &toc->ent[track - toc->hdr.first_track];
-
-	return 0;
-}
-
-static int ide_cd_read_tocentry(ide_drive_t *drive, void *arg)
-{
-	struct cdrom_tocentry *tocentry = arg;
-	struct atapi_toc_entry *toce;
-	int stat;
-
-	stat = ide_cd_get_toc_entry(drive, tocentry->cdte_track, &toce);
-	if (stat)
-		return stat;
-
-	tocentry->cdte_ctrl = toce->control;
-	tocentry->cdte_adr  = toce->adr;
-	if (tocentry->cdte_format == CDROM_MSF) {
-		lba_to_msf(toce->addr.lba,
-			   &tocentry->cdte_addr.msf.minute,
-			   &tocentry->cdte_addr.msf.second,
-			   &tocentry->cdte_addr.msf.frame);
-	} else
-		tocentry->cdte_addr.lba = toce->addr.lba;
-
-	return 0;
-}
-
-static int ide_cd_fake_play_trkind(ide_drive_t *drive, void *arg)
-{
-	struct cdrom_ti *ti = arg;
-	struct atapi_toc_entry *first_toc, *last_toc;
-	unsigned long lba_start, lba_end;
-	int stat;
-	struct request rq;
-	struct request_sense sense;
-
-	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
-	if (stat)
-		return stat;
-
-	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
-	if (stat)
-		return stat;
-
-	if (ti->cdti_trk1 != CDROM_LEADOUT)
-		++last_toc;
-	lba_start = first_toc->addr.lba;
-	lba_end   = last_toc->addr.lba;
-
-	if (lba_end <= lba_start)
-		return -EINVAL;
-
-	ide_cd_init_rq(drive, &rq);
-
-	rq.sense = &sense;
-	rq.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
-	lba_to_msf(lba_start,   &rq.cmd[3], &rq.cmd[4], &rq.cmd[5]);
-	lba_to_msf(lba_end - 1, &rq.cmd[6], &rq.cmd[7], &rq.cmd[8]);
-
-	return ide_cd_queue_pc(drive, &rq);
-}
-
 /* the generic packet interface to cdrom.c */
 static int ide_cdrom_packet(struct cdrom_device_info *cdi,
 			    struct packet_command *cgc)
@@ -2095,52 +1988,6 @@ static int ide_cdrom_packet(struct cdrom
 	return cgc->stat;
 }
 
-static int ide_cdrom_audio_ioctl(struct cdrom_device_info *cdi,
-				 unsigned int cmd, void *arg)
-{
-	ide_drive_t *drive = cdi->handle;
-
-	switch (cmd) {
-	/*
-	 * emulate PLAY_AUDIO_TI command with PLAY_AUDIO_10, since
-	 * atapi doesn't support it
-	 */
-	case CDROMPLAYTRKIND:
-		return ide_cd_fake_play_trkind(drive, arg);
-	case CDROMREADTOCHDR:
-		return ide_cd_read_tochdr(drive, arg);
-	case CDROMREADTOCENTRY:
-		return ide_cd_read_tocentry(drive, arg);
-	default:
-		return -EINVAL;
-	}
-}
-
-static
-int ide_cdrom_reset (struct cdrom_device_info *cdi)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
-	struct request_sense sense;
-	struct request req;
-	int ret;
-
-	ide_cd_init_rq(drive, &req);
-	req.cmd_type = REQ_TYPE_SPECIAL;
-	req.cmd_flags = REQ_QUIET;
-	ret = ide_do_drive_cmd(drive, &req, ide_wait);
-
-	/*
-	 * A reset will unlock the door. If it was previously locked,
-	 * lock it again.
-	 */
-	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
-		(void)ide_cd_lockdoor(drive, 1, &sense);
-
-	return ret;
-}
-
-
 static
 int ide_cdrom_tray_move (struct cdrom_device_info *cdi, int position)
 {
@@ -2157,15 +2004,7 @@ int ide_cdrom_tray_move (struct cdrom_de
 	return cdrom_eject(drive, !position, &sense);
 }
 
-static
-int ide_cdrom_lock_door (struct cdrom_device_info *cdi, int lock)
-{
-	ide_drive_t *drive = cdi->handle;
-
-	return ide_cd_lockdoor(drive, lock, NULL);
-}
-
-static int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
+int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 {
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
@@ -2184,7 +2023,7 @@ static int ide_cdrom_get_capabilities(id
 	return stat;
 }
 
-static void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
+void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
@@ -2205,49 +2044,6 @@ static void ide_cdrom_update_speed(ide_d
 }
 
 /*
- * ATAPI devices are free to select the speed you request or any slower
- * rate. :-(  Requesting too fast a speed will _not_ produce an error.
- */
-static int ide_cdrom_select_speed(struct cdrom_device_info *cdi, int speed)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
-	struct request rq;
-	struct request_sense sense;
-	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
-	int stat;
-
-	ide_cd_init_rq(drive, &rq);
-
-	rq.sense = &sense;
-
-	if (speed == 0)
-		speed = 0xffff; /* set to max */
-	else
-		speed *= 177;   /* Nx to kbytes/s */
-
-	rq.cmd[0] = GPCMD_SET_SPEED;
-	/* Read Drive speed in kbytes/second MSB/LSB */
-	rq.cmd[2] = (speed >> 8) & 0xff;
-	rq.cmd[3] = speed & 0xff;
-	if ((cdi->mask & (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) !=
-	    (CDC_CD_R | CDC_CD_RW | CDC_DVD_R)) {
-		/* Write Drive speed in kbytes/second MSB/LSB */
-		rq.cmd[4] = (speed >> 8) & 0xff;
-		rq.cmd[5] = speed & 0xff;
-	}
-
-	stat = ide_cd_queue_pc(drive, &rq);
-
-	if (!ide_cdrom_get_capabilities(drive, buf)) {
-		ide_cdrom_update_speed(drive, buf);
-		cdi->speed = cd->current_speed;
-	}
-
-	return 0;
-}
-
-/*
  * add logic to try GET_EVENT command first to check for media and tray
  * status. this should be supported by newer cd-r/w and all DVD etc
  * drives
@@ -2293,59 +2089,6 @@ int ide_cdrom_drive_status (struct cdrom
 	return CDS_DRIVE_NOT_READY;
 }
 
-static
-int ide_cdrom_get_last_session (struct cdrom_device_info *cdi,
-				struct cdrom_multisession *ms_info)
-{
-	struct atapi_toc *toc;
-	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *info = drive->driver_data;
-	struct request_sense sense;
-	int ret;
-
-	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || !info->toc) {
-		ret = ide_cd_read_toc(drive, &sense);
-		if (ret)
-			return ret;
-	}
-
-	toc = info->toc;
-	ms_info->addr.lba = toc->last_session_lba;
-	ms_info->xa_flag = toc->xa_flag;
-
-	return 0;
-}
-
-static int ide_cdrom_get_mcn(struct cdrom_device_info *cdi,
-			     struct cdrom_mcn *mcn_info)
-{
-	ide_drive_t *drive = cdi->handle;
-	int stat, mcnlen;
-	struct request rq;
-	char buf[24];
-
-	ide_cd_init_rq(drive, &rq);
-
-	rq.data = buf;
-	rq.data_len = sizeof(buf);
-
-	rq.cmd[0] = GPCMD_READ_SUBCHANNEL;
-	rq.cmd[1] = 2;		/* MSF addressing */
-	rq.cmd[2] = 0x40;	/* request subQ data */
-	rq.cmd[3] = 2;		/* format */
-	rq.cmd[8] = sizeof(buf);
-
-	stat = ide_cd_queue_pc(drive, &rq);
-	if (stat)
-		return stat;
-
-	mcnlen = sizeof(mcn_info->medium_catalog_number) - 1;
-	memcpy(mcn_info->medium_catalog_number, buf + 9, mcnlen);
-	mcn_info->medium_catalog_number[mcnlen] = '\0';
-
-	return 0;
-}
-
 /****************************************************************************
  * Other driver requests (open, close, check media change).
  */
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -148,4 +148,21 @@ struct cdrom_info {
 /* ide-cd_verbose.c */
 void ide_cd_log_error(const char *, struct request *, struct request_sense *);
 
+/* ide-cd.c functions used by ide-cd_ioctl.c */
+void ide_cd_init_rq(ide_drive_t *, struct request *);
+int ide_cd_queue_pc(ide_drive_t *, struct request *);
+int ide_cd_lockdoor(ide_drive_t *, int, struct request_sense *);
+int ide_cd_read_toc(ide_drive_t *, struct request_sense *);
+int ide_cdrom_get_capabilities(ide_drive_t *, u8 *);
+void ide_cdrom_update_speed(ide_drive_t *, u8 *);
+
+/* ide-cd_ioctl.c */
+int ide_cdrom_lock_door(struct cdrom_device_info *, int);
+int ide_cdrom_select_speed(struct cdrom_device_info *, int);
+int ide_cdrom_get_last_session(struct cdrom_device_info *,
+			       struct cdrom_multisession *);
+int ide_cdrom_get_mcn(struct cdrom_device_info *, struct cdrom_mcn *);
+int ide_cdrom_reset(struct cdrom_device_info *cdi);
+int ide_cdrom_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
+
 #endif /* _IDE_CD_H */
Index: b/drivers/ide/ide-cd_ioctl.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -0,0 +1,265 @@
+/*
+ * cdrom.c IOCTLs handling for ide-cd driver.
+ *
+ * Copyright (C) 1994-1996  Scott Snyder <snyder@fnald0.fnal.gov>
+ * Copyright (C) 1996-1998  Erik Andersen <andersee@debian.org>
+ * Copyright (C) 1998-2000  Jens Axboe <axboe@suse.de>
+ */
+
+#include <linux/kernel.h>
+#include <linux/cdrom.h>
+#include <linux/ide.h>
+
+#include "ide-cd.h"
+
+int ide_cdrom_lock_door(struct cdrom_device_info *cdi, int lock)
+{
+	ide_drive_t *drive = cdi->handle;
+
+	return ide_cd_lockdoor(drive, lock, NULL);
+}
+
+/*
+ * ATAPI devices are free to select the speed you request or any slower
+ * rate. :-(  Requesting too fast a speed will _not_ produce an error.
+ */
+int ide_cdrom_select_speed(struct cdrom_device_info *cdi, int speed)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
+	struct request rq;
+	struct request_sense sense;
+	u8 buf[ATAPI_CAPABILITIES_PAGE_SIZE];
+	int stat;
+
+	ide_cd_init_rq(drive, &rq);
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
+	stat = ide_cd_queue_pc(drive, &rq);
+
+	if (!ide_cdrom_get_capabilities(drive, buf)) {
+		ide_cdrom_update_speed(drive, buf);
+		cdi->speed = cd->current_speed;
+	}
+
+	return 0;
+}
+
+int ide_cdrom_get_last_session(struct cdrom_device_info *cdi,
+			       struct cdrom_multisession *ms_info)
+{
+	struct atapi_toc *toc;
+	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *info = drive->driver_data;
+	struct request_sense sense;
+	int ret;
+
+	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0 || !info->toc) {
+		ret = ide_cd_read_toc(drive, &sense);
+		if (ret)
+			return ret;
+	}
+
+	toc = info->toc;
+	ms_info->addr.lba = toc->last_session_lba;
+	ms_info->xa_flag = toc->xa_flag;
+
+	return 0;
+}
+
+int ide_cdrom_get_mcn(struct cdrom_device_info *cdi,
+		      struct cdrom_mcn *mcn_info)
+{
+	ide_drive_t *drive = cdi->handle;
+	int stat, mcnlen;
+	struct request rq;
+	char buf[24];
+
+	ide_cd_init_rq(drive, &rq);
+
+	rq.data = buf;
+	rq.data_len = sizeof(buf);
+
+	rq.cmd[0] = GPCMD_READ_SUBCHANNEL;
+	rq.cmd[1] = 2;		/* MSF addressing */
+	rq.cmd[2] = 0x40;	/* request subQ data */
+	rq.cmd[3] = 2;		/* format */
+	rq.cmd[8] = sizeof(buf);
+
+	stat = ide_cd_queue_pc(drive, &rq);
+	if (stat)
+		return stat;
+
+	mcnlen = sizeof(mcn_info->medium_catalog_number) - 1;
+	memcpy(mcn_info->medium_catalog_number, buf + 9, mcnlen);
+	mcn_info->medium_catalog_number[mcnlen] = '\0';
+
+	return 0;
+}
+
+int ide_cdrom_reset(struct cdrom_device_info *cdi)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
+	struct request_sense sense;
+	struct request req;
+	int ret;
+
+	ide_cd_init_rq(drive, &req);
+	req.cmd_type = REQ_TYPE_SPECIAL;
+	req.cmd_flags = REQ_QUIET;
+	ret = ide_do_drive_cmd(drive, &req, ide_wait);
+
+	/*
+	 * A reset will unlock the door. If it was previously locked,
+	 * lock it again.
+	 */
+	if (cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED)
+		(void)ide_cd_lockdoor(drive, 1, &sense);
+
+	return ret;
+}
+
+static int ide_cd_get_toc_entry(ide_drive_t *drive, int track,
+				struct atapi_toc_entry **ent)
+{
+	struct cdrom_info *info = drive->driver_data;
+	struct atapi_toc *toc = info->toc;
+	int ntracks;
+
+	/*
+	 * don't serve cached data, if the toc isn't valid
+	 */
+	if ((info->cd_flags & IDE_CD_FLAG_TOC_VALID) == 0)
+		return -EINVAL;
+
+	/* Check validity of requested track number. */
+	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
+
+	if (toc->hdr.first_track == CDROM_LEADOUT)
+		ntracks = 0;
+
+	if (track == CDROM_LEADOUT)
+		*ent = &toc->ent[ntracks];
+	else if (track < toc->hdr.first_track || track > toc->hdr.last_track)
+		return -EINVAL;
+	else
+		*ent = &toc->ent[track - toc->hdr.first_track];
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
+	struct request rq;
+	struct request_sense sense;
+
+	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk0, &first_toc);
+	if (stat)
+		return stat;
+
+	stat = ide_cd_get_toc_entry(drive, ti->cdti_trk1, &last_toc);
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
+	ide_cd_init_rq(drive, &rq);
+
+	rq.sense = &sense;
+	rq.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
+	lba_to_msf(lba_start,   &rq.cmd[3], &rq.cmd[4], &rq.cmd[5]);
+	lba_to_msf(lba_end - 1, &rq.cmd[6], &rq.cmd[7], &rq.cmd[8]);
+
+	return ide_cd_queue_pc(drive, &rq);
+}
+
+static int ide_cd_read_tochdr(ide_drive_t *drive, void *arg)
+{
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_tochdr *tochdr = arg;
+	struct atapi_toc *toc;
+	int stat;
+
+	/* Make sure our saved TOC is valid. */
+	stat = ide_cd_read_toc(drive, NULL);
+	if (stat)
+		return stat;
+
+	toc = cd->toc;
+	tochdr->cdth_trk0 = toc->hdr.first_track;
+	tochdr->cdth_trk1 = toc->hdr.last_track;
+
+	return 0;
+}
+
+static int ide_cd_read_tocentry(ide_drive_t *drive, void *arg)
+{
+	struct cdrom_tocentry *tocentry = arg;
+	struct atapi_toc_entry *toce;
+	int stat;
+
+	stat = ide_cd_get_toc_entry(drive, tocentry->cdte_track, &toce);
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
+int ide_cdrom_audio_ioctl(struct cdrom_device_info *cdi,
+			  unsigned int cmd, void *arg)
+{
+	ide_drive_t *drive = cdi->handle;
+
+	switch (cmd) {
+	/*
+	 * emulate PLAY_AUDIO_TI command with PLAY_AUDIO_10, since
+	 * atapi doesn't support it
+	 */
+	case CDROMPLAYTRKIND:
+		return ide_cd_fake_play_trkind(drive, arg);
+	case CDROMREADTOCHDR:
+		return ide_cd_read_tochdr(drive, arg);
+	case CDROMREADTOCENTRY:
+		return ide_cd_read_tocentry(drive, arg);
+	default:
+		return -EINVAL;
+	}
+}
