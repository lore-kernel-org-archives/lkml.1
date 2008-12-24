Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYLXSgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYLXSgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 13:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLXSgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 13:36:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYLXSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 13:36:38 -0500
Date: Wed, 24 Dec 2008 10:36:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [mmotm 2008-12-22-16-14] NULL pointer dereference in
 dma_alloc_from_coherent().
Message-Id: <20081224103623.2bada1c5.akpm@linux-foundation.org>
In-Reply-To: <20081224154502.GA6710@cmpxchg.org>
References: <200812240634.mBO6Y6ZY084756@www262.sakura.ne.jp>
	<20081223233705.21f1eaa4.akpm@linux-foundation.org>
	<20081224154502.GA6710@cmpxchg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 16:45:02 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > 
> > This thing was rather stupidly coded.  Rework it all prior to making
> > changes.
> > 
> > Also, rename local variable `page': kernel readers expect something called
> > `page' to have type `struct page *'.
> > 
> > Cc: Guennadi Liakhovetski <lg@denx.de>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  kernel/dma-coherent.c |   27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff -puN kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up kernel/dma-coherent.c
> > --- a/kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up
> > +++ a/kernel/dma-coherent.c
> > @@ -109,20 +109,25 @@ EXPORT_SYMBOL(dma_mark_declared_memory_o
> >  int dma_alloc_from_coherent(struct device *dev, ssize_t size,
> >  				       dma_addr_t *dma_handle, void **ret)
> >  {
> > -	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
> > +	struct dma_coherent_mem *mem;
> >  	int order = get_order(size);
> > +	int pageno;
> > +
> > +	if (!dev)
> > +		return 0;
> > +	mem = dev->dma_mem;
> > +	if (!mem)
> > +		return 0;
> >  
> > -	if (mem) {
> > -		int page = bitmap_find_free_region(mem->bitmap, mem->size,
> > -						     order);
> > -		if (page >= 0) {
> > -			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
> > -			*ret = mem->virt_base + (page << PAGE_SHIFT);
> > -			memset(*ret, 0, size);
> > -		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
> > -			*ret = NULL;
> > +	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
> > +	if (pageno >= 0) {
> > +		*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
> > +		*ret = mem->virt_base + (pageno << PAGE_SHIFT);
> > +		memset(*ret, 0, size);
> > +	} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
> > +		*ret = NULL;
> >  	}
> > -	return (mem != NULL);
> > +	return 1;
> >  }
> >  EXPORT_SYMBOL(dma_alloc_from_coherent);
> 
> Yep, looks much better.
> 

Looking at it again, that function has a bug:

int dma_alloc_from_coherent(struct device *dev, ssize_t size,
				       dma_addr_t *dma_handle, void **ret)
{
	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
	int order = get_order(size);

	if (mem) {
		int page = bitmap_find_free_region(mem->bitmap, mem->size,
						     order);
		if (page >= 0) {
			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
			*ret = mem->virt_base + (page << PAGE_SHIFT);
			memset(*ret, 0, size);
		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
			*ret = NULL;
	}
	return (mem != NULL);
}

if bitmap_find_free_region() fails and DMA_MEMORY_EXCLUSIVE is not set,
the function will fail to write anything to *ret and will return 1. 
This will cause dma_alloc_coherent() to return an uninitialised value,
crashing the kernel, perhaps via DMA to a random address (ugh).

So I think it should do this:

int dma_alloc_from_coherent(struct device *dev, ssize_t size,
				       dma_addr_t *dma_handle, void **ret)
{
	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
	int order = get_order(size);

	if (mem) {
		int page = bitmap_find_free_region(mem->bitmap, mem->size,
						     order);
		if (page >= 0) {
			/*
			 * Memory was found in the per-device arena.
			 */
			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
			*ret = mem->virt_base + (page << PAGE_SHIFT);
			memset(*ret, 0, size);
		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
			/*
			 * The per-device arena is exhausted and we are not
			 * permitted to fall back to generic memory.
			 */
			*ret = NULL;
		} else {
			/*
			 * The per-device arena is exhausted and we are
			 * permitted to fall back to generic memory.
			 */
			 return 0;
		}
	}
	return (mem != NULL);
}

Can I have some review of this, please?

From: Andrew Morton <akpm@linux-foundation.org>

If bitmap_find_free_region() fails and DMA_MEMORY_EXCLUSIVE is not set,
the function will fail to write anything to *ret and will return 1.             This will cause dma_alloc_coherent() to return an uninitialised value,
crashing the kernel, perhaps via DMA to a random address.

Fix that by changing it to return zero in this case, so the caller will
proceed to allocate the memory from the generic memory allocator.

Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN kernel/dma-coherent.c~dma_alloc_from_coherent-fix-fallback-to-generic-memory kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma_alloc_from_coherent-fix-fallback-to-generic-memory
+++ a/kernel/dma-coherent.c
@@ -116,11 +116,25 @@ int dma_alloc_from_coherent(struct devic
 		int page = bitmap_find_free_region(mem->bitmap, mem->size,
 						     order);
 		if (page >= 0) {
+			/*
+			 * Memory was found in the per-device arena.
+			 */
 			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
 			*ret = mem->virt_base + (page << PAGE_SHIFT);
 			memset(*ret, 0, size);
-		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
+			/*
+			 * The per-device arena is exhausted and we are not
+			 * permitted to fall back to generic memory.
+			 */
 			*ret = NULL;
+		} else {
+			/*
+			 * The per-device arena is exhausted and we are
+			 * permitted to fall back to generic memory.
+			 */
+			 return 0;
+		}
 	}
 	return (mem != NULL);
 }
_

