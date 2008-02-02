Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbYBBUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbYBBUo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763570AbYBBUou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:44:50 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:54832 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYBBUot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:44:49 -0500
Message-Id: <20080202204348.669987929@polymtl.ca>
References: <20080202204218.188248631@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:42:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 2/2] x86 - Enhance DEBUG_RODATA support for hotplug and kprobes
Content-Disposition: inline; filename=x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:43:49 +0000
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
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |   24 ++++++++----------------
 arch/x86/mm/init_64.c |   20 +++-----------------
 2 files changed, 11 insertions(+), 33 deletions(-)

Index: linux-2.6-lttng/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/init_32.c	2008-02-02 15:33:24.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/init_32.c	2008-02-02 15:33:34.000000000 -0500
@@ -740,25 +740,17 @@ void mark_rodata_ro(void)
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
Index: linux-2.6-lttng/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/mm/init_64.c	2008-02-02 15:33:39.000000000 -0500
+++ linux-2.6-lttng/arch/x86/mm/init_64.c	2008-02-02 15:33:59.000000000 -0500
@@ -618,23 +618,8 @@ EXPORT_SYMBOL_GPL(rodata_test_data);
 
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
 
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 
@@ -651,6 +636,7 @@ void mark_rodata_ro(void)
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
 }
+
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
