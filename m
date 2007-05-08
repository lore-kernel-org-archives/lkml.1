Return-Path: <linux-kernel-owner+w=401wt.eu-S967779AbXEHE3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967779AbXEHE3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 00:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967769AbXEHE3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 00:29:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:41293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967767AbXEHE3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 00:29:41 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 8 May 2007 14:29:17 +1000
Message-Id: <1070508042917.28734@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 001 of 5] md: Move test for whether level supports bitmap to correct place.
References: <20070508142718.28571.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We need to check for internal-consistency of superblock in
load_super.  validate_super is for inter-device consistency.

With the test in the wrong place, a badly created array will confuse md
rather an produce sensible errors.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-07 14:33:31.000000000 +1000
+++ ./drivers/md/md.c	2007-05-07 14:33:31.000000000 +1000
@@ -695,6 +695,17 @@ static int super_90_load(mdk_rdev_t *rde
 	rdev->data_offset = 0;
 	rdev->sb_size = MD_SB_BYTES;
 
+	if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
+		if (sb->level != 1 && sb->level != 4
+		    && sb->level != 5 && sb->level != 6
+		    && sb->level != 10) {
+			/* FIXME use a better test */
+			printk(KERN_WARNING
+			       "md: bitmaps not supported for this level.\n");
+			goto abort;
+		}
+	}
+
 	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
 	else
@@ -793,16 +804,8 @@ static int super_90_validate(mddev_t *md
 		mddev->max_disks = MD_SB_DISKS;
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
-		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1 && mddev->level != 4
-			    && mddev->level != 5 && mddev->level != 6
-			    && mddev->level != 10) {
-				/* FIXME use a better test */
-				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
-				return -EINVAL;
-			}
+		    mddev->bitmap_file == NULL)
 			mddev->bitmap_offset = mddev->default_bitmap_offset;
-		}
 
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling */
@@ -1059,6 +1062,18 @@ static int super_1_load(mdk_rdev_t *rdev
 		       bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
+	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)) {
+		if (sb->level != cpu_to_le32(1) &&
+		    sb->level != cpu_to_le32(4) &&
+		    sb->level != cpu_to_le32(5) &&
+		    sb->level != cpu_to_le32(6) &&
+		    sb->level != cpu_to_le32(10)) {
+			printk(KERN_WARNING
+			       "md: bitmaps not supported for this level.\n");
+			return -EINVAL;
+		}
+	}
+
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
@@ -1142,14 +1157,9 @@ static int super_1_validate(mddev_t *mdd
 		mddev->max_disks =  (4096-256)/2;
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
-		    mddev->bitmap_file == NULL ) {
-			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
-			    && mddev->level != 10) {
-				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
-				return -EINVAL;
-			}
+		    mddev->bitmap_file == NULL )
 			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
-		}
+
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			mddev->delta_disks = le32_to_cpu(sb->delta_disks);
