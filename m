Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXHOKlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXHOKlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXHOKi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:38:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:45734 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXHOKi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200708151238.148026000@suse.de>
In-Reply-To: <200708151238.148026000@suse.de>
To: cebbert@redhat.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2.6.22] [4/5] i386: Fix double fault handler
Message-Id: <20070815103857.6F54E14F28@wotan.suse.de>
Date: Wed, 15 Aug 2007 12:38:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Ebbert <cebbert@redhat.com>

The new percpu code has apparently broken the doublefault handler
when CONFIG_DEBUG_SPINLOCK is set. Doublefault is handled by
a hardware task, making the check

        SPIN_BUG_ON(lock->owner == current, lock, "recursion");

fault because it uses the FS register to access the percpu data
for current, and that register is zero in the new TSS. (The trace
I saw was on 2.6.20 where it was GS, but it looks like this will
still happen with FS on 2.6.22.)

Initializing FS in the doublefault_tss should fix it.

AK: Also fix broken ptr_ok() and turn printks into KERN_EMERG
AK: And add a PANIC prefix to make clear the system will hang
AK: (e.g. x86-64 will recover) 

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/doublefault.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.22-stable/arch/i386/kernel/doublefault.c
===================================================================
--- linux-2.6.22-stable.orig/arch/i386/kernel/doublefault.c
+++ linux-2.6.22-stable/arch/i386/kernel/doublefault.c
@@ -13,7 +13,7 @@
 static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
 #define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
 
-#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + 0x1000000)
+#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
 
 static void doublefault_fn(void)
 {
@@ -23,23 +23,23 @@ static void doublefault_fn(void)
 	store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
-	printk("double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
+	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
 
 	if (ptr_ok(gdt)) {
 		gdt += GDT_ENTRY_TSS << 3;
 		tss = *(u16 *)(gdt+2);
 		tss += *(u8 *)(gdt+4) << 16;
 		tss += *(u8 *)(gdt+7) << 24;
-		printk("double fault, tss at %08lx\n", tss);
+		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
 		if (ptr_ok(tss)) {
 			struct i386_hw_tss *t = (struct i386_hw_tss *)tss;
 
-			printk("eip = %08lx, esp = %08lx\n", t->eip, t->esp);
+			printk(KERN_EMERG "eip = %08lx, esp = %08lx\n", t->eip, t->esp);
 
-			printk("eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
+			printk(KERN_EMERG "eax = %08lx, ebx = %08lx, ecx = %08lx, edx = %08lx\n",
 				t->eax, t->ebx, t->ecx, t->edx);
-			printk("esi = %08lx, edi = %08lx\n",
+			printk(KERN_EMERG "esi = %08lx, edi = %08lx\n",
 				t->esi, t->edi);
 		}
 	}
@@ -63,6 +63,7 @@ struct tss_struct doublefault_tss __cach
 		.cs		= __KERNEL_CS,
 		.ss		= __KERNEL_DS,
 		.ds		= __USER_DS,
+		.fs		= __KERNEL_PERCPU,
 
 		.__cr3		= __pa(swapper_pg_dir)
 	}
