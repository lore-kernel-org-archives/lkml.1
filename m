Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbXH0Su0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbXH0Su0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXH0SuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:50:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59721 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752720AbXH0SuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:50:12 -0400
Date: Mon, 27 Aug 2007 11:50:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 0/6] Per cpu structures for SLUB
In-Reply-To: <20070824143848.a1ecb6bc.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708271144440.4667@schroedinger.engr.sgi.com>
References: <20070823064653.081843729@sgi.com> <20070824143848.a1ecb6bc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Andrew Morton wrote:

> I'm struggling a bit to understand these numbers.  Bigger is better, I
> assume?  In what units are these numbers?

No less is better. These are cycle counts. Hmmm... We discussed these 
cycle counts so much in the last week that I forgot to mention that.

> > Page allocator pass through
> > ---------------------------
> > There is a significant difference in the columns marked with a * because
> > of the way that allocations for page sized objects are handled.
> 
> OK, but what happened to the third pair of columns (Concurrent Alloc,
> Kmalloc) for 1024 and 2048-byte allocations?  They seem to have become
> significantly slower?

There is a significant performance increase there. That is the main point 
of the patch.

> Thanks for running the numbers, but it's still a bit hard to work out
> whether these changes are an aggregate benefit?

There is a drawback because of the additional code introduced in the fast 
path. However, the regular kmalloc case shows improvements throughout. 
This is in particular of importance for SMP systems. We see an improvement 
even for 2 processors.

> > If we handle
> > the allocations in the slab allocator (Norm) then the alloc free tests
> > results are superb since we can use the per cpu slab to just pass a pointer
> > back and forth. The page allocator pass through (PCPU) shows that the page
> > allocator may have problems with giving back the same page after a free.
> > Or there something else in the page allocator that creates significant
> > overhead compared to slab. Needs to be checked out I guess.
> > 
> > However, the page allocator pass through is a win in the other cases
> > since we can cut out the page allocator overhead. That is the more typical
> > load of allocating a sequence of objects and we should optimize for that.
> > 
> > (+ = Must be some cache artifact here or code crossing a TLB boundary.
> > The result is reproducable)
> > 
> 
> Most Linux machines are uniprocessor.  We should keep an eye on what effect
> a change like this has on code size and performance for CONFIG_SMP=n
> builds..

There is an #ifdef around ther per cpu structure management code. All of 
this will vanish (including the lookup of the per cpu address from the 
fast path) if SMP is off.

