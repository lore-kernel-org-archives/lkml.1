Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbXKIVjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbXKIVjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbXKIVfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:35:33 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52007 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598AbXKIVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:35:30 -0500
Subject: Re: [PATCH 2/2] fix up new filp allocators
From: Dave Hansen <haveblue@us.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: ezk@cs.sunysb.edu, akpm@osdl.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <1194643571.7459.107.camel@heimdal.trondhjem.org>
References: <20071109210439.122065A3@kernel>
	 <20071109210440.497630FB@kernel>
	 <1194643571.7459.107.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 13:35:22 -0800
Message-Id: <1194644122.7078.116.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 16:26 -0500, Trond Myklebust wrote:
> >  #include <linux/sunrpc/svc.h>
> >  #include <linux/nfsd/nfsd.h>
> >  #include <linux/nfsd/cache.h>
> > +#include <linux/file.h>
> >  #include <linux/mount.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/smp_lock.h>
> > @@ -1303,7 +1304,7 @@ static inline void
> >  nfs4_file_downgrade(struct file *filp, unsigned int share_access)
> >  {
> >  	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
> > -		put_write_access(filp->f_path.dentry->d_inode);
> > +		drop_file_write_access(filp);
> >  		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
> >  	}
> >  }
> 
> Hmm... The NFS server may also try to 'upgrade' an open file request to
> a read/write request whenever the client issues a new OPEN request for
> WRITE using the same open_owner.

Can you point me to some code?  I'll try and go fix it up.

> > diff -puN fs/pipe.c~fix-idmapd-bug fs/pipe.c
> > --- linux-2.6.git/fs/pipe.c~fix-idmapd-bug	2007-11-09 12:13:15.000000000 -0800
> > +++ linux-2.6.git-dave/fs/pipe.c	2007-11-09 12:13:15.000000000 -0800
> > @@ -959,13 +959,10 @@ struct file *create_write_pipe(void)
> >  	struct dentry *dentry;
> >  	struct qstr name = { .name = "" };
> >  
> > -	f = get_empty_filp();
> > -	if (!f)
> > -		return ERR_PTR(-ENFILE);
> >  	err = -ENFILE;
> >  	inode = get_pipe_inode();
> >  	if (!inode)
> > -		goto err_file;
> > +		goto err;
> >  
> >  	err = -ENOMEM;
> >  	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
> > @@ -980,13 +977,14 @@ struct file *create_write_pipe(void)
> >  	 */
> >  	dentry->d_flags &= ~DCACHE_UNHASHED;
> >  	d_instantiate(dentry, inode);
> > -	f->f_path.mnt = mntget(pipe_mnt);
> > -	f->f_path.dentry = dentry;
> > +
> > +	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
> > +	err = -ENFILE;
> > +	if (!f)
> > +		goto err_inode;
> >  	f->f_mapping = inode->i_mapping;
> >  
> >  	f->f_flags = O_WRONLY;
> > -	f->f_op = &write_pipe_fops;
> > -	f->f_mode = FMODE_WRITE;
> >  	f->f_version = 0;
> >  
> >  	return f;
> > @@ -994,8 +992,7 @@ struct file *create_write_pipe(void)
> >   err_inode:
> >  	free_pipe_info(inode);
> >  	iput(inode);
> > - err_file:
> > -	put_filp(f);
> > + err:
> >  	return ERR_PTR(err);
> >  }
> 
> Does RPC idmapd open a regular pipe too? I thought it only used
> rpc_pipefs?

No.  I the the actual bug triggered by idmapd was from an eventpoll filp
that had been acquired through anon_inode_getfd().  I just noticed the
pipe code here could be another potential bug of the same type.

-- Dave

