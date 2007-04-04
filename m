Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXDDRNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXDDRNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXDDRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:13:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35569 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652AbXDDRNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:13:07 -0400
Date: Wed, 4 Apr 2007 10:13:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB powerpc)
In-Reply-To: <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704041003170.24640@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com> 
 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031814430.7645@schroedinger.engr.sgi.com>
 <1175699559.6185.24.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> Well !! Helps a little, but not enough to boot (hangs little later) :(
> I will try to get stack trace for that.

Great! Thanks for all the debugging help.

 
> Processor 6 found.
> Processor 7 found.
> Brought up 8 CPUs
> mm/memory.c:111: bad pud c0000000f20c0480.

Hmmm... Checking for slabs used in powerpc arch code:

The pgtable cache is configured as


          pgtable_cache[i] = kmem_cache_create(name,
                                                     size, size,
                                                     SLAB_HWCACHE_ALIGN |
                                                     SLAB_MUST_HWCACHE_ALIGN,
                                                     zero_ctor,
                                                     NULL);

Hmmm.... aligned slabs at size and then we MUST_HWCACHE_ALIGN?? Two 
competing alignment requirements and a constructor. Constructor requires
the moving of the free pointer after the slab and thus increases the slab 
size.

Sigh. IF SLAB_HWCACHE_ALIGN is set then SLUB believes this to be the 
ultimate demand that overrides all other alignments and only aligns to the 
cacheline. Try the following fix:



SLUB: Treat SLAB_HWCACHE_ALIGN as a mininum and not as *the* alignment

If the specified alignment is higher than L1_CACHE_BYTES and
SLAB_HWCACHE_ALIGN is set then use the higher alignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 10:09:20.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 10:09:42.000000000 -0700
@@ -1373,10 +1373,7 @@ static int calculate_order(int size)
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
-	if (flags & SLAB_HWCACHE_ALIGN)
-		return L1_CACHE_BYTES;
-
-	if (flags & SLAB_MUST_HWCACHE_ALIGN)
+	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
