Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZBLBjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZBLBjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZBLBje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:39:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:51673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZBLBje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:39:34 -0500
Date: Thu, 12 Feb 2009 02:39:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] mm: vmap fix overflow
Message-ID: <20090212013931.GB30043@wotan.suse.de>
References: <20090210055119.GE28301@wotan.suse.de> <20090210144420.2e7bb9a9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210144420.2e7bb9a9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 02:44:20PM -0800, Andrew Morton wrote:
> On Tue, 10 Feb 2009 06:51:19 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > This patch is appropriate for 2.6.28 too.
> > 
> > --
> > 
> > The new vmap allocator can wrap the address and get confused in the case of
> > large allocations or VMALLOC_END near the end of address space.
> > 
> > Problem reported by Christoph Hellwig on a 32-bit XFS workload.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > ---
> >  mm/vmalloc.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > Index: linux-2.6/mm/vmalloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/vmalloc.c
> > +++ linux-2.6/mm/vmalloc.c
> > @@ -334,6 +334,9 @@ retry:
> >  	addr = ALIGN(vstart, align);
> >  
> >  	spin_lock(&vmap_area_lock);
> > +	if (addr + size < addr)
> > +		goto overflow;
> > +
> >  	/* XXX: could have a last_hole cache */
> >  	n = vmap_area_root.rb_node;
> >  	if (n) {
> > @@ -365,6 +368,8 @@ retry:
> >  
> >  		while (addr + size > first->va_start && addr + size <= vend) {
> >  			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> > +			if (addr + size < addr)
> > +				goto overflow;
> >  
> >  			n = rb_next(&first->rb_node);
> >  			if (n)
> > @@ -375,6 +380,7 @@ retry:
> >  	}
> >  found:
> >  	if (addr + size > vend) {
> > +overflow:
> >  		spin_unlock(&vmap_area_lock);
> >  		if (!purged) {
> >  			purge_vmap_area_lazy();
> 
> well...
> 
> 
> If a caller tries to allocate 0x1000 bytes at address 0xfffff000, this
> code will think that it overflowed.  But it didn't.
> 
> Presumably nobody ever tries to do that, but it seems a bit sloppy?

Oh that's true, good catch. I guess that should be (addr + size - 1)?
Because we care about the last byte that was actually allocated to us
(inclusive, rather than exclusive).

