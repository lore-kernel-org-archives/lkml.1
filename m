Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYJCOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYJCOH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYJCOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:07:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:5670 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYJCOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ZIjZzUGHa97H1Lc5Z2eWYbHD4xtBwZOBQatBS/8xDwSdBYhZBjerLr8eJ6AxkCcX8u
         oQv6ThA8dZOXuI4ZjORoH9pZB95YwSAfGtxFTstymy1E7nZ484u/UcIZGWQLQVjMTu7v
         uIbEF+v/JtwGg89UDQ78/jrW4RrMG3h0DHPaU=
Date: Fri, 3 Oct 2008 16:07:20 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86: fix virt_addr_valid() with
	CONFIG_DEBUG_VIRTUAL=y (try 2)
Message-ID: <20081003140720.GA14261@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this? It would apply to tip/x86/mm-debug. Untested.

Vegard


>From 27f365e4a7b3e76e5f01af1056c47ca1fcf226d8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 3 Oct 2008 15:58:50 +0200
Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y

virt_addr_valid() calls __pa(), which calls __phys_addr(). With
CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
address *isn't* valid. That's clearly wrong for virt_addr_valid().

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
---
 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/mm/ioremap.c            |   12 ++++++++++++
 include/asm-x86/page.h           |    3 ++-
 include/asm-x86/page_32.h        |    4 ++--
 include/asm-x86/page_64.h        |    1 +
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index 395acb1..b4f14c6 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
 		.ds		= __USER_DS,
 		.fs		= __KERNEL_PERCPU,
 
-		.__cr3		= __phys_addr_const((unsigned long)swapper_pg_dir)
+		.__cr3		= __pa_nodebug(swapper_pg_dir),
 	}
 };
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 835e062..2d5e6de 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -29,6 +29,18 @@ static inline int phys_addr_valid(unsigned long addr)
 	return addr < (1UL << boot_cpu_data.x86_phys_bits);
 }
 
+unsigned long __phys_addr_nodebug(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		x += phys_base;
+	} else {
+		x -= PAGE_OFFSET;
+	}
+
+	return x;
+}
+
 unsigned long __phys_addr(unsigned long x)
 {
 	if (x >= __START_KERNEL_map) {
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index c915747..9b70b41 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -179,6 +179,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
@@ -190,7 +191,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid(__pa_nodebug(kaddr) >> PAGE_SHIFT)
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 82b0109..deec501 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -71,11 +71,11 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr_const(x)	((x) - PAGE_OFFSET)
+#define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
 #else
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+#define __phys_addr(x)		__phys_addr_nodebug(x)
 #endif
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index 49380b8..d2a851e 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -68,6 +68,7 @@ void copy_page(void *to, void *from);
 extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
+extern unsigned long __phys_addr_nodebug(unsigned long);
 extern unsigned long __phys_addr(unsigned long);
 #define __phys_reloc_hide(x)	(x)
 
-- 
1.5.5.1

