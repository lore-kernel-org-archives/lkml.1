Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbZCMRIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbZCMRIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbZCMRBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:37 -0400
Received: from gw.goop.org ([64.81.55.164]:57451 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757548AbZCMRBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:36 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 26/27] agp: use more dma-ops-like operations for agp memory
Date: Fri, 13 Mar 2009 10:00:11 -0700
Message-Id: <1236963612-14287-27-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When using AGP under Xen, we need to be careful to
1) properly translate between physical and machine addresses, and
2) make sure memory is physically contigious when the hardware expects it

This change uses swiotlb_phys_to_bus/bus_to_phys to do the phys<->gart
conversion, since they already do the right thing, and dma_alloc_coherent
for gatt allocations.  This should work equally well running native.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Airlie <airlied@linux.ie>
---
 arch/x86/include/asm/agp.h |   15 ++++++++++-----
 lib/swiotlb.c              |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/agp.h b/arch/x86/include/asm/agp.h
index 9825cd6..7ba2639 100644
--- a/arch/x86/include/asm/agp.h
+++ b/arch/x86/include/asm/agp.h
@@ -1,8 +1,11 @@
 #ifndef _ASM_X86_AGP_H
 #define _ASM_X86_AGP_H
 
+#include <linux/swiotlb.h>
+
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
+#include <asm/dma-mapping.h>
 
 /*
  * Functions to keep the agpgart mappings coherent with the MMU. The
@@ -23,13 +26,15 @@
 #define flush_agp_cache() wbinvd()
 
 /* Convert a physical address to an address suitable for the GART. */
-#define phys_to_gart(x) (x)
-#define gart_to_phys(x) (x)
+#define phys_to_gart(x) swiotlb_phys_to_bus(NULL, (x))
+#define gart_to_phys(x) swiotlb_bus_to_phys(x)
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
-	((char *)__get_free_pages(GFP_KERNEL, (order)))
+#define alloc_gatt_pages(order)	({                                          \
+	char *_t; dma_addr_t _d;                                            \
+	_t = dma_alloc_coherent(NULL,PAGE_SIZE<<(order),&_d,GFP_KERNEL);    \
+	_t; })
 #define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+	dma_free_coherent(NULL,PAGE_SIZE<<(order),(table),virt_to_bus(table))
 
 #endif /* _ASM_X86_AGP_H */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 8e6f6c8..98fb7d3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -128,11 +128,13 @@ dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_phys_to_bus);
 
 phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
 {
 	return baddr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_bus_to_phys);
 
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
-- 
1.6.0.6

