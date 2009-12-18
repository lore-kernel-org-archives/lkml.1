Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZLRKBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZLRKBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZLRKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:01:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:47378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZLRKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:01:47 -0500
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: James Bottomley <James.Bottomley@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org, tytso@mit.edu,
       kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091218183353I.fujita.tomonori@lab.ntt.co.jp>
References: <1261094220.2752.27.camel@mulgrave.site>
	 <20091218095944G.fujita.tomonori@lab.ntt.co.jp>
	 <1261120128.3013.8.camel@mulgrave.site>
	 <20091218183353I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 11:01:29 +0100
Message-Id: <1261130489.3013.41.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:34 +0900, FUJITA Tomonori wrote:
> On Fri, 18 Dec 2009 08:08:48 +0100
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > Even if we have some potential users, I'm not sure that supporting
> > > vmalloc in the block layer officially is a good idea. IMO, it needs
> > > too many tricks for generic code.
> > 
> > So far, there's only xfs that I know of.
> > 
> > Given the way journalling works, it's not an unusual requirement to use
> > a large buffer for operations.  It's a bit of a waste of kernel
> > resources to have this physically contiguous, but it is a waste of
> > resources (and for buffers over our kmalloc max, it would even have to
> > be allocated at start of day), so I think large kernel virtual areas
> > (like vmap/vmalloc) have a part to play in fs operations.
> 
> Yeah, but now only XFS passes vmap'ed pages to the block layer. Isn't
> it better to wait until we have real users of the API?

XFS is a real user ... the XFS filesystem is our most trusted code base
that can break the 8TB limit, which hard disks are already at.  Ext4 may
be ready, but it's not universally present in enterprise distros like
XFS.

> > As to the API, the specific problem is that the block and lower arch
> > layers are specifically programmed to think any kernel address has only
> > a single alias and that it's offset mapped, which is why we get the
> > failure.
> 
> Yeah, however we can make a rule that you can't pass a vmap area
> (including vmap'ed pages) to the block layer. We can't make the rule
> effective for the past so XFS is the only exception.

We need something that works for XFS.  The next proposal works for the
current block API because the vunmap makes the xfs pages look like
standard kernel pages, which blk_rq_map_kern() will process correctly.

But, in principle, I think whatever fix is chosen, we shouldn't
necessarily discourage others from using it.

> > An alternative proposal to modifying the block layer to do coherency,
> > might be simply to have the fs layer do a vunmap before doing I/O and
> > re-vmap when it's completed. 
> 
> I'm not sure it's worth making the whole block layer compatible to
> vmap (adding complexity and possibly performance penalty).

This proposal has no block layer changes.  It just makes the XFS vmap
area look like a standard set of kernel pages ... with the overhead of
the page table manipulations on unmap and remap.

> If we really need to support this, I like helper APIs that the callers
> must use before and after I/Os.

If it's just this route, they already exist ... they're vmap and vunmap.

> > That would ensure the architecturally
> > correct flushing of the aliases, and would satisfy the expectations of
> > blk_rq_map_kern().  The down side is that vmap/vmalloc set up and clear
> > page tables, which isn't necessary and might impact performance (xfs
> > people?)
> 
> btw, I'm not sure that the existing blk_rq_map_* API isn't fit well to
> file systems since blk_rq_map_user and blk_rq_map_kern takes a request
> structure.

OK, so that was illustrative.  The meat of the change is at the bio
layer anyway (fss tend to speak bios).  But the point of *this*
particular proposal is that it requires no changes either in the blk_ or
bio_ routines.

James


