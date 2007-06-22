Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXFVUPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXFVUPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXFVUPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:15:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48311 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbXFVUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:15:25 -0400
Date: Fri, 22 Jun 2007 13:15:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706221312520.18841@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221143190.17958@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the corresponding PA-RISC piece. Its as straightforward as 
the other one since the only way to make this work properly in the past 
was if the sizes passed to the dma alloc functions are page size based.



PA-RISC: Use page allocator instead of slab allocator.

Slab pages obtained via kmalloc are not cachline aligned. Nor is it advisable
to perform VM operations designed for page allocator pages on
memory obtained via kmalloc.

So replace the page sized allocations in kernel/pci-dma.c with page allocator
pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/parisc/kernel/pci-dma.c |    4 ++--
 include/linux/mm.h           |    5 +----
 2 files changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/parisc/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/pci-dma.c	2007-06-22 13:02:32.000000000 -0700
+++ linux-2.6/arch/parisc/kernel/pci-dma.c	2007-06-22 13:06:39.000000000 -0700
@@ -572,7 +572,7 @@ static void *pa11_dma_alloc_noncoherent(
 	void *addr = NULL;
 
 	/* rely on kmalloc to be cacheline aligned */
-	addr = kmalloc(size, flag);
+	addr = (void *)__get_free_pages(flag, get_order(size));
 	if(addr)
 		*dma_handle = (dma_addr_t)virt_to_phys(addr);
 
@@ -582,7 +582,7 @@ static void *pa11_dma_alloc_noncoherent(
 static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t iova)
 {
-	kfree(vaddr);
+	free_pages((unsigned long)vaddr, get_order(size));
 	return;
 }
 

