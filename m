Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXFVBgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXFVBgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXFVBgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:36:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52108 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXFVBgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:36:23 -0400
Date: Thu, 21 Jun 2007 18:36:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this will address the issue on ARM?


ARM: Allocate dma pages via the page allocator and not via the slab allocator

Slab allocations are not guaranteed to be page aligned and slab allocators
may use the page structs for their own purposes. Using the page allocator
yields a properly aligned page and also makes the page flushing logic work right.

Passing a kmalloced "page" to a flushing function will not work reliably.

This will hopefully address the issue with SLUB on ARM. SLUB uses the
page->mapping field which is also checked by the flushing logic. The
flushing logic expects a normal page and not a slab page.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/arm/mm/consistent.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mm/consistent.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/consistent.c	2007-06-21 18:18:15.000000000 -0700
+++ linux-2.6/arch/arm/mm/consistent.c	2007-06-21 18:29:16.000000000 -0700
@@ -277,7 +277,7 @@ dma_alloc_coherent(struct device *dev, s
 	if (arch_is_coherent()) {
 		void *virt;
 
-		virt = kmalloc(size, gfp);
+		virt = get_free_pages(gfp, get_order(size));
 		if (!virt)
 			return NULL;
 		*handle =  virt_to_dma(dev, virt);
@@ -364,7 +364,7 @@ void dma_free_coherent(struct device *de
 	WARN_ON(irqs_disabled());
 
 	if (arch_is_coherent()) {
-		kfree(cpu_addr);
+		free_pages((unsigned long)cpu_addr, get_order(size));
 		return;
 	}
 
