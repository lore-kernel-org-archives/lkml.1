Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXEQH2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXEQH2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXEQH2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:28:47 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:8198 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754394AbXEQH2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:28:46 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705161435110.11642@schroedinger.engr.sgi.com>
References: <1179350433.2912.66.camel@lappy>
	 <Pine.LNX.4.64.0705161435110.11642@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 09:28:41 +0200
Message-Id: <1179386921.27354.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 14:42 -0700, Christoph Lameter wrote:
> On Wed, 16 May 2007, Peter Zijlstra wrote:
> 
> > > Hmmm.. so we could simplify the scheme by storing the last rank 
> > > somewheres.
> > 
> > Not sure how that would help..
> 
> One does not have a way of determining the current processes
> priority? Just need to do an alloc?

We need that alloc anyway, to gauge the current memory pressure.
Sure you could perhaps not do that for allocations are are entitled to
the reserve if we still have on; but I'm not sure that is worth the
bother.

> If we had the current processes "rank" then we could simply compare.
> If rank is okay give them the object. If not try to extend slab. If that
> succeeds clear the rank. If extending fails fail the alloc. There would be 
> no need for a reserve slab.
> 
> What worries me about this whole thing is
> 
> 
> 1. It is designed to fail an allocation rather than guarantee that all 
>    succeed. Is it not possible to figure out which processes are not 
>    essential and simply put them to sleep until the situation clear up?

Well, that is currently not done either (in as far as that __GFP_WAIT
doesn't sleep indefinitely). When you run very low on memory, some
allocations just need to fail, there is nothing very magical about that,
the system seems to cope just fine. It happens today.

Disable the __GFP_NOWARN logic and create a swap storm, see what
happens.

> 2. It seems to be based on global ordering of allocations which is
>    not possible given large systems and the relativistic constraints
>    of physics. Ordering of events get more expensive the bigger the
>    system is.
> 
>    How does this system work if you can just order events within
>    a processor? Or within a node? Within a zone?

/me fails again..

Its about ensuring ALLOC_NO_WATERMARKS memory only reaches PF_MEMALLOC
processes, not joe random's pi calculator.

> 3. I do not see how this integrates with other allocation constraints:
>    DMA constraints, cpuset constraints, memory node constraints,
>    GFP_THISNODE, MEMALLOC, GFP_HIGH.

It works exactly as it used to; if you can currently get out of a swap
storm you still can.

