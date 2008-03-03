Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYCCAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYCCAS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYCCARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:45659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879AbYCCARH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:07 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:18 +1100
Message-Id: <1080303001718.23607@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 9] md: Guard against possible bad array geometry in v1 metadata.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure the data doesn't start before the end of the superblock
when the superblock is at the start of the device.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:10.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:10.000000000 +1100
@@ -1105,7 +1105,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
 	if (rdev->sb_size & bmask)
-		rdev-> sb_size = (rdev->sb_size | bmask)+1;
+		rdev->sb_size = (rdev->sb_size | bmask) + 1;
+
+	if (minor_version
+	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
+		return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
@@ -1137,7 +1141,7 @@ static int super_1_load(mdk_rdev_t *rdev
 		else
 			ret = 0;
 	}
-	if (minor_version) 
+	if (minor_version)
 		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
 	else
 		rdev->size = rdev->sb_offset;
