Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYFQSmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYFQSmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYFQSmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:42:33 -0400
Received: from gw.goop.org ([64.81.55.164]:51603 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbYFQSmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:42:32 -0400
Message-ID: <4858056D.7000500@goop.org>
Date: Tue, 17 Jun 2008 11:41:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] x86: unify asm-x86/fixmap*.h
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost everything aside from the actual fixmap slot definitions is
common, so move it all into the common fixmap.h header.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/fixmap.h    |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/fixmap_32.h |   42 ------------------------------------------
 include/asm-x86/fixmap_64.h |   37 -------------------------------------
 3 files changed, 43 insertions(+), 79 deletions(-)

===================================================================
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -7,7 +7,50 @@
 # include "fixmap_64.h"
 #endif
 
+extern void __set_fixmap(enum fixed_addresses idx,
+			 unsigned long phys, pgprot_t flags);
+#define set_fixmap(idx, phys)				\
+	__set_fixmap(idx, phys, PAGE_KERNEL)
+
+/*
+ * Some hardware wants to get fixmapped without caching.
+ */
+#define set_fixmap_nocache(idx, phys)			\
+	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
+
 #define clear_fixmap(idx)			\
 	__set_fixmap(idx, 0, __pgprot(0))
 
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without translation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		__this_fixmap_does_not_exist();
+
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
 #endif
===================================================================
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -109,17 +109,8 @@
 	__end_of_fixed_addresses
 };
 
-extern void __set_fixmap(enum fixed_addresses idx,
-			 unsigned long phys, pgprot_t flags);
 extern void reserve_top_address(unsigned long reserve);
 
-#define set_fixmap(idx, phys)				\
-	__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys)			\
-	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 
@@ -128,38 +119,5 @@
 #define FIXADDR_START		(FIXADDR_TOP - __FIXADDR_SIZE)
 #define FIXADDR_BOOT_START	(FIXADDR_TOP - __FIXADDR_BOOT_SIZE)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without tranlation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static __always_inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * this branch gets completely eliminated after inlining,
-	 * except when someone tries to use fixaddr indices in an
-	 * illegal way. (such as mixing up address types or using
-	 * out-of-range indices).
-	 *
-	 * If it doesn't get removed, the linker will complain
-	 * loudly with a reasonably clear error message..
-	 */
-	if (idx >= __end_of_fixed_addresses)
-		__this_fixmap_does_not_exist();
-
-	return __fix_to_virt(idx);
-}
-
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
-
 #endif /* !__ASSEMBLY__ */
 #endif
===================================================================
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -65,17 +65,6 @@
 	__end_of_fixed_addresses
 };
 
-extern void __set_fixmap(enum fixed_addresses idx,
-			 unsigned long phys, pgprot_t flags);
-
-#define set_fixmap(idx, phys)			\
-	__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys)			\
-	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
-
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
@@ -84,30 +73,4 @@
 #define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
 #define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without translation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static __always_inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * this branch gets completely eliminated after inlining,
-	 * except when someone tries to use fixaddr indices in an
-	 * illegal way. (such as mixing up address types or using
-	 * out-of-range indices).
-	 *
-	 * If it doesn't get removed, the linker will complain
-	 * loudly with a reasonably clear error message..
-	 */
-	if (idx >= __end_of_fixed_addresses)
-		__this_fixmap_does_not_exist();
-
-	return __fix_to_virt(idx);
-}
-
 #endif


