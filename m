Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYAQT3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYAQT3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYAQT3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:29:30 -0500
Received: from gw.goop.org ([64.81.55.164]:59900 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbYAQT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:29:29 -0500
Message-ID: <478FAC91.90109@goop.org>
Date: Thu, 17 Jan 2008 11:29:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]  x86: fold _PAGE_GLOBAL into __PAGE_KERNEL
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the iounmap problem resolved, it should be OK to always set
_PAGE_GLOBAL in __PAGE_KERNEL*.

[ Did this patch cause problems before? ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/ioremap_64.c  |    2 +-
 include/asm-x86/pgtable.h |   27 ++++++++++-----------------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff -r eaf8bc049cdb arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c	Thu Jan 17 10:37:45 2008 -0800
+++ b/arch/x86/mm/ioremap_64.c	Thu Jan 17 10:39:51 2008 -0800
@@ -79,7 +79,7 @@ void __iomem * __ioremap(unsigned long p
 	if (!size || last_addr < phys_addr)
 		return NULL;
 
-	pgprot = __pgprot(__PAGE_KERNEL_EXEC | _PAGE_GLOBAL | flags);
+	pgprot = __pgprot(__PAGE_KERNEL_EXEC | flags);
 	/*
 	 * Mappings have to be page-aligned
 	 */
diff -r eaf8bc049cdb include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h	Thu Jan 17 10:37:45 2008 -0800
+++ b/include/asm-x86/pgtable.h	Thu Jan 17 10:39:51 2008 -0800
@@ -78,7 +78,7 @@ extern unsigned long long __PAGE_KERNEL,
 #endif	/* __ASSEMBLY__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
@@ -90,21 +90,15 @@ extern unsigned long long __PAGE_KERNEL,
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

