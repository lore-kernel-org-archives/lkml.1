Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbXLUCDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbXLUCDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXLUB66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:58:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53264 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762338AbXLUB6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:58:51 -0500
Message-Id: <20071221015724.389485313@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 06/24] Text Edit Lock - Alternative code for x86
Content-Disposition: inline; filename=text-edit-lock-alternative-i386-and-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memcpy that should be a text_poke (in apply_alternatives).

Use kernel_wp_save/kernel_wp_restore in text_poke to support DEBUG_RODATA
correctly and so the CPU HOTPLUG special case can be removed.

Add text_poke_early, for alternatives and paravirt boot-time and module load
time patching.

Notes:
- A macro is used instead of an inline function to deal with circular header
  include otherwise necessary for read_cr0 and preempt_disable/enable.

Changelog:

- Fix text_set and text_poke alignment check (mixed up bitwise and and or)
- Remove text_set
- Use the new macro INIT_ARRAY() to stop polluting the C files with ({ })
  brackets (which breaks some c parsers in editors).
- Export add_nops, so it can be used by others.
- Remove x86 test for "wp_works_ok", it will just be ignored by the architecture
  if not supported.
- Document text_poke_early.
- Remove clflush, since it breaks some VIA architectures and is not strictly
  necessary.
- Add kerneldoc to text_poke and text_poke_early.
- Remove arg cr0 from kernel_wp_save/restore. Change the macro name for
  kernel_wp_disable/enable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/alternative.c    |   56 ++++++++++++++++++++++++++++++++-------
 include/asm-x86/alternative_32.h |   36 ++++++++++++++++++++++++-
 include/asm-x86/alternative_64.h |   36 ++++++++++++++++++++++++-
 3 files changed, 116 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2007-12-06 10:08:58.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2007-12-06 10:08:58.000000000 -0500
@@ -173,7 +173,7 @@ static const unsigned char*const * find_
 #endif /* CONFIG_X86_64 */
 
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
-static void add_nops(void *insns, unsigned int len)
+void add_nops(void *insns, unsigned int len)
 {
 	const unsigned char *const *noptable = find_nop_table();
 
@@ -186,6 +186,7 @@ static void add_nops(void *insns, unsign
 		len -= noplen;
 	}
 }
+EXPORT_SYMBOL_GPL(add_nops);
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
@@ -219,7 +220,7 @@ void apply_alternatives(struct alt_instr
 		memcpy(insnbuf, a->replacement, a->replacementlen);
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
-		text_poke(instr, insnbuf, a->instrlen);
+		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
 
@@ -234,7 +235,8 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1); /* add lock prefix */
+		/* add lock prefix */
+		text_poke(*ptr, INIT_ARRAY(unsigned char, 0xf0, 1), 1);
 	};
 }
 
@@ -397,7 +399,7 @@ void apply_paravirt(struct paravirt_patc
 
 		/* Pad the rest with nops */
 		add_nops(insnbuf + used, p->len - used);
-		text_poke(p->instr, insnbuf, p->len);
+		text_poke_early(p->instr, insnbuf, p->len);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
@@ -457,18 +459,52 @@ void __init alternative_instructions(voi
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
+ * instructions.  And on the local CPU you need to be protected again NMI or MCE
+ * handlers seeing an inconsistent instruction while you patch.
+ * Warning: read_cr0 is modified by paravirt, this is why we have _early
+ * versions. They are not in the __init section because they can be used at
+ * module load time.
  */
-void __kprobes text_poke(void *addr, unsigned char *opcode, int len)
+void *text_poke_early(void *addr, const void *opcode, size_t len)
 {
 	memcpy(addr, opcode, len);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	return addr;
 }
+
+/**
+ * text_poke - Update instructions on a live kernel
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Only atomic text poke/set should be allowed when not doing early patching.
+ * It means the size must be writable atomically and the address must be aligned
+ * in a way that permits an atomic write.
+ */
+void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+{
+	BUG_ON(len > sizeof(long));
+	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
+		- ((long)addr & ~(sizeof(long) - 1)));
+	kernel_wp_disable();
+	memcpy(addr, opcode, len);
+	kernel_wp_enable();
+	sync_core();
+	/* Could also do a CLFLUSH here to speed up CPU recovery; but
+	   that causes hangs on some VIA CPUs. */
+	return addr;
+}
+
+
Index: linux-2.6-lttng/include/asm-x86/alternative_32.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/alternative_32.h	2007-12-06 10:08:58.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/alternative_32.h	2007-12-06 10:10:43.000000000 -0500
@@ -4,6 +4,7 @@
 #include <asm/types.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
+#include <asm/processor-flags.h>
 
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
@@ -149,6 +150,39 @@ apply_paravirt(struct paravirt_patch_sit
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
+ * The _early version does not use read_cr0(), which can be paravirtualized.
+ */
+
+extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
+#define kernel_wp_disable()			\
+do {						\
+	preempt_disable();			\
+	write_cr0(read_cr0() & ~X86_CR0_WP);	\
+} while (0)
+
+#define kernel_wp_enable()			\
+do {						\
+	write_cr0(read_cr0() | X86_CR0_WP);	\
+	preempt_enable();			\
+} while (0)
 
 #endif /* _I386_ALTERNATIVE_H */
Index: linux-2.6-lttng/include/asm-x86/alternative_64.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/alternative_64.h	2007-12-06 10:08:58.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/alternative_64.h	2007-12-06 10:10:06.000000000 -0500
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+#include <asm/processor-flags.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -154,6 +155,39 @@ apply_paravirt(struct paravirt_patch *st
 #define __parainstructions_end NULL
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
+ * The _early version does not use read_cr0(), which can be paravirtualized.
+ */
+
+extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
+#define kernel_wp_disable()			\
+do {						\
+	preempt_disable();			\
+	write_cr0(read_cr0() & ~X86_CR0_WP);	\
+} while (0)
+
+#define kernel_wp_enable()			\
+do {						\
+	write_cr0(read_cr0() | X86_CR0_WP);	\
+	preempt_enable();			\
+} while (0)
 
 #endif /* _X86_64_ALTERNATIVE_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
