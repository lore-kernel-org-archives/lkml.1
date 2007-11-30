Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXK3WgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXK3WgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbXK3WgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:36:09 -0500
Received: from waste.org ([66.93.16.53]:46127 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbXK3WgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:36:07 -0500
Date: Fri, 30 Nov 2007 16:35:37 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Allan Stephens <allan.stephens@windriver.com>,
       Jon Paul Maloy <jon.maloy@ericsson.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [bug] SLOB, tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
Message-ID: <20071130223537.GT19691@waste.org>
References: <20071129142546.GA27719@elte.hu> <20071129143920.GA32146@elte.hu> <20071129213217.GW19691@waste.org> <20071130091418.GA2201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130091418.GA2201@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 10:14:18AM +0100, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > plus, and this is a slob question i guess, how come we drop into 
> > > clear_highpage() for a kzalloc()??
> > 
> > Good question. Looks like kzalloc switched from doing a memset to
> > passing a GFP_ZERO flag down to kmalloc. Slob didn't get completely
> > updated to reflect this, so it blindly propagates the flag onto
> > __alloc_pages and does a harmless double-clear.
> > 
> > Someone should remind us what the point of moving the kzalloc memset
> > down into the allocators was. We now have all three allocators doing:
> > 
> >         if (unlikely((flags & __GFP_ZERO) && ptr))
> >                 memset(ptr, 0, obj_size(cachep));
> > 
> > and needing to mask flags before passing them to page allocators,
> > which hardly seems better than kzalloc unconditionally doing the
> > memset. Wouldn't it be better/faster/smaller to make kzalloc a
> > non-inline?
> > 
> > Slob also has a nice second path for large kmallocs where it just 
> > calls the page allocator directly which also needs this treatment. 
> > Which does the right thing with non-highmem systems, but can hit this 
> > bug otherwise.
> > 
> > Below is a totally untested patch. Alternately, we could simply tweak 
> > clear_highpage to remove the limitation, but that would leave slob 
> > doing an extra clear.
> 
> ok, this fixes the debug warning.
> 

But the question remains: is this the right fix? The commit in
question is here:

http://www.kernel.org/hg/linux-2.6/rev/13683609d67a

Christoph, remind us what's the upside here? It seems to me it would
be better to have separate non-inline kzalloc and kcalloc functions
that did the memset instead.

Another smaller open question is whether we want to remove the
in_interrupt restriction from clear_pagehigh.

-- 
Mathematics is the supreme nostalgia of our time.
