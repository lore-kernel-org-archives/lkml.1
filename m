Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYIQQ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYIQQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYIQQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:26 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53420 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYIQQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:24 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7CMW5-03-U8S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Date: Wed, 17 Sep 2008 18:52:37 +0200
Message-ID: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:57.0917 (UTC) FILETIME=[D653E6D0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IO/TLB flushing on every unmaping operation is the most expensive
part there and not strictly necessary. It is sufficient to do the flush
before any entries are reused. This is patch implements lazy IO/TLB
flushing which does exactly this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
 arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
 include/asm-x86/amd_iommu_types.h   |    9 +++++++++
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c2e00ee..5f0aefe 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
 			          domain)
+			unmap_flush - enable flushing of IO/TLB entries when
+			              they are unmapped. Otherwise they are
+				      flushed before they will be reused, which
+				      is a lot of faster
+
 	amd_iommu_size= [HW,X86-64]
 			Define the size of the aperture for the AMD IOMMU
 			driver. Possible values are:
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 691e023..0569098 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -203,6 +203,14 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 	return 0;
 }
 
+/* Flush the whole IO/TLB for a given protection domain */
+static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
+{
+	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+
+	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -386,14 +394,18 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 			PAGE_SIZE) >> PAGE_SHIFT;
 	limit = limit < size ? limit : size;
 
-	if (dom->next_bit >= limit)
+	if (dom->next_bit >= limit) {
 		dom->next_bit = 0;
+		dom->need_flush = true;
+	}
 
 	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
 			0 , boundary_size, 0);
-	if (address == -1)
+	if (address == -1) {
 		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
 				0, boundary_size, 0);
+		dom->need_flush = true;
+	}
 
 	if (likely(address != -1)) {
 		dom->next_bit = address + pages;
@@ -553,6 +565,8 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->bitmap[0] = 1;
 	dma_dom->next_bit = 0;
 
+	dma_dom->need_flush = false;
+
 	/* Intialize the exclusion range if necessary */
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
@@ -795,7 +809,10 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
-	if (unlikely(iommu_has_npcache(iommu)))
+	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
+		iommu_flush_tlb(iommu, dma_dom->domain.id);
+		dma_dom->need_flush = false;
+	} else if (unlikely(iommu_has_npcache(iommu)))
 		iommu_flush_pages(iommu, dma_dom->domain.id, address, size);
 
 out:
@@ -829,7 +846,8 @@ static void __unmap_single(struct amd_iommu *iommu,
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
-	iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
+	if (amd_iommu_unmap_flush)
+		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
 }
 
 /*
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index a69cc0f..da631ab 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -121,6 +121,7 @@ LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
 int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
@@ -995,6 +996,11 @@ int __init amd_iommu_init(void)
 	else
 		printk("disabled\n");
 
+	if (amd_iommu_unmap_flush)
+		printk(KERN_INFO "AMD IOMMU: IO/TLB flush on unmap enabled\n");
+	else
+		printk(KERN_INFO "AMD IOMMU: Lazy IO/TLB flushing enabled\n");
+
 out:
 	return ret;
 
@@ -1057,8 +1063,10 @@ void __init amd_iommu_detect(void)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strcmp(str, "isolate") == 0)
+		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
+		if (strncmp(str, "unmap_flush", 11) == 0)
+			amd_iommu_unmap_flush = true;
 	}
 
 	return 1;
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 1ffa4e5..82a26fb 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -196,6 +196,9 @@ struct dma_ops_domain {
 	 * just calculate its address in constant time.
 	 */
 	u64 **pte_pages;
+
+	/* This will be set to true when TLB needs to be flushed */
+	bool need_flush;
 };
 
 /*
@@ -322,6 +325,12 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
 /* will be 1 if device isolation is enabled */
 extern int amd_iommu_isolate;
 
+/*
+ * If true, the addresses will be flushed on unmap time, not when
+ * they are reused
+ */
+extern bool amd_iommu_unmap_flush;
+
 /* takes a PCI device id and prints it out in a readable form */
 static inline void print_devid(u16 devid, int nl)
 {
-- 
1.5.6.4


