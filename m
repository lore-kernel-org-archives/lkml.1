Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbZFQAU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbZFQAU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZFQAUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:20:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbZFQAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:20:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090616205454.GA2181@infradead.org>
References: <20090616205454.GA2181@infradead.org> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <20090616203850.4526.83585.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 01/17] VFS: Implement the pioctl() system call
Date: Wed, 17 Jun 2009 01:19:44 +0100
Message-ID: <11610.1245197984@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> > Implement the pioctl() system call.  This is used to support a number of AFS
> > functions, and could also be used for Coda and other filesystems.
> 
> Umm, adding a new system call multiplexer without any structure is a
> serious no-go.  And this one is much worse than ioctl, which with a
> fixed [fd,cmd,arg] tuple seems like a stronhold of sanity compred to this
> monster with multiple arguments and a path that may or may not be there.

Ummm...  pioctl() has lots of structure.  Standard argument/reply block
definition, for example: you get one blob of argument, you may return one blob
of argument, you must structure your blobs such that 32-bit/64-bit
compatibility problems don't occur.  It's _much_ more structured than ioctl,
for example.

The main annoyance with it, as you noted, is the fact that people have treated
the path as being optional.

> I think you'd be better of writing tools that use a sane interface than
> adding a big pile of crap like this to the kernel.

Name a single sane interface that can do all that pioctl() can?  There isn't
one.  You can emulate almost all of pioctl() in userspace by a combination of
getxattr, lgetxattr, setxattr, lsetxattr, add_key, keyctl_read, and when all
else fails, open/open-NOFOLLOW + ioctl [IF not a dev file, and IF there are no
collisions between ioctl numbers and pioctl numbers].  In other words, a mess.

Now, assuming I do produce such a userspace library - that does not address
the other requirement: that of using a common set of binaries to manipulate
both OpenAFS and kAFS without the need for recompilation.  I presume you
advocate making OpenAFS change to suit your requirements?

David
