Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZIBKNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZIBKNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZIBKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:13:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZIBKNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:13:33 -0400
Date: Wed, 2 Sep 2009 12:13:33 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes()
	export
Message-ID: <20090902101333.GB17842@duck.novell.com>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251880967-1136-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-09-09 10:42:40, Jens Axboe wrote:
> This adds two new exported functions:
> 
> - sync_inodes_sb(), which writes out dirty inodes on a super_block, and
> - sync_inodes_sb_wait(), which does the same but also waits for IO
>   completion.
  This is a nice cleanup. I only find the name sync_inodes_sb() slightly
misleading and the comment by that function as well. The name should rather
be something like writeback_inodes_sb() (and sync_inodes_sb_wait() could
stay just sync_inodes_sb()) - the writeback it does does not really
guarantee anything. For example it can skip inodes or pages it does not
like for some reason. What that function really does is - try to write some
dirty pages on that superblock and don't try too hard.
  I don't insist on the renaming of the function but I really thing the
comment should be improved.

								Honza

> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/staging/pohmelfs/inode.c |    9 +----
>  fs/fs-writeback.c                |   68 ++++++++++++++++++++++---------------
>  fs/sync.c                        |    8 +++--
>  fs/ubifs/budget.c                |   16 +--------
>  fs/ubifs/super.c                 |    8 +----
>  include/linux/fs.h               |    2 -
>  include/linux/writeback.h        |    3 +-
>  7 files changed, 51 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
> index 7b60579..bb6db36 100644
> --- a/drivers/staging/pohmelfs/inode.c
> +++ b/drivers/staging/pohmelfs/inode.c
> @@ -1950,14 +1950,7 @@ static int pohmelfs_get_sb(struct file_system_type *fs_type,
>   */
>  static void pohmelfs_kill_super(struct super_block *sb)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode	= WB_SYNC_ALL,
> -		.range_start	= 0,
> -		.range_end	= LLONG_MAX,
> -		.nr_to_write	= LONG_MAX,
> -	};
> -	generic_sync_sb_inodes(sb, &wbc);
> -
> +	sync_sb_inodes_wait(sb);
>  	kill_anon_super(sb);
>  }
>  
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index c54226b..382b15c 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -458,8 +458,8 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   * on the writer throttling path, and we get decent balancing between many
>   * throttled threads: we don't want them all piling up on inode_sync_wait.
>   */
> -void generic_sync_sb_inodes(struct super_block *sb,
> -				struct writeback_control *wbc)
> +static void generic_sync_sb_inodes(struct super_block *sb,
> +				   struct writeback_control *wbc)
>  {
>  	const unsigned long start = jiffies;	/* livelock avoidance */
>  	int sync = wbc->sync_mode == WB_SYNC_ALL;
> @@ -593,13 +593,6 @@ void generic_sync_sb_inodes(struct super_block *sb,
>  
>  	return;		/* Leave any unwritten inodes on s_io */
>  }
> -EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
> -
> -static void sync_sb_inodes(struct super_block *sb,
> -				struct writeback_control *wbc)
> -{
> -	generic_sync_sb_inodes(sb, wbc);
> -}
>  
>  /*
>   * Start writeback of dirty pagecache data against all unlocked inodes.
> @@ -640,7 +633,7 @@ restart:
>  			 */
>  			if (down_read_trylock(&sb->s_umount)) {
>  				if (sb->s_root)
> -					sync_sb_inodes(sb, wbc);
> +					generic_sync_sb_inodes(sb, wbc);
>  				up_read(&sb->s_umount);
>  			}
>  			spin_lock(&sb_lock);
> @@ -653,35 +646,54 @@ restart:
>  	spin_unlock(&sb_lock);
>  }
>  
> -/*
> - * writeback and wait upon the filesystem's dirty inodes.  The caller will
> - * do this in two passes - one to write, and one to wait.
> - *
> - * A finite limit is set on the number of pages which will be written.
> - * To prevent infinite livelock of sys_sync().
> +/**
> + * sync_inodes_sb	-	sync sb inode pages
> + * @sb: the superblock
>   *
> - * We add in the number of potentially dirty inodes, because each inode write
> - * can dirty pagecache in the underlying blockdev.
> + * This function writes dirty inodes belonging to this super_block. It does
> + * not wait for completion of IO.
>   */
> -void sync_inodes_sb(struct super_block *sb, int wait)
> +long sync_inodes_sb(struct super_block *sb)
>  {
>  	struct writeback_control wbc = {
> -		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
> +		.sync_mode	= WB_SYNC_NONE,
>  		.range_start	= 0,
>  		.range_end	= LLONG_MAX,
>  	};
> +	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
> +	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> +	long nr_to_write;
>  
> -	if (!wait) {
> -		unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
> -		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> -
> -		wbc.nr_to_write = nr_dirty + nr_unstable +
> +	nr_to_write = nr_dirty + nr_unstable +
>  			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> -	} else
> -		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
>  
> -	sync_sb_inodes(sb, &wbc);
> +	wbc.nr_to_write = nr_to_write;
> +	generic_sync_sb_inodes(sb, &wbc);
> +	return nr_to_write - wbc.nr_to_write;
> +}
> +EXPORT_SYMBOL(sync_inodes_sb);
> +
> +/**
> + * sync_inodes_sb_wait	-	sync sb inode pages
> + * @sb: the superblock
> + *
> + * This function writes and waits on any dirty inode belonging to this
> + * super_block.
> + */
> +long sync_inodes_sb_wait(struct super_block *sb)
> +{
> +	struct writeback_control wbc = {
> +		.sync_mode	= WB_SYNC_ALL,
> +		.range_start	= 0,
> +		.range_end	= LLONG_MAX,
> +	};
> +	long nr_to_write = LLONG_MAX; /* doesn't actually matter */
> +
> +	wbc.nr_to_write = nr_to_write;
> +	generic_sync_sb_inodes(sb, &wbc);
> +	return nr_to_write - wbc.nr_to_write;
>  }
> +EXPORT_SYMBOL(sync_inodes_sb_wait);
>  
>  /**
>   * write_inode_now	-	write an inode to disk
> diff --git a/fs/sync.c b/fs/sync.c
> index 3422ba6..431dba2 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -28,11 +28,13 @@
>  static int __sync_filesystem(struct super_block *sb, int wait)
>  {
>  	/* Avoid doing twice syncing and cache pruning for quota sync */
> -	if (!wait)
> +	if (!wait) {
>  		writeout_quota_sb(sb, -1);
> -	else
> +		sync_inodes_sb(sb);
> +	} else {
>  		sync_quota_sb(sb, -1);
> -	sync_inodes_sb(sb, wait);
> +		sync_inodes_sb_wait(sb);
> +	}
>  	if (sb->s_op->sync_fs)
>  		sb->s_op->sync_fs(sb, wait);
>  	return __sync_blockdev(sb->s_bdev, wait);
> diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
> index eaf6d89..341edd1 100644
> --- a/fs/ubifs/budget.c
> +++ b/fs/ubifs/budget.c
> @@ -65,26 +65,14 @@
>  static int shrink_liability(struct ubifs_info *c, int nr_to_write)
>  {
>  	int nr_written;
> -	struct writeback_control wbc = {
> -		.sync_mode   = WB_SYNC_NONE,
> -		.range_end   = LLONG_MAX,
> -		.nr_to_write = nr_to_write,
> -	};
> -
> -	generic_sync_sb_inodes(c->vfs_sb, &wbc);
> -	nr_written = nr_to_write - wbc.nr_to_write;
>  
> +	nr_written = sync_inodes_sb(c->vfs_sb);
>  	if (!nr_written) {
>  		/*
>  		 * Re-try again but wait on pages/inodes which are being
>  		 * written-back concurrently (e.g., by pdflush).
>  		 */
> -		memset(&wbc, 0, sizeof(struct writeback_control));
> -		wbc.sync_mode   = WB_SYNC_ALL;
> -		wbc.range_end   = LLONG_MAX;
> -		wbc.nr_to_write = nr_to_write;
> -		generic_sync_sb_inodes(c->vfs_sb, &wbc);
> -		nr_written = nr_to_write - wbc.nr_to_write;
> +		nr_written = sync_inodes_sb_wait(c->vfs_sb);
>  	}
>  
>  	dbg_budg("%d pages were written back", nr_written);
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 26d2e0d..0caa3f1 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -438,12 +438,6 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
>  {
>  	int i, err;
>  	struct ubifs_info *c = sb->s_fs_info;
> -	struct writeback_control wbc = {
> -		.sync_mode   = WB_SYNC_ALL,
> -		.range_start = 0,
> -		.range_end   = LLONG_MAX,
> -		.nr_to_write = LONG_MAX,
> -	};
>  
>  	/*
>  	 * Zero @wait is just an advisory thing to help the file system shove
> @@ -462,7 +456,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
>  	 * the user be able to get more accurate results of 'statfs()' after
>  	 * they synchronize the file system.
>  	 */
> -	generic_sync_sb_inodes(sb, &wbc);
> +	sync_inodes_sb_wait(sb);
>  
>  	/*
>  	 * Synchronize write buffers, because 'ubifs_run_commit()' does not
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 73e9b64..07b0f66 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2070,8 +2070,6 @@ static inline void invalidate_remote_inode(struct inode *inode)
>  extern int invalidate_inode_pages2(struct address_space *mapping);
>  extern int invalidate_inode_pages2_range(struct address_space *mapping,
>  					 pgoff_t start, pgoff_t end);
> -extern void generic_sync_sb_inodes(struct super_block *sb,
> -				struct writeback_control *wbc);
>  extern int write_inode_now(struct inode *, int);
>  extern int filemap_fdatawrite(struct address_space *);
>  extern int filemap_flush(struct address_space *);
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 3224820..f26a60b 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -78,7 +78,8 @@ struct writeback_control {
>   */	
>  void writeback_inodes(struct writeback_control *wbc);
>  int inode_wait(void *);
> -void sync_inodes_sb(struct super_block *, int wait);
> +long sync_inodes_sb(struct super_block *);
> +long sync_inodes_sb_wait(struct super_block *);
>  
>  /* writeback.h requires fs.h; it, too, is not included from here. */
>  static inline void wait_on_inode(struct inode *inode)
> -- 
> 1.6.4.1.207.g68ea
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
