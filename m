Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbXF2NFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbXF2NFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbXF2NE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:04:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:16853 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbXF2NE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:04:57 -0400
Date: Fri, 29 Jun 2007 14:04:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706291339160.10769@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcASmFtZXMuQm90dG9tbGV5QHN0ZWVsZXllLmNvbQBjbGFtZXRlckBzZ2kuY29tAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAZGF2ZW1AZGF2ZW1sb2Z0Lm5ldABybWsrbGttbEBhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Christoph Lameter wrote:

> I had a talk with James Bottomley last night and it seems that there is an 
> established way of using the page structs of slab objects in the block 
> layer. Drivers may use the DMA interfaces to issue control commands. In 
> that case they may allocate a short structure via the slab allocator and 
> put the control commands into that slab object.
> 
> The driver will then perform a sg_init_one() on the slab object. 
> sg_init_one() calls sg_set_buf() which determines the page struct of a 
> page. In this case sg_set_buf() will determine the page struct of a slab 
> object. The dma layer may then perform operations on the "slab page". The 
> block layer folks seem to have spend some time to make this work right.

Yes, I don't see why this comes as such a surprise and horror to you,
so much in need of dire WARNINGs.  kmalloc memory is not a different
kind of memory from what you get from the page allocators.

I stand by my page_mapping patch, and the remark I made before,
that page_mapping(page) is the correct place to check this.  What is
page_mapping(page) for?  Precisely to return the struct address_space*
from page->mapping when that's what's in there, and not when that field
has been reused for something else.

So lines like
> +	mapping = PageSlab(page) ? NULL : page_mapping(page);
seem to miss the point.

I agree that the only clash found yet has been in flush_dcache_page,
so some bytes and branches can indeed be saved by just doing the
test in there.  Oh, but your VM_BUG_ON cancels out that saving.
And if we were to try to save bytes and branches there, it's the
synthetic swapper_space business (only required in a couple of
places) I'd be wanting to cut out.

To me this all seems like a big fuss to excuse your surprise:
so please don't expect an Ack from me; but if others prefer
this, I won't be Nacking.  (Though I'll probably whine about
it into eternity ;)

Hugh
