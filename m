Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbYD2Dhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbYD2Dhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYD2DfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:35:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:57727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535AbYD2DfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:35:12 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:35:27 +1000
Message-Id: <1080429033527.20385@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
References: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

Found when trying to reassemble an active externally managed array.
Without this check we hit the more noisy "sysfs duplicate" warning in
the later call to kobject_add.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
@@ -1369,6 +1369,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 		MD_BUG();
 		return -EINVAL;
 	}
+
+	/* prevent duplicates */
+	if (find_rdev(mddev, rdev->bdev->bd_dev))
+		return -EEXIST;
+
 	/* make sure rdev->size exceeds mddev->size */
 	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
 		if (mddev->pers) {
