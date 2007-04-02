Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbXDBHo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbXDBHo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXDBHo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:44:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:46551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbXDBHoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:44:25 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 2 Apr 2007 17:44:17 +1000
Message-Id: <1070402074417.31093@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] md: Avoid a deadlock when removing a device from an md array via sysfs.
References: <20070402174319.30997.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch should go in 2.6.21 as it fixes a recent regression - NB)

A device can be removed from an md array via e.g.
  echo remove > /sys/block/md3/md/dev-sde/state

This will try to remove the 'dev-sde' subtree which will deadlock
since
  commit e7b0d26a86943370c04d6833c6edba2a72a6e240

With this patch we run the kobject_del via schedule_work so as to
avoid the deadlock.

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   13 ++++++++++++-
 ./include/linux/raid/md_k.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-04-02 17:43:03.000000000 +1000
+++ ./drivers/md/md.c	2007-04-02 17:38:46.000000000 +1000
@@ -1389,6 +1389,12 @@ static int bind_rdev_to_array(mdk_rdev_t
 	return err;
 }
 
+static void delayed_delete(struct work_struct *ws)
+{
+	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
+	kobject_del(&rdev->kobj);
+}
+
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -1401,7 +1407,12 @@ static void unbind_rdev_from_array(mdk_r
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
-	kobject_del(&rdev->kobj);
+
+	/* We need to delay this, otherwise we can deadlock when
+	 * writing to 'remove' to "dev/state"
+	 */
+	INIT_WORK(&rdev->del_work, delayed_delete);
+	schedule_work(&rdev->del_work);
 }
 
 /*

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2007-04-02 17:43:03.000000000 +1000
+++ ./include/linux/raid/md_k.h	2007-04-02 17:36:32.000000000 +1000
@@ -104,6 +104,7 @@ struct mdk_rdev_s
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
+	struct work_struct del_work;	/* used for delayed sysfs removal */
 };
 
 struct mddev_s
