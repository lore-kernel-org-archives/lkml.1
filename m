Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0BKTN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:13:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35202 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab0BKTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:13:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5889"; a="33948549"
Message-ID: <4B7456CF.6030805@codeaurora.org>
Date: Thu, 11 Feb 2010 11:13:19 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
References: <20100210212156.GB30854@n2100.arm.linux.org.uk> <1265885102.3389.34.camel@pc1117.cambridge.arm.com> <20100211105638.GB9480@n2100.arm.linux.org.uk>
In-Reply-To: <20100211105638.GB9480@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Feb 11, 2010 at 10:45:01AM +0000, Catalin Marinas wrote:
>> Alternatively we could use the dsb() macro. I don't think we need more
>> than this and we would not (well, not easily) compile ARMv5 and ARMv6 in
>> the same kernel.
> 
> That doesn't work - ARMv3 and some ARMv4 don't have a 'drain write
> buffer' instruction but others do - executing that instruction on
> older CPUs which don't have a write buffer causes an illegal
> instruction fault.
> 
>> The ___dma_single_cpu_to_dev() covers both inner and outer caches but I
>> haven't seen it touched by this patch (nor the other you posted). When
>> you clean the L1 cache, you need to make sure that there is a barrier
>> (DSB) so that it completes before cleaning the L2, otherwise you clean
>> the L2 but data keeps coming from L1.
>>
>> For the *_sg functions, you either use barrier between L1 and L2 for
>> each page or you do the for_each_sg() loop twice, once for L1 and
>> another for L2.
> 
> Okay, that's a fundamental problem with this approach.  Spanner in the
> works kind of thing.  I think that's a problem for Abhijeet's patch
> as well - since the same comment appears to apply there too.

The problem applies to my patch as well, however my board has a unified 
cache and I didn't think about ordering operations on the outer caches.

> Sounds like it needs a totally different approach then.
how about the following ?


 From ea746d981f6f7291fd0f8b3f51bdd3747ca976c5 Mon Sep 17 00:00:00 2001
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Date: Thu, 11 Feb 2010 10:29:19 -0800
Subject: [PATCH] dma: define map/unmap functions for outer cache

Define map and unmap functions for outer cache and execute barriers
at appropriate places within them. For architectures without outer caches
these functions are nil.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
  arch/arm/include/asm/cacheflush.h |   39 
+++++++++++++++++++++++++++++++++++++
  arch/arm/mm/dma-mapping.c         |   17 +--------------
  2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h 
b/arch/arm/include/asm/cacheflush.h
index 8148a00..3474a54 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -11,6 +11,7 @@
  #define _ASMARM_CACHEFLUSH_H

  #include <linux/mm.h>
+#include <linux/dma-mapping.h>

  #include <asm/glue.h>
  #include <asm/shmparam.h>
@@ -300,6 +301,38 @@ static inline void outer_flush_range(unsigned long 
start, unsigned long end)
  		outer_cache.flush_range(start, end);
  }

+static inline void dmac_outer_map_area(const void *kaddr, size_t size,
+	enum dma_data_direction dir)
+{
+	unsigned long paddr;
+
+	/* complete all the prior L1 operations */
+	dma_barrier();
+	paddr = __pa(kaddr);
+	if (dir == DMA_FROM_DEVICE) {
+		outer_inv_range(paddr, paddr + size);
+	} else {
+		outer_clean_range(paddr, paddr + size);
+	}
+	/* FIXME: non-speculating: flush on bidirectional mappings? */
+}
+
+static inline void dmac_outer_unmap_area(const void *kaddr, size_t size,
+	enum dma_data_direction dir)
+{
+
+	/* FIXME: non-speculating: not required */
+	/* don't bother invalidating if DMA to device */
+	if (dir != DMA_TO_DEVICE) {
+		unsigned long paddr = __pa(kaddr);
+		outer_inv_range(paddr, paddr + size);
+	}
+
+	/* complete all the outer cache operations operations */
+	dma_barrier();
+}
+
+
  #else

  static inline void outer_inv_range(unsigned long start, unsigned long end)
@@ -308,6 +341,12 @@ static inline void outer_clean_range(unsigned long 
start, unsigned long end)
  { }
  static inline void outer_flush_range(unsigned long start, unsigned 
long end)
  { }
+static inline void dmac_outer_map_area(const void *kaddr, size_t size,
+	enum dma_data_direction dir)
+{ }
+static inline void dmac_outer_unmap_area(const void *kaddr, size_t size,
+	enum dma_data_direction dir)
+{ }

  #endif

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64daef2..6fff111 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -407,19 +407,11 @@ EXPORT_SYMBOL(dma_free_coherent);
  void ___dma_single_cpu_to_dev(const void *kaddr, size_t size,
  	enum dma_data_direction dir)
  {
-	unsigned long paddr;
-
  	BUG_ON(!virt_addr_valid(kaddr) || !virt_addr_valid(kaddr + size - 1));

  	dmac_map_area(kaddr, size, dir);

-	paddr = __pa(kaddr);
-	if (dir == DMA_FROM_DEVICE) {
-		outer_inv_range(paddr, paddr + size);
-	} else {
-		outer_clean_range(paddr, paddr + size);
-	}
-	/* FIXME: non-speculating: flush on bidirectional mappings? */
+	dmac_outer_map_area(kaddr, size, dir);
  }
  EXPORT_SYMBOL(___dma_single_cpu_to_dev);

@@ -428,12 +420,7 @@ void ___dma_single_dev_to_cpu(const void *kaddr, 
size_t size,
  {
  	BUG_ON(!virt_addr_valid(kaddr) || !virt_addr_valid(kaddr + size - 1));

-	/* FIXME: non-speculating: not required */
-	/* don't bother invalidating if DMA to device */
-	if (dir != DMA_TO_DEVICE) {
-		unsigned long paddr = __pa(kaddr);
-		outer_inv_range(paddr, paddr + size);
-	}
+	dmac_outer_unmap_area(kaddr, size, dir);

  	dmac_unmap_area(kaddr, size, dir);
  }
-- 
1.5.6.3






