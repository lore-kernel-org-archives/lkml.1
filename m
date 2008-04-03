Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbYDCHdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbYDCHdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759797AbYDCHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:33:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48447 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbYDCHdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:33:23 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080402214824.GP9785@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 2 Apr 2008 22:48:24 +0100)
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu> <20080402214824.GP9785@ZenIV.linux.org.uk>
Message-Id: <E1JhJwR-0008Vv-2x@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Apr 2008 09:32:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It is an interface with at least 3 callers at the moment: syscalls,
> > nfsd and ecryptfs and unionfs in the future. It is an interface
> > because all external accesses to the filesystem *are* done through the
> > namespace and not directly on filesystem internals.
> > 
> > Such direct access would be conceivable, but I don't think we should
> > base the design on theoretically possible uses.  If those uses appear,
> > we can change the interface to fit that.
> > 
> > This "move everything to callers" thing is wrong because it just
> > results in bloat and bugs, none of which is desirable in the kernel.
> 
> I disagree.  First of all, clear separation between operations on
> _filesystem_, which should all be namespace-agnostic and things
> that depend on vfsmount is a Good Thing(tm).  Think of that as
> of separation between server (superblock and everything related
> to it, starting with dentry tree) and clients; mixing those is a
> bloody bad idea.

Separation: yes.  Exporting it as an interface: I'm not convinced.

If we ever want to rely on r/o mounts doing what they're supposed to
do, ie. not allowing modifications to the filesystem, we'd better
expose an interface that does just that.  Relying on callers won't
work (as demonstrated in practice).

Wasn't one of the points behind the r/o bind patchset is to make
remounting read-only race free?  If all mounts of a super block are
read-only, then the super block itself can be safely marked read-only.

If we allow external entities such as filesystem stacks to bypass this
rule and access the filesystem directly, then the whole thing is
basically worthless.

> What's more, I'm not at all convinced that for nfsd it's the right
> set of checks, to start with.

Well, what are the right checks then?  From the r/o consistency pov,
these are the right checks.  From NFS' pov there may be places where
we might want to take a write-ref spanning several operations.  But
that's OK, the checks are cheap (if not, we have other problems).

>  The same goes for future users.

There's already one place in that interface where users need to know
the vfsmount which they are operating on: opening a file (and hence
subsequent I/O on that file).  Besides my other points, what is the
sense in an interface, half of which operates on the namespace, and
the other half on the filesystem?

> As for ecryptfs, looking at their "lower_mnt" thing...  I'd say that
> it's a nonsense.  For one thing, duplicating a reference into ever
> dentry out there (and it's simply duplicated) makes no sense whatsoever.
> For another...  I'm not at all sure that remount of the underlying
> vfsmount r/o *should* take that sucker read-only.  And if it should,
> it's clearly an action that should have a visible effect on superblock
> flags of ecryptfs.

If it wants to handle that case nicely, it can monitor /proc/mounts
and reflect it in it's superblock flags.  And it can take a write-ref
on the underlying fs if it has outstanding dirtyness.  But we should
not _rely_ on ecryptfs to ensure that it's never writing to a
read-only mount.

Miklos
