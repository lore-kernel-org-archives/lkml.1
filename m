Return-Path: <linux-kernel-owner+w=401wt.eu-S1765900AbZAOXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765900AbZAOXqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763704AbZAOXpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:45:49 -0500
Received: from styx.suse.cz ([82.119.242.94]:34262 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935536AbZAOXpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:45:46 -0500
Date: Fri, 16 Jan 2009 00:45:44 +0100
From: Jan Kara <jack@suse.cz>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Theodore Tso <tytso@MIT.EDU>, Jan Kara <jack@suse.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090115234544.GA7579@duck.suse.cz>
References: <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114141204.GD6222@mit.edu> <20090114143756.GF19950@duck.suse.cz> <20090114165952.GH6222@mit.edu> <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-01-09 21:06:51, Fernando Luis Vázquez Cao wrote:
> On Wed, 2009-01-14 at 11:59 -0500, Theodore Tso wrote: 
> > On Wed, Jan 14, 2009 at 03:37:56PM +0100, Jan Kara wrote:
> > > > Um, we have that already; the sync_inode() followed by
> > > > blkdev_issue_flush() is the path taken by fdatasync(), I do believe.
> > >
> > >   Maybe ext4-patch-queue changes that area but in Linus's tree I see:
> > > 
> > >   if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > >          goto out;
> > > 
> > >   So if we just overwrite some data, we send them to disk via fdatawrite()
> > > and then we quickly bail out from ext4_sync_file() without doing
> > > blkdev_issue_flush().
> > 
> > So you're thinking about fdatawrite() being called by some code path
> > other than ext4_sync_file() before we call fsync()?  Yeah, that could
> > happen....  I think that will only happen if the file is opened
> > O_SYNC, but that raises another issue, which is that we're not forcing
> > a flush for writes when the file is opened O_SYNC.
> 
> Hi Jan, Ted
> 
> Is something like the patch below what you had in mind?
> 
> --
> 
> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> Subject: ext3: call blkdev_issue_flush on fsync
> 
> To ensure that bits are truly on-disk after an fsync or fdatasync, we
> should call blkdev_issue_flush if barriers are supported.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> --- linux-2.6.29-rc1-orig/fs/ext4/fsync.c	2008-12-25 08:26:37.000000000 +0900
> +++ linux-2.6.29-rc1/fs/ext4/fsync.c	2009-01-15 21:03:19.000000000 +0900
> @@ -48,6 +48,7 @@ int ext4_sync_file(struct file *file, st
>  {
>  	struct inode *inode = dentry->d_inode;
>  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> +	unsigned long i_state = inode->i_state;
>  	int ret = 0;
>  
>  	J_ASSERT(ext4_journal_current_handle() == NULL);
> @@ -79,22 +80,35 @@ int ext4_sync_file(struct file *file, st
>  		goto out;
>  	}
>  
> -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> -		goto out;
> +	if (datasync && !(i_state & I_DIRTY_DATASYNC))
> +		goto flush_blkdev;
>  
>  	/*
>  	 * The VFS has written the file data.  If the inode is unaltered
>  	 * then we need not start a commit.
>  	 */
> -	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
> +	if (i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
>  		struct writeback_control wbc = {
>  			.sync_mode = WB_SYNC_ALL,
>  			.nr_to_write = 0, /* sys_fsync did this */
>  		};
>  		ret = sync_inode(inode, &wbc);
> -		if (journal && (journal->j_flags & JBD2_BARRIER))
> -			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> +		/*
> +		 * When there are no blocks attached to the journal transaction
> +		 * some optimizations are possible, but if there were dirty
> +		 * pages sync_inode() should have ensured that all data gets
> +		 * actually written to disk. Thus, we can skip
> +		 * blkdev_issue_flush() below.
> +		 */
> +		if (!(i_state & I_DIRTY_PAGES))
> +			goto flush_blkdev;
  Uh. Here I don't get it. When we did sync_inode(), blkdev_issue_flush()
is needed only if the journal does not do barriers. So I'd expect here:
	if (!(journal->j_flags & JBD2_BARRIER))
		goto flush_blkdev;
	goto out;

>  	}
> +
> +	goto out;
  But here we might need to issue a flush if there are some data written. So
I'd have here:
	if (!(i_state & I_DIRTY_PAGES))
		goto out;

> +
> +flush_blkdev:
> +	if (journal && (journal->j_flags & JBD2_BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  out:
>  	return ret;
>  }

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
