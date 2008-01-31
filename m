Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbYAaNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbYAaNTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbYAaNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:19:39 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:61157 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbYAaNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:19:38 -0500
Date: Thu, 31 Jan 2008 14:19:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] GBPAGES: Fix global bit for 64bit
Message-ID: <20080131131931.GA15586@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 31 Jan 2008 13:13:15.0011 (UTC) FILETIME=[09B19530:01C8640B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Ideally apply before the patch to enable gbpages direct mapping]

The gbpages direct patch assumed that __PAGE_KERNEL contains _PAGE_GLOBAL
(I think because that was true at some point in git-x86 and i forgot
to remove it again when forward porting) 

This is currently true on 32bit, but not on 64bit which does not make 
much sense. Add it to 64bit too. Also get rid of the obsolete MAKE_GLOBAL.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -69,11 +69,13 @@
 #define _PAGE_KERNEL (_PAGE_KERNEL_EXEC | _PAGE_NX)
 
 #ifndef __ASSEMBLY__
+/* These are set up based on CPUID capabilities */
 extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #endif	/* __ASSEMBLY__ */
 #else
+/* 64bit can assume more CPUID capabilities */
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 
@@ -86,22 +88,16 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KE
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
-#define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
-#define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
-#define PAGE_KERNEL_VSYSCALL		MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL_NOCACHE)
+#define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_EXEC_NOCACHE	__pgprot(__PAGE_KERNEL_EXEC_NOCACHE)
+#define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
+#define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
+#define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
+#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
 /*         xwr */
 #define __P000	PAGE_NONE
