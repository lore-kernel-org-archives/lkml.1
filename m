Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYFUSSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYFUSSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYFUSSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:18:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:53415 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYFUSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fdSUVJStWWqETmXYywPh38/TOrAwn3ObHexk4jkxM8C1cbvi07PwIUC9Mii65kp428
         URwSQyY1xHTGm+S37jX4eIE/IzRZMtlvucQsNMgRrffUaRq4rtIUXh+MW0yIgq1Om21X
         IJLzQPkSpPznpISLb9qF/P+tejdHf1PvJyRJI=
Message-ID: <485D45B7.1080105@gmail.com>
Date: Sat, 21 Jun 2008 23:47:27 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: davem@davemloft.net, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ftrace: store mcount address in rec->ip
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record mcount call-site addresses. Tested on x86-32 and ARM. Would be a good
good idea to boot test it on sparc64, ppc and x86-64 before applying.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

Record the address of the mcount call-site. Currently all archs except sparc64
record the address of the instruction following the mcount call-site. Some
general cleanups are entailed. Storing mcount addresses in rec->ip enables
looking them up in the kprobe hash table later on to check if they're kprobe'd.

diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 3b13221..cc7b246 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -18,6 +18,7 @@
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
+#include <asm/ftrace.h>
 
 /*
  * libgcc functions - functions that are used internally by the
@@ -48,11 +49,6 @@ extern void __aeabi_ulcmp(void);
 extern void fpundefinstr(void);
 extern void fp_enter(void);
 
-#ifdef CONFIG_FTRACE
-extern void mcount(void);
-EXPORT_SYMBOL(mcount);
-#endif
-
 /*
  * This has a special calling convention; it doesn't
  * modify any of the usual registers, except for LR.
@@ -186,3 +182,7 @@ EXPORT_SYMBOL(_find_next_bit_be);
 #endif
 
 EXPORT_SYMBOL(copy_page);
+
+#ifdef CONFIG_FTRACE
+EXPORT_SYMBOL(mcount);
+#endif
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 8f79a47..84694e8 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -9,6 +9,7 @@
  */
 
 #include <asm/unistd.h>
+#include <asm/ftrace.h>
 #include <asm/arch/entry-macro.S>
 
 #include "entry-header.S"
@@ -104,6 +105,7 @@ ENTRY(ret_from_fork)
 ENTRY(mcount)
 	stmdb sp!, {r0-r3, lr}
 	mov r0, lr
+	sub r0, r0, #MCOUNT_INSN_SIZE
 
 	.globl mcount_call
 mcount_call:
@@ -114,6 +116,7 @@ ENTRY(ftrace_caller)
 	stmdb sp!, {r0-r3, lr}
 	ldr r1, [fp, #-4]
 	mov r0, lr
+	sub r0, r0, #MCOUNT_INSN_SIZE
 
 	.globl ftrace_call
 ftrace_call:
@@ -134,6 +137,7 @@ ENTRY(mcount)
 trace:
 	ldr r1, [fp, #-4]
 	mov r0, lr
+	sub r0, r0, #MCOUNT_INSN_SIZE
 	mov lr, pc
 	mov pc, r2
 	ldmia sp!, {r0-r3, pc}
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 22f3d6e..76d50e6 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -12,9 +12,10 @@
  */
 
 #include <linux/ftrace.h>
+
 #include <asm/cacheflush.h>
+#include <asm/ftrace.h>
 
-#define INSN_SIZE      4
 #define PC_OFFSET      8
 #define BL_OPCODE      0xeb000000
 #define BL_OFFSET_MASK 0x00ffffff
@@ -32,10 +33,10 @@ unsigned char *ftrace_call_replace(unsigned long pc, unsigned long addr)
 {
 	long offset;
 
-	offset = (long)addr - (long)(pc - INSN_SIZE + PC_OFFSET);
+	offset = (long)addr - (long)(pc + PC_OFFSET);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
 		/* Can't generate branches that far (from ARM ARM). Ftrace
-		 * doesn't generate branches outside of core kernel text.
+		 * doesn't generate branches outside of kernel text.
 		 */
 		WARN_ON_ONCE(1);
 		return NULL;
@@ -52,7 +53,6 @@ int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
 
 	old = *(unsigned long *)old_code;
 	new = *(unsigned long *)new_code;
-	pc -= INSN_SIZE;
 
 	__asm__ __volatile__ (
 		"1:  ldr    %1, [%2]  \n"
@@ -77,7 +77,7 @@ int ftrace_modify_code(unsigned long pc, unsigned char *old_code,
 		: "memory");
 
 	if (!err && (replaced == old))
-		flush_icache_range(pc, pc + INSN_SIZE);
+		flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
 
 	return err;
 }
@@ -89,8 +89,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	unsigned char *new;
 
 	pc = (unsigned long)&ftrace_call;
-	pc += INSN_SIZE;
-	memcpy(&old, &ftrace_call, INSN_SIZE);
+	memcpy(&old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(pc, (unsigned long)func);
 	ret = ftrace_modify_code(pc, (unsigned char *)&old, new);
 	return ret;
@@ -103,8 +102,7 @@ int ftrace_mcount_set(unsigned long *data)
 	unsigned char *new;
 
 	pc = (unsigned long)&mcount_call;
-	pc += INSN_SIZE;
-	memcpy(&old, &mcount_call, INSN_SIZE);
+	memcpy(&old, &mcount_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(pc, *addr);
 	*addr = ftrace_modify_code(pc, (unsigned char *)&old, new);
 	return 0;
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 3b1dd29..7231a70 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -30,6 +30,7 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
+#include <asm/ftrace.h>
 
 #undef SHOW_SYSCALLS
 #undef SHOW_SYSCALLS_TASK
@@ -1053,6 +1054,7 @@ _GLOBAL(_mcount)
 	stw	r10,40(r1)
 	stw	r3, 44(r1)
 	stw	r5, 8(r1)
+	subi	r3, r3, MCOUNT_INSN_SIZE
 	.globl mcount_call
 mcount_call:
 	bl	ftrace_stub
@@ -1090,6 +1092,7 @@ _GLOBAL(ftrace_caller)
 	stw	r10,40(r1)
 	stw	r3, 44(r1)
 	stw	r5, 8(r1)
+	subi	r3, r3, MCOUNT_INSN_SIZE
 .globl ftrace_call
 ftrace_call:
 	bl	ftrace_stub
@@ -1128,6 +1131,7 @@ _GLOBAL(_mcount)
 	stw	r3, 44(r1)
 	stw	r5, 8(r1)
 
+	subi	r3, r3, MCOUNT_INSN_SIZE
 	LOAD_REG_ADDR(r5, ftrace_trace_function)
 	lwz	r5,0(r5)
 
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 2c4d9e0..2f511a9 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -31,6 +31,7 @@
 #include <asm/bug.h>
 #include <asm/ptrace.h>
 #include <asm/irqflags.h>
+#include <asm/ftrace.h>
 
 /*
  * System calls.
@@ -879,6 +880,7 @@ _GLOBAL(_mcount)
 	mflr	r3
 	stdu	r1, -112(r1)
 	std	r3, 128(r1)
+	subi	r3, r3, MCOUNT_INSN_SIZE
 	.globl mcount_call
 mcount_call:
 	bl	ftrace_stub
@@ -895,6 +897,7 @@ _GLOBAL(ftrace_caller)
 	stdu	r1, -112(r1)
 	std	r3, 128(r1)
 	ld	r4, 16(r11)
+	subi	r3, r3, MCOUNT_INSN_SIZE
 .globl ftrace_call
 ftrace_call:
 	bl	ftrace_stub
@@ -916,7 +919,7 @@ _GLOBAL(_mcount)
 	std	r3, 128(r1)
 	ld	r4, 16(r11)
 
-
+	subi	r3, r3, MCOUNT_INSN_SIZE
 	LOAD_REG_ADDR(r5,ftrace_trace_function)
 	ld	r5,0(r5)
 	ld	r5,0(r5)
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index e12c593..3855ceb 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -15,8 +15,8 @@
 #include <linux/list.h>
 
 #include <asm/cacheflush.h>
+#include <asm/ftrace.h>
 
-#define CALL_BACK		4
 
 static unsigned int ftrace_nop = 0x60000000;
 
@@ -27,9 +27,10 @@ static unsigned int ftrace_nop = 0x60000000;
 # define GET_ADDR(addr) *(unsigned long *)addr
 #endif
 
+
 static unsigned int notrace ftrace_calc_offset(long ip, long addr)
 {
-	return (int)((addr + CALL_BACK) - ip);
+	return (int)(addr - ip);
 }
 
 notrace unsigned char *ftrace_nop_replace(void)
@@ -76,9 +77,6 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	unsigned new = *(unsigned *)new_code;
 	int faulted = 0;
 
-	/* move the IP back to the start of the call */
-	ip -= CALL_BACK;
-
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
@@ -118,12 +116,10 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
-	unsigned char old[4], *new;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 	int ret;
 
-	ip += CALL_BACK;
-
-	memcpy(old, &ftrace_call, 4);
+	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = ftrace_modify_code(ip, old, new);
 
@@ -134,16 +130,13 @@ notrace int ftrace_mcount_set(unsigned long *data)
 {
 	unsigned long ip = (long)(&mcount_call);
 	unsigned long *addr = data;
-	unsigned char old[4], *new;
-
-	/* ip is at the location, but modify code will subtact this */
-	ip += CALL_BACK;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 
 	/*
 	 * Replace the mcount stub with a pointer to the
 	 * ip recorder function.
 	 */
-	memcpy(old, &mcount_call, 4);
+	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, *addr);
 	*addr = ftrace_modify_code(ip, old, new);
 
diff --git a/arch/sparc64/kernel/ftrace.c b/arch/sparc64/kernel/ftrace.c
index c173731..4298d0a 100644
--- a/arch/sparc64/kernel/ftrace.c
+++ b/arch/sparc64/kernel/ftrace.c
@@ -5,6 +5,8 @@
 #include <linux/init.h>
 #include <linux/list.h>
 
+#include <asm/ftrace.h>
+
 static const u32 ftrace_nop = 0x01000000;
 
 notrace unsigned char *ftrace_nop_replace(void)
@@ -60,9 +62,9 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
-	unsigned char old[4], *new;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 
-	memcpy(old, &ftrace_call, 4);
+	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	return ftrace_modify_code(ip, old, new);
 }
@@ -71,13 +73,13 @@ notrace int ftrace_mcount_set(unsigned long *data)
 {
 	unsigned long ip = (long)(&mcount_call);
 	unsigned long *addr = data;
-	unsigned char old[4], *new;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 
 	/*
 	 * Replace the mcount stub with a pointer to the
 	 * ip recorder function.
 	 */
-	memcpy(old, &mcount_call, 4);
+	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, *addr);
 	*addr = ftrace_modify_code(ip, old, new);
 
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 8ac0b99..b80d982 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,6 +53,7 @@
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
+#include <asm/ftrace.h>
 
 struct poll {
 	int fd;
@@ -112,7 +113,6 @@ EXPORT_SYMBOL(smp_call_function);
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_MCOUNT)
-extern void _mcount(void);
 EXPORT_SYMBOL(_mcount);
 #endif
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 04ea83c..95e6bbe 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -51,6 +51,7 @@
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
 #include <asm/processor-flags.h>
+#include <asm/ftrace.h>
 #include "irq_vectors.h"
 
 /*
@@ -1118,6 +1119,7 @@ ENTRY(mcount)
 	pushl %ecx
 	pushl %edx
 	movl 0xc(%esp), %eax
+	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl mcount_call
 mcount_call:
@@ -1136,6 +1138,7 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
 ftrace_call:
@@ -1166,6 +1169,7 @@ trace:
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	subl $MCOUNT_INSN_SIZE, %eax
 
 	call *ftrace_trace_function
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index fe25e5f..b0f7308 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -51,6 +51,7 @@
 #include <asm/page.h>
 #include <asm/irqflags.h>
 #include <asm/paravirt.h>
+#include <asm/ftrace.h>
 
 	.code64
 
@@ -68,6 +69,7 @@ ENTRY(mcount)
 	movq %r9, 48(%rsp)
 
 	movq 0x38(%rsp), %rdi
+	subq $MCOUNT_INSN_SIZE, %rdi
 
 .globl mcount_call
 mcount_call:
@@ -99,6 +101,7 @@ ENTRY(ftrace_caller)
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
+	subq $MCOUNT_INSN_SIZE, %rdi
 
 .globl ftrace_call
 ftrace_call:
@@ -139,6 +142,7 @@ trace:
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
+	subq $MCOUNT_INSN_SIZE, %rdi
 
 	call   *ftrace_trace_function
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5582814..ab115cd 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,20 +17,21 @@
 #include <linux/list.h>
 
 #include <asm/alternative.h>
+#include <asm/ftrace.h>
 
-#define CALL_BACK		5
 
 /* Long is fine, even if it is only 4 bytes ;-) */
 static long *ftrace_nop;
 
 union ftrace_code_union {
-	char code[5];
+	char code[MCOUNT_INSN_SIZE];
 	struct {
 		char e8;
 		int offset;
 	} __attribute__((packed));
 };
 
+
 static int notrace ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
@@ -46,7 +47,7 @@ notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	static union ftrace_code_union calc;
 
 	calc.e8		= 0xe8;
-	calc.offset	= ftrace_calc_offset(ip, addr);
+	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
 
 	/*
 	 * No locking needed, this must be called via kstop_machine
@@ -65,9 +66,6 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	unsigned char newch = new_code[4];
 	int faulted = 0;
 
-	/* move the IP back to the start of the call */
-	ip -= CALL_BACK;
-
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
@@ -102,12 +100,10 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
-	unsigned char old[5], *new;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 	int ret;
 
-	ip += CALL_BACK;
-
-	memcpy(old, &ftrace_call, 5);
+	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = ftrace_modify_code(ip, old, new);
 
@@ -118,16 +114,13 @@ notrace int ftrace_mcount_set(unsigned long *data)
 {
 	unsigned long ip = (long)(&mcount_call);
 	unsigned long *addr = data;
-	unsigned char old[5], *new;
-
-	/* ip is at the location, but modify code will subtact this */
-	ip += CALL_BACK;
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
 
 	/*
 	 * Replace the mcount stub with a pointer to the
 	 * ip recorder function.
 	 */
-	memcpy(old, &mcount_call, 5);
+	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
 	new = ftrace_call_replace(ip, *addr);
 	*addr = ftrace_modify_code(ip, old, new);
 
@@ -142,8 +135,7 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	ftrace_mcount_set(data);
 
-	ftrace_nop = (unsigned long *)noptable[CALL_BACK];
+	ftrace_nop = (unsigned long *)noptable[MCOUNT_INSN_SIZE];
 
 	return 0;
 }
-
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 29999db..dd7ebee 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -1,9 +1,9 @@
-#include <linux/ftrace.h>
 #include <linux/module.h>
 
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
 #include <asm/desc.h>
+#include <asm/ftrace.h>
 
 #ifdef CONFIG_FTRACE
 /* mcount is defined in assembly */
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 122885b..16ff4bf 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -1,7 +1,6 @@
 /* Exports for assembly files.
    All C exports should go in the respective C files. */
 
-#include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/smp.h>
 
@@ -11,6 +10,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
+#include <asm/ftrace.h>
 
 #ifdef CONFIG_FTRACE
 /* mcount is defined in assembly */
diff --git a/include/asm-arm/ftrace.h b/include/asm-arm/ftrace.h
new file mode 100644
index 0000000..584ef9a
--- /dev/null
+++ b/include/asm-arm/ftrace.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_ARM_FTRACE
+#define _ASM_ARM_FTRACE
+
+#ifdef CONFIG_FTRACE
+#define MCOUNT_ADDR		((long)(mcount))
+#define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void mcount(void);
+#endif
+
+#endif
+
+#endif /* _ASM_ARM_FTRACE */
diff --git a/include/asm-powerpc/ftrace.h b/include/asm-powerpc/ftrace.h
index b1bfa70..de92132 100644
--- a/include/asm-powerpc/ftrace.h
+++ b/include/asm-powerpc/ftrace.h
@@ -1,6 +1,14 @@
 #ifndef _ASM_POWERPC_FTRACE
 #define _ASM_POWERPC_FTRACE
 
+#ifdef CONFIG_FTRACE
+#define MCOUNT_ADDR		((long)(_mcount))
+#define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
 extern void _mcount(void);
+#endif
 
 #endif
+
+#endif /* _ASM_POWERPC_FTRACE */
diff --git a/include/asm-sparc64/ftrace.h b/include/asm-sparc64/ftrace.h
new file mode 100644
index 0000000..f76a40a
--- /dev/null
+++ b/include/asm-sparc64/ftrace.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_SPARC64_FTRACE
+#define _ASM_SPARC64_FTRACE
+
+#ifdef CONFIG_FTRACE
+#define MCOUNT_ADDR		((long)(_mcount))
+#define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void _mcount(void);
+#endif
+
+#endif
+
+#endif /* _ASM_SPARC64_FTRACE */
diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
new file mode 100644
index 0000000..c184441
--- /dev/null
+++ b/include/asm-x86/ftrace.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_FTRACE
+#define _ASM_SPARC64_FTRACE
+
+#ifdef CONFIG_FTRACE
+#define MCOUNT_ADDR		((long)(mcount))
+#define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void mcount(void);
+#endif
+
+#endif /* CONFIG_FTRACE */
+
+#endif /* _ASM_X86_FTRACE */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 20e14d0..366098d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -31,7 +31,6 @@ int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
-extern void mcount(void);
 
 #else /* !CONFIG_FTRACE */
 # define register_ftrace_function(ops) do { } while (0)
@@ -54,7 +53,7 @@ enum {
 
 struct dyn_ftrace {
 	struct hlist_node node;
-	unsigned long	  ip;
+	unsigned long	  ip; /* address of mcount call-site */
 	unsigned long	  flags;
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0d5bcf6..f1e9e5c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,8 @@
 #include <linux/hash.h>
 #include <linux/list.h>
 
+#include <asm/ftrace.h>
+
 #include "trace.h"
 
 /* ftrace_enabled is a method to turn ftrace on or off */
@@ -329,7 +331,6 @@ ftrace_record_ip(unsigned long ip)
 }
 
 #define FTRACE_ADDR ((long)(ftrace_caller))
-#define MCOUNT_ADDR ((long)(mcount))
 
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec,
