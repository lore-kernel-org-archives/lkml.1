Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYBQIVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYBQIVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYBQITD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:19:03 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36886 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbYBQIS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:18:59 -0500
Date: Sun, 17 Feb 2008 10:18:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/fs-writeback.: make 2 functions static
Message-ID: <20080217081833.GL3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- writeback_acquire()
- writeback_release()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/fs-writeback.c           |   77 ++++++++++++++++++------------------
 include/linux/backing-dev.h |    2 
 2 files changed, 39 insertions(+), 40 deletions(-)

b9618973cfdb38d747ce5332d38ab9716733a146 diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c007607..b265a17 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,6 +25,45 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+
+/**
+ * writeback_acquire: attempt to get exclusive writeback access to a device
+ * @bdi: the device's backing_dev_info structure
+ *
+ * It is a waste of resources to have more than one pdflush thread blocked on
+ * a single request queue.  Exclusion at the request_queue level is obtained
+ * via a flag in the request_queue's backing_dev_info.state.
+ *
+ * Non-request_queue-backed address_spaces will share default_backing_dev_info,
+ * unless they implement their own.  Which is somewhat inefficient, as this
+ * may prevent concurrent writeback against multiple devices.
+ */
+static int writeback_acquire(struct backing_dev_info *bdi)
+{
+	return !test_and_set_bit(BDI_pdflush, &bdi->state);
+}
+
+/**
+ * writeback_in_progress: determine whether there is writeback in progress
+ * @bdi: the device's backing_dev_info structure.
+ *
+ * Determine whether there is writeback in progress against a backing device.
+ */
+int writeback_in_progress(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_pdflush, &bdi->state);
+}
+
+/**
+ * writeback_release: relinquish exclusive writeback access against a device.
+ * @bdi: the device's backing_dev_info structure
+ */
+static void writeback_release(struct backing_dev_info *bdi)
+{
+	BUG_ON(!writeback_in_progress(bdi));
+	clear_bit(BDI_pdflush, &bdi->state);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -749,41 +788,3 @@ int generic_osync_inode(struct inode *inode, struct address_space *mapping, int
 }
 
 EXPORT_SYMBOL(generic_osync_inode);
-
-/**
- * writeback_acquire: attempt to get exclusive writeback access to a device
- * @bdi: the device's backing_dev_info structure
- *
- * It is a waste of resources to have more than one pdflush thread blocked on
- * a single request queue.  Exclusion at the request_queue level is obtained
- * via a flag in the request_queue's backing_dev_info.state.
- *
- * Non-request_queue-backed address_spaces will share default_backing_dev_info,
- * unless they implement their own.  Which is somewhat inefficient, as this
- * may prevent concurrent writeback against multiple devices.
- */
-int writeback_acquire(struct backing_dev_info *bdi)
-{
-	return !test_and_set_bit(BDI_pdflush, &bdi->state);
-}
-
-/**
- * writeback_in_progress: determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback in progress against a backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return test_bit(BDI_pdflush, &bdi->state);
-}
-
-/**
- * writeback_release: relinquish exclusive writeback access against a device.
- * @bdi: the device's backing_dev_info structure
- */
-void writeback_release(struct backing_dev_info *bdi)
-{
-	BUG_ON(!writeback_in_progress(bdi));
-	clear_bit(BDI_pdflush, &bdi->state);
-}
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 48a62ba..b66fa2b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -156,9 +156,7 @@ static inline unsigned long bdi_stat_error(struct backing_dev_info *bdi)
 extern struct backing_dev_info default_backing_dev_info;
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
-int writeback_acquire(struct backing_dev_info *bdi);
 int writeback_in_progress(struct backing_dev_info *bdi);
-void writeback_release(struct backing_dev_info *bdi);
 
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {

