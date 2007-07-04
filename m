Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXGDGce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXGDGce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXGDGc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:32:27 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:15694
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbXGDGc0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:32:26 -0400
Message-Id: <468B5B54.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 04 Jul 2007 07:33:24 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86: make SMP locks handling interact properly with
	CONFIG_DEBUG_RODATA (2nd try)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of suppressing the change of .text to become readonly, make
the SMP locks patching code properly adjust/restore the page access
rights.

On x86-64 additionally remove all mappings past the kernel image, and
remove leftovers from the removal of the more general (but abandoned)
SMP alternatives.

Note that while I expect this to work properly on it own, it was only
tested together with the change_page_attr() patch submitted before,
which namely fixed the reference counting on split pages (which
affected earlier versions of this patch).

Assumes the respective KPROBES adjustment is also in place
(CONFIG_KPROBES being removed here at once).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/alternative.c   |   67 +++++++++++++++++++++++++++++++++------
 arch/i386/mm/init.c              |   14 +-------
 arch/x86_64/kernel/vmlinux.lds.S |    9 -----
 arch/x86_64/mm/init.c            |   14 ++------
 4 files changed, 64 insertions(+), 40 deletions(-)

--- linux-2.6.22-rc7/arch/i386/kernel/alternative.c	2007-07-03 10:57:28.000000000 +0200
+++ 2.6.22-rc7-x86-alt-page-attr/arch/i386/kernel/alternative.c	2007-07-02 14:40:15.000000000 +0200
@@ -2,8 +2,11 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/pfn.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
+#include <asm/pgtable.h>
+#include <asm/cacheflush.h>
 
 static int noreplace_smp     = 0;
 static int smp_alt_once      = 0;
@@ -150,6 +153,46 @@ static void nop_out(void *insns, unsigne
 	}
 }
 
+#ifdef CONFIG_DEBUG_RODATA
+
+#ifdef CONFIG_X86_32
+#include <asm/highmem.h>
+#define MODULES_VADDR VMALLOC_START
+#endif
+
+static inline void make_writable(const void *instr, unsigned int len)
+{
+	unsigned long va = (unsigned long)instr;
+
+	if (va < MODULES_VADDR) {
+		change_page_attr(virt_to_page(instr),
+				 PFN_UP(va + len) - PFN_DOWN(va),
+				 PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+	}
+}
+
+static inline void make_readonly(const void *instr, unsigned int len)
+{
+	unsigned long va = (unsigned long)instr;
+
+	if (va < MODULES_VADDR) {
+		change_page_attr(virt_to_page(instr),
+				 PFN_UP(va + len) - PFN_DOWN(va),
+#ifdef CONFIG_X86_64
+				 PAGE_KERNEL_RO);
+#else
+				 PAGE_KERNEL_RX);
+#endif
+		global_flush_tlb();
+	}
+}
+
+#else /* !CONFIG_DEBUG_RODATA */
+#define make_writable (void)
+#define make_readonly (void)
+#endif
+
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
 
@@ -196,7 +239,9 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
+		make_writable(*ptr, 1);
 		**ptr = 0xf0; /* lock prefix */
+		make_readonly(*ptr, 1);
 	};
 }
 
@@ -212,7 +257,9 @@ static void alternatives_smp_unlock(u8 *
 			continue;
 		if (*ptr > text_end)
 			continue;
+		make_writable(*ptr, 1);
 		nop_out(*ptr, 1);
+		make_readonly(*ptr, 1);
 	};
 }
 
@@ -239,7 +286,6 @@ void alternatives_smp_module_add(struct 
 				 void *text,  void *text_end)
 {
 	struct smp_alt_module *smp;
-	unsigned long flags;
 
 	if (noreplace_smp)
 		return;
@@ -265,39 +311,37 @@ void alternatives_smp_module_add(struct 
 		__FUNCTION__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
-	spin_lock_irqsave(&smp_alt, flags);
+	spin_lock(&smp_alt);
 	list_add_tail(&smp->next, &smp_alt_modules);
 	if (boot_cpu_has(X86_FEATURE_UP))
 		alternatives_smp_unlock(smp->locks, smp->locks_end,
 					smp->text, smp->text_end);
-	spin_unlock_irqrestore(&smp_alt, flags);
+	spin_unlock(&smp_alt);
 }
 
 void alternatives_smp_module_del(struct module *mod)
 {
 	struct smp_alt_module *item;
-	unsigned long flags;
 
 	if (smp_alt_once || noreplace_smp)
 		return;
 
-	spin_lock_irqsave(&smp_alt, flags);
+	spin_lock(&smp_alt);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		spin_unlock_irqrestore(&smp_alt, flags);
+		spin_unlock(&smp_alt);
 		DPRINTK("%s: %s\n", __FUNCTION__, item->name);
 		kfree(item);
 		return;
 	}
-	spin_unlock_irqrestore(&smp_alt, flags);
+	spin_unlock(&smp_alt);
 }
 
 void alternatives_smp_switch(int smp)
 {
 	struct smp_alt_module *mod;
-	unsigned long flags;
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -313,7 +357,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
-	spin_lock_irqsave(&smp_alt, flags);
+	spin_lock(&smp_alt);
 	if (smp) {
 		printk(KERN_INFO "SMP alternatives: switching to SMP code\n");
 		clear_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
@@ -329,7 +373,7 @@ void alternatives_smp_switch(int smp)
 			alternatives_smp_unlock(mod->locks, mod->locks_end,
 						mod->text, mod->text_end);
 	}
-	spin_unlock_irqrestore(&smp_alt, flags);
+	spin_unlock(&smp_alt);
 }
 
 #endif
@@ -369,6 +413,7 @@ void __init alternative_instructions(voi
 
 	local_irq_save(flags);
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
+	local_irq_restore(flags);
 
 	/* switch to patch-once-at-boottime-only mode and free the
 	 * tables in case we know the number of CPUs will never ever
@@ -399,6 +444,8 @@ void __init alternative_instructions(voi
 		alternatives_smp_switch(0);
 	}
 #endif
+
+	local_irq_save(flags);
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
--- linux-2.6.22-rc7/arch/i386/mm/init.c	2007-07-03 10:57:29.000000000 +0200
+++ 2.6.22-rc7-x86-alt-page-attr/arch/i386/mm/init.c	2007-07-02 14:40:15.000000000 +0200
@@ -799,17 +799,9 @@ void mark_rodata_ro(void)
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
--- linux-2.6.22-rc7/arch/x86_64/kernel/vmlinux.lds.S	2007-07-03 10:57:39.000000000 +0200
+++ 2.6.22-rc7-x86-alt-page-attr/arch/x86_64/kernel/vmlinux.lds.S	2007-07-02 14:40:15.000000000 +0200
@@ -131,20 +131,11 @@ SECTIONS
   /* might get freed after init */
   . = ALIGN(4096);
   __smp_alt_begin = .;
-  __smp_alt_instructions = .;
-  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
-	*(.smp_altinstructions)
-  }
-  __smp_alt_instructions_end = .;
-  . = ALIGN(8);
   __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 	*(.smp_locks)
   }
   __smp_locks_end = .;
-  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
-	*(.smp_altinstr_replacement)
-  }
   . = ALIGN(4096);
   __smp_alt_end = .;
 
--- linux-2.6.22-rc7/arch/x86_64/mm/init.c	2007-07-03 10:57:39.000000000 +0200
+++ 2.6.22-rc7-x86-alt-page-attr/arch/x86_64/mm/init.c	2007-07-02 14:40:15.000000000 +0200
@@ -592,6 +592,10 @@ void free_initmem(void)
 	free_init_pages("unused kernel memory",
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
+	change_page_attr_addr(PFN_ALIGN(_end),
+			      (KERNEL_TEXT_SIZE - __pa_symbol(_end)) >> PAGE_SHIFT,
+			      __pgprot(0));
+	global_flush_tlb();
 }
 
 #ifdef CONFIG_DEBUG_RODATA
@@ -600,16 +604,6 @@ void mark_rodata_ro(void)
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


