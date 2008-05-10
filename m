Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYEJCMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYEJCMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYEJCK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:10:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54336 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbYEJCKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:10:22 -0400
Message-Id: <20080510021021.472932504@sgi.com>
References: <20080510020947.803480649@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:09:53 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: travis@sgi.com
Subject: [patch 6/6] x86: Add checks for virtual addresses in __phys_addr()
Content-Disposition: inline; filename=vcp_check_virtual_addresses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checks to insure that virtual addresses are not used in invalid contexts.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/mm/ioremap.c     |   15 +++++++--------
 include/asm-x86/page_32.h |    7 ++++++-
 2 files changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c	2008-05-07 16:27:09.792659191 -0700
+++ linux-2.6/arch/x86/mm/ioremap.c	2008-05-07 19:46:34.733509101 -0700
@@ -21,29 +21,28 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-#ifdef CONFIG_X86_64
 
+#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_X86_64)
 unsigned long __phys_addr(unsigned long x)
 {
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
+#ifdef CONFIG_X86_64
 	if (x >= __START_KERNEL_map)
 		return x - __START_KERNEL_map + phys_base;
+#endif
 	return x - PAGE_OFFSET;
 }
 EXPORT_SYMBOL(__phys_addr);
+#endif
 
 static inline int phys_addr_valid(unsigned long addr)
 {
+#ifdef CONFIG_X86_64
 	return addr < (1UL << boot_cpu_data.x86_phys_bits);
-}
-
 #else
-
-static inline int phys_addr_valid(unsigned long addr)
-{
 	return 1;
-}
-
 #endif
+}
 
 int page_is_ram(unsigned long pagenr)
 {
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h	2008-05-07 16:27:12.191419001 -0700
+++ linux-2.6/include/asm-x86/page_32.h	2008-05-07 19:30:46.444980299 -0700
@@ -64,7 +64,12 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+#ifdef CONFIG_DEBUG_VM
+unsigned long __phys_addr(unsigned long x)
+#else
+#define __phys_addr(x)	((x) - PAGE_OFFSET)
+#endif
+
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM

-- 
