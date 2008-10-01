Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYJALQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYJALQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYJALQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:16:25 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50696 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYJALQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:16:24 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2008 07:16:24 EDT
Date: Wed, 1 Oct 2008 12:47:17 +0200
From: Vegard Nossum <vegardno@ifi.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Message-ID: <20081001104717.GA7925@ben.ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 685C2748251C304DC9ED1AA975DA7D5D5697BA94
X-UiO-SPAM-Test: remote_host: 129.240.64.202 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 7 total 4728 max/h 935 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Fix for tip/x86/mm-debug (commit 59ea746337c69f6a5f1bc4d5e8544b3cbf12f801).
I'm not sure if choice of names/structure is entirely correct, comments are
appreciated.


Vegard


>From 01613a1949de51c7ab9d0acaaa9a5444722a5cfa Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegardno@ben.ifi.uio.no>
Date: Wed, 1 Oct 2008 12:36:34 +0200
Subject: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y

virt_addr_valid() calls __pa(), which calls __phys_addr(). With
CONFIG_DEBUG_VIRTUAL=y, __phys_addr() will kill the kernel if the
address *isn't* valid. That's clearly wrong for virt_addr_valid().

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Vegard Nossum <vegardno@ben.ifi.uio.no>
---
 arch/x86/kernel/doublefault_32.c |    2 +-
 arch/x86/mm/ioremap.c            |    2 +-
 include/asm-x86/page.h           |    3 ++-
 include/asm-x86/page_32.h        |    4 ++--
 include/asm-x86/page_64.h        |    1 +
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index 395acb1..1580e0b 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
 		.ds		= __USER_DS,
 		.fs		= __KERNEL_PERCPU,
 
-		.__cr3		= __phys_addr_const((unsigned long)swapper_pg_dir)
+		.__cr3	= __phys_addr_nodebug((unsigned long)swapper_pg_dir)
 	}
 };
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 835e062..4d49e88 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -58,7 +58,7 @@ unsigned long __phys_addr(unsigned long x)
 	/* VMALLOC_* aren't constants; not available at the boot time */
 	VIRTUAL_BUG_ON(x < PAGE_OFFSET || (system_state != SYSTEM_BOOTING &&
 					is_vmalloc_addr((void *)x)));
-	return x - PAGE_OFFSET;
+	return __phys_addr_nodebug(x);
 }
 EXPORT_SYMBOL(__phys_addr);
 #endif
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
index 49380b8..8697b6f 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -69,6 +69,7 @@ extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
+#define __phys_addr_nodebug(x) __phys_addr(x)
 #define __phys_reloc_hide(x)	(x)
 
 /*
-- 
1.5.6.4

