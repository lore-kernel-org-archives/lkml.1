Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZCKQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZCKQzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZCKQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:55:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbZCKQzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:55:14 -0400
Date: Wed, 11 Mar 2009 16:54:27 GMT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090311143317.GA22244@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain>
Subject: [tip:x86/mm] x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn()
Message-ID: <tip-bb6d59ca927d855ffac567b35c0a790c67016103@git.kernel.org>
Git-Commit-ID: bb6d59ca927d855ffac567b35c0a790c67016103
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 16:54:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb6d59ca927d855ffac567b35c0a790c67016103
Gitweb:     http://git.kernel.org/tip/bb6d59ca927d855ffac567b35c0a790c67016103
Author:     "Akinobu Mita" <akinobu.mita@gmail.com>
AuthorDate: Wed, 11 Mar 2009 23:33:18 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Mar 2009 15:47:46 +0100

x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn()

kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same
except pgprot. This patch removes the code duplication for these
two functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090311143317.GA22244@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/highmem.h |    1 +
 arch/x86/mm/highmem_32.c       |   17 +++++++++++------
 arch/x86/mm/iomap_32.c         |   13 ++-----------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index bf9276b..014c2b8 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -63,6 +63,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
 
 #ifndef CONFIG_PARAVIRT
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index d117453..ae4c8da 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -121,23 +121,28 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
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
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 04102d4..592984e 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -18,6 +18,7 @@
 
 #include <asm/iomap.h>
 #include <asm/pat.h>
+#include <asm/highmem.h>
 #include <linux/module.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
@@ -36,11 +37,6 @@ EXPORT_SYMBOL_GPL(is_io_mapping_possible);
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
@@ -50,12 +46,7 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
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
 
