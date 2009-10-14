Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbZJNWGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbZJNWGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbZJNWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:06:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:48240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275AbZJNWGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="457521981"
Message-Id: <20091014220254.063193621@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 14:46:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, arjan@linux.jf.intel.com
Cc: linux-kernel@vger.kernel.org, chinang.ma@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] x86_64: preserve large page mapping for 1st 2MB kernel txt with CONFIG_DEBUG_RODATA
References: <20091014214654.423040927@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=prevent_kernel_text_lp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the first 2MB, kernel text is co-located with kernel static
page tables setup by head_64.S.  CONFIG_DEBUG_RODATA chops this
2MB large page mapping to small 4KB pages as we mark the kernel text as RO,
leaving the static page tables as RW.

With CONFIG_DEBUG_RODATA disabled, OLTP run on NHM-EP shows 1% improvement
with 2% reduction in system time and 1% improvement in iowait idle time.

To recover this, move the kernel static page tables to .data section, so that
we don't have to break the first 2MB of kernel text to small pages with
CONFIG_DEBUG_RODATA.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/head_64.S |    3 ++-
 arch/x86/mm/init_64.c     |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: tree/arch/x86/kernel/head_64.S
===================================================================
--- tree.orig/arch/x86/kernel/head_64.S
+++ tree/arch/x86/kernel/head_64.S
@@ -262,11 +262,11 @@ ENTRY(secondary_startup_64)
 	.quad	x86_64_start_kernel
 	ENTRY(initial_gs)
 	.quad	INIT_PER_CPU_VAR(irq_stack_union)
-	__FINITDATA
 
 	ENTRY(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
 	.word  0
+	__FINITDATA
 
 bad_address:
 	jmp bad_address
@@ -340,6 +340,7 @@ ENTRY(name)
 	i = i + 1 ;					\
 	.endr
 
+	.data
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
Index: tree/arch/x86/mm/init_64.c
===================================================================
--- tree.orig/arch/x86/mm/init_64.c
+++ tree/arch/x86/mm/init_64.c
@@ -698,7 +698,7 @@ static int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
 	if (!kernel_set_to_readonly)
@@ -712,7 +712,7 @@ void set_kernel_text_rw(void)
 
 void set_kernel_text_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long end = PFN_ALIGN(__start_rodata);
 
 	if (!kernel_set_to_readonly)
@@ -726,7 +726,7 @@ void set_kernel_text_ro(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext), end = PFN_ALIGN(__end_rodata);
+	unsigned long start = PFN_ALIGN(_text), end = PFN_ALIGN(__end_rodata);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 


