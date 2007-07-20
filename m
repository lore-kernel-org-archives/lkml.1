Return-Path: <linux-kernel-owner+w=401wt.eu-S935964AbXGTPdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935964AbXGTPdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933477AbXGTPct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:50681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765880AbXGTPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:48 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: jbeulich@novell.com, jeremy@goop.org, compudj@krystal.dyndns.org,
       zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected kernel text
Message-Id: <20070720153246.6597614E79@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Reenable kprobes and alternative patching when the kernel text is write
protected by DEBUG_RODATA
Add a general utility function to change write protected text.
The new function remaps the code using vmap to write it and takes
care of CPU synchronization. It also does CLFLUSH to make icache recovery
faster. 

There are some limitations on when the function can be used, see
the comment.

This is a newer version that also changes the paravirt_ops code.
text_poke also supports multi byte patching now.

Contains bug fixes from Zach Amsden and suggestions from
Mathieu Desnoyers.

Cc: jbeulich@novell.com
Cc: jeremy@goop.org
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: zach@vmware.com

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
+	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, &p->opcode, 1);
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
@@ -150,7 +154,7 @@ static void nop_out(void *insns, unsigne
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		memcpy(insns, noptable[noplen], noplen);
+		text_poke(insns, noptable[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -202,7 +206,7 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		**ptr = 0xf0; /* lock prefix */
+		text_poke(*ptr, ((unsigned char []){0xf0}), 1); /* add lock prefix */
 	};
 }
 
@@ -360,10 +364,6 @@ void apply_paravirt(struct paravirt_patc
 		/* Pad the rest with nops */
 		nop_out(p->instr + used, p->len - used);
 	}
-
-	/* Sync to be conservative, in case we patched following
-	 * instructions */
-	sync_core();
 }
 extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
@@ -406,3 +406,30 @@ void __init alternative_instructions(voi
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
+
+/*
+ * Warning: 
+ * When you use this code to patch more than one byte of an instruction
+ * you need to make sure that other CPUs cannot execute this code in parallel.
+ * And on the local CPU you need to be protected again NMI or MCE handlers
+ * seeing an inconsistent instruction while you patch.
+ */
+void __kprobes text_poke(void *oaddr, unsigned char *opcode, int len)
+{
+        u8 *addr = oaddr;
+	if (!pte_write(*lookup_address((unsigned long)addr))) {
+		struct page *p[2] = { virt_to_page(addr), virt_to_page(addr+PAGE_SIZE) };
+		addr = vmap(p, 2, VM_MAP, PAGE_KERNEL);
+		if (!addr)
+			return;
+		addr += ((unsigned long)oaddr) % PAGE_SIZE;
+	}
+	memcpy(addr, opcode, len);
+	sync_core();
+	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
+	   case. */
+	if (cpu_has_clflush)
+		asm("clflush (%0) " :: "r" (oaddr) : "memory");
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
 
+extern void text_poke(void *addr, unsigned char *opcode, int len);
+
 #endif /* _I386_ALTERNATIVE_H */
Index: linux/include/asm-x86_64/alternative.h
===================================================================
--- linux.orig/include/asm-x86_64/alternative.h
+++ linux/include/asm-x86_64/alternative.h
@@ -154,4 +154,6 @@ apply_paravirt(struct paravirt_patch *st
 #define __parainstructions_end NULL
 #endif
 
+extern void text_poke(void *addr, unsigned char *opcode, int len);
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
+	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_icache_range((unsigned long) p->addr,
-			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	text_poke(p->addr, &p->opcode, 1);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
Index: linux/arch/i386/mm/init.c
===================================================================
--- linux.orig/arch/i386/mm/init.c
+++ linux/arch/i386/mm/init.c
@@ -800,17 +800,9 @@ void mark_rodata_ro(void)
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
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -124,20 +124,28 @@ unsigned paravirt_patch_ignore(unsigned 
 	return len;
 }
 
+struct branch { 
+	unsigned char opcode;
+	u32 delta;
+} __attribute__((packed)); 
+
 unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
 			     void *site, u16 site_clobbers,
 			     unsigned len)
 {
 	unsigned char *call = site;
 	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
+	struct branch b;
 
 	if (tgt_clobbers & ~site_clobbers)
 		return len;	/* target would clobber too much for this site */
 	if (len < 5)
 		return len;	/* call too long for patch site */
 
-	*call++ = 0xe8;		/* call */
-	*(unsigned long *)call = delta;
+	b.opcode = 0xe8; /* call */
+	b.delta = delta;
+	BUILD_BUG_ON(sizeof(b) != 5);
+	text_poke(call, (unsigned char *)&b, 5);
 
 	return 5;
 }
@@ -150,8 +158,9 @@ unsigned paravirt_patch_jmp(void *target
 	if (len < 5)
 		return len;	/* call too long for patch site */
 
-	*jmp++ = 0xe9;		/* jmp */
-	*(unsigned long *)jmp = delta;
+	b.opcode = 0xe9;	/* jmp */
+	b.delta = delta;
+	text_poke(call, (unsigned char *)&b, 5);
 
 	return 5;
 }
