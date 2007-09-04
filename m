Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbXIDIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbXIDIgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXIDIgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:36:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXIDIgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:36:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 04 Sep 2007 09:35:40 +0100
Message-ID: <6503.1188894940@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words, let's assume that the user has /some/nfs/mount mounted 
> over NFS, and wants to re-mount it (or even just a subset of it) somewhere 
> else, the sane thing to do is not to mount it again, but to just do

That helps one case, yes, but what about a superset?  What about two sets that
might intersect but for which you don't have the common root to hand?  The
current NFS code deals with all these problems by attempting to share the
dentry sets.  Superblocks can now have multiple roots and we graft trees
together automatically when we discover one is a subset of another.

The case I came up with was this:

	mount home:/home/fred /home/fred
	mount home:/home/jim /home/jim

To effect these, the NFS mount process looks up "/home/fred" or "/home/jim"
directly rather than looking up "/" and path walking.  However, the NFS client
in the kernel may note that both Fred's and Jim's home directories reside on
the same NFS volume.  You cannot use a bind mount here because there's nothing
to bind from.

Then, should, say, this happen:

	mount home:/home /mnt

You'll probably end up with three roots in the NFS superblock.  Following with
an ls of /home, say, would then populate the dentries for /home - including
those for fred and jim, and the code would splice in the dentried now rooted at
/home/fred and /home/jim.

You can't do that with bind mounts as far as I know because I don't believe
that you can go up the tree (rootwards) from the apparent root of a vfsmount.

So bind mounts aren't quite it for this problem, and in any case your
suggestion of:

	mount --bind /some/nfs/mount/subdir /new/mount/place

doesn't help with the automounter case particularly well.  The automounter
*could* probe to see if the server stuff is common with an already existing
mount, but there would then be a race, and it doesn't help with the homedir
example I gave above either.

You might think "well, start by mounting '/' somewhere and then bind mounting
subdirs of it", but that doesn't work if you can't mount "/" or "/home", and
might go spectacularly wrong if the server has a symlink in the path that you
can't see.


> This is why I think "nosharecache" should just be the default, because 
> that's the behaviour that simply does not have any subtle issues. The 
> *special* case should be the "sharecache" case, and 99% of the time that 
> one should likely be done with a "--bind" mount.

Yeah, that's probably necessary, if annoying.  However, local caching can
enable sharing or make it a prerequisite option.

> (I don't really see the point of _ever_ doing anything but a bind mount, 
> but maybe there are reasons to try to share at a NFS layer that I don't 
> really see)

The reason I added all this NFS superblock sharing is so that I could implement
on-disk local caching much more easily.  If, for instance, two netfs inodes
aren't shared, but their "index keys" say they should use the same piece of
cache then all sorts of fun ensues from the disjoint cache coherency.

Even working out that two inodes are using the same piece of cache isn't
trivial (though it seems like it ought to be).

David
