Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZIOR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZIOR3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZIOR3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 13:29:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZIOR3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 13:29:23 -0400
Date: Tue, 15 Sep 2009 19:29:24 +0200
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] Ext3: data=guarded mode
Message-ID: <20090915172924.GI12169@duck.suse.cz>
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com> <1252422595-4554-3-git-send-email-chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252422595-4554-3-git-send-email-chris.mason@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Chris,

  thanks for the patch and sorry for replying a bit late...

On Tue 08-09-09 11:09:55, Chris Mason wrote:
> ext3 data=ordered mode makes sure that data blocks are on disk before
> the metadata that references them, which avoids files full of garbage
> or previously deleted data after a crash.  It does this by adding every dirty
> buffer onto a list of things that must be written before a commit.
> 
> This makes every fsync write out all the dirty data on the entire FS, which
> has high latencies and is generally much more expensive than it needs to be.
> 
> Another way to avoid exposing stale data after a crash is to wait until
> after the data buffers are written before updating the on-disk record
> of the file's size.  If we crash before the data IO is done, i_size
> doesn't yet include the new blocks and no stale data is exposed.
> 
> This patch adds the delayed i_size update to ext3, along with a new
> mount option (data=guarded) to enable it.  The basic mechanism works like
> this:
> 
> * Add a list to the in-memory ext3 inode for tracking data=guarded
> buffer heads that are waiting to be sent to disk.
> 
> * Add an ext3 guarded write_end call to add buffer heads for newly
> allocated blocks into the list.  If we have a newly allocated block that is
> filling a hole inside i_size, this is done as an old style data=ordered write
> instead.
> 
> * Add an ext3 guarded writepage call that uses a special buffer head
> end_io handler for buffers that are marked as guarded.  Again, if we find
> newly allocated blocks filling holes, they are sent through data=ordered
> instead of data=guarded.
> 
> * When a guarded IO finishes, kick a per-FS workqueue to do the
> on disk i_size updates.  The workqueue function must be very careful.  We only
> update the on disk i_size if all of the IO between the old on disk i_size and
> the new on disk i_size is complete.  The on disk i_size is incrementally
> updated to the largest safe value every time an IO completes.
> 
> * When we start tracking guarded buffers on a given inode, we put the
> inode into ext3's orphan list.  This way if we do crash, the file will
> be truncated back down to the on disk i_size and we'll free any blocks that
> were not completely written.  The inode is removed from the orphan list
> only after all the guarded buffers are done.
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> ---
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index a272365..248ac79 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -179,6 +180,110 @@ static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
>  }
>  
>  /*
> + * after a data=guarded IO is done, we need to update the
> + * disk i_size to reflect the data we've written.  If there are
> + * no more ordered data extents left in the list, we need to
> + * get rid of the orphan entry making sure the file's
> + * block pointers match the i_size after a crash
> + *
> + * When we aren't in data=guarded mode, this just does an ext3_orphan_del.
> + *
> + * It returns the result of ext3_orphan_del.
> + *
> + * handle may be null if we are just cleaning up the orphan list in
> + * memory.
> + *
> + * pass must_log == 1 when the inode must be logged in order to get
> + * an i_size update on disk
> + */
> +static int orphan_del(handle_t *handle, struct inode *inode, int must_log)
> +{
> +	int ret = 0;
> +	struct list_head *ordered_list;
> +
> +	ordered_list = &EXT3_I(inode)->ordered_buffers.ordered_list;
> +
> +	/* fast out when data=guarded isn't on */
> +	if (!ext3_should_guard_data(inode)) {
> +		WARN_ON(must_log);
> +		return ext3_orphan_del(handle, inode);
> +	}
> +
> +	ext3_ordered_lock(inode);
> +	if (inode->i_nlink && list_empty(ordered_list)) {
> +		ext3_ordered_unlock(inode);
> +
> +		lock_super(inode->i_sb);
> +
> +		/*
> +		 * now that we have the lock make sure we are allowed to
> +		 * get rid of the orphan.  This way we make sure our
> +		 * test isn't happening concurrently with someone else
> +		 * adding an orphan.  Memory barrier for the ordered list.
> +		 */
> +		smp_mb();
> +		if (inode->i_nlink == 0 || !list_empty(ordered_list)) {
  The code here still looks suspicious.
1) Inodes can be on orphan list with i_nlink > 0 when a write failed for
   some reason and we have to truncate blocks instantiated beyond i_size.
   Those places (similarly as truncate) expect that while they hold i_mutex
   they are safe doing what they want with the orphan list. This code would
   happily remove the inode from orphan list...
2) Cannot it happen that:
     CPU1
orphan_del()
  if (inode->i_nlink && list_empty(ordered_list)) {
	ext3_ordered_unlock(inode);
	lock_super(inode->i_sb);
	smp_mb();
	if (inode->i_nlink == 0 || !list_empty(ordered_list)) {

     CPU2
journal_dirty_data_guarded_fn()
  ret = ext3_add_ordered_extent(inode, offset, bh);
  if (ret == 0 && buffer_dataguarded(bh) &&
      list_empty(&EXT3_I(inode)->i_orphan) &&
      !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS)) - list isn't
empty yet so we don't add inode to orphan list, but on CPU1, we go ahead
and remove inode from the orphan list...

  We could fix it by removing the list_empty() check but that means taking
superblock lock on each journal_dirty_data_guarded_fn() call which isn't
nice either.
  Maybe we could postpone removing inode from orphan list until we can do
proper locking. But that means that we would have to do it from a different
thread after ending page writeback. Or we could just set i_disksize from
end_io, pin the inode in memory by dirtying it and queue work doing proper
ext3_mark_inode_dirty() and ext3_orphan_del(). This looks like the cleanest
way way but it would need a way to call __mark_inode_dirty() without calling
->dirty_inode() and a support in ext3_write_inode().

> +			unlock_super(inode->i_sb);
> +			if (must_log)
> +				ext3_mark_inode_dirty(handle, inode);
> +			goto out;
> +		}
> +
> +		/*
> +		 * if we aren't actually on the orphan list, the orphan
> +		 * del won't log our inode.  Log it now to make sure
> +		 */
> +		ext3_mark_inode_dirty(handle, inode);
> +
> +		ret = ext3_orphan_del_locked(handle, inode);
> +
> +		unlock_super(inode->i_sb);
> +	} else if (handle && must_log) {
> @@ -767,6 +879,24 @@ err_out:
>  }
>  
>  /*
> + * This protects the disk i_size with the  spinlock for the ordered
> + * extent tree.  It returns 1 when the inode needs to be logged
> + * because the i_disksize has been updated.
> + */
> +static int maybe_update_disk_isize(struct inode *inode, loff_t new_size)
> +{
> +	int ret = 0;
> +
> +	ext3_ordered_lock(inode);
> +	if (EXT3_I(inode)->i_disksize < new_size) {
> +		EXT3_I(inode)->i_disksize = new_size;
> +		ret = 1;
> +	}
> +	ext3_ordered_unlock(inode);
> +	return ret;
> +}
  Why is this function here? It is called only from update_file_sizes()
which is called only from ext3_ordered_write_end() and
ext3_writeback_write_end(). So ordered_lock shouldn't be needed for them?

> @@ -1294,6 +1595,73 @@ static int ext3_ordered_write_end(struct file *file,
>  	return ret ? ret : copied;
>  }
>  
> +static int ext3_guarded_write_end(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata)
> +{
> +	handle_t *handle = ext3_journal_current_handle();
> +	struct inode *inode = file->f_mapping->host;
> +	unsigned from, to;
> +	int ret = 0, ret2;
> +
> +	copied = block_write_end(file, mapping, pos, len, copied,
> +				 page, fsdata);
> +
> +	from = pos & (PAGE_CACHE_SIZE - 1);
> +	to = from + copied;
> +	ret = walk_page_buffers(handle, page_buffers(page),
> +		from, to, NULL, journal_dirty_data_guarded_fn);
> +
> +	/*
> +	 * we only update the in-memory i_size.  The disk i_size is done
> +	 * by the end io handlers
> +	 */
> +	if (ret == 0 && pos + copied > inode->i_size) {
> +		int must_log;
> +
> +		/* updated i_size, but we may have raced with a
> +		 * data=guarded end_io handler.
                   I don't understand the above sentence.

> +int ext3_put_ordered_extent(struct ext3_ordered_extent *entry)
> +{
> +	if (atomic_dec_and_test(&entry->refs)) {
> +		WARN_ON(entry->bh);
> +		WARN_ON(entry->end_io_bh);
> +		kfree(entry);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * remove an ordered extent from the list.  This removes the
> + * reference held by the list on 'entry' and the
> + * reference on the buffer head held by the entry.
> + */
  Maybe add a note that this expects buffers->lock (ext3_ordered_lock) to be
locked.

> +int ext3_remove_ordered_extent(struct inode *inode,
> +				struct ext3_ordered_extent *entry)
...
> +/*
> + * during a truncate or delete, we need to get rid of pending
> + * ordered extents so there isn't a war over who updates disk i_size first.
> + * This does that, without waiting for any of the IO to actually finish.
> + *
> + * When the IO does finish, it will find the ordered extent removed from the
> + * list and all will work properly.
> + */
> +void ext3_truncate_ordered_extents(struct inode *inode, u64 offset)
> +{
> +	struct ext3_ordered_buffers *buffers = &EXT3_I(inode)->ordered_buffers;
> +	struct ext3_ordered_extent *test;
> +
> +	spin_lock(&buffers->lock);
  It would be easier to read if you used ext3_ordered_lock() here as
everywhere else...

> +	while (!list_empty(&buffers->ordered_list)) {
> +
> +		test = list_entry(buffers->ordered_list.prev,
> +				  struct ext3_ordered_extent, ordered_list);
> +
> +		if (test->start < offset)
> +			break;
> +		/*
> +		 * once this is called, the end_io handler won't run,
> +		 * and we won't update disk_i_size to include this buffer.
> +		 *
> +		 * That's ok for truncates because the truncate code is
> +		 * writing a new i_size.
> +		 *
> +		 * This ignores any IO in flight, which is ok
> +		 * because the guarded_buffers list has a reference
> +		 * on the ordered extent
> +		 */
> +		ext3_remove_ordered_extent(inode, test);
> +	}
> +	spin_unlock(&buffers->lock);
> +	return;
> +
> +}
...

> diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
> index ca1bfe9..a6cf26d 100644
> --- a/include/linux/ext3_fs_i.h
> +++ b/include/linux/ext3_fs_i.h
> @@ -137,6 +180,8 @@ struct ext3_inode_info {
>  	 * by other means, so we have truncate_mutex.
>  	 */
>  	struct mutex truncate_mutex;
> +
> +	struct ext3_ordered_buffers ordered_buffers;
>  	struct inode vfs_inode;
>  };
  Hmm, how hard would it be to hide especially this behind
CONFIG_EXT3_GUARDED_DATA so that we can avoid increasing inode size for
users which are not interested in the new guarded mode?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
