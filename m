Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZITWSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZITWSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 18:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZITWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 18:18:44 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64765 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbZITWSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 18:18:43 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v4 4/4] Use macros for .data.page_aligned section.
Date: Sun, 20 Sep 2009 18:14:15 -0400
Message-Id: <1253484855-8067-5-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>
References: <1253484855-8067-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the remaining direct references to
.data.page_aligned in C and assembly code to use the macros in
include/linux/linkage.h.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/avr32/mm/init.c                        |    4 +---
 arch/powerpc/kernel/vdso.c                  |    3 ++-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 ++-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 ++-
 arch/s390/kernel/vdso.c                     |    2 +-
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |    3 ++-
 arch/s390/kernel/vdso64/vdso64_wrapper.S    |    3 ++-
 arch/x86/include/asm/cache.h                |    4 +++-
 arch/x86/kernel/head_32.S                   |    2 +-
 9 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index e819fa6..cc60d10 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -24,11 +24,9 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-#define __page_aligned	__attribute__((section(".data.page_aligned")))
-
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned;
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 struct page *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index a0abce2..3faaf29 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -1,3 +1,4 @@
+
 /*
  *    Copyright (C) 2004 Benjamin Herrenschmidt, IBM Corp.
  *			 <benh@kernel.crashing.org>
@@ -74,7 +75,7 @@ static int vdso_ready;
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */
diff --git a/arch/powerpc/kernel/vdso32/vdso32_wrapper.S b/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
index 556f0ca..6e8f507 100644
--- a/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
+++ b/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
diff --git a/arch/powerpc/kernel/vdso64/vdso64_wrapper.S b/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
index 0529cb9..b8553d6 100644
--- a/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
+++ b/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 45e1708..45a3e9a 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -75,7 +75,7 @@ __setup("vdso=", vdso_setup);
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /*
diff --git a/arch/s390/kernel/vdso32/vdso32_wrapper.S b/arch/s390/kernel/vdso32/vdso32_wrapper.S
index 61639a8..ae42f8c 100644
--- a/arch/s390/kernel/vdso32/vdso32_wrapper.S
+++ b/arch/s390/kernel/vdso32/vdso32_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
diff --git a/arch/s390/kernel/vdso64/vdso64_wrapper.S b/arch/s390/kernel/vdso64/vdso64_wrapper.S
index d8e2ac1..c245842 100644
--- a/arch/s390/kernel/vdso64/vdso64_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso64_wrapper.S
@@ -1,7 +1,8 @@
 #include <linux/init.h>
+#include <linux/linkage.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	__PAGE_ALIGNED_DATA
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 5d367ca..549860d 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_CACHE_H
 #define _ASM_X86_CACHE_H
 
+#include <linux/linkage.h>
+
 /* L1 cache line size */
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
@@ -13,7 +15,7 @@
 #ifdef CONFIG_SMP
 #define __cacheline_aligned_in_smp					\
 	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))	\
-	__attribute__((__section__(".data.page_aligned")))
+	__page_aligned_data
 #endif
 #endif
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 1dac239..218aad7 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -626,7 +626,7 @@ ENTRY(empty_zero_page)
  * This starts the data section.
  */
 #ifdef CONFIG_X86_PAE
-.section ".data.page_aligned","wa"
+__PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
-- 
1.6.3.3

