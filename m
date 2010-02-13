Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0BMTtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:49:06 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:46150 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab0BMTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TTLSfE+F/bSn0jmlwDquw/jtoiHaV2LLmRm7WVk2W/uB2Uw6hUUxLkR9WGtqbuoIOk
         HGiXq/eVBQYBBo1ONaLxiB9YAsuiL9W5icNMFu0VNQEtYMGQ2fvJlbpgeACERM0Al4t2
         m69ItyrqHhU7c8F9TfVgI1feOW/2S4sZozKww=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 08/10] ARM: ftrace: fix and update dynamic ftrace
Date: Sun, 14 Feb 2010 01:18:36 +0530
Message-Id: <1266090518-31120-9-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds mcount recording and updates dynamic ftrace for ARM to work
with the new ftrace dyamic tracing implementation.  It also adds support
for the mcount format used by newer ARM compilers.

With dynamic tracing, mcount() is implemented as a nop.  Callsites are
patched on startup with nops, and dynamically patched to call to the
ftrace_caller() routine as needed.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/ftrace.h  |   19 +++++-
 arch/arm/kernel/entry-common.S |   37 +++++++---
 arch/arm/kernel/ftrace.c       |  155 +++++++++++++++++++++++++++------------
 scripts/recordmcount.pl        |    2 +
 4 files changed, 155 insertions(+), 58 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 103f7ee..4a56a2e 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -2,12 +2,29 @@
 #define _ASM_ARM_FTRACE
 
 #ifdef CONFIG_FUNCTION_TRACER
-#define MCOUNT_ADDR		((long)(mcount))
+#define MCOUNT_ADDR		((unsigned long)(__gnu_mcount_nc))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 extern void __gnu_mcount_nc(void);
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+struct dyn_arch_ftrace {
+#ifdef CONFIG_OLD_MCOUNT
+	bool	old_mcount;
+#endif
+};
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr;
+}
+
+extern void ftrace_caller_old(void);
+extern void ftrace_call_old(void);
+#endif
+
 #endif
 
 #endif
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index cd2a574..736cd75 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -123,32 +123,51 @@ ENDPROC(ret_from_fork)
  * With both the mcount types, we need to restore the original lr before
  * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
  * No other registers should be clobbered.
+ *
+ * When using dynamic ftrace, we patch out the mcount call by a "mov r0, r0"
+ * for the mcount case, and a "pop {lr}" for the __gnu_mcount_nc case (see
+ * arch/arm/kernel/ftrace.c).
  */
 #ifdef CONFIG_DYNAMIC_FTRACE
-ENTRY(mcount)
+ENTRY(__gnu_mcount_nc)
+	mov	ip, lr
+	ldmia	sp!, {lr}
+	mov	pc, ip
+ENDPROC(__gnu_mcount_nc)
+
+ENTRY(ftrace_caller)
 	stmdb	sp!, {r0-r3, lr}
 	mov	r0, lr
 	sub	r0, r0, #MCOUNT_INSN_SIZE
+	ldr	r1, [sp, #20]
 
-	.globl mcount_call
-mcount_call:
+	.global	ftrace_call
+ftrace_call:
 	bl	ftrace_stub
-	ldr	lr, [fp, #-4]			@ restore lr
-	ldmia	sp!, {r0-r3, pc}
+	ldmia	sp!, {r0-r3, ip, lr}
+	mov	pc, ip
+ENDPROC(ftrace_caller)
+
+#ifdef CONFIG_OLD_MCOUNT
+ENTRY(mcount)
+	stmdb	sp!, {lr}
+	ldr	lr, [fp, #-4]
+	ldmia	sp!, {pc}
 ENDPROC(mcount)
 
-ENTRY(ftrace_caller)
+ENTRY(ftrace_caller_old)
 	stmdb	sp!, {r0-r3, lr}
 	ldr	r1, [fp, #-4]
 	mov	r0, lr
 	sub	r0, r0, #MCOUNT_INSN_SIZE
 
-	.globl ftrace_call
-ftrace_call:
+	.globl ftrace_call_old
+ftrace_call_old:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
-ENDPROC(ftrace_caller)
+ENDPROC(ftrace_caller_old)
+#endif
 
 #else
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index c638427..f09014c 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -2,102 +2,161 @@
  * Dynamic function tracing support.
  *
  * Copyright (C) 2008 Abhishek Sagar <sagar.abhishek@gmail.com>
+ * Copyright (C) 2010 Rabin Vincent <rabin@rab.in>
  *
  * For licencing details, see COPYING.
  *
  * Defines low-level handling of mcount calls when the kernel
  * is compiled with the -pg flag. When using dynamic ftrace, the
- * mcount call-sites get patched lazily with NOP till they are
- * enabled. All code mutation routines here take effect atomically.
+ * mcount call-sites get patched with NOP till they are enabled.
+ * All code mutation routines here are called under stop_machine().
  */
 
 #include <linux/ftrace.h>
+#include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 
-#define PC_OFFSET      8
-#define BL_OPCODE      0xeb000000
-#define BL_OFFSET_MASK 0x00ffffff
+#define	NOP		0xe8bd4000	/* pop {lr} */
 
-static unsigned long bl_insn;
-static const unsigned long NOP = 0xe1a00000; /* mov r0, r0 */
+#ifdef CONFIG_OLD_MCOUNT
+#define OLD_MCOUNT_ADDR	((unsigned long) mcount)
+#define OLD_FTRACE_ADDR ((unsigned long) ftrace_caller_old)
 
-unsigned char *ftrace_nop_replace(void)
+#define	OLD_NOP		0xe1a00000	/* mov r0, r0 */
+
+static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
+{
+	return rec->arch.old_mcount ? OLD_NOP : NOP;
+}
+
+static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
+{
+	if (!rec->arch.old_mcount)
+		return addr;
+
+	if (addr == MCOUNT_ADDR)
+		addr = OLD_MCOUNT_ADDR;
+	else if (addr == FTRACE_ADDR)
+		addr = OLD_FTRACE_ADDR;
+
+	return addr;
+}
+#else
+static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
+{
+	return NOP;
+}
+
+static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 {
-	return (char *)&NOP;
+	return addr;
 }
+#endif
 
 /* construct a branch (BL) instruction to addr */
-unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
 	long offset;
 
-	offset = (long)addr - (long)(pc + PC_OFFSET);
+	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
 		/* Can't generate branches that far (from ARM ARM). Ftrace
 		 * doesn't generate branches outside of kernel text.
 		 */
 		WARN_ON_ONCE(1);
-		return NULL;
+		return 0;
 	}
-	offset = (offset >> 2) & BL_OFFSET_MASK;
-	bl_insn = BL_OPCODE | offset;
-	return (unsigned char *)&bl_insn;
-}
 
-int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
-		       unsigned char *new_code)
-{
-	unsigned long err = 0, replaced = 0, old, new;
+	offset = (offset >> 2) & 0x00ffffff;
 
-	old = *(unsigned long *)old_code;
-	new = *(unsigned long *)new_code;
+	return 0xeb000000 | offset;
+}
 
-	__asm__ __volatile__ (
-		"1:  ldr    %1, [%2]  \n"
-		"    cmp    %1, %4    \n"
-		"2:  streq  %3, [%2]  \n"
-		"    cmpne  %1, %3    \n"
-		"    movne  %0, #2    \n"
-		"3:\n"
+static int ftrace_modify_code(unsigned long pc, unsigned long old,
+			      unsigned long new)
+{
+	unsigned long replaced;
 
-		".section .fixup, \"ax\"\n"
-		"4:  mov  %0, #1  \n"
-		"    b    3b      \n"
-		".previous\n"
+	if (probe_kernel_read(&replaced, (void *)pc, MCOUNT_INSN_SIZE))
+		return -EFAULT;
 
-		".section __ex_table, \"a\"\n"
-		"    .long 1b, 4b \n"
-		"    .long 2b, 4b \n"
-		".previous\n"
+	if (replaced != old)
+		return -EINVAL;
 
-		: "=r"(err), "=r"(replaced)
-		: "r"(pc), "r"(new), "r"(old), "0"(err), "1"(replaced)
-		: "memory");
+	if (probe_kernel_write((void *)pc, &new, MCOUNT_INSN_SIZE))
+		return -EPERM;
 
-	if (!err && (replaced == old))
-		flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
+	flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
 
-	return err;
+	return 0;
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
-	int ret;
 	unsigned long pc, old;
-	unsigned char *new;
+	unsigned long new;
+	int ret;
 
 	pc = (unsigned long)&ftrace_call;
 	memcpy(&old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(pc, (unsigned long)func);
-	ret = ftrace_modify_code(pc, (unsigned char *)&old, new);
+
+	ret = ftrace_modify_code(pc, old, new);
+
+#ifdef CONFIG_OLD_MCOUNT
+	if (!ret) {
+		pc = (unsigned long)&ftrace_call_old;
+		memcpy(&old, &ftrace_call_old, MCOUNT_INSN_SIZE);
+		new = ftrace_call_replace(pc, (unsigned long)func);
+
+		ret = ftrace_modify_code(pc, old, new);
+	}
+#endif
+
+	return ret;
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long new, old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_nop_replace(rec);
+	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip = rec->ip;
+	unsigned long old;
+	unsigned long new;
+	int ret;
+
+	old = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_nop_replace(rec);
+	ret = ftrace_modify_code(ip, old, new);
+
+#ifdef CONFIG_OLD_MCOUNT
+	if (ret == -EINVAL && addr == MCOUNT_ADDR) {
+		rec->arch.old_mcount = true;
+
+		old = ftrace_call_replace(ip, adjust_address(rec, addr));
+		new = ftrace_nop_replace(rec);
+		ret = ftrace_modify_code(ip, old, new);
+	}
+#endif
+
 	return ret;
 }
 
-/* run from ftrace_init with irqs disabled */
 int __init ftrace_dyn_arch_init(void *data)
 {
-	ftrace_mcount_set(data);
+	*(unsigned long *)data = 0;
+
 	return 0;
 }
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index ea6f6e3..66c1c4b 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -267,6 +267,8 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "arm") {
     $alignment = 2;
     $section_type = '%progbits';
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24)" .
+			"\\s+(__gnu_mcount_nc|mcount)\$";
 
 } elsif ($arch eq "ia64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
-- 
1.6.6

