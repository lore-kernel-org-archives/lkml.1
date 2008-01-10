Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYAJQOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYAJQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAJQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:14:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633AbYAJQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:14:38 -0500
Date: Thu, 10 Jan 2008 08:13:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
Message-ID: <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>  <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>  <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>  <1199314218.4497.109.camel@cinder.waste.org> 
 <20080103085239.GA10813@elte.hu>  <1199378818.8274.25.camel@cinder.waste.org>  <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>  <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> 
 <1199641910.8215.28.camel@cinder.waste.org>  <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>  <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org>
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Pekka J Enberg wrote:
> 
> We probably don't have the same version of GCC which perhaps affects 
> memory layout (struct sizes) and thus allocation patterns?

No, struct sizes will not change with compiler versions - that would 
create binary incompatibilities for libraries etc.

So apart from the kernel itself working around some old gcc bugs by making 
spinlocks have different size depending on the compiler version, sizes of 
structures should be the same (as long as the configuration is the same, 
of course).

However, a greedy first-fit allocator will be *very* sensitive to 
allocation pattern differences, so timing will probably make a big 
difference. In contrast, SLUB and SLAB both use fixed sizes per allocation 
queue, which makes them almost totally impervious to any allocation 
pattern from different allocation sizes (they still end up caring about 
the pattern *within* one size, but those tend to be much stabler).

There really is a reason why traditional heaps with first-fit are almost 
never used for any real loads.

(I'm not a fan of slabs per se - I think all the constructor/destructor 
crap is just that: total crap - but the size/type binning is a big deal, 
and I think SLOB was naïve to think a pure first-fit makes any sense. Now 
you guys are size-binning by just two or three bins, and it seems to make 
a difference for some loads, but compared to SLUB/SLAB it's a total hack).

I would suggest that if you guys are really serious about memory use, try 
to do a size-based heap thing, and do best-fit in that heap. Or just some 
really simple size-based binning, eg

	if (size > 2*PAGE_SIZE)
		goto page_allocator;
	bin = lookup_bin[(size+31) >> 5];

or whatever. Because first-fit is *known* to be bad.

At try to change it to address-ordered first-fit or something (which is 
much more complex than just plain LIFO, but hey, that's life).

I haven't checked much, but I *think* SLOB is just basic first-fit 
(perhaps the "next-fit" variation?) Next-fit is known to be EVEN WORSE 
than the simple first-fit when it comes to fragmentation (so no, Knuth was 
not always right - let's face it, much of Knuth is simply outdated).

			Linus
