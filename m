Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXBLCbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXBLCbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 21:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXBLCbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 21:31:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:38782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXBLCbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 21:31:35 -0500
Subject: [PATCH] powerpc: Fix vDSO page count calculation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 13:31:08 +1100
Message-Id: <1171247468.20494.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent vDSO consolidation patches broke powerpc due to a mistake
in the definition of MAXPAGES constants. This fixes it by moving to
a dynamically allocated array of pages instead as I don't like much
hard coded size limits. Also move the vdso initialisation to an initcall
since it doesn't really need to be done -that- early.

Applogies for not catching the breakage earlier, Roland _did_ CC me on
his patches a while ago, I got busy with other things and forgot to test
them.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Index: linux-work/arch/powerpc/kernel/vdso.c
===================================================================
--- linux-work.orig/arch/powerpc/kernel/vdso.c	2007-02-12 10:42:46.000000000 +1100
+++ linux-work/arch/powerpc/kernel/vdso.c	2007-02-12 11:03:54.000000000 +1100
@@ -49,24 +49,23 @@
 /* Max supported size for symbol names */
 #define MAX_SYMNAME	64
 
-#define VDSO32_MAXPAGES	(((0x3000 + PAGE_MASK) >> PAGE_SHIFT) + 2)
-#define VDSO64_MAXPAGES	(((0x3000 + PAGE_MASK) >> PAGE_SHIFT) + 2)
-
 extern char vdso32_start, vdso32_end;
 static void *vdso32_kbase = &vdso32_start;
-unsigned int vdso32_pages;
-static struct page *vdso32_pagelist[VDSO32_MAXPAGES];
+static unsigned int vdso32_pages;
+static struct page **vdso32_pagelist;
 unsigned long vdso32_sigtramp;
 unsigned long vdso32_rt_sigtramp;
 
 #ifdef CONFIG_PPC64
 extern char vdso64_start, vdso64_end;
 static void *vdso64_kbase = &vdso64_start;
-unsigned int vdso64_pages;
-static struct page *vdso64_pagelist[VDSO64_MAXPAGES];
+static unsigned int vdso64_pages;
+static struct page **vdso64_pagelist;
 unsigned long vdso64_rt_sigtramp;
 #endif /* CONFIG_PPC64 */
 
+static int vdso_ready;
+
 /*
  * The vdso data page (aka. systemcfg for old ppc64 fans) is here.
  * Once the early boot kernel code no longer needs to muck around
@@ -182,6 +181,9 @@ int arch_setup_additional_pages(struct l
 	unsigned long vdso_base;
 	int rc;
 
+	if (!vdso_ready)
+		return 0;
+
 #ifdef CONFIG_PPC64
 	if (test_thread_flag(TIF_32BIT)) {
 		vdso_pagelist = vdso32_pagelist;
@@ -661,7 +663,7 @@ static void __init vdso_setup_syscall_ma
 }
 
 
-void __init vdso_init(void)
+static int __init vdso_init(void)
 {
 	int i;
 
@@ -716,11 +718,13 @@ void __init vdso_init(void)
 #ifdef CONFIG_PPC64
 		vdso64_pages = 0;
 #endif
-		return;
+		return 0;
 	}
 
 	/* Make sure pages are in the correct state */
-	BUG_ON(vdso32_pages + 2 > VDSO32_MAXPAGES);
+	vdso32_pagelist = kzalloc(sizeof(struct page *) * (vdso32_pages + 2),
+				  GFP_KERNEL);
+	BUG_ON(vdso32_pagelist == NULL);
 	for (i = 0; i < vdso32_pages; i++) {
 		struct page *pg = virt_to_page(vdso32_kbase + i*PAGE_SIZE);
 		ClearPageReserved(pg);
@@ -731,7 +735,9 @@ void __init vdso_init(void)
 	vdso32_pagelist[i] = NULL;
 
 #ifdef CONFIG_PPC64
-	BUG_ON(vdso64_pages + 2 > VDSO64_MAXPAGES);
+	vdso64_pagelist = kzalloc(sizeof(struct page *) * (vdso64_pages + 2),
+				  GFP_KERNEL);
+	BUG_ON(vdso64_pagelist == NULL);
 	for (i = 0; i < vdso64_pages; i++) {
 		struct page *pg = virt_to_page(vdso64_kbase + i*PAGE_SIZE);
 		ClearPageReserved(pg);
@@ -743,7 +749,13 @@ void __init vdso_init(void)
 #endif /* CONFIG_PPC64 */
 
 	get_page(virt_to_page(vdso_data));
+
+	smp_wmb();
+	vdso_ready = 1;
+
+	return 0;
 }
+arch_initcall(vdso_init);
 
 int in_gate_area_no_task(unsigned long addr)
 {
Index: linux-work/arch/powerpc/mm/mem.c
===================================================================
--- linux-work.orig/arch/powerpc/mm/mem.c	2007-02-12 10:53:02.000000000 +1100
+++ linux-work/arch/powerpc/mm/mem.c	2007-02-12 10:53:05.000000000 +1100
@@ -384,9 +384,6 @@ void __init mem_init(void)
 		initsize >> 10);
 
 	mem_init_done = 1;
-
-	/* Initialize the vDSO */
-	vdso_init();
 }
 
 /*
Index: linux-work/include/asm-powerpc/vdso.h
===================================================================
--- linux-work.orig/include/asm-powerpc/vdso.h	2007-02-12 11:02:44.000000000 +1100
+++ linux-work/include/asm-powerpc/vdso.h	2007-02-12 11:03:36.000000000 +1100
@@ -18,16 +18,11 @@
 
 #ifndef __ASSEMBLY__
 
-extern unsigned int vdso64_pages;
-extern unsigned int vdso32_pages;
-
 /* Offsets relative to thread->vdso_base */
 extern unsigned long vdso64_rt_sigtramp;
 extern unsigned long vdso32_sigtramp;
 extern unsigned long vdso32_rt_sigtramp;
 
-extern void vdso_init(void);
-
 #else /* __ASSEMBLY__ */
 
 #ifdef __VDSO64__


