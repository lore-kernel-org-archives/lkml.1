Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZIHJZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZIHJZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZIHJYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:24:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56789 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZIHJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:23:57 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/8] writeback: check for registered bdi in flusher add and inode dirty
Date: Tue,  8 Sep 2009 11:23:10 +0200
Message-Id: <1252401791-22463-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
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
index 7c79ff5..6ccdfbb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1046,6 +1046,13 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!was_dirty) {
 			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
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
index 2f218b7..f169bcb 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -29,6 +29,7 @@ enum bdi_state {
 	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
+	BDI_registered,		/* bdi_register() was done */
 	BDI_unused,		/* Available bits start here */
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5cb32c5..8629ea8 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -465,6 +465,11 @@ void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
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
@@ -528,6 +533,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	}
 
 	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 exit:
 	return ret;
 }
-- 
1.6.4.1.207.g68ea

