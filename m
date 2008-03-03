Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYCCVEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYCCVEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYCCVEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:04:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41557
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYCCVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:04:04 -0500
Date: Mon, 03 Mar 2008 13:03:48 -0800 (PST)
Message-Id: <20080303.130348.25289482.davem@davemloft.net>
To: bunk@kernel.org
Cc: wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc vs. gcc 4.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080303192651.GL26072@cs181133002.pp.htv.fi>
References: <20080303192651.GL26072@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 3 Mar 2008 21:26:51 +0200

>   LD      arch/sparc/boot/image
> arch/sparc/kernel/built-in.o:(__ex_table+0x394): undefined reference to `kernel_unaligned_trap_fault'
...
> arch/sparc/kernel/built-in.o:(__ex_table+0x46c): undefined reference to `user_unaligned_trap_fault'

> Does anyone have a clue what's going wrong here?

We hit the same problem a while back on sparc64 too.

GCC can't see how the inline asm is reachable so eliminates it
entirely.  We hide the label inside the inline asm string and call it
from exception handlers.

The way we fixed this on sparc64 was quite invasive (patch below for
reference), so I'll try to come up with something simpler.

commit a3f9985843b674cbcb58f39fab8416675e7ab842
Author: David S. Miller <davem@davemloft.net>
Date:   Fri Aug 19 15:55:33 2005 -0700

    [SPARC64]: Move kernel unaligned trap handlers into assembler file.
    
    GCC 4.x really dislikes the games we are playing in
    unaligned.c, and the cleanest way to fix this is to
    move things into assembler.
    
    Noted by Al Viro.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/Makefile b/arch/sparc64/kernel/Makefile
index 093281b..6f00ab8 100644
--- a/arch/sparc64/kernel/Makefile
+++ b/arch/sparc64/kernel/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS := -Werror
 extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		:= process.o setup.o cpu.o idprom.o \
-		   traps.o devices.o auxio.o \
+		   traps.o devices.o auxio.o una_asm.o \
 		   irq.o ptrace.o time.o sys_sparc.o signal.o \
 		   unaligned.o central.o pci.o starfire.o semaphore.o \
 		   power.o sbus.o iommu_common.o sparc64_ksyms.o chmc.o
diff --git a/arch/sparc64/kernel/traps.c b/arch/sparc64/kernel/traps.c
index 100b010..0c9e54b 100644
--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -2127,6 +2127,9 @@ void __init trap_init(void)
 	    TI_PRE_COUNT != offsetof(struct thread_info, preempt_count) ||
 	    TI_NEW_CHILD != offsetof(struct thread_info, new_child) ||
 	    TI_SYS_NOERROR != offsetof(struct thread_info, syscall_noerror) ||
+	    TI_RESTART_BLOCK != offsetof(struct thread_info, restart_block) ||
+	    TI_KUNA_REGS != offsetof(struct thread_info, kern_una_regs) ||
+	    TI_KUNA_INSN != offsetof(struct thread_info, kern_una_insn) ||
 	    TI_FPREGS != offsetof(struct thread_info, fpregs) ||
 	    (TI_FPREGS & (64 - 1)))
 		thread_info_offsets_are_bolixed_dave();
diff --git a/arch/sparc64/kernel/una_asm.S b/arch/sparc64/kernel/una_asm.S
new file mode 100644
index 0000000..cbb4058
--- /dev/null
+++ b/arch/sparc64/kernel/una_asm.S
@@ -0,0 +1,153 @@
+/* una_asm.S: Kernel unaligned trap assembler helpers.
+ *
+ * Copyright (C) 1996,2005 David S. Miller (davem@davemloft.net)
+ * Copyright (C) 1996,1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
+ */
+
+	.text
+
+kernel_unaligned_trap_fault:
+	call	kernel_mna_trap_fault
+	 nop
+	retl
+	 nop
+	.size	kern_unaligned_trap_fault, .-kern_unaligned_trap_fault
+
+	.globl	__do_int_store
+__do_int_store:
+	rd	%asi, %o4
+	wr	%o3, 0, %asi
+	ldx	[%o2], %g3
+	cmp	%o1, 2
+	be,pn	%icc, 2f
+	 cmp	%o1, 4
+	be,pt	%icc, 1f
+	 srlx	%g3, 24, %g2
+	srlx	%g3, 56, %g1
+	srlx	%g3, 48, %g7
+4:	stba	%g1, [%o0] %asi
+	srlx	%g3, 40, %g1
+5:	stba	%g7, [%o0 + 1] %asi
+	srlx	%g3, 32, %g7
+6:	stba	%g1, [%o0 + 2] %asi
+7:	stba	%g7, [%o0 + 3] %asi
+	srlx	%g3, 16, %g1
+8:	stba	%g2, [%o0 + 4] %asi
+	srlx	%g3, 8, %g7
+9:	stba	%g1, [%o0 + 5] %asi
+10:	stba	%g7, [%o0 + 6] %asi
+	ba,pt	%xcc, 0f
+11:	 stba	%g3, [%o0 + 7] %asi
+1:	srl	%g3, 16, %g7
+12:	stba	%g2, [%o0] %asi
+	srl	%g3, 8, %g2
+13:	stba	%g7, [%o0 + 1] %asi
+14:	stba	%g2, [%o0 + 2] %asi
+	ba,pt	%xcc, 0f
+15:	 stba	%g3, [%o0 + 3] %asi
+2:	srl	%g3, 8, %g2
+16:	stba	%g2, [%o0] %asi
+17:	stba	%g3, [%o0 + 1] %asi
+0:
+	wr	%o4, 0x0, %asi
+	retl
+	 nop
+	.size	__do_int_store, .-__do_int_store
+
+	.section	__ex_table
+	.word		4b, kernel_unaligned_trap_fault
+	.word		5b, kernel_unaligned_trap_fault
+	.word		6b, kernel_unaligned_trap_fault
+	.word		7b, kernel_unaligned_trap_fault
+	.word		8b, kernel_unaligned_trap_fault
+	.word		9b, kernel_unaligned_trap_fault
+	.word		10b, kernel_unaligned_trap_fault
+	.word		11b, kernel_unaligned_trap_fault
+	.word		12b, kernel_unaligned_trap_fault
+	.word		13b, kernel_unaligned_trap_fault
+	.word		14b, kernel_unaligned_trap_fault
+	.word		15b, kernel_unaligned_trap_fault
+	.word		16b, kernel_unaligned_trap_fault
+	.word		17b, kernel_unaligned_trap_fault
+	.previous
+
+	.globl	do_int_load
+do_int_load:
+	rd	%asi, %o5
+	wr	%o4, 0, %asi
+	cmp	%o1, 8
+	bge,pn	%icc, 9f
+	 cmp	%o1, 4
+	be,pt	%icc, 6f
+4:	 lduba	[%o2] %asi, %g2
+5:	lduba	[%o2 + 1] %asi, %g3
+	sll	%g2, 8, %g2
+	brz,pt	%o3, 3f
+	 add	%g2, %g3, %g2
+	sllx	%g2, 48, %g2
+	srax	%g2, 48, %g2
+3:	ba,pt	%xcc, 0f
+	 stx	%g2, [%o0]
+6:	lduba	[%o2 + 1] %asi, %g3
+	sll	%g2, 24, %g2
+7:	lduba	[%o2 + 2] %asi, %g7
+	sll	%g3, 16, %g3
+8:	lduba	[%o2 + 3] %asi, %g1
+	sll	%g7, 8, %g7
+	or	%g2, %g3, %g2
+	or	%g7, %g1, %g7
+	or	%g2, %g7, %g2
+	brnz,a,pt %o3, 3f
+	 sra	%g2, 0, %g2
+3:	ba,pt	%xcc, 0f
+	 stx	%g2, [%o0]
+9:	lduba	[%o2] %asi, %g2
+10:	lduba	[%o2 + 1] %asi, %g3
+	sllx	%g2, 56, %g2
+11:	lduba	[%o2 + 2] %asi, %g7
+	sllx	%g3, 48, %g3
+12:	lduba	[%o2 + 3] %asi, %g1
+	sllx	%g7, 40, %g7
+	sllx	%g1, 32, %g1
+	or	%g2, %g3, %g2
+	or	%g7, %g1, %g7
+13:	lduba	[%o2 + 4] %asi, %g3
+	or	%g2, %g7, %g7
+14:	lduba	[%o2 + 5] %asi, %g1
+	sllx	%g3, 24, %g3
+15:	lduba	[%o2 + 6] %asi, %g2
+	sllx	%g1, 16, %g1
+	or	%g7, %g3, %g7
+16:	lduba	[%o2 + 7] %asi, %g3
+	sllx	%g2, 8, %g2
+	or	%g7, %g1, %g7
+	or	%g2, %g3, %g2
+	or	%g7, %g2, %g7
+	cmp	%o1, 8
+	be,a,pt %icc, 0f
+	 stx	%g7, [%o0]
+	srlx	%g7, 32, %g2
+	sra	%g7, 0, %g7
+	stx	%g2, [%o0]
+	stx	%g7, [%o0 + 8]
+0:
+	wr	%o5, 0x0, %asi
+	retl
+	 nop
+	.size	__do_int_load, .-__do_int_load
+
+	.section	__ex_table
+	.word		4b, kernel_unaligned_trap_fault
+	.word		5b, kernel_unaligned_trap_fault
+	.word		6b, kernel_unaligned_trap_fault
+	.word		7b, kernel_unaligned_trap_fault
+	.word		8b, kernel_unaligned_trap_fault
+	.word		9b, kernel_unaligned_trap_fault
+	.word		10b, kernel_unaligned_trap_fault
+	.word		11b, kernel_unaligned_trap_fault
+	.word		12b, kernel_unaligned_trap_fault
+	.word		13b, kernel_unaligned_trap_fault
+	.word		14b, kernel_unaligned_trap_fault
+	.word		15b, kernel_unaligned_trap_fault
+	.word		16b, kernel_unaligned_trap_fault
+	.previous
diff --git a/arch/sparc64/kernel/unaligned.c b/arch/sparc64/kernel/unaligned.c
index 4372bf3..11c3e88 100644
--- a/arch/sparc64/kernel/unaligned.c
+++ b/arch/sparc64/kernel/unaligned.c
@@ -180,169 +180,28 @@ static void __attribute_used__ unaligned_panic(char *str, struct pt_regs *regs)
 	die_if_kernel(str, regs);
 }
 
-#define do_integer_load(dest_reg, size, saddr, is_signed, asi, errh) ({		\
-__asm__ __volatile__ (								\
-	"wr	%4, 0, %%asi\n\t"						\
-	"cmp	%1, 8\n\t"							\
-	"bge,pn	%%icc, 9f\n\t"							\
-	" cmp	%1, 4\n\t"							\
-	"be,pt	%%icc, 6f\n"							\
-"4:\t"	" lduba	[%2] %%asi, %%l1\n"						\
-"5:\t"	"lduba	[%2 + 1] %%asi, %%l2\n\t"					\
-	"sll	%%l1, 8, %%l1\n\t"						\
-	"brz,pt	%3, 3f\n\t"							\
-	" add	%%l1, %%l2, %%l1\n\t"						\
-	"sllx	%%l1, 48, %%l1\n\t"						\
-	"srax	%%l1, 48, %%l1\n"						\
-"3:\t"	"ba,pt	%%xcc, 0f\n\t"							\
-	" stx	%%l1, [%0]\n"							\
-"6:\t"	"lduba	[%2 + 1] %%asi, %%l2\n\t"					\
-	"sll	%%l1, 24, %%l1\n"						\
-"7:\t"	"lduba	[%2 + 2] %%asi, %%g7\n\t"					\
-	"sll	%%l2, 16, %%l2\n"						\
-"8:\t"	"lduba	[%2 + 3] %%asi, %%g1\n\t"					\
-	"sll	%%g7, 8, %%g7\n\t"						\
-	"or	%%l1, %%l2, %%l1\n\t"						\
-	"or	%%g7, %%g1, %%g7\n\t"						\
-	"or	%%l1, %%g7, %%l1\n\t"						\
-	"brnz,a,pt %3, 3f\n\t"							\
-	" sra	%%l1, 0, %%l1\n"						\
-"3:\t"	"ba,pt	%%xcc, 0f\n\t"							\
-	" stx	%%l1, [%0]\n"							\
-"9:\t"	"lduba	[%2] %%asi, %%l1\n"						\
-"10:\t"	"lduba	[%2 + 1] %%asi, %%l2\n\t"					\
-	"sllx	%%l1, 56, %%l1\n"						\
-"11:\t"	"lduba	[%2 + 2] %%asi, %%g7\n\t"					\
-	"sllx	%%l2, 48, %%l2\n"						\
-"12:\t"	"lduba	[%2 + 3] %%asi, %%g1\n\t"					\
-	"sllx	%%g7, 40, %%g7\n\t"						\
-	"sllx	%%g1, 32, %%g1\n\t"						\
-	"or	%%l1, %%l2, %%l1\n\t"						\
-	"or	%%g7, %%g1, %%g7\n"						\
-"13:\t"	"lduba	[%2 + 4] %%asi, %%l2\n\t"					\
-	"or	%%l1, %%g7, %%g7\n"						\
-"14:\t"	"lduba	[%2 + 5] %%asi, %%g1\n\t"					\
-	"sllx	%%l2, 24, %%l2\n"						\
-"15:\t"	"lduba	[%2 + 6] %%asi, %%l1\n\t"					\
-	"sllx	%%g1, 16, %%g1\n\t"						\
-	"or	%%g7, %%l2, %%g7\n"						\
-"16:\t"	"lduba	[%2 + 7] %%asi, %%l2\n\t"					\
-	"sllx	%%l1, 8, %%l1\n\t"						\
-	"or	%%g7, %%g1, %%g7\n\t"						\
-	"or	%%l1, %%l2, %%l1\n\t"						\
-	"or	%%g7, %%l1, %%g7\n\t"						\
-	"cmp	%1, 8\n\t"							\
-	"be,a,pt %%icc, 0f\n\t"							\
-	" stx	%%g7, [%0]\n\t"							\
-	"srlx	%%g7, 32, %%l1\n\t"						\
-	"sra	%%g7, 0, %%g7\n\t"						\
-	"stx	%%l1, [%0]\n\t"							\
-	"stx	%%g7, [%0 + 8]\n"						\
-"0:\n\t"									\
-	"wr	%%g0, %5, %%asi\n\n\t"						\
-	".section __ex_table\n\t"						\
-	".word	4b, " #errh "\n\t"						\
-	".word	5b, " #errh "\n\t"						\
-	".word	6b, " #errh "\n\t"						\
-	".word	7b, " #errh "\n\t"						\
-	".word	8b, " #errh "\n\t"						\
-	".word	9b, " #errh "\n\t"						\
-	".word	10b, " #errh "\n\t"						\
-	".word	11b, " #errh "\n\t"						\
-	".word	12b, " #errh "\n\t"						\
-	".word	13b, " #errh "\n\t"						\
-	".word	14b, " #errh "\n\t"						\
-	".word	15b, " #errh "\n\t"						\
-	".word	16b, " #errh "\n\n\t"						\
-	".previous\n\t"								\
-	: : "r" (dest_reg), "r" (size), "r" (saddr), "r" (is_signed),		\
-	  "r" (asi), "i" (ASI_AIUS)						\
-	: "l1", "l2", "g7", "g1", "cc");					\
-})
+extern void do_int_load(unsigned long *dest_reg, int size,
+			unsigned long *saddr, int is_signed, int asi);
 	
-#define store_common(dst_addr, size, src_val, asi, errh) ({			\
-__asm__ __volatile__ (								\
-	"wr	%3, 0, %%asi\n\t"						\
-	"ldx	[%2], %%l1\n"							\
-	"cmp	%1, 2\n\t"							\
-	"be,pn	%%icc, 2f\n\t"							\
-	" cmp	%1, 4\n\t"							\
-	"be,pt	%%icc, 1f\n\t"							\
-	" srlx	%%l1, 24, %%l2\n\t"						\
-	"srlx	%%l1, 56, %%g1\n\t"						\
-	"srlx	%%l1, 48, %%g7\n"						\
-"4:\t"	"stba	%%g1, [%0] %%asi\n\t"						\
-	"srlx	%%l1, 40, %%g1\n"						\
-"5:\t"	"stba	%%g7, [%0 + 1] %%asi\n\t"					\
-	"srlx	%%l1, 32, %%g7\n"						\
-"6:\t"	"stba	%%g1, [%0 + 2] %%asi\n"						\
-"7:\t"	"stba	%%g7, [%0 + 3] %%asi\n\t"					\
-	"srlx	%%l1, 16, %%g1\n"						\
-"8:\t"	"stba	%%l2, [%0 + 4] %%asi\n\t"					\
-	"srlx	%%l1, 8, %%g7\n"						\
-"9:\t"	"stba	%%g1, [%0 + 5] %%asi\n"						\
-"10:\t"	"stba	%%g7, [%0 + 6] %%asi\n\t"					\
-	"ba,pt	%%xcc, 0f\n"							\
-"11:\t"	" stba	%%l1, [%0 + 7] %%asi\n"						\
-"1:\t"	"srl	%%l1, 16, %%g7\n"						\
-"12:\t"	"stba	%%l2, [%0] %%asi\n\t"						\
-	"srl	%%l1, 8, %%l2\n"						\
-"13:\t"	"stba	%%g7, [%0 + 1] %%asi\n"						\
-"14:\t"	"stba	%%l2, [%0 + 2] %%asi\n\t"					\
-	"ba,pt	%%xcc, 0f\n"							\
-"15:\t"	" stba	%%l1, [%0 + 3] %%asi\n"						\
-"2:\t"	"srl	%%l1, 8, %%l2\n"						\
-"16:\t"	"stba	%%l2, [%0] %%asi\n"						\
-"17:\t"	"stba	%%l1, [%0 + 1] %%asi\n"						\
-"0:\n\t"									\
-	"wr	%%g0, %4, %%asi\n\n\t"						\
-	".section __ex_table\n\t"						\
-	".word	4b, " #errh "\n\t"						\
-	".word	5b, " #errh "\n\t"						\
-	".word	6b, " #errh "\n\t"						\
-	".word	7b, " #errh "\n\t"						\
-	".word	8b, " #errh "\n\t"						\
-	".word	9b, " #errh "\n\t"						\
-	".word	10b, " #errh "\n\t"						\
-	".word	11b, " #errh "\n\t"						\
-	".word	12b, " #errh "\n\t"						\
-	".word	13b, " #errh "\n\t"						\
-	".word	14b, " #errh "\n\t"						\
-	".word	15b, " #errh "\n\t"						\
-	".word	16b, " #errh "\n\t"						\
-	".word	17b, " #errh "\n\n\t"						\
-	".previous\n\t"								\
-	: : "r" (dst_addr), "r" (size), "r" (src_val), "r" (asi), "i" (ASI_AIUS)\
-	: "l1", "l2", "g7", "g1", "cc");					\
-})
-
-#define do_integer_store(reg_num, size, dst_addr, regs, asi, errh) ({		\
-	unsigned long zero = 0;							\
-	unsigned long *src_val = &zero;						\
-										\
-	if (size == 16) {							\
-		size = 8;							\
-		zero = (((long)(reg_num ? 					\
-		        (unsigned)fetch_reg(reg_num, regs) : 0)) << 32) |	\
-			(unsigned)fetch_reg(reg_num + 1, regs);			\
-	} else if (reg_num) src_val = fetch_reg_addr(reg_num, regs);		\
-	store_common(dst_addr, size, src_val, asi, errh);			\
-})
-
-extern void smp_capture(void);
-extern void smp_release(void);
-
-#define do_atomic(srcdest_reg, mem, errh) ({					\
-	unsigned long flags, tmp;						\
-										\
-	smp_capture();								\
-	local_irq_save(flags);							\
-	tmp = *srcdest_reg;							\
-	do_integer_load(srcdest_reg, 4, mem, 0, errh);				\
-	store_common(mem, 4, &tmp, errh);					\
-	local_irq_restore(flags);						\
-	smp_release();								\
-})
+extern void __do_int_store(unsigned long *dst_addr, int size,
+			   unsigned long *src_val, int asi);
+
+static inline void do_int_store(int reg_num, int size, unsigned long *dst_addr,
+				struct pt_regs *regs, int asi)
+{
+	unsigned long zero = 0;
+	unsigned long *src_val = &zero;
+
+	if (size == 16) {
+		size = 8;
+		zero = (((long)(reg_num ?
+		        (unsigned)fetch_reg(reg_num, regs) : 0)) << 32) |
+			(unsigned)fetch_reg(reg_num + 1, regs);
+	} else if (reg_num) {
+		src_val = fetch_reg_addr(reg_num, regs);
+	}
+	__do_int_store(dst_addr, size, src_val, asi);
+}
 
 static inline void advance(struct pt_regs *regs)
 {
@@ -364,24 +223,29 @@ static inline int ok_for_kernel(unsigned int insn)
 	return !floating_point_load_or_store_p(insn);
 }
 
-void kernel_mna_trap_fault(struct pt_regs *regs, unsigned int insn) __asm__ ("kernel_mna_trap_fault");
-
-void kernel_mna_trap_fault(struct pt_regs *regs, unsigned int insn)
+void kernel_mna_trap_fault(void)
 {
-	unsigned long g2 = regs->u_regs [UREG_G2];
+	struct pt_regs *regs = current_thread_info()->kern_una_regs;
+	unsigned int insn = current_thread_info()->kern_una_insn;
+	unsigned long g2 = regs->u_regs[UREG_G2];
 	unsigned long fixup = search_extables_range(regs->tpc, &g2);
 
 	if (!fixup) {
-		unsigned long address = compute_effective_address(regs, insn, ((insn >> 25) & 0x1f));
+		unsigned long address;
+
+		address = compute_effective_address(regs, insn,
+						    ((insn >> 25) & 0x1f));
         	if (address < PAGE_SIZE) {
-                	printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference in mna handler");
+                	printk(KERN_ALERT "Unable to handle kernel NULL "
+			       "pointer dereference in mna handler");
         	} else
-                	printk(KERN_ALERT "Unable to handle kernel paging request in mna handler");
+                	printk(KERN_ALERT "Unable to handle kernel paging "
+			       "request in mna handler");
 	        printk(KERN_ALERT " at virtual address %016lx\n",address);
-		printk(KERN_ALERT "current->{mm,active_mm}->context = %016lx\n",
+		printk(KERN_ALERT "current->{active_,}mm->context = %016lx\n",
 			(current->mm ? CTX_HWBITS(current->mm->context) :
 			CTX_HWBITS(current->active_mm->context)));
-		printk(KERN_ALERT "current->{mm,active_mm}->pgd = %016lx\n",
+		printk(KERN_ALERT "current->{active_,}mm->pgd = %016lx\n",
 			(current->mm ? (unsigned long) current->mm->pgd :
 			(unsigned long) current->active_mm->pgd));
 	        die_if_kernel("Oops", regs);
@@ -400,48 +264,41 @@ asmlinkage void kernel_unaligned_trap(struct pt_regs *regs, unsigned int insn, u
 	enum direction dir = decode_direction(insn);
 	int size = decode_access_size(insn);
 
+	current_thread_info()->kern_una_regs = regs;
+	current_thread_info()->kern_una_insn = insn;
+
 	if (!ok_for_kernel(insn) || dir == both) {
-		printk("Unsupported unaligned load/store trap for kernel at <%016lx>.\n",
-		       regs->tpc);
-		unaligned_panic("Kernel does fpu/atomic unaligned load/store.", regs);
-
-		__asm__ __volatile__ ("\n"
-"kernel_unaligned_trap_fault:\n\t"
-		"mov	%0, %%o0\n\t"
-		"call	kernel_mna_trap_fault\n\t"
-		" mov	%1, %%o1\n\t"
-		:
-		: "r" (regs), "r" (insn)
-		: "o0", "o1", "o2", "o3", "o4", "o5", "o7",
-		  "g1", "g2", "g3", "g4", "g7", "cc");
+		printk("Unsupported unaligned load/store trap for kernel "
+		       "at <%016lx>.\n", regs->tpc);
+		unaligned_panic("Kernel does fpu/atomic "
+				"unaligned load/store.", regs);
+
+		kernel_mna_trap_fault();
 	} else {
-		unsigned long addr = compute_effective_address(regs, insn, ((insn >> 25) & 0x1f));
+		unsigned long addr;
 
+		addr = compute_effective_address(regs, insn,
+						 ((insn >> 25) & 0x1f));
 #ifdef DEBUG_MNA
-		printk("KMNA: pc=%016lx [dir=%s addr=%016lx size=%d] retpc[%016lx]\n",
-		       regs->tpc, dirstrings[dir], addr, size, regs->u_regs[UREG_RETPC]);
+		printk("KMNA: pc=%016lx [dir=%s addr=%016lx size=%d] "
+		       "retpc[%016lx]\n",
+		       regs->tpc, dirstrings[dir], addr, size,
+		       regs->u_regs[UREG_RETPC]);
 #endif
 		switch (dir) {
 		case load:
-			do_integer_load(fetch_reg_addr(((insn>>25)&0x1f), regs),
-					size, (unsigned long *) addr,
-					decode_signedness(insn), decode_asi(insn, regs),
-					kernel_unaligned_trap_fault);
+			do_int_load(fetch_reg_addr(((insn>>25)&0x1f), regs),
+				    size, (unsigned long *) addr,
+				    decode_signedness(insn),
+				    decode_asi(insn, regs));
 			break;
 
 		case store:
-			do_integer_store(((insn>>25)&0x1f), size,
-					 (unsigned long *) addr, regs,
-					 decode_asi(insn, regs),
-					 kernel_unaligned_trap_fault);
-			break;
-#if 0 /* unsupported */
-		case both:
-			do_atomic(fetch_reg_addr(((insn>>25)&0x1f), regs),
-				  (unsigned long *) addr,
-				  kernel_unaligned_trap_fault);
+			do_int_store(((insn>>25)&0x1f), size,
+				     (unsigned long *) addr, regs,
+				     decode_asi(insn, regs));
 			break;
-#endif
+
 		default:
 			panic("Impossible kernel unaligned trap.");
 			/* Not reached... */
diff --git a/include/asm-sparc64/thread_info.h b/include/asm-sparc64/thread_info.h
index 352d994..c94d8b3 100644
--- a/include/asm-sparc64/thread_info.h
+++ b/include/asm-sparc64/thread_info.h
@@ -68,6 +68,9 @@ struct thread_info {
 
 	struct restart_block	restart_block;
 
+	struct pt_regs		*kern_una_regs;
+	unsigned int		kern_una_insn;
+
 	unsigned long		fpregs[0] __attribute__ ((aligned(64)));
 };
 
@@ -103,6 +106,8 @@ struct thread_info {
 #define TI_PCR		0x00000490
 #define TI_CEE_STUFF	0x00000498
 #define TI_RESTART_BLOCK 0x000004a0
+#define TI_KUNA_REGS	0x000004c8
+#define TI_KUNA_INSN	0x000004d0
 #define TI_FPREGS	0x00000500
 
 /* We embed this in the uppermost byte of thread_info->flags */
