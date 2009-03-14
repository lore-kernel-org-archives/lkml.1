Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZCNB7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZCNB7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZCNBV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:57 -0400
Received: from kroah.org ([198.145.64.141]:35832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754993AbZCNBVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:46 2009
Message-Id: <20090314011046.351163467@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 101/114] x86: math_emu info cleanup
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-math_emu-info-cleanup.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ae6af41f5a4841f06eb92bc86ad020ad44ae2a30 upstream.

Impact: cleanup

* Come on, struct info?  s/struct info/struct math_emu_info/

* Use struct pt_regs and kernel_vm86_regs instead of defining its own
  register frame structure.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/math_emu.h  |   29 ++++-------------
 arch/x86/include/asm/processor.h |    2 -
 arch/x86/math-emu/fpu_entry.c    |    2 -
 arch/x86/math-emu/fpu_proto.h    |    2 -
 arch/x86/math-emu/fpu_system.h   |   14 ++++----
 arch/x86/math-emu/get_address.c  |   63 ++++++++++++++++++---------------------
 6 files changed, 48 insertions(+), 64 deletions(-)

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
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -349,7 +349,7 @@ struct i387_soft_struct {
 	u8			no_update;
 	u8			rm;
 	u8			alimit;
-	struct info		*info;
+	struct math_emu_info	*info;
 	u32			entry_eip;
 };
 
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -659,7 +659,7 @@ static int valid_prefix(u_char *Byte, u_
 	}
 }
 
-void math_abort(struct info *info, unsigned int signal)
+void math_abort(struct math_emu_info *info, unsigned int signal)
 {
 	FPU_EIP = FPU_ORIG_EIP;
 	current->thread.trap_no = 16;
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
@@ -349,34 +346,34 @@ void __user *FPU_get_address_16(u_char F
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
 


