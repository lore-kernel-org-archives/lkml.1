Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbXFYSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbXFYSXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXFYSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:23:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39829 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbXFYSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:23:39 -0400
Date: Mon, 25 Jun 2007 11:23:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
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
In-Reply-To: <Pine.LNX.4.64.0706251804420.7592@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Hugh Dickins wrote:

> > > PageSlab to avoid oopsing on page->mapping.
> > 
> > It is definitely intended to work. Otherwise we would not have code 
> > like this:
> > 
> > christoph@fly:~/linux-2.6$ find . -name "*.c" | xargs grep "flush_dcache_page"|grep virt
> > ./drivers/scsi/scsi_tgt_if.c:   flush_dcache_page(virt_to_page(ev));
> > ./drivers/scsi/scsi_tgt_if.c:           flush_dcache_page(virt_to_page(ev));
> 
> I didn't claim that flush_dcache_page(virt_to_page(virt)) is not expected
> to work.  I claim that flush_dcache_page is expected to be a noop rather
> than an oops on a kmalloced page.

There are no kmalloced pages. There is only kmalloced memory. You allocate 
pages from the page allocator. Its a layering violation to expect a page
struct operation on a slab object to work.

It is not okay to use a page cache function on a slab object. The slab 
object does not fulfill the alignment requirements of a page cache page
nor does it  have a compatible page struct content as a page cache page. 
This can only cause trouble.

The problem is that the code is allocating some slab memory and then 
determines the page struct pointer and then hands it back to the DMA 
layer?

> > Ok. I think your patch is fine as a quick fix for 2.6.22. I am a bit 
> > uneasy with that given that its in such a broadly used function while its 
> > only use is to enable flush_dcache_page to work. But we need the general 
> > issue taken care of after 2.6.22.
> 
> What general issue?

How to flush slab objects in a reliable way.

> Please see Documentation/cachetlb.txt: flush_dcache_page is about
> pagecache pages mapped into userspace.  We don't use kmalloc for those,
> but we do sometimes need to flush_dcache_page in places which commonly
> deal with pagecache pages, but sometimes handle kmalloc'ed buffers too.
> Luckily we don't have to deal with buffers in which the first page is
> kmalloced and the next comes from pagecache.

This gets crazier and crazier. flush_dcache_page is for pages not for
allocated buffers via kmalloc. So this has nothing to do with any need
to flush slab objects?

Sometimes we do this and then we do that? So someone played loose
ball with the slab, was successful and that makes it right now?

We need the VM_BUG_ON in include/linux/mm.h to stop this nonsense.

The "sometimes we have kmalloced buffers" locations need to be fixed.
