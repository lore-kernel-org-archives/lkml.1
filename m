Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZIDCuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZIDCuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbZIDCuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:50:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZIDCuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:50:15 -0400
Date: Thu, 3 Sep 2009 22:50:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090904025017.GB3658@infradead.org>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904024628.GA3658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904024628.GA3658@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 10:46:29PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 02, 2009 at 10:42:41AM +0200, Jens Axboe wrote:
> > This is a first step at introducing per-bdi flusher threads. We should
> > have no change in behaviour, although sb_has_dirty_inodes() is now
> > ridiculously expensive, as there's no easy way to answer that question.
> > Not a huge problem, since it'll be deleted in subsequent patches.
> 
> After this patch generic_sync_sb_inodes becomes pretty useless.  We
> have two callers which each want to call bdi_writeback_all, and one of
> them wants to wait, so just split that into a separate helper.
> 
> Also move wakeup_flusher_threads into fs-writeback.c, that allows us
> to make bdi_writeback_all static.
> 
> Btw, I do not think implementing sync_inodes_sb/sync_inodes_sb_wait
> is a smart and efficient idea.  Right now we have a n:1 superblock:bdi
> relation, so we really should make use of that instead of doing linear
> search of all bdis in the system.  If we introduce multiple bdis per
> superblock we should add an efficient lookup data structure for them.

Sorry, that patch was pre-fixing and quilt refresh.  Proper one below:


Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2009-09-03 23:35:30.544832785 -0300
+++ linux-2.6/fs/fs-writeback.c	2009-09-03 23:48:32.596833183 -0300
@@ -836,7 +836,7 @@ int bdi_writeback_task(struct bdi_writeb
  * we are simply called for WB_SYNC_NONE, then writeback will merely be
  * scheduled to run.
  */
-void bdi_writeback_all(struct writeback_control *wbc)
+static void bdi_writeback_all(struct writeback_control *wbc)
 {
 	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
 	struct backing_dev_info *bdi;
@@ -894,6 +894,25 @@ restart:
 	}
 }
 
+/*
+ * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
+ * the whole world.
+ */
+void wakeup_flusher_threads(long nr_pages)
+{
+	struct writeback_control wbc = {
+		.sync_mode	= WB_SYNC_NONE,
+		.older_than_this = NULL,
+		.range_cyclic	= 1,
+	};
+
+	if (nr_pages == 0)
+		nr_pages = global_page_state(NR_FILE_DIRTY) +
+				global_page_state(NR_UNSTABLE_NFS);
+	wbc.nr_to_write = nr_pages;
+	bdi_writeback_all(&wbc);
+}
+
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 {
 	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
@@ -1012,81 +1031,53 @@ out:
 EXPORT_SYMBOL(__mark_inode_dirty);
 
 /*
- * Write out a superblock's list of dirty inodes.  A wait will be performed
- * upon no inodes, all inodes or the final one, depending upon sync_mode.
- *
- * If older_than_this is non-NULL, then only write out inodes which
- * had their first dirtying at a time earlier than *older_than_this.
- *
- * If we're a pdlfush thread, then implement pdflush collision avoidance
- * against the entire list.
- *
- * If `bdi' is non-zero then we're being asked to writeback a specific queue.
- * This function assumes that the blockdev superblock's inodes are backed by
- * a variety of queues, so all inodes are searched.  For other superblocks,
- * assume that all inodes are backed by the same queue.
- *
- * The inodes to be written are parked on bdi->b_io.  They are moved back onto
- * bdi->b_dirty as they are selected for writing.  This way, none can be missed
- * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on inode_sync_wait.
+ * For a data integrity sync we must wait for all pages under writeback,
+ * because there may have been pages dirtied before our sync call, but which
+ * had writeout started before we write it out.  In which case, the inode
+ * may not be on the dirty list, but we still have to wait for that writeout.
  */
-static void generic_sync_sb_inodes(struct writeback_control *wbc)
+static void wait_sb_inodes(struct writeback_control *wbc)
 {
-	if (wbc->bdi)
-		bdi_start_writeback(wbc);
-	else
-		bdi_writeback_all(wbc);
+	struct inode *inode, *old_inode = NULL;
 
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		struct inode *inode, *old_inode = NULL;
+	/*
+	 * We need to be protected against the filesystem going from
+	 * r/o to r/w or vice versa.
+	 */
+	WARN_ON(!rwsem_is_locked(&wbc->sb->s_umount));
 
-		/*
-		 * We need to be protected against the filesystem going from
-		 * r/o to r/w or vice versa.
-		 */
-		WARN_ON(!rwsem_is_locked(&wbc->sb->s_umount));
+	spin_lock(&inode_lock);
 
-		spin_lock(&inode_lock);
+	list_for_each_entry(inode, &wbc->sb->s_inodes, i_sb_list) {
+		struct address_space *mapping;
+
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
+			continue;
+		mapping = inode->i_mapping;
+		if (mapping->nrpages == 0)
+			continue;
+		__iget(inode);
+		spin_unlock(&inode_lock);
 
 		/*
-		 * Data integrity sync. Must wait for all pages under writeback,
-		 * because there may have been pages dirtied before our sync
-		 * call, but which had writeout started before we write it out.
-		 * In which case, the inode may not be on the dirty list, but
-		 * we still have to wait for that writeout.
+		 * We hold a reference to 'inode' so it couldn't have
+		 * been removed from s_inodes list while we dropped the
+		 * inode_lock.  We cannot iput the inode now as we can
+		 * be holding the last reference and we cannot iput it
+		 * under inode_lock. So we keep the reference and iput
+		 * it later.
 		 */
-		list_for_each_entry(inode, &wbc->sb->s_inodes, i_sb_list) {
-			struct address_space *mapping;
-
-			if (inode->i_state &
-					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
-				continue;
-			mapping = inode->i_mapping;
-			if (mapping->nrpages == 0)
-				continue;
-			__iget(inode);
-			spin_unlock(&inode_lock);
-			/*
-			 * We hold a reference to 'inode' so it couldn't have
-			 * been removed from s_inodes list while we dropped the
-			 * inode_lock.  We cannot iput the inode now as we can
-			 * be holding the last reference and we cannot iput it
-			 * under inode_lock. So we keep the reference and iput
-			 * it later.
-			 */
-			iput(old_inode);
-			old_inode = inode;
+		iput(old_inode);
+		old_inode = inode;
 
-			filemap_fdatawait(mapping);
+		filemap_fdatawait(mapping);
 
-			cond_resched();
+		cond_resched();
 
-			spin_lock(&inode_lock);
-		}
-		spin_unlock(&inode_lock);
-		iput(old_inode);
+		spin_lock(&inode_lock);
 	}
+	spin_unlock(&inode_lock);
+	iput(old_inode);
 }
 
 /**
@@ -1112,7 +1103,7 @@ long sync_inodes_sb(struct super_block *
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
 	wbc.nr_to_write = nr_to_write;
-	generic_sync_sb_inodes(&wbc);
+	bdi_writeback_all(&wbc);
 	return nr_to_write - wbc.nr_to_write;
 }
 EXPORT_SYMBOL(sync_inodes_sb);
@@ -1132,10 +1123,11 @@ long sync_inodes_sb_wait(struct super_bl
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
-	long nr_to_write = LLONG_MAX; /* doesn't actually matter */
+	long nr_to_write = LONG_MAX; /* doesn't actually matter */
 
 	wbc.nr_to_write = nr_to_write;
-	generic_sync_sb_inodes(&wbc);
+	bdi_writeback_all(&wbc);
+	wait_sb_inodes(&wbc);
 	return nr_to_write - wbc.nr_to_write;
 }
 EXPORT_SYMBOL(sync_inodes_sb_wait);
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h	2009-09-03 23:42:42.968834087 -0300
+++ linux-2.6/include/linux/backing-dev.h	2009-09-03 23:42:45.124832763 -0300
@@ -99,7 +99,6 @@ int bdi_register_dev(struct backing_dev_
 void bdi_unregister(struct backing_dev_info *bdi);
 void bdi_start_writeback(struct writeback_control *wbc);
 int bdi_writeback_task(struct bdi_writeback *wb);
-void bdi_writeback_all(struct writeback_control *wbc);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2009-09-03 23:42:11.956834796 -0300
+++ linux-2.6/include/linux/writeback.h	2009-09-03 23:42:32.708832476 -0300
@@ -85,6 +85,7 @@ long sync_inodes_sb(struct super_block *
 long sync_inodes_sb_wait(struct super_block *);
 void sync_inodes_wbc(struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
+void wakeup_flusher_threads(long nr_pages);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
@@ -104,7 +105,6 @@ static inline void inode_sync_wait(struc
 /*
  * mm/page-writeback.c
  */
-void wakeup_flusher_threads(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
 void throttle_vm_writeout(gfp_t gfp_mask);
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2009-09-03 23:41:42.724833252 -0300
+++ linux-2.6/mm/page-writeback.c	2009-09-03 23:41:51.368832827 -0300
@@ -674,25 +674,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
         }
 }
 
-/*
- * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
- * the whole world.
- */
-void wakeup_flusher_threads(long nr_pages)
-{
-	struct writeback_control wbc = {
-		.sync_mode	= WB_SYNC_NONE,
-		.older_than_this = NULL,
-		.range_cyclic	= 1,
-	};
-
-	if (nr_pages == 0)
-		nr_pages = global_page_state(NR_FILE_DIRTY) +
-				global_page_state(NR_UNSTABLE_NFS);
-	wbc.nr_to_write = nr_pages;
-	bdi_writeback_all(&wbc);
-}
-
 static void laptop_timer_fn(unsigned long unused);
 
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
