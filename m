Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZCNEVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZCNEVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZCNEVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:21:38 -0400
Received: from mail-gx0-f163.google.com ([209.85.217.163]:49775 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZCNEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sU0IqnuD9rNA5JWgO2GbGE5Hwt4YjJfcWhulooTggFzL66briWXzuW8RMaPerbwKN2
         KCHO9KckOR/jvkPsu/IDnBH8nBmgasph2LwWLkQUHqV3X97QxT5voQSRnE6Mcv2u5AVv
         wbb8MzwALPjlSmUdNPBBGBptdX5qvANrT4Y/M=
Date: Sat, 14 Mar 2009 13:20:56 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: [PATCH -tip 2/2] mm: use debug_kmap_atomic
Message-ID: <20090314042054.GB3697@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain> <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org> <20090314041948.GA3697@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090314041948.GA3697@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: use debug_kmap_atomic
From: Akinobu Mita <akinobu.mita@gmail.com>

Use debug_kmap_atomic in kmap_atomic, kmap_atomic_pfn, kmap_atomic_prot and
iomap_atomic_prot_pfn.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/mips/mm/highmem.c             |    2 ++
 arch/powerpc/include/asm/highmem.h |    2 ++
 arch/sparc/mm/highmem.c            |    1 +
 arch/x86/mm/iomap_32.c             |    3 ++-
 include/asm-frv/highmem.h          |    2 ++
 include/asm-mn10300/highmem.h      |    2 ++
 6 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/mips/mm/highmem.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/mm/highmem.c
+++ linux-2.6-tip/arch/mips/mm/highmem.c
@@ -43,6 +43,7 @@ void *__kmap_atomic(struct page *page, e
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -91,6 +92,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
Index: linux-2.6-tip/arch/powerpc/include/asm/highmem.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/highmem.h
+++ linux-2.6-tip/arch/powerpc/include/asm/highmem.h
@@ -24,6 +24,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/highmem.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
@@ -94,6 +95,7 @@ static inline void *kmap_atomic_prot(str
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
Index: linux-2.6-tip/arch/sparc/mm/highmem.c
===================================================================
--- linux-2.6-tip.orig/arch/sparc/mm/highmem.c
+++ linux-2.6-tip/arch/sparc/mm/highmem.c
@@ -39,6 +39,7 @@ void *kmap_atomic(struct page *page, enu
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
Index: linux-2.6-tip/arch/x86/mm/iomap_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/mm/iomap_32.c
+++ linux-2.6-tip/arch/x86/mm/iomap_32.c
@@ -18,8 +18,8 @@
 
 #include <asm/iomap.h>
 #include <asm/pat.h>
-#include <asm/highmem.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
@@ -39,6 +39,7 @@ void *kmap_atomic_prot_pfn(unsigned long
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
Index: linux-2.6-tip/include/asm-frv/highmem.h
===================================================================
--- linux-2.6-tip.orig/include/asm-frv/highmem.h
+++ linux-2.6-tip/include/asm-frv/highmem.h
@@ -18,6 +18,7 @@
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#include <linux/highmem.h>
 #include <asm/mem-layout.h>
 #include <asm/spr-regs.h>
 #include <asm/mb-regs.h>
@@ -116,6 +117,7 @@ static inline void *kmap_atomic(struct p
 	unsigned long paddr;
 
 	pagefault_disable();
+	debug_kmap_atomic(type);
 	paddr = page_to_phys(page);
 
 	switch (type) {
Index: linux-2.6-tip/include/asm-mn10300/highmem.h
===================================================================
--- linux-2.6-tip.orig/include/asm-mn10300/highmem.h
+++ linux-2.6-tip/include/asm-mn10300/highmem.h
@@ -16,6 +16,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/highmem.h>
 #include <asm/kmap_types.h>
 #include <asm/pgtable.h>
 
@@ -77,6 +78,7 @@ static inline unsigned long kmap_atomic(
 	if (page < highmem_start_page)
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #if HIGHMEM_DEBUG
