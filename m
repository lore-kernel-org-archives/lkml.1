Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZDWKIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZDWKIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZDWKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:08:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47389 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZDWKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:08:42 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net
In-reply-to: <49EFB1A9.3060503@kernel.org> (message from Tejun Heo on Thu, 23
	Apr 2009 09:09:13 +0900)
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org>
Message-Id: <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Apr 2009 12:08:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Tejun Heo wrote:
> Miklos Szeredi wrote:

> > What I changed (IIRC):
> > 
> >  - Don't store pointer to struct inode, struct fuse_inode, and struct
> >    file in struct fuse_file.  Instead store nodeid in struct
> >    fuse_file, no worries about object lifetimes this way.
> 
> Hmm... there really isn't any object lifetime issue with or without
> the pointers as both fuse_file and fuse_inode follow VFS lifetime
> rules.

I did find some problems with lifetimes (it was I think struct file
still being used in release code, but it may have been something
different).

>   I tried several different approaches including adding nodeid
> but what pushed me toward adding the pointers was that the parameter
> passing and which uses/depends on what becomes a bit too complex with
> other approaches.  e.g. How do you discern between needing vfs inode
> and fuse inode?

VFS inode should never be needed by the CUSE codepaths.  Well, maybe
for setting access/modification times, but in any case those need not
be shared with fuse code.

> 
> >  - Don't implement fsync and flush in CUSE, they don't really make
> >    sense on character devices.  At least I can't think of any use for
> >    them.
> >  - release() in CUSE can be synchronous.  Asynchronous release causes
> >    many headaches in fuse, but is necessary due to the possible DoS
> >    that an unprivileged filesystem could do with an unrelated process.
> >    Since CUSE servers are always privileged, this should not be an
> >    issue.
> 
> Cool.
> 
> >  - Other cleanups.
> > 
> > I still think that the INIT sequence in CUSE is way too complicated
> > and that the kernel thread is unnecessary.  How about doing the init
> > with a single CUSE_INIT message which embeds the fuse_init_in and
> > fuse_init_out structures.
> 
> I don't see why the kernel thread is such a big problem.  It's just a
> kernel thread.

I think it's an unnecessary complication.  Threads are useful if
something needs to be _done_, but in this case nothing is done, just
waiting for the reply.  One example why I find it hackish is that you
are returning error values from the thread, as if it was a synchronous
thing, but those errors are obviously lost.

I don't see any problems with doing the device initialization in the
context of the replying process (which will usually be the same as the
one opening the device anyway).

>  We can surely fold FUSE_INIT inside FUSE_INIT tho but
> one way or the other doesn't make whole lot of difference.

I just think it would be cleaner, both code-wise and protocol-wise.  I
can do the above cleanups if you have no objection.

> > I also don't see the purpose of the CUSE_INIT_DONE message.  Isn't
> > it enough not to send any other messages while the initialization is
> > not complete?  This is what fuse does.
> 
> The difference between FUSE and CUSE in this regard is that the
> synchornous part of initialization is much less for CUSE.  ie. For
> FUSE, after the mount is complete, all accesses go to FUSE, so it's
> all good.  However, for CUSE, the device nodes are setup
> asynchronously, so there's no such inherent synchronization point as
> mount.  This becomes a problem when CUSE is started from modprobe to
> emulate devices on demand because modprobe should not return before
> the device nodes are setup.

Hmm, OK.

Thanks,
Miklos
