Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYAJPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYAJPz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYAJPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:55:17 -0500
Received: from styx.suse.cz ([82.119.242.94]:52370 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755950AbYAJPzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:55:15 -0500
Date: Thu, 10 Jan 2008 16:55:13 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Supriya Kannery <supriyak@in.ibm.com>
Subject: Re: [PATCH] Fix private_list handling
Message-ID: <20080110155513.GB12697@duck.suse.cz>
References: <20080110154959.GA12697@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110154959.GA12697@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  sorry for the previous empty email...

  Supriya noted in his testing that sometimes buffers removed by
__remove_assoc_queue() don't have b_assoc_mapping set (and thus IO error
won't be properly propagated). Actually, looking more into the code I found
there are some more races. The patch below should fix them. It survived
beating with LTP and fsstress on ext2 filesystem on my testing machine so
it should be reasonably bugfree... Andrew, would you put the patch into
-mm? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

There are two possible races in handling of private_list in buffer cache.
1) When fsync_buffers_list() processes a private_list, it clears
b_assoc_mapping and moves buffer to its private list. Now drop_buffers() comes,
sees a buffer is on list so it calls __remove_assoc_queue() which complains
about b_assoc_mapping being cleared (as it cannot propagate possible IO error).
This race has been actually observed in the wild.
2) When fsync_buffers_list() processes a private_list,
mark_buffer_dirty_inode() can be called on bh which is already on the private
list of fsync_buffers_list(). As buffer is on some list (note that the check is
performed without private_lock), it is not readded to the mapping's
private_list and after fsync_buffers_list() finishes, we have a dirty buffer
which should be on private_list but it isn't. This race has not been reported,
probably because most (but not all) callers of mark_buffer_dirty_inode() hold
i_mutex and thus are serialized with fsync().

Fix these issues by rewriting fsync_buffers_list() to not move buffers to
dedicated private list (which has an additional bonus of reducing code size)
and scan original private_list instead (some care has to be taken to avoid
racing with drop_buffers()). Also mark_buffer_dirty_inode() is modified
to avoid race 2).

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..8691fa5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -563,15 +563,6 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * take an address_space, not an inode.  And it should be called
  * mark_buffer_dirty_fsync() to clearly define why those buffers are being
  * queued up.
- *
- * FIXME: mark_buffer_dirty_inode() doesn't need to add the buffer to the
- * list if it is already on a list.  Because if the buffer is on a list,
- * it *must* already be on the right one.  If not, the filesystem is being
- * silly.  This will save a ton of locking.  But first we have to ensure
- * that buffers are taken *off* the old inode's list when they are freed
- * (presumably in truncate).  That requires careful auditing of all
- * filesystems (do it inside bforget()).  It could also be done by bringing
- * b_inode back.
  */
 
 /*
@@ -591,41 +582,6 @@ int inode_has_buffers(struct inode *inode)
 	return !list_empty(&inode->i_data.private_list);
 }
 
-/*
- * osync is designed to support O_SYNC io.  It waits synchronously for
- * all already-submitted IO to complete, but does not queue any new
- * writes to the disk.
- *
- * To do O_SYNC writes, just queue the buffer writes with ll_rw_block as
- * you dirty the buffers, and then use osync_inode_buffers to wait for
- * completion.  Any other dirty buffers which are not yet queued for
- * write will not be flushed to disk by the osync.
- */
-static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct list_head *p;
-	int err = 0;
-
-	spin_lock(lock);
-repeat:
-	list_for_each_prev(p, list) {
-		bh = BH_ENTRY(p);
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(lock);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				err = -EIO;
-			brelse(bh);
-			spin_lock(lock);
-			goto repeat;
-		}
-	}
-	spin_unlock(lock);
-	return err;
-}
-
 /**
  * sync_mapping_buffers - write out and wait upon a mapping's "associated"
  *                        buffers
@@ -634,6 +590,11 @@ repeat:
  * Starts I/O against the buffers at mapping->private_list, and waits upon
  * that I/O.
  *
+ * The caller must make sure (usually by holding i_mutex) that we cannot race
+ * with invalidate_inode_buffers() or remove_inode_buffers() calling
+ * __remove_assoc_queue(). Racing with drop_buffers() is fine and is taken care
+ * of.
+ *
  * Basically, this is a convenience function for fsync().
  * @mapping is a file or directory which needs those buffers to be written for
  * a successful fsync().
@@ -667,22 +628,28 @@ void write_boundary_block(struct block_device *bdev,
 	}
 }
 
+/* Mark buffer as dirty and add it to inode mapping's private_list. We play
+ * tricks to avoid locking private_lock when not needed and still keep
+ * fsync_buffers_list() from removing the buffer we are just adding. */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct address_space *buffer_mapping = bh->b_page->mapping;
 
-	mark_buffer_dirty(bh);
-	if (!mapping->assoc_mapping) {
+	if (!mapping->assoc_mapping)
 		mapping->assoc_mapping = buffer_mapping;
-	} else {
+	else
 		BUG_ON(mapping->assoc_mapping != buffer_mapping);
-	}
-	if (list_empty(&bh->b_assoc_buffers)) {
+
+	if (!buffer_dirty(bh) || !bh->b_assoc_map) {
+		mark_buffer_dirty(bh);
 		spin_lock(&buffer_mapping->private_lock);
-		list_move_tail(&bh->b_assoc_buffers,
+		/* Recheck under spinlock */
+		if (!bh->b_assoc_map) {
+			bh->b_assoc_map = mapping;
+			list_add_tail(&bh->b_assoc_buffers,
 				&mapping->private_list);
-		bh->b_assoc_map = mapping;
+		}
 		spin_unlock(&buffer_mapping->private_lock);
 	}
 }
@@ -772,72 +739,69 @@ int __set_page_dirty_buffers(struct page *page)
 EXPORT_SYMBOL(__set_page_dirty_buffers);
 
 /*
- * Write out and wait upon a list of buffers.
+ * Write out and wait upon a list of buffers. 
  *
- * We have conflicting pressures: we want to make sure that all
- * initially dirty buffers get waited on, but that any subsequently
- * dirtied buffers don't.  After all, we don't want fsync to last
- * forever if somebody is actively writing to the file.
+ * We have conflicting pressures: we want to make sure that all initially dirty
+ * buffers get waited on, but that any subsequently dirtied buffers don't.
+ * After all, we don't want fsync to last forever if somebody is actively
+ * writing to the file.
  *
- * Do this in two main stages: first we copy dirty buffers to a
- * temporary inode list, queueing the writes as we go.  Then we clean
- * up, waiting for those writes to complete.
+ * Do this in two sweeps of the private_list. In the first one we queue writes
+ * of dirty buffers, in the second one we wait for locked buffers.
  * 
- * During this second stage, any subsequent updates to the file may end
- * up refiling the buffer on the original inode's dirty list again, so
- * there is a chance we will end up with a buffer queued for write but
- * not yet completed on that list.  So, as a final cleanup we go through
- * the osync code to catch these locked, dirty buffers without requeuing
- * any newly dirty buffers for write.
+ * The locking here is a bit subtle. We hold i_mutex so we are safe from most
+ * other users of private_list (especially the ones removing buffers from the
+ * list). Only drop_buffers() can still remove a buffer from private_list and
+ * from that we are guarded by the reference to the buffer we acquire. So we
+ * continue scanning the list after we reacquire the private lock.
  */
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
-	struct list_head tmp;
-	int err = 0, err2;
-
-	INIT_LIST_HEAD(&tmp);
+	struct list_head *cur, *next;
+	int err = 0;
 
 	spin_lock(lock);
-	while (!list_empty(list)) {
-		bh = BH_ENTRY(list->next);
-		__remove_assoc_queue(bh);
-		if (buffer_dirty(bh) || buffer_locked(bh)) {
-			list_add(&bh->b_assoc_buffers, &tmp);
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(lock);
-				/*
-				 * Ensure any pending I/O completes so that
-				 * ll_rw_block() actually writes the current
-				 * contents - it is a noop if I/O is still in
-				 * flight on potentially older contents.
-				 */
-				ll_rw_block(SWRITE, 1, &bh);
-				brelse(bh);
-				spin_lock(lock);
-			}
+	list_for_each_entry(bh, list, b_assoc_buffers) {
+		if (buffer_dirty(bh)) {
+			get_bh(bh);
+			spin_unlock(lock);
+			/*
+			 * Ensure any pending I/O completes so that
+			 * ll_rw_block() actually writes the current
+			 * contents - it is a noop if I/O is still in
+			 * flight on potentially older contents.
+			 */
+			ll_rw_block(SWRITE, 1, &bh);
+			spin_lock(lock);
+			BUG_ON(list_empty(&bh->b_assoc_buffers));
+			brelse(bh);
 		}
 	}
 
-	while (!list_empty(&tmp)) {
-		bh = BH_ENTRY(tmp.prev);
-		list_del_init(&bh->b_assoc_buffers);
+	for (cur = list->next; cur != list; cur = next) {
+		bh = list_entry(cur, struct buffer_head, b_assoc_buffers);
+		if (!buffer_locked(bh)) {
+			next = cur->next;
+			if (!buffer_dirty(bh))
+				__remove_assoc_queue(bh);
+			continue;
+		}
 		get_bh(bh);
 		spin_unlock(lock);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			err = -EIO;
-		brelse(bh);
 		spin_lock(lock);
+		BUG_ON(list_empty(&bh->b_assoc_buffers));
+		next = cur->next;
+		if (!buffer_dirty(bh) && !buffer_locked(bh))
+			__remove_assoc_queue(bh);
+		brelse(bh);
 	}
-	
 	spin_unlock(lock);
-	err2 = osync_buffers_list(lock, list);
-	if (err)
-		return err;
-	else
-		return err2;
+
+	return err;
 }
 
 /*
@@ -1195,7 +1159,7 @@ void __brelse(struct buffer_head * buf)
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
-	if (!list_empty(&bh->b_assoc_buffers)) {
+	if (bh->b_assoc_map) {
 		struct address_space *buffer_mapping = bh->b_page->mapping;
 
 		spin_lock(&buffer_mapping->private_lock);
@@ -3037,7 +3001,7 @@ drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
 	do {
 		struct buffer_head *next = bh->b_this_page;
 
-		if (!list_empty(&bh->b_assoc_buffers))
+		if (bh->b_assoc_map)
 			__remove_assoc_queue(bh);
 		bh = next;
 	} while (bh != head);
