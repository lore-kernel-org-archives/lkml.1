Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYBAHlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYBAHlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934907AbYBAHiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:38:23 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48026 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763466AbYBAHiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:38:19 -0500
Date: Fri, 1 Feb 2008 17:37:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117bItl022687@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 01/06]: move ColdFire entry.S to its own coldfire directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common ColdFire CPU entry.S to common coldfire platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/entry.S linux-2.6.24.1/arch/m68knommu/platform/5307/entry.S
--- linux-2.6.24/arch/m68knommu/platform/5307/entry.S	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/5307/entry.S	1970-01-01 10:00:00.000000000 +1000
@@ -1,235 +0,0 @@
-/*
- *  linux/arch/m68knommu/platform/5307/entry.S
- *
- *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
- *  Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
- *                      Kenneth Albanowski <kjahds@kjahds.com>,
- *  Copyright (C) 2000  Lineo Inc. (www.lineo.com)
- *  Copyright (C) 2004-2006  Macq Electronique SA. (www.macqel.com)
- *
- * Based on:
- *
- *  linux/arch/m68k/kernel/entry.S
- *
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file README.legal in the main directory of this archive
- * for more details.
- *
- * Linux/m68k support by Hamish Macdonald
- *
- * 68060 fixes by Jesper Skov
- * ColdFire support by Greg Ungerer (gerg@snapgear.com)
- * 5307 fixes by David W. Miller
- * linux 2.4 support David McCullough <davidm@snapgear.com>
- * Bug, speed and maintainability fixes by Philippe De Muyter <phdm@macqel.be>
- */
-
-#include <linux/sys.h>
-#include <linux/linkage.h>
-#include <asm/unistd.h>
-#include <asm/thread_info.h>
-#include <asm/errno.h>
-#include <asm/setup.h>
-#include <asm/segment.h>
-#include <asm/asm-offsets.h>
-#include <asm/entry.h>
-
-.bss
-
-sw_ksp:
-.long	0
-
-sw_usp:
-.long	0
-
-.text
-
-.globl system_call
-.globl resume
-.globl ret_from_exception
-.globl ret_from_signal
-.globl sys_call_table
-.globl ret_from_interrupt
-.globl inthandler
-.globl fasthandler
-
-enosys:
-	mov.l	#sys_ni_syscall,%d3
-	bra	1f
-
-ENTRY(system_call)
-	SAVE_ALL
-	move	#0x2000,%sr		/* enable intrs again */
-
-	cmpl	#NR_syscalls,%d0
-	jcc	enosys
-	lea	sys_call_table,%a0
-	lsll	#2,%d0			/* movel %a0@(%d0:l:4),%d3 */
-	movel	%a0@(%d0),%d3
-	jeq	enosys
-
-1:
-	movel	%sp,%d2			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d2	/* at start of kernel stack */
-	movel	%d2,%a0
-	movel	%a0@,%a1		/* save top of frame */
-	movel	%sp,%a1@(TASK_THREAD+THREAD_ESP0)
-	btst	#(TIF_SYSCALL_TRACE%8),%a0@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
-	bnes	1f
-
-	movel	%d3,%a0
-	jbsr	%a0@
-	movel	%d0,%sp@(PT_D0)		/* save the return value */
-	jra	ret_from_exception
-1:
-	movel	#-ENOSYS,%d2		/* strace needs -ENOSYS in PT_D0 */
-	movel	%d2,PT_D0(%sp)		/* on syscall entry */
-	subql	#4,%sp
-	SAVE_SWITCH_STACK
-	jbsr	syscall_trace
-	RESTORE_SWITCH_STACK
-	addql	#4,%sp
-	movel	%d3,%a0
-	jbsr	%a0@
-	movel	%d0,%sp@(PT_D0)		/* save the return value */
-	subql	#4,%sp			/* dummy return address */
-	SAVE_SWITCH_STACK
-	jbsr	syscall_trace
-
-ret_from_signal:
-	RESTORE_SWITCH_STACK
-	addql	#4,%sp
-
-ret_from_exception:
-	btst	#5,%sp@(PT_SR)		/* check if returning to kernel */
-	jeq	Luser_return		/* if so, skip resched, signals */
-
-Lkernel_return:
-	moveml	%sp@,%d1-%d5/%a0-%a2
-	lea	%sp@(32),%sp		/* space for 8 regs */
-	movel	%sp@+,%d0
-	addql	#4,%sp			/* orig d0 */
-	addl	%sp@+,%sp		/* stk adj */
-	rte
-
-Luser_return:
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1	/* at base of kernel stack */
-	movel	%d1,%a0
-	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
-	andl	#_TIF_WORK_MASK,%d1
-	jne	Lwork_to_do		/* still work to do */
-
-Lreturn:
-	move	#0x2700,%sr		/* disable intrs */
-	movel	sw_usp,%a0		/* get usp */
-	movel	%sp@(PT_PC),%a0@-	/* copy exception program counter */
-	movel	%sp@(PT_FORMATVEC),%a0@-/* copy exception format/vector/sr */
-	moveml	%sp@,%d1-%d5/%a0-%a2
-	lea	%sp@(32),%sp		/* space for 8 regs */
-	movel	%sp@+,%d0
-	addql	#4,%sp			/* orig d0 */
-	addl	%sp@+,%sp		/* stk adj */
-	addql	#8,%sp			/* remove exception */
-	movel	%sp,sw_ksp		/* save ksp */
-	subql	#8,sw_usp		/* set exception */
-	movel	sw_usp,%sp		/* restore usp */
-	rte
-
-Lwork_to_do:
-	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
-	btst	#TIF_NEED_RESCHED,%d1
-	jne	reschedule
-
-	/* GERG: do we need something here for TRACEing?? */
-
-Lsignal_return:
-	subql	#4,%sp			/* dummy return address */
-	SAVE_SWITCH_STACK
-	pea	%sp@(SWITCH_STACK_SIZE)
-	clrl	%sp@-
-	jsr	do_signal
-	addql	#8,%sp
-	RESTORE_SWITCH_STACK
-	addql	#4,%sp
-	jmp	Lreturn
-
-/*
- * This is the generic interrupt handler (for all hardware interrupt
- * sources). Calls upto high level code to do all the work.
- */
-ENTRY(inthandler)
-	SAVE_ALL
-	moveq	#-1,%d0
-	movel	%d0,%sp@(PT_ORIG_D0)
-
-	movew	%sp@(PT_FORMATVEC),%d0	/* put exception # in d0 */
-	andl	#0x03fc,%d0		/* mask out vector only */
-
-	movel	%sp,%sp@-		/* push regs arg */
-	lsrl	#2,%d0			/* calculate real vector # */
-	movel	%d0,%sp@-		/* push vector number */
-	jbsr	do_IRQ			/* call high level irq handler */
-	lea	%sp@(8),%sp		/* pop args off stack */
-
-	bra	ret_from_interrupt	/* this was fallthrough */
-
-/*
- * This is the fast interrupt handler (for certain hardware interrupt
- * sources). Unlike the normal interrupt handler it just uses the
- * current stack (doesn't care if it is user or kernel). It also
- * doesn't bother doing the bottom half handlers.
- */
-ENTRY(fasthandler)
-	SAVE_LOCAL
-
-	movew	%sp@(PT_FORMATVEC),%d0
-	andl	#0x03fc,%d0		/* mask out vector only */
-
-	movel	%sp,%sp@-		/* push regs arg */
-	lsrl	#2,%d0			/* calculate real vector # */
-	movel	%d0,%sp@-		/* push vector number */
-	jbsr	do_IRQ			/* call high level irq handler */
-	lea	%sp@(8),%sp		/* pop args off stack */
-
-	RESTORE_LOCAL
-
-ENTRY(ret_from_interrupt)
-	jeq	2f
-1:
-	RESTORE_ALL
-2:
-	moveb	%sp@(PT_SR),%d0
-	andl	#0x7,%d0
-	jhi	1b
-
-	/* check if we need to do software interrupts */
-	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
-	jeq	ret_from_exception
-
-	pea	ret_from_exception
-	jmp	do_softirq
-
-/*
- * Beware - when entering resume, prev (the current task) is
- * in a0, next (the new task) is in a1,so don't change these
- * registers until their contents are no longer needed.
- * This is always called in supervisor mode, so don't bother to save
- * and restore sr; user's process sr is actually in the stack.
- */
-ENTRY(resume)
-	movel	%a0, %d1			/* get prev thread in d1 */
-
-	movel	sw_usp,%d0			/* save usp */
-	movel	%d0,%a0@(TASK_THREAD+THREAD_USP)
-
-	SAVE_SWITCH_STACK
-	movel	%sp,%a0@(TASK_THREAD+THREAD_KSP) /* save kernel stack pointer */
-	movel	%a1@(TASK_THREAD+THREAD_KSP),%sp /* restore new thread stack */
-	RESTORE_SWITCH_STACK
-
-	movel	%a1@(TASK_THREAD+THREAD_USP),%a0 /* restore thread user stack */
-	movel	%a0, sw_usp
-	rts
diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/entry.S linux-2.6.24.1/arch/m68knommu/platform/coldfire/entry.S
--- linux-2.6.24/arch/m68knommu/platform/coldfire/entry.S	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/entry.S	2008-01-25 08:58:37.000000000 +1000
@@ -0,0 +1,235 @@
+/*
+ *  linux/arch/m68knommu/platform/5307/entry.S
+ *
+ *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
+ *                      Kenneth Albanowski <kjahds@kjahds.com>,
+ *  Copyright (C) 2000  Lineo Inc. (www.lineo.com)
+ *  Copyright (C) 2004-2006  Macq Electronique SA. (www.macqel.com)
+ *
+ * Based on:
+ *
+ *  linux/arch/m68k/kernel/entry.S
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file README.legal in the main directory of this archive
+ * for more details.
+ *
+ * Linux/m68k support by Hamish Macdonald
+ *
+ * 68060 fixes by Jesper Skov
+ * ColdFire support by Greg Ungerer (gerg@snapgear.com)
+ * 5307 fixes by David W. Miller
+ * linux 2.4 support David McCullough <davidm@snapgear.com>
+ * Bug, speed and maintainability fixes by Philippe De Muyter <phdm@macqel.be>
+ */
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/unistd.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/setup.h>
+#include <asm/segment.h>
+#include <asm/asm-offsets.h>
+#include <asm/entry.h>
+
+.bss
+
+sw_ksp:
+.long	0
+
+sw_usp:
+.long	0
+
+.text
+
+.globl system_call
+.globl resume
+.globl ret_from_exception
+.globl ret_from_signal
+.globl sys_call_table
+.globl ret_from_interrupt
+.globl inthandler
+.globl fasthandler
+
+enosys:
+	mov.l	#sys_ni_syscall,%d3
+	bra	1f
+
+ENTRY(system_call)
+	SAVE_ALL
+	move	#0x2000,%sr		/* enable intrs again */
+
+	cmpl	#NR_syscalls,%d0
+	jcc	enosys
+	lea	sys_call_table,%a0
+	lsll	#2,%d0			/* movel %a0@(%d0:l:4),%d3 */
+	movel	%a0@(%d0),%d3
+	jeq	enosys
+
+1:
+	movel	%sp,%d2			/* get thread_info pointer */
+	andl	#-THREAD_SIZE,%d2	/* at start of kernel stack */
+	movel	%d2,%a0
+	movel	%a0@,%a1		/* save top of frame */
+	movel	%sp,%a1@(TASK_THREAD+THREAD_ESP0)
+	btst	#(TIF_SYSCALL_TRACE%8),%a0@(TI_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
+	bnes	1f
+
+	movel	%d3,%a0
+	jbsr	%a0@
+	movel	%d0,%sp@(PT_D0)		/* save the return value */
+	jra	ret_from_exception
+1:
+	movel	#-ENOSYS,%d2		/* strace needs -ENOSYS in PT_D0 */
+	movel	%d2,PT_D0(%sp)		/* on syscall entry */
+	subql	#4,%sp
+	SAVE_SWITCH_STACK
+	jbsr	syscall_trace
+	RESTORE_SWITCH_STACK
+	addql	#4,%sp
+	movel	%d3,%a0
+	jbsr	%a0@
+	movel	%d0,%sp@(PT_D0)		/* save the return value */
+	subql	#4,%sp			/* dummy return address */
+	SAVE_SWITCH_STACK
+	jbsr	syscall_trace
+
+ret_from_signal:
+	RESTORE_SWITCH_STACK
+	addql	#4,%sp
+
+ret_from_exception:
+	btst	#5,%sp@(PT_SR)		/* check if returning to kernel */
+	jeq	Luser_return		/* if so, skip resched, signals */
+
+Lkernel_return:
+	moveml	%sp@,%d1-%d5/%a0-%a2
+	lea	%sp@(32),%sp		/* space for 8 regs */
+	movel	%sp@+,%d0
+	addql	#4,%sp			/* orig d0 */
+	addl	%sp@+,%sp		/* stk adj */
+	rte
+
+Luser_return:
+	movel	%sp,%d1			/* get thread_info pointer */
+	andl	#-THREAD_SIZE,%d1	/* at base of kernel stack */
+	movel	%d1,%a0
+	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
+	andl	#_TIF_WORK_MASK,%d1
+	jne	Lwork_to_do		/* still work to do */
+
+Lreturn:
+	move	#0x2700,%sr		/* disable intrs */
+	movel	sw_usp,%a0		/* get usp */
+	movel	%sp@(PT_PC),%a0@-	/* copy exception program counter */
+	movel	%sp@(PT_FORMATVEC),%a0@-/* copy exception format/vector/sr */
+	moveml	%sp@,%d1-%d5/%a0-%a2
+	lea	%sp@(32),%sp		/* space for 8 regs */
+	movel	%sp@+,%d0
+	addql	#4,%sp			/* orig d0 */
+	addl	%sp@+,%sp		/* stk adj */
+	addql	#8,%sp			/* remove exception */
+	movel	%sp,sw_ksp		/* save ksp */
+	subql	#8,sw_usp		/* set exception */
+	movel	sw_usp,%sp		/* restore usp */
+	rte
+
+Lwork_to_do:
+	movel	%a0@(TI_FLAGS),%d1	/* get thread_info->flags */
+	btst	#TIF_NEED_RESCHED,%d1
+	jne	reschedule
+
+	/* GERG: do we need something here for TRACEing?? */
+
+Lsignal_return:
+	subql	#4,%sp			/* dummy return address */
+	SAVE_SWITCH_STACK
+	pea	%sp@(SWITCH_STACK_SIZE)
+	clrl	%sp@-
+	jsr	do_signal
+	addql	#8,%sp
+	RESTORE_SWITCH_STACK
+	addql	#4,%sp
+	jmp	Lreturn
+
+/*
+ * This is the generic interrupt handler (for all hardware interrupt
+ * sources). Calls upto high level code to do all the work.
+ */
+ENTRY(inthandler)
+	SAVE_ALL
+	moveq	#-1,%d0
+	movel	%d0,%sp@(PT_ORIG_D0)
+
+	movew	%sp@(PT_FORMATVEC),%d0	/* put exception # in d0 */
+	andl	#0x03fc,%d0		/* mask out vector only */
+
+	movel	%sp,%sp@-		/* push regs arg */
+	lsrl	#2,%d0			/* calculate real vector # */
+	movel	%d0,%sp@-		/* push vector number */
+	jbsr	do_IRQ			/* call high level irq handler */
+	lea	%sp@(8),%sp		/* pop args off stack */
+
+	bra	ret_from_interrupt	/* this was fallthrough */
+
+/*
+ * This is the fast interrupt handler (for certain hardware interrupt
+ * sources). Unlike the normal interrupt handler it just uses the
+ * current stack (doesn't care if it is user or kernel). It also
+ * doesn't bother doing the bottom half handlers.
+ */
+ENTRY(fasthandler)
+	SAVE_LOCAL
+
+	movew	%sp@(PT_FORMATVEC),%d0
+	andl	#0x03fc,%d0		/* mask out vector only */
+
+	movel	%sp,%sp@-		/* push regs arg */
+	lsrl	#2,%d0			/* calculate real vector # */
+	movel	%d0,%sp@-		/* push vector number */
+	jbsr	do_IRQ			/* call high level irq handler */
+	lea	%sp@(8),%sp		/* pop args off stack */
+
+	RESTORE_LOCAL
+
+ENTRY(ret_from_interrupt)
+	jeq	2f
+1:
+	RESTORE_ALL
+2:
+	moveb	%sp@(PT_SR),%d0
+	andl	#0x7,%d0
+	jhi	1b
+
+	/* check if we need to do software interrupts */
+	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
+	jeq	ret_from_exception
+
+	pea	ret_from_exception
+	jmp	do_softirq
+
+/*
+ * Beware - when entering resume, prev (the current task) is
+ * in a0, next (the new task) is in a1,so don't change these
+ * registers until their contents are no longer needed.
+ * This is always called in supervisor mode, so don't bother to save
+ * and restore sr; user's process sr is actually in the stack.
+ */
+ENTRY(resume)
+	movel	%a0, %d1			/* get prev thread in d1 */
+
+	movel	sw_usp,%d0			/* save usp */
+	movel	%d0,%a0@(TASK_THREAD+THREAD_USP)
+
+	SAVE_SWITCH_STACK
+	movel	%sp,%a0@(TASK_THREAD+THREAD_KSP) /* save kernel stack pointer */
+	movel	%a1@(TASK_THREAD+THREAD_KSP),%sp /* restore new thread stack */
+	RESTORE_SWITCH_STACK
+
+	movel	%a1@(TASK_THREAD+THREAD_USP),%a0 /* restore thread user stack */
+	movel	%a0, sw_usp
+	rts
