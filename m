Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZKJNYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZKJNYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZKJNYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:24:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:34210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZKJNYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:24:52 -0500
Date: Tue, 10 Nov 2009 13:24:08 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] swiotlb: Add swiotlb_free() function
Message-ID: <tip-5740afdb68abadc473fd5392df733558a58c1254@git.kernel.org>
Git-Commit-ID: 5740afdb68abadc473fd5392df733558a58c1254
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5740afdb68abadc473fd5392df733558a58c1254
Gitweb:     http://git.kernel.org/tip/5740afdb68abadc473fd5392df733558a58c1254
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 10 Nov 2009 19:46:18 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:31:52 +0100

swiotlb: Add swiotlb_free() function

swiotlb_free() function frees all allocated memory for swiotlb.

We need to initialize swiotlb before IOMMU initialization (x86
and powerpc needs to allocate memory from bootmem allocator). If
IOMMU initialization is successful, we need to free swiotlb
resource (don't want to waste 64MB).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
LKML-Reference: <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
[ -v2: build fix for the !CONFIG_SWIOTLB case ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/swiotlb.h |    6 ++++++
 lib/swiotlb.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 73b1f1c..59bafa6 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -88,4 +88,10 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
+#ifdef CONFIG_SWIOTLB
+extern void __init swiotlb_free(void);
+#else
+static inline void swiotlb_free(void) { }
+#endif
+
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
