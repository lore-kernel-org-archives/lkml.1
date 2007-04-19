Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXDSWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXDSWmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXDSWmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:42:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41584 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754170AbXDSWmq (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:42:46 -0400
Date: Fri, 20 Apr 2007 08:42:25 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070419224225.GJ32602149@melbourne.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> Variable Order Page Cache Patchset
> 
> This patchset modifies the core VM so that higher order page cache pages
> become possible. The higher order page cache pages are compound pages
> and can be handled in the same way as regular pages.
> 
> The order of the pages is determined by the order set up in the mapping
> (struct address_space). By default the order is set to zero.
> This means that higher order pages are optional. There is no attempt here
> to generally change the page order of the page cache. 4K pages are effective
> for small files.
> 
> However, it would be good if the VM would support I/O to higher order pages
> to enable efficient support for large scale I/O. If one wants to write a
> long file of a few gigabytes then the filesystem should have a choice of
> selecting a larger page size for that file and handle larger chunks of
> memory at once.
> 
> The support here is only for buffered I/O and only for one filesystem (ramfs).
> Modification of other filesystems to support higher order pages may require
> extensive work of other components of the kernel. But I hope this shows that
> there is a relatively easy way to that goal that could be taken in steps..

So looking at this the main thing for converting a filesystem is some extra
bits in the mount process and replacing PAGE_CACHE_* macros with
page_cache_*() wrapper functions.

We can probably set all this up trivially with XFS by allowing block size > page
size filesystems to be mounted and modifying the way we feed pages to a bio
to be aware of compound pages.

> Note that the higher order pages are subject to reclaim. This works in general
> since we are always operating on a single page struct. Reclaim is fooled to
> think that it is touching page sized objects (there are likely issues to be
> fixed there if we want to go down this road).
> 
> What is currently not supported:
> - Buffer heads for higher order pages (possible with the compound pages in mm
>   that do not use page->private requires upgrade of the buffer cache layers).

Does this mean that the -mm code will currently support bufferheads on compound
pages? We need that before we can get XFS to work with compound pages.

> - Higher order pages in the block layer etc.

It's more drivers that we have to worry about, I think.  We don't need to
modify bios to explicitly support compound pages. From bio.h:

/*
 * was unsigned short, but we might as well be ready for > 64kB I/O pages
 */
struct bio_vec {
        struct page     *bv_page;
        unsigned int    bv_len;
        unsigned int    bv_offset;
};

So compound pages should be transparent to anything that doesn't
look at the contents of bio_vecs....

> - Mmapping higher order pages

*nod*

hmmm - what about the way we do copyin and copyout from the page cache? ie
we kmap_atomic() them before we access them. Does this need to change?

> The ramfs driver can be used to test higher order page cache functionality
> (and may help troubleshoot the VM support until we get some real filesystem
> and real devices supporting higher order pages).

I don't think it will take much to get XFS to work with a high order
page cache and we can probably insulate the block layer initially with some
kind of bio_add_compound_page() wrapper and some similar
wrapper on the io completion side.

> Comments appreciated.

So far it's much less intrusive than I expected ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
