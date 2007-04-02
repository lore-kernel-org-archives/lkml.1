Return-Path: <linux-kernel-owner+w=401wt.eu-S965942AbXDBVWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965942AbXDBVWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965941AbXDBVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:22:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35946 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbXDBVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:22:10 -0400
Subject: Re: [PATCH 1/2] Generic Virtual Memmap suport for SPARSEMEM
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704021351590.1224@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
	 <1175547000.22373.89.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021351590.1224@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:22:04 -0700
Message-Id: <1175548924.22373.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 14:00 -0700, Christoph Lameter wrote:
> On Mon, 2 Apr 2007, Dave Hansen wrote:
> > > +	} else
> > > +		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> > > +					__pa(MAX_DMA_ADDRESS));
> > > +}
> > 
> > Hmmmmmmm.  Can we combine this with sparse_index_alloc()?  Also, why not
> > just use the slab for this?
> 
> Use a slab for page sized allocations? No.

Why not?  We use it above for sparse_index_alloc() and if it is doing
something wrong, I'd love to fix it.  Can you elaborate?

> > Let's get rid of the _block() part, too.  I'm not sure it does any good.
> > At least make it _bytes() so that we know what the units are.  Also, if
> > you're just going to round up internally and _not_ use the slab, can you
> > just make the argument in pages, or even order?
> 
> Its used for page sized allocations.

Ok, then let's make it take pages of some kind or its argument.  

> > Can you think of any times when we'd want that BUG_ON() to be a
> > WARN_ON(), instead?  I can see preferring having my mem_map[] on the
> > wrong node than hitting a BUG().
> 
> We should probably have some error handling there instead of the BUG.
> 
> > > +#ifndef ARCH_POPULATES_VIRTUAL_MEMMAP
> > > +/*
> > > + * Virtual memmap populate functionality for architectures that support
> > > + * PMDs for huge pages like i386, x86_64 etc.
> > > + */
> > 
> > How about:
> > 
> > /*
> >  * Virtual memmap support for architectures that use Linux pagetables
> >  * natively in hardware, and support mapping huge pages with PMD
> >  * entries.
> >  */
> > 
> > It wouldn't make sense to map the vmemmap area with Linux pagetables on
> > an arch that didn't use them in hardware, right?  So, perhaps this
> > doesn't quite belong in mm/sparse.c.  Perhaps we need
> > arch/x86/sparse.c. ;)
> 
> I just extended this in V2 to also work on IA64. Its pretty generic.

Can you extend it to work on ppc? ;)

You haven't posted V2, right?

> > 
> >          map = alloc_remap(nid, sizeof(struct page) * PAGES_PER_SECTION);
> >          if (map)
> >                  return map;
> > 
> > +        map = alloc_vmemmap(map, PAGES_PER_SECTION, nid);
> > +        if (map)
> > +                return map;
> > +
> >          map = alloc_bootmem_node(NODE_DATA(nid),
> >                          sizeof(struct page) * PAGES_PER_SECTION);
> >          if (map)
> >                  return map;
> > 
> > Then, do whatever magic you want in alloc_vmemmap().
> 
> That would break if alloc_vmemmap returns NULL because it cannot allocate 
> memory.

OK, that makes sense.  However, it would still be nice to hide that
#ifdef somewhere that people are a bit less likely to run into it.  It's
just one #ifdef, so if you can kill it, great.  Otherwise, they pile up
over time and _do_ cause real readability problems.

-- Dave

