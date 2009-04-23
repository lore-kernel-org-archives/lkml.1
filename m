Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbZDWV3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbZDWV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbZDWV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:29:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:34384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758611AbZDWV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:29:11 -0400
Date: Thu, 23 Apr 2009 23:29:08 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] vfs: Make sys_sync() use fsync_super() (version 2)
Message-ID: <20090423212908.GC31584@duck.suse.cz>
References: <1240498045-14288-1-git-send-email-jack@suse.cz> <1240498045-14288-5-git-send-email-jack@suse.cz> <20090423165736.GB4083@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423165736.GB4083@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-04-09 12:57:36, Christoph Hellwig wrote:
> > +int __sync_blockdev(struct block_device *bdev, int wait)
> > +{
> > +	if (!bdev)
> > +		return 0;
> > +	if (!wait)
> > +		return filemap_flush(bdev->bd_inode->i_mapping);
> > +	return filemap_write_and_wait(bdev->bd_inode->i_mapping);
> > +}
> 
> I wonder if the filemap_flush for the async case really buys us much,
> all the async and then later sync writeback activities of the FS will
> redirty lots of bits of the blockdev mapping that we then have to write
> twice.
  Well, I think it does. Because if you call write_inode() with wait==1,
then filesystems usually do sync_dirty_buffer() for the buffer with inode.
But with wait==0 filesystems (e.g. ext2 and other "simple" filesystems)
just mark the buffer with inode dirty.  So sync_inodes_sb(sb, 0) just
dirties lots of buffers and then filemap_flush() submits all the IO more
effectively than doing sync_dirty_buffer() for each inode... But I guess it
deserves a comment.
  Also I'd think that async case submits most of the IO and later sync just
gathers last bits we might have skipped.
 
> > @@ -284,7 +277,12 @@ static int __fsync_super(struct super_block *sb)
> >   */
> >  int fsync_super(struct super_block *sb)
> >  {
> > -	return __fsync_super(sb);
> > +	int ret;
> > +
> > +	ret = __fsync_super(sb, 0);
> > +	if (ret < 0)
> > +		return ret;
> > +	return __fsync_super(sb, 1);
> 
> This async first then wait approach does have some benefits when syncing
> multiple filesystems, but I wonder if it isn't actually conta-productive
> when syncing a single one.
> 
> Maybe this should be a separate patch ontop to allow for more
> fine-grained benchmarking.
  But __fsync_super() previously did:
sync_inodes_sb(sb, 0);
...
sync_inodes_sb(sb, 1);
  So the change is only in calling write_super(), vfs_dq_sync() and
sync_fs() twice. I can certainly change the function to call vfs_dq_sync()
and write_super() only if wait == 1, so only sync_fs() would be called
twice. But then if someone uses __fsync_super() in future, he might get
surprised...

> >  /*
> > - * Call the ->sync_fs super_op against all filesystems which are r/w and
> > - * which implement it.
> > + * Sync all the data for all the filesystems (called by do_sync())
> 
> Your patch removes do_sync :)
  Yup, thanks.
 
> >  static void do_sync_work(struct work_struct *work)
> >  {
> > -	do_sync(0);
> > +	/*
> > +	 * Sync twice to reduce the possibility we skipped some inodes / pages
> > +	 * because they were temporarily locked
> > +	 */
> > +	sync_filesystems(0);
> > +	sync_filesystems(0);
> > +	printk("Emergency Sync complete\n");
> >  	kfree(work);
> 
> Ah, nice.  Good to have this out of the sys_sync path.
> 
> The patch looks generally good but I'll need some heavy testing.  I'll
> do some XFS testing with it ASAP.
  Great. I think the first (maybe first two) patch can go in quickly to fix
the bug and the others can go in after more serious testing.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
