Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbYGBBDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbYGBBDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYGBBBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:01:50 -0400
Received: from gw.goop.org ([64.81.55.164]:58671 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbYGBBBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 8] x86: always set _PAGE_GLOBAL in _PAGE_KERNEL* flags
X-Mercurial-Node: c504187662589e9d358b6ab242955d1626a18d50
Message-Id: <c504187662589e9d358b.1214955995@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consistently set _PAGE_GLOBAL in _PAGE_KERNEL flags.  This makes 32-
and 64-bit code consistent, and removes some special cases where
__PAGE_KERNEL* did not have _PAGE_GLOBAL set, causing confusion as a
result of the inconsistencies.

This patch only affects x86-64, which generally always supports PGD.
The x86-32 patch is next.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head_64.S |    4 ++--
 include/asm-x86/pgtable.h |   32 +++++++++++++-------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -374,7 +374,7 @@
 	/* Since I easily can, map the first 1G.
 	 * Don't set NX because code runs from these pages.
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL, PTRS_PER_PMD)
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
 	/*
@@ -387,7 +387,7 @@
 	 *  If you want to increase this then increase MODULES_VADDR
 	 *  too.)
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL,
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
 		KERNEL_IMAGE_SIZE/PMD_SIZE)
 
 NEXT_PAGE(level2_spare_pgt)
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -88,7 +88,7 @@
 #endif	/* __ASSEMBLY__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
@@ -103,24 +103,18 @@
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
-#define PAGE_KERNEL_WC			MAKE_GLOBAL(__PAGE_KERNEL_WC)
-#define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_UC_MINUS		MAKE_GLOBAL(__PAGE_KERNEL_UC_MINUS)
-#define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
-#define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
-#define PAGE_KERNEL_VSYSCALL		MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_WC			__pgprot(__PAGE_KERNEL_WC)
+#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_UC_MINUS		__pgprot(__PAGE_KERNEL_UC_MINUS)
+#define PAGE_KERNEL_EXEC_NOCACHE	__pgprot(__PAGE_KERNEL_EXEC_NOCACHE)
+#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
 /*         xwr */
 #define __P000	PAGE_NONE


