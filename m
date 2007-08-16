Return-Path: <linux-kernel-owner+w=401wt.eu-S937384AbXHPAjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937384AbXHPAjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936894AbXHPAiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:38:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:58480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936834AbXHPAiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:38:52 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 16 Aug 2007 10:38:45 +1000
Message-Id: <1070816003845.32736@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 2] md: Correctly update sysfs when a raid1 is reshaped.
References: <20070816103626.32539.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a raid1 array is reshaped (number of drives changed),
the list of devices is compacted, so that slots for missing
devices are filled with working devices from later slots.
This requires the "rd%d" symlinks in sysfs to be updated.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-16 10:29:58.000000000 +1000
@@ -2154,11 +2154,25 @@ static int raid1_reshape(mddev_t *mddev)
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
 
-	for (d=d2=0; d < conf->raid_disks; d++)
-		if (conf->mirrors[d].rdev) {
-			conf->mirrors[d].rdev->raid_disk = d2;
-			newmirrors[d2++].rdev = conf->mirrors[d].rdev;
+	for (d = d2 = 0; d < conf->raid_disks; d++) {
+		mdk_rdev_t *rdev = conf->mirrors[d].rdev;
+		if (rdev && rdev->raid_disk != d2) {
+			char nm[20];
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			rdev->raid_disk = d2;
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			if (sysfs_create_link(&mddev->kobj,
+					      &rdev->kobj, nm))
+				printk(KERN_WARNING
+				       "md/raid1: cannot register "
+				       "%s for %s\n",
+				       nm, mdname(mddev));
 		}
+		if (rdev)
+			newmirrors[d2++].rdev = rdev;
+	}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
 	kfree(conf->poolinfo);
