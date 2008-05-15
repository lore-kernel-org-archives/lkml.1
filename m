Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYEOHjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYEOHjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYEOHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:39:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46185 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYEOHja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:39:30 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080515072358.GS13907@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 15 May 2008 08:23:58 +0100)
Subject: Re: [patch 08/24] vfs: immutable inode checking cleanup
References: <20080506091327.259950960@szeredi.hu> <20080506091416.025653274@szeredi.hu> <20080515072358.GS13907@ZenIV.linux.org.uk>
Message-Id: <E1JwY3V-0006CO-Lz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 09:39:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux-2.6.orig/fs/attr.c	2008-05-06 11:04:29.000000000 +0200
> > +++ linux-2.6/fs/attr.c	2008-05-06 11:04:35.000000000 +0200
> > @@ -108,6 +108,12 @@ int notify_change(struct dentry * dentry
> >  	struct timespec now;
> >  	unsigned int ia_valid = attr->ia_valid;
> >  
> > +	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
> > +			ATTR_ATIME_SET | ATTR_MTIME_SET)) {
> > +		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> > +			return -EPERM;
> > +	}
> > +
> >  	now = current_fs_time(inode->i_sb);
> >  
> >  	attr->ia_ctime = now;
> > Index: linux-2.6/fs/utimes.c
> > ===================================================================
> > --- linux-2.6.orig/fs/utimes.c	2008-05-06 11:04:29.000000000 +0200
> > +++ linux-2.6/fs/utimes.c	2008-05-06 11:04:35.000000000 +0200
> > @@ -105,10 +105,6 @@ long do_utimes(int dfd, char __user *fil
> >  	/* Don't worry, the checks are done in inode_change_ok() */
> >  	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
> >  	if (times) {
> > -		error = -EPERM;
> > -                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > -			goto mnt_drop_write_and_out;
> > -
> >  		if (times[0].tv_nsec == UTIME_OMIT)
> >  			newattrs.ia_valid &= ~ATTR_ATIME;
> >  		else if (times[0].tv_nsec != UTIME_NOW) {
> 
> Erm...  What happens if we have UTIME_NOW on both and inode is marked
> immutable?  AFAICS, you've just switched from -EPERM to -EACCES.
> For append-only it's even more interesting - you go from -EPERM to
> success.

Yup.  These are defensible on the ground that times == NULL should be
equivalent to UTIME_NOW on both.  There's really no reason to be
stricter on the latter case.

> It might or might not be the right thing to do, and the syscall is
> new, but...  Do you have an ACK from Ulrich?

No.  I could CC him on these, but he's not even acking my security
patches on utimesat, so I don't have high hopes.

Miklos
