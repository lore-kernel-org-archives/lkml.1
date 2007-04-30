Return-Path: <linux-kernel-owner+w=401wt.eu-S1946537AbXD3RrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946537AbXD3RrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946549AbXD3RrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:47:05 -0400
Received: from holomorphy.com ([66.93.40.71]:50959 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946537AbXD3RrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:47:03 -0400
Date: Mon, 30 Apr 2007 10:47:30 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [6/6] arrange for a guard page on cpu 0's IRQ stack (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174730.GI19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> Here's what I did for i386 for someone concerned about blowing the stack.

vmap() cpu 0's IRQ stack to ensure a guard page for it.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/kernel/irq.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/irq.c	2007-04-30 10:36:14.553987258 -0700
+++ stack-paranoia/arch/i386/kernel/irq.c	2007-04-30 10:37:09.909141769 -0700
@@ -17,6 +17,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/mm.h>
 #include <linux/bootmem.h>
 
 #include <asm/apic.h>
@@ -156,6 +157,41 @@
 static DEFINE_PER_CPU(char *, hardirq_stack);
 
 #ifdef CONFIG_VMALLOC_STACK
+static void * __init irq_remap_stack(void *stack)
+{
+	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE];
+
+	for (i = 0; i < ARRAY_SIZE(pages); ++i)
+		pages[i] =  virt_to_page(stack + PAGE_SIZE*i);
+	return vmap(pages, THREAD_SIZE/PAGE_SIZE, VM_IOREMAP, PAGE_KERNEL);
+}
+
+static int __init irq_guard_cpu0(void)
+{
+	unsigned long flags;
+	void *tmp;
+
+	tmp = irq_remap_stack(per_cpu(softirq_stack, 0));
+	if (!tmp)
+		return -ENOMEM;
+	else {
+		local_irq_save(flags);
+		per_cpu(softirq_stack, 0) = tmp;
+		local_irq_restore(flags);
+	}
+	tmp = irq_remap_stack(per_cpu(hardirq_stack, 0));
+	if (!tmp)
+		return -ENOMEM;
+	else {
+		local_irq_save(flags);
+		per_cpu(hardirq_stack, 0) = tmp;
+		local_irq_restore(flags);
+	}
+	return 0;
+}
+core_initcall(irq_guard_cpu0);
+
 static void * __init __alloc_irqstack(int cpu)
 {
 	int i;
