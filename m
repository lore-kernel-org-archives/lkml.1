Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbXENRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbXENRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXENRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:41:08 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:39517 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbXENRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:41:07 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
	 <20070514161224.GC11115@waste.org>
	 <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 19:40:52 +0200
Message-Id: <1179164453.2942.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 09:29 -0700, Christoph Lameter wrote:
> On Mon, 14 May 2007, Matt Mackall wrote:
> 
> > privileged thread                      unprivileged greedy process
> > kmem_cache_alloc(...)
> >    adds new slab page from lowmem pool
> 
> Yes but it returns an object for the privileged thread. Is that not 
> enough?

No, because we reserved memory for n objects, and like matt illustrates
most of those that will be eaten by the greedy process.

We could reserve 1 page per object but that rather bloats the reserve.

> > do_io()
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        kmem_cache_alloc(...)
> >                                        ...
> >                                           eats it all
> > kmem_cache_alloc(...) -> ENOMEM
> >    who ate my donuts?!
> > 
> > But I think this solution is somehow overkill. If we only care about
> > this issue in the OOM avoidance case, then our rank reduces to a
> > boolean.

I tried to slim it down to a two state affair; but last time I tried
performance runs that actually slowed it down some.

