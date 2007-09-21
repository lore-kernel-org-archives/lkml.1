Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbXIUWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbXIUWe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763207AbXIUWcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:40449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762310AbXIUWcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:05 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: xemul@openvz.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/50] i386: clean up oops/bug reports
Message-Id: <20070921223204.43B8413DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Emelyanov <xemul@openvz.org>

Typically the oops first lines look like this:

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c049dfbd
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
...

Such output is gained with some ugly if (!nl) printk("\n"); code and
besides being a waste of lines, this is also annoying to read. The
following output looks better (and it is how it looks on x86_64):

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: c049dfbd *pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
...

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/traps.c |   16 ++++------------
 arch/i386/mm/fault.c     |   13 +++++++------
 2 files changed, 11 insertions(+), 18 deletions(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -444,31 +444,23 @@ void die(const char * str, struct pt_reg
 		local_save_flags(flags);
 
 	if (++die.lock_owner_depth < 3) {
-		int nl = 0;
 		unsigned long esp;
 		unsigned short ss;
 
 		report_bug(regs->eip, regs);
 
-		printk(KERN_EMERG "%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
+		printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
-		printk(KERN_EMERG "PREEMPT ");
-		nl = 1;
+		printk("PREEMPT ");
 #endif
 #ifdef CONFIG_SMP
-		if (!nl)
-			printk(KERN_EMERG);
 		printk("SMP ");
-		nl = 1;
 #endif
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		if (!nl)
-			printk(KERN_EMERG);
 		printk("DEBUG_PAGEALLOC");
-		nl = 1;
 #endif
-		if (nl)
-			printk("\n");
+		printk("\n");
+
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
Index: linux/arch/i386/mm/fault.c
===================================================================
--- linux.orig/arch/i386/mm/fault.c
+++ linux/arch/i386/mm/fault.c
@@ -544,23 +544,22 @@ no_context:
 			printk(KERN_ALERT "BUG: unable to handle kernel paging"
 					" request");
 		printk(" at virtual address %08lx\n",address);
-		printk(KERN_ALERT " printing eip:\n");
-		printk("%08lx\n", regs->eip);
+		printk(KERN_ALERT "printing eip: %08lx ", regs->eip);
 
 		page = read_cr3();
 		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
 #ifdef CONFIG_X86_PAE
-		printk(KERN_ALERT "*pdpt = %016Lx\n", page);
+		printk("*pdpt = %016Lx ", page);
 		if ((page >> PAGE_SHIFT) < max_low_pfn
 		    && page & _PAGE_PRESENT) {
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
 			                                         & (PTRS_PER_PMD - 1)];
-			printk(KERN_ALERT "*pde = %016Lx\n", page);
+			printk(KERN_ALERT "*pde = %016Lx ", page);
 			page &= ~_PAGE_NX;
 		}
 #else
-		printk(KERN_ALERT "*pde = %08lx\n", page);
+		printk("*pde = %08lx ", page);
 #endif
 
 		/*
@@ -574,8 +573,10 @@ no_context:
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
 			                                         & (PTRS_PER_PTE - 1)];
-			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*2, (u64)page);
+			printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
 		}
+
+		printk("\n");
 	}
 
 	tsk->thread.cr2 = address;
