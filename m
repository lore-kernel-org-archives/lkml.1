Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbYGBBD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbYGBBD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbYGBBBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:01:52 -0400
Received: from gw.goop.org ([64.81.55.164]:58677 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbYGBBBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 8] x86_32: remove __PAGE_KERNEL(_EXEC)
X-Mercurial-Node: 2883837d8dc7ef53f1f92dca409be612eefe333b
Message-Id: <2883837d8dc7ef53f1f9.1214955996@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older x86-32 processors do not support global mappings (PGD), so must
only use it if the processor supports it.

The _PAGE_KERNEL* flags always have _PAGE_KERNEL set, since logically
we always want it set.

This is OK even on processors which do not support PGD, since all
_PAGE flags are masked with __supported_pte_mask before being turned
into a real in-pagetable pte.  On 32-bit systems, __supported_pte_mask
is initialized to not contain _PAGE_GLOBAL, and it is then added if
the CPU is found to support it.

The x86-32 code used to use __PAGE_KERNEL/__PAGE_KERNEL_EXEC for this
purpose, but they're now redundant and can be removed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_32.c     |   10 ++--------
 include/asm-x86/pgtable.h |   10 ----------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -383,11 +383,6 @@
 # define set_highmem_pages_init()	do { } while (0)
 #endif /* CONFIG_HIGHMEM */
 
-pteval_t __PAGE_KERNEL = _PAGE_KERNEL;
-EXPORT_SYMBOL(__PAGE_KERNEL);
-
-pteval_t __PAGE_KERNEL_EXEC = _PAGE_KERNEL_EXEC;
-
 void __init native_pagetable_setup_start(pgd_t *base)
 {
 	unsigned long pfn, va;
@@ -509,7 +504,7 @@
 
 int nx_enabled;
 
-pteval_t __supported_pte_mask __read_mostly = ~_PAGE_NX;
+pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
@@ -803,8 +798,7 @@
 	/* Enable PGE if available */
 	if (cpu_has_pge) {
 		set_in_cr4(X86_CR4_PGE);
-		__PAGE_KERNEL |= _PAGE_GLOBAL;
-		__PAGE_KERNEL_EXEC |= _PAGE_GLOBAL;
+		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
 	/*
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -78,19 +78,9 @@
 #define PAGE_READONLY_EXEC	__pgprot(_PAGE_PRESENT | _PAGE_USER |	\
 					 _PAGE_ACCESSED)
 
-#ifdef CONFIG_X86_32
-#define _PAGE_KERNEL_EXEC \
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
-#define _PAGE_KERNEL (_PAGE_KERNEL_EXEC | _PAGE_NX)
-
-#ifndef __ASSEMBLY__
-extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
-#endif	/* __ASSEMBLY__ */
-#else
 #define __PAGE_KERNEL_EXEC						\
 	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
-#endif
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)


