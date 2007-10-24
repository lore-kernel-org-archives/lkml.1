Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXJXVZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXJXVZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXJXVZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:25:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXJXVZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:25:41 -0400
Message-ID: <471FB852.8090802@ce.jp.nec.com>
Date: Wed, 24 Oct 2007 17:25:38 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: noflush resizing (1/3) Add bdlookup()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds bdlookup() and bdlookup_disk().
They are lookup-only variant of bdget()/bdget_disk().

The function can be used when
  - the caller wants to get bdev only if somebody already got it
    (i.e. there is already bd_inode allocated in memory)
  - the race between bdlookup() and bdget() is acceptable

The patch is a preparation for the 2nd part of this patchset.

Background:
  inode is initialized with I_LOCK and I_NEW turned on.
  After initialization, both flags are turned off.

  bdget() uses iget5_locked(), which waits until I_LOCK is removed.
  It could take so long or forever.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 fs/block_dev.c        |   27 +++++++++++++++++++++++++++
 include/linux/fs.h    |    4 +++-
 include/linux/genhd.h |    6 ++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6.23.work/fs/block_dev.c
===================================================================
--- linux-2.6.23.work.orig/fs/block_dev.c
+++ linux-2.6.23.work/fs/block_dev.c
@@ -586,6 +586,33 @@ struct block_device *bdget(dev_t dev)
 
 EXPORT_SYMBOL(bdget);
 
+/*
+ * Variant of bdget(), which returns bdev only when it is already gotten.
+ *
+ * The function can be used when:
+ *   - the caller wants to get bdev only if somebody already got it
+ *     (i.e. there is already bd_inode allocated in memory)
+ * and
+ *   - the race between bdlookup() and bdget() is acceptable
+ */
+struct block_device *bdlookup(dev_t dev)
+{
+	struct inode *inode;
+
+	might_sleep();
+
+	/* Use _nowait because we don't want to wait for I_LOCK */
+	inode = ilookup5_nowait(bd_mnt->mnt_sb, hash(dev), bdev_test, &dev);
+
+	if (!inode)
+		return NULL;
+
+	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
+
+	return &BDEV_I(inode)->bdev;
+}
+EXPORT_SYMBOL(bdlookup);
+
 long nr_blockdev_pages(void)
 {
 	struct block_device *bdev;
Index: linux-2.6.23.work/include/linux/fs.h
===================================================================
--- linux-2.6.23.work.orig/include/linux/fs.h
+++ linux-2.6.23.work/include/linux/fs.h
@@ -1211,10 +1211,11 @@ struct super_operations {
 #define I_DIRTY_DATASYNC	2 /* Data-related inode changes pending */
 #define I_DIRTY_PAGES		4 /* Data-related inode changes pending */
 #define __I_LOCK		3
+#define __I_NEW			6
 #define I_LOCK			(1 << __I_LOCK)
 #define I_FREEING		16
 #define I_CLEAR			32
-#define I_NEW			64
+#define I_NEW			(1 << __I_NEW)
 #define I_WILL_FREE		128
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
@@ -1431,6 +1432,7 @@ extern void putname(const char *name);
 extern int register_blkdev(unsigned int, const char *);
 extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
+extern struct block_device *bdlookup(dev_t);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
Index: linux-2.6.23.work/include/linux/genhd.h
===================================================================
--- linux-2.6.23.work.orig/include/linux/genhd.h
+++ linux-2.6.23.work/include/linux/genhd.h
@@ -435,6 +435,12 @@ static inline struct block_device *bdget
 	return bdget(MKDEV(disk->major, disk->first_minor) + index);
 }
 
+static inline struct block_device *bdlookup_disk(struct gendisk *disk,
+						 int index)
+{
+	return bdlookup(MKDEV(disk->major, disk->first_minor) + index);
+}
+
 #endif
 
 #else /* CONFIG_BLOCK */
