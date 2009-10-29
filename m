Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZJ2BxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZJ2BxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZJ2BxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:53:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:60455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbZJ2BxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:53:09 -0400
X-ExtLoop1: 1
Message-Id: <20091029024821.080941108@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 28 Oct 2009 18:46:57 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] x86_64, ftrace: make ftrace use kernel identity mapping to modify code
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_ftrace_rodata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
So use the kernel identity mapping instead of the kernel text mapping to modify
the kernel text.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/ftrace.c |   17 +++++++++++++++++
 arch/x86/mm/pageattr.c   |    3 +--
 2 files changed, 18 insertions(+), 2 deletions(-)

Index: tip/arch/x86/kernel/ftrace.c
===================================================================
--- tip.orig/arch/x86/kernel/ftrace.c
+++ tip/arch/x86/kernel/ftrace.c
@@ -189,9 +189,26 @@ static void wait_for_nmi(void)
 	nmi_wait_count++;
 }
 
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
+
 static int
 do_ftrace_mod_code(unsigned long ip, void *new_code)
 {
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
 
Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c
+++ tip/arch/x86/mm/pageattr.c
@@ -279,8 +279,7 @@ static inline pgprot_t static_protection
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA) && \
-	!defined(CONFIG_DYNAMIC_FTRACE)
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
 	 * Once the kernel maps the text as RO (kernel_set_to_readonly is set),
 	 * kernel text mappings for the large page aligned text, rodata sections


