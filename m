Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZKSVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZKSVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZKSVYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:24:52 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53943 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZKSVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:24:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=md-add-syncall-ioctl.patch
Content-type: TEXT/PLAIN; NAME=''md-add-syncall-ioctl.patch
Date: Thu, 19 Nov 2009 16:22:46 -0500
From: scjody@sun.com
Subject: [patch 5/5] [md] Add SET_RESYNC_ALL and CLEAR_RESYNC_ALL ioctls.
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
Message-id: <20091119212407.911694324@sun.com>
References: <20091119212241.283629302@sun.com>
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SET_RESYNC_ALL and CLEAR_RESYNC_ALL ioctls, needed for
fsck of a filesystem using declared mode.

SET_RESYNC_ALL instructs an MD block device to perform a resync of all
stripes read or written until CLEAR_RESYNC_ALL is set.  The intended user
is e2fsck, which can SET_RESYNC_ALL before journal replay (which includes
reading from all blocks declared for write prior to a crash) and then
CLEAR_RESYNC_ALL afterwards.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6.18-128.7.1/drivers/md/md.c
===================================================================
--- linux-2.6.18-128.7.1.orig/drivers/md/md.c
+++ linux-2.6.18-128.7.1/drivers/md/md.c
@@ -4484,6 +4484,24 @@ static int md_ioctl(struct inode *inode,
 			err = set_bitmap_file(mddev, (int)arg);
 			goto done_unlock;
 
+		case SET_RESYNC_ALL:
+			if (mddev->pers->set_resync_all == NULL) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			err = mddev->pers->set_resync_all(mddev, 1);
+			goto done_unlock;
+
+		case CLEAR_RESYNC_ALL:
+			if (mddev->pers->set_resync_all == NULL) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			err = mddev->pers->set_resync_all(mddev, 0);
+			goto done_unlock;
+
 		default:
 			err = -EINVAL;
 			goto abort_unlock;
Index: linux-2.6.18-128.7.1/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.7.1.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.7.1/drivers/md/raid5.c
@@ -3013,7 +3013,7 @@ retry:
 			r_sector += sectors_per_chunk;
 		}
 		if (sh) {
-			if (bio_flagged(bi, BIO_SYNCRAID)) {
+			if (bio_flagged(bi, BIO_SYNCRAID) || conf->resync_all) {
 				if (test_bit(STRIPE_RESYNC_REQ, &sh->state)) {
 					PRINTK("SYNCRAID on %llu, already resynced\n", bi->bi_sector);
 				} else {
@@ -4049,6 +4049,15 @@ static void raid5_quiesce(mddev_t *mddev
 	}
 }
 
+static int raid5_set_resync_all(mddev_t *mddev, int state)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+
+	conf->resync_all = state;
+
+	return 0;
+}
+
 static struct mdk_personality raid6_personality =
 {
 	.name		= "raid6",
@@ -4065,6 +4074,7 @@ static struct mdk_personality raid6_pers
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
+	.set_resync_all = raid5_set_resync_all,
 };
 static struct mdk_personality raid5_personality =
 {
@@ -4086,6 +4096,7 @@ static struct mdk_personality raid5_pers
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.set_resync_all = raid5_set_resync_all,
 };
 
 static struct mdk_personality raid4_personality =
@@ -4104,6 +4115,7 @@ static struct mdk_personality raid4_pers
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
+	.set_resync_all = raid5_set_resync_all,
 };
 
 static int __init raid5_init(void)
Index: linux-2.6.18-128.7.1/include/linux/raid/md_u.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/raid/md_u.h
+++ linux-2.6.18-128.7.1/include/linux/raid/md_u.h
@@ -45,6 +45,8 @@
 #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
+#define SET_RESYNC_ALL		_IO (MD_MAJOR, 0x35)
+#define CLEAR_RESYNC_ALL	_IO (MD_MAJOR, 0x36)
 
 typedef struct mdu_version_s {
 	int major;
Index: linux-2.6.18-128.7.1/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/raid/raid5.h
+++ linux-2.6.18-128.7.1/include/linux/raid/raid5.h
@@ -241,6 +241,7 @@ struct raid5_private_data {
 
 	int			seq_flush, seq_write;
 	int			quiesce;
+	int			resync_all;
 
 	int			fullsync;  /* set to 1 if a full sync is needed,
 					    * (fresh device added).
Index: linux-2.6.18-128.7.1/include/linux/raid/md_k.h
===================================================================
--- linux-2.6.18-128.7.1.orig/include/linux/raid/md_k.h
+++ linux-2.6.18-128.7.1/include/linux/raid/md_k.h
@@ -283,6 +283,7 @@ struct mdk_personality
 	 * others - reserved
 	 */
 	void (*quiesce) (mddev_t *mddev, int state);
+	int (*set_resync_all) (mddev_t *mddev, int state);
 };
 
 

-- 
