Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZLAKid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZLAKid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZLAKid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:38:33 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:54517 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZLAKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:38:32 -0500
From: Li Yang <leoli@freescale.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Li Yang <leoli@freescale.com>
Subject: [PATCH] powerpc/mm: setting mmaped page cache property through device tree
Date: Tue,  1 Dec 2009 18:30:50 +0800
Message-Id: <1259663450-28790-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 01 Dec 2009 10:38:24.0868 (UTC) FILETIME=[691AC240:01CA7272]
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds the ability for powerpc architecture to set page cache
property of mmaped area through device tree.  This is useful for two
cases.  First, for memory shared with other OS'es to have the same cache
property to avoid cache paradoxes.  Second, enabling application to map
memory which is not managed by kernel as cacheable for better performance.

Signed-off-by: Li Yang <leoli@freescale.com>
---
Although it will be better if we can come up with a generic solution
not only for powerpc arch.  Changing the behavior of O_SYNC seems to
draw concerns over compatibility of old applications.  Suggestions
are welcomed.

 arch/powerpc/mm/mem.c          |   49 +++++++++++++++++++++++++++++++++++++--
 arch/powerpc/platforms/Kconfig |    7 +++++
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 579382c..02da2c8 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -95,16 +95,59 @@ int page_is_ram(unsigned long pfn)
 #endif
 }
 
+#ifdef CONFIG_OF_MMAP_CACHE_PROPERTY
+pgprot_t pgprot_from_dt(unsigned long pfn, pgprot_t vma_prot)
+{
+	struct device_node *np;
+	struct resource res;
+	unsigned long paddr = (pfn << PAGE_SHIFT);
+	int i;
+	const int *prop;
+
+	for_each_node_by_name(np, "mmap-region")
+		for (i = 0; of_address_to_resource(np, i, &res) == 0; i++)
+			if ((paddr >= res.start) && (paddr <= res.end)) {
+				unsigned long _prot;
+				prop = of_get_property(np, "cache-property",
+						NULL);
+
+				if (prop == NULL)
+					return vma_prot;
+
+				_prot = pgprot_val(vma_prot) & ~_PAGE_CACHE_CTL;
+
+				/* bit map of WIMG */
+				if (*prop & 0x8)
+					_prot |= _PAGE_WRITETHRU;
+				if (*prop & 0x4)
+					_prot |= _PAGE_NO_CACHE;
+				if (*prop & 0x2)
+					_prot |= _PAGE_COHERENT;
+				if (*prop & 0x1)
+					_prot |= _PAGE_GUARDED;
+
+				return __pgprot(_prot);
+			}
+
+	return vma_prot;
+}
+#endif
+
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
 	if (ppc_md.phys_mem_access_prot)
 		return ppc_md.phys_mem_access_prot(file, pfn, size, vma_prot);
 
-	if (!page_is_ram(pfn))
-		vma_prot = pgprot_noncached(vma_prot);
+	/* kernel managed memory is always mapped as cacheable */
+	if (page_is_ram(pfn))
+		return vma_prot;
 
-	return vma_prot;
+#ifdef CONFIG_OF_MMAP_CACHE_PROPERTY
+	return pgprot_from_dt(pfn, vma_prot);
+#else
+	return pgprot_noncached(vma_prot);
+#endif
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 12bc2ce..de0f57c 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -333,4 +333,11 @@ config MCU_MPC8349EMITX
 	  also register MCU GPIOs with the generic GPIO API, so you'll able
 	  to use MCU pins as GPIOs.
 
+config OF_MMAP_CACHE_PROPERTY
+	bool "Support setting cache property of mmap through device tree"
+	default n
+	help
+	  Say Y here to support setting cache property of mmaped region via
+	  mmap-region device tree node.
+
 endmenu
-- 
1.6.4

