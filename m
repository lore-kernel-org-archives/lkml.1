Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZDHMML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZDHMML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbZDHMBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:01:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48992 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933395AbZDHMAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/13] writeback: check for registered bdi in flusher add and inode dirty
Date: Wed,  8 Apr 2009 14:00:15 +0200
Message-Id: <1239192016-19857-13-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also a debugging aid. We want to catch dirty inodes being added to
backing devices that don't do writeback.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |    7 +++++++
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7ed86a0..1d25d3a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -426,6 +426,13 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!was_dirty) {
 			struct bdi_writeback *wb = inode_get_wb(inode);
+			struct backing_dev_info *bdi = wb->bdi;
+
+			if (bdi_cap_writeback_dirty(bdi) &&
+			    !test_bit(BDI_registered, &bdi->state)) {
+				WARN_ON(1);
+				printk("bdi-%s not registered\n", bdi->name);
+			}
 
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &wb->b_dirty);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index a343719..c7c1ed6 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -29,6 +29,7 @@ enum bdi_state {
 	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
+	BDI_registered,		/* bdi_register() was done */
 	BDI_unused,		/* Available bits start here */
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f86f9cc..9d6ac11 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -485,6 +485,11 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
+	if (WARN_ON(!test_bit(BDI_registered, &bdi->state))) {
+		printk("bdi %p/%s is not registered!\n", bdi, bdi->name);
+		return;
+	}
+
 	/*
 	 * Check with the helper whether to proceed adding a task. Will only
 	 * abort if we two or more simultanous calls to
@@ -588,6 +593,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 
 exit:
 	return ret;
-- 
1.6.2.2.446.gfbdc0

