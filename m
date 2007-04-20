Return-Path: <linux-kernel-owner+w=401wt.eu-S2993254AbXDTOOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993254AbXDTOOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766649AbXDTOOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:14:11 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:54839 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993254AbXDTOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:14:09 -0400
Date: Fri, 20 Apr 2007 15:14:06 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420141406.GB16878@skynet.ie>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/04/07 09:35), Christoph Lameter didst pronounce:
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

Interesting stuff. It seems promising.

> The support here is only for buffered I/O and only for one filesystem (ramfs).
> Modification of other filesystems to support higher order pages may require
> extensive work of other components of the kernel. But I hope this shows that
> there is a relatively easy way to that goal that could be taken in steps..
> 

And having ramfs even remotely aware of compound pages is a step in the
direction of collaping hugetlbfs and ramfs into being two sides of the
same coin. I haven't thought about it much but it seems plausible.

> Note that the higher order pages are subject to reclaim. This works in general
> since we are always operating on a single page struct. Reclaim is fooled to
> think that it is touching page sized objects (there are likely issues to be
> fixed there if we want to go down this road).
> 

I believe there is an assumption in parts of reclaim that LRU pages are
order-0. An interesting bug or two is likely to rear its head there.

> What is currently not supported:
> - Buffer heads for higher order pages (possible with the compound pages in mm
>   that do not use page->private requires upgrade of the buffer cache layers).
> - Higher order pages in the block layer etc.
> - Mmapping higher order pages
> 
> Note that this is proof-of-concept. Lots of functionality is missing and
> various issues have not been dealt with. Use of higher order pages may cause
> memory fragmentation. Mel Gorman's anti-fragmentation work is probably
> essential if we want to do this. We likely need actual defragmentation
> support.
> 

Ok, anti-fragmentation will help up to a point but it's awkward with ramfs
because those pages are not reclaimable or migratable no matter what the
order. Normal filesystems would fare much better fragmentation-wise.

The problem is that the mapping gfp_mask is normally GFP_HIGH_MOVABLE but it's
GFP_HIGHUSER for ramfs. This patchset will increase the number of non-movable
high-order allocations quite considerably and it will tend to fragment memory
worse than we do currently. I can think of ways it can be dealt with 
(even marking them RECLAIMABLE would help) so I'm not massively worried
now but I'll keep it in mind as things develop.

> The main point of this patchset is to demonstrates that it is basically
> possible to have higher order support with straightforward changes to the
> VM.
> 
> The ramfs driver can be used to test higher order page cache functionality
> (and may help troubleshoot the VM support until we get some real filesystem
> and real devices supporting higher order pages).
> 
> If you apply this patch and then you can f.e. try this:
> 
> mount -tramfs -o10 none /media
> 
> 	Mounts a ramfs filesystem with order 10 pages (4 MB)
> 
> cp linux-2.6.21-rc7.tar.gz /media
> 
> 	Populate the ramfs. Note that we allocate 14 pages of 4M each
> 	instead of 13508..
> 
> umount /media
> 
> 	Gets rid of the large pages again
> 
> Comments appreciated.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
