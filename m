Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYGHXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYGHXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYGHXOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:41 -0400
Received: from gw.goop.org ([64.81.55.164]:51200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 55] x86: use __page_aligned_data/bss
X-Mercurial-Node: 5d7b5c2b6320cbbf5c34627061f8bd24a7706486
Message-Id: <5d7b5c2b6320cbbf5c34.1215554787@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/x86's use of page-aligned variables.  The change to
arch/x86/xen/mmu.c fixes an actual bug, but the rest are cleanups
and to set a precident.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common_64.c |    4 ++--
 arch/x86/kernel/irq_32.c        |    7 ++-----
 arch/x86/xen/mmu.c              |   15 ++++++---------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -16,6 +16,7 @@
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/linkage.h>
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
@@ -512,8 +513,7 @@
 }
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-			   DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
+			   DEBUG_STKSZ] __page_aligned_bss;
 
 extern asmlinkage void ignore_sysret(void);
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
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
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -46,6 +46,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/paravirt.h>
+#include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -60,22 +61,18 @@
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
 
-static unsigned long p2m_top_mfn_list[
-			PAGE_ALIGN(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)]
-	__attribute__((section(".bss.page_aligned")));
+static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
+	__page_aligned_bss;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {


