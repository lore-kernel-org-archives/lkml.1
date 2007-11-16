Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbXKPUGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbXKPUGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932682AbXKPUC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:02:29 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38932 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbXKPUC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:02:26 -0500
Message-Id: <20071116200140.866586731@polymtl.ca>
References: <20071116195747.448703304@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 14:57:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [rfc-patch 11/11] Text Edit Lock - x86_64 standardize debug rodata
Content-Disposition: inline; filename=text-edit-lock-x86_64-standardize-debug-rodata.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:01:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize DEBUG_RODATA, removing special cases for hotplug and kprobes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86_64/mm/init.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

Index: linux-2.6-lttng/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/init_64.c	2007-09-24 11:00:01.000000000 -0400
+++ linux-2.6-lttng/arch/x86/mm/init_64.c	2007-09-24 11:00:02.000000000 -0400
@@ -592,25 +592,11 @@ void free_initmem(void)
 
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
@@ -623,6 +609,7 @@ void mark_rodata_ro(void)
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
