Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbZE0HXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbZE0HXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbZE0HS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:18:26 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:50357 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761138AbZE0HSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:18:24 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 10/29] microblaze_mmu_v2: io.h MMU update
Date: Wed, 27 May 2009 08:47:35 +0200
Message-Id: <1243406874-3917-11-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-10-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/io.h |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index 8b5853e..5c17342 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -12,6 +14,9 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/types.h>
+#include <asm/byteorder.h>
+#include <linux/mm.h>          /* Get struct page {...} */
+
 
 #define IO_SPACE_LIMIT (0xFFFFFFFF)
 
@@ -112,6 +117,30 @@ static inline void writel(unsigned int v, volatile void __iomem *addr)
 #define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
 #define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
 
+#ifdef CONFIG_MMU
+
+#define mm_ptov(addr)		((void *)__phys_to_virt(addr))
+#define mm_vtop(addr)		((unsigned long)__virt_to_phys(addr))
+#define phys_to_virt(addr)	((void *)__phys_to_virt(addr))
+#define virt_to_phys(addr)	((unsigned long)__virt_to_phys(addr))
+#define virt_to_bus(addr)	((unsigned long)__virt_to_phys(addr))
+
+#define __page_address(page) \
+		(PAGE_OFFSET + (((page) - mem_map) << PAGE_SHIFT))
+#define page_to_phys(page)	virt_to_phys((void *)__page_address(page))
+#define page_to_bus(page)	(page_to_phys(page))
+#define bus_to_virt(addr)	(phys_to_virt(addr))
+
+extern void iounmap(void *addr);
+/*extern void *__ioremap(phys_addr_t address, unsigned long size,
+		unsigned long flags);*/
+extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
+#define ioremap_writethrough(addr, size) ioremap((addr), (size))
+#define ioremap_nocache(addr, size)      ioremap((addr), (size))
+#define ioremap_fullcache(addr, size)    ioremap((addr), (size))
+
+#else /* CONFIG_MMU */
+
 /**
  *	virt_to_phys - map virtual addresses to physical
  *	@address: address to remap
@@ -160,6 +189,8 @@ static inline void __iomem *__ioremap(phys_addr_t address, unsigned long size,
 #define iounmap(addr)		((void)0)
 #define ioremap_nocache(physaddr, size)	ioremap(physaddr, size)
 
+#endif /* CONFIG_MMU */
+
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
-- 
1.5.5.1

