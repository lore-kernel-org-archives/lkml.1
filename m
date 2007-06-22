Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXFVRlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXFVRlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXFVRlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:41:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37074 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbXFVRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:41:11 -0400
Date: Fri, 22 Jun 2007 10:41:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add VM_BUG_ON in case someone uses page_mapping on a slab page

Detect slab objects being passed to the page oriented functions of the VM.

It is not sufficient to simply return NULL because the functions calling
page_mapping may depend on other items of the page_struct also to be setup
properly. Moreover the slab object may not be properly aligned. The page 
orientedfunctions of the VM expect to operate on page aligned, page sized 
objects. operations on objects straddling page boundaries may only affect 
the objects partially which may lead to surprising results.

It is better to detect eventually remaining uses and eliminate them.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-06-22 10:33:27.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-06-22 10:34:09.000000000 -0700
@@ -603,10 +603,7 @@ static inline struct address_space *page
 
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-#ifdef CONFIG_SLUB
-	else if (unlikely(PageSlab(page)))
-		mapping = NULL;
-#endif
+	VM_BUG_ON(PageSlab(page));
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;

