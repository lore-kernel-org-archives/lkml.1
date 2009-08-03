Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZHCUzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZHCUzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZHCUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:55:07 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34200 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZHCUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:55:05 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, linux-raid@vger.kernel.org,
       Neil Brown <neilb@suse.de>, <stable@kernel.org>
Subject: [PATCH] md: avoid use of broken kzalloc mempool
Date: Mon,  3 Aug 2009 13:54:46 -0700
Message-Id: <1249332888-13440-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kzalloc mempool does not re-zero items that have been used and then
returned to the pool.  Manually zero the allocated multipath_bh instead.

CC: linux-raid@vger.kernel.org
CC: Neil Brown <neilb@suse.de>
CC: <stable@kernel.org>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 drivers/md/multipath.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 237fe3f..151ce69 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -150,6 +150,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	}
 
 	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
+	memset(mp_bh, 0, sizeof(*mp_bh));
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
@@ -490,7 +491,7 @@ static int multipath_run (mddev_t *mddev)
 	}
 	mddev->degraded = conf->raid_disks - conf->working_disks;
 
-	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
+	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
-- 
1.5.6.5

