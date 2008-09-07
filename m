Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYIGWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYIGWY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYIGWYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:16 -0400
Received: from gw.goop.org ([64.81.55.164]:39650 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbYIGWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag for IO mappings
X-Mercurial-Node: 4d93ba619c716c45cca0b7042e4a4e493608917c
Message-Id: <4d93ba619c716c45cca0.1220826073@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one of the software-defined PTE bits to indicate that a mapping is
intended for an IO address.  On native hardware this is irrelevent,
since a physical address is a physical address.  But in a virtual
environment, physical addresses are also virtualized, so there needs
to be some way to distinguish between pseudo-physical addresses and
actual hardware addresses; _PAGE_IOMAP indicates this intent.

By default, __supported_pte_mask masks out _PAGE_IOMAP, so it doesn't
even appear in the final pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_32.c     |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 arch/x86/mm/ioremap.c     |    8 ++++----
 include/asm-x86/fixmap.h  |    2 +-
 include/asm-x86/pgtable.h |   14 ++++++++++++--
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -503,7 +503,7 @@
 
 int nx_enabled;
 
-pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
+pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -88,7 +88,7 @@
 
 int after_bootmem;
 
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
+pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 static int do_not_nx __cpuinitdata;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -223,16 +223,16 @@
 	switch (prot_val) {
 	case _PAGE_CACHE_UC:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		prot = PAGE_KERNEL_IO_NOCACHE;
 		break;
 	case _PAGE_CACHE_UC_MINUS:
-		prot = PAGE_KERNEL_UC_MINUS;
+		prot = PAGE_KERNEL_IO_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WC:
-		prot = PAGE_KERNEL_WC;
+		prot = PAGE_KERNEL_IO_WC;
 		break;
 	case _PAGE_CACHE_WB:
-		prot = PAGE_KERNEL;
+		prot = PAGE_KERNEL_IO;
 		break;
 	}
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -15,7 +15,7 @@
 #define _PAGE_BIT_PAT		7	/* on 4KB pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
-#define _PAGE_BIT_UNUSED2	10
+#define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
 #define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
@@ -32,7 +32,7 @@
 #define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
+#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
 #define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
@@ -99,6 +99,11 @@
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
+#define __PAGE_KERNEL_IO		(__PAGE_KERNEL | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
+
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
@@ -112,6 +117,11 @@
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+
+#define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
+#define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
+#define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
+#define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
 
 /*         xwr */
 #define __P000	PAGE_NONE


