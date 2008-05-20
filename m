Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbYETSg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbYETSg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYETSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:36:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759597AbYETSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:36:14 -0400
Date: Tue, 20 May 2008 11:34:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
In-Reply-To: <4832D65C.2030108@goop.org>
Message-ID: <alpine.LFD.1.10.0805201116590.3081@woody.linux-foundation.org>
References: <patchbomb.1211268376@localhost> <Pine.LNX.4.64.0805201346120.24102@blonde.site> <4832D65C.2030108@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Jeremy Fitzhardinge wrote:

> Hugh Dickins wrote:
> > I'll leave it to you and Linus whether your way of defining PTE_MASK is
> > satisfactory as is, or needs to be improved to his way.  I've not tried
> > his suggestion of doing the _PAGE_BIT definitions: certainly it's
> > seemed odd to me that they were defined with L, but I've little
> > appetite to mess around with them now myself.
> 
> Yes, well, that was me too, with the intention of making ~_PAGE_FOO generate
> an appropriately sized mask.  I guess it would be better to use pteval_t these
> days.

The thing is, making _PAGE_FOO be a signed long in no way guarantees any 
appropriately sized masks.

Why? Because 'long' mixes with 'unsigned long' and in the C type system, 
unsigned is stronger than signed.

As a result, if you depend on sign-extension of things like a binary 'not' 
operation, you're always going to have cases where it simply doesn't work, 
just because you happen to mix it up with other things that may have type 
'unsigned long' (or, on 32-bit, 'unsigned int' which has the same size: 
the 'unsigned' is so strong that it will convert to 'long' because it has 
the same size.

Try this one in a 32-bit environment:

	/*
	 * 'A' is the low bits mask - and explicitly signed so
	 * that you can do '~A' to get the high bits of a PTE
	 */
	#define A 0xfffl

	/*
	 * Some random value that just happens to be unsigned for other 
	 * reasons - perhaps it's a sizeof expression or whatever.
	 */
	#define B 5U

	int main(int argc, char **argv)
	{
	        unsigned long long pte;

	        pte = B | ~A;
	        printf("%llx\n", pte);

	        pte = ~A;
	        pte |= B;
	        printf("%llx\n", pte);

	        pte = B;
	        pte |= ~A;
	        printf("%llx\n", pte);
	}

and see what it generates. It does the EXACT SAME thing in all three 
cases: the expression is "B | ~A" in various guises, but they are not the 
same values because the order of the type expansion matters. Note how in 
one case the sign bits of the binary not did *not* percolate up to the 
upper 32 bits.

So making something signed and just assuming that it means that when it is 
expanded to a bigger type the bits will always be set is simply not true. 
It's *often* true, but it's untrue in many trivial cases. 

If you want the upper bits to behave reliably in a bigger type, then you 
have to actually make the values *be* of that type.

Or do people really want to live with a kernel where 

	pte = B | ~A;

is different from

	pte = B;
	pte |= ~A;

and making the "obvious" simplification will just generate a totaly 
different result?

I don't think we want to continue to rely on that kind of subtle C type 
tricks, especially since we know they haven't worked (ie we had this 
*exact* issue with mixing in PAGE_MASK that happened to be unsigned, and 
changed all the arithmetic for the signed longs that depended on sign 
extensions to bigger types).

Obviously, we could just choose to make *everything* be of a signed type, 
but we know that doesn't work very well, and it interacts badly with 
things like right-shifting (which we do quite a lot on the things 
involved: we extract fields like the PFN with a right shift and a mask).

			Linus
