Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYJDILy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYJDILy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYJDILh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:11:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYJDILg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:11:36 -0400
Date: Sat, 4 Oct 2008 10:11:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -tip] x86: fix virt_addr_valid() with
	CONFIG_DEBUG_VIRTUAL=y (try 2)
Message-ID: <20081004081122.GA27624@elte.hu>
References: <20081003155425.GA6112@localhost.localdomain> <48E6604F.8000404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E6604F.8000404@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Vegard Nossum napsal(a):
> > Is this what you had in mind? If not, then I don't know how to do it :-)
> 
> Yeah, something like that, but I am not the one you need ACK from ;).

ok - i've applied the commit below to tip/x86/core to get some testing 
of it.

	Ingo

------------>
>From fe45d9c75945698006a608a8fcccf39d161b0669 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 3 Oct 2008 17:54:25 +0200
Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y, v2

virt_addr_valid() calls __pa(), which calls __phys_addr(). With
CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
address *isn't* valid. That's clearly wrong for virt_addr_valid().

We also incorporate the debugging checks into virt_addr_valid().

Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/mm/ioremap.c            |   36 ++++++++++++++++++++++++++++++++++--
 include/asm-x86/page.h           |    8 +++++++-
 include/asm-x86/page_32.h        |    4 ++--
 4 files changed, 44 insertions(+), 6 deletions(-)

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
index 7955a5a..e6e57fe 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -45,6 +45,27 @@ unsigned long __phys_addr(unsigned long x)
 }
 EXPORT_SYMBOL(__phys_addr);
 
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		if (x >= KERNEL_IMAGE_SIZE)
+			return false;
+		x += phys_base;
+	} else {
+		if (x < PAGE_OFFSET)
+			return false;
+		x -= PAGE_OFFSET;
+		if (system_state == SYSTEM_BOOTING ?
+				x > MAXMEM : !phys_addr_valid(x)) {
+			return false;
+		}
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
 #else
 
 static inline int phys_addr_valid(unsigned long addr)
@@ -56,13 +77,24 @@ static inline int phys_addr_valid(unsigned long addr)
 unsigned long __phys_addr(unsigned long x)
 {
 	/* VMALLOC_* aren't constants; not available at the boot time */
-	VIRTUAL_BUG_ON(x < PAGE_OFFSET || (system_state != SYSTEM_BOOTING &&
-					is_vmalloc_addr((void *)x)));
+	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+	VIRTUAL_BUG_ON(system_state != SYSTEM_BOOTING &&
+		is_vmalloc_addr((void *) x));
 	return x - PAGE_OFFSET;
 }
 EXPORT_SYMBOL(__phys_addr);
 #endif
 
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x < PAGE_OFFSET)
+		return false;
+	if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
+		return false;
+	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
 #endif
 
 int page_is_ram(unsigned long pagenr)
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 79544e6..0495171 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -178,6 +178,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
@@ -187,9 +188,14 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
 
+/*
+ * virt_to_page(kaddr) returns a valid pointer if and only if
+ * virt_addr_valid(kaddr) returns true.
+ */
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+extern bool __virt_addr_valid(unsigned long kaddr);
+#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index fe86ee2..3a3e4b7 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -73,11 +73,11 @@ typedef struct page *pgtable_t;
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
 
