Return-Path: <linux-kernel-owner+w=401wt.eu-S1764467AbXHTU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764467AbXHTU11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762748AbXHTUWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:22:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54503 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762655AbXHTUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:22:35 -0400
Message-Id: <20070820202149.498694689@polymtl.ca>
References: <20070820201902.597091353@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:19:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu
Subject: [patch 11/11] Text Edit Lock - x86_64 standardize debug rodata
Content-Disposition: inline; filename=text-edit-lock-x86_64-standardize-debug-rodata.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:21:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize DEBUG_RODATA, removing special cases for hotplug and kprobes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
---
 arch/x86_64/mm/init.c           |   23 +++++------------------
 include/asm-x86_64/cacheflush.h |   22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+), 18 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/init.c	2007-08-18 10:02:58.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/init.c	2007-08-18 10:04:14.000000000 -0400
@@ -598,25 +598,11 @@ void free_initmem(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = (unsigned long)_stext, end;
+	unsigned long start = PFN_ALIGN(_stext);
+	unsigned long end = PFN_ALIGN(__end_rodata);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() > 1)
-		start = (unsigned long)_etext;
-#endif
-
-#ifdef CONFIG_KPROBES
-	start = (unsigned long)__start_rodata;
-#endif
-	
-	end = (unsigned long)__end_rodata;
-	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
-	end &= PAGE_MASK;
-	if (end <= start)
-		return;
-
-	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	change_page_attr_addr(start, (end - start) >> PAGE_SHIFT,
+				PAGE_KERNEL_RO);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -629,6 +615,7 @@ void mark_rodata_ro(void)
 	 */
 	global_flush_tlb();
 }
+
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
