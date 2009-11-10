Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZKJKuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZKJKuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZKJKuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:50:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:33804 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZKJKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:50:06 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 7/9] swiotlb: add swiotlb_free function
Date: Tue, 10 Nov 2009 19:46:18 +0900
Message-Id: <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_free function frees all allocated memory for swiotlb.

We need to initialize swiotlb before IOMMU initialization (x86 and
powerpc needs to allocate memory from bootmem allocator). If IOMMU
initialization is successful, we need to free swiotlb resource (don't
want to waste 64MB).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |    1 +
 lib/swiotlb.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 73b1f1c..51b6cc2 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -88,4 +88,5 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
+extern void __init swiotlb_free(void);
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index ac25cd2..eee512b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -97,6 +97,8 @@ static phys_addr_t *io_tlb_orig_addr;
  */
 static DEFINE_SPINLOCK(io_tlb_lock);
 
+static int late_alloc;
+
 static int __init
 setup_io_tlb_npages(char *str)
 {
@@ -262,6 +264,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
 
 	swiotlb_print_info(bytes);
 
+	late_alloc = 1;
+
 	return 0;
 
 cleanup4:
@@ -281,6 +285,32 @@ cleanup1:
 	return -ENOMEM;
 }
 
+void __init swiotlb_free(void)
+{
+	if (!io_tlb_overflow_buffer)
+		return;
+
+	if (late_alloc) {
+		free_pages((unsigned long)io_tlb_overflow_buffer,
+			   get_order(io_tlb_overflow));
+		free_pages((unsigned long)io_tlb_orig_addr,
+			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
+		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+								 sizeof(int)));
+		free_pages((unsigned long)io_tlb_start,
+			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
+	} else {
+		free_bootmem_late(__pa(io_tlb_overflow_buffer),
+				  io_tlb_overflow);
+		free_bootmem_late(__pa(io_tlb_orig_addr),
+				  io_tlb_nslabs * sizeof(phys_addr_t));
+		free_bootmem_late(__pa(io_tlb_list),
+				  io_tlb_nslabs * sizeof(int));
+		free_bootmem_late(__pa(io_tlb_start),
+				  io_tlb_nslabs << IO_TLB_SHIFT);
+	}
+}
+
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(io_tlb_start) &&
-- 
1.5.6.5

