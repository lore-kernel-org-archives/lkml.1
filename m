Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZETMtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZETMtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbZETMtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:49:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbZETMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:49:19 -0400
Date: Wed, 20 May 2009 14:49:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, aia21@cantab.net,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090520124920.GZ11363@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <20090520123710.GA29974@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520123710.GA29974@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20 2009, Christoph Hellwig wrote:
> Can you run the hunk below past Anton and get it upstream separately?
> The code does indeed looks extremly fishy, but I'd rather not see it
> go in a large unrelated patch..

Yes, it really should go out of this patchset and into a prep patch.
Anton, care to comment?

> On Mon, May 18, 2009 at 02:19:43PM +0200, Jens Axboe wrote:
> > diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> > index f76951d..c4cb157 100644
> > --- a/fs/ntfs/super.c
> > +++ b/fs/ntfs/super.c
> > @@ -2373,39 +2373,13 @@ static void ntfs_put_super(struct super_block *sb)
> >  		vol->mftmirr_ino = NULL;
> >  	}
> >  	/*
> > -	 * If any dirty inodes are left, throw away all mft data page cache
> > -	 * pages to allow a clean umount.  This should never happen any more
> > -	 * due to mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
> > -	 * the underlying mft records are written out and cleaned.  If it does,
> > +	 * We should have no dirty inodes left, due to
> > +	 * mft.c::ntfs_mft_writepage() cleaning all the dirty pages as
> > +	 * the underlying mft records are written out and cleaned.
> >  	 * happen anyway, we want to know...
> >  	 */
> >  	ntfs_commit_inode(vol->mft_ino);
> >  	write_inode_now(vol->mft_ino, 1);
> > -	if (sb_has_dirty_inodes(sb)) {
> > -		const char *s1, *s2;
> > -
> > -		mutex_lock(&vol->mft_ino->i_mutex);
> > -		truncate_inode_pages(vol->mft_ino->i_mapping, 0);
> > -		mutex_unlock(&vol->mft_ino->i_mutex);
> > -		write_inode_now(vol->mft_ino, 1);
> > -		if (sb_has_dirty_inodes(sb)) {
> > -			static const char *_s1 = "inodes";
> > -			static const char *_s2 = "";
> > -			s1 = _s1;
> > -			s2 = _s2;
> > -		} else {
> > -			static const char *_s1 = "mft pages";
> > -			static const char *_s2 = "They have been thrown "
> > -					"away.  ";
> > -			s1 = _s1;
> > -			s2 = _s2;
> > -		}
> > -		ntfs_error(sb, "Dirty %s found at umount time.  %sYou should "
> > -				"run chkdsk.  Please email "
> > -				"linux-ntfs-dev@lists.sourceforge.net and say "
> > -				"that you saw this message.  Thank you.", s1,
> > -				s2);
> > -	}
> >  #endif /* NTFS_RW */
> >  
> >  	iput(vol->mft_ino);
> 

-- 
Jens Axboe

