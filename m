Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZDVRUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZDVRUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZDVRUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:20:20 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:44344 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZDVRUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:20:19 -0400
Subject: Re: [PATCH] vfs: Merge sync_supers(), sync_filesystems() and
 sync_blockdevs()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1240415781-17834-3-git-send-email-jack@suse.cz>
References: <1240415781-17834-1-git-send-email-jack@suse.cz>
	 <1240415781-17834-3-git-send-email-jack@suse.cz>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 13:20:14 -0400
Message-Id: <1240420814.9197.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 876FEB1A85A8A310F0ABAE5AE61864A02A9BF66C
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 184 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 17:56 +0200, Jan Kara wrote:
> These three functions are quite similar so merge them to save superblock list
> traversal code. As a bonus we get livelock avoidance for all these superblock
> traversals. Also remove the condition that if wait == 0 and sb->s_dirt is
> not set, then ->sync_fs() is not called. This does not really make much sence
> since s_dirt is generally used by filesystem to mean that ->write_super() needs
> to be called. But ->sync_fs() does different things. I even suspect that some
> filesystems (btrfs?) sets s_dirt just to fool this logic.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/super.c          |  104 ++++++++++++++------------------------------------
>  fs/sync.c           |   12 ++++--
>  include/linux/fs.h  |   11 +++--
>  mm/page-writeback.c |    2 +-
>  4 files changed, 44 insertions(+), 85 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 4f56333..6d6209e 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -413,58 +413,24 @@ void drop_super(struct super_block *sb)
>  
>  EXPORT_SYMBOL(drop_super);
>  
> -static inline void write_super(struct super_block *sb)
> -{
> -	lock_super(sb);
> -	if (sb->s_root && sb->s_dirt)
> -		if (sb->s_op->write_super)
> -			sb->s_op->write_super(sb);
> -	unlock_super(sb);
> -}
> -
> -/*
> - * Note: check the dirty flag before waiting, so we don't
> - * hold up the sync while mounting a device. (The newly
> - * mounted device won't need syncing.)
> - */
> -void sync_supers(void)
> -{
> -	struct super_block *sb;
> -
> -	spin_lock(&sb_lock);
> -restart:
> -	list_for_each_entry(sb, &super_blocks, s_list) {
> -		if (sb->s_dirt) {
> -			sb->s_count++;
> -			spin_unlock(&sb_lock);
> -			down_read(&sb->s_umount);
> -			write_super(sb);
> -			up_read(&sb->s_umount);
> -			spin_lock(&sb_lock);
> -			if (__put_super_and_need_restart(sb))
> -				goto restart;
> -		}
> -	}
> -	spin_unlock(&sb_lock);
> -}
> -
>  /*
> - * Call the ->sync_fs super_op against all filesystems which are r/w and
> - * which implement it.
> + * Call the ->write_super, ->sync_fs, sync_blockdev() against all filesystems
> + * which are r/w and which implement it.
>   *
> - * This operation is careful to avoid the livelock which could easily happen
> - * if two or more filesystems are being continuously dirtied.  s_need_sync_fs
> - * is used only here.  We set it against all filesystems and then clear it as
> - * we sync them.  So redirtied filesystems are skipped.
> + * This operation is careful to avoid the livelock. Currently it's not so easy
> + * to trigger as it used to be - we restart scanning the superblock list only
> + * if the superblock got unmounted under us - but it's better to be safe and it
> + * doesn't cost us much. s_need_sync is used only here.  We set it against all
> + * filesystems and then clear it as we sync them.  So redirtied filesystems are
> + * skipped.
>   *
>   * But if process A is currently running sync_filesystems and then process B
> - * calls sync_filesystems as well, process B will set all the s_need_sync_fs
> - * flags again, which will cause process A to resync everything.  Fix that with
> - * a local mutex.
> + * calls sync_filesystems as well, process B will set all the s_need_sync flags
> + * again, which will cause process A to resync everything.  Fix that with a
> + * local mutex.
>   *
> - * (Fabian) Avoid sync_fs with clean fs & wait mode 0
>   */
> -void sync_filesystems(int wait)
> +void sync_filesystems(int what, int wait)
>  {
>  	struct super_block *sb;
>  	static DEFINE_MUTEX(mutex);
> @@ -472,26 +438,37 @@ void sync_filesystems(int wait)
>  	mutex_lock(&mutex);		/* Could be down_interruptible */
>  	spin_lock(&sb_lock);
>  	list_for_each_entry(sb, &super_blocks, s_list) {
> -		if (!sb->s_op->sync_fs)
> +		if ((!sb->s_op->sync_fs || !(what & FSSYNC_FS)) &&
> +		    (!sb->s_op->write_super || !(what & FSSYNC_SUPER)) &&
> +		    !(what & FSSYNC_BDEV))

Ditto. There should be a check for sb->s_bdev here too...

>  			continue;
>  		if (sb->s_flags & MS_RDONLY)
>  			continue;
> -		sb->s_need_sync_fs = 1;
> +		sb->s_need_sync = 1;
>  	}
>  
>  restart:
>  	list_for_each_entry(sb, &super_blocks, s_list) {
> -		if (!sb->s_need_sync_fs)
> +		if (!sb->s_need_sync)
>  			continue;
> -		sb->s_need_sync_fs = 0;
> +		sb->s_need_sync = 0;
>  		if (sb->s_flags & MS_RDONLY)
>  			continue;	/* hm.  Was remounted r/o meanwhile */
>  		sb->s_count++;
>  		spin_unlock(&sb_lock);
>  		down_read(&sb->s_umount);
>  		async_synchronize_full_domain(&sb->s_async_list);
> -		if (sb->s_root && (wait || sb->s_dirt))
> -			sb->s_op->sync_fs(sb, wait);
> +		if (sb->s_root) {
> +			lock_super(sb);
> +			if (what & FSSYNC_SUPER && sb->s_dirt &&
> +			    sb->s_op->write_super)
> +				sb->s_op->write_super(sb);
> +			unlock_super(sb);
> +			if (what & FSSYNC_FS && sb->s_op->sync_fs)
> +				sb->s_op->sync_fs(sb, wait);
> +			if (what & FSSYNC_BDEV)
> +				sync_blockdev(sb->s_bdev);
> +		}
>  		up_read(&sb->s_umount);
>  		/* restart only when sb is no longer on the list */
>  		spin_lock(&sb_lock);
> @@ -502,29 +479,6 @@ restart:
>  	mutex_unlock(&mutex);
>  }
>  
> -/*
> - *  Sync all block devices underlying some superblock
> - */
> -void sync_blockdevs(void)
> -{
> -	struct super_block *sb;
> -
> -	spin_lock(&sb_lock);
> -restart:
> -	list_for_each_entry(sb, &super_blocks, s_list) {
> -		sb->s_count++;
> -		spin_unlock(&sb_lock);
> -		down_read(&sb->s_umount);
> -		if (sb->s_root)
> -			sync_blockdev(sb->s_bdev);
> -		up_read(&sb->s_umount);
> -		spin_lock(&sb_lock);
> -		if (__put_super_and_need_restart(sb))
> -			goto restart;
> -	}
> -	spin_unlock(&sb_lock);
> -}
> -
>  /**
>   *	get_super - get the superblock of a device
>   *	@bdev: device to get the superblock for
> diff --git a/fs/sync.c b/fs/sync.c
> index fa14e42..3c677ee 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -26,11 +26,15 @@ static void do_sync(unsigned long wait)
>  	wakeup_pdflush(0);
>  	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
>  	vfs_dq_sync(NULL);
> +	sync_filesystems(FSSYNC_FS, 0);	/* Start syncing the filesystems */
> +	/*
> +	 * We have to reliably submit IO for all the inodes before writing
> +	 * super blocks and calling sync_fs(). Otherwise superblock could miss
> +	 * some updates or journal could still have uncommitted data.
> +	 */
>  	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
> -	sync_supers();		/* Write the superblocks */
> -	sync_filesystems(0);	/* Start syncing the filesystems */
> -	sync_filesystems(wait);	/* Waitingly sync the filesystems */
> -	sync_blockdevs();
> +	/* Waitingly sync the filesystems */
> +	sync_filesystems(FSSYNC_SUPER | FSSYNC_FS | FSSYNC_BDEV, wait);
>  	if (!wait)
>  		printk("Emergency Sync complete\n");
>  	if (unlikely(laptop_mode))
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4bad02e..2758e75 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1321,7 +1321,7 @@ struct super_block {
>  	struct rw_semaphore	s_umount;
>  	struct mutex		s_lock;
>  	int			s_count;
> -	int			s_need_sync_fs;
> +	int			s_need_sync;
>  	atomic_t		s_active;
>  #ifdef CONFIG_SECURITY
>  	void                    *s_security;
> @@ -1942,7 +1942,6 @@ extern void bdput(struct block_device *);
>  extern struct block_device *open_by_devnum(dev_t, fmode_t);
>  extern void invalidate_bdev(struct block_device *);
>  extern int sync_blockdev(struct block_device *bdev);
> -extern void sync_blockdevs(void);
>  extern struct super_block *freeze_bdev(struct block_device *);
>  extern void emergency_thaw_all(void);
>  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
> @@ -1952,7 +1951,6 @@ extern int fsync_no_super(struct block_device *);
>  #else
>  static inline void bd_forget(struct inode *inode) {}
>  static inline int sync_blockdev(struct block_device *bdev) { return 0; }
> -static inline void sync_blockdevs(void) { }
>  static inline void invalidate_bdev(struct block_device *bdev) {}
>  
>  static inline struct super_block *freeze_bdev(struct block_device *sb)
> @@ -2082,8 +2080,11 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
>  				loff_t start, loff_t end);
>  
>  extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
> -extern void sync_supers(void);
> -extern void sync_filesystems(int wait);
> +/* Flags telling what should be synced by sync_filesystems() */
> +#define FSSYNC_FS 1
> +#define FSSYNC_SUPER 2
> +#define FSSYNC_BDEV 4
> +extern void sync_filesystems(int what, int wait);
>  extern void __fsync_super(struct super_block *sb);
>  extern void emergency_sync(void);
>  extern void emergency_remount(void);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 30351f0..05a2948 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -768,7 +768,7 @@ static void wb_kupdate(unsigned long arg)
>  		.range_cyclic	= 1,
>  	};
>  
> -	sync_supers();
> +	sync_filesystems(FSSYNC_SUPER, 0);
>  
>  	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
>  	start_jif = jiffies;

