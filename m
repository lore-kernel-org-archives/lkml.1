Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXCWBKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXCWBKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422642AbXCWBKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:10:46 -0400
Received: from ns.suse.de ([195.135.220.2]:42895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422636AbXCWBK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:10:26 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 12:10:20 +1100
Message-Id: <1070323011020.5958@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 3] md: Convert compile time warnings into runtime warnings.
References: <20070323120828.5793.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... still not sure why we need this ....

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++----------
 ./drivers/md/raid5.c |   12 ++++++++++--
 2 files changed, 41 insertions(+), 12 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-03-23 11:13:41.000000000 +1100
+++ ./drivers/md/md.c	2007-03-23 12:06:34.000000000 +1100
@@ -1319,6 +1319,7 @@ static int bind_rdev_to_array(mdk_rdev_t
 	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
 	char *s;
+	int err;
 
 	if (rdev->mddev) {
 		MD_BUG();
@@ -1353,20 +1354,29 @@ static int bind_rdev_to_array(mdk_rdev_t
 	while ( (s=strchr(rdev->kobj.k_name, '/')) != NULL)
 		*s = '!';
 			
-	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
 	rdev->kobj.parent = &mddev->kobj;
-	kobject_add(&rdev->kobj);
+	if ((err = kobject_add(&rdev->kobj)))
+		goto fail;
 
 	if (rdev->bdev->bd_part)
 		ko = &rdev->bdev->bd_part->kobj;
 	else
 		ko = &rdev->bdev->bd_disk->kobj;
-	sysfs_create_link(&rdev->kobj, ko, "block");
+	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
+		kobject_del(&rdev->kobj);
+		goto fail;
+	}
+	list_add(&rdev->same_set, &mddev->disks);
 	bd_claim_by_disk(rdev->bdev, rdev, mddev->gendisk);
 	return 0;
+
+ fail:
+	printk(KERN_WARNING "md: failed to register dev-%s for %s\n",
+	       b, mdname(mddev));
+	return err;
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -2966,7 +2976,9 @@ static struct kobject *md_probe(dev_t de
 	mddev->kobj.k_name = NULL;
 	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
-	kobject_register(&mddev->kobj);
+	if (kobject_register(&mddev->kobj))
+		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
+		       disk->disk_name);
 	return NULL;
 }
 
@@ -3144,9 +3156,12 @@ static int do_md_run(mddev_t * mddev)
 		bitmap_destroy(mddev);
 		return err;
 	}
-	if (mddev->pers->sync_request)
-		sysfs_create_group(&mddev->kobj, &md_redundancy_group);
-	else if (mddev->ro == 2) /* auto-readonly not meaningful */
+	if (mddev->pers->sync_request) {
+		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+			printk(KERN_WARNING
+			       "md: cannot register extra attributes for %s\n",
+			       mdname(mddev));
+	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
  	atomic_set(&mddev->writes_pending,0);
@@ -3160,7 +3175,9 @@ static int do_md_run(mddev_t * mddev)
 		if (rdev->raid_disk >= 0) {
 			char nm[20];
 			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+			if (sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
+				printk("md: cannot register %s for %s\n",
+				       nm, mdname(mddev));
 		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5388,8 +5405,12 @@ static int remove_and_add_spares(mddev_t
 				if (mddev->pers->hot_add_disk(mddev,rdev)) {
 					char nm[20];
 					sprintf(nm, "rd%d", rdev->raid_disk);
-					sysfs_create_link(&mddev->kobj,
-							  &rdev->kobj, nm);
+					if (sysfs_create_link(&mddev->kobj,
+							      &rdev->kobj, nm))
+						printk(KERN_WARNING
+						       "md: cannot register "
+						       "%s for %s\n",
+						       nm, mdname(mddev));
 					spares++;
 					md_new_event(mddev);
 				} else

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-23 11:13:41.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-23 12:06:00.000000000 +1100
@@ -4265,7 +4265,10 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
-	sysfs_create_group(&mddev->kobj, &raid5_attrs_group);
+	if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
+		printk(KERN_WARNING
+		       "raid5: failed to create sysfs attributes for %s\n",
+		       mdname(mddev));
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
@@ -4574,7 +4577,12 @@ static int raid5_start_reshape(mddev_t *
 				added_devices++;
 				rdev->recovery_offset = 0;
 				sprintf(nm, "rd%d", rdev->raid_disk);
-				sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+				if (sysfs_create_link(&mddev->kobj,
+						      &rdev->kobj, nm))
+					printk(KERN_WARNING
+					       "raid5: failed to create "
+					       " link %s for %s\n",
+					       nm, mdname(mddev));
 			} else
 				break;
 		}
