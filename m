Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZGVNwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZGVNwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZGVNwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:52:24 -0400
Received: from cmpxchg.org ([85.214.51.133]:34805 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZGVNwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:52:23 -0400
Date: Wed, 22 Jul 2009 15:51:10 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       smfrench@gmail.com, hch@infradead.org
Subject: Re: [PATCH] fix offset checks in do_sendfile to use unsigned values
Message-ID: <20090722135110.GA3091@cmpxchg.org>
References: <1248262099-12514-1-git-send-email-jlayton@redhat.com> <1248262099-12514-2-git-send-email-jlayton@redhat.com> <20090722125945.GA2834@cmpxchg.org> <1248269879.4534.12.camel@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248269879.4534.12.camel@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:37:59AM -0400, Jeff Layton wrote:
> On Wed, 2009-07-22 at 14:59 +0200, Johannes Weiner wrote:
> > On Wed, Jul 22, 2009 at 07:28:19AM -0400, Jeff Layton wrote:
> > > If do_sendfile is called with a "max" value of 0, it grabs the lesser
> > > s_maxbytes value of the two superblocks to use instead. There's a
> > > problem here however. s_maxbytes is an unsigned long long and it gets
> > > cast to a signed value. If both s_maxbytes values are large enough, max
> > > will end up being negative and the comparisons in this code won't work
> > > correctly.
> > > 
> > > Change do_sendfile to use unsigned values internally for the offset
> > > checks.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > ---
> > >  fs/read_write.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > index 6c8c55d..36899ff 100644
> > > --- a/fs/read_write.c
> > > +++ b/fs/read_write.c
> > > @@ -788,11 +788,11 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
> > >  }
> > >  
> > >  static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
> > > -			   size_t count, loff_t max)
> > > +			   size_t count, unsigned long long max)
> > >  {
> > >  	struct file * in_file, * out_file;
> > >  	struct inode * in_inode, * out_inode;
> > > -	loff_t pos;
> > > +	unsigned long long pos;
> > >  	ssize_t retval;
> > >  	int fput_needed_in, fput_needed_out, fl;
> > >  
> > > @@ -838,7 +838,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
> > >  	if (!max)
> > >  		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
> > >  
> > > -	pos = *ppos;
> > > +	pos = (unsigned long long) *ppos;
> > >  	retval = -EINVAL;
> > >  	if (unlikely(pos < 0))
> > >  		goto fput_out;
> > 
> > May it be possible that cifs is the only fs that sets sb->sb_maxbytes
> > to exceed loff_t?  It seems the others clamp it to MAX_LFS_FILESIZE
> > while CIFS exceeds this by one.  And then max is -1.
> > 
> > So, isn't the correct fix something similar to this?
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index e16d759..df56093 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2452,10 +2452,10 @@ try_mount_again:
> >  		tcon->local_lease = volume_info->local_lease;
> >  	}
> >  	if (pSesInfo) {
> > -		if (pSesInfo->capabilities & CAP_LARGE_FILES) {
> > -			sb->s_maxbytes = (u64) 1 << 63;
> > -		} else
> > -			sb->s_maxbytes = (u64) 1 << 31;	/* 2 GB */
> > +		if (pSesInfo->capabilities & CAP_LARGE_FILES)
> > +			sb->s_maxbytes = MAX_LFS_FILESIZE;
> > +		else
> > +			sb->s_maxbytes = MAX_NON_LFS;
> >  	}
> >  
> >  	/* BB FIXME fix time_gran to be larger for LANMAN sessions */
> 
> Yes and I posted that exact same cifs patch yesterday.

Sorry, I missed it.

> I think we also need to do a similar fix for get_sb_pseudo. It
> currently sets s_maxbytes to ~0ULL...

Yes, I saw it and agree with it.

> Any of these patches will fix the immediate problem, but I think this
> code in do_sendfile should still account for the possibility that
> someone can set the value larger than MAX_LFS_FILESIZE. An alternative
> is to consider a WARN at mount time when filesystems set s_maxbytes
> larger than that value (that might help catch out of tree filesystems
> that get this wrong and prevent this sort of silent bug in the future).

Isn't MAX_LFS_FILESIZE by definition the maximum sensible value for
s_maxbytes?

> Either way, the patch I posted for this isn't sufficient since there are
> some checks that need to be done against the signed values (the
> (pos < 0) check, for instance). I'll post a respun patch in a bit that
> should fix up those problems.

That is already handled in rw_verify_area(), I think, so we should be
able to drop it completely.

	Hannes
