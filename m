Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZCRN3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZCRN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZCRN05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbZCRN0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:48 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/18] GFS2: Support generation of discard requests
Date: Wed, 18 Mar 2009 12:23:44 +0000
Message-Id: <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch allows GFS2 to generate discard requests for blocks which are
no longer useful to the filesystem (i.e. those which have been freed as
the result of an unlink operation). The requests are generated at the
time which those blocks become available for reuse in the filesystem.

In order to use this new feature, you have to specify the "discard"
mount option. The code coalesces adjacent blocks into a single extent
when generating the discard requests, thus generating the minimum
number.

If an error occurs when the request has been sent to the block device,
then it will print a message and turn off the requests for that
filesystem. If the problem is temporary, then you can use remount to
turn the option back on again. There is also a nodiscard mount option
so that you can use remount to turn discard requests off, if required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8fe0675..3f29bd2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -416,7 +416,7 @@ struct gfs2_args {
 	unsigned int ar_suiddir:1;		/* suiddir support */
 	unsigned int ar_data:2;			/* ordered/writeback */
 	unsigned int ar_meta:1;			/* mount metafs */
-	unsigned int ar_num_glockd;		/* Number of glockd threads */
+	unsigned int ar_discard:1;		/* discard requests */
 };
 
 struct gfs2_tune {
diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index fba502a..ee69701 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -41,6 +41,8 @@ enum {
 	Opt_data_writeback,
 	Opt_data_ordered,
 	Opt_meta,
+	Opt_discard,
+	Opt_nodiscard,
 	Opt_err,
 };
 
@@ -65,6 +67,8 @@ static const match_table_t tokens = {
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_meta, "meta"},
+	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_err, NULL}
 };
 
@@ -157,6 +161,12 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *options)
 		case Opt_meta:
 			args->ar_meta = 1;
 			break;
+		case Opt_discard:
+			args->ar_discard = 1;
+			break;
+		case Opt_nodiscard:
+			args->ar_discard = 0;
+			break;
 		case Opt_err:
 		default:
 			fs_info(sdp, "invalid mount option: %s\n", o);
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 4ecdad0..4580195 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -608,6 +608,8 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		}
 		seq_printf(s, ",data=%s", state);
 	}
+	if (args->ar_discard)
+		seq_printf(s, ",discard");
 
 	return 0;
 }
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index ba5a021..789953a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/prefetch.h>
+#include <linux/blkdev.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -830,6 +831,58 @@ void gfs2_rgrp_bh_put(struct gfs2_rgrpd *rgd)
 	spin_unlock(&sdp->sd_rindex_spin);
 }
 
+static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
+				    const struct gfs2_bitmap *bi)
+{
+	struct super_block *sb = sdp->sd_vfs;
+	struct block_device *bdev = sb->s_bdev;
+	const unsigned int sects_per_blk = sdp->sd_sb.sb_bsize /
+					   bdev_hardsect_size(sb->s_bdev);
+	u64 blk;
+	sector_t start;
+	sector_t nr_sects = 0;
+	int rv;
+	unsigned int x;
+
+	for (x = 0; x < bi->bi_len; x++) {
+		const u8 *orig = bi->bi_bh->b_data + bi->bi_offset + x;
+		const u8 *clone = bi->bi_clone + bi->bi_offset + x;
+		u8 diff = ~(*orig | (*orig >> 1)) & (*clone | (*clone >> 1));
+		diff &= 0x55;
+		if (diff == 0)
+			continue;
+		blk = offset + ((bi->bi_start + x) * GFS2_NBBY);
+		blk *= sects_per_blk; /* convert to sectors */
+		while(diff) {
+			if (diff & 1) {
+				if (nr_sects == 0)
+					goto start_new_extent;
+				if ((start + nr_sects) != blk) {
+					rv = blkdev_issue_discard(bdev, start,
+							    nr_sects, GFP_NOFS);
+					if (rv)
+						goto fail;
+					nr_sects = 0;
+start_new_extent:
+					start = blk;
+				}
+				nr_sects += sects_per_blk;
+			}
+			diff >>= 2;
+			blk += sects_per_blk;
+		}
+	}
+	if (nr_sects) {
+		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS);
+		if (rv)
+			goto fail;
+	}
+	return;
+fail:
+	fs_warn(sdp, "error %d on discard request, turning discards off for this filesystem", rv);
+	sdp->sd_args.ar_discard = 0;
+}
+
 void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 {
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
@@ -840,6 +893,8 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 		struct gfs2_bitmap *bi = rgd->rd_bits + x;
 		if (!bi->bi_clone)
 			continue;
+		if (sdp->sd_args.ar_discard)
+			gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bi);
 		memcpy(bi->bi_clone + bi->bi_offset,
 		       bi->bi_bh->b_data + bi->bi_offset, bi->bi_len);
 	}
-- 
1.6.0.3

