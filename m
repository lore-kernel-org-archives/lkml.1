Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXISIYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXISIYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXISIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:24:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXISIYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:24:24 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/17] [RFC] Virtual Compound Page Support
References: <20070919033605.785839297@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 10:24:22 +0200
In-Reply-To: <20070919033605.785839297@sgi.com>
Message-ID: <p73ejgvvz9l.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

It seems like a good idea simply because the same functionality
is already open coded in a couple of places and unifying
that would be a good thing. But ...
 
> The patchset provides this functionality in stages. Stage 1 introduces
> the basic fall back mechanism necessary to replace vmalloc allocations
> with
> 
> 	alloc_page(GFP_VFALLBACK, order, ....)

Is there a reason this needs to be a GFP flag versus a wrapper
around alloc_page/free_page ?  page_alloc.c is already too complicated
and it's better to keep new features separated. The only drawback
would be that free_pages would need a different call, but that
doesn't seem like a big problem.

Especially integrating it into slab would seem wrong to me.
slab is already too complicated and for users who need that
large areas page granuality rounding to pages is probably fine.

Also such a wrapper could do the old alloc_page_exact() trick:
instead of always rounding up to next order return the left over
pages to the VM. In some cases this can save significant memory.

I'm also a little dubious about your attempts to do vmalloc in
interrupt context. Is that really needed? GFP_ATOMIC allocations of
large areas seem to be extremly unreliable to me and not design. Even
if it works sometimes free probably wouldn't work there due to the
flushes, which is very nasty. It would be better to drop that.

-Andi



> which signifies to the page allocator that a higher order is to be found
> but a virtual mapping may stand in if there is an issue with fragmentation.
> 
> Stage 1 functionality does not allow allocation and freeing of virtual
> mappings from interrupt contexts.
> 
> The stage 1 series ends with the conversion of a few key uses of vmalloc
> in the VM to alloc_pages() for the allocation of sparsemems memmap table
> and the wait table in each zone. Other uses of vmalloc could be converted
> in the same way.
> 
> 
> Stage 2 functionality enhances the fallback even more allowing allocation
> and frees in interrupt context.
> 
> SLUB is then modified to use the virtual mappings for slab caches
> that are marked with SLAB_VFALLBACK. If a slab cache is marked this way
> then we drop all the restraints regarding page order and allocate
> good large memory areas that fit lots of objects so that we rarely
> have to use the slow paths.
> 
> Two slab caches--the dentry cache and the buffer_heads--are then flagged
> that way. Others could be converted in the same way.
> 
> The patch set also provides a debugging aid through setting
> 
> 	CONFIG_VFALLBACK_ALWAYS
> 
> If set then all GFP_VFALLBACK allocations fall back to the virtual
> mappings. This is useful for verification tests. The test of this
> patch set was done by enabling that options and compiling a kernel.
> 
> 
> Stage 3 functionality could be the adding of support for the large
> buffer size patchset. Not done yet and not sure if it would be useful
> to do.
> 
> Much of this patchset may only be needed for special cases in which the
> existing defragmentation methods fail for some reason. It may be better to
> have the system operate without such a safety net and make sure that the
> page allocator can return large orders in a reliable way.
> 
> The initial idea for this patchset came from Nick Piggin's fsblock
> and from his arguments about reliability and guarantees. Since his
> fsblock uses the virtual mappings I think it is legitimate to
> generalize the use of virtual mappings to support higher order
> allocations in this way. The application of these ideas to the large
> block size patchset etc are straightforward. If wanted I can base
> the next rev of the largebuffer patchset on this one and implement
> fallback.
> 
> Contrary to Nick, I still doubt that any of this provides a "guarantee".
> Have said that I have to deal with various failure scenarios in the VM
> daily and I'd certainly like to see it work in a more reliable manner.
> 
> IMHO getting rid of the various workarounds to deal with the small 4k
> pages and avoiding additional layers that group these pages in subsystem
> specific ways is something that can simplify the kernel and make the
> kernel more reliable overall.
> 
> If people feel that a virtual fall back is needed then so be it. Maybe
> we can shed our security blanket later when the approaches to deal
> with fragmentation have matured.
> 
> The patch set is also available via git from the largeblock git tree via
> 
> git pull
>   git://git.kernel.org/pub/scm/linux/kernel/git/christoph/largeblocksize.git
>     vcompound
> 
> -- 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
