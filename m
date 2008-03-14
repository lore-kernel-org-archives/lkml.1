Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYCNJgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYCNJgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYCNJgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:36:11 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:40250 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYCNJgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:36:10 -0400
Date: Fri, 14 Mar 2008 18:35:30 +0900
To: jbeulich@novell.com
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid endless loops in lib/swiotlb.c
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47D8FE4A.76E4.0078.0@novell.com>
References: <47D8FE4A.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080314182219P.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 09:13:30 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> Commit 681cc5cd3efbeafca6386114070e0bfb5012e249 introduced two
> possibilities for entering an endless loop in lib/swiotlb.c:
> 
> - if max_slots is zero (possible if mask is ~0UL)

Yeah, max_slots can not be zero. There are no drivers that have such
mask. I'm not sure that we will have.

I exported a function, iommu_is_span_boundary in lib/iommu-helper.c
that does the same thing that is_span_boundary does for SPARC and
PARISC IOMMUs. iommu_is_span_boundary does this checking. I've
attached a patch to convert swiotlb to use it.

If we need to think about the possibility of handling such mask, I
think that it would be better to create a helper function to handle
this in lib/iommu-helper.c since several IOMMUs do the same thing.


> - if the number of slots requested fits into a swiotlb segment, but is
>   too large for the part of a segment which remains after considering
>   offset_slots

Sorry, I'm not sure what you mean. Can you give me an actual example
numbers that leads to that?


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] SWIOTLB: use iommu_is_span_boundary helper function

iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC
IOMMUs (commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f). SWIOTLB can
use it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/Kconfig |    3 +++
 arch/x86/Kconfig  |    5 ++---
 lib/swiotlb.c     |   19 ++++++-------------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8fa3faf..a33d7ed 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -46,6 +46,9 @@ config MMU
 config SWIOTLB
        bool
 
+config IOMMU_HELPER
+       bool
+
 config GENERIC_LOCKBREAK
 	bool
 	default y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 237fc12..aff96a7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -477,9 +477,6 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
-config IOMMU_HELPER
-	def_bool (CALGARY_IOMMU || GART_IOMMU)
-
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
@@ -490,6 +487,8 @@ config SWIOTLB
 	  access 32-bits of memory can be used on systems with more than
 	  3 GB of memory. If unsure, say Y.
 
+config IOMMU_HELPER
+	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB)
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-255)"
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4bb5a11..2c6392a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -31,6 +31,7 @@
 
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/iommu-helper.h>
 
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
@@ -282,15 +283,6 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 	return (addr & ~mask) != 0;
 }
 
-static inline unsigned int is_span_boundary(unsigned int index,
-					    unsigned int nslots,
-					    unsigned long offset_slots,
-					    unsigned long max_slots)
-{
-	unsigned long offset = (offset_slots + index) & (max_slots - 1);
-	return offset + nslots > max_slots;
-}
-
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -334,8 +326,8 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 		if (index >= io_tlb_nslabs)
 			index = 0;
 
-		while (is_span_boundary(index, nslots, offset_slots,
-					max_slots)) {
+		while (iommu_is_span_boundary(index, nslots, offset_slots,
+					      max_slots)) {
 			index += stride;
 			if (index >= io_tlb_nslabs)
 				index = 0;
@@ -371,8 +363,9 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 				index += stride;
 				if (index >= io_tlb_nslabs)
 					index = 0;
-			} while (is_span_boundary(index, nslots, offset_slots,
-						  max_slots));
+			} while (iommu_is_span_boundary(index, nslots,
+							offset_slots,
+							max_slots));
 		} while (index != wrap);
 
 		spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.5.3.7

