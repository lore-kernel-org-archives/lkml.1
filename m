Return-Path: <linux-kernel-owner+w=401wt.eu-S1767682AbXCJAV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767682AbXCJAV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767683AbXCJAV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:21:57 -0500
Received: from raven.upol.cz ([158.194.120.4]:62576 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767682AbXCJAVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:21:55 -0500
Date: Sat, 10 Mar 2007 01:31:41 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN (Re: [PATCH] Fix get_order())
Message-ID: <20070310003140.GC17084@flower.upol.cz>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org> <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower> <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org> <20070309231334.GB17084@flower.upol.cz> <Pine.LNX.4.64.0703091509180.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091509180.10832@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 03:15:10PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 10 Mar 2007, Oleg Verych wrote:
> > 
> > OTOH, if i would write it this way
> > 
> > #define BALIGN(x,bits)      ((((x) >> (bits)) + 1) << (bits))
> 
> But that's *wrong*. It aligns something that is *already* aligned to 
> something else.

Indeed. I'm confused by semantics of ALIGN macro, as from C arithmetic
side, as from using side. Former confusion also yields patches like
(Fix 'ALIGN()' macro, take 2), fixing that, i was wonder about.

BALIGN is like do-this alignment, and must be

    void do_align(what, bits)

instead. While clear arithmetic (optimized in assembler, shifts are
C shifts!), it fails in value(alignment(what, how)) kind of thing.

> So you'd have to do it as something like
> 
> 	#define ALIGN_TO_POW2(x,pow) \
> 		((((x)+(1<<(pow))-1)>>(pow))<<(pow))
>
> and the thing is, that's actually both (a) less readable than what ALIGN() 
> already does (b) unless the compiler notices that what you really want is 
> a "bitwise and", it's really inefficient too because shifts are generally 
> much more expensive than simple bitops.
> 
> So you're simply better off doing it as
> 
> 	#define ALIGN_TO_POW2(x,pow) ALIGN(x, (1ull << pow))
> 
> but then you'd still have to depend on the "typeof()" magic in ALIGN() to 
> turn the final end result back to the type of "x".
>
> (the "1ull" is necessary exactly because you don't know what type "x" is 
> beforehand, so you need to make sure that the mask is at *least* as big a 
> type as x, and not overflow to undefined C semantics).

Via typeof() *feature* and 1U, 1UL, 1ULL *things*, i (we?) have that, what
is described above.

Examples of using ALIGN. As that, i've picked earlier,

arch/powerpc/mm/hugetlbpage.c:                  addr = ALIGN(addr+1,1UL<<HTLB_AREA_SHIFT);
arch/powerpc/mm/hugetlbpage.c:                  addr = ALIGN(addr+1,1<<SID_SHIFT);

mixes two things, and i can't understand what is meant here,

lib/swiotlb.c:          io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
lib/swiotlb.c:          io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
lib/swiotlb.c:          io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);

clear "do align", etc.

So, maybe spitting "do align" (with C shifts, without C arithmetics
error-prone-due-to-C magic) and "alignment" isn't a bad idea.

Easiness is what i wanted to have. For example, like in this clean up,
'proper memory-mapped accesses rather than making up our own "volatile"
pointers' in 6c0ffb9d2fd987c79c6cbb81c3f3011c63749b1a. Clear C-vs-call()
rewrite.

Sorry, if i'm barking up the wrong tree here.
____
