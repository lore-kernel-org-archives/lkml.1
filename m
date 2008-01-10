Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYAJS3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYAJS3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYAJS3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:29:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219AbYAJS3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:29:37 -0500
Date: Thu, 10 Jan 2008 10:28:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199987366.5331.92.camel@cinder.waste.org>
Message-ID: <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>  <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>  <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>  <1199314218.4497.109.camel@cinder.waste.org> 
 <20080103085239.GA10813@elte.hu>  <1199378818.8274.25.camel@cinder.waste.org>  <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>  <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> 
 <1199641910.8215.28.camel@cinder.waste.org>  <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>  <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>  <1199919548.6245.74.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>  <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>  <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <1199987366.5331.92.camel@cinder.waste.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Matt Mackall wrote:
> > 
> > (I'm not a fan of slabs per se - I think all the constructor/destructor 
> > crap is just that: total crap - but the size/type binning is a big deal, 
> > and I think SLOB was naïve to think a pure first-fit makes any sense. Now 
> > you guys are size-binning by just two or three bins, and it seems to make 
> > a difference for some loads, but compared to SLUB/SLAB it's a total hack).
> 
> Here I'm going to differ with you. The premises of the SLAB concept
> (from the original paper) are: 

I really don't think we differ.

The advantage of slab was largely the binning by type. Everything else was 
just a big crock. SLUB does the binning better, by really just making the 
type binning be about what really matters - the *size* of the type.

So my argument was that the type/size binning makes sense (size more so 
than type), but the rest of the original Sun arguments for why slab was 
such a great idea were basically just the crap.

Hard type binning was a mistake (but needed by slab due to the idiotic 
notion that constructors/destructors are "good for caches" - bleargh). I 
suspect that hard size binning is a mistake too (ie there are probably 
cases where you do want to split unused bigger size areas), but the fact 
that all of our allocators are two-level (with the page allocator acting 
as a size-agnostic free space) may help it somewhat.

And yes, I do agree that any current allocator has problems with the big 
sizes that don't fit well into a page or two (like task_struct). That 
said, most of those don't have lots of allocations under many normal 
circumstances (even if there are uses that will really blow them up).

The *big* slab users at least for me tend to be ext3_inode_cache and 
dentry. Everything else is orders of magnitude less. And of the two bad 
ones, ext3_inode_cache is the bad one at 700+ bytes or whatever (resulting 
in ~10% fragmentation just due to the page thing, regardless of whether 
you use an order-0 or order-1 page allocation).

Of course, dentries fit better in a page (due to being smaller), but then 
the bigger number of dentries per page make it harder to actually free 
pages, so then you get fragmentation from that. Oh well. You can't win.

			Linus
