Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYAXUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYAXUl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYAXUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:35:42 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53370 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbYAXUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:35:41 -0500
Message-Id: <20080124203337.097732577@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 12/26] Text Edit Lock - x86_32 standardize debug rodata
Content-Disposition: inline; filename=text-edit-lock-i386-standardize-debug-rodata.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize DEBUG_RODATA, removing special cases for hotplug and kprobes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/init_32.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng.mm/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/mm/init_32.c	2008-01-24 14:10:42.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/mm/init_32.c	2008-01-24 14:28:36.000000000 -0500
@@ -807,28 +807,21 @@ static int noinline do_test_wp_bit(void)
 }
 
 #ifdef CONFIG_DEBUG_RODATA
-
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		change_page_attr(virt_to_page(start),
-		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-		printk("Write protecting the kernel text: %luk\n", size >> 10);
-	}
-#endif
+	change_page_attr(virt_to_page(start),
+		size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
+		size >> 10);
+
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
 	                 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
-	printk("Write protecting the kernel read-only data: %luk\n",
+	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       size >> 10);
 
 	/*
@@ -839,6 +832,7 @@ void mark_rodata_ro(void)
 	 */
 	global_flush_tlb();
 }
+
 #endif
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
