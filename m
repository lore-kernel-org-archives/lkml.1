Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZFZIvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZFZIvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZFZIva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:51:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:52068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbZFZIv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:51:29 -0400
Date: Fri, 26 Jun 2009 10:51:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090626085130.GB12201@wotan.suse.de>
References: <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain> <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 01:22:25PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 25 Jun 2009, Linus Torvalds wrote:
> > 
> > Whether these are important to you or not, I dunno. I actually suspect 
> > that we might want a combination of "high priority + allow memory 
> > freeing", which would be
> > 
> > 	#define GFP_CRITICAL (__GFP_HIGH | __GFP_WAIT)
> 
> Actually, that doesn't work quite the way I intended.
> 
> The current page allocator screws up, and doesn't allow us to do this 

No I think it works OK. As designed, at least (whether or not
you agree with the design :P)


> (well, you _can_ combine the flags, but they don't mean what they mean on 
> their own). If you have the WAIT flag set, the page allocator will not set 
> the ALLOC_HARDER bit,

But it does use ALLOC_HIGH.


> so it turns out that GFP_ATOMIC (__GFP_HIGH on its 
> own) sometimes actually allows more allocations than the above 
> GFP_CRITICAL would.

Yes. The intention was to allow allocations from sleepable/reclaimable
context but not allow them to use up all the reserves allowed for
atomic context (so you don't suddenly get bursts of atomic allocation
failure warnings on your network card when under heavy disk IO, for
example).

 
> It might make more sense to make a __GFP_WAIT allocation set the 
> ALLOC_HARDER bit _if_ it repeats. The problem with doing a loop of 
> allocations outside of the page allocator is that you then miss the 
> subtlety of "try increasingly harder" that the page allocator internally 
> does (well, right now, the "increasingly harder" only exists for the 
> try-to-free path, but we could certainly have it for the try-to-allocate 
> side too)
