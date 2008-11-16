Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYKPSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYKPSFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYKPSFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:05:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:21921 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYKPSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qW60GUpiQ28/lYs5nQ0mCpLl6QJubJIREeUh9wA0+3J7pbatphepbNLCF64jCy+Lrj
         RBS0FLTn6+pRwCERLXR8MG5+XjPrAg8asyyoOa/EwQ+3WURXvPvD5zh5WYEo6LQdvACU
         S69ancGFAfhPtkcKXBeBlJwlq47plpB/g5Hdg=
Date: Sun, 16 Nov 2008 19:04:47 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] cdrom: split mmc_ioctl to lower stack usage
Message-ID: <20081116180437.GC6282@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkstack output:

Before:
mmc_ioctl:                  584

After:
mmc_ioctl_dvd_read_struct:  280
mmc_ioctl_cdrom_subchannel: 152
mmc_ioctl_cdrom_read_data:  120
mmc_ioctl_cdrom_volume:     104
mmc_ioctl_cdrom_read_audio: 104
(mmc_ioctl is inlined into cdrom_ioctl - 104 bytes)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/cdrom/cdrom.c |  570 ++++++++++++++++++++++++++++---------------------
 1 files changed, 329 insertions(+), 241 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d16b024..eb6f6ad 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2783,271 +2783,359 @@ static int cdrom_switch_blocksize(struct cdrom_device_info *cdi, int size)
 	return cdo->generic_packet(cdi, &cgc);
 }
 
-static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
-		     unsigned long arg)
-{		
-	struct cdrom_device_ops *cdo = cdi->ops;
-	struct packet_command cgc;
+static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
+					void __user *arg,
+					struct packet_command *cgc,
+					int cmd)
+{
 	struct request_sense sense;
-	unsigned char buffer[32];
-	int ret = 0;
-
-	memset(&cgc, 0, sizeof(cgc));
+	struct cdrom_msf msf;
+	int blocksize = 0, format = 0, lba;
+	int ret;
 
-	/* build a unified command and queue it through
-	   cdo->generic_packet() */
 	switch (cmd) {
 	case CDROMREADRAW:
+		blocksize = CD_FRAMESIZE_RAW;
+		break;
 	case CDROMREADMODE1:
-	case CDROMREADMODE2: {
-		struct cdrom_msf msf;
-		int blocksize = 0, format = 0, lba;
-		
-		switch (cmd) {
-		case CDROMREADRAW:
-			blocksize = CD_FRAMESIZE_RAW;
-			break;
-		case CDROMREADMODE1:
-			blocksize = CD_FRAMESIZE;
-			format = 2;
-			break;
-		case CDROMREADMODE2:
-			blocksize = CD_FRAMESIZE_RAW0;
-			break;
-		}
-		IOCTL_IN(arg, struct cdrom_msf, msf);
-		lba = msf_to_lba(msf.cdmsf_min0,msf.cdmsf_sec0,msf.cdmsf_frame0);
-		/* FIXME: we need upper bound checking, too!! */
-		if (lba < 0)
-			return -EINVAL;
-		cgc.buffer = kmalloc(blocksize, GFP_KERNEL);
-		if (cgc.buffer == NULL)
-			return -ENOMEM;
-		memset(&sense, 0, sizeof(sense));
-		cgc.sense = &sense;
-		cgc.data_direction = CGC_DATA_READ;
-		ret = cdrom_read_block(cdi, &cgc, lba, 1, format, blocksize);
-		if (ret && sense.sense_key==0x05 && sense.asc==0x20 && sense.ascq==0x00) {
-			/*
-			 * SCSI-II devices are not required to support
-			 * READ_CD, so let's try switching block size
-			 */
-			/* FIXME: switch back again... */
-			if ((ret = cdrom_switch_blocksize(cdi, blocksize))) {
-				kfree(cgc.buffer);
-				return ret;
-			}
-			cgc.sense = NULL;
-			ret = cdrom_read_cd(cdi, &cgc, lba, blocksize, 1);
-			ret |= cdrom_switch_blocksize(cdi, blocksize);
-		}
-		if (!ret && copy_to_user((char __user *)arg, cgc.buffer, blocksize))
-			ret = -EFAULT;
-		kfree(cgc.buffer);
+		blocksize = CD_FRAMESIZE;
+		format = 2;
+		break;
+	case CDROMREADMODE2:
+		blocksize = CD_FRAMESIZE_RAW0;
+		break;
+	}
+	IOCTL_IN(arg, struct cdrom_msf, msf);
+	lba = msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0, msf.cdmsf_frame0);
+	/* FIXME: we need upper bound checking, too!! */
+	if (lba < 0)
+		return -EINVAL;
+
+	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	if (cgc->buffer == NULL)
+		return -ENOMEM;
+
+	memset(&sense, 0, sizeof(sense));
+	cgc->sense = &sense;
+	cgc->data_direction = CGC_DATA_READ;
+	ret = cdrom_read_block(cdi, cgc, lba, 1, format, blocksize);
+	if (ret && sense.sense_key == 0x05 &&
+		   sense.asc == 0x20 &&
+		   sense.ascq == 0x00) {
+		/*
+		 * SCSI-II devices are not required to support
+		 * READ_CD, so let's try switching block size
+		 */
+		/* FIXME: switch back again... */
+		ret = cdrom_switch_blocksize(cdi, blocksize);
+		if (ret)
+			goto out;
+		cgc->sense = NULL;
+		ret = cdrom_read_cd(cdi, cgc, lba, blocksize, 1);
+		ret |= cdrom_switch_blocksize(cdi, blocksize);
+	}
+	if (!ret && copy_to_user(arg, cgc->buffer, blocksize))
+		ret = -EFAULT;
+out:
+	kfree(cgc->buffer);
+	return ret;
+}
+
+static noinline int mmc_ioctl_cdrom_read_audio(struct cdrom_device_info *cdi,
+					void __user *arg)
+{
+	struct cdrom_read_audio ra;
+	int lba;
+
+	IOCTL_IN(arg, struct cdrom_read_audio, ra);
+
+	if (ra.addr_format == CDROM_MSF)
+		lba = msf_to_lba(ra.addr.msf.minute,
+				 ra.addr.msf.second,
+				 ra.addr.msf.frame);
+	else if (ra.addr_format == CDROM_LBA)
+		lba = ra.addr.lba;
+	else
+		return -EINVAL;
+
+	/* FIXME: we need upper bound checking, too!! */
+	if (lba < 0 || ra.nframes <= 0 || ra.nframes > CD_FRAMES)
+		return -EINVAL;
+
+	return cdrom_read_cdda(cdi, ra.buf, lba, ra.nframes);
+}
+
+static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
+					void __user *arg)
+{
+	int ret;
+	struct cdrom_subchnl q;
+	u_char requested, back;
+	IOCTL_IN(arg, struct cdrom_subchnl, q);
+	requested = q.cdsc_format;
+	if (!((requested == CDROM_MSF) ||
+	      (requested == CDROM_LBA)))
+		return -EINVAL;
+	q.cdsc_format = CDROM_MSF;
+	ret = cdrom_read_subchannel(cdi, &q, 0);
+	if (ret)
 		return ret;
-		}
-	case CDROMREADAUDIO: {
-		struct cdrom_read_audio ra;
-		int lba;
-
-		IOCTL_IN(arg, struct cdrom_read_audio, ra);
-
-		if (ra.addr_format == CDROM_MSF)
-			lba = msf_to_lba(ra.addr.msf.minute,
-					 ra.addr.msf.second,
-					 ra.addr.msf.frame);
-		else if (ra.addr_format == CDROM_LBA)
-			lba = ra.addr.lba;
-		else
-			return -EINVAL;
+	back = q.cdsc_format; /* local copy */
+	sanitize_format(&q.cdsc_absaddr, &back, requested);
+	sanitize_format(&q.cdsc_reladdr, &q.cdsc_format, requested);
+	IOCTL_OUT(arg, struct cdrom_subchnl, q);
+	/* cdinfo(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
+	return 0;
+}
 
-		/* FIXME: we need upper bound checking, too!! */
-		if (lba < 0 || ra.nframes <= 0 || ra.nframes > CD_FRAMES)
-			return -EINVAL;
+static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
+					void __user *arg,
+					struct packet_command *cgc)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	struct cdrom_msf msf;
+	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
+	IOCTL_IN(arg, struct cdrom_msf, msf);
+	cgc->cmd[0] = GPCMD_PLAY_AUDIO_MSF;
+	cgc->cmd[3] = msf.cdmsf_min0;
+	cgc->cmd[4] = msf.cdmsf_sec0;
+	cgc->cmd[5] = msf.cdmsf_frame0;
+	cgc->cmd[6] = msf.cdmsf_min1;
+	cgc->cmd[7] = msf.cdmsf_sec1;
+	cgc->cmd[8] = msf.cdmsf_frame1;
+	cgc->data_direction = CGC_DATA_NONE;
+	return cdo->generic_packet(cdi, cgc);
+}
 
-		return cdrom_read_cdda(cdi, ra.buf, lba, ra.nframes);
-		}
-	case CDROMSUBCHNL: {
-		struct cdrom_subchnl q;
-		u_char requested, back;
-		IOCTL_IN(arg, struct cdrom_subchnl, q);
-		requested = q.cdsc_format;
-		if (!((requested == CDROM_MSF) ||
-		      (requested == CDROM_LBA)))
-			return -EINVAL;
-		q.cdsc_format = CDROM_MSF;
-		if ((ret = cdrom_read_subchannel(cdi, &q, 0)))
-			return ret;
-		back = q.cdsc_format; /* local copy */
-		sanitize_format(&q.cdsc_absaddr, &back, requested);
-		sanitize_format(&q.cdsc_reladdr, &q.cdsc_format, requested);
-		IOCTL_OUT(arg, struct cdrom_subchnl, q);
-		/* cdinfo(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */ 
-		return 0;
-		}
-	case CDROMPLAYMSF: {
-		struct cdrom_msf msf;
-		cdinfo(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
-		IOCTL_IN(arg, struct cdrom_msf, msf);
-		cgc.cmd[0] = GPCMD_PLAY_AUDIO_MSF;
-		cgc.cmd[3] = msf.cdmsf_min0;
-		cgc.cmd[4] = msf.cdmsf_sec0;
-		cgc.cmd[5] = msf.cdmsf_frame0;
-		cgc.cmd[6] = msf.cdmsf_min1;
-		cgc.cmd[7] = msf.cdmsf_sec1;
-		cgc.cmd[8] = msf.cdmsf_frame1;
-		cgc.data_direction = CGC_DATA_NONE;
-		return cdo->generic_packet(cdi, &cgc);
-		}
-	case CDROMPLAYBLK: {
-		struct cdrom_blk blk;
-		cdinfo(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
-		IOCTL_IN(arg, struct cdrom_blk, blk);
-		cgc.cmd[0] = GPCMD_PLAY_AUDIO_10;
-		cgc.cmd[2] = (blk.from >> 24) & 0xff;
-		cgc.cmd[3] = (blk.from >> 16) & 0xff;
-		cgc.cmd[4] = (blk.from >>  8) & 0xff;
-		cgc.cmd[5] = blk.from & 0xff;
-		cgc.cmd[7] = (blk.len >> 8) & 0xff;
-		cgc.cmd[8] = blk.len & 0xff;
-		cgc.data_direction = CGC_DATA_NONE;
-		return cdo->generic_packet(cdi, &cgc);
-		}
-	case CDROMVOLCTRL:
-	case CDROMVOLREAD: {
-		struct cdrom_volctrl volctrl;
-		char mask[sizeof(buffer)];
-		unsigned short offset;
+static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
+					void __user *arg,
+					struct packet_command *cgc)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	struct cdrom_blk blk;
+	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
+	IOCTL_IN(arg, struct cdrom_blk, blk);
+	cgc->cmd[0] = GPCMD_PLAY_AUDIO_10;
+	cgc->cmd[2] = (blk.from >> 24) & 0xff;
+	cgc->cmd[3] = (blk.from >> 16) & 0xff;
+	cgc->cmd[4] = (blk.from >>  8) & 0xff;
+	cgc->cmd[5] = blk.from & 0xff;
+	cgc->cmd[7] = (blk.len >> 8) & 0xff;
+	cgc->cmd[8] = blk.len & 0xff;
+	cgc->data_direction = CGC_DATA_NONE;
+	return cdo->generic_packet(cdi, cgc);
+}
 
-		cdinfo(CD_DO_IOCTL, "entering CDROMVOLUME\n");
+static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
+					void __user *arg,
+					struct packet_command *cgc,
+					unsigned int cmd)
+{
+	struct cdrom_volctrl volctrl;
+	unsigned char buffer[32];
+	char mask[sizeof(buffer)];
+	unsigned short offset;
+	int ret;
+
+	cdinfo(CD_DO_IOCTL, "entering CDROMVOLUME\n");
 
-		IOCTL_IN(arg, struct cdrom_volctrl, volctrl);
+	IOCTL_IN(arg, struct cdrom_volctrl, volctrl);
 
-		cgc.buffer = buffer;
-		cgc.buflen = 24;
-		if ((ret = cdrom_mode_sense(cdi, &cgc, GPMODE_AUDIO_CTL_PAGE, 0)))
-		    return ret;
+	cgc->buffer = buffer;
+	cgc->buflen = 24;
+	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 0);
+	if (ret)
+		return ret;
 		
-		/* originally the code depended on buffer[1] to determine
-		   how much data is available for transfer. buffer[1] is
-		   unfortunately ambigious and the only reliable way seem
-		   to be to simply skip over the block descriptor... */
-		offset = 8 + be16_to_cpu(*(__be16 *)(buffer+6));
-
-		if (offset + 16 > sizeof(buffer))
-			return -E2BIG;
-
-		if (offset + 16 > cgc.buflen) {
-			cgc.buflen = offset+16;
-			ret = cdrom_mode_sense(cdi, &cgc,
-						GPMODE_AUDIO_CTL_PAGE, 0);
-			if (ret)
-				return ret;
-		}
+	/* originally the code depended on buffer[1] to determine
+	   how much data is available for transfer. buffer[1] is
+	   unfortunately ambigious and the only reliable way seem
+	   to be to simply skip over the block descriptor... */
+	offset = 8 + be16_to_cpu(*(__be16 *)(buffer + 6));
+
+	if (offset + 16 > sizeof(buffer))
+		return -E2BIG;
+
+	if (offset + 16 > cgc->buflen) {
+		cgc->buflen = offset + 16;
+		ret = cdrom_mode_sense(cdi, cgc,
+					GPMODE_AUDIO_CTL_PAGE, 0);
+		if (ret)
+			return ret;
+	}
 
-		/* sanity check */
-		if ((buffer[offset] & 0x3f) != GPMODE_AUDIO_CTL_PAGE ||
-				buffer[offset+1] < 14)
-			return -EINVAL;
+	/* sanity check */
+	if ((buffer[offset] & 0x3f) != GPMODE_AUDIO_CTL_PAGE ||
+			buffer[offset + 1] < 14)
+		return -EINVAL;
 
-		/* now we have the current volume settings. if it was only
-		   a CDROMVOLREAD, return these values */
-		if (cmd == CDROMVOLREAD) {
-			volctrl.channel0 = buffer[offset+9];
-			volctrl.channel1 = buffer[offset+11];
-			volctrl.channel2 = buffer[offset+13];
-			volctrl.channel3 = buffer[offset+15];
-			IOCTL_OUT(arg, struct cdrom_volctrl, volctrl);
-			return 0;
-		}
+	/* now we have the current volume settings. if it was only
+	   a CDROMVOLREAD, return these values */
+	if (cmd == CDROMVOLREAD) {
+		volctrl.channel0 = buffer[offset+9];
+		volctrl.channel1 = buffer[offset+11];
+		volctrl.channel2 = buffer[offset+13];
+		volctrl.channel3 = buffer[offset+15];
+		IOCTL_OUT(arg, struct cdrom_volctrl, volctrl);
+		return 0;
+	}
 		
-		/* get the volume mask */
-		cgc.buffer = mask;
-		if ((ret = cdrom_mode_sense(cdi, &cgc, 
-				GPMODE_AUDIO_CTL_PAGE, 1)))
-			return ret;
+	/* get the volume mask */
+	cgc->buffer = mask;
+	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 1);
+	if (ret)
+		return ret;
 
-		buffer[offset+9] = volctrl.channel0 & mask[offset+9];
-		buffer[offset+11] = volctrl.channel1 & mask[offset+11];
-		buffer[offset+13] = volctrl.channel2 & mask[offset+13];
-		buffer[offset+15] = volctrl.channel3 & mask[offset+15];
+	buffer[offset + 9]  = volctrl.channel0 & mask[offset + 9];
+	buffer[offset + 11] = volctrl.channel1 & mask[offset + 11];
+	buffer[offset + 13] = volctrl.channel2 & mask[offset + 13];
+	buffer[offset + 15] = volctrl.channel3 & mask[offset + 15];
 
-		/* set volume */
-		cgc.buffer = buffer + offset - 8;
-		memset(cgc.buffer, 0, 8);
-		return cdrom_mode_select(cdi, &cgc);
-		}
+	/* set volume */
+	cgc->buffer = buffer + offset - 8;
+	memset(cgc->buffer, 0, 8);
+	return cdrom_mode_select(cdi, cgc);
+}
 
-	case CDROMSTART:
-	case CDROMSTOP: {
-		cdinfo(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n"); 
-		cgc.cmd[0] = GPCMD_START_STOP_UNIT;
-		cgc.cmd[1] = 1;
-		cgc.cmd[4] = (cmd == CDROMSTART) ? 1 : 0;
-		cgc.data_direction = CGC_DATA_NONE;
-		return cdo->generic_packet(cdi, &cgc);
-		}
+static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
+					struct packet_command *cgc,
+					int cmd)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	cdinfo(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
+	cgc->cmd[0] = GPCMD_START_STOP_UNIT;
+	cgc->cmd[1] = 1;
+	cgc->cmd[4] = (cmd == CDROMSTART) ? 1 : 0;
+	cgc->data_direction = CGC_DATA_NONE;
+	return cdo->generic_packet(cdi, cgc);
+}
 
-	case CDROMPAUSE:
-	case CDROMRESUME: {
-		cdinfo(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n"); 
-		cgc.cmd[0] = GPCMD_PAUSE_RESUME;
-		cgc.cmd[8] = (cmd == CDROMRESUME) ? 1 : 0;
-		cgc.data_direction = CGC_DATA_NONE;
-		return cdo->generic_packet(cdi, &cgc);
-		}
+static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
+					struct packet_command *cgc,
+					int cmd)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	cdinfo(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
+	cgc->cmd[0] = GPCMD_PAUSE_RESUME;
+	cgc->cmd[8] = (cmd == CDROMRESUME) ? 1 : 0;
+	cgc->data_direction = CGC_DATA_NONE;
+	return cdo->generic_packet(cdi, cgc);
+}
 
-	case DVD_READ_STRUCT: {
-		dvd_struct *s;
-		int size = sizeof(dvd_struct);
-		if (!CDROM_CAN(CDC_DVD))
-			return -ENOSYS;
-		if ((s = kmalloc(size, GFP_KERNEL)) == NULL)
-			return -ENOMEM;
-		cdinfo(CD_DO_IOCTL, "entering DVD_READ_STRUCT\n"); 
-		if (copy_from_user(s, (dvd_struct __user *)arg, size)) {
-			kfree(s);
-			return -EFAULT;
-		}
-		if ((ret = dvd_read_struct(cdi, s))) {
-			kfree(s);
-			return ret;
-		}
-		if (copy_to_user((dvd_struct __user *)arg, s, size))
-			ret = -EFAULT;
+static noinline int mmc_ioctl_dvd_read_struct(struct cdrom_device_info *cdi,
+						void __user *arg)
+{
+	int ret;
+	dvd_struct *s;
+	int size = sizeof(dvd_struct);
+
+	if (!CDROM_CAN(CDC_DVD))
+		return -ENOSYS;
+
+	s = kmalloc(size, GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	cdinfo(CD_DO_IOCTL, "entering DVD_READ_STRUCT\n");
+	if (copy_from_user(s, arg, size)) {
 		kfree(s);
+		return -EFAULT;
+	}
+
+	ret = dvd_read_struct(cdi, s);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(arg, s, size))
+		ret = -EFAULT;
+out:
+	kfree(s);
+	return ret;
+}
+
+static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
+					void __user *arg)
+{
+	int ret;
+	dvd_authinfo ai;
+	if (!CDROM_CAN(CDC_DVD))
+		return -ENOSYS;
+	cdinfo(CD_DO_IOCTL, "entering DVD_AUTH\n");
+	IOCTL_IN(arg, dvd_authinfo, ai);
+	ret = dvd_do_auth(cdi, &ai);
+	if (ret)
 		return ret;
-		}
+	IOCTL_OUT(arg, dvd_authinfo, ai);
+	return 0;
+}
 
-	case DVD_AUTH: {
-		dvd_authinfo ai;
-		if (!CDROM_CAN(CDC_DVD))
-			return -ENOSYS;
-		cdinfo(CD_DO_IOCTL, "entering DVD_AUTH\n"); 
-		IOCTL_IN(arg, dvd_authinfo, ai);
-		if ((ret = dvd_do_auth (cdi, &ai)))
-			return ret;
-		IOCTL_OUT(arg, dvd_authinfo, ai);
-		return 0;
-		}
+static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
+						void __user *arg)
+{
+	int ret;
+	long next = 0;
+	cdinfo(CD_DO_IOCTL, "entering CDROM_NEXT_WRITABLE\n");
+	ret = cdrom_get_next_writable(cdi, &next);
+	if (ret)
+		return ret;
+	IOCTL_OUT(arg, long, next);
+	return 0;
+}
 
-	case CDROM_NEXT_WRITABLE: {
-		long next = 0;
-		cdinfo(CD_DO_IOCTL, "entering CDROM_NEXT_WRITABLE\n"); 
-		if ((ret = cdrom_get_next_writable(cdi, &next)))
-			return ret;
-		IOCTL_OUT(arg, long, next);
-		return 0;
-		}
-	case CDROM_LAST_WRITTEN: {
-		long last = 0;
-		cdinfo(CD_DO_IOCTL, "entering CDROM_LAST_WRITTEN\n"); 
-		if ((ret = cdrom_get_last_written(cdi, &last)))
-			return ret;
-		IOCTL_OUT(arg, long, last);
-		return 0;
-		}
-	} /* switch */
+static noinline int mmc_ioctl_cdrom_last_written(struct cdrom_device_info *cdi,
+						void __user *arg)
+{
+	int ret;
+	long last = 0;
+	cdinfo(CD_DO_IOCTL, "entering CDROM_LAST_WRITTEN\n");
+	ret = cdrom_get_last_written(cdi, &last);
+	if (ret)
+		return ret;
+	IOCTL_OUT(arg, long, last);
+	return 0;
+}
+
+static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
+		     unsigned long arg)
+{
+	struct packet_command cgc;
+	void __user *userptr = (void __user *)arg;
+
+	memset(&cgc, 0, sizeof(cgc));
+
+	/* build a unified command and queue it through
+	   cdo->generic_packet() */
+	switch (cmd) {
+	case CDROMREADRAW:
+	case CDROMREADMODE1:
+	case CDROMREADMODE2:
+		return mmc_ioctl_cdrom_read_data(cdi, userptr, &cgc, cmd);
+	case CDROMREADAUDIO:
+		return mmc_ioctl_cdrom_read_audio(cdi, userptr);
+	case CDROMSUBCHNL:
+		return mmc_ioctl_cdrom_subchannel(cdi, userptr);
+	case CDROMPLAYMSF:
+		return mmc_ioctl_cdrom_play_msf(cdi, userptr, &cgc);
+	case CDROMPLAYBLK:
+		return mmc_ioctl_cdrom_play_blk(cdi, userptr, &cgc);
+	case CDROMVOLCTRL:
+	case CDROMVOLREAD:
+		return mmc_ioctl_cdrom_volume(cdi, userptr, &cgc, cmd);
+	case CDROMSTART:
+	case CDROMSTOP:
+		return mmc_ioctl_cdrom_start_stop(cdi, &cgc, cmd);
+	case CDROMPAUSE:
+	case CDROMRESUME:
+		return mmc_ioctl_cdrom_pause_resume(cdi, &cgc, cmd);
+	case DVD_READ_STRUCT:
+		return mmc_ioctl_dvd_read_struct(cdi, userptr);
+	case DVD_AUTH:
+		return mmc_ioctl_dvd_auth(cdi, userptr);
+	case CDROM_NEXT_WRITABLE:
+		return mmc_ioctl_cdrom_next_writable(cdi, userptr);
+	case CDROM_LAST_WRITTEN:
+		return mmc_ioctl_cdrom_last_written(cdi, userptr);
+	}
 
 	return -ENOTTY;
 }
-- 
1.5.6.4

