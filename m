Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZJ2BxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZJ2BxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZJ2BxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:53:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:40310 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZJ2BxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:53:09 -0400
X-ExtLoop1: 1
Message-Id: <20091029024820.996634347@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 28 Oct 2009 18:46:56 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, rostedt@goodmis.org
Subject: [patch 1/3] x86, cpa: fix kernel text RO checks in static_protection()
Content-Disposition: inline; filename=fix_cpa_check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt reported that we are unconditionally making the
kernel text mapping as read-only. i.e., if someone does cpa() to the
kernel text area for setting/clearing any page table attribute, we
unconditionally clear the read-write attribute for the kernel text mapping
that is set at compile time.

We should delay (to forbid the write attribute) and enforce only after the
kernel has mapped the text as read-only.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/cacheflush.h |    1 +
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c            |   10 ++++++----
 4 files changed, 9 insertions(+), 6 deletions(-)

Index: tip/arch/x86/include/asm/cacheflush.h
===================================================================
--- tip.orig/arch/x86/include/asm/cacheflush.h
+++ tip/arch/x86/include/asm/cacheflush.h
@@ -176,6 +176,7 @@ void clflush_cache_range(void *addr, uns
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
+extern int kernel_set_to_readonly;
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
Index: tip/arch/x86/mm/init_32.c
===================================================================
--- tip.orig/arch/x86/mm/init_32.c
+++ tip/arch/x86/mm/init_32.c
@@ -997,7 +997,7 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
Index: tip/arch/x86/mm/init_64.c
===================================================================
--- tip.orig/arch/x86/mm/init_64.c
+++ tip/arch/x86/mm/init_64.c
@@ -695,7 +695,7 @@ void __init mem_init(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c
+++ tip/arch/x86/mm/pageattr.c
@@ -282,14 +282,16 @@ static inline pgprot_t static_protection
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA) && \
 	!defined(CONFIG_DYNAMIC_FTRACE)
 	/*
-	 * Kernel text mappings for the large page aligned .rodata section
-	 * will be read-only. For the kernel identity mappings covering
-	 * the holes caused by this alignment can be anything.
+	 * Once the kernel maps the text as RO (kernel_set_to_readonly is set),
+	 * kernel text mappings for the large page aligned text, rodata sections
+	 * will be always read-only. For the kernel identity mappings covering
+	 * the holes caused by this alignment can be anything that user asks.
 	 *
 	 * This will preserve the large page mappings for kernel text/data
 	 * at no extra cost.
 	 */
-	if (within(address, (unsigned long)_text,
+	if (kernel_set_to_readonly &&
+	    within(address, (unsigned long)_text,
 		   (unsigned long)__end_rodata_hpage_align))
 		pgprot_val(forbidden) |= _PAGE_RW;
 #endif


