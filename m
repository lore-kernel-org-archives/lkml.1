Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbXKIVq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbXKIVq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXKIVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:46:48 -0500
Received: from mail.fieldses.org ([66.93.2.214]:54728 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbXKIVqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:46:48 -0500
Date: Fri, 9 Nov 2007 16:46:21 -0500
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, ezk@cs.sunysb.edu,
       akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] fix up new filp allocators
Message-ID: <20071109214621.GK26826@fieldses.org>
References: <20071109210439.122065A3@kernel> <20071109210440.497630FB@kernel> <1194643571.7459.107.camel@heimdal.trondhjem.org> <1194644122.7078.116.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194644122.7078.116.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 01:35:22PM -0800, Dave Hansen wrote:
> On Fri, 2007-11-09 at 16:26 -0500, Trond Myklebust wrote:
> > >  #include <linux/sunrpc/svc.h>
> > >  #include <linux/nfsd/nfsd.h>
> > >  #include <linux/nfsd/cache.h>
> > > +#include <linux/file.h>
> > >  #include <linux/mount.h>
> > >  #include <linux/workqueue.h>
> > >  #include <linux/smp_lock.h>
> > > @@ -1303,7 +1304,7 @@ static inline void
> > >  nfs4_file_downgrade(struct file *filp, unsigned int share_access)
> > >  {
> > >  	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
> > > -		put_write_access(filp->f_path.dentry->d_inode);
> > > +		drop_file_write_access(filp);
> > >  		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
> > >  	}
> > >  }
> > 
> > Hmm... The NFS server may also try to 'upgrade' an open file request to
> > a read/write request whenever the client issues a new OPEN request for
> > WRITE using the same open_owner.
> 
> Can you point me to some code?  I'll try and go fix it up.

See fs/nfsd/nfs4state.c:nfs4_upgrade_open().

I suspect that there are other reasons why what nfsd is doing here is a
bad idea, and that we should really be getting a new file descriptor.
But I haven't figured out yet what to do instead.

--b.
