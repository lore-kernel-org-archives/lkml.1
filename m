Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbXH0QGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbXH0QGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXH0P7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:59:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43202 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573AbXH0P7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:59:14 -0400
Message-Id: <20070827155851.587460820@polymtl.ca>
References: <20070827155601.360241608@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:56:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu
Subject: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Content-Disposition: inline; filename=text-edit-lock-alternative-i386-and-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:58:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memcpy that should be a text_poke (in apply_alternatives).

Use kernel_wp_save/kernel_wp_restore in text_poke to support DEBUG_RODATA
correctly and so the CPU HOTPLUG special case can be removed.

clflush all the cachelines touched by text_poke.

Add text_set(), which is basically a memset-like text_poke.

Add text_poke_early and text_set_early, for alternatives and paravirt boot-time
and module load time patching.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
---
 arch/i386/kernel/alternative.c   |   95 ++++++++++++++++++++++++++++++---------
 include/asm-i386/alternative.h   |   40 ++++++++++++++++
 include/asm-x86_64/alternative.h |   38 +++++++++++++++
 3 files changed, 150 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/alternative.c	2007-08-24 17:28:42.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/alternative.c	2007-08-24 18:05:48.000000000 -0400
@@ -16,6 +16,77 @@
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
 
+/*
+ * Warning:
+ * When you use this code to patch more than one byte of an instruction
+ * you need to make sure that other CPUs cannot execute this code in parallel.
+ * Also no thread must be currently preempted in the middle of these
+ * instructions.  And on the local CPU you need to be protected again NMI or MCE
+ * handlers seeing an inconsistent instruction while you patch.
+ * Warning: read_cr0 is modified by paravirt, this is why we have _early
+ * versions. They are not in the __init section because they can be used at
+ * module load time.
+ */
+static inline void text_sync(void *addr, size_t len)
+{
+	void *faddr;
+
+	sync_core();
+	/* Not strictly needed, but can speed CPU recovery up. */
+	if (cpu_has_clflush)
+		for (faddr = addr; faddr < addr + len;
+				faddr += boot_cpu_data.x86_clflush_size)
+			asm("clflush (%0) " :: "r" (faddr) : "memory");
+}
+
+void * text_poke_early(void *addr, const void *opcode,
+					size_t len)
+{
+	memcpy(addr, opcode, len);
+	text_sync(addr, len);
+	return addr;
+}
+
+void * text_set_early(void *addr, int c, size_t len)
+{
+	memset(addr, c, len);
+	text_sync(addr, len);
+	return addr;
+}
+
+/*
+ * Only atomic text poke/set should be allowed when not doing early patching.
+ * It means the size must be writable atomically and the address must be aligned
+ * in a way that permits an atomic write.
+ */
+void * __kprobes text_poke(void *addr, const void *opcode, size_t len)
+{
+	unsigned long cr0;
+
+	BUG_ON(len > sizeof(long));
+	BUG_ON((((long)addr + len - 1) | ~(sizeof(long) - 1))
+		- ((long)addr | ~(sizeof(long) - 1)));
+	kernel_wp_save(cr0);
+	memcpy(addr, opcode, len);
+	kernel_wp_restore(cr0);
+	text_sync(addr, len);
+	return addr;
+}
+
+void * __kprobes text_set(void *addr, int c, size_t len)
+{
+	unsigned long cr0;
+
+	BUG_ON(len > sizeof(long));
+	BUG_ON((((long)addr + len - 1) | ~(sizeof(long) - 1))
+		- ((long)addr | ~(sizeof(long) - 1)));
+	kernel_wp_save(cr0);
+	memset(addr, c, len);
+	kernel_wp_restore(cr0);
+	text_sync(addr, len);
+	return addr;
+}
+
 static int __init bootonly(char *str)
 {
 	smp_alt_once = 1;
@@ -197,7 +268,7 @@ void apply_alternatives(struct alt_instr
 		memcpy(insnbuf, a->replacement, a->replacementlen);
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
-		text_poke(instr, insnbuf, a->instrlen);
+		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
 
@@ -212,7 +283,7 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1); /* add lock prefix */
+		text_set(*ptr, 0xf0, 1); /* add lock prefix */
 	};
 }
 
@@ -375,7 +446,7 @@ void apply_paravirt(struct paravirt_patc
 
 		/* Pad the rest with nops */
 		add_nops(insnbuf + used, p->len - used);
-		text_poke(p->instr, insnbuf, p->len);
+		text_poke_early(p->instr, insnbuf, p->len);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
@@ -432,21 +503,3 @@ void __init alternative_instructions(voi
 	restart_mce();
 #endif
 }
-
-/*
- * Warning:
- * When you use this code to patch more than one byte of an instruction
- * you need to make sure that other CPUs cannot execute this code in parallel.
- * Also no thread must be currently preempted in the middle of these instructions.
- * And on the local CPU you need to be protected again NMI or MCE handlers
- * seeing an inconsistent instruction while you patch.
- */
-void __kprobes text_poke(void *addr, unsigned char *opcode, int len)
-{
-	memcpy(addr, opcode, len);
-	sync_core();
-	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
-	   case. */
-	if (cpu_has_clflush)
-		asm("clflush (%0) " :: "r" (addr) : "memory");
-}
Index: linux-2.6-lttng/include/asm-i386/alternative.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/alternative.h	2007-08-24 17:22:18.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/alternative.h	2007-08-24 17:39:36.000000000 -0400
@@ -4,6 +4,7 @@
 #include <asm/types.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
+#include <asm/processor-flags.h>
 
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
@@ -149,6 +150,43 @@ apply_paravirt(struct paravirt_patch_sit
 #define __parainstructions_end	NULL
 #endif
 
-extern void text_poke(void *addr, unsigned char *opcode, int len);
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
+ */
+
+extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_set(void *addr, int c, size_t len);
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern void *text_set_early(void *addr, int c, size_t len);
+
+#define kernel_wp_save(cr0)					\
+	do {							\
+		typecheck(unsigned long, cr0);			\
+		preempt_disable();				\
+		cr0 = read_cr0();				\
+		if (cpu_data[smp_processor_id()].wp_works_ok)	\
+			write_cr0(cr0 & ~X86_CR0_WP);		\
+	} while (0)
+
+#define kernel_wp_restore(cr0)					\
+	do {							\
+		typecheck(unsigned long, cr0);			\
+		if (cpu_data[smp_processor_id()].wp_works_ok)	\
+			write_cr0(cr0);				\
+		preempt_enable();				\
+	} while (0)
 
 #endif /* _I386_ALTERNATIVE_H */
Index: linux-2.6-lttng/include/asm-x86_64/alternative.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/alternative.h	2007-08-24 17:22:30.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/alternative.h	2007-08-24 17:39:36.000000000 -0400
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+#include <asm/processor-flags.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -154,6 +155,41 @@ apply_paravirt(struct paravirt_patch *st
 #define __parainstructions_end NULL
 #endif
 
-extern void text_poke(void *addr, unsigned char *opcode, int len);
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
+ */
+
+extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_set(void *addr, int c, size_t len);
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern void *text_set_early(void *addr, int c, size_t len);
+
+#define kernel_wp_save(cr0)					\
+	do {							\
+		typecheck(unsigned long, cr0);			\
+		preempt_disable();				\
+		cr0 = read_cr0();				\
+		write_cr0(cr0 & ~X86_CR0_WP);			\
+	} while (0)
+
+#define kernel_wp_restore(cr0)					\
+	do {							\
+		typecheck(unsigned long, cr0);			\
+		write_cr0(cr0);					\
+		preempt_enable();				\
+	} while (0)
 
 #endif /* _X86_64_ALTERNATIVE_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
