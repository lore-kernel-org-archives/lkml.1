Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXLNG2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXLNG2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbXLNG0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:26:39 -0500
Received: from ns.suse.de ([195.135.220.2]:34083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXLNG0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:26:38 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Dec 2007 17:26:35 +1100
Message-Id: <1071214062635.1891@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 005 of 7] md: Lock address when changing attributes of component devices.
References: <20071214171950.1308.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:09:01.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:09:03.000000000 +1100
@@ -2080,12 +2080,18 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	int rv;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return entry->store(rdev, page, length);
+	rv = mddev_lock(rdev->mddev);
+	if (!rv) {
+		rv = entry->store(rdev, page, length);
+		mddev_unlock(rdev->mddev);
+	}
+	return rv;
 }
 
 static void rdev_free(struct kobject *ko)
