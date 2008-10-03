Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYJCPye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYJCPye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYJCPyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:54:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:16246 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYJCPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=lhATI8ZXpOTuSO+A++qHscovTWfSwhbdLoiAylGdUfefO4konKayB9VL+jSE2Azfql
         KjUdfBSVbyEkPeDYw/8tsYh0X/kEh6ZHRYo2jVsvesXr+VPfCJLJrCnV5f+j33RNcV4O
         wK+nxHVflJHWNIz9b+VUG49mbn6+ewamiFS1w=
Date: Fri, 3 Oct 2008 17:54:25 +0200
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix virt_addr_valid() with
	CONFIG_DEBUG_VIRTUAL=y (try 2)
Message-ID: <20081003155425.GA6112@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E62AF7.5040008@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 4:23 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Vegard Nossum napsal(a):
>> How about this? It would apply to tip/x86/mm-debug. Untested.
>
> It is wrong in my eyes -- it's workarounding of the real problem rather than
> fixing. virt_addr_valid() should be fixed/augmented to the full virtual
> address domain instead or not used for the purpose you need in kmemcheck.
>
> As it is now, it should be used only on direct mapping addresses (more
> concrete: kernel image space and physical mapping) and it returns
> semi-random values on the rest -- with CONFIG_DEBUG_VIRTUAL=y it screams
> instead of returning a bogus value.
>

Is this what you had in mind? If not, then I don't know how to do it :-)

It seems that it might be structured in a better way -- but that better way
eludes my imagination. Thanks for commenting!


Vegard


>From 320c68f94e1a2071c64ecc9db6358801bd0c1f0b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 3 Oct 2008 15:58:50 +0200
Subject: [PATCH] x86: fix virt_addr_valid()

virt_addr_valid() calls __pa(), which calls __phys_addr(). With
CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
address *isn't* valid. That's clearly wrong for virt_addr_valid().

We also incorporate the debugging checks into virt_addr_valid().

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
---
 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/mm/ioremap.c            |   37 +++++++++++++++++++++++++++++++++++--
 include/asm-x86/page.h           |    8 +++++++-
 include/asm-x86/page_32.h        |    4 ++--
 4 files changed, 45 insertions(+), 6 deletions(-)

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
index 835e062..b20389d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -45,6 +45,28 @@ unsigned long __phys_addr(unsigned long x)
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
+		if (system_state == SYSTEM_BOOTING
+			? x > MAXMEM : !phys_addr_valid(x))
+		{
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
@@ -56,13 +78,24 @@ static inline int phys_addr_valid(unsigned long addr)
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
index c915747..d4f1d57 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -179,6 +179,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
@@ -188,9 +189,14 @@ static inline pteval_t native_pte_flags(pte_t pte)
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
 
-- 
1.5.5.1

