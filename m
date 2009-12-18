Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZLRJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZLRJfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZLRJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:35:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:47045 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZLRJfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:35:41 -0500
Date: Fri, 18 Dec 2009 18:34:52 +0900
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       torvalds@linux-foundation.org, tytso@mit.edu, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, linux-arch@vger.kernel.org
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1261120128.3013.8.camel@mulgrave.site>
References: <1261094220.2752.27.camel@mulgrave.site>
	<20091218095944G.fujita.tomonori@lab.ntt.co.jp>
	<1261120128.3013.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091218183353I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 18 Dec 2009 18:34:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 08:08:48 +0100
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > Even if we have some potential users, I'm not sure that supporting
> > vmalloc in the block layer officially is a good idea. IMO, it needs
> > too many tricks for generic code.
> 
> So far, there's only xfs that I know of.
> 
> Given the way journalling works, it's not an unusual requirement to use
> a large buffer for operations.  It's a bit of a waste of kernel
> resources to have this physically contiguous, but it is a waste of
> resources (and for buffers over our kmalloc max, it would even have to
> be allocated at start of day), so I think large kernel virtual areas
> (like vmap/vmalloc) have a part to play in fs operations.

Yeah, but now only XFS passes vmap'ed pages to the block layer. Isn't
it better to wait until we have real users of the API?


> As to the API, the specific problem is that the block and lower arch
> layers are specifically programmed to think any kernel address has only
> a single alias and that it's offset mapped, which is why we get the
> failure.

Yeah, however we can make a rule that you can't pass a vmap area
(including vmap'ed pages) to the block layer. We can't make the rule
effective for the past so XFS is the only exception.


> An alternative proposal to modifying the block layer to do coherency,
> might be simply to have the fs layer do a vunmap before doing I/O and
> re-vmap when it's completed. 

I'm not sure it's worth making the whole block layer compatible to
vmap (adding complexity and possibly performance penalty).

If we really need to support this, I like helper APIs that the callers
must use before and after I/Os.


> That would ensure the architecturally
> correct flushing of the aliases, and would satisfy the expectations of
> blk_rq_map_kern().  The down side is that vmap/vmalloc set up and clear
> page tables, which isn't necessary and might impact performance (xfs
> people?)

btw, I'm not sure that the existing blk_rq_map_* API isn't fit well to
file systems since blk_rq_map_user and blk_rq_map_kern takes a request
structure.
