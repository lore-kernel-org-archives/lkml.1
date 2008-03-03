Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbYCCATd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbYCCATd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbYCCARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:45688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536AbYCCARa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:30 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:39 +1100
Message-Id: <1080303001739.23653@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 006 of 9] md: Lock access to rdev attributes properly
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we access attributes of an rdev (component device on an md array)
through sysfs, we really need to lock the array against concurrent
changes.  We currently do that when we change an attribute, but not
when we read an attribute.  We need to lock when reading as well else
rdev->mddev could become NULL while we are accessing it.

So add appropriate locking (mddev_lock) to rdev_attr_show.

rdev_size_store requires some extra care as well as it needs to unlock
the mddev while scanning other mddevs for overlapping regions.  We
currently assume that rdev->mddev will still be unchanged after the
scan, but that cannot be certain.  So take a copy of rdev->mddev for
use at the end of the function.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:52.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:56:20.000000000 +1100
@@ -2001,9 +2001,11 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	char *e;
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	unsigned long long oldsize = rdev->size;
+	mddev_t *my_mddev = rdev->mddev;
+
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
+	if (my_mddev->pers)
 		return -EBUSY;
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
@@ -2016,7 +2018,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		int overlap = 0;
 		struct list_head *tmp, *tmp2;
 
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
@@ -2036,7 +2038,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 				break;
 			}
 		}
-		mddev_lock(rdev->mddev);
+		mddev_lock(my_mddev);
 		if (overlap) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
@@ -2048,8 +2050,8 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			return -EBUSY;
 		}
 	}
-	if (size < rdev->mddev->size || rdev->mddev->size == 0)
-		rdev->mddev->size = size;
+	if (size < my_mddev->size || my_mddev->size == 0)
+		my_mddev->size = size;
 	return len;
 }
 
@@ -2070,10 +2072,21 @@ rdev_attr_show(struct kobject *kobj, str
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	mddev_t *mddev = rdev->mddev;
+	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-	return entry->show(rdev, page);
+
+	rv = mddev ? mddev_lock(mddev) : -EBUSY;
+	if (!rv) {
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->show(rdev, page);
+		mddev_unlock(mddev);
+	}
+	return rv;
 }
 
 static ssize_t
@@ -2082,15 +2095,19 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
-	int rv;
+	ssize_t rv;
+	mddev_t *mddev = rdev->mddev;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	rv = mddev_lock(rdev->mddev);
+	rv = mddev ? mddev_lock(mddev): -EBUSY;
 	if (!rv) {
-		rv = entry->store(rdev, page, length);
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->store(rdev, page, length);
 		mddev_unlock(rdev->mddev);
 	}
 	return rv;
