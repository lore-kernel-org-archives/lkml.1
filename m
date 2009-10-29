Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZJ2BxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZJ2BxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZJ2BxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:53:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:57859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbZJ2BxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:53:09 -0400
X-ExtLoop1: 1
Message-Id: <20091029024821.164525222@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 28 Oct 2009 18:46:58 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] x86_64, cpa: use only text section in set_kernel_text_rw/ro
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_kernel_text_ro_rw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_kernel_text_rw()/set_kernel_text_ro() are marking pages starting
from _text to __start_rodata as RW or RO.

With CONFIG_DEBUG_RODATA, there might be free pages (associated with
padding the sections to 2MB large page boundary) between text
and rodata sections that are given back to page allocator. So we should
use only use the start (__text) and end (__stop___ex_table) of the
text section in set_kernel_text_rw()/set_kernel_text_ro().

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/init_64.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: tip/arch/x86/mm/init_64.c
===================================================================
--- tip.orig/arch/x86/mm/init_64.c
+++ tip/arch/x86/mm/init_64.c
@@ -700,7 +700,7 @@ int kernel_set_to_readonly;
 void set_kernel_text_rw(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -708,13 +708,18 @@ void set_kernel_text_rw(void)
 	pr_debug("Set kernel text: %lx - %lx for read write\n",
 		 start, end);
 
+	/*
+	 * Make the kernel identity mapping for text RW. Kernel text
+	 * mapping will always be RO. Refer to the comment in
+	 * static_protections() in pageattr.c
+	 */
 	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
 }
 
 void set_kernel_text_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -722,6 +727,9 @@ void set_kernel_text_ro(void)
 	pr_debug("Set kernel text: %lx - %lx for read only\n",
 		 start, end);
 
+	/*
+ 	 * Set the kernel identity mapping for text RO.
+ 	 */
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 }
 


