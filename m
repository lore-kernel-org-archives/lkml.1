Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZEYHe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZEYHe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZEYHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:32:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38731 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbZEYHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:17 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/12] writeback: check for registered bdi in flusher add and inode dirty
Date: Mon, 25 May 2009 09:31:07 +0200
Message-Id: <1243236668-3398-25-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
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
index 1292a88..bf8e0d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -583,6 +583,13 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 4507569..0b20d4b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -31,6 +31,7 @@ enum bdi_state {
 	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
+	BDI_registered,		/* bdi_register() was done */
 	BDI_unused,		/* Available bits start here */
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0834ff9..ed66081 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -504,6 +504,11 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
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
@@ -612,6 +617,7 @@ remove_err:
 	}
 
 	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 exit:
 	return ret;
 }
-- 
1.6.3.rc0.1.gf800

