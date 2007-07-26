Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXGZBH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXGZBH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXGZBHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:07:19 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:53466 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXGZBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:07:17 -0400
Date: Wed, 25 Jul 2007 18:07:15 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0707251731370.30561@shell4.speakeasy.net>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Linus Torvalds wrote:
> On Tue, 24 Jul 2007, Trent Piepho wrote:
> >
> > Speaking of that, why are all the asm functions in arch/i386/lib/string.c
> > defined as having a memory clobber, even those which don't modify memory
> > like strcmp, strchr, strlen and so on?
>
> That's because the memory clobber will serialize the inline asm with
> anything else that reads or writes memory.
>
> So even if we don't actually change any memory, if we cannot describe what
> we *read*, then we need to tell gcc to not re-order us wrt things that
> could *write*. And the simplest way to do that is to say that you clobber
> memory, even if you don't.

I went a made a test suite to see what really happened, and this isn't how
it works.  It appears that a memory clobber only tells gcc that the asm
writes to memory.  It does _not_ tell gcc that the asm reads from memory.

It's at http://www.speakeasy.org/~xyzzy/download/opttest.tar.gz
It's only 3k, but there are 16 files so I'm not inlining it.

The suite has a few test c files, which are compiled with various different
functions, inline norm asm, inline volatile asm, inline asm with a memory
clobber, a normal function, a __attribute__((const)) function, and so on.

They are compiled to asm file, and then a perl script scans the asm files to
figure out what optimizations gcc made.

"make test" will compile all the tests and run them through the perl scripts.
"make test1" will just run test1, etc.

It appears that a normal asm, one without volatile or a memory clobber, is
treated like a const function, which returns the output via a struct (not
using pass-by-address).  It has no side-effects, can't read or write global
variables, and can't dereference pointer arguments.

Adding volatile tells gcc the asm has some hidden side-effect.  It still can't
r/w globals or dereference inputs.  But it won't get elided if there are no
used outputs, common subexpression merged, or treated as a loop invariant.

Adding a memory clobber tells gcc that the asm modifies memory.  It doesn't
modify un-aliased local variables in registers.  It does modify aliased local
variables.  It does not read from memory.  gcc will move or elide a memory
write before an asm with a memory clobber if nothing else (besides the asm)
could see the write.  A memory clobber doesn't count as a side-effect either,
a non-volatile asm without unused outputs will be elided, even if has a memory
clobber.

Specifically, check test6_memasm.s.  The C code looks like this:

extern int a; /* keep asm from being elided for having no used output */
static inline void bar(void) { asm("call bar" : "=m"(a) : : "memory"); }
/* float x can't alias asm's output int a */
void foo(float *x) { x[20] = 1; bar(); x[20] = 2; }

The asm code ends up like this:
foo:
        call bar
        movl    4(%esp), %eax   # x, x
        movl    $0x40000000, 80(%eax)   #,
        ret

Notice that the first write to x[20] was NOT done.  It's also not done for a
volatile asm without a memory clobber.  But if you combine both volatile and a
memory clobber, then it is!  How to explain that?

The difference between test2_volasm.s and test2_normasm.s is hard to explain
too.  It seems like some times gcc forgets that imull is commutative.  It will
emit "imull %edx, %eax" in some cases, but change an asm slightly and it will
decide it must do "imull %eax, %edx ; movl %edx, %eax" for no apparent reason.
