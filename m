Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZCXR7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZCXR7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZCXR7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:59:35 -0400
Received: from gw.goop.org ([64.81.55.164]:43987 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZCXR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:59:34 -0400
Message-ID: <49C91F84.5020109@goop.org>
Date: Tue, 24 Mar 2009 10:59:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] agp: use more dma-ops-like operations for agp memory
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make agp work under Xen

[ Hi Dave,  I was about to post this, but I'm not sure if you've had this
  explicitly brought to your attention for ack/nack.  Thanks -J ]

When using AGP under Xen, we need to be careful to
1) properly translate between physical and machine addresses, and
2) make sure memory is physically contigious when the hardware expects it

This change uses swiotlb_phys_to_bus/bus_to_phys to do the phys<->gart
conversion, since they already do the right thing, and dma_alloc_coherent
for gatt allocations.  This works equally well running native.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Airlie <airlied@linux.ie>

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


