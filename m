Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZDVRX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZDVRX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZDVRXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:23:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:51551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbZDVRXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:23:18 -0400
Date: Wed, 22 Apr 2009 19:23:15 +0200
From: Jan Kara <jack@suse.cz>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] vfs: Fix sys_sync() and fsync_super() reliability
Message-ID: <20090422172315.GF25968@duck.suse.cz>
References: <1240415781-17834-1-git-send-email-jack@suse.cz> <1240415781-17834-2-git-send-email-jack@suse.cz> <1240420576.9197.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240420576.9197.1.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-04-09 13:16:16, Trond Myklebust wrote:
> On Wed, 2009-04-22 at 17:56 +0200, Jan Kara wrote:
> > So far, do_sync() called:
> >   sync_inodes(0);
> >   sync_supers();
> >   sync_filesystems(0);
> >   sync_filesystems(1);
> >   sync_inodes(1);
> > 
> > This ordering makes it kind of hard for filesystems as sync_inodes(0) need not
> > submit all the IO (for example it skips inodes with I_SYNC set) so e.g. forcing
> > transaction to disk in ->sync_fs() is not really enough. Therefore sys_sync has
> > not been completely reliable on some filesystems (ext3, ext4, reiserfs, ocfs2
> > and others are hit by this) when racing e.g. with background writeback. A
> > similar problem hits also other filesystems (e.g. ext2) because of
> > write_supers() being called before the sync_inodes(1).
> > 
> > Change the ordering of calls in do_sync() - this requires a new function
> > sync_blkdevs() to preserve the property that block devices are always synced
> > after write_super() / sync_fs() call.
> > 
> > The same issue is fixed in __fsync_super() function used on umount /
> > remount read-only.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/super.c         |   25 ++++++++++++++++++++++++-
> >  fs/sync.c          |    3 ++-
> >  include/linux/fs.h |    2 ++
> >  3 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 786fe7d..4f56333 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -267,6 +267,7 @@ void __fsync_super(struct super_block *sb)
> >  {
> >  	sync_inodes_sb(sb, 0);
> >  	vfs_dq_sync(sb);
> > +	sync_inodes_sb(sb, 1);
> >  	lock_super(sb);
> >  	if (sb->s_dirt && sb->s_op->write_super)
> >  		sb->s_op->write_super(sb);
> > @@ -274,7 +275,6 @@ void __fsync_super(struct super_block *sb)
> >  	if (sb->s_op->sync_fs)
> >  		sb->s_op->sync_fs(sb, 1);
> >  	sync_blockdev(sb->s_bdev);
> > -	sync_inodes_sb(sb, 1);
> >  }
> >  
> >  /*
> > @@ -502,6 +502,29 @@ restart:
> >  	mutex_unlock(&mutex);
> >  }
> >  
> > +/*
> > + *  Sync all block devices underlying some superblock
> > + */
> > +void sync_blockdevs(void)
> > +{
> > +	struct super_block *sb;
> > +
> > +	spin_lock(&sb_lock);
> > +restart:
> > +	list_for_each_entry(sb, &super_blocks, s_list) {
> > +		sb->s_count++;
> > +		spin_unlock(&sb_lock);
> > +		down_read(&sb->s_umount);
> > +		if (sb->s_root)
> > +			sync_blockdev(sb->s_bdev);
> > +		up_read(&sb->s_umount);
> 
> What's the point of going to all this trouble of upping the sb->s_count,
> and grabbing sb->s_umount if there is no sb->s_bdev to sync in the first
> place?
  Thanks for the comment. Yes, we could save something here. I can improve
this and similarly my next patch. I'll just wait till tomorrow whether
someone else does not have other comments...

> 
> > +		spin_lock(&sb_lock);
> > +		if (__put_super_and_need_restart(sb))
> > +			goto restart;
> > +	}
> > +	spin_unlock(&sb_lock);
> > +}
> > +
> >  /**
> >   *	get_super - get the superblock of a device
> >   *	@bdev: device to get the superblock for
> > diff --git a/fs/sync.c b/fs/sync.c
> > index 7abc65f..fa14e42 100644
> > --- a/fs/sync.c
> > +++ b/fs/sync.c
> > @@ -26,10 +26,11 @@ static void do_sync(unsigned long wait)
> >  	wakeup_pdflush(0);
> >  	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
> >  	vfs_dq_sync(NULL);
> > +	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
> >  	sync_supers();		/* Write the superblocks */
> >  	sync_filesystems(0);	/* Start syncing the filesystems */
> >  	sync_filesystems(wait);	/* Waitingly sync the filesystems */
> > -	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
> > +	sync_blockdevs();
> >  	if (!wait)
> >  		printk("Emergency Sync complete\n");
> >  	if (unlikely(laptop_mode))
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 5bed436..4bad02e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1942,6 +1942,7 @@ extern void bdput(struct block_device *);
> >  extern struct block_device *open_by_devnum(dev_t, fmode_t);
> >  extern void invalidate_bdev(struct block_device *);
> >  extern int sync_blockdev(struct block_device *bdev);
> > +extern void sync_blockdevs(void);
> >  extern struct super_block *freeze_bdev(struct block_device *);
> >  extern void emergency_thaw_all(void);
> >  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
> > @@ -1951,6 +1952,7 @@ extern int fsync_no_super(struct block_device *);
> >  #else
> >  static inline void bd_forget(struct inode *inode) {}
> >  static inline int sync_blockdev(struct block_device *bdev) { return 0; }
> > +static inline void sync_blockdevs(void) { }
> >  static inline void invalidate_bdev(struct block_device *bdev) {}
> >  
> >  static inline struct super_block *freeze_bdev(struct block_device *sb)
> > -- 
> > 1.6.0.2

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
