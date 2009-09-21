Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZIUQaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZIUQaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZIUQaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:30:10 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:27190 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZIUQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:30:07 -0400
Date: Mon, 21 Sep 2009 12:29:59 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] Ext3: data=guarded mode
Message-ID: <20090921162959.GF6259@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
 <1252422595-4554-3-git-send-email-chris.mason@oracle.com>
 <20090915172924.GI12169@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915172924.GI12169@duck.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AB7AA0C.003F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 07:29:24PM +0200, Jan Kara wrote:
>   The code here still looks suspicious.
> 1) Inodes can be on orphan list with i_nlink > 0 when a write failed for
>    some reason and we have to truncate blocks instantiated beyond i_size.
>    Those places (similarly as truncate) expect that while they hold i_mutex
>    they are safe doing what they want with the orphan list. This code would
>    happily remove the inode from orphan list...
> 2) Cannot it happen that:
>      CPU1
> orphan_del()
>   if (inode->i_nlink && list_empty(ordered_list)) {
> 	ext3_ordered_unlock(inode);
> 	lock_super(inode->i_sb);
> 	smp_mb();
> 	if (inode->i_nlink == 0 || !list_empty(ordered_list)) {
> 
>      CPU2
> journal_dirty_data_guarded_fn()
>   ret = ext3_add_ordered_extent(inode, offset, bh);
>   if (ret == 0 && buffer_dataguarded(bh) &&
>       list_empty(&EXT3_I(inode)->i_orphan) &&
>       !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) - list isn't
> empty yet so we don't add inode to orphan list, but on CPU1, we go ahead
> and remove inode from the orphan list...
> 
>   We could fix it by removing the list_empty() check but that means taking
> superblock lock on each journal_dirty_data_guarded_fn() call which isn't
> nice either.

I've just started testing this incremental, but wanted to send it along
so you could poke holes in the idea.  Instead of trying to loop around a
lack of locking, I've just added the ordered lock into the orphan
processing.

With this patch we have the ordered lock held when we're deciding if
we're allowed to remove an orphan off the list.  It will catch new
ordered extents being added to the list, and after new extents are added
we have the ordered lock held while we are testing the orphan list.

I think it should solve all the problems, aside from the part where
ext3_orphan_del_locked drops the ordered lock halfway through the call.

The second major problem you brought up was with truncate.  write_begin
and write_end both add an orphan and ext3_truncate to make sure the
metadata matches i_size when things go wrong.

This incremental changes the guarded code to flag a given inode as
pinned on the ordered list.  It won't be removed from the ordered list
until it is unpinned, and truncate is the only place that unpins it.
This allows us to make sure the inode stays on the orphan list the
entire time truncate is working, regardless of how many transactions
take place.

I was planning on just flushing the guarded list, but that doesn't work
with the page lock held, and write_end needs the page lock held until
after we are added to the orphan list.

This is incremental over the last patch and barely tested.  Its really
only meant for Jan ;)

-chris

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 248ac79..a9d3cf6 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -209,6 +209,9 @@ static int orphan_del(handle_t *handle, struct inode *inode, int must_log)
 		return ext3_orphan_del(handle, inode);
 	}
 
+	if (ext3_ordered_orphan_pinned(inode))
+		return 0;
+
 	ext3_ordered_lock(inode);
 	if (inode->i_nlink && list_empty(ordered_list)) {
 		ext3_ordered_unlock(inode);
@@ -219,23 +222,27 @@ static int orphan_del(handle_t *handle, struct inode *inode, int must_log)
 		 * now that we have the lock make sure we are allowed to
 		 * get rid of the orphan.  This way we make sure our
 		 * test isn't happening concurrently with someone else
-		 * adding an orphan.  Memory barrier for the ordered list.
+		 * adding an orphan.
 		 */
-		smp_mb();
-		if (inode->i_nlink == 0 || !list_empty(ordered_list)) {
+		ext3_ordered_lock(inode);
+		if (inode->i_nlink == 0 || !list_empty(ordered_list) ||
+		    ext3_ordered_orphan_pinned(inode)) {
+			ext3_ordered_unlock(inode);
 			unlock_super(inode->i_sb);
 			if (must_log)
 				ext3_mark_inode_dirty(handle, inode);
 			goto out;
 		}
 
+		/* this drops the ordered lock for us */
+		ret = ext3_orphan_del_locked(handle, inode);
+
 		/*
 		 * if we aren't actually on the orphan list, the orphan
 		 * del won't log our inode.  Log it now to make sure
 		 */
 		ext3_mark_inode_dirty(handle, inode);
 
-		ret = ext3_orphan_del_locked(handle, inode);
 
 		unlock_super(inode->i_sb);
 	} else if (handle && must_log) {
@@ -879,24 +886,6 @@ err_out:
 }
 
 /*
- * This protects the disk i_size with the  spinlock for the ordered
- * extent tree.  It returns 1 when the inode needs to be logged
- * because the i_disksize has been updated.
- */
-static int maybe_update_disk_isize(struct inode *inode, loff_t new_size)
-{
-	int ret = 0;
-
-	ext3_ordered_lock(inode);
-	if (EXT3_I(inode)->i_disksize < new_size) {
-		EXT3_I(inode)->i_disksize = new_size;
-		ret = 1;
-	}
-	ext3_ordered_unlock(inode);
-	return ret;
-}
-
-/*
  * Allocation strategy is simple: if we have to allocate something, we will
  * have to go the whole way to leaf. So let's do it before attaching anything
  * to tree, set linkage between the newborn blocks, write them if sync is
@@ -1394,11 +1383,15 @@ write_begin_failed:
 		 * finishes. Do this only if ext3_can_truncate() agrees so
 		 * that orphan processing code is happy.
 		 */
-		if (pos + len > inode->i_size && ext3_can_truncate(inode))
+		if (pos + len > inode->i_size && ext3_can_truncate(inode)) {
+			ext3_ordered_pin_orphan(inode);
 			ext3_orphan_add(handle, inode);
+		}
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+
+		/* truncate unpins the orphan */
 		if (pos + len > inode->i_size)
 			ext3_truncate(inode);
 	}
@@ -1489,11 +1482,17 @@ static int journal_dirty_data_guarded_fn(handle_t *handle,
 	 * list is the work queue to process completed guarded
 	 * buffers.  That will find the ordered_extent we added
 	 * above and leave us on the orphan list.
+	 *
+	 * We have the ordered lock while testing the orphan list for empty
 	 */
+	ext3_ordered_lock(inode);
 	if (ret == 0 && buffer_dataguarded(bh) &&
 	    list_empty(&EXT3_I(inode)->i_orphan) &&
 	    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) {
-			ret = ext3_orphan_add(handle, inode);
+		ext3_ordered_unlock(inode);
+		ret = ext3_orphan_add(handle, inode);
+	} else {
+		ext3_ordered_unlock(inode);
 	}
 out:
 	return ret;
@@ -1548,8 +1547,10 @@ static void update_file_sizes(struct inode *inode, loff_t pos, unsigned copied)
 	/* What matters to us is i_disksize. We don't write i_size anywhere */
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
-	if (maybe_update_disk_isize(inode, pos + copied))
+	if (pos + copied > EXT3_I(inode)->i_disksize) {
+		EXT3_I(inode)->i_disksize = pos + copied;
 		mark_inode_dirty(inode);
+	}
 }
 
 /*
@@ -1620,9 +1621,7 @@ static int ext3_guarded_write_end(struct file *file,
 	if (ret == 0 && pos + copied > inode->i_size) {
 		int must_log;
 
-		/* updated i_size, but we may have raced with a
-		 * data=guarded end_io handler.
-		 *
+		/*
 		 * All the guarded IO could have ended while i_size was still
 		 * small, and if we're just adding bytes into an existing block
 		 * in the file, we may not be adding a new guarded IO with this
@@ -2962,7 +2961,11 @@ void ext3_truncate(struct inode *inode)
 	 *
 	 * Implication: the file must always be in a sane, consistent
 	 * truncatable state while each transaction commits.
+	 *
+	 * We don't want any of the data=guarded end io handlers to take
+	 * this orphan off the list, so we flag it to make sure it stays
 	 */
+	ext3_ordered_pin_orphan(inode);
 	if (ext3_orphan_add(handle, inode))
 		goto out_stop;
 
@@ -3085,6 +3088,8 @@ out_stop:
 	 * ext3_delete_inode(), and we allow that function to clean up the
 	 * orphan info for us.
 	 */
+	ext3_ordered_unpin_orphan(inode);
+
 	if (inode->i_nlink)
 		orphan_del(handle, inode, 0);
 
@@ -3095,8 +3100,10 @@ out_notrans:
 	 * Delete the inode from orphan list so that it doesn't stay there
 	 * forever and trigger assertion on umount.
 	 */
-	if (inode->i_nlink)
+	if (inode->i_nlink) {
+		ext3_ordered_unpin_orphan(inode);
 		orphan_del(NULL, inode, 0);
+	}
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 711549a..7a3fc1f 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1978,6 +1978,9 @@ int ext3_orphan_del(handle_t *handle, struct inode *inode)
 	int ret;
 
 	lock_super(inode->i_sb);
+	ext3_ordered_lock(inode);
+
+	/* drops the ordered lock for us */
 	ret = ext3_orphan_del_locked(handle, inode);
 	unlock_super(inode->i_sb);
 	return ret;
@@ -1986,6 +1989,9 @@ int ext3_orphan_del(handle_t *handle, struct inode *inode)
 /*
  * ext3_orphan_del() removes an unlinked or truncated inode from the list
  * of such inodes stored on disk, because it is finally being cleaned up.
+ *
+ * This expects the ordered lock to be held by the caller and will drop
+ * it right after removing our inode from the orphan list
  */
 int ext3_orphan_del_locked(handle_t *handle, struct inode *inode)
 {
@@ -1996,8 +2002,10 @@ int ext3_orphan_del_locked(handle_t *handle, struct inode *inode)
 	struct ext3_iloc iloc;
 	int err = 0;
 
-	if (list_empty(&ei->i_orphan))
+	if (list_empty(&ei->i_orphan)) {
+		ext3_ordered_unlock(inode);
 		return 0;
+	}
 
 	ino_next = NEXT_ORPHAN(inode);
 	prev = ei->i_orphan.prev;
@@ -2007,6 +2015,12 @@ int ext3_orphan_del_locked(handle_t *handle, struct inode *inode)
 
 	list_del_init(&ei->i_orphan);
 
+	/*
+	 * now that we're off the orphan list, the ordered extent code will
+	 * add it back if a new extent is added.  Drop the ordered lock here
+	 */
+	ext3_ordered_unlock(inode);
+
 	/* If we're on an error path, we may not have a valid
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
diff --git a/fs/ext3/ordered-data.c b/fs/ext3/ordered-data.c
index 9f12474..cc8f01d 100644
--- a/fs/ext3/ordered-data.c
+++ b/fs/ext3/ordered-data.c
@@ -24,6 +24,9 @@
 #include <linux/buffer_head.h>
 #include <linux/ext3_jbd.h>
 
+/* bits for the flag field of the ext3_ordered_buffers struct */
+#define ORDERED_FLAG_PIN_ORPHAN 0
+
 /*
  * simple helper to make sure a new entry we're adding is
  * at a larger offset in the file than the last entry in the list
@@ -108,6 +111,8 @@ int ext3_put_ordered_extent(struct ext3_ordered_extent *entry)
  * remove an ordered extent from the list.  This removes the
  * reference held by the list on 'entry' and the
  * reference on the buffer head held by the entry.
+ *
+ * The ordered lock must be held when calling this.
  */
 int ext3_remove_ordered_extent(struct inode *inode,
 				struct ext3_ordered_extent *entry)
@@ -200,7 +205,7 @@ void ext3_truncate_ordered_extents(struct inode *inode, u64 offset)
 	struct ext3_ordered_buffers *buffers = &EXT3_I(inode)->ordered_buffers;
 	struct ext3_ordered_extent *test;
 
-	spin_lock(&buffers->lock);
+	ext3_ordered_lock(inode);
 	while (!list_empty(&buffers->ordered_list)) {
 
 		test = list_entry(buffers->ordered_list.prev,
@@ -221,14 +226,32 @@ void ext3_truncate_ordered_extents(struct inode *inode, u64 offset)
 		 */
 		ext3_remove_ordered_extent(inode, test);
 	}
-	spin_unlock(&buffers->lock);
+	ext3_ordered_unlock(inode);
 	return;
 
 }
 
+void ext3_ordered_pin_orphan(struct inode *inode)
+{
+	set_bit(ORDERED_FLAG_PIN_ORPHAN,
+		&EXT3_I(inode)->ordered_buffers.flags);
+}
+
+void ext3_ordered_unpin_orphan(struct inode *inode)
+{
+	clear_bit(ORDERED_FLAG_PIN_ORPHAN,
+		&EXT3_I(inode)->ordered_buffers.flags);
+}
+
+int ext3_ordered_orphan_pinned(struct inode *inode)
+{
+	return test_bit(ORDERED_FLAG_PIN_ORPHAN,
+		&EXT3_I(inode)->ordered_buffers.flags);
+}
+
 void ext3_ordered_inode_init(struct ext3_inode_info *ei)
 {
 	INIT_LIST_HEAD(&ei->ordered_buffers.ordered_list);
 	spin_lock_init(&ei->ordered_buffers.lock);
+	ei->ordered_buffers.flags = 0;
 }
-
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 8583819..f55e7e9 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -963,6 +963,10 @@ int ext3_ordered_update_i_size(struct inode *inode);
 void ext3_ordered_inode_init(struct ext3_inode_info *ei);
 void ext3_truncate_ordered_extents(struct inode *inode, u64 offset);
 
+void ext3_ordered_pin_orphan(struct inode *inode);
+void ext3_ordered_unpin_orphan(struct inode *inode);
+int ext3_ordered_orphan_pinned(struct inode *inode);
+
 static inline void ext3_ordered_lock(struct inode *inode)
 {
 	spin_lock(&EXT3_I(inode)->ordered_buffers.lock);
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index a6cf26d..1e00648 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -76,6 +76,11 @@ struct ext3_ordered_buffers {
 	/* protects the list and disk i_size */
 	spinlock_t lock;
 
+	/*
+	 * only one flag right now, keep the orphan entry regardless of the
+	 * ordered data state
+	 */
+	unsigned long flags;
 	struct list_head ordered_list;
 };
 
