Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbYANBrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbYANBrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYANBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:46:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:59217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbYANBqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:46:04 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jan 2008 12:45:56 +1100
Message-Id: <1080114014556.20415@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 006 of 6] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
References: <20080114123726.19968.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Finish ITERATE_ to for_each conversion.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |    8 ++++----
 ./include/linux/raid/md_k.h |   14 ++++----------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:26:10.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:26:15.000000000 +1100
@@ -3767,7 +3767,7 @@ static void autorun_devices(int part)
 		printk(KERN_INFO "md: considering %s ...\n",
 			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
-		ITERATE_RDEV_PENDING(rdev,tmp)
+		rdev_for_each_list(rdev, tmp, pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
 					bdevname(rdev->bdev,b));
@@ -3810,7 +3810,7 @@ static void autorun_devices(int part)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
-			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
+			rdev_for_each_list(rdev, tmp, candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
@@ -3821,7 +3821,7 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		ITERATE_RDEV_GENERIC(candidates,rdev,tmp)
+		rdev_for_each_list(rdev, tmp, candidates)
 			export_rdev(rdev);
 		mddev_put(mddev);
 	}
@@ -4936,7 +4936,7 @@ static void status_unused(struct seq_fil
 
 	seq_printf(seq, "unused devices: ");
 
-	ITERATE_RDEV_PENDING(rdev,tmp) {
+	rdev_for_each_list(rdev, tmp, pending_raid_disks) {
 		char b[BDEVNAME_SIZE];
 		i++;
 		seq_printf(seq, "%s ",

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-01-14 12:26:10.000000000 +1100
+++ ./include/linux/raid/md_k.h	2008-01-14 12:26:15.000000000 +1100
@@ -313,23 +313,17 @@ static inline char * mdname (mddev_t * m
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
  */
-#define ITERATE_RDEV_GENERIC(head,rdev,tmp)				\
+#define rdev_for_each_list(rdev, tmp, list)				\
 									\
-	for ((tmp) = (head).next;					\
+	for ((tmp) = (list).next;					\
 		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
-			(tmp) = (tmp)->next, (tmp)->prev != &(head)	\
+			(tmp) = (tmp)->next, (tmp)->prev != &(list)	\
 		; )
 /*
  * iterates through the 'same array disks' ringlist
  */
 #define rdev_for_each(rdev, tmp, mddev)				\
-	ITERATE_RDEV_GENERIC((mddev)->disks,rdev,tmp)
-
-/*
- * Iterates through 'pending RAID disks'
- */
-#define ITERATE_RDEV_PENDING(rdev,tmp)					\
-	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
+	rdev_for_each_list(rdev, tmp, (mddev)->disks)
 
 typedef struct mdk_thread_s {
 	void			(*run) (mddev_t *mddev);
