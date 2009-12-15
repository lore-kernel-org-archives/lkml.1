Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbZLOKxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbZLOKxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZLOKxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZLOKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:53:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091215004143.GA15785@shareable.org>
References: <20091215004143.GA15785@shareable.org> <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> <20091210135816.6325.37536.stgit@warthog.procyon.org.uk>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: dhowells@redhat.com, stefani@seibold.net, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com
Subject: Re: [uClinux-dev] [PATCH 5/7] NOMMU: Avoiding duplicate icache flushes of shared maps
Date: Tue, 15 Dec 2009 10:52:46 +0000
Message-ID: <24260.1260874366@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier <jamie@shareable.org> wrote:

> This looks like it won't work in the following sequence:
> 
>     process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
>     process B maps MAP_SHARED, PROT_READ|PROT_WRITE
>         and proceeds to modify the data
>     process C maps MAP_SHARED, PROT_READ|PROT_EXEC (no icache flush)

Assuming all the above refer to the same piece of RAM, there's no reason that
process A will will continue to function correctly executing from the first
mapping if process B writes to that RAM through the second mapping.

There's also no point doing an icache flush unless you first flush the dcache
back to the RAM - and we don't know to do that because the O/S does not know
whether the RAM has been changed.  So we'd have to do an unconditional dcache
flush too for the entire RAM segment.

I'd prefer to leave this to the writers.  If they're mad enough to write
shared code that undergoes runtime modification, and then want to run it on
NOMMU...

So my question back to you is: would it work anyway?

Note that some arches have a specific cache flushing system call.  Perhaps
this should be extended to all.

> What about icache flushes in these cases:
> 
> When using mprotect() PROT_READ|PROT_WRITE -> PROT_READ|PROT_EXEC,
> e.g. as an FDPIC implementation may do when updating PLT entries.

There is no mprotect() on NOMMU, at least not at the moment.  It may be
reasonable to add support for someone turning on/off the PROT_EXEC and
PROT_WRITE bits, and make it flush dcache to RAM when WRITE is turned off, and
flush the icache when EXEC is turned on, in that order.

However, as Mike said, we don't do this in FDPIC.  The code sections are
immutable blobs, and are mapped MAP_PRIVATE, PROT_READ|PROT_EXEC from the
start.  That way, mmap() will share them for us and even do XIP without special
support in userspace.  FDPIC uses a non-executable GOT in the data area, and
loads the function pointer and new GOT pointer out of it before making a call.

> And when calling msync(), like this:
> 
>     process A maps MAP_SHARED, PROT_READ|PROT_EXEC (flushes icache)
>     process B maps MAP_SHARED, PROT_READ|PROT_WRITE
>         and proceeds to modify the data
>     process A calls msync()
>         and proceeds to execute the modified contents

Similarly, we don't provide msync().  On NOMMU, memory mappings cannot be
shared from disks that aren't based direct-access (quasi-)memory (e.g. ramfs,
MTD).

We could, perhaps, partially implement msync() to flush the appropriate caches.
We might even be able to add extra flags to msync() so that it can flush just
the CPU caches - that would obviate the need for separate syscalls for this
purpose.

> Do you think the mprotect() and msync() calls should flush icache in
> those cases?

I don't see that msync() should flush the icache at all.  It's purpose is to
flush data to the backing store.

Also, don't forget that under NOMMU conditions, you have no idea if the data
has been modified.

> But in the first example above, I don't see how process C could be
> expected to know it must flush icache, and process B could just be an
> "optimised with writable mmap" file copy, so it shouldn't have
> responsibility for icache either.

It's manually executing off of a MAP_SHARED region, a region that others have
open for write.  It has to look after its own semantics.  This applied too to
process A.

> If seen arguments for it, and arguments that the executing process can
> be expected to explicitly flush icache itself in those cases because
> it knows what it is doing.  (Personally I lean towards the kernel
> should be doing it.  IRIX interestingly offers both alternatives, with
> a PROT_EXEC_NOFLUSH).

I disagree, at least in the case of MAP_SHARED regions.  You need to manage
your own coherency.  Again, see process A vs process B.

> Or is icache fully flushed on every context switch on all nommu
> architectures anyway, and defined to do so?

That would be a sure performance killer, and, in any case, wouldn't help on an
SMP system.

David
