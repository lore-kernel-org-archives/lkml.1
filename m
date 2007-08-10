Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbXHJIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbXHJIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXHJIXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:23:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXHJIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:23:13 -0400
Date: Fri, 10 Aug 2007 10:23:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
Message-ID: <20070810082310.GA6804@one.firstfloor.org>
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de> <46BB5F9B.6050808@redhat.com> <20070809231618.GC1845@one.firstfloor.org> <46BBA4CB.7070009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BBA4CB.7070009@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 07:35:39PM -0400, Chuck Ebbert wrote:
> On 08/09/2007 07:16 PM, Andi Kleen wrote:
> > 
> > I tested it. Even on a box without spin lock debugging I get a hard
> > hang after
> > 
> > double fault, gdt at c1404000 [255 bytes]
> > 
> > even though it should have printed the registers.
> > So it looks like there is more broken in the DF handler than just
> > this.
> 
> Looks like it just fails the ptr_ok() test:
> 
> #define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + 0x1000000)
> 
> page_offset  c0000000
>             + 1000000
> 
>            < c1404000
> 
> What should that be changed to, or is there some easier way to test that?

This is the patch i came up with in the end. Passes testing.
I also fixed some more minor things.


Fix double fault handler

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

 arch/i386/kernel/doublefault.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/kernel/doublefault.c
===================================================================
--- linux.orig/arch/i386/kernel/doublefault.c
+++ linux/arch/i386/kernel/doublefault.c
@@ -13,7 +13,7 @@
 static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
 #define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
 
-#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + 0x1000000)
+#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
 
 static void doublefault_fn(void)
 {
@@ -23,7 +23,7 @@ static void doublefault_fn(void)
 	store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
-	printk("double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
+	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
 
 	if (ptr_ok(gdt)) {
 		gdt += GDT_ENTRY_TSS << 3;
@@ -35,11 +35,11 @@ static void doublefault_fn(void)
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



