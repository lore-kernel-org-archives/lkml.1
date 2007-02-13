Return-Path: <linux-kernel-owner+w=401wt.eu-S1750876AbXBMQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbXBMQ6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXBMQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:58:48 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:57594 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXBMQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:58:48 -0500
Subject: Re: [PATCH 12/22] elevate write count files are open()ed
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070212211148.c9069c97.akpm@linux-foundation.org>
References: <20070209225329.27619A62@localhost.localdomain>
	 <20070209225337.C8EC7257@localhost.localdomain>
	 <20070212211148.c9069c97.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 08:58:16 -0800
Message-Id: <1171385896.6202.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 21:11 -0800, Andrew Morton wrote:
> On Fri, 09 Feb 2007 14:53:37 -0800 Dave Hansen <hansendc@us.ibm.com> wrote:
> 
> > diff -puN fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/file_table.c
> > --- lxc/fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
> > +++ lxc-dave/fs/file_table.c	2007-02-09 14:26:54.000000000 -0800
> > @@ -209,8 +209,11 @@ void fastcall __fput(struct file *file)
> >  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
> >  		cdev_put(inode->i_cdev);
> >  	fops_put(file->f_op);
> > -	if (file->f_mode & FMODE_WRITE)
> > +	if (file->f_mode & FMODE_WRITE) {
> >  		put_write_access(inode);
> > +		if(!special_file(inode->i_mode))
> > +			mnt_drop_write(mnt);
> > +	}
> >  	put_pid(file->f_owner.pid);
> >  	put_user_ns(file->f_owner.user_ns);
> >  	file_kill(file);
> > diff -puN fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/namei.c
> > --- lxc/fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
> > +++ lxc-dave/fs/namei.c	2007-02-09 14:26:54.000000000 -0800
> > @@ -1548,8 +1548,17 @@ int may_open(struct nameidata *nd, int a
> >  			return -EACCES;
> >  
> >  		flag &= ~O_TRUNC;
> > -	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
> > -		return -EROFS;
> > +	} else if (flag & FMODE_WRITE) {
> > +		/*
> > +		 * effectively: !special_file()
> > +		 * balanced by __fput()
> > +		 */
> > +		error = mnt_want_write(nd->mnt);
> > +		if (error)
> > +			return error;
> > +		if (IS_RDONLY(inode))
> > +			return -EROFS;
> > +	}
> 
> yipes.  A new mount-wide spin_lock/unlock for each for-writing open() and close().
> Can we have a microbenchmark on this please?

Yeah, I'll schedule some dbench time on a NUMA machine.

> Are you sure that fget_light() and fput_light() don't accidentally bypass this
> new logic?

Pretty sure.  My code actually surrounds all of the permission() checks
in the VFS.  To even use fget, you had to get a fd at some point, and to
do that you have to go through open, where both the mount and normal
filesystem checks are.

Is there something particular you had in mind?

-- Dave

