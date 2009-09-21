Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZIUJxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZIUJxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZIUJxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:53:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:27948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZIUJxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189808897"
Date: Mon, 21 Sep 2009 17:53:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090921095326.GA32281@localhost>
References: <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost> <20090918175252.GF26991@mit.edu> <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090919150351.GA19880@localhost> <20090920190006.GD16919@duck.suse.cz> <20090921030402.GC6331@localhost> <20090921053546.GA16932@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921053546.GA16932@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 01:35:46PM +0800, Wu Fengguang wrote:
> On Mon, Sep 21, 2009 at 11:04:02AM +0800, Wu Fengguang wrote:
> > On Mon, Sep 21, 2009 at 03:00:06AM +0800, Jan Kara wrote:
> > > On Sat 19-09-09 23:03:51, Wu Fengguang wrote:
> > > > On Sat, Sep 19, 2009 at 12:26:07PM +0800, Wu Fengguang wrote:
> > > > > On Sat, Sep 19, 2009 at 12:00:51PM +0800, Wu Fengguang wrote:
> > > > > > On Sat, Sep 19, 2009 at 11:58:35AM +0800, Wu Fengguang wrote:
> > > > > > > On Sat, Sep 19, 2009 at 01:52:52AM +0800, Theodore Tso wrote:
> > > > > > > > On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> > > > > > > > > 
> > > > > > > > > That would be good. Sorry for the late work. I'll allocate some time
> > > > > > > > > in mid next week to help review and benchmark recent writeback works,
> > > > > > > > > and hope to get things done in this merge window.
> > > > > > > > 
> > > > > > > > Did you have some chance to get more work done on the your writeback
> > > > > > > > patches?
> > > > > > > 
> > > > > > > Sorry for the delay, I'm now testing the patches with commands
> > > > > > > 
> > > > > > >  cp /dev/zero /mnt/test/zero0 &
> > > > > > >  dd if=/dev/zero of=/mnt/test/zero1 &
> > > > > > > 
> > > > > > > and the attached debug patch.
> > > > > > > 
> > > > > > > One problem I found with ext3/4 is, redirty_tail() is called repeatedly
> > > > > > > in the traces, which could slow down the inode writeback significantly.
> > > > > > 
> > > > > > FYI, it's this redirty_tail() called in writeback_single_inode():
> > > > > > 
> > > > > >                         /*
> > > > > >                          * Someone redirtied the inode while were writing back
> > > > > >                          * the pages.
> > > > > >                          */
> > > > > >                         redirty_tail(inode);
> > > > > 
> > > > > Hmm, this looks like an old fashioned problem get blew up by the
> > > > > 128MB MAX_WRITEBACK_PAGES.
> > > > > 
> > > > > The inode was redirtied by the busy cp/dd processes. Now it takes much
> > > > > more time to sync 128MB, so that a heavy dirtier can easily redirty
> > > > > the inode in that time window.
> > > > > 
> > > > > One single invocation of redirty_tail() could hold up the writeback of
> > > > > current inode for up to 30 seconds.
> > > > 
> > > > It seems that this patch helps. However I'm afraid it's too late to
> > > > risk merging such kind of patches now..
> > >   Fenguang, could we maybe write down how the logic should look like
> > > and then look at the code and modify it as needed to fit the logic?
> > > Because I couldn't find a compact description of the logic anywhere
> > > in the code.
> > 
> > Good idea. It makes sense to write something down in Documentation/
> > or embedded as code comments.
> > 
> > >   Here is how I'd imaging the writeout logic should work:
> > > We would have just two lists - b_dirty and b_more_io. Both would be
> > > ordered by dirtied_when.
> > 
> > Andrew has a very good description for the dirty/io/more_io queues:
> > 
> > http://lkml.org/lkml/2006/2/7/5
> > 
> > | So the protocol would be:
> > |
> > | s_io: contains expired and non-expired dirty inodes, with expired ones at
> > | the head.  Unexpired ones (at least) are in time order.
> > |
> > | s_more_io: contains dirty expired inodes which haven't been fully written. 
> > | Ordering doesn't matter (unless someone goes and changes
> > | dirty_expire_centisecs - but as long as we don't do anything really bad in
> > | response to this we'll be OK).
> > |
> > | s_dirty: contains expired and non-expired dirty inodes.  The non-expired
> > | ones are in time-of-dirtying order.
> > 
> > Since then s_io was changed to hold only _expired_ dirty inodes at the
> > beginning of a full scan. It serves as a bounded set of dirty inodes.
> > So that when finished a full scan of it, the writeback can go on to
> > the next superblock, and old dirty files' writeback won't be delayed
> > infinitely by poring in newly dirty files.
> > 
> > It seems that the boundary could also be provided by some
> > older_than_this timestamp. So removal of b_io is possible
> > at least on this purpose.
> 
> Yeah, this is a scratch patch to remove b_io, I see no obvious
> difficulties in doing so.

However the removal of b_io is not that good for possible b_dirty
optimizations. For example, we could use a tree for b_dirty for more
flexible ordering. Or can introduce a b_dirty_atime to hold the inodes
dirtied by atime and expire them much lazily:

                       expire > 30m
        b_dirty_atime --------------+
                                    |
                                    +--- b_io ---> writeback
                                    |
        b_dirty --------------------+
                       expire > 30s

Thanks,
Fengguang

> ---
>  fs/btrfs/extent_io.c        |    2 -
>  fs/fs-writeback.c           |   65 +++++++++-------------------------
>  include/linux/backing-dev.h |    2 -
>  include/linux/writeback.h   |    4 +-
>  mm/backing-dev.c            |    1 
>  mm/page-writeback.c         |    1 
>  6 files changed, 21 insertions(+), 54 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-09-21 13:12:56.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-09-21 13:12:57.000000000 +0800
> @@ -284,7 +284,7 @@ static void redirty_tail(struct inode *i
>  }
>  
>  /*
> - * requeue inode for re-scanning after bdi->b_io list is exhausted.
> + * requeue inode for re-scanning.
>   */
>  static void requeue_io(struct inode *inode)
>  {
> @@ -317,32 +317,6 @@ static bool inode_dirtied_after(struct i
>  	return ret;
>  }
>  
> -/*
> - * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
> - */
> -static void move_expired_inodes(struct list_head *delaying_queue,
> -			       struct list_head *dispatch_queue,
> -				unsigned long *older_than_this)
> -{
> -	while (!list_empty(delaying_queue)) {
> -		struct inode *inode = list_entry(delaying_queue->prev,
> -						struct inode, i_list);
> -		if (older_than_this &&
> -		    inode_dirtied_after(inode, *older_than_this))
> -			break;
> -		list_move(&inode->i_list, dispatch_queue);
> -	}
> -}
> -
> -/*
> - * Queue all expired dirty inodes for io, eldest first.
> - */
> -static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
> -{
> -	list_splice_init(&wb->b_more_io, wb->b_io.prev);
> -	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
> -}
> -
>  static int write_inode(struct inode *inode, int sync)
>  {
>  	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode))
> @@ -399,7 +373,7 @@ writeback_single_inode(struct inode *ino
>  		 * writeback can proceed with the other inodes on s_io.
>  		 *
>  		 * We'll have another go at writing back this inode when we
> -		 * completed a full scan of b_io.
> +		 * completed a full scan.
>  		 */
>  		if (!wait) {
>  			requeue_io(inode);
> @@ -540,11 +514,11 @@ static void writeback_inodes_wb(struct b
>  
>  	spin_lock(&inode_lock);
>  
> -	if (!wbc->for_kupdate || list_empty(&wb->b_io))
> -		queue_io(wb, wbc->older_than_this);
> +	if (list_empty(&wb->b_dirty))
> +		list_splice_init(&wb->b_more_io, &wb->b_dirty);
>  
> -	while (!list_empty(&wb->b_io)) {
> -		struct inode *inode = list_entry(wb->b_io.prev,
> +	while (!list_empty(&wb->b_dirty)) {
> +		struct inode *inode = list_entry(wb->b_dirty.prev,
>  						struct inode, i_list);
>  		long pages_skipped;
>  
> @@ -590,8 +564,12 @@ static void writeback_inodes_wb(struct b
>  		 * Was this inode dirtied after sync_sb_inodes was called?
>  		 * This keeps sync from extra jobs and livelock.
>  		 */
> -		if (inode_dirtied_after(inode, start))
> -			break;
> +		if (inode_dirtied_after(inode, wbc->older_than_this)) {
> +			if (list_empty(&wb->b_more_io))
> +				break;
> +			list_splice_init(&wb->b_more_io, wb->b_dirty.prev);
> +			continue;
> +		}
>  
>  		if (pin_sb_for_writeback(wbc, inode)) {
>  			requeue_io(inode);
> @@ -623,7 +601,7 @@ static void writeback_inodes_wb(struct b
>  	}
>  
>  	spin_unlock(&inode_lock);
> -	/* Leave any unwritten inodes on b_io */
> +	/* Leave any unwritten inodes on b_dirty */
>  }
>  
>  void writeback_inodes_wbc(struct writeback_control *wbc)
> @@ -674,18 +652,18 @@ static long wb_writeback(struct bdi_writ
>  		.bdi			= wb->bdi,
>  		.sb			= args->sb,
>  		.sync_mode		= args->sync_mode,
> -		.older_than_this	= NULL,
>  		.for_kupdate		= args->for_kupdate,
>  		.range_cyclic		= args->range_cyclic,
>  	};
>  	unsigned long oldest_jif;
>  	long wrote = 0;
>  
> -	if (wbc.for_kupdate) {
> -		wbc.older_than_this = &oldest_jif;
> -		oldest_jif = jiffies -
> +	if (wbc.for_kupdate)
> +		wbc.older_than_this = jiffies -
>  				msecs_to_jiffies(dirty_expire_interval * 10);
> -	}
> +	else
> +		wbc.older_than_this = jiffies;
> +
>  	if (!wbc.range_cyclic) {
>  		wbc.range_start = 0;
>  		wbc.range_end = LLONG_MAX;
> @@ -1004,7 +982,7 @@ void __mark_inode_dirty(struct inode *in
>  			goto out;
>  
>  		/*
> -		 * If the inode was already on b_dirty/b_io/b_more_io, don't
> +		 * If the inode was already on b_dirty/b_more_io, don't
>  		 * reposition it (that would break b_dirty time-ordering).
>  		 */
>  		if (!was_dirty) {
> @@ -1041,11 +1019,6 @@ EXPORT_SYMBOL(__mark_inode_dirty);
>   * This function assumes that the blockdev superblock's inodes are backed by
>   * a variety of queues, so all inodes are searched.  For other superblocks,
>   * assume that all inodes are backed by the same queue.
> - *
> - * The inodes to be written are parked on bdi->b_io.  They are moved back onto
> - * bdi->b_dirty as they are selected for writing.  This way, none can be missed
> - * on the writer throttling path, and we get decent balancing between many
> - * throttled threads: we don't want them all piling up on inode_sync_wait.
>   */
>  static void wait_sb_inodes(struct super_block *sb)
>  {
> --- linux.orig/fs/btrfs/extent_io.c	2009-09-21 13:12:24.000000000 +0800
> +++ linux/fs/btrfs/extent_io.c	2009-09-21 13:12:57.000000000 +0800
> @@ -2467,7 +2467,6 @@ int extent_write_full_page(struct extent
>  	struct writeback_control wbc_writepages = {
>  		.bdi		= wbc->bdi,
>  		.sync_mode	= wbc->sync_mode,
> -		.older_than_this = NULL,
>  		.nr_to_write	= 64,
>  		.range_start	= page_offset(page) + PAGE_CACHE_SIZE,
>  		.range_end	= (loff_t)-1,
> @@ -2501,7 +2500,6 @@ int extent_write_locked_range(struct ext
>  	struct writeback_control wbc_writepages = {
>  		.bdi		= inode->i_mapping->backing_dev_info,
>  		.sync_mode	= mode,
> -		.older_than_this = NULL,
>  		.nr_to_write	= nr_pages * 2,
>  		.range_start	= start,
>  		.range_end	= end + 1,
> --- linux.orig/include/linux/writeback.h	2009-09-21 13:12:24.000000000 +0800
> +++ linux/include/linux/writeback.h	2009-09-21 13:12:57.000000000 +0800
> @@ -32,8 +32,8 @@ struct writeback_control {
>  	struct super_block *sb;		/* if !NULL, only write inodes from
>  					   this super_block */
>  	enum writeback_sync_modes sync_mode;
> -	unsigned long *older_than_this;	/* If !NULL, only write back inodes
> -					   older than this */
> +	unsigned long older_than_this;	/* only write back inodes older than
> +					   this */
>  	long nr_to_write;		/* Write this many pages, and decrement
>  					   this for each page written */
>  	long pages_skipped;		/* Pages which were not written */
> --- linux.orig/mm/backing-dev.c	2009-09-21 13:12:24.000000000 +0800
> +++ linux/mm/backing-dev.c	2009-09-21 13:12:57.000000000 +0800
> @@ -333,7 +333,6 @@ static void bdi_flush_io(struct backing_
>  	struct writeback_control wbc = {
>  		.bdi			= bdi,
>  		.sync_mode		= WB_SYNC_NONE,
> -		.older_than_this	= NULL,
>  		.range_cyclic		= 1,
>  		.nr_to_write		= 1024,
>  	};
> --- linux.orig/mm/page-writeback.c	2009-09-21 13:12:56.000000000 +0800
> +++ linux/mm/page-writeback.c	2009-09-21 13:12:57.000000000 +0800
> @@ -492,7 +492,6 @@ static void balance_dirty_pages(struct a
>  		struct writeback_control wbc = {
>  			.bdi		= bdi,
>  			.sync_mode	= WB_SYNC_NONE,
> -			.older_than_this = NULL,
>  			.nr_to_write	= write_chunk,
>  			.range_cyclic	= 1,
>  		};
> --- linux.orig/include/linux/backing-dev.h	2009-09-21 13:12:24.000000000 +0800
> +++ linux/include/linux/backing-dev.h	2009-09-21 13:12:57.000000000 +0800
> @@ -53,7 +53,6 @@ struct bdi_writeback {
>  
>  	struct task_struct	*task;		/* writeback task */
>  	struct list_head	b_dirty;	/* dirty inodes */
> -	struct list_head	b_io;		/* parked for writeback */
>  	struct list_head	b_more_io;	/* parked for more writeback */
>  };
>  
> @@ -111,7 +110,6 @@ extern struct list_head bdi_list;
>  static inline int wb_has_dirty_io(struct bdi_writeback *wb)
>  {
>  	return !list_empty(&wb->b_dirty) ||
> -	       !list_empty(&wb->b_io) ||
>  	       !list_empty(&wb->b_more_io);
>  }
>  
