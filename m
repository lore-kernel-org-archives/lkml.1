Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYIVOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYIVOtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYIVOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYIVOtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:49:10 -0400
Date: Mon, 22 Sep 2008 16:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export iommu_area_reserve helper funciton
Message-ID: <20080922144849.GB27956@elte.hu>
References: <20080922223353K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922223353K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] export iommu_area_reserve helper funciton
> 
> x86 has set_bit_string() that does the exact same thing that
> set_bit_area() in lib/iommu-helper.c does.
> 
> This patch exports set_bit_area() in lib/iommu-helper.c as
> iommu_area_reserve(), converts GART, Calgary, and AMD IOMMU to use it.

applied the patch below to tip/x86/iommu, thanks.

> x86's set_bit_string() is used by only the above IOMMUs so this patch 
> also removes set_bit_string. We can put it back easily when it 
> necessary.

could you please send this as a separate patch?

	Ingo

----------------->
>From d26dbc5cf94b0a28acc947285c3b54814a73cb2e Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 22 Sep 2008 22:35:07 +0900
Subject: [PATCH] iommu: export iommu_area_reserve helper function

x86 has set_bit_string() that does the exact same thing that
set_bit_area() in lib/iommu-helper.c does.

This patch exports set_bit_area() in lib/iommu-helper.c as
iommu_area_reserve(), converts GART, Calgary, and AMD IOMMU to use it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/pci-gart_64.c    |    2 +-
 include/linux/iommu-helper.h     |    1 +
 lib/iommu-helper.c               |    5 ++---
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6f7b974..70537d1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -572,7 +572,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	set_bit_string(dom->bitmap, start_page, pages);
+	iommu_area_reserve(dom->bitmap, start_page, pages);
 }
 
 static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fe7695e..080d1d2 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -261,7 +261,7 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 			       badbit, tbl, start_addr, npages);
 	}
 
-	set_bit_string(tbl->it_map, index, npages);
+	iommu_area_reserve(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 508ef47..3dcb1ad 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -827,7 +827,7 @@ void __init gart_iommu_init(void)
 	 * Out of IOMMU space handling.
 	 * Reserve some invalid pages at the beginning of the GART.
 	 */
-	set_bit_string(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
+	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 58f4110..786539e 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -11,6 +11,7 @@ static inline unsigned long iommu_device_max_index(unsigned long size,
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
+extern void iommu_area_reserve(unsigned long *map, unsigned long i, int len);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index a3b8d4c..5d90074 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -30,8 +30,7 @@ again:
 	return index;
 }
 
-static inline void set_bit_area(unsigned long *map, unsigned long i,
-				int len)
+void iommu_area_reserve(unsigned long *map, unsigned long i, int len)
 {
 	unsigned long end = i + len;
 	while (i < end) {
@@ -64,7 +63,7 @@ again:
 			start = index + 1;
 			goto again;
 		}
-		set_bit_area(map, index, nr);
+		iommu_area_reserve(map, index, nr);
 	}
 	return index;
 }
