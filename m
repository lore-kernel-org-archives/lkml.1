Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYF0Gys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYF0Gys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYF0Gul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:50:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:46772 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546AbYF0Gui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:50:38 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:50:29 +1000
Message-Id: <1080627065029.10473@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 011 of 29] md: Support adding a spare to a live md array with external metadata.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i.e. extend the 'md/dev-XXX/slot' attribute so that you can
tell a device to fill an vacant slot in an and md array.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c        |   42 +++++++++++++++++++++++++++++++++++++++---
 ./drivers/md/multipath.c |    7 ++++++-
 ./drivers/md/raid1.c     |    7 ++++++-
 ./drivers/md/raid10.c    |   10 ++++++++--
 ./drivers/md/raid5.c     |   10 ++++++++--
 5 files changed, 67 insertions(+), 9 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:33:01.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:33:01.000000000 +1000
@@ -1932,7 +1932,7 @@ slot_store(mdk_rdev_t *rdev, const char 
 		slot = -1;
 	else if (e==buf || (*e && *e!= '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers) {
+	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
 		 * updating the 'rd%d' link, and communicating
 		 * with the personality with ->hot_*_disk.
@@ -1940,8 +1940,6 @@ slot_store(mdk_rdev_t *rdev, const char 
 		 * failed/spare devices.  This normally happens automatically,
 		 * but not when the metadata is externally managed.
 		 */
-		if (slot != -1)
-			return -EBUSY;
 		if (rdev->raid_disk == -1)
 			return -EEXIST;
 		/* personality does all needed checks */
@@ -1955,6 +1953,44 @@ slot_store(mdk_rdev_t *rdev, const char 
 		sysfs_remove_link(&rdev->mddev->kobj, nm);
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
+	} else if (rdev->mddev->pers) {
+		mdk_rdev_t *rdev2;
+		struct list_head *tmp;
+		/* Activating a spare .. or possibly reactivating
+		 * if we every get bitmaps working here.
+		 */
+
+		if (rdev->raid_disk != -1)
+			return -EBUSY;
+
+		if (rdev->mddev->pers->hot_add_disk == NULL)
+			return -EINVAL;
+
+		rdev_for_each(rdev2, tmp, rdev->mddev)
+			if (rdev2->raid_disk == slot)
+				return -EEXIST;
+
+		rdev->raid_disk = slot;
+		if (test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = slot;
+		else
+			rdev->saved_raid_disk = -1;
+		err = rdev->mddev->pers->
+			hot_add_disk(rdev->mddev, rdev);
+		if (err != 1) {
+			rdev->raid_disk = -1;
+			if (err == 0)
+				return -EEXIST;
+			return err;
+		}
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		if (sysfs_create_link(&rdev->mddev->kobj, &rdev->kobj, nm))
+			printk(KERN_WARNING
+			       "md: cannot register "
+			       "%s for %s\n",
+			       nm, mdname(rdev->mddev));
+
+		/* don't wakeup anyone, leave that to userspace. */
 	} else {
 		if (slot >= rdev->mddev->raid_disks)
 			return -ENOSPC;

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2008-06-27 15:14:03.000000000 +1000
+++ ./drivers/md/multipath.c	2008-06-27 15:33:01.000000000 +1000
@@ -284,10 +284,15 @@ static int multipath_add_disk(mddev_t *m
 	int found = 0;
 	int path;
 	struct multipath_info *p;
+	int first = 0;
+	int last = mddev->raid_disks - 1;
+
+	if (rdev->raid_disk >= 0)
+		first = last = rdev->raid_disk;
 
 	print_multipath_conf(conf);
 
-	for (path=0; path<mddev->raid_disks; path++) 
+	for (path = first; path <= last; path++)
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			q = rdev->bdev->bd_disk->queue;
 			blk_queue_stack_limits(mddev->queue, q);

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-06-27 15:19:36.000000000 +1000
+++ ./drivers/md/raid10.c	2008-06-27 15:33:01.000000000 +1000
@@ -1116,6 +1116,8 @@ static int raid10_add_disk(mddev_t *mdde
 	int found = 0;
 	int mirror;
 	mirror_info_t *p;
+	int first = 0;
+	int last = mddev->raid_disks - 1;
 
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
@@ -1125,12 +1127,16 @@ static int raid10_add_disk(mddev_t *mdde
 	if (!enough(conf))
 		return 0;
 
+	if (rdev->raid_disk)
+		first = last = rdev->raid_disk;
+
 	if (rdev->saved_raid_disk >= 0 &&
+	    rdev->saved_raid_disk >= first &&
 	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
 		mirror = rdev->saved_raid_disk;
 	else
-		mirror = 0;
-	for ( ; mirror < mddev->raid_disks; mirror++)
+		mirror = first;
+	for ( ; mirror <= last ; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
 			blk_queue_stack_limits(mddev->queue,

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-06-27 15:14:03.000000000 +1000
+++ ./drivers/md/raid1.c	2008-06-27 15:33:01.000000000 +1000
@@ -1103,8 +1103,13 @@ static int raid1_add_disk(mddev_t *mddev
 	int found = 0;
 	int mirror = 0;
 	mirror_info_t *p;
+	int first = 0;
+	int last = mddev->raid_disks - 1;
 
-	for (mirror=0; mirror < mddev->raid_disks; mirror++)
+	if (rdev->raid_disk >= 0)
+		first = last = rdev->raid_disk;
+
+	for (mirror = first; mirror <= last; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
 			blk_queue_stack_limits(mddev->queue,

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:31:23.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:33:01.000000000 +1000
@@ -4607,21 +4607,27 @@ static int raid5_add_disk(mddev_t *mddev
 	int found = 0;
 	int disk;
 	struct disk_info *p;
+	int first = 0;
+	int last = conf->raid_disks - 1;
 
 	if (mddev->degraded > conf->max_degraded)
 		/* no point adding a device */
 		return 0;
 
+	if (rdev->raid_disk >= 0)
+		first = last = rdev->raid_disk;
+
 	/*
 	 * find the disk ... but prefer rdev->saved_raid_disk
 	 * if possible.
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
+	    rdev->saved_raid_disk >= first &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		disk = rdev->saved_raid_disk;
 	else
-		disk = 0;
-	for ( ; disk < conf->raid_disks; disk++)
+		disk = first;
+	for ( ; disk <= last ; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
