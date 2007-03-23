Return-Path: <linux-kernel-owner+w=401wt.eu-S1422639AbXCWBKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbXCWBKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422646AbXCWBKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:10:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934266AbXCWBKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:10:21 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 12:10:15 +1100
Message-Id: <1070323011015.5943@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 3] md: Clear the congested_fn when stopping a raid5
References: <20070323120828.5793.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If this mddev and queue got reused for another array that doesn't
register a congested_fn, this function would get called incorretly.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |    1 +
 ./drivers/md/raid5.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-03-23 11:13:41.000000000 +1100
+++ ./drivers/md/md.c	2007-03-23 11:13:41.000000000 +1100
@@ -3325,6 +3325,7 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->issue_flush_fn = NULL;
+			mddev->queue->backing_dev_info.congested_fn = NULL;
 			if (mddev->pers->sync_request)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-23 11:13:29.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-23 11:13:41.000000000 +1100
@@ -4269,8 +4269,8 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
-	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
 	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
@@ -4301,6 +4301,7 @@ static int stop(mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	kfree(conf->stripe_hashtbl);
+	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf->disks);
