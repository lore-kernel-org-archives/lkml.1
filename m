Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXHKDPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXHKDPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 23:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbXHKDPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 23:15:37 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46424 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760742AbXHKDPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 23:15:36 -0400
Date: Fri, 10 Aug 2007 23:15:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC] Adding a TIF_KERNEL_TRACE to thread_info.h, s390 and ia64 8 bit limit
Message-ID: <20070811031533.GB15885@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:58:04 up 12 days,  3:16,  2 users,  load average: 0.74, 0.74, 0.69
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to add a TIF_KERNEL_TRACE that would have the same effect
as TIF_SYSCALL_TRACE, which is to call into do_syscall_trace when
enabled. It would be enabled by setting it in each thread info
structure (and protected against racy thread creation with proper flag
copy from the parent thread upon thread creation). The particularity of
TIF_KERNEL_TRACE is that it would be enabled dynamically system-wide
when kernel tracing is active.

The current similar flags that exist are TIF_SYSCALL_TRACE (for ptrace)
and TIF_SYSCALL_AUDIT (set by audit_alloc() at process creation if
auditing is enabled). However, touching these flags system-wide would
conflict with either syscall audit or ptrace, therefore the
introduction of a new thread flag looks like a plausible solution.

However, since the instructions used to test these flags are limited to
8 bits on some architectures, we run out of free flags at least on s390
and ia64.

I would appreciate some comments about the idea in general, and how
bitfield limitation should be overcomed for s390 and ia64.

Some details about the problematic patches below.

Thanks,

Mathieu Desnoyers


On s390:

/home/compudj/git/linux-2.6-lttng/arch/s390/kernel/entry.S: Assembler messages:
/home/compudj/git/linux-2.6-lttng/arch/s390/kernel/entry.S:252: Error: operand out of range (289 is not between 0 and 255)
/home/compudj/git/linux-2.6-lttng/arch/s390/kernel/entry.S:362: Error: operand out of range (289 is not between 0 and 255)
make[2]: *** [arch/s390/kernel/entry.o] Error 1

when adding:

---
 include/asm-s390/thread_info.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/thread_info.h	2007-07-30 18:53:20.000000000 -0400
+++ linux-2.6-lttng/include/asm-s390/thread_info.h	2007-07-30 18:53:24.000000000 -0400
@@ -96,6 +96,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -110,6 +111,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)

Index: linux-2.6-lttng/arch/s390/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry.S	2007-07-30 19:18:28.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/entry.S	2007-07-30 19:19:05.000000000 -0400
@@ -244,7 +244,7 @@ sysc_nr_ok:
 	mvc	SP_ARGS(4,%r15),SP_R7(%r15)
 sysc_do_restart:
 	l	%r8,BASED(.Lsysc_table)
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE)
 	l	%r8,0(%r7,%r8)	  # get system call addr.
 	bnz	BASED(sysc_tracesys)
 	basr	%r14,%r8	  # call sys_xxxx
@@ -354,7 +354,7 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	st	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE)
 	bz	BASED(sysc_return)
 	l	%r1,BASED(.Ltrace)
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
Index: linux-2.6-lttng/arch/s390/kernel/entry64.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/entry64.S	2007-07-30 19:19:10.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/entry64.S	2007-07-30 19:19:50.000000000 -0400
@@ -239,7 +239,7 @@ sysc_do_restart:
 	larl	%r10,sys_call_table_emu  # use 31 bit emulation system calls
 sysc_noemu:
 #endif
-	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE)
 	lgf	%r8,0(%r7,%r10) # load address of system call routine
 	jnz	sysc_tracesys
 	basr	%r14,%r8	# call sys_xxxx
@@ -346,7 +346,7 @@ sysc_tracego:
 	basr	%r14,%r8		# call sys_xxx
 	stg	%r2,SP_R2(%r15)		# store return value
 sysc_tracenogo:
-	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
+	tm	__TI_flags+7(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE)
 	jz	sysc_return
 	la	%r2,SP_PTREGS(%r15)	# load pt_regs
 	la	%r3,1


For ia64:

/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S: Assembler messages:
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:69: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:90: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:133: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:228: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:382: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
/home/compudj/git/linux-2.6-lttng/arch/ia64/kernel/fsys.S:549: Error: Operand 2 of `and' should be an 8-bit integer (-128-127)
make[2]: *** [arch/ia64/kernel/fsys.o] Error 1

This is weird, because I added bit "1<<7" (8th bit), which should fit in 8 bits.


---
 include/asm-ia64/thread_info.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/thread_info.h	2007-08-10 19:42:55.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/thread_info.h	2007-08-10 21:57:50.000000000 -0400
@@ -86,6 +86,7 @@ struct thread_info {
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_PERFMON_WORK	6	/* work for pfm_handle_work() */
+#define TIF_KERNEL_TRACE	7	/* kernel trace active */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -95,7 +96,8 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
+#define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_KERNEL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_PERFMON_WORK	(1 << TIF_PERFMON_WORK)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -108,9 +110,12 @@ struct thread_info {
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_PERFMON_WORK|_TIF_SYSCALL_AUDIT|\
 				 _TIF_NEED_RESCHED| _TIF_SYSCALL_TRACE|\
-				 _TIF_RESTORE_SIGMASK)
-/* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
-#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
+				 _TIF_RESTORE_SIGMASK|_TIF_KERNEL_TRACE)
+/*
+ * like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE, TIF_KERNEL_TRACE
+ * or TIF_SYSCALL_AUDIT
+ */
+#define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE))
 
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
