Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZBINlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZBINlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZBINkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:37837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbZBINko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:44 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/11] x86: fix math_emu register frame access
Date: Mon,  9 Feb 2009 22:39:50 +0900
Message-Id: <1234186798-16820-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_device_not_available() is the handler for #NM and it declares that
it takes a unsigned long and calls math_emu(), which takes a long
argument and surprisingly expects the stack frame starting at the zero
argument would match struct math_emu_info, which isn't true regardless
of configuration in the current code.

This patch makes do_device_not_available() take struct pt_regs like
other exception handlers and initialize struct math_emu_info with
pointer to it and pass pointer to the math_emu_info to math_emulate()
like normal C functions do.  This way, unless gcc makes a copy of
struct pt_regs in do_device_not_available(), the register frame is
correctly accessed regardless of kernel configuration or compiler
used.

This doesn't fix all math_emu problems but it at least gets it
somewhat working.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/math_emu.h |    4 +-
 arch/x86/include/asm/traps.h    |    4 +-
 arch/x86/kernel/traps.c         |   15 +++++---
 arch/x86/math-emu/fpu_entry.c   |    4 +-
 arch/x86/math-emu/fpu_proto.h   |    2 +-
 arch/x86/math-emu/fpu_system.h  |   16 +++------
 arch/x86/math-emu/get_address.c |   66 +++++++++++++++++++-------------------
 7 files changed, 55 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/math_emu.h b/arch/x86/include/asm/math_emu.h
index 302492c..031f626 100644
--- a/arch/x86/include/asm/math_emu.h
+++ b/arch/x86/include/asm/math_emu.h
@@ -11,8 +11,8 @@
 struct math_emu_info {
 	long ___orig_eip;
 	union {
-		struct pt_regs regs;
-		struct kernel_vm86_regs vm86;
+		struct pt_regs *regs;
+		struct kernel_vm86_regs *vm86;
 	};
 };
 #endif /* _ASM_X86_MATH_EMU_H */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 2ee0a3b..36ad79f 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
 dotraplinkage void do_overflow(struct pt_regs *, long);
 dotraplinkage void do_bounds(struct pt_regs *, long);
 dotraplinkage void do_invalid_op(struct pt_regs *, long);
-dotraplinkage void do_device_not_available(struct pt_regs *, long);
+dotraplinkage void do_device_not_available(struct pt_regs);
 dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
 dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
 dotraplinkage void do_segment_not_present(struct pt_regs *, long);
@@ -77,7 +77,7 @@ extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
 void math_error(void __user *);
-asmlinkage void math_emulate(long);
+asmlinkage void math_emulate(struct math_emu_info *);
 #ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
 #else
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index afb46c0..84bdf8f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -900,7 +900,7 @@ asmlinkage void math_state_restore(void)
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-asmlinkage void math_emulate(long arg)
+void math_emulate(struct math_emu_info *info)
 {
 	printk(KERN_EMERG
 		"math-emulation not enabled and no coprocessor found.\n");
@@ -910,16 +910,19 @@ asmlinkage void math_emulate(long arg)
 }
 #endif /* CONFIG_MATH_EMULATION */
 
-dotraplinkage void __kprobes
-do_device_not_available(struct pt_regs *regs, long error)
+dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
 {
 #ifdef CONFIG_X86_32
 	if (read_cr0() & X86_CR0_EM) {
-		conditional_sti(regs);
-		math_emulate(0);
+		struct math_emu_info info = { };
+
+		conditional_sti(&regs);
+
+		info.regs = &regs;
+		math_emulate(&info);
 	} else {
 		math_state_restore(); /* interrupts still off */
-		conditional_sti(regs);
+		conditional_sti(&regs);
 	}
 #else
 	math_state_restore();
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index c268abe..5d87f58 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -131,7 +131,7 @@ u_char emulating = 0;
 static int valid_prefix(u_char *Byte, u_char __user ** fpu_eip,
 			overrides * override);
 
-asmlinkage void math_emulate(long arg)
+void math_emulate(struct math_emu_info *info)
 {
 	u_char FPU_modrm, byte1;
 	unsigned short code;
@@ -161,7 +161,7 @@ asmlinkage void math_emulate(long arg)
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
-	SETUP_DATA_AREA(arg);
+	FPU_info = info;
 
 	FPU_ORIG_EIP = FPU_EIP;
 
diff --git a/arch/x86/math-emu/fpu_proto.h b/arch/x86/math-emu/fpu_proto.h
index 51bfbb6..9779df4 100644
--- a/arch/x86/math-emu/fpu_proto.h
+++ b/arch/x86/math-emu/fpu_proto.h
@@ -51,7 +51,7 @@ extern void ffreep(void);
 extern void fst_i_(void);
 extern void fstp_i(void);
 /* fpu_entry.c */
-asmlinkage extern void math_emulate(long arg);
+extern void math_emulate(struct math_emu_info *info);
 extern void math_abort(struct math_emu_info *info, unsigned int signal);
 /* fpu_etc.c */
 extern void FPU_etc(void);
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 6729c6a..50fa0ec 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -16,10 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
-/* This sets the pointer FPU_info to point to the argument part
-   of the stack frame of math_emulate() */
-#define SETUP_DATA_AREA(arg)	FPU_info = (struct math_emu_info *) &arg
-
 /* s is always from a cpu register, and the cpu does bounds checking
  * during register load --> no further bounds checks needed */
 #define LDT_DESCRIPTOR(s)	(((struct desc_struct *)current->mm->context.ldt)[(s) >> 3])
@@ -38,12 +34,12 @@
 #define I387			(current->thread.xstate)
 #define FPU_info		(I387->soft.info)
 
-#define FPU_CS			(*(unsigned short *) &(FPU_info->regs.cs))
-#define FPU_SS			(*(unsigned short *) &(FPU_info->regs.ss))
-#define FPU_DS			(*(unsigned short *) &(FPU_info->regs.ds))
-#define FPU_EAX			(FPU_info->regs.ax)
-#define FPU_EFLAGS		(FPU_info->regs.flags)
-#define FPU_EIP			(FPU_info->regs.ip)
+#define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))
+#define FPU_SS			(*(unsigned short *) &(FPU_info->regs->ss))
+#define FPU_DS			(*(unsigned short *) &(FPU_info->regs->ds))
+#define FPU_EAX			(FPU_info->regs->ax)
+#define FPU_EFLAGS		(FPU_info->regs->flags)
+#define FPU_EIP			(FPU_info->regs->ip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
 #define FPU_lookahead           (I387->soft.lookahead)
diff --git a/arch/x86/math-emu/get_address.c b/arch/x86/math-emu/get_address.c
index 62daa7f..420b3b6 100644
--- a/arch/x86/math-emu/get_address.c
+++ b/arch/x86/math-emu/get_address.c
@@ -29,43 +29,43 @@
 #define FPU_WRITE_BIT 0x10
 
 static int reg_offset[] = {
-	offsetof(struct math_emu_info, regs.ax),
-	offsetof(struct math_emu_info, regs.cx),
-	offsetof(struct math_emu_info, regs.dx),
-	offsetof(struct math_emu_info, regs.bx),
-	offsetof(struct math_emu_info, regs.sp),
-	offsetof(struct math_emu_info, regs.bp),
-	offsetof(struct math_emu_info, regs.si),
-	offsetof(struct math_emu_info, regs.di)
+	offsetof(struct pt_regs, ax),
+	offsetof(struct pt_regs, cx),
+	offsetof(struct pt_regs, dx),
+	offsetof(struct pt_regs, bx),
+	offsetof(struct pt_regs, sp),
+	offsetof(struct pt_regs, bp),
+	offsetof(struct pt_regs, si),
+	offsetof(struct pt_regs, di)
 };
 
-#define REG_(x) (*(long *)(reg_offset[(x)]+(u_char *) FPU_info))
+#define REG_(x) (*(long *)(reg_offset[(x)] + (u_char *)FPU_info->regs))
 
 static int reg_offset_vm86[] = {
-	offsetof(struct math_emu_info, regs.cs),
-	offsetof(struct math_emu_info, vm86.ds),
-	offsetof(struct math_emu_info, vm86.es),
-	offsetof(struct math_emu_info, vm86.fs),
-	offsetof(struct math_emu_info, vm86.gs),
-	offsetof(struct math_emu_info, regs.ss),
-	offsetof(struct math_emu_info, vm86.ds)
+	offsetof(struct pt_regs, cs),
+	offsetof(struct kernel_vm86_regs, ds),
+	offsetof(struct kernel_vm86_regs, es),
+	offsetof(struct kernel_vm86_regs, fs),
+	offsetof(struct kernel_vm86_regs, gs),
+	offsetof(struct pt_regs, ss),
+	offsetof(struct kernel_vm86_regs, ds)
 };
 
 #define VM86_REG_(x) (*(unsigned short *) \
-		      (reg_offset_vm86[((unsigned)x)]+(u_char *) FPU_info))
+		(reg_offset_vm86[((unsigned)x)] + (u_char *)FPU_info->regs))
 
 static int reg_offset_pm[] = {
-	offsetof(struct math_emu_info, regs.cs),
-	offsetof(struct math_emu_info, regs.ds),
-	offsetof(struct math_emu_info, regs.es),
-	offsetof(struct math_emu_info, regs.fs),
-	offsetof(struct math_emu_info, regs.ds), /* dummy, not saved on stack */
-	offsetof(struct math_emu_info, regs.ss),
-	offsetof(struct math_emu_info, regs.ds)
+	offsetof(struct pt_regs, cs),
+	offsetof(struct pt_regs, ds),
+	offsetof(struct pt_regs, es),
+	offsetof(struct pt_regs, fs),
+	offsetof(struct pt_regs, ds),	/* dummy, not saved on stack */
+	offsetof(struct pt_regs, ss),
+	offsetof(struct pt_regs, ds)
 };
 
 #define PM_REG_(x) (*(unsigned short *) \
-		      (reg_offset_pm[((unsigned)x)]+(u_char *) FPU_info))
+		(reg_offset_pm[((unsigned)x)] + (u_char *)FPU_info->regs))
 
 /* Decode the SIB byte. This function assumes mod != 0 */
 static int sib(int mod, unsigned long *fpu_eip)
@@ -346,34 +346,34 @@ void __user *FPU_get_address_16(u_char FPU_modrm, unsigned long *fpu_eip,
 	}
 	switch (rm) {
 	case 0:
-		address += FPU_info->regs.bx + FPU_info->regs.si;
+		address += FPU_info->regs->bx + FPU_info->regs->si;
 		break;
 	case 1:
-		address += FPU_info->regs.bx + FPU_info->regs.di;
+		address += FPU_info->regs->bx + FPU_info->regs->di;
 		break;
 	case 2:
-		address += FPU_info->regs.bp + FPU_info->regs.si;
+		address += FPU_info->regs->bp + FPU_info->regs->si;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 3:
-		address += FPU_info->regs.bp + FPU_info->regs.di;
+		address += FPU_info->regs->bp + FPU_info->regs->di;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 4:
-		address += FPU_info->regs.si;
+		address += FPU_info->regs->si;
 		break;
 	case 5:
-		address += FPU_info->regs.di;
+		address += FPU_info->regs->di;
 		break;
 	case 6:
-		address += FPU_info->regs.bp;
+		address += FPU_info->regs->bp;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 7:
-		address += FPU_info->regs.bx;
+		address += FPU_info->regs->bx;
 		break;
 	}
 
-- 
1.6.0.2

