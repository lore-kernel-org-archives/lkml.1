Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYAJXXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYAJXXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYAJXXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:23:10 -0500
Received: from gw.goop.org ([64.81.55.164]:35216 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbYAJXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:23:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 2] x86: fold _PAGE_GLOBAL into __PAGE_KERNEL
X-Mercurial-Node: 4a84dc33e9912b58d8e58a1fcd3deeb569dd58fc
Message-Id: <4a84dc33e9912b58d8e5.1200004570@localhost>
In-Reply-To: <patchbomb.1200004569@localhost>
Date: Thu, 10 Jan 2008 14:36:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the iounmap problem resolved, it should be OK to always set
_PAGE_GLOBAL in __PAGE_KERNEL*.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/ioremap_64.c  |    2 +-
 include/asm-x86/pgtable.h |   26 ++++++++++----------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/ioremap_64.c b/arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -50,7 +50,7 @@ ioremap_change_attr(unsigned long phys_a
 		 * memmap entry:
 		 */
 		err = change_page_attr_addr(vaddr, npages,
-					    MAKE_GLOBAL(__PAGE_KERNEL|flags));
+					    __pgprot(__PAGE_KERNEL|flags));
 		if (!err)
 			global_flush_tlb();
 	}
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -68,7 +68,7 @@ extern unsigned long long __PAGE_KERNEL,
 #endif	/* __ASSEMBLER__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
@@ -80,21 +80,15 @@ extern unsigned long long __PAGE_KERNEL,
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
-#ifdef CONFIG_X86_32
-# define MAKE_GLOBAL(x)			__pgprot((x))
-#else
-# define MAKE_GLOBAL(x)			__pgprot((x) | _PAGE_GLOBAL)
-#endif
-
-#define PAGE_KERNEL			MAKE_GLOBAL(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO			MAKE_GLOBAL(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
-#define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
-#define PAGE_KERNEL_VSYSCALL		MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
 /*         xwr */
 #define __P000	PAGE_NONE


