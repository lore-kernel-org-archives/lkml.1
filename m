Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYC1SkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYC1SkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYC1Sj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:39:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48940 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbYC1Sj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:39:56 -0400
Date: Fri, 28 Mar 2008 11:37:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803281133190.17805@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl> 
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
 <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Linus Torvalds wrote:

> The bug was that the commit I made (which was correct and robust) was then 
> partially reverted by Christoph for no good reason. At that point, 
> kmalloc_large() didn't even exist, so at that point the change was 
> "technically correct" (since the only user of gfpflags really did end up 
> clearing it somewhere deep in its callchain).

That commit cleared a flag that was cleared later anyways....

> So the fact is, commit 3811dbf67162bd08412f1b0e02e554f353e93bdb is and was 
> total and utter crap. I've reverted it in my tree. It's crap not because 
> it was buggy when it was put in, but because it was *fragile* when it was 
> put in. And that fragility ended up causing a bug later.

Do we have confirmation that the revert actually does something? It 
certainly does not address the issues with inline page forwarding. And why 
are we forbidding page allocator allocs with __GFP_ZERO in interrupt 
context? Only __GFP_HIGHMEM needs kmap and only __GFP_HIGHMEM can cause 
trouble.

> I'm getting really tired of slub. It was supposed to be simpler code than 
> slab, and yes, it's simpler, but it has been buggy as hell, and part of it 
> has been that people just haven't been careful enough, and haven't written 
> code to be defensive and easy-to-follow.

You may want to check SLAB recent bug list. There is still crap over there 
as well and AFAICT this is more severe than SLUB and its inherent in the 
complex scheme that we had to put in ther.
 
> So the *last* thing we want to do is to clear GFP_ZERO in multiple subtle 
> places based on new random code being added. We want to clear it at the 
> top level, so that no other code never ever even has to _think_ about it!

__GFP_ZERO is cleared in one place when new_slab() calls allocate_slab(). 
The fallback code in 2.6.25 will go away in 2.6.26.


