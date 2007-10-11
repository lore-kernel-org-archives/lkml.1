Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXJKSRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXJKSRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 14:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXJKSR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 14:17:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38728 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbXJKSR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 14:17:28 -0400
Subject: Re: [RFC][PATCH 2/7] get mount write in __dentry_open()
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <E1IfzeX-0007qp-00@dorka.pomaz.szeredi.hu>
References: <20071010163439.0F8089F7@kernel>
	 <20071010163439.9DB7F219@kernel> <E1IfzeX-0007qp-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 11:16:56 -0700
Message-Id: <1192126616.31114.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-11 at 17:08 +0200, Miklos Szeredi wrote:
> > diff -puN fs/namei.c~get-write-in-__dentry_open fs/namei.c
> > --- lxc/fs/namei.c~get-write-in-__dentry_open	2007-10-03 14:44:52.000000000 -0700
> > +++ lxc-dave/fs/namei.c	2007-10-04 18:02:48.000000000 -0700
> > @@ -1621,14 +1621,6 @@ int may_open(struct nameidata *nd, int a
> >  			return -EACCES;
> >  
> >  		flag &= ~O_TRUNC;
> > -	} else if (flag & FMODE_WRITE) {
> > -		/*
> > -		 * effectively: !special_file()
> > -		 * balanced by __fput()
> > -		 */
> > -		error = mnt_want_write(nd->mnt);
> > -		if (error)
> > -			return error;
> >  	}
> 
> Maybe readonly should still be checked here, so that the order of
> error checking doesn't change.  If racing with a read-only remount the
> order is irrelevant anyway.  Something like this?
> 
> 	} else if (flag & FMODE_WRITE && __mnt_is_readonly(nd->mnt)) {
> 		return -EROFS
> 	}

I think that would be a bug if anything actually managed to trip that
code.  all of the may_open() calls should have been covered by the
__dentry_open() mnt writer.

> >  	error = vfs_permission(nd, acc_mode);
> > @@ -1778,11 +1770,7 @@ do_last:
> >  
> >  	/* Negative dentry, just create the file */
> >  	if (!path.dentry->d_inode) {
> > -		error = mnt_want_write(nd->mnt);
> > -		if (error)
> > -			goto exit_mutex_unlock;
> >  		error = open_namei_create(nd, &path, flag, mode);
> > -		mnt_drop_write(nd->mnt);
> 
> This is still needed, isn't it?

Yes, it is.  I'll add a big fat comment this time about why we need it.

> And they should be added around do_truncate() as well, since you
> remove the protection from may_open().
> 
> This one introduces an interesting race between ro-remount and
> open(O_TRUNC), where the truncate can succeed but the open fail with
> EROFS.  Is that a problem?

You're right, this does introduce that race, and it is relatively hard
to fix properly.  But, the 'return a filp' patch makes it easy to fix.
I've put a temporary kludge in the updated version of this patch, and
fixed it properly in that later patch.  

> >  cleanup_all:
> >  	fops_put(f->f_op);
> > -	if (f->f_mode & FMODE_WRITE)
> > +	if (f->f_mode & FMODE_WRITE) {
> >  		put_write_access(inode);
> > +		mnt_drop_write(mnt);
> 
> Shouldn't this be conditional on !special_file()?

It certainly should.

-- Dave

