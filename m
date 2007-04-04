Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDDRDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDDRDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXDDRDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:03:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36959 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbXDDRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:03:12 -0400
Date: Wed, 4 Apr 2007 10:03:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> On Tue, 2007-04-03 at 16:55 -0700, Christoph Lameter wrote:
> > On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> > 
> > > Hmm. booted fine with slub_debug :(
> > 
> > Try to selectively disable debug options... if you got the 
> > time...
> > 
> > F.e. Try with sanity checks only
> > 
> > slub_debug=F
> 
> slub_debug=F got something. 

Ahh.... Seems that the first 4 bytes of the allocations is zapped after 
the object has been freed. Can you trap writes to the first four bytes of 
the object? This should give you the culprit.

The other thing is that the system is performing DMA allocations
for the file cache???? Then its running out of memory.

Argh.... We use  GFP DMA bitmask to check SLAB flags field:

Try this fix:



SLUB: Use correct flags to check for DMA cache

We use a GFP mask to check the SLAB flags if this is a DMA cache.

Fix this by using the correct SLAB mask and then use the SLUB_DMA
for the ORing of flags. If the system does not support DMA then
we will OR zero which will hopefully get the compiler to drop the
useless if statement as well.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 09:59:05.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 10:01:14.000000000 -0700
@@ -678,8 +678,8 @@ static struct page *allocate_slab(struct
 	if (s->order)
 		flags |= __GFP_COMP;
 
-	if (s->flags & SLUB_DMA)
-		flags |= GFP_DMA;
+	if (s->flags & SLAB_CACHE_DMA)
+		flags |= SLUB_DMA;
 
 	if (node == -1)
 		page = alloc_pages(flags, s->order);


