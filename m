Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXFYSoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXFYSoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXFYSob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:44:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:25819 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXFYSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:44:31 -0400
Date: Mon, 25 Jun 2007 19:43:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706251933540.13382@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250952490.8320@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251804420.7592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJtaytsa21sQGFybS5saW51eC5vcmcudWsA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Christoph Lameter wrote:
> On Mon, 25 Jun 2007, Hugh Dickins wrote:
> > 
> > I didn't claim that flush_dcache_page(virt_to_page(virt)) is not expected
> > to work.  I claim that flush_dcache_page is expected to be a noop rather
> > than an oops on a kmalloced page.
> 
> There are no kmalloced pages. There is only kmalloced memory. You allocate 
> pages from the page allocator. Its a layering violation to expect a page
> struct operation on a slab object to work.

Oh, thanks so much for resolving my confusion on that.

> 
> It is not okay to use a page cache function on a slab object. The slab 
> object does not fulfill the alignment requirements of a page cache page
> nor does it  have a compatible page struct content as a page cache page. 
> This can only cause trouble.
> 
> The problem is that the code is allocating some slab memory and then 
> determines the page struct pointer and then hands it back to the DMA 
> layer?
> 
> > > Ok. I think your patch is fine as a quick fix for 2.6.22. I am a bit 
> > > uneasy with that given that its in such a broadly used function while its 
> > > only use is to enable flush_dcache_page to work. But we need the general 
> > > issue taken care of after 2.6.22.
> > 
> > What general issue?
> 
> How to flush slab objects in a reliable way.
> 
> > Please see Documentation/cachetlb.txt: flush_dcache_page is about
> > pagecache pages mapped into userspace.  We don't use kmalloc for those,
> > but we do sometimes need to flush_dcache_page in places which commonly
> > deal with pagecache pages, but sometimes handle kmalloc'ed buffers too.
> > Luckily we don't have to deal with buffers in which the first page is
> > kmalloced and the next comes from pagecache.
> 
> This gets crazier and crazier. flush_dcache_page is for pages not for
> allocated buffers via kmalloc. So this has nothing to do with any need
> to flush slab objects?
> 
> Sometimes we do this and then we do that? So someone played loose
> ball with the slab, was successful and that makes it right now?
> 
> We need the VM_BUG_ON in include/linux/mm.h to stop this nonsense.
> 
> The "sometimes we have kmalloced buffers" locations need to be fixed.

I've said enough, I'd better leave it to others to deter you or not
from fiddling around pointlessly here.

But Andrew, please cancel my Acked-by to mm's
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch

Thanks,
Hugh
