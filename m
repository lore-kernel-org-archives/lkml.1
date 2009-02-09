Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZBINmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZBINmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZBINkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbZBINkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:47 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] x86: math_emu info cleanup
Date: Mon,  9 Feb 2009 22:39:49 +0900
Message-Id: <1234186798-16820-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

* Come on, struct info?  s/struct info/struct math_emu_info/

* Use struct pt_regs and kernel_vm86_regs instead of defining its own
  register frame structure.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/math_emu.h  |   29 +++++------------
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/math-emu/fpu_entry.c    |    2 +-
 arch/x86/math-emu/fpu_proto.h    |    2 +-
 arch/x86/math-emu/fpu_system.h   |   14 ++++----
 arch/x86/math-emu/get_address.c  |   63 ++++++++++++++++++--------------------
 6 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/math_emu.h b/arch/x86/include/asm/math_emu.h
index 5a65b10..302492c 100644
--- a/arch/x86/include/asm/math_emu.h
+++ b/arch/x86/include/asm/math_emu.h
@@ -1,31 +1,18 @@
 #ifndef _ASM_X86_MATH_EMU_H
 #define _ASM_X86_MATH_EMU_H
 
+#include <asm/ptrace.h>
+#include <asm/vm86.h>
+
 /* This structure matches the layout of the data saved to the stack
    following a device-not-present interrupt, part of it saved
    automatically by the 80386/80486.
    */
-struct info {
+struct math_emu_info {
 	long ___orig_eip;
-	long ___ebx;
-	long ___ecx;
-	long ___edx;
-	long ___esi;
-	long ___edi;
-	long ___ebp;
-	long ___eax;
-	long ___ds;
-	long ___es;
-	long ___fs;
-	long ___orig_eax;
-	long ___eip;
-	long ___cs;
-	long ___eflags;
-	long ___esp;
-	long ___ss;
-	long ___vm86_es; /* This and the following only in vm86 mode */
-	long ___vm86_ds;
-	long ___vm86_fs;
-	long ___vm86_gs;
+	union {
+		struct pt_regs regs;
+		struct kernel_vm86_regs vm86;
+	};
 };
 #endif /* _ASM_X86_MATH_EMU_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7fd5ae9..80b8be2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -353,7 +353,7 @@ struct i387_soft_struct {
 	u8			no_update;
 	u8			rm;
 	u8			alimit;
-	struct info		*info;
+	struct math_emu_info	*info;
 	u32			entry_eip;
 };
 
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index c7b06fe..c268abe 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -659,7 +659,7 @@ static int valid_prefix(u_char *Byte, u_char __user **fpu_eip,
 	}
 }
 
-void math_abort(struct info *info, unsigned int signal)
+void math_abort(struct math_emu_info *info, unsigned int signal)
 {
 	FPU_EIP = FPU_ORIG_EIP;
 	current->thread.trap_no = 16;
diff --git a/arch/x86/math-emu/fpu_proto.h b/arch/x86/math-emu/fpu_proto.h
index aa49b6a..51bfbb6 100644
--- a/arch/x86/math-emu/fpu_proto.h
+++ b/arch/x86/math-emu/fpu_proto.h
@@ -52,7 +52,7 @@ extern void fst_i_(void);
 extern void fstp_i(void);
 /* fpu_entry.c */
 asmlinkage extern void math_emulate(long arg);
-extern void math_abort(struct info *info, unsigned int signal);
+extern void math_abort(struct math_emu_info *info, unsigned int signal);
 /* fpu_etc.c */
 extern void FPU_etc(void);
 /* fpu_tags.c */
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 13488fa..6729c6a 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -18,7 +18,7 @@
 
 /* This sets the pointer FPU_info to point to the argument part
    of the stack frame of math_emulate() */
-#define SETUP_DATA_AREA(arg)	FPU_info = (struct info *) &arg
+#define SETUP_DATA_AREA(arg)	FPU_info = (struct math_emu_info *) &arg
 
 /* s is always from a cpu register, and the cpu does bounds checking
  * during register load --> no further bounds checks needed */
@@ -38,12 +38,12 @@
 #define I387			(current->thread.xstate)
 #define FPU_info		(I387->soft.info)
 
-#define FPU_CS			(*(unsigned short *) &(FPU_info->___cs))
-#define FPU_SS			(*(unsigned short *) &(FPU_info->___ss))
-#define FPU_DS			(*(unsigned short *) &(FPU_info->___ds))
-#define FPU_EAX			(FPU_info->___eax)
-#define FPU_EFLAGS		(FPU_info->___eflags)
-#define FPU_EIP			(FPU_info->___eip)
+#define FPU_CS			(*(unsigned short *) &(FPU_info->regs.cs))
+#define FPU_SS			(*(unsigned short *) &(FPU_info->regs.ss))
+#define FPU_DS			(*(unsigned short *) &(FPU_info->regs.ds))
+#define FPU_EAX			(FPU_info->regs.ax)
+#define FPU_EFLAGS		(FPU_info->regs.flags)
+#define FPU_EIP			(FPU_info->regs.ip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
 #define FPU_lookahead           (I387->soft.lookahead)
diff --git a/arch/x86/math-emu/get_address.c b/arch/x86/math-emu/get_address.c
index d701e2b..62daa7f 100644
--- a/arch/x86/math-emu/get_address.c
+++ b/arch/x86/math-emu/get_address.c
@@ -29,42 +29,39 @@
 #define FPU_WRITE_BIT 0x10
 
 static int reg_offset[] = {
-	offsetof(struct info, ___eax),
-	offsetof(struct info, ___ecx),
-	offsetof(struct info, ___edx),
-	offsetof(struct info, ___ebx),
-	offsetof(struct info, ___esp),
-	offsetof(struct info, ___ebp),
-	offsetof(struct info, ___esi),
-	offsetof(struct info, ___edi)
+	offsetof(struct math_emu_info, regs.ax),
+	offsetof(struct math_emu_info, regs.cx),
+	offsetof(struct math_emu_info, regs.dx),
+	offsetof(struct math_emu_info, regs.bx),
+	offsetof(struct math_emu_info, regs.sp),
+	offsetof(struct math_emu_info, regs.bp),
+	offsetof(struct math_emu_info, regs.si),
+	offsetof(struct math_emu_info, regs.di)
 };
 
 #define REG_(x) (*(long *)(reg_offset[(x)]+(u_char *) FPU_info))
 
 static int reg_offset_vm86[] = {
-	offsetof(struct info, ___cs),
-	offsetof(struct info, ___vm86_ds),
-	offsetof(struct info, ___vm86_es),
-	offsetof(struct info, ___vm86_fs),
-	offsetof(struct info, ___vm86_gs),
-	offsetof(struct info, ___ss),
-	offsetof(struct info, ___vm86_ds)
+	offsetof(struct math_emu_info, regs.cs),
+	offsetof(struct math_emu_info, vm86.ds),
+	offsetof(struct math_emu_info, vm86.es),
+	offsetof(struct math_emu_info, vm86.fs),
+	offsetof(struct math_emu_info, vm86.gs),
+	offsetof(struct math_emu_info, regs.ss),
+	offsetof(struct math_emu_info, vm86.ds)
 };
 
 #define VM86_REG_(x) (*(unsigned short *) \
 		      (reg_offset_vm86[((unsigned)x)]+(u_char *) FPU_info))
 
-/* This dummy, gs is not saved on the stack. */
-#define ___GS ___ds
-
 static int reg_offset_pm[] = {
-	offsetof(struct info, ___cs),
-	offsetof(struct info, ___ds),
-	offsetof(struct info, ___es),
-	offsetof(struct info, ___fs),
-	offsetof(struct info, ___GS),
-	offsetof(struct info, ___ss),
-	offsetof(struct info, ___ds)
+	offsetof(struct math_emu_info, regs.cs),
+	offsetof(struct math_emu_info, regs.ds),
+	offsetof(struct math_emu_info, regs.es),
+	offsetof(struct math_emu_info, regs.fs),
+	offsetof(struct math_emu_info, regs.ds), /* dummy, not saved on stack */
+	offsetof(struct math_emu_info, regs.ss),
+	offsetof(struct math_emu_info, regs.ds)
 };
 
 #define PM_REG_(x) (*(unsigned short *) \
@@ -349,34 +346,34 @@ void __user *FPU_get_address_16(u_char FPU_modrm, unsigned long *fpu_eip,
 	}
 	switch (rm) {
 	case 0:
-		address += FPU_info->___ebx + FPU_info->___esi;
+		address += FPU_info->regs.bx + FPU_info->regs.si;
 		break;
 	case 1:
-		address += FPU_info->___ebx + FPU_info->___edi;
+		address += FPU_info->regs.bx + FPU_info->regs.di;
 		break;
 	case 2:
-		address += FPU_info->___ebp + FPU_info->___esi;
+		address += FPU_info->regs.bp + FPU_info->regs.si;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 3:
-		address += FPU_info->___ebp + FPU_info->___edi;
+		address += FPU_info->regs.bp + FPU_info->regs.di;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 4:
-		address += FPU_info->___esi;
+		address += FPU_info->regs.si;
 		break;
 	case 5:
-		address += FPU_info->___edi;
+		address += FPU_info->regs.di;
 		break;
 	case 6:
-		address += FPU_info->___ebp;
+		address += FPU_info->regs.bp;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 7:
-		address += FPU_info->___ebx;
+		address += FPU_info->regs.bx;
 		break;
 	}
 
-- 
1.6.0.2

