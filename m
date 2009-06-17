Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZFQR1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZFQR1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFQR06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:26:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbZFQR05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:26:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@sun.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 18:24:39 +0100
Message-ID: <28023.1245259479@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > What about opening the mountpoint (which HAS to be available) and then
> > calling an ioctl() on that?
> 
> It's very hard to "open the mountpoint" in user space. How would you even 
> do it? Remember: we're not living in the 1980's any more, and disco is 
> dead. ABBA may have made a comeback, but static mountpoints are long gone, 
> and won't be coming back.

I think what Andreas means is open the directory at the root of the mounted
tree, i.e. "/afs" for AFS, and then do an ioctl() on that that emulates
pioctl().

This is similar to what Coda does (see fs/coda/pioctl.c) except that that uses
a special file hidden in the root dir of the Coda mount (see coda_lookup() in
fs/coda/dir.c) that doesn't appear to readdir.

This is also similar to what OpenAFS does if it can't alter the syscall table -
it creates a proc file (/proc/fs/openafs/afs_ioctl) and issues ioctls on that,
to emulate pioctl().

In both cases, the pioctl emulator calls user_path() or similar from the
module, and then calls the appropriate handler directly.

> So you'd need to open the file itself. Which might be a symlink or a 
> device node, depending on the exact semantics of pioctl.

Indeed.  I was also hoping to use them to control caching of AFS, NFS and CIFS
files, where you might want to point at a file and say "put that in the cache"
or "eject that from the cache" or "keep that out of the cache".  However,
that's only possible with certain types of file where the file is opened
directly and an ioctl() done on it instead of a pioctl().  As you point out,
for symlinks it's tricky and for device files it's definitely wrong.

I'll acknowledge that it *could* perhaps be done with [l]setxattr() using
special attributes - however these things aren't necessarily attributes of the
file, but rather attributes of the system, so is setxattr() semantically
correct?

David
