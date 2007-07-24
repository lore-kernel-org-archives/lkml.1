Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXGXGWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXGXGWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXGXGWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:22:31 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:39793 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbXGXGWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:22:30 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 11:53:50 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory
 addresses
In-Reply-To: <46A57DCB.7050609@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707241115120.1433@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
 <46A57DCB.7050609@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> Linus Torvalds wrote:
> > 
> > On Mon, 23 Jul 2007, Satyam Sharma wrote:
> > 
> > 
> > > [4/8] i386: bitops: Kill volatile-casting of memory addresses
> > 
> > 
> > This is wrong.
> > 
> > The "const volatile" is so that you can pass an arbitrary pointer. The only
> > kind of abritraty pointer is "const volatile".
> > 
> > In other words, the "volatile" has nothing at all to do with whether the
> > memory is volatile or not (the same way "const" has nothing to do with it:
> > it's purely a C type *safety* issue, exactly the same way "const" is a type
> > safety issue.
> > 
> > A "const" on a pointer doesn't mean that the thing it points to cannot
> > change. When you pass a source pointer to "strlen()", it doesn't have to be
> > constant. But "strlen()" takes a "const" pointer, because it work son
> > constant pointers *too*.
> > 
> > Same deal here.
> > 
> > Admittedly this may be mostly historic, but regardless - the "volatiles" are
> > right.
> > 
> > Using volatile on *data* is generally considered incorrect and bad taste,
> > but using it in situations like this potentially makes sense.
> > 
> > Of course, if we remove all "volatiles" in data in the kernel (with the
> > possible exception of "jiffies"), we can then remove them from function
> > declarations too, but it should be done in that order.
> 
> Well, regardless, it still forces the function to treat the pointer
> target as volatile, won't it? It definitely prevents valid optimisations
> that would be useful for me in mm/page_alloc.c where page flags are
> being set up or torn down or checked with non-atomic bitops.

Yes, and yes. But I think what he meant there is that we'd need to
audit the kernel for all users of set_bit and friends and see if callers
actually pass in any _data_ that _is_ volatile. So we have to kill them
there first, and then in the function declarations here. I think I'll put
that on my long-term todo list, but see below.

> Anyway by type safety, do you mean it will stop the compiler from
> warning if a pointer to a volatile is passed to the bitop?

The compiler would start warning for all those cases (passing in
a pointer to volatile data, when the bitops have lost the volatile
casting from their function declarations), actually. Something like
"passing argument discards qualifiers from pointer type" ... but
considering I didn't see *any* of those warnings after these patches,
I'm confused as to what exactly Linus meant here ... and what exactly
do we need to do "kill the volatiles".

> If so, then
> why don't we just kill all the volatiles out of here and fix any
> warnings that comeup? I doubt there would be many, and of those, some
> might show up real synchronisation problems.

Yes, but see above.

> OK, not the i386 functions as much because they are all in asm anwyay,
> but in general (btw. why does i386 or any architecture define their own
> non-atomic bitops? If the version in asm-generic/bitops/non-atomic.h
> is not good enough then surely it is a bug in gcc or that file?)



Satyam
