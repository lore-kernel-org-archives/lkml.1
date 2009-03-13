Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZCMBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZCMBlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZCMBlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:41:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:46636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZCMBlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:41:00 -0400
Date: Fri, 13 Mar 2009 01:39:31 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090311143317.GA22244@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain>
Subject: [tip:x86/mm] x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix
Message-ID: <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org>
Git-Commit-ID: dd63fdcc63f0f853b116b52e56200a0e0227cf5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 01:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd63fdcc63f0f853b116b52e56200a0e0227cf5f
Gitweb:     http://git.kernel.org/tip/dd63fdcc63f0f853b116b52e56200a0e0227cf5f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 03:20:49 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 03:24:53 +0100

x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix

Impact: build fix

Move kmap_atomic_prot_pfn() to iomap_32.c. It is used on all 32-bit
kernels, while highmem_32.c is only built on highmem kernels.

( Note: the debug_kmap_atomic_prot() check is removed for now, that
  problem is handled via another patch. )

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090311143317.GA22244@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |   20 ++------------------
 arch/x86/mm/iomap_32.c   |   18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index f256e73..522db5e 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -121,24 +121,8 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 	pagefault_enable();
 }
 
-void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
-{
-	enum fixed_addresses idx;
-	unsigned long vaddr;
-
-	pagefault_disable();
-
-	debug_kmap_atomic_prot(type);
-
-	idx = type + KM_TYPE_NR * smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
-
-	return (void*) vaddr;
-}
-
-/* This is the same as kmap_atomic() but can map memory that doesn't
+/*
+ * This is the same as kmap_atomic() but can map memory that doesn't
  * have a struct page associated with it.
  */
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 592984e..6e60ba6 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -32,7 +32,23 @@ int is_io_mapping_possible(resource_size_t base, unsigned long size)
 }
 EXPORT_SYMBOL_GPL(is_io_mapping_possible);
 
-/* Map 'pfn' using fixed map 'type' and protections 'prot'
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	pagefault_disable();
+
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
+	arch_flush_lazy_mmu_mode();
+
+	return (void *)vaddr;
+}
+
+/*
+ * Map 'pfn' using fixed map 'type' and protections 'prot'
  */
 void *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
