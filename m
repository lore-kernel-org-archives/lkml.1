Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbZAUIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbZAUIOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZAUIOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:14:25 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44059 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754889AbZAUIOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:14:23 -0500
Date: Wed, 21 Jan 2009 17:11:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
       Guennadi Liakhovetski <lg@denx.de>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
Message-ID: <20090121081118.GA14537@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
	dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
	Guennadi Liakhovetski <lg@denx.de>,
	Johannes Weiner <hannes@cmpxchg.org>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com> <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121033951.GB14094@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 12:39:52PM +0900, Paul Mundt wrote:
> On Tue, Jan 20, 2009 at 09:55:07PM +0000, Adrian McMenamin wrote:
> > On Tue, 2009-01-20 at 21:48 +0000, Adrian McMenamin wrote:
> > > Currently this code compares a size in bytes with a size in pages.
> > > This patch makes both sides of the comparison bytes.
> > 
> > Apologies, here it is without the line wrap.
> > 
> > Currently this comparison is made between bytes and pages. This patch
> > ensures it is bytes on both side of the comparison.
> > 
> > Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > ---
> > 
> > --- a/kernel/dma-coherent.c
> > +++ b/kernel/dma-coherent.c
> > @@ -118,7 +118,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
> >  	mem = dev->dma_mem;
> >  	if (!mem)
> >  		return 0;
> > -	if (unlikely(size > mem->size))
> > +	if (unlikely(size > mem->size << PAGE_SHIFT))
> >   		return 0;
> >  
> >  	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
> > 
And to make matters worse, this completely changes the underlying
semantics for systems that _require_ exclusive use of the per-device
region and don't permit fallback to the generic allocator. Returning 0
from dma_alloc_from_coherent() indicates that the generic allocator is
safe to fall back on, which is totally bogus in the DMA_MEMORY_EXCLUSIVE
case. This is what causes 8139too to successfully allocate memory on the
Dreamcast from totally bogus locations, which causes the generally
unhelpful error messages. If the fallback hadn't been made silently, it
would have errored out on allocating the buffers immediately.

So, something like the following should do it:

---

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index 0387074..3a2156a 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
  * @size:	size of requested memory area
  * @dma_handle:	This will be filled with the correct dma handle
  * @ret:	This pointer will be filled with the virtual address
- * 		to allocated area.
+ *		to allocated area.
  *
  * This function should be only called from per-arch dma_alloc_coherent()
  * to support allocation from per-device coherent memory pools.
@@ -118,31 +118,32 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	mem = dev->dma_mem;
 	if (!mem)
 		return 0;
-	if (unlikely(size > mem->size))
- 		return 0;
+
+	*ret = NULL;
+
+	if (unlikely(size > (mem->size << PAGE_SHIFT)))
+		goto err;
 
 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
-	if (pageno >= 0) {
-		/*
-		 * Memory was found in the per-device arena.
-		 */
-		*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
-		*ret = mem->virt_base + (pageno << PAGE_SHIFT);
-		memset(*ret, 0, size);
-	} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
-		/*
-		 * The per-device arena is exhausted and we are not
-		 * permitted to fall back to generic memory.
-		 */
-		*ret = NULL;
-	} else {
-		/*
-		 * The per-device arena is exhausted and we are
-		 * permitted to fall back to generic memory.
-		 */
-		 return 0;
-	}
+	if (unlikely(pageno < 0))
+		goto err;
+
+	/*
+	 * Memory was found in the per-device arena.
+	 */
+	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
+	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
+	memset(*ret, 0, size);
+
 	return 1;
+
+err:
+	/*
+	 * In the case where the allocation can not be satisfied from the
+	 * per-device area, try to fall back to generic memory if the
+	 * constraints allow it.
+	 */
+	return mem->flags & DMA_MEMORY_EXCLUSIVE;
 }
 EXPORT_SYMBOL(dma_alloc_from_coherent);
 
