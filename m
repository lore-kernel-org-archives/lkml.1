Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0BVM2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:28:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62947 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0BVM1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YxN6384sAqh6Qx4E8yG8Qlhw9LWys1COtpNHHxkvJTuGvY7bXOAPjVIcI652CkJjKk
         lupZUTBfW4To+F4KNNy+TW8EnatdSgML3YbvzPjld2FtP7f27i/YAr23pIYeGWuEZ5CS
         m4q4+1lZ54wk7iIbdBMXSposKeop9LqbXL7U0=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 5/8] cdrom: fixed assignment in if condition style issues
Date: Mon, 22 Feb 2010 13:26:35 +0100
Message-Id: <1266841598-19662-5-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all assignments in conditions errors.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   96 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 6a4f0ab..0062bf4 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -524,7 +524,8 @@ static int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write)
 	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	mfd = (struct mrw_feature_desc *)&buffer[sizeof(struct feature_header)];
@@ -532,7 +533,8 @@ static int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write)
 		return 1;
 	*write = mfd->write;
 
-	if ((ret = cdrom_mrw_probe_pc(cdi))) {
+	ret = cdrom_mrw_probe_pc(cdi);
+	if (ret) {
 		*write = 0;
 		return ret;
 	}
@@ -645,7 +647,8 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	cgc.buffer = buffer;
 	cgc.buflen = sizeof(buffer);
 
-	if ((ret = cdrom_mode_sense(cdi, &cgc, cdi->mrw_mode_page, 0)))
+	ret = cdrom_mode_sense(cdi, &cgc, cdi->mrw_mode_page, 0);
+	if (ret)
 		return ret;
 
 	mph = (struct mode_page_header *) buffer;
@@ -655,7 +658,8 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	buffer[offset + 3] = space;
 	cgc.buflen = size;
 
-	if ((ret = cdrom_mode_select(cdi, &cgc)))
+	ret = cdrom_mode_select(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "cdrom: %s: mrw address space %s selected\n", cdi->name, mrw_address_space[space]);
@@ -676,7 +680,8 @@ static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 	cgc.cmd[8] = sizeof(buffer);		/* often 0x18 */
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
@@ -697,7 +702,8 @@ static int cdrom_has_defect_mgt(struct cdrom_device_info *cdi)
 	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	feature_code = (__be16 *) &buffer[sizeof(struct feature_header)];
@@ -715,7 +721,8 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
 
 	*write = 0;
 
-	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+	ret = cdrom_get_random_writable(cdi, &rfd);
+	if (ret)
 		return ret;
 
 	if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
@@ -826,10 +833,12 @@ static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
 	struct rwrt_feature_desc rfd;
 	int ret;
 
-	if ((ret = cdrom_has_defect_mgt(cdi)))
+	ret = cdrom_has_defect_mgt(cdi);
+	if (ret)
 		return ret;
 
-	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+	ret = cdrom_get_random_writable(cdi, &rfd);
+	if (ret)
 		return ret;
 	else if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
 		ret = !rfd.curr;
@@ -852,7 +861,8 @@ static void cdrom_mmc3_profile(struct cdrom_device_info *cdi)
 	cgc.cmd[8] = sizeof(buffer);		/* Allocation Length */
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		mmc3_profile = 0xffff;
 	else
 		mmc3_profile = (buffer[6] << 8) | buffer[7];
@@ -1265,7 +1275,8 @@ static int cdrom_slot_status(struct cdrom_device_info *cdi, int slot)
 	if (!info)
 		return -ENOMEM;
 
-	if ((ret = cdrom_read_mech_status(cdi, info)))
+	ret = cdrom_read_mech_status(cdi, info);
+	if (ret)
 		goto out_free;
 
 	if (info->slots[slot].disc_present)
@@ -1295,7 +1306,8 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 	if (!info)
 		return -ENOMEM;
 
-	if ((status = cdrom_read_mech_status(cdi, info)) == 0)
+	status = cdrom_read_mech_status(cdi, info);
+	if (status == 0)
 		nslots = info->hdr.nslots;
 
 	kfree(info);
@@ -1353,7 +1365,8 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	if (!info)
 		return -ENOMEM;
 
-	if ((ret = cdrom_read_mech_status(cdi, info))) {
+	ret = cdrom_read_mech_status(cdi, info);
+	if (ret) {
 		kfree(info);
 		return ret;
 	}
@@ -1378,7 +1391,8 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 
 	/* set media changed bits on both queues */
 	cdi->mc_flags = 0x3;
-	if ((ret = cdrom_load_unload(cdi, slot)))
+	ret = cdrom_load_unload(cdi, slot);
+	if (ret)
 		return ret;
 
 	return slot;
@@ -1433,7 +1447,8 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	tracks->error = 0;
 	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
 	/* Grab the TOC header so we can see how many tracks there are */
-	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
+	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header);
+	if (ret) {
 		if (ret == -ENOMEDIUM)
 			tracks->error = CDS_NO_DISC;
 		else
@@ -1580,7 +1595,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lsa.agid, 0);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lsa.agid = buf[7] >> 6;
@@ -1591,7 +1607,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cdinfo(CD_DVD, "entering DVD_LU_SEND_KEY1\n");
 		setup_report_key(&cgc, ai->lsk.agid, 2);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		copy_key(ai->lsk.key, &buf[4]);
@@ -1602,7 +1619,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cdinfo(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n");
 		setup_report_key(&cgc, ai->lsc.agid, 1);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		copy_chal(ai->lsc.chal, &buf[4]);
@@ -1619,7 +1637,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.cmd[3] = ai->lstk.lba >> 16;
 		cgc.cmd[2] = ai->lstk.lba >> 24;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lstk.cpm = (buf[4] >> 7) & 1;
@@ -1633,7 +1652,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cdinfo(CD_DVD, "entering DVD_LU_SEND_ASF\n");
 		setup_report_key(&cgc, ai->lsasf.agid, 5);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lsasf.asf = buf[7] & 1;
@@ -1646,7 +1666,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 0xe;
 		copy_chal(&buf[4], ai->hsc.chal);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->type = DVD_LU_SEND_KEY1;
@@ -1658,7 +1679,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 0xa;
 		copy_key(&buf[4], ai->hsk.key);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc))) {
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret) {
 			ai->type = DVD_AUTH_FAILURE;
 			return ret;
 		}
@@ -1670,7 +1692,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.quiet = 1;
 		cdinfo(CD_DVD, "entering DVD_INVALIDATE_AGID\n");
 		setup_report_key(&cgc, ai->lsa.agid, 0x3f);
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 		break;
 
@@ -1681,7 +1704,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		memset(&rpc_state, 0, sizeof(rpc_state_t));
 		cgc.buffer = (char *) &rpc_state;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lrpcs.type = rpc_state.type_code;
@@ -1698,7 +1722,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 6;
 		buf[4] = ai->hrpcs.pdrc;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 		break;
 
@@ -1955,7 +1980,8 @@ static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 	cgc.cmd[3] = mcn ? 2 : 1;
 	cgc.cmd[8] = 16;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	subchnl->cdsc_audiostatus = cgc.buffer[1];
@@ -3172,7 +3198,8 @@ static int cdrom_get_track_info(struct cdrom_device_info *cdi, __u16 track, __u8
 	cgc.cmd[8] = 8;
 	cgc.quiet = 1;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	buflen = be16_to_cpu(ti->track_information_length) +
@@ -3182,7 +3209,8 @@ static int cdrom_get_track_info(struct cdrom_device_info *cdi, __u16 track, __u8
 		buflen = sizeof(track_information);
 
 	cgc.cmd[8] = cgc.buflen = buflen;
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	/* return actual fill size */
@@ -3202,7 +3230,8 @@ static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *
 	cgc.cmd[8] = cgc.buflen = 2;
 	cgc.quiet = 1;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	/* not all drives have the same disc_info length, so requeue
@@ -3215,7 +3244,8 @@ static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *
 		buflen = sizeof(disc_information);
 
 	cgc.cmd[8] = cgc.buflen = buflen;
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	/* return actual fill size */
@@ -3278,7 +3308,8 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
 use_toc:
 	toc.cdte_format = CDROM_MSF;
 	toc.cdte_track = CDROM_LEADOUT;
-	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
+	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc);
+	if (ret)
 		return ret;
 	sanitize_format(&toc.cdte_addr, &toc.cdte_format, CDROM_LBA);
 	*last_written = toc.cdte_addr.lba;
@@ -3325,7 +3356,8 @@ static int cdrom_get_next_writable(struct cdrom_device_info *cdi, long *next_wri
 	}
 
 use_last_written:
-	if ((ret = cdrom_get_last_written(cdi, next_writable))) {
+	ret = cdrom_get_last_written(cdi, next_writable);
+	if (ret) {
 		*next_writable = 0;
 		return ret;
 	} else {
-- 
1.7.0

