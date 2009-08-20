Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZHTNbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZHTNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZHTNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbZHTNbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:31:35 -0400
Date: Thu, 20 Aug 2009 15:31:35 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 03/17] vfs: Remove syncing from
	generic_file_direct_write() and generic_file_buffered_write()
Message-ID: <20090820133135.GF16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-4-git-send-email-jack@suse.cz> <20090819161853.GC6150@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819161853.GC6150@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-08-09 12:18:53, Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 06:04:30PM +0200, Jan Kara wrote:
> > generic_file_direct_write() and generic_file_buffered_write() called
> > generic_osync_inode() if it was called on O_SYNC file or IS_SYNC inode. But
> > this is superfluous since generic_file_aio_write() does the syncing as well.
> > Also XFS and OCFS2 which call these functions directly handle syncing
> > themselves. So let's have a single place where syncing happens:
> > generic_file_aio_write().
> 
> Yeah, this is something that never made any sense to me.
> 
> > @@ -2187,20 +2187,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
> >  		}
> >  		*ppos = end;
> >  	}
> > -
> > -	/*
> > -	 * Sync the fs metadata but not the minor inode changes and
> > -	 * of course not the data as we did direct DMA for the IO.
> > -	 * i_mutex is held, which protects generic_osync_inode() from
> > -	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
> > -	 */
> >  out:
> > -	if ((written >= 0 || written == -EIOCBQUEUED) &&
> > -	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
> > -		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
> > -		if (err < 0)
> > -			written = err;
> > -	}
> >  	return written;
> 
> Here we check (written >= 0 || written == -EIOCBQUEUED), but
> generic_file_aio_write only cares about positive return values.  We
> defintively do have a change here for partial AIO requests.
  Ah, that's a good point.

> The question is if the previous behaviour made in sense.  If do have an
> O_SYNC aio+dio request we would have to flush out the metadata after the
> request has completed and not here.
  Yes, that would be a correct behavior but I see no good way of doing
that. Flushing on EIOCBQUEUED mostly works for simple filesystems like
ext[23] where we don't do anything from end_io callback. The only risk
is if we crash after the transaction commits but before the direct IO is
done (we could expose stale data) but I'm not sure that is an issue with
real HW.
  Anyway, the question is what we should do about it.  For now, I'd call
generic_write_sync() even in case EIOCBQUEUED is returned to preserve old
behavior (EIOCBQUEUED does not seem to be returned from buffered write path
so we really just preserve the old behavior).

> > @@ -2343,16 +2328,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
> >  	if (likely(status >= 0)) {
> >  		written += status;
> >  		*ppos = pos + status;
> > -
> > -		/*
> > -		 * For now, when the user asks for O_SYNC, we'll actually give
> > -		 * O_DSYNC
> > -		 */
> > -		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
> > -			if (!a_ops->writepage || !is_sync_kiocb(iocb))
> > -				status = generic_osync_inode(inode, mapping,
> > -						OSYNC_METADATA|OSYNC_DATA);
> > -		}
> >    	}
> 
> No problem with -EIOCBQUEUED here, but we change from doing
> generic_osync_inode with OSYNC_DATA which does a full writeout of the
> data to sync_page_range which only does the range writeout here.  That
> should be fine (as we only need to sync that range), but should probably
> be documented in the patch description.
  Yes, will do.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
