Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXLMUt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXLMUt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763741AbXLMUtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:49:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:44726 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763808AbXLMUtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:49:14 -0500
Subject: Re: What was the problem with quicklists and x86-64?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>
	 <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 07:47:56 +1100
Message-Id: <1197578876.15741.163.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 11:47 -0800, Christoph Lameter wrote:
> On Wed, 12 Dec 2007, Jeremy Fitzhardinge wrote:
> 
> > I'm looking at unifying the various pgalloc+pgd_lists mechanisms between
> > 32-bit (PAE and non-PAE) and 64-bit, so I'm trying to understand why
> > these differences exist in the first place.
> > 
> > Change da8f153e51290e7438ba7da66234a864e5d3e1c1 reverted the use of
> > quicklists for allocating pagetables, because of concerns about ordering
> > with respect to tlb flushes.
> 
> These issues only exist with NUMA because of the freeing of off node pages 
> before the TLB flush was done. There was a discussion about this issue and 
> my fix of simply not freeing the offnode pages early was ignored. Instead 
> the x86_64 implementation (which has no problems that I know of) was 
> pulled leaving the issue open in the core. Benjamin Herrrenschmidt 
> wanted to take a look at these issues (CCing him).

I don't know how NUMA gets in the picture there, it's probably very x86
specific thing. The issue we have here happens on other platforms
unrelated to NUMA. The fact that is tired to NUMA on x86 might be due to
the way the HW tablewalk operates on these. 

Essentially the problem is a processor walking the page table tree
(either in HW or in SW, but both without any lock) vs. freeing them.

The risk is that if we just clear the PMD entry (or any other level in
fact) and then right away free the PTE page (or any other page level) in
such a way that it can be re-used by something else pretty much
immediately, we have a race where the other processor might have started
to walk the page table tree, sampled the "old" PMD value, and then
starts accessing the PTE page that have been freed or even worse,
re-used.

The race is very hard to trigger, it will mostly happen on very out of
order architectures (such as powerpc) and you'd have to hammer addresses
that you are just unmapping (with is not something that happens in
practice), but it's been seen and can cause very bad results. 

The solution we use on powerpc to avoid it is to defer all page table
page freeing using RCU, since the part that walks the page table is SW
in the hash miss handler. On x86, the IPI & flush after clearing the PMD
entry and before freeing the page guarantees also that no other CPU is
still walking the thing with the old PMD value.

Ben.


