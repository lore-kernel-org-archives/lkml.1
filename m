Return-Path: <linux-kernel-owner+w=401wt.eu-S966222AbXDDBQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966222AbXDDBQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966225AbXDDBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:16:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40782 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966222AbXDDBQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:16:06 -0400
Date: Tue, 3 Apr 2007 18:16:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> Seems to be an issue with calibrate_delay() spinning in a tight
> loop :(
> 
> BTW, machine boots fine with SLAB code - not sure why ?

Interrupt disabled sigh.

Here is the fix:




SLUB: Fix numa bootstrap

NUMA bootstrap calls new_slab() if more than one node is found on bootup.
new_slab() assumes a standard slab context where interrupts must be
disabled. It enables interrupts for the call into the page allocator
and then disables them again. Interrupts do not have to be disabled
during on bootstrap because we still run single threaded there.

I dropped the interrupt preservation code just before SLUB v6 because
it looked useless there. SLUB worked on the following NUMA tests
that just had a single node. Sigh.

Enable interrupts after calling new_slab.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-03 18:07:41.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-03 18:08:17.000000000 -0700
@@ -1436,6 +1436,8 @@ static int init_kmem_cache_nodes(struct 
 
 			BUG_ON(s->size < sizeof(struct kmem_cache_node));
 			page = new_slab(kmalloc_caches, gfpflags, node);
+			/* new_slab() disables interupts */
+			local_irq_enable();
 
 			BUG_ON(!page);
 			n = page->freelist;
