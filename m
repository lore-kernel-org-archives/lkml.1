Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbYDIQ0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbYDIQ0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYDIQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:23:09 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59000 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbYDIQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:23:08 -0400
Message-Id: <20080409152048.501244637@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 06/17] x86 - Enhance DEBUG_RODATA support for hotplug and kprobes
Content-Disposition: inline; filename=x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize DEBUG_RODATA, removing special cases for hotplug and kprobes.

Changelog :
- Use is_rodata_addr to check which pages must be set RW/RO under DEBUG_RODATA.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/mm/init_32.c |   24 ++++++++----------------
 arch/x86/mm/init_64.c |   20 +++-----------------
 2 files changed, 11 insertions(+), 33 deletions(-)

Index: linux-2.6-lttng.mm/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/mm/init_32.c	2008-04-09 10:24:48.000000000 -0400
+++ linux-2.6-lttng.mm/arch/x86/mm/init_32.c	2008-04-09 10:34:26.000000000 -0400
@@ -723,25 +723,17 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
-#endif
-	{
-		set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
-		printk(KERN_INFO "Write protecting the kernel text: %luk\n",
-			size >> 10);
+	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
+	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
+		size >> 10);
 
 #ifdef CONFIG_CPA_DEBUG
-		printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
-			start, start+size);
-		set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);
+	printk(KERN_INFO "Testing CPA: Reverting %lx-%lx\n",
+		start, start+size);
+	set_pages_rw(virt_to_page(start), size>>PAGE_SHIFT);
 
-		printk(KERN_INFO "Testing CPA: write protecting again\n");
-		set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
-#endif
-	}
+	printk(KERN_INFO "Testing CPA: write protecting again\n");
+	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 #endif
 	start += size;
 	size = (unsigned long)__end_rodata - start;
Index: linux-2.6-lttng.mm/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/mm/init_64.c	2008-04-09 10:25:48.000000000 -0400
+++ linux-2.6-lttng.mm/arch/x86/mm/init_64.c	2008-04-09 10:34:26.000000000 -0400
@@ -632,23 +632,8 @@ EXPORT_SYMBOL_GPL(rodata_test_data);
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = (unsigned long)_stext, end;
-
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
+	unsigned long start = PFN_ALIGN(_stext),
+			end = PFN_ALIGN(__end_rodata);
 
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
@@ -679,6 +664,7 @@ void free_initrd_mem(unsigned long start
 {
 	free_init_pages("initrd memory", start, end);
 }
+
 #endif
 
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
