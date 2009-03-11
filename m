Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZCKOdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZCKOdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZCKOdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:33:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:54585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZCKOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AwcQLWvIvykyg+ESMaN8ZkFzafHfWrlSZ2/mjHZJTzk6wL2eYN7ndK4UJSz60/kQ5j
         5e9tSGx4+720LPDUhD1Hn/BLuVwESogf3jLbt7/fTBq8/UmUo81wWq/ul/+HOOVeyZ7u
         V1jvx5Eyze9+59/5VN1qNa2PbGx/YhaFgRvWI=
Date: Wed, 11 Mar 2009 23:33:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 1/2] x86: unify kmap_atomic_pfn() and
	iomap_atomic_prot_pfn()
Message-ID: <20090311143317.GA22244@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same except
pgprot. This patch removes the code duplication for these two functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
---
 arch/x86/include/asm/highmem.h |    1 +
 arch/x86/mm/highmem_32.c       |   17 +++++++++++------
 arch/x86/mm/iomap_32.c         |   13 ++-----------
 3 files changed, 14 insertions(+), 17 deletions(-)

Index: 2.6-mmotm/arch/x86/include/asm/highmem.h
===================================================================
--- 2.6-mmotm.orig/arch/x86/include/asm/highmem.h
+++ 2.6-mmotm/arch/x86/include/asm/highmem.h
@@ -63,6 +63,7 @@ void *kmap_atomic_prot(struct page *page
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
 
 #ifndef CONFIG_PARAVIRT
Index: 2.6-mmotm/arch/x86/mm/highmem_32.c
===================================================================
--- 2.6-mmotm.orig/arch/x86/mm/highmem_32.c
+++ 2.6-mmotm/arch/x86/mm/highmem_32.c
@@ -121,23 +121,28 @@ void kunmap_atomic(void *kvaddr, enum km
 	pagefault_enable();
 }
 
-/* This is the same as kmap_atomic() but can map memory that doesn't
- * have a struct page associated with it.
- */
-void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
 
 	pagefault_disable();
 
-	idx = type + KM_TYPE_NR*smp_processor_id();
+	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
+	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
 	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
+
+/* This is the same as kmap_atomic() but can map memory that doesn't
+ * have a struct page associated with it.
+ */
+void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+{
+	return kmap_atomic_prot_pfn(pfn, type, kmap_prot);
+}
 EXPORT_SYMBOL_GPL(kmap_atomic_pfn); /* temporarily in use by i915 GEM until vmap */
 
 struct page *kmap_atomic_to_page(void *ptr)
Index: 2.6-mmotm/arch/x86/mm/iomap_32.c
===================================================================
--- 2.6-mmotm.orig/arch/x86/mm/iomap_32.c
+++ 2.6-mmotm/arch/x86/mm/iomap_32.c
@@ -18,6 +18,7 @@
 
 #include <asm/iomap.h>
 #include <asm/pat.h>
+#include <asm/highmem.h>
 #include <linux/module.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
@@ -36,11 +37,6 @@ EXPORT_SYMBOL_GPL(is_io_mapping_possible
 void *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 {
-	enum fixed_addresses idx;
-	unsigned long vaddr;
-
-	pagefault_disable();
-
 	/*
 	 * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
 	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
@@ -50,12 +46,7 @@ iomap_atomic_prot_pfn(unsigned long pfn,
 	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
 		prot = PAGE_KERNEL_UC_MINUS;
 
-	idx = type + KM_TYPE_NR*smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
-
-	return (void*) vaddr;
+	return kmap_atomic_prot_pfn(pfn, type, prot);
 }
 EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
 
