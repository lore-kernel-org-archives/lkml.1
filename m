Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZFAPdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZFAPdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZFAPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:10 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54264 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZFAPdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:07 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="4484691"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Kirch <okir@suse.de>,
       Greg KH <gregkh@suse.de>, <x86@kernel.org>
Subject: [PATCH 02/11] x86: introduce arch-specific dma-mapping interface
Date: Mon, 1 Jun 2009 16:32:54 +0100
Message-ID: <1243870383-12954-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_map_range is intended to replace usage of both
swiotlb_arch_range_needs_mapping and
swiotlb_arch_address_needs_mapping as __weak functions as well as
replacing is_buffer_dma_capable.

phys_to_dma and dma_to_phys are intended to replace
swiotlb_phys_to_bus and swiotlb_bus_to_phys.  I choose to use dma
rather than bus since a) it matches the parameters and b) avoids
confusion on x86 with the existing (but deprecated) virt_to_bus
function which relates to ISA device DMA.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Greg KH <gregkh@suse.de>
Cc: x86@kernel.org
---
 arch/x86/include/asm/dma-mapping.h |    7 +++++++
 arch/x86/kernel/pci-dma.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 916cbb6..be8cb22 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -47,6 +47,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
+extern dma_addr_t phys_to_dma(struct device *hwdev, phys_addr_t paddr);
+extern phys_addr_t dma_to_phys(struct device *hwdev, dma_addr_t daddr);
+
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
@@ -309,4 +312,8 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 		ops->free_coherent(dev, size, vaddr, bus);
 }
 
+extern bool dma_map_range(struct device *dev, u64 mask,
+			  phys_addr_t addr, size_t size,
+			  dma_addr_t *dma_addr_p);
+
 #endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 745579b..f4c1b03 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -59,6 +59,32 @@ int dma_set_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
+dma_addr_t phys_to_dma(struct device *hwdev, phys_addr_t paddr)
+{
+	return paddr;
+}
+EXPORT_SYMBOL_GPL(phys_to_dma);
+
+phys_addr_t dma_to_phys(struct device *hwdev, dma_addr_t daddr)
+{
+	return daddr;
+}
+EXPORT_SYMBOL_GPL(dma_to_phys);
+
+bool dma_map_range(struct device *dev, u64 mask,
+		   phys_addr_t addr, size_t size,
+		   dma_addr_t *dma_addr_p)
+{
+	dma_addr_t dma_addr = phys_to_dma(dev, addr);
+
+	if (dma_addr + size > mask)
+		return false;
+
+	*dma_addr_p = dma_addr;
+	return true;
+}
+EXPORT_SYMBOL_GPL(dma_map_range);
+
 #ifdef CONFIG_X86_64
 static __initdata void *dma32_bootmem_ptr;
 static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
-- 
1.5.6.5

