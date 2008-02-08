Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbYBHV2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYBHV2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYBHV2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:28:36 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:52437 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYBHV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:28:34 -0500
Message-ID: <47ACC97C.3000806@web.de>
Date: Fri, 08 Feb 2008 22:28:28 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC][PATCH] KGDB: remove kgdb-own fault handling (was: Re: [git
 pull] x86 arch updates for v2.6.25)
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <p73ejbn2xk2.fsf@bingen.suse.de> <47AC95FC.5090701@siemens.com> <20080208185719.GA11573@one.firstfloor.org>
In-Reply-To: <20080208185719.GA11573@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19SRGwyiVMp36RkPVpxcORWrWKXLvMNTT3nPGWy
	7UM6P8yqLOTAL6T4gGC+yhKIrgW8k+wECBjE+DZ4DcGYtFuQ75
	nxAM7va+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> /me was once wondering as well why kgdb installs a seconds way of
>> handling (its own) faults. Jason explained to me that this approach is
>> more robust against corruption along the normal fix-up path.
> 
> That's 100% bogus.
> 
>> If you recall the issues (and they are still present), it would be nice
>> to have them listed. kgdb suffered a lot from historic cruft, but we
>> already remove at least some of it over the last patching rounds.
>> Whatever remains should be addressed ASAP.
> 
> I sent Jason a couple of mails last time when he posted (and before that the
> previous maintainer when he tried to merge it).   All were
> fairly "beratungsresistent".
> 
> If you're truly interested i can dig out the mails or do a fresh review.
> 
> Long ago I did a quite clean x86-64 kgdb for Linux 2.4 based on the 
> old 2.4 stub that dropped in without any strange other hooks
> (except for a straight forward change to the serial code). It worked
> just fine this way.

Well, let's try it this way: Find below a patch against kgdb.git that
removes the special fault handling (this wouldn't be the first feature I
recently removed from kgdb :->). Light testing revealed no obvious
problems yet.

Jason, please tell us what problems this could cause. I just dug out the
reply you sent me regarding this last year, and you specifically
mentioned non-recoverable unaligned accesses by gdb on MIPS. Is this
still true? Is there no way to handle this particular arch separately
and leave the rest happily with what the kernel already provides?

Jan


----snip----

As the kernel already provides the infrastructure to carefully access
potentially bogus memory locations, kgdb does not need to maintain its
own, complex, arch-dependent mechanism.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 arch/x86/kernel/Makefile      |    2 
 arch/x86/kernel/kgdb-jmp_32.S |   74 ------------------------
 arch/x86/kernel/kgdb-jmp_64.S |   65 ---------------------
 arch/x86/kernel/kgdb.c        |    5 -
 include/asm-x86/kgdb.h        |    6 --
 include/linux/kgdb.h          |   27 ---------
 kernel/kgdb.c                 |  125 ++++--------------------------------------
 7 files changed, 16 insertions(+), 288 deletions(-)

Index: b/arch/x86/kernel/Makefile
===================================================================
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,7 +58,7 @@ obj-$(CONFIG_MODULES)		+= module_$(BITS)
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
-obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp_$(BITS).o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
Index: b/arch/x86/kernel/kgdb-jmp_32.S
===================================================================
--- a/arch/x86/kernel/kgdb-jmp_32.S
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- * arch/x86/kernel/kgdb-jmp_32.S
- *
- * Save and restore system registers so that within a limited frame we
- * may have a fault and "jump back" to a known safe location.
- *
- * Author: George Anzinger <george@mvista.com>
- *
- * Cribbed from glibc, which carries the following:
- * Copyright (C) 1996, 1996, 1997, 2000, 2001 Free Software Foundation, Inc.
- * Copyright (C) 2005 by MontaVista Software.
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program as licensed "as is" without any warranty of
- * any kind, whether express or implied.
- */
-
-#include <linux/linkage.h>
-
-#define PCOFF		0
-#define LINKAGE		4		/* just the return address */
-#define PTR_SIZE	4
-#define PARMS		LINKAGE		/* no space for saved regs */
-#define JMPBUF		PARMS
-#define VAL		JMPBUF+PTR_SIZE
-
-#define JB_BX		0
-#define JB_SI		1
-#define JB_DI		2
-#define JB_BP		3
-#define JB_SP		4
-#define JB_PC		5
-
-/* This must be called prior to kgdb_fault_longjmp and
- * kgdb_fault_longjmp must not be called outside of the context of the
- * last call to kgdb_fault_setjmp.
- * kgdb_fault_setjmp(int *jmp_buf[6])
- */
-ENTRY(kgdb_fault_setjmp)
-	movl JMPBUF(%esp), %eax
-
-	/* Save registers.  */
-	movl	%ebx, (JB_BX*4)(%eax)
-	movl	%esi, (JB_SI*4)(%eax)
-	movl	%edi, (JB_DI*4)(%eax)
-	/* Save SP as it will be after we return.  */
-	leal	JMPBUF(%esp), %ecx
-	movl	%ecx, (JB_SP*4)(%eax)
-	movl	PCOFF(%esp), %ecx	/* Save PC we are returning to now.  */
-	movl	%ecx, (JB_PC*4)(%eax)
-	movl	%ebp, (JB_BP*4)(%eax)	/* Save caller's frame pointer.  */
-
-	/* Restore state so we can now try the access. */
-	movl	JMPBUF(%esp), %ecx	/* User's jmp_buf in %ecx.  */
-	/* Save the return address now.  */
-	movl	(JB_PC*4)(%ecx), %edx
-	/* Restore registers.  */
-	movl	$0, %eax
-	movl	(JB_SP*4)(%ecx), %esp
-	jmp	*%edx		/* Jump to saved PC. */
-
-/* kgdb_fault_longjmp(int *jmp_buf[6]) */
-ENTRY(kgdb_fault_longjmp)
-	movl	JMPBUF(%esp), %ecx	/* User's jmp_buf in %ecx.  */
-	/* Save the return address now.  */
-	movl	(JB_PC*4)(%ecx), %edx
-	/* Restore registers.  */
-	movl	(JB_BX*4)(%ecx), %ebx
-	movl	(JB_SI*4)(%ecx), %esi
-	movl	(JB_DI*4)(%ecx), %edi
-	movl	(JB_BP*4)(%ecx), %ebp
-	movl	$1, %eax
-	movl	(JB_SP*4)(%ecx), %esp
-	jmp	*%edx		/* Jump to saved PC. */
Index: b/arch/x86/kernel/kgdb-jmp_64.S
===================================================================
--- a/arch/x86/kernel/kgdb-jmp_64.S
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- * arch/x86/kernel/kgdb-jmp.S
- *
- * Save and restore system registers so that within a limited frame we
- * may have a fault and "jump back" to a known safe location.
- *
- * Author: Tom Rini <trini@kernel.crashing.org>
- *
- * Cribbed from glibc, which carries the following:
- * Copyright (C) 2001, 2003, 2004 Free Software Foundation, Inc.
- * Copyright (C) 2005 by MontaVista Software.
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program as licensed "as is" without any warranty of
- * any kind, whether express or implied.
- */
-
-#include <linux/linkage.h>
-
-#define JB_RBX		0
-#define JB_RBP		1
-#define JB_R12		2
-#define JB_R13		3
-#define JB_R14		4
-#define JB_R15		5
-#define JB_RSP		6
-#define JB_PC		7
-
-	.code64
-
-/* This must be called prior to kgdb_fault_longjmp and
- * kgdb_fault_longjmp must not be called outside of the context of the
- * last call to kgdb_fault_setjmp.
- */
-ENTRY(kgdb_fault_setjmp)
-	/* Save registers. */
-	movq %rbx, (JB_RBX*8)(%rdi)
-	movq %rbp, (JB_RBP*8)(%rdi)
-	movq %r12, (JB_R12*8)(%rdi)
-	movq %r13, (JB_R13*8)(%rdi)
-	movq %r14, (JB_R14*8)(%rdi)
-	movq %r15, (JB_R15*8)(%rdi)
-	leaq 8(%rsp), %rdx	/* Save SP as it will be after we return. */
-	movq %rdx, (JB_RSP*8)(%rdi)
-	movq (%rsp), %rax	/* Save PC we are returning to now. */
-	movq %rax, (JB_PC*8)(%rdi)
-	/* Set return value for setjmp. */
-	mov $0,%eax
-	movq (JB_PC*8)(%rdi),%rdx
-	movq (JB_RSP*8)(%rdi),%rsp
-	jmpq *%rdx
-
-ENTRY(kgdb_fault_longjmp)
-	/* Restore registers. */
-	movq (JB_RBX*8)(%rdi),%rbx
-	movq (JB_RBP*8)(%rdi),%rbp
-	movq (JB_R12*8)(%rdi),%r12
-	movq (JB_R13*8)(%rdi),%r13
-	movq (JB_R14*8)(%rdi),%r14
-	movq (JB_R15*8)(%rdi),%r15
-	/* Set return value for setjmp. */
-	movq (JB_PC*8)(%rdi),%rdx
-	movq (JB_RSP*8)(%rdi),%rsp
-	mov $1,%eax
-	jmpq *%rdx
Index: b/include/asm-x86/kgdb.h
===================================================================
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -63,15 +63,11 @@ enum regnames { _AX,	/* 0 */
 };
 #endif /* CONFIG_X86_32 */
 
-/* Number of bytes of registers and critical bytes required for a
- * setjmp/longjmp
- */
+/* Number of bytes for gdb registers */
 #ifdef CONFIG_X86_32
 #define NUMREGBYTES		64
-#define NUMCRITREGBYTES		24
 #else /* ! CONFIG_X86_32 */
 #define NUMREGBYTES		((_PS+1)*8)
-#define NUMCRITREGBYTES		(8 * 8)		/* 8 registers. */
 #endif /* CONFIG_X86_32 */
 
 #ifndef __ASSEMBLY__
Index: b/include/linux/kgdb.h
===================================================================
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -32,7 +32,6 @@ struct uart_port;
 void breakpoint(void);
 
 extern int kgdb_connected;
-extern int kgdb_may_fault;
 
 extern atomic_t			kgdb_setting_breakpoint;
 extern atomic_t			cpu_doing_single_step;
@@ -165,32 +164,6 @@ int kgdb_arch_handle_exception(int vecto
  */
 void kgdb_roundup_cpus(unsigned long flags);
 
-#ifndef JMP_REGS_ALIGNMENT
-# define JMP_REGS_ALIGNMENT
-#endif
-
-extern unsigned long		kgdb_fault_jmp_regs[];
-
-/**
- *	kgdb_fault_setjmp - Store state in case we fault.
- *	@curr_context: An array to store state into.
- *
- *	Certain functions may try to access memory, and in doing so may
- *	cause a fault.  When this happens, we trap it, restore state to
- *	this call, and let ourself know that something bad has happened.
- */
-asmlinkage int kgdb_fault_setjmp(unsigned long *curr_context);
-
-/**
- *	kgdb_fault_longjmp - Restore state when we have faulted.
- *	@curr_context: The previously stored state.
- *
- *	When something bad does happen, this function is called to
- *	restore the known good state, and set the return value to 1, so
- *	we know something bad happened.
- */
-asmlinkage void kgdb_fault_longjmp(unsigned long *curr_context);
-
 /* Optional functions. */
 int kgdb_validate_break_address(unsigned long addr);
 int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -72,12 +72,6 @@ struct debuggerinfo_struct {
 	struct task_struct	*task;
 } kgdb_info[NR_CPUS];
 
-/*
- * Could we be about to try and access a bad memory location?
- * If so we also need to flag this has happened.
- */
-int				kgdb_may_fault;
-
 /* Is a host GDB connected to us? */
 int				kgdb_connected;
 EXPORT_SYMBOL_GPL(kgdb_connected);
@@ -133,10 +127,6 @@ static unsigned long		gdb_regs[(NUMREGBY
 					sizeof(unsigned long) - 1) /
 					sizeof(unsigned long)];
 
-/* Storage of registers for handling a fault. */
-unsigned long			kgdb_fault_jmp_regs[NUMCRITREGBYTES /
-				sizeof(unsigned long)] JMP_REGS_ALIGNMENT;
-
 /* to keep track of the CPU which is doing the single stepping*/
 atomic_t			cpu_doing_single_step = ATOMIC_INIT(-1);
 
@@ -314,44 +304,6 @@ static void put_packet(char *buffer)
 }
 
 /*
- * Black magic portion. Dont look too closely. Limited setjmp support.
- */
-
-/*
- * Wrap kgdb_fault_setjmp() call to enable the kernel faults and save/restore
- * the state before/after a fault has happened.
- * Note that it *must* be inline to work correctly.
- */
-static __always_inline int fault_setjmp(void)
-{
-#ifdef CONFIG_PREEMPT
-	int count = preempt_count();
-#endif
-
-	/*
-	 * kgdb_fault_setjmp() returns 0 after the jump buffer has been setup,
-	 * and non-zero when an expected kernel fault has happened.
-	 */
-	if (kgdb_fault_setjmp(kgdb_fault_jmp_regs) == 0) {
-		kgdb_may_fault = 1;
-		return 0;
-	} else {
-		/*
-		 * Close your eyes please!
-		 */
-#ifdef CONFIG_PREEMPT
-		preempt_count() = count;
-#endif
-		/*
-		 * Thanks, you may open them now!
-		 */
-		kgdb_may_fault = 0;
-
-		return 1;
-	}
-}
-
-/*
  * Fault-tolerant memory accessor wrappers. Performance is a secondary
  * concern, the primary concern is not to crash the debugger (or the
  * debuggee):
@@ -363,9 +315,6 @@ static __always_inline int fault_setjmp(
  */
 char *kgdb_mem2hex(char *mem, char *buf, int count)
 {
-	if (fault_setjmp() != 0)
-		return ERR_PTR(-EINVAL);
-
 	/*
 	 * Accessing some registers in a single load instruction is
 	 * required to avoid bad side effects for some I/O registers.
@@ -373,10 +322,8 @@ char *kgdb_mem2hex(char *mem, char *buf,
 	if ((count == 2) && (((long)mem & 1) == 0)) {
 		u16 tmp_s;
 
-		if (probe_kernel_address(mem, tmp_s) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if (probe_kernel_address(mem, tmp_s) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 
 		mem += 2;
 #ifdef __BIG_ENDIAN
@@ -392,10 +339,8 @@ char *kgdb_mem2hex(char *mem, char *buf,
 #endif
 	} else if ((count == 4) && (((long)mem & 3) == 0)) {
 		u32 tmp_l;
-		if (probe_kernel_address(mem, tmp_l) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if (probe_kernel_address(mem, tmp_l) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 
 		mem += 4;
 #ifdef __BIG_ENDIAN
@@ -420,10 +365,8 @@ char *kgdb_mem2hex(char *mem, char *buf,
 #ifdef CONFIG_64BIT
 	} else if ((count == 8) && (((long)mem & 7) == 0)) {
 		u64 tmp_ll;
-		if (probe_kernel_address(mem, tmp_ll) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if (probe_kernel_address(mem, tmp_ll) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 
 		mem += 8;
 #ifdef __BIG_ENDIAN
@@ -466,17 +409,14 @@ char *kgdb_mem2hex(char *mem, char *buf,
 		while (count-- > 0) {
 			unsigned char ch;
 
-			if (probe_kernel_address(mem, ch) == -EFAULT) {
-				kgdb_may_fault = 0;
+			if (probe_kernel_address(mem, ch) == -EFAULT)
 				return ERR_PTR(-EINVAL);
-			}
 			mem++;
 			*buf++ = hexchars[ch >> 4];
 			*buf++ = hexchars[ch & 0xf];
 		}
 	}
 
-	kgdb_may_fault = 0;
 	*buf = 0;
 
 	return buf;
@@ -489,26 +429,17 @@ char *kgdb_mem2hex(char *mem, char *buf,
  */
 static char *kgdb_ebin2mem(char *buf, char *mem, int count)
 {
-	if (fault_setjmp() != 0)
-		return ERR_PTR(-EINVAL);
-
 	for (; count > 0; count--, buf++) {
 		if (*buf == 0x7d) {
 			if (probe_kernel_write(mem, (char)(*buf ^ 0x20)) ==
-				-EFAULT) {
-				kgdb_may_fault = 0;
+				-EFAULT)
 				return ERR_PTR(-EINVAL);
-			}
 			buf++;
-		} else {
-			if (probe_kernel_write(mem, *buf) == -EFAULT) {
-				kgdb_may_fault = 0;
+		} else
+			if (probe_kernel_write(mem, *buf) == -EFAULT)
 				return ERR_PTR(-EINVAL);
-			}
-		}
 		mem++;
 	}
-	kgdb_may_fault = 0;
 
 	return mem;
 }
@@ -520,9 +451,6 @@ static char *kgdb_ebin2mem(char *buf, ch
  */
 char *kgdb_hex2mem(char *buf, char *mem, int count)
 {
-	if (fault_setjmp() != 0)
-		return ERR_PTR(-EINVAL);
-
 	if ((count == 2) && (((long)mem & 1) == 0)) {
 		u16 tmp_s = 0;
 
@@ -537,10 +465,8 @@ char *kgdb_hex2mem(char *buf, char *mem,
 		tmp_s |= hex(*buf++) << 12;
 		tmp_s |= hex(*buf++) << 8;
 #endif
-		if (probe_kernel_write(mem, tmp_s) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if (probe_kernel_write(mem, tmp_s) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 		mem += 2;
 	} else if ((count == 4) && (((long)mem & 3) == 0)) {
 		u32 tmp_l = 0;
@@ -564,10 +490,8 @@ char *kgdb_hex2mem(char *buf, char *mem,
 		tmp_l |= hex(*buf++) << 28;
 		tmp_l |= hex(*buf++) << 24;
 #endif
-		if (probe_kernel_write(mem, tmp_l) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if (probe_kernel_write(mem, tmp_l) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 		mem += 4;
 	} else {
 		int i;
@@ -576,14 +500,11 @@ char *kgdb_hex2mem(char *buf, char *mem,
 			unsigned char ch = hex(*buf++) << 4;
 
 			ch |= hex(*buf++);
-			if (probe_kernel_write(mem, ch) == -EFAULT) {
-				kgdb_may_fault = 0;
+			if (probe_kernel_write(mem, ch) == -EFAULT)
 				return ERR_PTR(-EINVAL);
-			}
 			mem++;
 		}
 	}
-	kgdb_may_fault = 0;
 
 	return mem;
 }
@@ -806,46 +727,28 @@ static void kgdb_wait(struct pt_regs *re
 
 char *kgdb_get_mem(char *addr, unsigned char *buf, int count)
 {
-	if (fault_setjmp() != 0)
-		return ERR_PTR(-EINVAL);
-
 	while (count) {
-		if ((unsigned long)addr < TASK_SIZE) {
-			kgdb_may_fault = 0;
-			return ERR_PTR(-EINVAL);
-		}
-		if (probe_kernel_address(addr, *buf) == -EFAULT) {
-			kgdb_may_fault = 0;
+		if ((unsigned long)addr < TASK_SIZE ||
+		    probe_kernel_address(addr, *buf) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
 		buf++;
 		addr++;
 		count--;
 	}
-	kgdb_may_fault = 0;
 
 	return NULL;
 }
 
 char *kgdb_set_mem(char *addr, unsigned char *buf, int count)
 {
-	if (fault_setjmp() != 0)
-		return ERR_PTR(-EINVAL);
-
 	while (count) {
-		if ((unsigned long)addr < TASK_SIZE) {
-			kgdb_may_fault = 0;
+		if ((unsigned long)addr < TASK_SIZE ||
+		    probe_kernel_write(addr, *buf) == -EFAULT)
 			return ERR_PTR(-EINVAL);
-		}
-		if (probe_kernel_write(addr, *buf) == -EFAULT) {
-			kgdb_may_fault = 0;
-			return ERR_PTR(-EINVAL);
-		}
 		buf++;
 		addr++;
 		count--;
 	}
-	kgdb_may_fault = 0;
 
 	return NULL;
 }
Index: b/arch/x86/kernel/kgdb.c
===================================================================
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -475,11 +475,6 @@ static int kgdb_notify(struct notifier_b
 			return NOTIFY_DONE;
 	}
 
-	if (kgdb_may_fault) {
-		kgdb_fault_longjmp(kgdb_fault_jmp_regs);
-		return NOTIFY_STOP;
-	}
-
 	if (kgdb_handle_exception(args->trapnr, args->signr,
 		args->err, regs))
 		return NOTIFY_DONE;
