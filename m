Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZIALTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZIALTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZIALTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:19:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45155 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZIALTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:19:40 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/8] writeback: check for registered bdi in flusher add and inode dirty
Date: Tue,  1 Sep 2009 13:19:05 +0200
Message-Id: <1251803946-9243-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
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
index c127735..38cb758 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -949,6 +949,13 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 28b2542..8bab34e 100644
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
index 44efc3e..a5f31e6 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -464,6 +464,11 @@ void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
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
@@ -527,6 +532,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	}
 
 	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 exit:
 	return ret;
 }
-- 
1.6.4.1.207.g68ea

