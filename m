Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYE1QFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYE1QFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYE1QFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:05:09 -0400
Received: from gw.goop.org ([64.81.55.164]:33845 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYE1QFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:05:08 -0400
Message-ID: <483D8292.40808@goop.org>
Date: Wed, 28 May 2008 17:04:34 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/3] make page-aligned data and bss less fragile
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making a variable page-aligned by using
__attribute__((section(".data.page_aligned"))) is fragile because if
sizeof(variable) is not also a multiple of page size, it leaves
variables in the remainder of the section unaligned.

This patch introduces two new qualifiers, __page_aligned_data and
__page_aligned_bss to set the section *and* the alignment of
variables.  This makes page-aligned variables more robust because the
linker will make sure they're aligned properly.  Unfortunately it
requires *all* page-aligned data to use these macros...

It also updates arch/x86's use of page-aligned variables, since its
the heaviest user of them in the kernel.  The change to
arch/x86/xen/mmu.c fixes an actual bug, but the rest are cleanups
and to set a precident.

[ I don't know if this would be easier to manage by splitting the
  x86 part out from the common part. Two following patches apply to
  powerpc and sh; they're purely decorative. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/irq_32.c  |    7 ++-----
 arch/x86/kernel/setup64.c |    5 +++--
 arch/x86/mm/ioremap.c     |    3 +--
 arch/x86/xen/mmu.c        |   12 +++++-------
 include/linux/linkage.h   |    8 ++++++++
 5 files changed, 19 insertions(+), 16 deletions(-)

===================================================================
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -83,11 +83,8 @@
 static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
-
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
 static void call_on_stack(void *func, void *stack)
 {
===================================================================
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/string.h>
+#include <linux/linkage.h>
 #include <linux/bootmem.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
@@ -40,7 +41,7 @@
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
+char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
@@ -123,7 +124,7 @@
 } 
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
+__page_aligned_bss;
 
 extern asmlinkage void ignore_sysret(void);
 
===================================================================
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -403,8 +403,7 @@
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
-		__section(.bss.page_aligned);
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -46,6 +46,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/paravirt.h>
+#include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -60,21 +61,18 @@
 #define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
 
 /* Placeholder for holes in the address space */
-static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE]
-	__attribute__((section(".data.page_aligned"))) =
+static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE] __page_aligned_data =
 		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
 
  /* Array of pointers to pages containing p2m entries */
-static unsigned long *p2m_top[TOP_ENTRIES]
-	__attribute__((section(".data.page_aligned"))) =
+static unsigned long *p2m_top[TOP_ENTRIES] __page_aligned_data =
 		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
 
 /* Arrays of p2m arrays expressed in mfns used for save/restore */
-static unsigned long p2m_top_mfn[TOP_ENTRIES]
-	__attribute__((section(".bss.page_aligned")));
+static unsigned long p2m_top_mfn[TOP_ENTRIES] __page_aligned_bss;
 
 static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
-	__attribute__((section(".bss.page_aligned")));
+	__page_aligned_bss;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
===================================================================
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_LINKAGE_H
 #define _LINUX_LINKAGE_H
 
+#include <linux/compiler.h>
 #include <asm/linkage.h>
 
 #define notrace __attribute__((no_instrument_function))
@@ -18,6 +19,13 @@
 #ifndef asmregparm
 # define asmregparm
 #endif
+
+/*
+ * Mark a variable page aligned, and put it in an appropriate page
+ * aligned section.
+ */
+#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
  * This is used by architectures to keep arguments on the stack


