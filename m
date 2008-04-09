Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYDIQZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYDIQZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYDIQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:22:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58862 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623AbYDIQWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:22:47 -0400
Message-Id: <20080409152047.821224339@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 04/17] x86 - Enhance DEBUG_RODATA support - alternatives
Content-Disposition: inline; filename=x86-enhance-debug-rodata-support-alternatives.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memcpy that should be a text_poke (in apply_alternatives).

Use kernel_wp_save/kernel_wp_restore in text_poke to support DEBUG_RODATA
correctly and so the CPU HOTPLUG special case can be removed.

Add text_poke_early, for alternatives and paravirt boot-time and module load
time patching.

Changelog:

- Fix text_set and text_poke alignment check (mixed up bitwise and and or)
- Remove text_set
- Export add_nops, so it can be used by others.
- Document text_poke_early.
- Remove clflush, since it breaks some VIA architectures and is not strictly
  necessary.
- Add kerneldoc to text_poke and text_poke_early.
- Create a second vmap instead of using the WP bit to support Xen and VMI.
- Move local_irq disable within text_poke and text_poke_early to be able to
  be sleepable in these functions.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/alternative.c |   88 +++++++++++++++++++++++++++++++-----------
 include/asm-x86/alternative.h |   23 ++++++++++
 2 files changed, 87 insertions(+), 24 deletions(-)

Index: linux-2.6-lttng.mm/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/kernel/alternative.c	2008-04-09 11:02:43.000000000 -0400
+++ linux-2.6-lttng.mm/arch/x86/kernel/alternative.c	2008-04-09 11:04:09.000000000 -0400
@@ -5,12 +5,14 @@
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/io.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
 #include <asm/vsyscall.h>
+#include <asm/cacheflush.h>
 
 #define MAX_PATCH_LEN (255-1)
 
@@ -173,7 +175,7 @@ static const unsigned char*const * find_
 #endif /* CONFIG_X86_64 */
 
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
-static void add_nops(void *insns, unsigned int len)
+void add_nops(void *insns, unsigned int len)
 {
 	const unsigned char *const *noptable = find_nop_table();
 
@@ -186,6 +188,7 @@ static void add_nops(void *insns, unsign
 		len -= noplen;
 	}
 }
+EXPORT_SYMBOL_GPL(add_nops);
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
@@ -219,7 +222,7 @@ void apply_alternatives(struct alt_instr
 		memcpy(insnbuf, a->replacement, a->replacementlen);
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
-		text_poke(instr, insnbuf, a->instrlen);
+		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
 
@@ -280,7 +283,6 @@ void alternatives_smp_module_add(struct 
 				 void *text,  void *text_end)
 {
 	struct smp_alt_module *smp;
-	unsigned long flags;
 
 	if (noreplace_smp)
 		return;
@@ -306,39 +308,37 @@ void alternatives_smp_module_add(struct 
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
@@ -355,7 +355,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
-	spin_lock_irqsave(&smp_alt, flags);
+	spin_lock(&smp_alt);
 
 	/*
 	 * Avoid unnecessary switches because it forces JIT based VMs to
@@ -379,7 +379,7 @@ void alternatives_smp_switch(int smp)
 						mod->text, mod->text_end);
 	}
 	smp_mode = smp;
-	spin_unlock_irqrestore(&smp_alt, flags);
+	spin_unlock(&smp_alt);
 }
 
 #endif
@@ -407,7 +407,7 @@ void apply_paravirt(struct paravirt_patc
 
 		/* Pad the rest with nops */
 		add_nops(insnbuf + used, p->len - used);
-		text_poke(p->instr, insnbuf, p->len);
+		text_poke_early(p->instr, insnbuf, p->len);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
@@ -416,8 +416,6 @@ extern struct paravirt_patch_site __star
 
 void __init alternative_instructions(void)
 {
-	unsigned long flags;
-
 	/* The patching is not fully atomic, so try to avoid local interruptions
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
@@ -426,7 +424,6 @@ void __init alternative_instructions(voi
 	stop_mce();
 #endif
 
-	local_irq_save(flags);
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
 	/* switch to patch-once-at-boottime-only mode and free the
@@ -458,7 +455,6 @@ void __init alternative_instructions(voi
 	}
 #endif
  	apply_paravirt(__parainstructions, __parainstructions_end);
-	local_irq_restore(flags);
 
 	if (smp_alt_once)
 		free_init_pages("SMP alternatives",
@@ -471,18 +467,64 @@ void __init alternative_instructions(voi
 #endif
 }
 
-/*
- * Warning:
+/**
+ * text_poke_early - Update instructions on a live kernel at boot time
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
  * When you use this code to patch more than one byte of an instruction
  * you need to make sure that other CPUs cannot execute this code in parallel.
- * Also no thread must be currently preempted in the middle of these instructions.
- * And on the local CPU you need to be protected again NMI or MCE handlers
- * seeing an inconsistent instruction while you patch.
+ * Also no thread must be currently preempted in the middle of these
+ * instructions. And on the local CPU you need to be protected again NMI or MCE
+ * handlers seeing an inconsistent instruction while you patch.
  */
-void __kprobes text_poke(void *addr, unsigned char *opcode, int len)
+void *text_poke_early(void *addr, const void *opcode, size_t len)
 {
+	unsigned long flags;
+	local_irq_save(flags);
 	memcpy(addr, opcode, len);
+	local_irq_restore(flags);
+	sync_core();
+	/* Could also do a CLFLUSH here to speed up CPU recovery; but
+	   that causes hangs on some VIA CPUs. */
+	return addr;
+}
+
+/**
+ * text_poke - Update instructions on a live kernel
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Only atomic text poke/set should be allowed when not doing early patching.
+ * It means the size must be writable atomically and the address must be aligned
+ * in a way that permits an atomic write. It also makes sure we fit on a single
+ * page.
+ */
+void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+{
+	unsigned long flags;
+	char *vaddr;
+	int nr_pages = 2;
+
+	BUG_ON(len > sizeof(long));
+	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
+		- ((long)addr & ~(sizeof(long) - 1)));
+	{
+		struct page *pages[2] = { virt_to_page(addr),
+			virt_to_page(addr + PAGE_SIZE) };
+		if (!pages[1])
+			nr_pages = 1;
+		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+		WARN_ON(!vaddr);
+		local_irq_save(flags);
+		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
+		local_irq_restore(flags);
+		vunmap(vaddr);
+	}
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	return addr;
 }
Index: linux-2.6-lttng.mm/include/asm-x86/alternative.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/asm-x86/alternative.h	2008-04-09 11:02:43.000000000 -0400
+++ linux-2.6-lttng.mm/include/asm-x86/alternative.h	2008-04-09 11:03:04.000000000 -0400
@@ -156,6 +156,27 @@ apply_paravirt(struct paravirt_patch_sit
 #define __parainstructions_end	NULL
 #endif
 
-extern void text_poke(void *addr, unsigned char *opcode, int len);
+extern void add_nops(void *insns, unsigned int len);
+
+/*
+ * Clear and restore the kernel write-protection flag on the local CPU.
+ * Allows the kernel to edit read-only pages.
+ * Side-effect: any interrupt handler running between save and restore will have
+ * the ability to write to read-only pages.
+ *
+ * Warning:
+ * Code patching in the UP case is safe if NMIs and MCE handlers are stopped and
+ * no thread can be preempted in the instructions being modified (no iret to an
+ * invalid instruction possible) or if the instructions are changed from a
+ * consistent state to another consistent state atomically.
+ * More care must be taken when modifying code in the SMP case because of
+ * Intel's errata.
+ * On the local CPU you need to be protected again NMI or MCE handlers seeing an
+ * inconsistent instruction while you patch.
+ * The _early version expects the memory to already be RW.
+ */
+
+extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
