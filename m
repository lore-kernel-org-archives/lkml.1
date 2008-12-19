Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYLSWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYLSWqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYLSWqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:46:07 -0500
Received: from cmpxchg.org ([85.214.51.133]:55737 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYLSWqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:46:07 -0500
Date: Fri, 19 Dec 2008 23:45:33 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
Message-ID: <20081219224532.GA2581@cmpxchg.org>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange> <20081219130211.GA1560@cmpxchg.org> <Pine.LNX.4.64.0812191413520.4536@axis700.grange> <20081219144726.GA1991@cmpxchg.org> <Pine.LNX.4.64.0812191553550.4536@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812191553550.4536@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 04:09:42PM +0100, Guennadi Liakhovetski wrote:
> Yes, this is the i.MX31 video capture driver (patch has once been 
> submitted, new version in work). The thing is, we reserve and declare a 
> fixed size coherent region in the board code at start-up, but then what 
> the driver allocates depends on what a user-space application requests - 
> what size video frame and how many buffers. And the driver does not check 
> how much coherent memory it has available, it relies on 
> dma_alloc_coherent() to tell. In fact, the actual i.MX31 camera driver 
> knows nothing about this allocation, this all happens automatically in 
> soc_camera.c::soc_camera_mmap() -> 
> videobuf-dma-contig.c::__videobuf_mmap_mapper().
> 
> > I think we should add the check, WARN if it's true and return an
> > appropriate error number.  It will be handled gracefully then and we
> > still know which callsite screwed up.
> 
> Well, given above you'd get warning each time the user requests too big a 
> frame or too many buffers, which is not nice.

Indeed, that's BS then.

The region size information is local to the dma-coherent code.  So
either the callsite keeps track of the size itself or, if it can not
as in your case, we should check for the correct size on exactly that
layer of code, as well.  Does that sound reasonable?

Why do other driver not need this?  I will look further into it.  If
it's any use, here is a patch that does the check on the allocation
level.

---
dma-coherent: catch oversized requests to dma_alloc_from_coherent()

Prevent passing an order to bitmap_find_free_region() that is larger
than the actual bitmap can represent.

These requests can come from device drivers that have no idea how big
the dma region is and need to rely on dma_alloc_from_coherent() to
sort it out for them.

Reported-by: Guennadi Liakhovetski <lg@denx.de>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index f013a0c..56ea73e 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -112,6 +112,9 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
+	if (unlikely(size > mem->size))
+		return 0;
+
 	if (mem) {
 		int page = bitmap_find_free_region(mem->bitmap, mem->size,
 						     order);
