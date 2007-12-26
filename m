Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXLZV4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXLZV4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 16:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXLZV4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 16:56:44 -0500
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:41350 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbXLZV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 16:56:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Pmju1z/k3l6THxIMCDgQbEdaVrjHzT7wSN6AGgLLltdk0ATVHOchqkPH7RpUgDy6scdK1vZkMgwaMSsQoaLoyJ/06bbGlOGeLtgls7OVLaczcmQ9CW/XPfkQpkbZt7ngbreq7YluHQWwBYnvrh3iUw08kYbnIWRS2q1N2GwStXM=  ;
X-YMail-OSG: tdDKyLcVM1nRYUacE4.pi0PeMLfuy0fewmN_EAIaeB77xzpNHMctJuj1uGq9jnqbpaeKbTm60.IqJ3EcuAH7XwZNtvLYg8Sc95xVSGU7CAj73OZKNhG.vqKWhjODITkFVN9n2FZt
Date: Wed, 26 Dec 2007 22:54:32 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide-cd: move the remaining cdrom.c ioctl handling code
	to ide-cd_ioctl.c
Message-ID: <20071226215431.GA11415@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20071226205014.GA7228@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071226205014.GA7228@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 09:50:14PM +0100, Borislav Petkov wrote:

Actually you should drop the previous one for it wasn't incomplete. Here's,
hopefully, a better one :).
--
From: Borislav Petkov <bbpetkov@yahoo.de>

There should be no functional changes from this.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

---
 drivers/ide/ide-cd.c       |  217 +-------------------------------------------
 drivers/ide/ide-cd.h       |    8 ++-
 drivers/ide/ide-cd_ioctl.c |  210 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+), 217 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 23d4987..07e850d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1396,7 +1396,7 @@ void msf_from_bcd (struct atapi_msf *msf)
 	msf->frame  = BCD2BIN(msf->frame);
 }
 
-static int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
+int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 {
 	struct request req;
 	struct cdrom_info *info = drive->driver_data;
@@ -1417,85 +1417,6 @@ static int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	return ide_cd_queue_pc(drive, &req);
 }
 
-/* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
-int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
-		    struct request_sense *sense)
-{
-	struct cdrom_info *cd = drive->driver_data;
-	struct request_sense my_sense;
-	struct request req;
-	int stat;
-
-	if (sense == NULL)
-		sense = &my_sense;
-
-	/* If the drive cannot lock the door, just pretend. */
-	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
-		stat = 0;
-	} else {
-		ide_cd_init_rq(drive, &req);
-		req.sense = sense;
-		req.cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
-		req.cmd[4] = lockflag ? 1 : 0;
-		stat = ide_cd_queue_pc(drive, &req);
-	}
-
-	/* If we got an illegal field error, the drive
-	   probably cannot lock the door. */
-	if (stat != 0 &&
-	    sense->sense_key == ILLEGAL_REQUEST &&
-	    (sense->asc == 0x24 || sense->asc == 0x20)) {
-		printk (KERN_ERR "%s: door locking not supported\n",
-			drive->name);
-		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
-		stat = 0;
-	}
-	
-	/* no medium, that's alright. */
-	if (stat != 0 && sense->sense_key == NOT_READY && sense->asc == 0x3a)
-		stat = 0;
-
-	if (stat == 0) {
-		if (lockflag)
-			cd->cd_flags |= IDE_CD_FLAG_DOOR_LOCKED;
-		else
-			cd->cd_flags &= ~IDE_CD_FLAG_DOOR_LOCKED;
-	}
-
-	return stat;
-}
-
-
-/* Eject the disk if EJECTFLAG is 0.
-   If EJECTFLAG is 1, try to reload the disk. */
-static int cdrom_eject(ide_drive_t *drive, int ejectflag,
-		       struct request_sense *sense)
-{
-	struct cdrom_info *cd = drive->driver_data;
-	struct cdrom_device_info *cdi = &cd->devinfo;
-	struct request req;
-	char loej = 0x02;
-
-	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
-		return -EDRIVE_CANT_DO_THIS;
-
-	/* reload fails on some drives, if the tray is locked */
-	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
-		return 0;
-
-	ide_cd_init_rq(drive, &req);
-
-	/* only tell drive to close tray if open, if it can do that */
-	if (ejectflag && (cdi->mask & CDC_CLOSE_TRAY))
-		loej = 0;
-
-	req.sense = sense;
-	req.cmd[0] = GPCMD_START_STOP_UNIT;
-	req.cmd[4] = loej | (ejectflag != 0);
-
-	return ide_cd_queue_pc(drive, &req);
-}
-
 static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 			       unsigned long *sectors_per_frame,
 			       struct request_sense *sense)
@@ -1711,53 +1632,6 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	return 0;
 }
 
-/* the generic packet interface to cdrom.c */
-static int ide_cdrom_packet(struct cdrom_device_info *cdi,
-			    struct packet_command *cgc)
-{
-	struct request req;
-	ide_drive_t *drive = cdi->handle;
-
-	if (cgc->timeout <= 0)
-		cgc->timeout = ATAPI_WAIT_PC;
-
-	/* here we queue the commands from the uniform CD-ROM
-	   layer. the packet must be complete, as we do not
-	   touch it at all. */
-	ide_cd_init_rq(drive, &req);
-	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
-	if (cgc->sense)
-		memset(cgc->sense, 0, sizeof(struct request_sense));
-	req.data = cgc->buffer;
-	req.data_len = cgc->buflen;
-	req.timeout = cgc->timeout;
-
-	if (cgc->quiet)
-		req.cmd_flags |= REQ_QUIET;
-
-	req.sense = cgc->sense;
-	cgc->stat = ide_cd_queue_pc(drive, &req);
-	if (!cgc->stat)
-		cgc->buflen -= req.data_len;
-	return cgc->stat;
-}
-
-static
-int ide_cdrom_tray_move (struct cdrom_device_info *cdi, int position)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct request_sense sense;
-
-	if (position) {
-		int stat = ide_cd_lockdoor(drive, 0, &sense);
-
-		if (stat)
-			return stat;
-	}
-
-	return cdrom_eject(drive, !position, &sense);
-}
-
 int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -1797,95 +1671,6 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	cd->max_speed = (maxspeed + (176/2)) / 176;
 }
 
-/*
- * add logic to try GET_EVENT command first to check for media and tray
- * status. this should be supported by newer cd-r/w and all DVD etc
- * drives
- */
-static
-int ide_cdrom_drive_status (struct cdrom_device_info *cdi, int slot_nr)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct media_event_desc med;
-	struct request_sense sense;
-	int stat;
-
-	if (slot_nr != CDSL_CURRENT)
-		return -EINVAL;
-
-	stat = cdrom_check_status(drive, &sense);
-	if (!stat || sense.sense_key == UNIT_ATTENTION)
-		return CDS_DISC_OK;
-
-	if (!cdrom_get_media_event(cdi, &med)) {
-		if (med.media_present)
-			return CDS_DISC_OK;
-		else if (med.door_open)
-			return CDS_TRAY_OPEN;
-		else
-			return CDS_NO_DISC;
-	}
-
-	if (sense.sense_key == NOT_READY && sense.asc == 0x04 && sense.ascq == 0x04)
-		return CDS_DISC_OK;
-
-	/*
-	 * If not using Mt Fuji extended media tray reports,
-	 * just return TRAY_OPEN since ATAPI doesn't provide
-	 * any other way to detect this...
-	 */
-	if (sense.sense_key == NOT_READY) {
-		if (sense.asc == 0x3a && sense.ascq == 1)
-			return CDS_NO_DISC;
-		else
-			return CDS_TRAY_OPEN;
-	}
-	return CDS_DRIVE_NOT_READY;
-}
-
-/****************************************************************************
- * Other driver requests (open, close, check media change).
- */
-
-static
-int ide_cdrom_check_media_change_real (struct cdrom_device_info *cdi,
-				       int slot_nr)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
-	int retval;
-
-	if (slot_nr == CDSL_CURRENT) {
-		(void) cdrom_check_status(drive, NULL);
-		retval = (cd->cd_flags & IDE_CD_FLAG_MEDIA_CHANGED) ? 1 : 0;
-		cd->cd_flags &= ~IDE_CD_FLAG_MEDIA_CHANGED;
-		return retval;
-	} else {
-		return -EINVAL;
-	}
-}
-
-
-static
-int ide_cdrom_open_real (struct cdrom_device_info *cdi, int purpose)
-{
-	return 0;
-}
-
-/*
- * Close down the device.  Invalidate all cached blocks.
- */
-
-static
-void ide_cdrom_release_real (struct cdrom_device_info *cdi)
-{
-	ide_drive_t *drive = cdi->handle;
-	struct cdrom_info *cd = drive->driver_data;
-
-	if (!cdi->use_count)
-		cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
-}
-
 #define IDE_CD_CAPABILITIES \
 	(CDC_CLOSE_TRAY | CDC_OPEN_TRAY | CDC_LOCK | CDC_SELECT_SPEED | \
 	 CDC_SELECT_DISC | CDC_MULTI_SESSION | CDC_MCN | CDC_MEDIA_CHANGED | \
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 5343063..58ae663 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -151,12 +151,17 @@ void ide_cd_log_error(const char *, struct request *, struct request_sense *);
 /* ide-cd.c functions used by ide-cd_ioctl.c */
 void ide_cd_init_rq(ide_drive_t *, struct request *);
 int ide_cd_queue_pc(ide_drive_t *, struct request *);
-int ide_cd_lockdoor(ide_drive_t *, int, struct request_sense *);
 int ide_cd_read_toc(ide_drive_t *, struct request_sense *);
 int ide_cdrom_get_capabilities(ide_drive_t *, u8 *);
 void ide_cdrom_update_speed(ide_drive_t *, u8 *);
+int cdrom_check_status(ide_drive_t *, struct request_sense *);
 
 /* ide-cd_ioctl.c */
+int ide_cdrom_open_real(struct cdrom_device_info *, int);
+void ide_cdrom_release_real(struct cdrom_device_info *);
+int ide_cdrom_drive_status(struct cdrom_device_info *, int);
+int ide_cdrom_check_media_change_real(struct cdrom_device_info *, int);
+int ide_cdrom_tray_move(struct cdrom_device_info *, int);
 int ide_cdrom_lock_door(struct cdrom_device_info *, int);
 int ide_cdrom_select_speed(struct cdrom_device_info *, int);
 int ide_cdrom_get_last_session(struct cdrom_device_info *,
@@ -164,5 +169,6 @@ int ide_cdrom_get_last_session(struct cdrom_device_info *,
 int ide_cdrom_get_mcn(struct cdrom_device_info *, struct cdrom_mcn *);
 int ide_cdrom_reset(struct cdrom_device_info *cdi);
 int ide_cdrom_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
+int ide_cdrom_packet(struct cdrom_device_info *, struct packet_command *);
 
 #endif /* _IDE_CD_H */
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index ec698c4..b68284d 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -9,9 +9,188 @@
 #include <linux/kernel.h>
 #include <linux/cdrom.h>
 #include <linux/ide.h>
+#include <scsi/scsi.h>
 
 #include "ide-cd.h"
 
+/****************************************************************************
+ * Other driver requests (open, close, check media change).
+ */
+int ide_cdrom_open_real(struct cdrom_device_info *cdi, int purpose)
+{
+	return 0;
+}
+
+/*
+ * Close down the device.  Invalidate all cached blocks.
+ */
+void ide_cdrom_release_real(struct cdrom_device_info *cdi)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
+
+	if (!cdi->use_count)
+		cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
+}
+
+/*
+ * add logic to try GET_EVENT command first to check for media and tray
+ * status. this should be supported by newer cd-r/w and all DVD etc
+ * drives
+ */
+int ide_cdrom_drive_status(struct cdrom_device_info *cdi, int slot_nr)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct media_event_desc med;
+	struct request_sense sense;
+	int stat;
+
+	if (slot_nr != CDSL_CURRENT)
+		return -EINVAL;
+
+	stat = cdrom_check_status(drive, &sense);
+	if (!stat || sense.sense_key == UNIT_ATTENTION)
+		return CDS_DISC_OK;
+
+	if (!cdrom_get_media_event(cdi, &med)) {
+		if (med.media_present)
+			return CDS_DISC_OK;
+		else if (med.door_open)
+			return CDS_TRAY_OPEN;
+		else
+			return CDS_NO_DISC;
+	}
+
+	if (sense.sense_key == NOT_READY && sense.asc == 0x04
+			&& sense.ascq == 0x04)
+		return CDS_DISC_OK;
+
+	/*
+	 * If not using Mt Fuji extended media tray reports,
+	 * just return TRAY_OPEN since ATAPI doesn't provide
+	 * any other way to detect this...
+	 */
+	if (sense.sense_key == NOT_READY) {
+		if (sense.asc == 0x3a && sense.ascq == 1)
+			return CDS_NO_DISC;
+		else
+			return CDS_TRAY_OPEN;
+	}
+	return CDS_DRIVE_NOT_READY;
+}
+
+int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,
+				       int slot_nr)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct cdrom_info *cd = drive->driver_data;
+	int retval;
+
+	if (slot_nr == CDSL_CURRENT) {
+		(void) cdrom_check_status(drive, NULL);
+		retval = (cd->cd_flags & IDE_CD_FLAG_MEDIA_CHANGED) ? 1 : 0;
+		cd->cd_flags &= ~IDE_CD_FLAG_MEDIA_CHANGED;
+		return retval;
+	} else {
+		return -EINVAL;
+	}
+}
+
+/* Eject the disk if EJECTFLAG is 0.
+   If EJECTFLAG is 1, try to reload the disk. */
+static
+int cdrom_eject(ide_drive_t *drive, int ejectflag,
+		struct request_sense *sense)
+{
+	struct cdrom_info *cd = drive->driver_data;
+	struct cdrom_device_info *cdi = &cd->devinfo;
+	struct request req;
+	char loej = 0x02;
+
+	if ((cd->cd_flags & IDE_CD_FLAG_NO_EJECT) && !ejectflag)
+		return -EDRIVE_CANT_DO_THIS;
+
+	/* reload fails on some drives, if the tray is locked */
+	if ((cd->cd_flags & IDE_CD_FLAG_DOOR_LOCKED) && ejectflag)
+		return 0;
+
+	ide_cd_init_rq(drive, &req);
+
+	/* only tell drive to close tray if open, if it can do that */
+	if (ejectflag && (cdi->mask & CDC_CLOSE_TRAY))
+		loej = 0;
+
+	req.sense = sense;
+	req.cmd[0] = GPCMD_START_STOP_UNIT;
+	req.cmd[4] = loej | (ejectflag != 0);
+
+	return ide_cd_queue_pc(drive, &req);
+}
+
+/* Lock the door if LOCKFLAG is nonzero; unlock it otherwise. */
+static
+int ide_cd_lockdoor(ide_drive_t *drive, int lockflag,
+		    struct request_sense *sense)
+{
+	struct cdrom_info *cd = drive->driver_data;
+	struct request_sense my_sense;
+	struct request req;
+	int stat;
+
+	if (sense == NULL)
+		sense = &my_sense;
+
+	/* If the drive cannot lock the door, just pretend. */
+	if (cd->cd_flags & IDE_CD_FLAG_NO_DOORLOCK) {
+		stat = 0;
+	} else {
+		ide_cd_init_rq(drive, &req);
+		req.sense = sense;
+		req.cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
+		req.cmd[4] = lockflag ? 1 : 0;
+		stat = ide_cd_queue_pc(drive, &req);
+	}
+
+	/* If we got an illegal field error, the drive
+	   probably cannot lock the door. */
+	if (stat != 0 &&
+	    sense->sense_key == ILLEGAL_REQUEST &&
+	    (sense->asc == 0x24 || sense->asc == 0x20)) {
+		printk(KERN_ERR "%s: door locking not supported\n",
+			drive->name);
+		cd->cd_flags |= IDE_CD_FLAG_NO_DOORLOCK;
+		stat = 0;
+	}
+
+	/* no medium, that's alright. */
+	if (stat != 0 && sense->sense_key == NOT_READY && sense->asc == 0x3a)
+		stat = 0;
+
+	if (stat == 0) {
+		if (lockflag)
+			cd->cd_flags |= IDE_CD_FLAG_DOOR_LOCKED;
+		else
+			cd->cd_flags &= ~IDE_CD_FLAG_DOOR_LOCKED;
+	}
+
+	return stat;
+}
+
+int ide_cdrom_tray_move(struct cdrom_device_info *cdi, int position)
+{
+	ide_drive_t *drive = cdi->handle;
+	struct request_sense sense;
+
+	if (position) {
+		int stat = ide_cd_lockdoor(drive, 0, &sense);
+
+		if (stat)
+			return stat;
+	}
+
+	return cdrom_eject(drive, !position, &sense);
+}
+
 int ide_cdrom_lock_door(struct cdrom_device_info *cdi, int lock)
 {
 	ide_drive_t *drive = cdi->handle;
@@ -263,3 +442,34 @@ int ide_cdrom_audio_ioctl(struct cdrom_device_info *cdi,
 		return -EINVAL;
 	}
 }
+
+/* the generic packet interface to cdrom.c */
+int ide_cdrom_packet(struct cdrom_device_info *cdi,
+			    struct packet_command *cgc)
+{
+	struct request req;
+	ide_drive_t *drive = cdi->handle;
+
+	if (cgc->timeout <= 0)
+		cgc->timeout = ATAPI_WAIT_PC;
+
+	/* here we queue the commands from the uniform CD-ROM
+	   layer. the packet must be complete, as we do not
+	   touch it at all. */
+	ide_cd_init_rq(drive, &req);
+	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	if (cgc->sense)
+		memset(cgc->sense, 0, sizeof(struct request_sense));
+	req.data = cgc->buffer;
+	req.data_len = cgc->buflen;
+	req.timeout = cgc->timeout;
+
+	if (cgc->quiet)
+		req.cmd_flags |= REQ_QUIET;
+
+	req.sense = cgc->sense;
+	cgc->stat = ide_cd_queue_pc(drive, &req);
+	if (!cgc->stat)
+		cgc->buflen -= req.data_len;
+	return cgc->stat;
+}
-- 
Regards/Gruﬂ,
    Boris.
