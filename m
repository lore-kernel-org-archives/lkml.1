Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYKPOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYKPOs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYKPOr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:47:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:44826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYKPOrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:47:51 -0500
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/3] Unify devmem_is_allowed across architectures
Date: Sun, 16 Nov 2008 15:47:46 +0100
Message-Id: <1226846868-9595-2-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1226846868-9595-1-git-send-email-bwalle@suse.de>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies devmem_is_allowed() across different architectures.
It removes the devmem_is_allowed 1 defines from m32r and frv and
adds a generic fallback implementation to <asm-generic/page.h>.

Architecutes can define their version and define __HAVE_ARCH_RANGE_IS_ALLOWED.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/include/asm/page.h |    1 +
 include/asm-frv/page.h      |    2 --
 include/asm-generic/page.h  |    4 ++++
 include/asm-m32r/page.h     |    2 --
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index e9873a2..b768401 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -63,6 +63,7 @@ extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);
 extern void unmap_devmem(unsigned long pfn, unsigned long size,
 			 pgprot_t vma_prot);
+#define __HAVE_ARCH_RANGE_IS_ALLOWED 1
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
diff --git a/include/asm-frv/page.h b/include/asm-frv/page.h
index bd9c220..bc2c835 100644
--- a/include/asm-frv/page.h
+++ b/include/asm-frv/page.h
@@ -40,8 +40,6 @@ typedef struct page *pgtable_t;
 #define __pgprot(x)	((pgprot_t) { (x) } )
 #define PTE_MASK	PAGE_MASK
 
-#define devmem_is_allowed(pfn)	1
-
 #define __pa(vaddr)		virt_to_phys((void *) (unsigned long) (vaddr))
 #define __va(paddr)		phys_to_virt((unsigned long) (paddr))
 
diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index 14db733..cde4ceb 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -19,6 +19,10 @@ static __inline__ __attribute_const__ int get_order(unsigned long size)
 	return order;
 }
 
+#ifndef __HAVE_ARCH_RANGE_IS_ALLOWED
+#define devmem_is_allowed(pfn)	1
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* _ASM_GENERIC_PAGE_H */
diff --git a/include/asm-m32r/page.h b/include/asm-m32r/page.h
index c933308..89d6b10 100644
--- a/include/asm-m32r/page.h
+++ b/include/asm-m32r/page.h
@@ -79,8 +79,6 @@ typedef struct page *pgtable_t;
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC )
 
-#define devmem_is_allowed(x) 1
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-- 
1.6.0.4

