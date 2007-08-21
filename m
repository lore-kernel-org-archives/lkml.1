Return-Path: <linux-kernel-owner+w=401wt.eu-S1762749AbXHUG7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762749AbXHUG7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbXHUGzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:55:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44367 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761097AbXHUGzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:55:39 -0400
Date: Mon, 20 Aug 2007 23:56:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, cebbert@redhat.com,
       patches@x86-64.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 19/20] i386: Fix double fault handler
Message-ID: <20070821065605.GT5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-fix-double-fault-handler.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/i386/kernel/doublefault.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/i386/kernel/doublefault.c
+++ b/arch/i386/kernel/doublefault.c
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

-- 
