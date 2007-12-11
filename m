Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXLKVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXLKVh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXLKVht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:37:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45818 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXLKVhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:37:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18271.804.101490.729913@cargo.ozlabs.ibm.com>
Date: Wed, 12 Dec 2007 08:37:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][POWERPC] Provide a way to protect 4k subpages when using 64k pages
In-Reply-To: <20071211155305.GA28055@lst.de>
References: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
	<20071211155305.GA28055@lst.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

> As Arnd said reusing an old system call slot seems rather dangerous,
> I'd rather avoid it.

Sure.  I don't mind allocating a new syscall for this.

> But I wonder whether we really need a new
> syscall.  Using 4k pages should basically be a pre-process flag
> (which it already is as an implementation detail in your patch), and

Hmmm.  Ultimately I want to make it (the page size) be per-slice,
which shouldn't actually be particularly difficult.

> thus the proper way to mark it should be a personality flag.  This
> also means it could be implied by certain personalities, e.g. powerpc
> 32bit for full compatiblity.  

The 32-bit PowerPC ABI explicitly says that the kernel can use any
power-of-2 page size between 4kB and 64kB, so I don't see any need to
do 4k emulation for 32-bit processes.

> All these process would use plain mmap/
> mprotect to deal with the subpage protections.

It would be lovely if the generic VM code could handle multiple page
sizes, but it can't at the moment.  So I assume that you are talking
about intercepting mmap, mprotect, etc. in the powerpc arch code and
emulating 4k-granularity mmap/mprotect/mremap/munmap etc. using 64k
anonymous pages plus some sort of internal subpage protection map.

The difference between that and my scheme is that that puts more of
the logic into the kernel rather than the emulator.  Since it is only
specialized programs (such as x86 emulators) that need to emulate
4k-granularity mappings, I'd rather put most of that logic in
userspace rather than the kernel, and just have the part that only the
kernel can do (the subpage protections) implemented in the kernel.
If there was a more general need for 4k-granularity mappings then I
would agree with you, but I don't see that need at present.

> In fact the x86 emulation on ia64 already has some hacks for that in
> arch/ia64/ia32/sys_ia32.c, and it would be really useful if we could
> make both the interface and eventually the code implementing it generic.
> At least ia64 and mips have multiple pages sizes already and I suspect
> more architectures will grow support for it.

I don't see anything in arch/ia64/ia32/sys_ia32.c that can't be done
in userspace by an emulator.  As far as I can see, with that code, you
end up with the permissions on each ia64 page being the union of the
permissions on the 4k subpages, meaning that the program can access
subpages that it shouldn't really be able to access.  So I don't see
that sys_ia32.c addresses the problem that my patch is designed to
solve, namely, ensuring that an emulated program gets a SIGSEGV if it
tries to access subpages that it shouldn't be able to access.

Paul.
