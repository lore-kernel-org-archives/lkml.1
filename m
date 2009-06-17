Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZFQSGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZFQSGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFQSGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:06:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZFQSGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:06:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@sun.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-afs@lists.infradead.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 19:03:43 +0100
Message-ID: <28259.1245261823@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> What _I_ mean is that THIS IS IMPOSSIBLE TO DO FROM USER SPACE!
> 
> Try it. Not doable. User space simply doesn't know enough, and has 
> fundamental races with mount/umount.

Ummm...  I'm not sure I completely agree.  If you've managed to open, say,
"/afs", where's the race with mount/umount?  You've got a file descriptor you
can use as a handle.  Yes, you have to check that it's actually an inode of
your fs, but that's not exactly difficult, and that's not going to change just
because someone unmounts it or mounts over it whilst you've got it open.

However, that makes userspace have to assume that the pioctl handler is on an
AFS inode, perhaps any AFS inode.  This is not compatible with OpenAFS as it
stands, and also means you can't use the AFS pioctls before mounting anything,
and you can't mount it elsewhere and expect it to work.

> End result: you do need a new system call. 
> 
> I just don't think "pioctl()" is a good one.

Out of interest, why not?  Is it just because it's another multipexor?  Or is
it because it's been abused to have pathless commands?

> You'd be better off with some modification of open and then use ioctl.

So you'd say use:

	fd = open("/the/target/file", O_SUPPRESS | (nofollow?O_NOFOLLOW:0));
	ioctl(fd, cmd, &args);
	close(fd);

where O_SUPPRESS (or whatever) suppressed override of the ops tables by the
chardev and blockdev handlers, and allows symlinks to be opened, rather than:

	pioctl("/the/target/file", cmd, &args, nofollow);

I would counter that with:

 (1) pioctl() is actually simpler and cleaner, and doesn't require
     modifications to open().

 (2) The open()/ioctl() method doesn't handle pathless pioctls, and so is not
     a complete solution.

 (3) The open()/ioctl() method assumes that pioctl() command numbers don't
     clash with ioctl() command numbers - something that's unfortunately not
     true of OpenAFS:-(

     Of course, you could have one ioctl() command number that says that this
     is a pioctl() and then a second number in the argument data that is the
     pioctl() command number.

 (4) pioctl() is compatible with OpenAFS.

Do you also disagree with OpenAFS's idea of creating a proc file to open so
that you can do ioctls on that to emulate pioctl()?  That would serve also.

David
