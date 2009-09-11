Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZIKSxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZIKSxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZIKSw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:52:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50678 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbZIKSwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:52:46 -0400
Date: Fri, 11 Sep 2009 20:52:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core/locking for v2.6.32
Message-ID: <20090911185234.GA7745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

Highlights:

 - More flexible lock-op inlining/uninlining support, used on s390
 - Reimplement/improve lockdep via BFS
 - Various cleanups

 Thanks,

	Ingo

------------------>
Heiko Carstens (9):
      locking, powerpc: Rename __spin_try_lock() and friends
      locking, sparc: Rename __spin_try_lock() and friends
      locking, m68k/asm-offsets: Rename pt_regs offset defines
      locking, m68k: Calculate thread_info offset with asm offset
      locking: Move spinlock function bodies to header file
      locking: Allow arch-inlined spinlocks
      locking: Simplify spinlock inlining
      locking: Inline spinlock code for all locking variants on s390
      locking, m68k/asm-offsets: Rename signal defines

Ingo Molnar (1):
      lockdep: Fix BFS build

Li Zefan (5):
      lockdep: Fix missing entry in /proc/lock_stat
      lockdep: Fix missing entries in /proc/lock_chains
      lockdep: Simplify lockdep seqfile code
      lockdep: Simplify lockdep_chains seqfile code
      lockdep: Simplify lock_stat seqfile code

Ming Lei (12):
      lockdep: Print the shortest dependency chain if finding a circle
      lockdep: Improve implementation of BFS
      lockdep: Introduce match function to BFS
      lockdep: Implement check_noncircular() by BFS
      lockdep: Implement find_usage_*wards by BFS
      lockdep: Introduce print_shortest_lock_dependencies
      lockdep: Implement lockdep_count_*ward_deps by BFS
      lockdep: Update memory usage introduced by BFS
      lockdep: Add statistics info for max bfs queue depth
      lockdep: Reintroduce generation count to make BFS faster
      lockdep: Fix memory usage info of BFS
      lockdep: Remove recursion stattistics

Peter Zijlstra (5):
      lockdep: BFS cleanup
      lockdep: Fix backtraces
      lockdep: Fix style nits
      lockdep: Introduce lockdep_assert_held()
      lockdep: Deal with many similar locks


 arch/m68k/include/asm/entry_mm.h       |    4 -
 arch/m68k/include/asm/entry_no.h       |    8 +-
 arch/m68k/include/asm/math-emu.h       |   20 +-
 arch/m68k/include/asm/thread_info_mm.h |   11 +-
 arch/m68k/kernel/asm-offsets.c         |   39 +-
 arch/m68k/kernel/entry.S               |   22 +-
 arch/m68k/math-emu/fp_entry.S          |   38 +-
 arch/powerpc/include/asm/spinlock.h    |   20 +-
 arch/s390/include/asm/spinlock.h       |   29 ++
 arch/sparc/include/asm/spinlock_32.h   |   12 +-
 arch/sparc/include/asm/spinlock_64.h   |   28 +-
 include/linux/lockdep.h                |   18 +-
 include/linux/spinlock.h               |   64 +--
 include/linux/spinlock_api_smp.h       |  394 ++++++++++++++++
 kernel/lockdep.c                       |  792 +++++++++++++++++++++-----------
 kernel/lockdep_internals.h             |    2 +
 kernel/lockdep_proc.c                  |  128 +----
 kernel/sched.c                         |    2 +
 kernel/spinlock.c                      |  230 ++++------
 19 files changed, 1209 insertions(+), 652 deletions(-)

diff --git a/arch/m68k/include/asm/entry_mm.h b/arch/m68k/include/asm/entry_mm.h
index 5202f5a..4741258 100644
--- a/arch/m68k/include/asm/entry_mm.h
+++ b/arch/m68k/include/asm/entry_mm.h
@@ -46,7 +46,6 @@
 #define curptr a2
 
 LFLUSH_I_AND_D = 0x00000808
-LSIGTRAP = 5
 
 /* process bits for task_struct.ptrace */
 PT_TRACESYS_OFF = 3
@@ -118,9 +117,6 @@ PT_DTRACE_BIT = 2
 #define STR(X) STR1(X)
 #define STR1(X) #X
 
-#define PT_OFF_ORIG_D0	 0x24
-#define PT_OFF_FORMATVEC 0x32
-#define PT_OFF_SR	 0x2C
 #define SAVE_ALL_INT				\
 	"clrl	%%sp@-;"    /* stk_adj */	\
 	"pea	-1:w;"	    /* orig d0 = -1 */	\
diff --git a/arch/m68k/include/asm/entry_no.h b/arch/m68k/include/asm/entry_no.h
index c2553d2..907ed03 100644
--- a/arch/m68k/include/asm/entry_no.h
+++ b/arch/m68k/include/asm/entry_no.h
@@ -72,8 +72,8 @@ LENOSYS = 38
 	lea	%sp@(-32),%sp		/* space for 8 regs */
 	moveml	%d1-%d5/%a0-%a2,%sp@
 	movel	sw_usp,%a0		/* get usp */
-	movel	%a0@-,%sp@(PT_PC)	/* copy exception program counter */
-	movel	%a0@-,%sp@(PT_FORMATVEC)/* copy exception format/vector/sr */
+	movel	%a0@-,%sp@(PT_OFF_PC)	/* copy exception program counter */
+	movel	%a0@-,%sp@(PT_OFF_FORMATVEC)/*copy exception format/vector/sr */
 	bra	7f
 	6:
 	clrl	%sp@-			/* stkadj */
@@ -89,8 +89,8 @@ LENOSYS = 38
 	bnes	8f			/* no, skip */
 	move	#0x2700,%sr		/* disable intrs */
 	movel	sw_usp,%a0		/* get usp */
-	movel	%sp@(PT_PC),%a0@-	/* copy exception program counter */
-	movel	%sp@(PT_FORMATVEC),%a0@-/* copy exception format/vector/sr */
+	movel	%sp@(PT_OFF_PC),%a0@-	/* copy exception program counter */
+	movel	%sp@(PT_OFF_FORMATVEC),%a0@-/*copy exception format/vector/sr */
 	moveml	%sp@,%d1-%d5/%a0-%a2
 	lea	%sp@(32),%sp		/* space for 8 regs */
 	movel	%sp@+,%d0
diff --git a/arch/m68k/include/asm/math-emu.h b/arch/m68k/include/asm/math-emu.h
index ddfab96..5e9249b 100644
--- a/arch/m68k/include/asm/math-emu.h
+++ b/arch/m68k/include/asm/math-emu.h
@@ -145,16 +145,16 @@ extern unsigned int fp_debugprint;
  * these are only used during instruction decoding
  * where we always know how deep we're on the stack.
  */
-#define FPS_DO		(PT_D0)
-#define FPS_D1		(PT_D1)
-#define FPS_D2		(PT_D2)
-#define FPS_A0		(PT_A0)
-#define FPS_A1		(PT_A1)
-#define FPS_A2		(PT_A2)
-#define FPS_SR		(PT_SR)
-#define FPS_PC		(PT_PC)
-#define FPS_EA		(PT_PC+6)
-#define FPS_PC2		(PT_PC+10)
+#define FPS_DO		(PT_OFF_D0)
+#define FPS_D1		(PT_OFF_D1)
+#define FPS_D2		(PT_OFF_D2)
+#define FPS_A0		(PT_OFF_A0)
+#define FPS_A1		(PT_OFF_A1)
+#define FPS_A2		(PT_OFF_A2)
+#define FPS_SR		(PT_OFF_SR)
+#define FPS_PC		(PT_OFF_PC)
+#define FPS_EA		(PT_OFF_PC+6)
+#define FPS_PC2		(PT_OFF_PC+10)
 
 .macro	fp_get_fp_reg
 	lea	(FPD_FPREG,FPDATA,%d0.w*4),%a0
diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
index 6ea5c33..b6da388 100644
--- a/arch/m68k/include/asm/thread_info_mm.h
+++ b/arch/m68k/include/asm/thread_info_mm.h
@@ -1,6 +1,10 @@
 #ifndef _ASM_M68K_THREAD_INFO_H
 #define _ASM_M68K_THREAD_INFO_H
 
+#ifndef ASM_OFFSETS_C
+#include <asm/asm-offsets.h>
+#endif
+#include <asm/current.h>
 #include <asm/types.h>
 #include <asm/page.h>
 
@@ -31,7 +35,12 @@ struct thread_info {
 #define init_thread_info	(init_task.thread.info)
 #define init_stack		(init_thread_union.stack)
 
-#define task_thread_info(tsk)	(&(tsk)->thread.info)
+#ifdef ASM_OFFSETS_C
+#define task_thread_info(tsk)	((struct thread_info *) NULL)
+#else
+#define task_thread_info(tsk)	((struct thread_info *)((char *)tsk+TASK_TINFO))
+#endif
+
 #define task_stack_page(tsk)	((tsk)->stack)
 #define current_thread_info()	task_thread_info(current)
 
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index b1f012f..73e5e58 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -8,6 +8,8 @@
  * #defines from the assembly-language output.
  */
 
+#define ASM_OFFSETS_C
+
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
@@ -27,6 +29,9 @@ int main(void)
 	DEFINE(TASK_INFO, offsetof(struct task_struct, thread.info));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
+#ifdef CONFIG_MMU
+	DEFINE(TASK_TINFO, offsetof(struct task_struct, thread.info));
+#endif
 
 	/* offsets into the thread struct */
 	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
@@ -44,20 +49,20 @@ int main(void)
 	DEFINE(TINFO_FLAGS, offsetof(struct thread_info, flags));
 
 	/* offsets into the pt_regs */
-	DEFINE(PT_D0, offsetof(struct pt_regs, d0));
-	DEFINE(PT_ORIG_D0, offsetof(struct pt_regs, orig_d0));
-	DEFINE(PT_D1, offsetof(struct pt_regs, d1));
-	DEFINE(PT_D2, offsetof(struct pt_regs, d2));
-	DEFINE(PT_D3, offsetof(struct pt_regs, d3));
-	DEFINE(PT_D4, offsetof(struct pt_regs, d4));
-	DEFINE(PT_D5, offsetof(struct pt_regs, d5));
-	DEFINE(PT_A0, offsetof(struct pt_regs, a0));
-	DEFINE(PT_A1, offsetof(struct pt_regs, a1));
-	DEFINE(PT_A2, offsetof(struct pt_regs, a2));
-	DEFINE(PT_PC, offsetof(struct pt_regs, pc));
-	DEFINE(PT_SR, offsetof(struct pt_regs, sr));
+	DEFINE(PT_OFF_D0, offsetof(struct pt_regs, d0));
+	DEFINE(PT_OFF_ORIG_D0, offsetof(struct pt_regs, orig_d0));
+	DEFINE(PT_OFF_D1, offsetof(struct pt_regs, d1));
+	DEFINE(PT_OFF_D2, offsetof(struct pt_regs, d2));
+	DEFINE(PT_OFF_D3, offsetof(struct pt_regs, d3));
+	DEFINE(PT_OFF_D4, offsetof(struct pt_regs, d4));
+	DEFINE(PT_OFF_D5, offsetof(struct pt_regs, d5));
+	DEFINE(PT_OFF_A0, offsetof(struct pt_regs, a0));
+	DEFINE(PT_OFF_A1, offsetof(struct pt_regs, a1));
+	DEFINE(PT_OFF_A2, offsetof(struct pt_regs, a2));
+	DEFINE(PT_OFF_PC, offsetof(struct pt_regs, pc));
+	DEFINE(PT_OFF_SR, offsetof(struct pt_regs, sr));
 	/* bitfields are a bit difficult */
-	DEFINE(PT_VECTOR, offsetof(struct pt_regs, pc) + 4);
+	DEFINE(PT_OFF_FORMATVEC, offsetof(struct pt_regs, pc) + 4);
 
 	/* offsets into the irq_handler struct */
 	DEFINE(IRQ_HANDLER, offsetof(struct irq_node, handler));
@@ -84,10 +89,10 @@ int main(void)
 	DEFINE(FONT_DESC_PREF, offsetof(struct font_desc, pref));
 
 	/* signal defines */
-	DEFINE(SIGSEGV, SIGSEGV);
-	DEFINE(SEGV_MAPERR, SEGV_MAPERR);
-	DEFINE(SIGTRAP, SIGTRAP);
-	DEFINE(TRAP_TRACE, TRAP_TRACE);
+	DEFINE(LSIGSEGV, SIGSEGV);
+	DEFINE(LSEGV_MAPERR, SEGV_MAPERR);
+	DEFINE(LSIGTRAP, SIGTRAP);
+	DEFINE(LTRAP_TRACE, TRAP_TRACE);
 
 	/* offsets into the custom struct */
 	DEFINE(CUSTOMBASE, &amiga_custom);
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index c3735cd..922f52e 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -77,17 +77,17 @@ ENTRY(ret_from_fork)
 	jra	.Lret_from_exception
 
 do_trace_entry:
-	movel	#-ENOSYS,%sp@(PT_D0)	| needed for strace
+	movel	#-ENOSYS,%sp@(PT_OFF_D0)| needed for strace
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
-	movel	%sp@(PT_ORIG_D0),%d0
+	movel	%sp@(PT_OFF_ORIG_D0),%d0
 	cmpl	#NR_syscalls,%d0
 	jcs	syscall
 badsys:
-	movel	#-ENOSYS,%sp@(PT_D0)
+	movel	#-ENOSYS,%sp@(PT_OFF_D0)
 	jra	ret_from_syscall
 
 do_trace_exit:
@@ -103,7 +103,7 @@ ENTRY(ret_from_signal)
 	addql	#4,%sp
 /* on 68040 complete pending writebacks if any */
 #ifdef CONFIG_M68040
-	bfextu	%sp@(PT_VECTOR){#0,#4},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#0,#4},%d0
 	subql	#7,%d0				| bus error frame ?
 	jbne	1f
 	movel	%sp,%sp@-
@@ -127,7 +127,7 @@ ENTRY(system_call)
 	jcc	badsys
 syscall:
 	jbsr	@(sys_call_table,%d0:l:4)@(0)
-	movel	%d0,%sp@(PT_D0)		| save the return value
+	movel	%d0,%sp@(PT_OFF_D0)	| save the return value
 ret_from_syscall:
 	|oriw	#0x0700,%sr
 	movew	%curptr@(TASK_INFO+TINFO_FLAGS+2),%d0
@@ -135,7 +135,7 @@ ret_from_syscall:
 1:	RESTORE_ALL
 
 syscall_exit_work:
-	btst	#5,%sp@(PT_SR)		| check if returning to kernel
+	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
 	bnes	1b			| if so, skip resched, signals
 	lslw	#1,%d0
 	jcs	do_trace_exit
@@ -148,7 +148,7 @@ syscall_exit_work:
 
 ENTRY(ret_from_exception)
 .Lret_from_exception:
-	btst	#5,%sp@(PT_SR)		| check if returning to kernel
+	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
 	bnes	1f			| if so, skip resched, signals
 	| only allow interrupts when we are really the last one on the
 	| kernel stack, otherwise stack overflow can occur during
@@ -182,7 +182,7 @@ do_signal_return:
 	jbra	resume_userspace
 
 do_delayed_trace:
-	bclr	#7,%sp@(PT_SR)		| clear trace bit in SR
+	bclr	#7,%sp@(PT_OFF_SR)	| clear trace bit in SR
 	pea	1			| send SIGTRAP
 	movel	%curptr,%sp@-
 	pea	LSIGTRAP
@@ -199,7 +199,7 @@ ENTRY(auto_inthandler)
 	GET_CURRENT(%d0)
 	addqb	#1,%curptr@(TASK_INFO+TINFO_PREEMPT+1)
 					|  put exception # in d0
-	bfextu	%sp@(PT_VECTOR){#4,#10},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 	subw	#VEC_SPUR,%d0
 
 	movel	%sp,%sp@-
@@ -216,7 +216,7 @@ ret_from_interrupt:
 	ALIGN
 ret_from_last_interrupt:
 	moveq	#(~ALLOWINT>>8)&0xff,%d0
-	andb	%sp@(PT_SR),%d0
+	andb	%sp@(PT_OFF_SR),%d0
 	jne	2b
 
 	/* check if we need to do software interrupts */
@@ -232,7 +232,7 @@ ENTRY(user_inthandler)
 	GET_CURRENT(%d0)
 	addqb	#1,%curptr@(TASK_INFO+TINFO_PREEMPT+1)
 					|  put exception # in d0
-	bfextu	%sp@(PT_VECTOR){#4,#10},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 user_irqvec_fixup = . + 2
 	subw	#VEC_USER,%d0
 
diff --git a/arch/m68k/math-emu/fp_entry.S b/arch/m68k/math-emu/fp_entry.S
index 954b4f3..a3fe1f3 100644
--- a/arch/m68k/math-emu/fp_entry.S
+++ b/arch/m68k/math-emu/fp_entry.S
@@ -85,8 +85,8 @@ fp_err_ua2:
 fp_err_ua1:
 	addq.l	#4,%sp
 	move.l	%a0,-(%sp)
-	pea	SEGV_MAPERR
-	pea	SIGSEGV
+	pea	LSEGV_MAPERR
+	pea	LSIGSEGV
 	jsr	fpemu_signal
 	add.w	#12,%sp
 	jra	ret_from_exception
@@ -96,8 +96,8 @@ fp_err_ua1:
 	| it does not really belong here, but...
 fp_sendtrace060:
 	move.l	(FPS_PC,%sp),-(%sp)
-	pea	TRAP_TRACE
-	pea	SIGTRAP
+	pea	LTRAP_TRACE
+	pea	LSIGTRAP
 	jsr	fpemu_signal
 	add.w	#12,%sp
 	jra	ret_from_exception
@@ -122,17 +122,17 @@ fp_get_data_reg:
 	.long	fp_get_d6, fp_get_d7
 
 fp_get_d0:
-	move.l	(PT_D0+8,%sp),%d0
+	move.l	(PT_OFF_D0+8,%sp),%d0
 	printf	PREGISTER,"{d0->%08x}",1,%d0
 	rts
 
 fp_get_d1:
-	move.l	(PT_D1+8,%sp),%d0
+	move.l	(PT_OFF_D1+8,%sp),%d0
 	printf	PREGISTER,"{d1->%08x}",1,%d0
 	rts
 
 fp_get_d2:
-	move.l	(PT_D2+8,%sp),%d0
+	move.l	(PT_OFF_D2+8,%sp),%d0
 	printf	PREGISTER,"{d2->%08x}",1,%d0
 	rts
 
@@ -173,35 +173,35 @@ fp_put_data_reg:
 
 fp_put_d0:
 	printf	PREGISTER,"{d0<-%08x}",1,%d0
-	move.l	%d0,(PT_D0+8,%sp)
+	move.l	%d0,(PT_OFF_D0+8,%sp)
 	rts
 
 fp_put_d1:
 	printf	PREGISTER,"{d1<-%08x}",1,%d0
-	move.l	%d0,(PT_D1+8,%sp)
+	move.l	%d0,(PT_OFF_D1+8,%sp)
 	rts
 
 fp_put_d2:
 	printf	PREGISTER,"{d2<-%08x}",1,%d0
-	move.l	%d0,(PT_D2+8,%sp)
+	move.l	%d0,(PT_OFF_D2+8,%sp)
 	rts
 
 fp_put_d3:
 	printf	PREGISTER,"{d3<-%08x}",1,%d0
 |	move.l	%d0,%d3
-	move.l	%d0,(PT_D3+8,%sp)
+	move.l	%d0,(PT_OFF_D3+8,%sp)
 	rts
 
 fp_put_d4:
 	printf	PREGISTER,"{d4<-%08x}",1,%d0
 |	move.l	%d0,%d4
-	move.l	%d0,(PT_D4+8,%sp)
+	move.l	%d0,(PT_OFF_D4+8,%sp)
 	rts
 
 fp_put_d5:
 	printf	PREGISTER,"{d5<-%08x}",1,%d0
 |	move.l	%d0,%d5
-	move.l	%d0,(PT_D5+8,%sp)
+	move.l	%d0,(PT_OFF_D5+8,%sp)
 	rts
 
 fp_put_d6:
@@ -225,17 +225,17 @@ fp_get_addr_reg:
 	.long	fp_get_a6, fp_get_a7
 
 fp_get_a0:
-	move.l	(PT_A0+8,%sp),%a0
+	move.l	(PT_OFF_A0+8,%sp),%a0
 	printf	PREGISTER,"{a0->%08x}",1,%a0
 	rts
 
 fp_get_a1:
-	move.l	(PT_A1+8,%sp),%a0
+	move.l	(PT_OFF_A1+8,%sp),%a0
 	printf	PREGISTER,"{a1->%08x}",1,%a0
 	rts
 
 fp_get_a2:
-	move.l	(PT_A2+8,%sp),%a0
+	move.l	(PT_OFF_A2+8,%sp),%a0
 	printf	PREGISTER,"{a2->%08x}",1,%a0
 	rts
 
@@ -276,17 +276,17 @@ fp_put_addr_reg:
 
 fp_put_a0:
 	printf	PREGISTER,"{a0<-%08x}",1,%a0
-	move.l	%a0,(PT_A0+8,%sp)
+	move.l	%a0,(PT_OFF_A0+8,%sp)
 	rts
 
 fp_put_a1:
 	printf	PREGISTER,"{a1<-%08x}",1,%a0
-	move.l	%a0,(PT_A1+8,%sp)
+	move.l	%a0,(PT_OFF_A1+8,%sp)
 	rts
 
 fp_put_a2:
 	printf	PREGISTER,"{a2<-%08x}",1,%a0
-	move.l	%a0,(PT_A2+8,%sp)
+	move.l	%a0,(PT_OFF_A2+8,%sp)
 	rts
 
 fp_put_a3:
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index c3b1931..198266c 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -54,7 +54,7 @@
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
  */
-static inline unsigned long __spin_trylock(raw_spinlock_t *lock)
+static inline unsigned long arch_spin_trylock(raw_spinlock_t *lock)
 {
 	unsigned long tmp, token;
 
@@ -76,7 +76,7 @@ static inline unsigned long __spin_trylock(raw_spinlock_t *lock)
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
-	return __spin_trylock(lock) == 0;
+	return arch_spin_trylock(lock) == 0;
 }
 
 /*
@@ -108,7 +108,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(__spin_trylock(lock) == 0))
+		if (likely(arch_spin_trylock(lock) == 0))
 			break;
 		do {
 			HMT_low();
@@ -126,7 +126,7 @@ void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(__spin_trylock(lock) == 0))
+		if (likely(arch_spin_trylock(lock) == 0))
 			break;
 		local_save_flags(flags_dis);
 		local_irq_restore(flags);
@@ -181,7 +181,7 @@ extern void __raw_spin_unlock_wait(raw_spinlock_t *lock);
  * This returns the old value in the lock + 1,
  * so we got a read lock if the return value is > 0.
  */
-static inline long __read_trylock(raw_rwlock_t *rw)
+static inline long arch_read_trylock(raw_rwlock_t *rw)
 {
 	long tmp;
 
@@ -205,7 +205,7 @@ static inline long __read_trylock(raw_rwlock_t *rw)
  * This returns the old value in the lock,
  * so we got the write lock if the return value is 0.
  */
-static inline long __write_trylock(raw_rwlock_t *rw)
+static inline long arch_write_trylock(raw_rwlock_t *rw)
 {
 	long tmp, token;
 
@@ -228,7 +228,7 @@ static inline long __write_trylock(raw_rwlock_t *rw)
 static inline void __raw_read_lock(raw_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(__read_trylock(rw) > 0))
+		if (likely(arch_read_trylock(rw) > 0))
 			break;
 		do {
 			HMT_low();
@@ -242,7 +242,7 @@ static inline void __raw_read_lock(raw_rwlock_t *rw)
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(__write_trylock(rw) == 0))
+		if (likely(arch_write_trylock(rw) == 0))
 			break;
 		do {
 			HMT_low();
@@ -255,12 +255,12 @@ static inline void __raw_write_lock(raw_rwlock_t *rw)
 
 static inline int __raw_read_trylock(raw_rwlock_t *rw)
 {
-	return __read_trylock(rw) > 0;
+	return arch_read_trylock(rw) > 0;
 }
 
 static inline int __raw_write_trylock(raw_rwlock_t *rw)
 {
-	return __write_trylock(rw) == 0;
+	return arch_write_trylock(rw) == 0;
 }
 
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
diff --git a/arch/s390/include/asm/spinlock.h b/arch/s390/include/asm/spinlock.h
index c9af0d1..41ce686 100644
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -191,4 +191,33 @@ static inline int __raw_write_trylock(raw_rwlock_t *rw)
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
+#define __always_inline__spin_lock
+#define __always_inline__read_lock
+#define __always_inline__write_lock
+#define __always_inline__spin_lock_bh
+#define __always_inline__read_lock_bh
+#define __always_inline__write_lock_bh
+#define __always_inline__spin_lock_irq
+#define __always_inline__read_lock_irq
+#define __always_inline__write_lock_irq
+#define __always_inline__spin_lock_irqsave
+#define __always_inline__read_lock_irqsave
+#define __always_inline__write_lock_irqsave
+#define __always_inline__spin_trylock
+#define __always_inline__read_trylock
+#define __always_inline__write_trylock
+#define __always_inline__spin_trylock_bh
+#define __always_inline__spin_unlock
+#define __always_inline__read_unlock
+#define __always_inline__write_unlock
+#define __always_inline__spin_unlock_bh
+#define __always_inline__read_unlock_bh
+#define __always_inline__write_unlock_bh
+#define __always_inline__spin_unlock_irq
+#define __always_inline__read_unlock_irq
+#define __always_inline__write_unlock_irq
+#define __always_inline__spin_unlock_irqrestore
+#define __always_inline__read_unlock_irqrestore
+#define __always_inline__write_unlock_irqrestore
+
 #endif /* __ASM_SPINLOCK_H */
diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index 46f91ab..857630c 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -76,7 +76,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
  *
  * Unfortunately this scheme limits us to ~16,000,000 cpus.
  */
-static inline void __read_lock(raw_rwlock_t *rw)
+static inline void arch_read_lock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -92,11 +92,11 @@ static inline void __read_lock(raw_rwlock_t *rw)
 #define __raw_read_lock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	__read_lock(lock); \
+	arch_read_lock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void __read_unlock(raw_rwlock_t *rw)
+static inline void arch_read_unlock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -112,7 +112,7 @@ static inline void __read_unlock(raw_rwlock_t *rw)
 #define __raw_read_unlock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	__read_unlock(lock); \
+	arch_read_unlock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
@@ -150,7 +150,7 @@ static inline int __raw_write_trylock(raw_rwlock_t *rw)
 	return (val == 0);
 }
 
-static inline int __read_trylock(raw_rwlock_t *rw)
+static inline int arch_read_trylock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	register int res asm("o0");
@@ -169,7 +169,7 @@ static inline int __read_trylock(raw_rwlock_t *rw)
 ({	unsigned long flags; \
 	int res; \
 	local_irq_save(flags); \
-	res = __read_trylock(lock); \
+	res = arch_read_trylock(lock); \
 	local_irq_restore(flags); \
 	res; \
 })
diff --git a/arch/sparc/include/asm/spinlock_64.h b/arch/sparc/include/asm/spinlock_64.h
index f6b2b92..43e5147 100644
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -92,7 +92,7 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 
 /* Multi-reader locks, these are much saner than the 32-bit Sparc ones... */
 
-static void inline __read_lock(raw_rwlock_t *lock)
+static void inline arch_read_lock(raw_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -115,7 +115,7 @@ static void inline __read_lock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static int inline __read_trylock(raw_rwlock_t *lock)
+static int inline arch_read_trylock(raw_rwlock_t *lock)
 {
 	int tmp1, tmp2;
 
@@ -136,7 +136,7 @@ static int inline __read_trylock(raw_rwlock_t *lock)
 	return tmp1;
 }
 
-static void inline __read_unlock(raw_rwlock_t *lock)
+static void inline arch_read_unlock(raw_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -152,7 +152,7 @@ static void inline __read_unlock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline __write_lock(raw_rwlock_t *lock)
+static void inline arch_write_lock(raw_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2;
 
@@ -177,7 +177,7 @@ static void inline __write_lock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline __write_unlock(raw_rwlock_t *lock)
+static void inline arch_write_unlock(raw_rwlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stw		%%g0, [%0]"
@@ -186,7 +186,7 @@ static void inline __write_unlock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static int inline __write_trylock(raw_rwlock_t *lock)
+static int inline arch_write_trylock(raw_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2, result;
 
@@ -210,14 +210,14 @@ static int inline __write_trylock(raw_rwlock_t *lock)
 	return result;
 }
 
-#define __raw_read_lock(p)	__read_lock(p)
-#define __raw_read_lock_flags(p, f) __read_lock(p)
-#define __raw_read_trylock(p)	__read_trylock(p)
-#define __raw_read_unlock(p)	__read_unlock(p)
-#define __raw_write_lock(p)	__write_lock(p)
-#define __raw_write_lock_flags(p, f) __write_lock(p)
-#define __raw_write_unlock(p)	__write_unlock(p)
-#define __raw_write_trylock(p)	__write_trylock(p)
+#define __raw_read_lock(p)	arch_read_lock(p)
+#define __raw_read_lock_flags(p, f) arch_read_lock(p)
+#define __raw_read_trylock(p)	arch_read_trylock(p)
+#define __raw_read_unlock(p)	arch_read_unlock(p)
+#define __raw_write_lock(p)	arch_write_lock(p)
+#define __raw_write_lock_flags(p, f) arch_write_lock(p)
+#define __raw_write_unlock(p)	arch_write_unlock(p)
+#define __raw_write_trylock(p)	arch_write_trylock(p)
 
 #define __raw_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
 #define __raw_write_can_lock(rw)	(!(rw)->lock)
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b25d1b5..9ccf0e2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -149,6 +149,12 @@ struct lock_list {
 	struct lock_class		*class;
 	struct stack_trace		trace;
 	int				distance;
+
+	/*
+	 * The parent field is used to implement breadth-first search, and the
+	 * bit 0 is reused to indicate if the lock has been accessed in BFS.
+	 */
+	struct lock_list		*parent;
 };
 
 /*
@@ -208,10 +214,12 @@ struct held_lock {
 	 * interrupt context:
 	 */
 	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
-	unsigned int trylock:1;
+	unsigned int trylock:1;						/* 16 bits */
+
 	unsigned int read:2;        /* see lock_acquire() comment */
 	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
+	unsigned int references:11;					/* 32 bits */
 };
 
 /*
@@ -291,6 +299,10 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+
+extern int lock_is_held(struct lockdep_map *lock);
+
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
 			   unsigned long ip);
@@ -309,6 +321,8 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
+#define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -353,6 +367,8 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
+#define lockdep_assert_held(l)			do { } while (0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 4be57ab..f0ca7a7 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -143,15 +143,6 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
  */
 #define spin_unlock_wait(lock)	__raw_spin_unlock_wait(&(lock)->raw_lock)
 
-/*
- * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-# include <linux/spinlock_api_smp.h>
-#else
-# include <linux/spinlock_api_up.h>
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
@@ -268,50 +259,16 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
 
 #define spin_lock_irq(lock)		_spin_lock_irq(lock)
 #define spin_lock_bh(lock)		_spin_lock_bh(lock)
-
 #define read_lock_irq(lock)		_read_lock_irq(lock)
 #define read_lock_bh(lock)		_read_lock_bh(lock)
-
 #define write_lock_irq(lock)		_write_lock_irq(lock)
 #define write_lock_bh(lock)		_write_lock_bh(lock)
-
-/*
- * We inline the unlock functions in the nondebug case:
- */
-#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_PREEMPT) || \
-	!defined(CONFIG_SMP)
-# define spin_unlock(lock)		_spin_unlock(lock)
-# define read_unlock(lock)		_read_unlock(lock)
-# define write_unlock(lock)		_write_unlock(lock)
-# define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
-# define read_unlock_irq(lock)		_read_unlock_irq(lock)
-# define write_unlock_irq(lock)		_write_unlock_irq(lock)
-#else
-# define spin_unlock(lock) \
-    do {__raw_spin_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define read_unlock(lock) \
-    do {__raw_read_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define write_unlock(lock) \
-    do {__raw_write_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define spin_unlock_irq(lock)			\
-do {						\
-	__raw_spin_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-# define read_unlock_irq(lock)			\
-do {						\
-	__raw_read_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-# define write_unlock_irq(lock)			\
-do {						\
-	__raw_write_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-#endif
+#define spin_unlock(lock)		_spin_unlock(lock)
+#define read_unlock(lock)		_read_unlock(lock)
+#define write_unlock(lock)		_write_unlock(lock)
+#define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
+#define read_unlock_irq(lock)		_read_unlock_irq(lock)
+#define write_unlock_irq(lock)		_write_unlock_irq(lock)
 
 #define spin_unlock_irqrestore(lock, flags)		\
 	do {						\
@@ -380,4 +337,13 @@ extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
  */
 #define spin_can_lock(lock)	(!spin_is_locked(lock))
 
+/*
+ * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+# include <linux/spinlock_api_smp.h>
+#else
+# include <linux/spinlock_api_up.h>
+#endif
+
 #endif /* __LINUX_SPINLOCK_H */
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index d79845d..7a7e18f 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -60,4 +60,398 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+/*
+ * We inline the unlock functions in the nondebug case:
+ */
+#if !defined(CONFIG_DEBUG_SPINLOCK) && !defined(CONFIG_PREEMPT)
+#define __always_inline__spin_unlock
+#define __always_inline__read_unlock
+#define __always_inline__write_unlock
+#define __always_inline__spin_unlock_irq
+#define __always_inline__read_unlock_irq
+#define __always_inline__write_unlock_irq
+#endif
+
+#ifndef CONFIG_DEBUG_SPINLOCK
+#ifndef CONFIG_GENERIC_LOCKBREAK
+
+#ifdef __always_inline__spin_lock
+#define _spin_lock(lock) __spin_lock(lock)
+#endif
+
+#ifdef __always_inline__read_lock
+#define _read_lock(lock) __read_lock(lock)
+#endif
+
+#ifdef __always_inline__write_lock
+#define _write_lock(lock) __write_lock(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_bh
+#define _spin_lock_bh(lock) __spin_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__read_lock_bh
+#define _read_lock_bh(lock) __read_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__write_lock_bh
+#define _write_lock_bh(lock) __write_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_irq
+#define _spin_lock_irq(lock) __spin_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__read_lock_irq
+#define _read_lock_irq(lock) __read_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__write_lock_irq
+#define _write_lock_irq(lock) __write_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_irqsave
+#define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
+#endif
+
+#ifdef __always_inline__read_lock_irqsave
+#define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
+#endif
+
+#ifdef __always_inline__write_lock_irqsave
+#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
+#endif
+
+#endif /* !CONFIG_GENERIC_LOCKBREAK */
+
+#ifdef __always_inline__spin_trylock
+#define _spin_trylock(lock) __spin_trylock(lock)
+#endif
+
+#ifdef __always_inline__read_trylock
+#define _read_trylock(lock) __read_trylock(lock)
+#endif
+
+#ifdef __always_inline__write_trylock
+#define _write_trylock(lock) __write_trylock(lock)
+#endif
+
+#ifdef __always_inline__spin_trylock_bh
+#define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock
+#define _spin_unlock(lock) __spin_unlock(lock)
+#endif
+
+#ifdef __always_inline__read_unlock
+#define _read_unlock(lock) __read_unlock(lock)
+#endif
+
+#ifdef __always_inline__write_unlock
+#define _write_unlock(lock) __write_unlock(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_bh
+#define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__read_unlock_bh
+#define _read_unlock_bh(lock) __read_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__write_unlock_bh
+#define _write_unlock_bh(lock) __write_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_irq
+#define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__read_unlock_irq
+#define _read_unlock_irq(lock) __read_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__write_unlock_irq
+#define _write_unlock_irq(lock) __write_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_irqrestore
+#define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
+#endif
+
+#ifdef __always_inline__read_unlock_irqrestore
+#define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
+#endif
+
+#ifdef __always_inline__write_unlock_irqrestore
+#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
+#endif
+
+#endif /* CONFIG_DEBUG_SPINLOCK */
+
+static inline int __spin_trylock(spinlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __read_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_read_trylock(lock)) {
+		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __write_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_write_trylock(lock)) {
+		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+
+static inline void __read_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	/*
+	 * On lockdep we dont want the hand-coded irq-enable of
+	 * _raw_spin_lock_flags() code, because lockdep assumes
+	 * that interrupts are not re-enabled during lock-acquire:
+	 */
+#ifdef CONFIG_LOCKDEP
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+#else
+	_raw_spin_lock_flags(lock, &flags);
+#endif
+	return flags;
+}
+
+static inline void __spin_lock_irq(spinlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __spin_lock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
+			     _raw_read_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __read_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline void __read_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
+			     _raw_write_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __write_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __write_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __spin_lock(spinlock_t *lock)
+{
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __write_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+#endif /* CONFIG_PREEMPT */
+
+static inline void __spin_unlock(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __write_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __read_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irqrestore(spinlock_t *lock,
+					    unsigned long flags)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irq(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __spin_unlock_bh(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __read_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __read_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __write_unlock_irqrestore(rwlock_t *lock,
+					     unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __write_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __write_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline int __spin_trylock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	return 0;
+}
+
 #endif /* __LINUX_SPINLOCK_API_SMP_H */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8bbeef9..f74d2d7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -42,6 +42,7 @@
 #include <linux/hash.h>
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
+#include <linux/bitops.h>
 
 #include <asm/sections.h>
 
@@ -366,11 +367,21 @@ static int save_trace(struct stack_trace *trace)
 
 	save_stack_trace(trace);
 
+	/*
+	 * Some daft arches put -1 at the end to indicate its a full trace.
+	 *
+	 * <rant> this is buggy anyway, since it takes a whole extra entry so a
+	 * complete trace that maxes out the entries provided will be reported
+	 * as incomplete, friggin useless </rant>
+	 */
+	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+		trace->nr_entries--;
+
 	trace->max_entries = trace->nr_entries;
 
 	nr_stack_trace_entries += trace->nr_entries;
 
-	if (nr_stack_trace_entries == MAX_STACK_TRACE_ENTRIES) {
+	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES-1) {
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
@@ -388,20 +399,6 @@ unsigned int nr_hardirq_chains;
 unsigned int nr_softirq_chains;
 unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
-unsigned int max_recursion_depth;
-
-static unsigned int lockdep_dependency_gen_id;
-
-static bool lockdep_dependency_visit(struct lock_class *source,
-				     unsigned int depth)
-{
-	if (!depth)
-		lockdep_dependency_gen_id++;
-	if (source->dep_gen_id == lockdep_dependency_gen_id)
-		return true;
-	source->dep_gen_id = lockdep_dependency_gen_id;
-	return false;
-}
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
@@ -431,11 +428,8 @@ atomic_t redundant_softirqs_on;
 atomic_t redundant_softirqs_off;
 atomic_t nr_unused_locks;
 atomic_t nr_cyclic_checks;
-atomic_t nr_cyclic_check_recursions;
 atomic_t nr_find_usage_forwards_checks;
-atomic_t nr_find_usage_forwards_recursions;
 atomic_t nr_find_usage_backwards_checks;
-atomic_t nr_find_usage_backwards_recursions;
 #endif
 
 /*
@@ -551,58 +545,6 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	}
 }
 
-static void print_lock_class_header(struct lock_class *class, int depth)
-{
-	int bit;
-
-	printk("%*s->", depth, "");
-	print_lock_name(class);
-	printk(" ops: %lu", class->ops);
-	printk(" {\n");
-
-	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
-		if (class->usage_mask & (1 << bit)) {
-			int len = depth;
-
-			len += printk("%*s   %s", depth, "", usage_str[bit]);
-			len += printk(" at:\n");
-			print_stack_trace(class->usage_traces + bit, len);
-		}
-	}
-	printk("%*s }\n", depth, "");
-
-	printk("%*s ... key      at: ",depth,"");
-	print_ip_sym((unsigned long)class->key);
-}
-
-/*
- * printk all lock dependencies starting at <entry>:
- */
-static void __used
-print_lock_dependencies(struct lock_class *class, int depth)
-{
-	struct lock_list *entry;
-
-	if (lockdep_dependency_visit(class, depth))
-		return;
-
-	if (DEBUG_LOCKS_WARN_ON(depth >= 20))
-		return;
-
-	print_lock_class_header(class, depth);
-
-	list_for_each_entry(entry, &class->locks_after, entry) {
-		if (DEBUG_LOCKS_WARN_ON(!entry->class))
-			return;
-
-		print_lock_dependencies(entry->class, depth + 1);
-
-		printk("%*s ... acquired at:\n",depth,"");
-		print_stack_trace(&entry->trace, 2);
-		printk("\n");
-	}
-}
-
 static void print_kernel_version(void)
 {
 	printk("%s %.*s\n", init_utsname()->release,
@@ -898,22 +840,203 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 }
 
 /*
+ * For good efficiency of modular, we use power of 2
+ */
+#define MAX_CIRCULAR_QUEUE_SIZE		4096UL
+#define CQ_MASK				(MAX_CIRCULAR_QUEUE_SIZE-1)
+
+/*
+ * The circular_queue and helpers is used to implement the
+ * breadth-first search(BFS)algorithem, by which we can build
+ * the shortest path from the next lock to be acquired to the
+ * previous held lock if there is a circular between them.
+ */
+struct circular_queue {
+	unsigned long element[MAX_CIRCULAR_QUEUE_SIZE];
+	unsigned int  front, rear;
+};
+
+static struct circular_queue lock_cq;
+
+unsigned int max_bfs_queue_depth;
+
+static unsigned int lockdep_dependency_gen_id;
+
+static inline void __cq_init(struct circular_queue *cq)
+{
+	cq->front = cq->rear = 0;
+	lockdep_dependency_gen_id++;
+}
+
+static inline int __cq_empty(struct circular_queue *cq)
+{
+	return (cq->front == cq->rear);
+}
+
+static inline int __cq_full(struct circular_queue *cq)
+{
+	return ((cq->rear + 1) & CQ_MASK) == cq->front;
+}
+
+static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
+{
+	if (__cq_full(cq))
+		return -1;
+
+	cq->element[cq->rear] = elem;
+	cq->rear = (cq->rear + 1) & CQ_MASK;
+	return 0;
+}
+
+static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
+{
+	if (__cq_empty(cq))
+		return -1;
+
+	*elem = cq->element[cq->front];
+	cq->front = (cq->front + 1) & CQ_MASK;
+	return 0;
+}
+
+static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
+{
+	return (cq->rear - cq->front) & CQ_MASK;
+}
+
+static inline void mark_lock_accessed(struct lock_list *lock,
+					struct lock_list *parent)
+{
+	unsigned long nr;
+
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	lock->parent = parent;
+	lock->class->dep_gen_id = lockdep_dependency_gen_id;
+}
+
+static inline unsigned long lock_accessed(struct lock_list *lock)
+{
+	unsigned long nr;
+
+	nr = lock - list_entries;
+	WARN_ON(nr >= nr_list_entries);
+	return lock->class->dep_gen_id == lockdep_dependency_gen_id;
+}
+
+static inline struct lock_list *get_lock_parent(struct lock_list *child)
+{
+	return child->parent;
+}
+
+static inline int get_lock_depth(struct lock_list *child)
+{
+	int depth = 0;
+	struct lock_list *parent;
+
+	while ((parent = get_lock_parent(child))) {
+		child = parent;
+		depth++;
+	}
+	return depth;
+}
+
+static int __bfs(struct lock_list *source_entry,
+		 void *data,
+		 int (*match)(struct lock_list *entry, void *data),
+		 struct lock_list **target_entry,
+		 int forward)
+{
+	struct lock_list *entry;
+	struct list_head *head;
+	struct circular_queue *cq = &lock_cq;
+	int ret = 1;
+
+	if (match(source_entry, data)) {
+		*target_entry = source_entry;
+		ret = 0;
+		goto exit;
+	}
+
+	if (forward)
+		head = &source_entry->class->locks_after;
+	else
+		head = &source_entry->class->locks_before;
+
+	if (list_empty(head))
+		goto exit;
+
+	__cq_init(cq);
+	__cq_enqueue(cq, (unsigned long)source_entry);
+
+	while (!__cq_empty(cq)) {
+		struct lock_list *lock;
+
+		__cq_dequeue(cq, (unsigned long *)&lock);
+
+		if (!lock->class) {
+			ret = -2;
+			goto exit;
+		}
+
+		if (forward)
+			head = &lock->class->locks_after;
+		else
+			head = &lock->class->locks_before;
+
+		list_for_each_entry(entry, head, entry) {
+			if (!lock_accessed(entry)) {
+				unsigned int cq_depth;
+				mark_lock_accessed(entry, lock);
+				if (match(entry, data)) {
+					*target_entry = entry;
+					ret = 0;
+					goto exit;
+				}
+
+				if (__cq_enqueue(cq, (unsigned long)entry)) {
+					ret = -1;
+					goto exit;
+				}
+				cq_depth = __cq_get_elem_count(cq);
+				if (max_bfs_queue_depth < cq_depth)
+					max_bfs_queue_depth = cq_depth;
+			}
+		}
+	}
+exit:
+	return ret;
+}
+
+static inline int __bfs_forwards(struct lock_list *src_entry,
+			void *data,
+			int (*match)(struct lock_list *entry, void *data),
+			struct lock_list **target_entry)
+{
+	return __bfs(src_entry, data, match, target_entry, 1);
+
+}
+
+static inline int __bfs_backwards(struct lock_list *src_entry,
+			void *data,
+			int (*match)(struct lock_list *entry, void *data),
+			struct lock_list **target_entry)
+{
+	return __bfs(src_entry, data, match, target_entry, 0);
+
+}
+
+/*
  * Recursive, forwards-direction lock-dependency checking, used for
  * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
  * checking.
- *
- * (to keep the stackframe of the recursive functions small we
- *  use these global variables, and we also mark various helper
- *  functions as noinline.)
  */
-static struct held_lock *check_source, *check_target;
 
 /*
  * Print a dependency chain entry (this is only done when a deadlock
  * has been detected):
  */
 static noinline int
-print_circular_bug_entry(struct lock_list *target, unsigned int depth)
+print_circular_bug_entry(struct lock_list *target, int depth)
 {
 	if (debug_locks_silent)
 		return 0;
@@ -930,11 +1053,13 @@ print_circular_bug_entry(struct lock_list *target, unsigned int depth)
  * header first:
  */
 static noinline int
-print_circular_bug_header(struct lock_list *entry, unsigned int depth)
+print_circular_bug_header(struct lock_list *entry, unsigned int depth,
+			struct held_lock *check_src,
+			struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+	if (debug_locks_silent)
 		return 0;
 
 	printk("\n=======================================================\n");
@@ -943,9 +1068,9 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 	printk(  "-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
-	print_lock(check_source);
+	print_lock(check_src);
 	printk("\nbut task is already holding lock:\n");
-	print_lock(check_target);
+	print_lock(check_tgt);
 	printk("\nwhich lock already depends on the new lock.\n\n");
 	printk("\nthe existing dependency chain (in reverse order) is:\n");
 
@@ -954,19 +1079,36 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
 	return 0;
 }
 
-static noinline int print_circular_bug_tail(void)
+static inline int class_equal(struct lock_list *entry, void *data)
+{
+	return entry->class == data;
+}
+
+static noinline int print_circular_bug(struct lock_list *this,
+				struct lock_list *target,
+				struct held_lock *check_src,
+				struct held_lock *check_tgt)
 {
 	struct task_struct *curr = current;
-	struct lock_list this;
+	struct lock_list *parent;
+	int depth;
 
-	if (debug_locks_silent)
+	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	this.class = hlock_class(check_source);
-	if (!save_trace(&this.trace))
+	if (!save_trace(&this->trace))
 		return 0;
 
-	print_circular_bug_entry(&this, 0);
+	depth = get_lock_depth(target);
+
+	print_circular_bug_header(target, depth, check_src, check_tgt);
+
+	parent = get_lock_parent(target);
+
+	while (parent) {
+		print_circular_bug_entry(parent, --depth);
+		parent = get_lock_parent(parent);
+	}
 
 	printk("\nother info that might help us debug this:\n\n");
 	lockdep_print_held_locks(curr);
@@ -977,73 +1119,69 @@ static noinline int print_circular_bug_tail(void)
 	return 0;
 }
 
-#define RECURSION_LIMIT 40
-
-static int noinline print_infinite_recursion_bug(void)
+static noinline int print_bfs_bug(int ret)
 {
 	if (!debug_locks_off_graph_unlock())
 		return 0;
 
-	WARN_ON(1);
+	WARN(1, "lockdep bfs error:%d\n", ret);
 
 	return 0;
 }
 
-unsigned long __lockdep_count_forward_deps(struct lock_class *class,
-					   unsigned int depth)
+static int noop_count(struct lock_list *entry, void *data)
 {
-	struct lock_list *entry;
-	unsigned long ret = 1;
+	(*(unsigned long *)data)++;
+	return 0;
+}
 
-	if (lockdep_dependency_visit(class, depth))
-		return 0;
+unsigned long __lockdep_count_forward_deps(struct lock_list *this)
+{
+	unsigned long  count = 0;
+	struct lock_list *uninitialized_var(target_entry);
 
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+	__bfs_forwards(this, (void *)&count, noop_count, &target_entry);
 
-	return ret;
+	return count;
 }
-
 unsigned long lockdep_count_forward_deps(struct lock_class *class)
 {
 	unsigned long ret, flags;
+	struct lock_list this;
+
+	this.parent = NULL;
+	this.class = class;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&lockdep_lock);
-	ret = __lockdep_count_forward_deps(class, 0);
+	ret = __lockdep_count_forward_deps(&this);
 	__raw_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
 	return ret;
 }
 
-unsigned long __lockdep_count_backward_deps(struct lock_class *class,
-					    unsigned int depth)
+unsigned long __lockdep_count_backward_deps(struct lock_list *this)
 {
-	struct lock_list *entry;
-	unsigned long ret = 1;
+	unsigned long  count = 0;
+	struct lock_list *uninitialized_var(target_entry);
 
-	if (lockdep_dependency_visit(class, depth))
-		return 0;
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+	__bfs_backwards(this, (void *)&count, noop_count, &target_entry);
 
-	return ret;
+	return count;
 }
 
 unsigned long lockdep_count_backward_deps(struct lock_class *class)
 {
 	unsigned long ret, flags;
+	struct lock_list this;
+
+	this.parent = NULL;
+	this.class = class;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&lockdep_lock);
-	ret = __lockdep_count_backward_deps(class, 0);
+	ret = __lockdep_count_backward_deps(&this);
 	__raw_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
@@ -1055,29 +1193,16 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
  * lead to <target>. Print an error and return 0 if it does.
  */
 static noinline int
-check_noncircular(struct lock_class *source, unsigned int depth)
+check_noncircular(struct lock_list *root, struct lock_class *target,
+		struct lock_list **target_entry)
 {
-	struct lock_list *entry;
+	int result;
 
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
+	debug_atomic_inc(&nr_cyclic_checks);
 
-	debug_atomic_inc(&nr_cyclic_check_recursions);
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_after, entry) {
-		if (entry->class == hlock_class(check_target))
-			return print_circular_bug_header(entry, depth+1);
-		debug_atomic_inc(&nr_cyclic_checks);
-		if (!check_noncircular(entry->class, depth+1))
-			return print_circular_bug_entry(entry, depth+1);
-	}
-	return 1;
+	result = __bfs_forwards(root, target, class_equal, target_entry);
+
+	return result;
 }
 
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
@@ -1086,103 +1211,121 @@ check_noncircular(struct lock_class *source, unsigned int depth)
  * proving that two subgraphs can be connected by a new dependency
  * without creating any illegal irq-safe -> irq-unsafe lock dependency.
  */
-static enum lock_usage_bit find_usage_bit;
-static struct lock_class *forwards_match, *backwards_match;
+
+static inline int usage_match(struct lock_list *entry, void *bit)
+{
+	return entry->class->usage_mask & (1 << (enum lock_usage_bit)bit);
+}
+
+
 
 /*
  * Find a node in the forwards-direction dependency sub-graph starting
- * at <source> that matches <find_usage_bit>.
+ * at @root->class that matches @bit.
  *
- * Return 2 if such a node exists in the subgraph, and put that node
- * into <forwards_match>.
+ * Return 0 if such a node exists in the subgraph, and put that node
+ * into *@target_entry.
  *
- * Return 1 otherwise and keep <forwards_match> unchanged.
- * Return 0 on error.
+ * Return 1 otherwise and keep *@target_entry unchanged.
+ * Return <0 on error.
  */
-static noinline int
-find_usage_forwards(struct lock_class *source, unsigned int depth)
+static int
+find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
+			struct lock_list **target_entry)
 {
-	struct lock_list *entry;
-	int ret;
-
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
-
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
+	int result;
 
 	debug_atomic_inc(&nr_find_usage_forwards_checks);
-	if (source->usage_mask & (1 << find_usage_bit)) {
-		forwards_match = source;
-		return 2;
-	}
 
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_after, entry) {
-		debug_atomic_inc(&nr_find_usage_forwards_recursions);
-		ret = find_usage_forwards(entry->class, depth+1);
-		if (ret == 2 || ret == 0)
-			return ret;
-	}
-	return 1;
+	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
+
+	return result;
 }
 
 /*
  * Find a node in the backwards-direction dependency sub-graph starting
- * at <source> that matches <find_usage_bit>.
+ * at @root->class that matches @bit.
  *
- * Return 2 if such a node exists in the subgraph, and put that node
- * into <backwards_match>.
+ * Return 0 if such a node exists in the subgraph, and put that node
+ * into *@target_entry.
  *
- * Return 1 otherwise and keep <backwards_match> unchanged.
- * Return 0 on error.
+ * Return 1 otherwise and keep *@target_entry unchanged.
+ * Return <0 on error.
  */
-static noinline int
-find_usage_backwards(struct lock_class *source, unsigned int depth)
+static int
+find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
+			struct lock_list **target_entry)
 {
-	struct lock_list *entry;
-	int ret;
+	int result;
 
-	if (lockdep_dependency_visit(source, depth))
-		return 1;
+	debug_atomic_inc(&nr_find_usage_backwards_checks);
 
-	if (!__raw_spin_is_locked(&lockdep_lock))
-		return DEBUG_LOCKS_WARN_ON(1);
+	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
 
-	if (depth > max_recursion_depth)
-		max_recursion_depth = depth;
-	if (depth >= RECURSION_LIMIT)
-		return print_infinite_recursion_bug();
+	return result;
+}
 
-	debug_atomic_inc(&nr_find_usage_backwards_checks);
-	if (source->usage_mask & (1 << find_usage_bit)) {
-		backwards_match = source;
-		return 2;
-	}
+static void print_lock_class_header(struct lock_class *class, int depth)
+{
+	int bit;
 
-	if (!source && debug_locks_off_graph_unlock()) {
-		WARN_ON(1);
-		return 0;
-	}
+	printk("%*s->", depth, "");
+	print_lock_name(class);
+	printk(" ops: %lu", class->ops);
+	printk(" {\n");
 
-	/*
-	 * Check this lock's dependency list:
-	 */
-	list_for_each_entry(entry, &source->locks_before, entry) {
-		debug_atomic_inc(&nr_find_usage_backwards_recursions);
-		ret = find_usage_backwards(entry->class, depth+1);
-		if (ret == 2 || ret == 0)
-			return ret;
+	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
+		if (class->usage_mask & (1 << bit)) {
+			int len = depth;
+
+			len += printk("%*s   %s", depth, "", usage_str[bit]);
+			len += printk(" at:\n");
+			print_stack_trace(class->usage_traces + bit, len);
+		}
 	}
-	return 1;
+	printk("%*s }\n", depth, "");
+
+	printk("%*s ... key      at: ",depth,"");
+	print_ip_sym((unsigned long)class->key);
+}
+
+/*
+ * printk the shortest lock dependencies from @start to @end in reverse order:
+ */
+static void __used
+print_shortest_lock_dependencies(struct lock_list *leaf,
+				struct lock_list *root)
+{
+	struct lock_list *entry = leaf;
+	int depth;
+
+	/*compute depth from generated tree by BFS*/
+	depth = get_lock_depth(leaf);
+
+	do {
+		print_lock_class_header(entry->class, depth);
+		printk("%*s ... acquired at:\n", depth, "");
+		print_stack_trace(&entry->trace, 2);
+		printk("\n");
+
+		if (depth == 0 && (entry != root)) {
+			printk("lockdep:%s bad BFS generated tree\n", __func__);
+			break;
+		}
+
+		entry = get_lock_parent(entry);
+		depth--;
+	} while (entry && (depth >= 0));
+
+	return;
 }
 
 static int
 print_bad_irq_dependency(struct task_struct *curr,
+			 struct lock_list *prev_root,
+			 struct lock_list *next_root,
+			 struct lock_list *backwards_entry,
+			 struct lock_list *forwards_entry,
 			 struct held_lock *prev,
 			 struct held_lock *next,
 			 enum lock_usage_bit bit1,
@@ -1215,26 +1358,32 @@ print_bad_irq_dependency(struct task_struct *curr,
 
 	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
 		irqclass);
-	print_lock_name(backwards_match);
+	print_lock_name(backwards_entry->class);
 	printk("\n... which became %s-irq-safe at:\n", irqclass);
 
-	print_stack_trace(backwards_match->usage_traces + bit1, 1);
+	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
 
 	printk("\nto a %s-irq-unsafe lock:\n", irqclass);
-	print_lock_name(forwards_match);
+	print_lock_name(forwards_entry->class);
 	printk("\n... which became %s-irq-unsafe at:\n", irqclass);
 	printk("...");
 
-	print_stack_trace(forwards_match->usage_traces + bit2, 1);
+	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe %s-irq-safe lock's dependencies:\n", irqclass);
-	print_lock_dependencies(backwards_match, 0);
+	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
+	printk(" and the holding lock:\n");
+	if (!save_trace(&prev_root->trace))
+		return 0;
+	print_shortest_lock_dependencies(backwards_entry, prev_root);
 
-	printk("\nthe %s-irq-unsafe lock's dependencies:\n", irqclass);
-	print_lock_dependencies(forwards_match, 0);
+	printk("\nthe dependencies between the lock to be acquired");
+	printk(" and %s-irq-unsafe lock:\n", irqclass);
+	if (!save_trace(&next_root->trace))
+		return 0;
+	print_shortest_lock_dependencies(forwards_entry, next_root);
 
 	printk("\nstack backtrace:\n");
 	dump_stack();
@@ -1248,19 +1397,30 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 	    enum lock_usage_bit bit_forwards, const char *irqclass)
 {
 	int ret;
+	struct lock_list this, that;
+	struct lock_list *uninitialized_var(target_entry);
+	struct lock_list *uninitialized_var(target_entry1);
 
-	find_usage_bit = bit_backwards;
-	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(prev), 0);
-	if (!ret || ret == 1)
+	this.parent = NULL;
+
+	this.class = hlock_class(prev);
+	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
-	find_usage_bit = bit_forwards;
-	ret = find_usage_forwards(hlock_class(next), 0);
-	if (!ret || ret == 1)
+	that.parent = NULL;
+	that.class = hlock_class(next);
+	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
-	/* ret == 2 */
-	return print_bad_irq_dependency(curr, prev, next,
+
+	return print_bad_irq_dependency(curr, &this, &that,
+			target_entry, target_entry1,
+			prev, next,
 			bit_backwards, bit_forwards, irqclass);
 }
 
@@ -1472,6 +1632,8 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 {
 	struct lock_list *entry;
 	int ret;
+	struct lock_list this;
+	struct lock_list *uninitialized_var(target_entry);
 
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
@@ -1482,10 +1644,13 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * We are using global variables to control the recursion, to
 	 * keep the stackframe size of the recursive functions low:
 	 */
-	check_source = next;
-	check_target = prev;
-	if (!(check_noncircular(hlock_class(next), 0)))
-		return print_circular_bug_tail();
+	this.class = hlock_class(next);
+	this.parent = NULL;
+	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
+	if (unlikely(!ret))
+		return print_circular_bug(&this, target_entry, next, prev);
+	else if (unlikely(ret < 0))
+		return print_bfs_bug(ret);
 
 	if (!check_prev_add_irq(curr, prev, next))
 		return 0;
@@ -1884,7 +2049,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
  * print irq inversion bug:
  */
 static int
-print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
+print_irq_inversion_bug(struct task_struct *curr,
+			struct lock_list *root, struct lock_list *other,
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
@@ -1902,17 +2068,16 @@ print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
 		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
 		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
-	print_lock_name(other);
+	print_lock_name(other->class);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
 	printk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe first lock's dependencies:\n");
-	print_lock_dependencies(hlock_class(this), 0);
-
-	printk("\nthe second lock's dependencies:\n");
-	print_lock_dependencies(other, 0);
+	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
+	if (!save_trace(&root->trace))
+		return 0;
+	print_shortest_lock_dependencies(other, root);
 
 	printk("\nstack backtrace:\n");
 	dump_stack();
@@ -1929,14 +2094,19 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 		     enum lock_usage_bit bit, const char *irqclass)
 {
 	int ret;
-
-	find_usage_bit = bit;
-	/* fills in <forwards_match> */
-	ret = find_usage_forwards(hlock_class(this), 0);
-	if (!ret || ret == 1)
+	struct lock_list root;
+	struct lock_list *uninitialized_var(target_entry);
+
+	root.parent = NULL;
+	root.class = hlock_class(this);
+	ret = find_usage_forwards(&root, bit, &target_entry);
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
-	return print_irq_inversion_bug(curr, forwards_match, this, 1, irqclass);
+	return print_irq_inversion_bug(curr, &root, target_entry,
+					this, 1, irqclass);
 }
 
 /*
@@ -1948,14 +2118,19 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 		      enum lock_usage_bit bit, const char *irqclass)
 {
 	int ret;
-
-	find_usage_bit = bit;
-	/* fills in <backwards_match> */
-	ret = find_usage_backwards(hlock_class(this), 0);
-	if (!ret || ret == 1)
+	struct lock_list root;
+	struct lock_list *uninitialized_var(target_entry);
+
+	root.parent = NULL;
+	root.class = hlock_class(this);
+	ret = find_usage_backwards(&root, bit, &target_entry);
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
-	return print_irq_inversion_bug(curr, backwards_match, this, 0, irqclass);
+	return print_irq_inversion_bug(curr, &root, target_entry,
+					this, 1, irqclass);
 }
 
 void print_irqtrace_events(struct task_struct *curr)
@@ -2530,13 +2705,15 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip,
+			  int references)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
 	struct held_lock *hlock;
 	unsigned int depth, id;
 	int chain_head = 0;
+	int class_idx;
 	u64 chain_key;
 
 	if (!prove_locking)
@@ -2584,10 +2761,24 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(depth >= MAX_LOCK_DEPTH))
 		return 0;
 
+	class_idx = class - lock_classes + 1;
+
+	if (depth) {
+		hlock = curr->held_locks + depth - 1;
+		if (hlock->class_idx == class_idx && nest_lock) {
+			if (hlock->references)
+				hlock->references++;
+			else
+				hlock->references = 2;
+
+			return 1;
+		}
+	}
+
 	hlock = curr->held_locks + depth;
 	if (DEBUG_LOCKS_WARN_ON(!class))
 		return 0;
-	hlock->class_idx = class - lock_classes + 1;
+	hlock->class_idx = class_idx;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
 	hlock->nest_lock = nest_lock;
@@ -2595,6 +2786,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->read = read;
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
+	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = sched_clock();
@@ -2703,6 +2895,30 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
 	return 1;
 }
 
+static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
+{
+	if (hlock->instance == lock)
+		return 1;
+
+	if (hlock->references) {
+		struct lock_class *class = lock->class_cache;
+
+		if (!class)
+			class = look_up_lock_class(lock, 0);
+
+		if (DEBUG_LOCKS_WARN_ON(!class))
+			return 0;
+
+		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
+			return 0;
+
+		if (hlock->class_idx == class - lock_classes + 1)
+			return 1;
+	}
+
+	return 0;
+}
+
 static int
 __lock_set_class(struct lockdep_map *lock, const char *name,
 		 struct lock_class_key *key, unsigned int subclass,
@@ -2726,7 +2942,7 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -2745,7 +2961,8 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip,
+				hlock->references))
 			return 0;
 	}
 
@@ -2784,20 +3001,34 @@ lock_release_non_nested(struct task_struct *curr,
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
-	lock_release_holdtime(hlock);
+	if (hlock->instance == lock)
+		lock_release_holdtime(hlock);
+
+	if (hlock->references) {
+		hlock->references--;
+		if (hlock->references) {
+			/*
+			 * We had, and after removing one, still have
+			 * references, the current lock stack is still
+			 * valid. We're done!
+			 */
+			return 1;
+		}
+	}
 
 	/*
 	 * We have the right lock to unlock, 'hlock' points to it.
 	 * Now we remove it from the stack, and add back the other
 	 * entries (if any), recalculating the hash along the way:
 	 */
+
 	curr->lockdep_depth = i;
 	curr->curr_chain_key = hlock->prev_chain_key;
 
@@ -2806,7 +3037,8 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip,
+				hlock->references))
 			return 0;
 	}
 
@@ -2836,7 +3068,7 @@ static int lock_release_nested(struct task_struct *curr,
 	/*
 	 * Is the unlock non-nested:
 	 */
-	if (hlock->instance != lock)
+	if (hlock->instance != lock || hlock->references)
 		return lock_release_non_nested(curr, lock, ip);
 	curr->lockdep_depth--;
 
@@ -2881,6 +3113,21 @@ __lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
 	check_chain_key(curr);
 }
 
+static int __lock_is_held(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	int i;
+
+	for (i = 0; i < curr->lockdep_depth; i++) {
+		struct held_lock *hlock = curr->held_locks + i;
+
+		if (match_held_lock(hlock, lock))
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -2957,7 +3204,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
@@ -2982,6 +3229,26 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+int lock_is_held(struct lockdep_map *lock)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (unlikely(current->lockdep_recursion))
+		return ret;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	current->lockdep_recursion = 1;
+	ret = __lock_is_held(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lock_is_held);
+
 void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
 	current->lockdep_reclaim_gfp = gfp_mask;
@@ -3041,7 +3308,7 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3049,6 +3316,9 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 	return;
 
 found_it:
+	if (hlock->instance != lock)
+		return;
+
 	hlock->waittime_stamp = sched_clock();
 
 	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
@@ -3088,7 +3358,7 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3096,6 +3366,9 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	return;
 
 found_it:
+	if (hlock->instance != lock)
+		return;
+
 	cpu = smp_processor_id();
 	if (hlock->waittime_stamp) {
 		now = sched_clock();
@@ -3326,7 +3599,12 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024);
+		sizeof(struct list_head) * CHAINHASH_SIZE
+#ifdef CONFIG_PROVE_LOCKING
+		+ sizeof(struct circular_queue)
+#endif
+		) / 1024
+		);
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..a2ee95a 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -91,6 +91,8 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+extern unsigned int max_bfs_queue_depth;
+
 #ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index e94caa6..d4b3dbc 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -25,38 +25,12 @@
 
 static void *l_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_class *class;
-
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		class = m->private;
-	else {
-		class = v;
-
-		if (class->lock_entry.next != &all_lock_classes)
-			class = list_entry(class->lock_entry.next,
-					   struct lock_class, lock_entry);
-		else
-			class = NULL;
-	}
-
-	return class;
+	return seq_list_next(v, &all_lock_classes, pos);
 }
 
 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	struct lock_class *class;
-	loff_t i = 0;
-
-	if (*pos == 0)
-		return SEQ_START_TOKEN;
-
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		if (++i == *pos)
-		return class;
-	}
-	return NULL;
+	return seq_list_start_head(&all_lock_classes, *pos);
 }
 
 static void l_stop(struct seq_file *m, void *v)
@@ -82,11 +56,11 @@ static void print_name(struct seq_file *m, struct lock_class *class)
 
 static int l_show(struct seq_file *m, void *v)
 {
-	struct lock_class *class = v;
+	struct lock_class *class = list_entry(v, struct lock_class, lock_entry);
 	struct lock_list *entry;
 	char usage[LOCK_USAGE_CHARS];
 
-	if (v == SEQ_START_TOKEN) {
+	if (v == &all_lock_classes) {
 		seq_printf(m, "all lock classes:\n");
 		return 0;
 	}
@@ -128,17 +102,7 @@ static const struct seq_operations lockdep_ops = {
 
 static int lockdep_open(struct inode *inode, struct file *file)
 {
-	int res = seq_open(file, &lockdep_ops);
-	if (!res) {
-		struct seq_file *m = file->private_data;
-
-		if (!list_empty(&all_lock_classes))
-			m->private = list_entry(all_lock_classes.next,
-					struct lock_class, lock_entry);
-		else
-			m->private = NULL;
-	}
-	return res;
+	return seq_open(file, &lockdep_ops);
 }
 
 static const struct file_operations proc_lockdep_operations = {
@@ -149,37 +113,23 @@ static const struct file_operations proc_lockdep_operations = {
 };
 
 #ifdef CONFIG_PROVE_LOCKING
-static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct lock_chain *chain;
-
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		chain = m->private;
-	else {
-		chain = v;
-
-		if (*pos < nr_lock_chains)
-			chain = lock_chains + *pos;
-		else
-			chain = NULL;
-	}
-
-	return chain;
-}
-
 static void *lc_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	if (*pos < nr_lock_chains)
-		return lock_chains + *pos;
+	if (*pos - 1 < nr_lock_chains)
+		return lock_chains + (*pos - 1);
 
 	return NULL;
 }
 
+static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return lc_start(m, pos);
+}
+
 static void lc_stop(struct seq_file *m, void *v)
 {
 }
@@ -220,16 +170,7 @@ static const struct seq_operations lockdep_chains_ops = {
 
 static int lockdep_chains_open(struct inode *inode, struct file *file)
 {
-	int res = seq_open(file, &lockdep_chains_ops);
-	if (!res) {
-		struct seq_file *m = file->private_data;
-
-		if (nr_lock_chains)
-			m->private = lock_chains;
-		else
-			m->private = NULL;
-	}
-	return res;
+	return seq_open(file, &lockdep_chains_ops);
 }
 
 static const struct file_operations proc_lockdep_chains_operations = {
@@ -258,16 +199,10 @@ static void lockdep_stats_debug_show(struct seq_file *m)
 		debug_atomic_read(&chain_lookup_hits));
 	seq_printf(m, " cyclic checks:                 %11u\n",
 		debug_atomic_read(&nr_cyclic_checks));
-	seq_printf(m, " cyclic-check recursions:       %11u\n",
-		debug_atomic_read(&nr_cyclic_check_recursions));
 	seq_printf(m, " find-mask forwards checks:     %11u\n",
 		debug_atomic_read(&nr_find_usage_forwards_checks));
-	seq_printf(m, " find-mask forwards recursions: %11u\n",
-		debug_atomic_read(&nr_find_usage_forwards_recursions));
 	seq_printf(m, " find-mask backwards checks:    %11u\n",
 		debug_atomic_read(&nr_find_usage_backwards_checks));
-	seq_printf(m, " find-mask backwards recursions:%11u\n",
-		debug_atomic_read(&nr_find_usage_backwards_recursions));
 
 	seq_printf(m, " hardirq on events:             %11u\n", hi1);
 	seq_printf(m, " hardirq off events:            %11u\n", hi2);
@@ -409,8 +344,10 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_unused);
 	seq_printf(m, " max locking depth:             %11u\n",
 			max_lockdep_depth);
-	seq_printf(m, " max recursion depth:           %11u\n",
-			max_recursion_depth);
+#ifdef CONFIG_PROVE_LOCKING
+	seq_printf(m, " max bfs queue depth:           %11u\n",
+			max_bfs_queue_depth);
+#endif
 	lockdep_stats_debug_show(m);
 	seq_printf(m, " debug_locks:                   %11u\n",
 			debug_locks);
@@ -438,7 +375,6 @@ struct lock_stat_data {
 };
 
 struct lock_stat_seq {
-	struct lock_stat_data *iter;
 	struct lock_stat_data *iter_end;
 	struct lock_stat_data stats[MAX_LOCKDEP_KEYS];
 };
@@ -626,34 +562,22 @@ static void seq_header(struct seq_file *m)
 static void *ls_start(struct seq_file *m, loff_t *pos)
 {
 	struct lock_stat_seq *data = m->private;
+	struct lock_stat_data *iter;
 
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	data->iter = data->stats + *pos;
-	if (data->iter >= data->iter_end)
-		data->iter = NULL;
+	iter = data->stats + (*pos - 1);
+	if (iter >= data->iter_end)
+		iter = NULL;
 
-	return data->iter;
+	return iter;
 }
 
 static void *ls_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct lock_stat_seq *data = m->private;
-
 	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		data->iter = data->stats;
-	else {
-		data->iter = v;
-		data->iter++;
-	}
-
-	if (data->iter == data->iter_end)
-		data->iter = NULL;
-
-	return data->iter;
+	return ls_start(m, pos);
 }
 
 static void ls_stop(struct seq_file *m, void *v)
@@ -691,7 +615,6 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 		struct lock_stat_data *iter = data->stats;
 		struct seq_file *m = file->private_data;
 
-		data->iter = iter;
 		list_for_each_entry(class, &all_lock_classes, lock_entry) {
 			iter->class = class;
 			iter->stats = lock_stats(class);
@@ -699,7 +622,7 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 		}
 		data->iter_end = iter;
 
-		sort(data->stats, data->iter_end - data->iter,
+		sort(data->stats, data->iter_end - data->stats,
 				sizeof(struct lock_stat_data),
 				lock_stat_cmp, NULL);
 
@@ -734,7 +657,6 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 
 	vfree(seq->private);
-	seq->private = NULL;
 	return seq_release(inode, file);
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..2c75f7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6609,6 +6609,8 @@ int cond_resched_lock(spinlock_t *lock)
 	int resched = should_resched();
 	int ret = 0;
 
+	lockdep_assert_held(lock);
+
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
 		if (resched)
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 7932653..5ddab73 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -21,44 +21,29 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
+#ifndef _spin_trylock
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	
-	preempt_enable();
-	return 0;
+	return __spin_trylock(lock);
 }
 EXPORT_SYMBOL(_spin_trylock);
+#endif
 
+#ifndef _read_trylock
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_read_trylock(lock)) {
-		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __read_trylock(lock);
 }
 EXPORT_SYMBOL(_read_trylock);
+#endif
 
+#ifndef _write_trylock
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_write_trylock(lock)) {
-		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __write_trylock(lock);
 }
 EXPORT_SYMBOL(_write_trylock);
+#endif
 
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
@@ -67,132 +52,101 @@ EXPORT_SYMBOL(_write_trylock);
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
+#ifndef _read_lock
 void __lockfunc _read_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock(lock);
 }
 EXPORT_SYMBOL(_read_lock);
+#endif
 
+#ifndef _spin_lock_irqsave
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	/*
-	 * On lockdep we dont want the hand-coded irq-enable of
-	 * _raw_spin_lock_flags() code, because lockdep assumes
-	 * that interrupts are not re-enabled during lock-acquire:
-	 */
-#ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-#else
-	_raw_spin_lock_flags(lock, &flags);
-#endif
-	return flags;
+	return __spin_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irqsave);
+#endif
 
+#ifndef _spin_lock_irq
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
+#endif
 
+#ifndef _spin_lock_bh
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
+#endif
 
+#ifndef _read_lock_irqsave
 unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
-			     _raw_read_lock_flags, &flags);
-	return flags;
+	return __read_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
+#endif
 
+#ifndef _read_lock_irq
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_irq(lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
+#endif
 
+#ifndef _read_lock_bh
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_bh(lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
+#endif
 
+#ifndef _write_lock_irqsave
 unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
-			     _raw_write_lock_flags, &flags);
-	return flags;
+	return __write_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
+#endif
 
+#ifndef _write_lock_irq
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_irq(lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
+#endif
 
+#ifndef _write_lock_bh
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_bh(lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
+#endif
 
+#ifndef _spin_lock
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock(lock);
 }
-
 EXPORT_SYMBOL(_spin_lock);
+#endif
 
+#ifndef _write_lock
 void __lockfunc _write_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock(lock);
 }
-
 EXPORT_SYMBOL(_write_lock);
+#endif
 
 #else /* CONFIG_PREEMPT: */
 
@@ -318,125 +272,109 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
+#ifndef _spin_unlock
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable();
+	__spin_unlock(lock);
 }
 EXPORT_SYMBOL(_spin_unlock);
+#endif
 
+#ifndef _write_unlock
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable();
+	__write_unlock(lock);
 }
 EXPORT_SYMBOL(_write_unlock);
+#endif
 
+#ifndef _read_unlock
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable();
+	__read_unlock(lock);
 }
 EXPORT_SYMBOL(_read_unlock);
+#endif
 
+#ifndef _spin_unlock_irqrestore
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
+#endif
 
+#ifndef _spin_unlock_irq
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_irq);
+#endif
 
+#ifndef _spin_unlock_bh
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__spin_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
+#endif
 
+#ifndef _read_unlock_irqrestore
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__read_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_read_unlock_irqrestore);
+#endif
 
+#ifndef _read_unlock_irq
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__read_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_read_unlock_irq);
+#endif
 
+#ifndef _read_unlock_bh
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__read_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_read_unlock_bh);
+#endif
 
+#ifndef _write_unlock_irqrestore
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__write_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_write_unlock_irqrestore);
+#endif
 
+#ifndef _write_unlock_irq
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__write_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_write_unlock_irq);
+#endif
 
+#ifndef _write_unlock_bh
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__write_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_write_unlock_bh);
+#endif
 
+#ifndef _spin_trylock_bh
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
-	return 0;
+	return __spin_trylock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_trylock_bh);
+#endif
 
 notrace int in_lock_functions(unsigned long addr)
 {
