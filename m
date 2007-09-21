Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbXIUVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbXIUVQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765242AbXIUVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:15:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38887 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764981AbXIUVPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:15:51 -0400
Subject: Re: [PATCH 07/25] r/o bind mounts: elevate write count for some
	ioctls
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20070921011706.88e9bcdd.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195257.0E38EED5@kernel>
	 <20070921011706.88e9bcdd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 14:15:43 -0700
Message-Id: <1190409344.26982.192.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 01:17 -0700, Andrew Morton wrote:
> On Thu, 20 Sep 2007 12:52:57 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > +		ret = mnt_want_write(filp->f_vfsmnt);
> 
> It still creeps me out that we have this sprinkled *all over* the tree and
> people will forget to do it and there's no runtime or compile-time checking
> that they remembered to do it and when they forget to do it nobody will
> notice that it broke until ages and ages later.
> 
> IOW: it is a sheer horror for maintainability.
> 
> 
> Please have a think about what we can do about this.  For example, if you'd
> thought about this up-front, (and I think it's a big problem), we could
> have done something grotty like, in mnt_want_write():
> 
> 	current->vfsmnt_im_allowed_to_write_to = inode;
> 
> and then check that current->vfsmnt_im_allowed_to_write_to is the correct
> inode in __mark_inode_dirty() and various other strategic places.  That
> sort of thing.

Just brainstorming a bit...  I tried just keeping a writer count in the
superblock which we bump at the same time as the mnt->__mnt_writers,
which makes it quite easy to check whenever we have the inode around.
This causes quite a few false positives with journal code, and I think a
few more with direct block device access.  I think we can work around
those, though.

The true issue comes when we have a lot of users (more than one) of a
superblock.  If anybody has a write request outstanding, then the check
I put in will get skipped.  It's easy to mask real problems this way.

Putting the "inodes allowed" list in the task (or probably signal struct
to support threads) should be workable, but I worry a bit about the
cases where fds are sent across sockets.

We could also break up the mnt_want_write() requests into two classes,
the common mnt_want_write() case and mnt_want_indefinite_write() or
something.  The plain (and common) case is the one for things like
rmdir, mknod, or chmod where the write is confined to a single syscall.
mnt_want_indefinite_write() would be for things that do an open() and
later work on a file descriptor.  Each of these cases could have a
different variable or flag in (or hanging off) the task struct.  

In __mark_inode_dirty() we would first check to see if we are currently
in one of the plain, more atomic, mnt_want_write() regions by checking a
flag.  If not, we go looking through the task's file descriptors and
seeing if one of them is open for write on the inode.  If both of these
conditions fail, then we have a potential bug.  

-- Dave

