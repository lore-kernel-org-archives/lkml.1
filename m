Return-Path: <linux-kernel-owner+w=401wt.eu-S937407AbXGSJG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937407AbXGSJG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937225AbXGSJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:05:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:57846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936859AbXGSJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:05:51 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: mathieu.desnoyers@polymtl.ca, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>
Subject: new text patching for review
Date: Thu, 19 Jul 2007 11:05:43 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191105.44056.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hallo,

I had some second thoughts about the text patching of DEBUG_RODATA kernels
using change_page_attr(). Change_page_attr is intrusive and slow and using
a separate mapping is a little more gentle. I came up with this patch.
For your review and testing pleasure.

The main quirk is that it doesn't fully follow the cross-modifying code
recommendations; but i'm not sure that's really needed.

Also I admit nop_out is quite inefficient, but that's a very slow path
and it was easier to do it this way than handle all the corner cases
explicitely.

Comments,

-Andi

x86: Fix alternatives and kprobes to remap write-protected kernel text

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c   |   33 +++++++++++++++++++++++++++++++--
 arch/i386/kernel/kprobes.c       |    9 +++------
 arch/i386/mm/init.c              |   14 +++-----------
 arch/x86_64/kernel/kprobes.c     |   10 +++-------
 arch/x86_64/mm/init.c            |   10 ----------
 arch/x86_64/mm/pageattr.c        |    2 +-
 include/asm-i386/alternative.h   |    2 ++
 include/asm-x86_64/alternative.h |    2 ++
 include/asm-x86_64/pgtable.h     |    2 ++
 9 files changed, 47 insertions(+), 37 deletions(-)

Index: linux/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux.orig/arch/x86_64/kernel/kprobes.c
+++ linux/arch/x86_64/kernel/kprobes.c
@@ -39,9 +39,9 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 
-#include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <asm/alternative.h>
 
 void jprobe_return_end(void);
 static void __kprobes arch_copy_kprobe(struct kprobe *p);
@@ -209,16 +209,12 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, BREAKPOINT_INSTRUCTION);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, p->opcode);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -2,8 +2,12 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/kprobes.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/pgtable.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -145,12 +149,15 @@ static unsigned char** find_nop_table(vo
 static void nop_out(void *insns, unsigned int len)
 {
 	unsigned char **noptable = find_nop_table();
+	int i;
 
 	while (len > 0) {
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		memcpy(insns, noptable[noplen], noplen);
+		/* Very inefficient */
+		for (i = 0; i < noplen; i++)
+			text_poke(insns + i, noptable[noplen][i]);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -202,7 +209,7 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		**ptr = 0xf0; /* lock prefix */
+		text_poke(ptr, 0xf0); /* lock prefix */
 	};
 }
 
@@ -406,3 +413,25 @@ void __init alternative_instructions(voi
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
+
+/*
+ * RED-PEN Intel recommends stopping the other CPUs for such
+ * "cross-modifying code".
+ */
+void __kprobes text_poke(void *oaddr, u8 opcode)
+{
+        u8 *addr = oaddr;
+	if (!pte_write(*lookup_address((unsigned long)addr))) {
+		struct page *p = virt_to_page(addr);
+		addr = vmap(&p, 1, VM_MAP, PAGE_KERNEL);
+		if (!addr)
+			return;
+		addr += ((unsigned long)oaddr) % PAGE_SIZE;
+	}
+	*addr = opcode;
+	/* Not strictly needed, but can speed CPU recovery up */
+	if (cpu_has_clflush)
+		asm("clflush (%0) " :: "r" (addr) : "memory");
+	if (addr != oaddr)
+		vunmap(addr);
+}
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -13,7 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
-static inline pte_t *lookup_address(unsigned long address) 
+pte_t *lookup_address(unsigned long address)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -149,4 +149,6 @@ apply_paravirt(struct paravirt_patch_sit
 #define __parainstructions_end	NULL
 #endif
 
+extern void text_poke(void *addr, u8 opcode);
+
 #endif /* _I386_ALTERNATIVE_H */
Index: linux/include/asm-x86_64/alternative.h
===================================================================
--- linux.orig/include/asm-x86_64/alternative.h
+++ linux/include/asm-x86_64/alternative.h
@@ -154,4 +154,6 @@ apply_paravirt(struct paravirt_patch *st
 #define __parainstructions_end NULL
 #endif
 
+extern void text_poke(void *addr, u8 opcode);
+
 #endif /* _X86_64_ALTERNATIVE_H */
Index: linux/include/asm-x86_64/pgtable.h
===================================================================
--- linux.orig/include/asm-x86_64/pgtable.h
+++ linux/include/asm-x86_64/pgtable.h
@@ -403,6 +403,8 @@ extern struct list_head pgd_list;
 
 extern int kern_addr_valid(unsigned long addr); 
 
+pte_t *lookup_address(unsigned long addr);
+
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
Index: linux/arch/i386/kernel/kprobes.c
===================================================================
--- linux.orig/arch/i386/kernel/kprobes.c
+++ linux/arch/i386/kernel/kprobes.c
@@ -35,6 +35,7 @@
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
 #include <asm/uaccess.h>
+#include <asm/alternative.h>
 
 void jprobe_return_end(void);
 
@@ -169,16 +170,12 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	*p->addr = BREAKPOINT_INSTRUCTION;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, BREAKPOINT_INSTRUCTION);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, p->opcode);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
Index: linux/arch/i386/mm/init.c
===================================================================
--- linux.orig/arch/i386/mm/init.c
+++ linux/arch/i386/mm/init.c
@@ -801,17 +801,9 @@ void mark_rodata_ro(void)
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
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+	printk("Write protecting the kernel text: %luk\n", size >> 10);
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -600,16 +600,6 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
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
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;
