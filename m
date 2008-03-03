Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYCCASo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYCCASo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYCCARP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264AbYCCARN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:13 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:24 +1100
Message-Id: <1080303001724.23623@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 9] md: Clean up irregularity with raid autodetect.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a raid1 array is stopped, all components currently get added
to the list for auto-detection.  However we should really only add
components that were found by autodetection in the first place.
So add a flag to record that information, and use it.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |    4 +++-
 ./include/linux/raid/md_k.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:10.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:25.000000000 +1100
@@ -1503,7 +1503,8 @@ static void export_rdev(mdk_rdev_t * rde
 	free_disk_sb(rdev);
 	list_del_init(&rdev->same_set);
 #ifndef MODULE
-	md_autodetect_dev(rdev->bdev->bd_dev);
+	if (test_bit(AutoDetected, &rdev->flags))
+		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
 	unlock_rdev(rdev);
 	kobject_put(&rdev->kobj);
@@ -6025,6 +6026,7 @@ static void autostart_arrays(int part)
 			MD_BUG();
 			continue;
 		}
+		set_bit(AutoDetected, &rdev->flags);
 		list_add(&rdev->same_set, &pending_raid_disks);
 		i_passed++;
 	}

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-02-22 15:46:25.000000000 +1100
+++ ./include/linux/raid/md_k.h	2008-02-22 15:46:25.000000000 +1100
@@ -83,6 +83,7 @@ struct mdk_rdev_s
 #define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
+#define	AutoDetected	7		/* added by auto-detect */
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
