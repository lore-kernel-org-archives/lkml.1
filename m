Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZAJMa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZAJMa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZAJMaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:30:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZAJMaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:30:16 -0500
Date: Sat, 10 Jan 2009 13:29:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       andi@firstfloor.org, ak@linux.intel.com, cl@linux-foundation.org,
       rth@twiddle.net, sfr@canb.auug.org.au, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
Message-ID: <20090110122945.GA28033@elte.hu>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org> <200901102211.45603.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901102211.45603.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Saturday 10 January 2009 11:10:53 akpm@linux-foundation.org wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> ...
> > + * This is needed because the C standard makes it undefined to do
> > + * pointer arithmetic on "objects" outside their boundaries and the
> > + * gcc optimizers assume this is the case. In particular they
> > + * assume such arithmetic does not wrap.

that is a rather useless comment without real examples.

> ...
>
> That last sentence seems misleading to me; the case I know of gcc 
> hurting us is the powerpc literal strcpy case.  See prom_init.c where 
> vars are not yet mapped at KERNEL_BASE, so they offset them manually: 
> gcc turned a strcpy(dest, "literal"+KERNEL_BASE) into memcpy(dest, 
> "literal"+KERNEL_BASE, 7-KERNEL_BASE).  Boom.
> 
> Richard came up with the RELOC_HIDE macro, to future-proof against other 
> such optimizations.  I can't remember if I was clever enough to use it 
> for per-cpu on my own, or whether he pointed it out.
> 
> I hope that clarifies once and for all!

Note that 32-bit x86 lived just fine for years without RELOC_HIDE() - and 
it has similar large-offset pointer arithmetics both for PAGE_OFFSET and 
for per-cpu accesses.

The obscurity and undocumentedness of RELOC_HIDE() turned it a bit of a 
voodoo programming construct: it got introduced due to unspecified fear 
but there's no real documented specifics of actual GCC breakage caused by 
it in the field, other than a constant string put into a percpu area - 
which is pretty stupid to do to begin with.

So it's a bit of a mystery construct, and if we add a comment, here are a 
few examples that brings the above textbook definition closer to reality, 
examples of what GCC _could_ do and how it could break without RELOC_HIDE 
- and this might be much more useful for the commit log than the obscure 
C-lawyering paragraph above:

1) String operations

 For example if we do something like:

        strcpy(tmp, "abc" + LARGE_OFFSET)

 GCC could assume that "abc" is a 4 bytes long string, and could assume 
 that LARGE_OFFSET points within it, and could optimize this into:

	memcpy(tmp, "abc" + LARGE_OFFSET, 4 - LARGE_OFFSET)

 [ This is a bit far-fetched, as it would need us to put constant strings 
   into PER_CPU areas - but it's not actually wrong to do it so if it 
   happens it's nasty. OTOH, very clear crashes will point to it, so not 
   really relevant. ]

2) Special structure sizes

 For example we want to load a value from "&var + LARGE_OFFSET" (common 
 percpu construct). If 'var' is a C structure that happens to have a size 
 of 255 bytes, then GCC could legitimately assume that 'LARGE_OFFSET' is 
 0..255 [inclusive], and could optimize LARGE_OFFSET to be truncated to a 
 single byte.

3) Memory object aliasing, alias analysis

 A "bad" aliasing optimization happens when GCC detects that a %gs 
 referenced and a kernel linear pointer has the same value - and thus 
 mis-optimizes it assuming that already loaded values must be the same. 

 [ does not really happen as both in the current and in the zerobased case 
   the two memory spaces are clearly separated. ]

 Or if GCC does not recognize that aliased accesses to the same object 
 involve the same object - and optimizes things assuming that it's two 
 separate objects - and could schedule instructions in a mixed up way, 
 corrupting the object.

 Not a real issue either here: the %gs space is very separate from the 
 kernel linear address space, we never access the same object via two
 similar-looking pointers at once. We just set up the percpu area and
 leave those linear addresses alone.

But RELOC_HIDE() does not actually _prevent_ any useful optimizations from 
being done - so it does not really hurt. But the comment added by this 
patch is rather misleading as it's formulated way too generic way without 
pointing out the obscurity of these cases, and thus hurts the end result 
more than it helps.

	Ingo

