Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbZIOSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbZIOSjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZIOSjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:39:13 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46523 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZIOSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:39:12 -0400
Date: Tue, 15 Sep 2009 14:39:06 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] Ext3: data=guarded mode
Message-ID: <20090915183906.GE23965@think>
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
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AAFDF4C.01C2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 07:29:24PM +0200, Jan Kara wrote:
>   Hi Chris,
> 
>   thanks for the patch and sorry for replying a bit late...
> 

Thanks for reading through things!

> > +static int orphan_del(handle_t *handle, struct inode *inode, int must_log)
> > +{
> > +	int ret = 0;
> > +	struct list_head *ordered_list;
> > +
> > +	ordered_list = &EXT3_I(inode)->ordered_buffers.ordered_list;
> > +
> > +	/* fast out when data=guarded isn't on */
> > +	if (!ext3_should_guard_data(inode)) {
> > +		WARN_ON(must_log);
> > +		return ext3_orphan_del(handle, inode);
> > +	}
> > +
> > +	ext3_ordered_lock(inode);
> > +	if (inode->i_nlink && list_empty(ordered_list)) {
> > +		ext3_ordered_unlock(inode);
> > +
> > +		lock_super(inode->i_sb);
> > +
> > +		/*
> > +		 * now that we have the lock make sure we are allowed to
> > +		 * get rid of the orphan.  This way we make sure our
> > +		 * test isn't happening concurrently with someone else
> > +		 * adding an orphan.  Memory barrier for the ordered list.
> > +		 */
> > +		smp_mb();
> > +		if (inode->i_nlink == 0 || !list_empty(ordered_list)) {
>   The code here still looks suspicious.
> 1) Inodes can be on orphan list with i_nlink > 0 when a write failed for
>    some reason and we have to truncate blocks instantiated beyond i_size.
>    Those places (similarly as truncate) expect that while they hold i_mutex
>    they are safe doing what they want with the orphan list. This code would
>    happily remove the inode from orphan list...

The only risky place for this is the work thread doing the ordered
writes.  Truncate gets around it by waiting for the ordered completions.
I'll add the wait to the error handlers as well.

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

This used to have a check after the orphan_del to re-add the orphan if
we raced with the end_io handlers.  I removed it because I thought it
was over-paranoid, but I see that you're right.  So, I'll put that one
back in.

> >  
> >  /*
> > + * This protects the disk i_size with the  spinlock for the ordered
> > + * extent tree.  It returns 1 when the inode needs to be logged
> > + * because the i_disksize has been updated.
> > + */
> > +static int maybe_update_disk_isize(struct inode *inode, loff_t new_size)
> > +{
> > +	int ret = 0;
> > +
> > +	ext3_ordered_lock(inode);
> > +	if (EXT3_I(inode)->i_disksize < new_size) {
> > +		EXT3_I(inode)->i_disksize = new_size;
> > +		ret = 1;
> > +	}
> > +	ext3_ordered_unlock(inode);
> > +	return ret;
> > +}
>   Why is this function here? It is called only from update_file_sizes()
> which is called only from ext3_ordered_write_end() and
> ext3_writeback_write_end(). So ordered_lock shouldn't be needed for them?

Well, its a leftover from the original patch.  I'll get rid of it.

> 
> > @@ -1294,6 +1595,73 @@ static int ext3_ordered_write_end(struct file *file,
> >  	return ret ? ret : copied;
> >  }
> >  
> > +static int ext3_guarded_write_end(struct file *file,
> > +				struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata)
> > +{
> > +	handle_t *handle = ext3_journal_current_handle();
> > +	struct inode *inode = file->f_mapping->host;
> > +	unsigned from, to;
> > +	int ret = 0, ret2;
> > +
> > +	copied = block_write_end(file, mapping, pos, len, copied,
> > +				 page, fsdata);
> > +
> > +	from = pos & (PAGE_CACHE_SIZE - 1);
> > +	to = from + copied;
> > +	ret = walk_page_buffers(handle, page_buffers(page),
> > +		from, to, NULL, journal_dirty_data_guarded_fn);
> > +
> > +	/*
> > +	 * we only update the in-memory i_size.  The disk i_size is done
> > +	 * by the end io handlers
> > +	 */
> > +	if (ret == 0 && pos + copied > inode->i_size) {
> > +		int must_log;
> > +
> > +		/* updated i_size, but we may have raced with a
> > +		 * data=guarded end_io handler.
>                    I don't understand the above sentence.

After an IO finishes, we update the on disk i_size to either the on disk
i_size or the start of the first item on the data=guarded list.  The
write_end code is the place we update i_size, so it must also check the
guarded list to see if it is supposed to update the disk i_size as well.

This is especially important for this case:

Create a 3KB file
sync
Append 1 byte on the end

The append won't be a data=guarded write because the block is already on
disk.  So when we update i_size we have to make sure to also update
i_disksize.  There are variations on this that involve racing with the
end_io worker threads too.

[ ok ]

> > diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
> > index ca1bfe9..a6cf26d 100644
> > --- a/include/linux/ext3_fs_i.h
> > +++ b/include/linux/ext3_fs_i.h
> > @@ -137,6 +180,8 @@ struct ext3_inode_info {
> >  	 * by other means, so we have truncate_mutex.
> >  	 */
> >  	struct mutex truncate_mutex;
> > +
> > +	struct ext3_ordered_buffers ordered_buffers;
> >  	struct inode vfs_inode;
> >  };
>   Hmm, how hard would it be to hide especially this behind
> CONFIG_EXT3_GUARDED_DATA so that we can avoid increasing inode size for
> users which are not interested in the new guarded mode?

I'm not too picky, but it would litter the code with #ifdefs around the
guarded functions.  I'd rather not.

-chris

