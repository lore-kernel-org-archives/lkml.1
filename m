Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbYCFODP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbYCFODP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYCFOCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:02:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYCFOCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:02:53 -0500
Date: Thu, 6 Mar 2008 15:01:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Message-ID: <20080306140105.GC28438@elte.hu>
References: <200803061811.27555.srinivasa@in.ibm.com> <20080306125551.GA1597@Krystal> <200803061903.09003.srinivasa@in.ibm.com> <20080306134849.GA4088@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306134849.GA4088@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Cc:-ed Arjan - he wrote and handles the DEBUG_RODATA bits. ]

* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hrm, yeah, that's because http://lkml.org/lkml/2008/2/2/227
> 
> x86 - Enhance DEBUG_RODATA support - alternatives
> 
> has been pulled out of the x86 tree. It implements the correct 
> text_poke required to support this. It's been removed because Xen does 
> not support the WP bit in the guest kernels.
> 
> Can you try my new replacement implementation ? It creates another 
> mapping instead of modifying the WP bit.

thanks, applied it to x86.git.

note, there were rejects and i had to hand-merge it - in general it's 
best to send development x86 patches against:

    http://people.redhat.com/mingo/x86.git/README

find the merged patch is below - i hope i merged it right ;)

	Ingo

------------->
Subject: x86: enhance DEBUG_RODATA support - alternatives
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 6 Mar 2008 08:48:49 -0500

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
CC: H. Peter Anvin <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |   88 +++++++++++++++++++++++++++++++-----------
 include/asm-x86/alternative.h |   23 ++++++++++
 2 files changed, 87 insertions(+), 24 deletions(-)

Index: linux-x86.q/arch/x86/kernel/alternative.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/alternative.c
+++ linux-x86.q/arch/x86/kernel/alternative.c
@@ -11,6 +11,8 @@
 #include <asm/mce.h>
 #include <asm/nmi.h>
 #include <asm/vsyscall.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
 
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
 		__func__, smp->locks, smp->locks_end,
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
 		DPRINTK("%s: %s\n", __func__, item->name);
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
Index: linux-x86.q/include/asm-x86/alternative.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/alternative.h
+++ linux-x86.q/include/asm-x86/alternative.h
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
