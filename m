Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXFNP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXFNP01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXFNPZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:25:59 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51061
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbXFNPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:25:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 2] make seccomp zerocost in schedule
X-Mercurial-Node: a1896c3e29c7fb4dc1811f24e9f5cfc8dcbad419
Message-Id: <a1896c3e29c7fb4dc181.1181833735@v2.random>
In-Reply-To: <patchbomb.1181833733@v2.random>
Date: Thu, 14 Jun 2007 17:08:55 +0200
From: Andrea Arcangeli <andrea@cpushare.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@cpushare.com>
# Date 1181833362 -7200
# Node ID a1896c3e29c7fb4dc1811f24e9f5cfc8dcbad419
# Parent  8d75c4aa7185fcdcc2e99f3fe0f1ec68cbd78a43
make seccomp zerocost in schedule

This follows a suggestion from Chuck Ebbert on how to make seccomp
absolutely zerocost in schedule too. The only remaining footprint of
seccomp is in terms of the bzImage size that becomes a few bytes
(perhaps even a few kbytes) larger, measure it if you care in the
embedded.

Signed-off-by: Andrea Arcangeli <andrea@cpushare.com>

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -538,8 +538,31 @@ int dump_task_regs(struct task_struct *t
 	return 1;
 }
 
-static noinline void __switch_to_xtra(struct task_struct *next_p,
-				    struct tss_struct *tss)
+#ifdef CONFIG_SECCOMP
+void hard_disable_TSC(void)
+{
+	write_cr4(read_cr4() | X86_CR4_TSD);
+}
+void disable_TSC(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_disable_TSC();
+	preempt_enable();
+}
+void hard_enable_TSC(void)
+{
+	write_cr4(read_cr4() & ~X86_CR4_TSD);
+}
+#endif /* CONFIG_SECCOMP */
+
+static noinline void
+__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		 struct tss_struct *tss)
 {
 	struct thread_struct *next;
 
@@ -555,6 +578,17 @@ static noinline void __switch_to_xtra(st
 		set_debugreg(next->debugreg[7], 7);
 	}
 
+#ifdef CONFIG_SECCOMP
+	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
+	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
+			hard_disable_TSC();
+		else
+			hard_enable_TSC();
+	}
+#endif
+
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
@@ -583,33 +617,6 @@ static noinline void __switch_to_xtra(st
 	 * perform any I/O during its timeslice.
 	 */
 	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
-}
-
-/*
- * This function selects if the context switch from prev to next
- * has to tweak the TSC disable bit in the cr4.
- */
-static inline void disable_tsc(struct task_struct *prev_p,
-			       struct task_struct *next_p)
-{
-	struct thread_info *prev, *next;
-
-	/*
-	 * gcc should eliminate the ->thread_info dereference if
-	 * has_secure_computing returns 0 at compile time (SECCOMP=n).
-	 */
-	prev = task_thread_info(prev_p);
-	next = task_thread_info(next_p);
-
-	if (has_secure_computing(prev) || has_secure_computing(next)) {
-		/* slow path here */
-		if (has_secure_computing(prev) &&
-		    !has_secure_computing(next)) {
-			write_cr4(read_cr4() & ~X86_CR4_TSD);
-		} else if (!has_secure_computing(prev) &&
-			   has_secure_computing(next))
-			write_cr4(read_cr4() | X86_CR4_TSD);
-	}
 }
 
 /*
@@ -689,11 +696,9 @@ struct task_struct fastcall * __switch_t
 	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
-	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)))
-		__switch_to_xtra(next_p, tss);
-
-	disable_tsc(prev_p, next_p);
+	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
+		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
+		__switch_to_xtra(prev_p, next_p, tss);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
diff --git a/include/asm-i386/processor.h b/include/asm-i386/processor.h
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -227,6 +227,10 @@ extern int bootloader_type;
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
+extern void hard_disable_TSC(void);
+extern void disable_TSC(void);
+extern void hard_enable_TSC(void);
+
 /*
  * Size of io_bitmap.
  */
diff --git a/include/asm-i386/thread_info.h b/include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h
+++ b/include/asm-i386/thread_info.h
@@ -137,6 +137,7 @@ static inline struct thread_info *curren
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
+#define TIF_NOTSC		20	/* TSC is not accessible in userland */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -151,6 +152,7 @@ static inline struct thread_info *curren
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_NOTSC		(1<<TIF_NOTSC)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -160,7 +162,8 @@ static inline struct thread_info *curren
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG)
+#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC)
 
 /*
  * Thread-synchronous status.
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -16,11 +16,6 @@ static inline void secure_computing(int 
 		__secure_computing(this_syscall);
 }
 
-static inline int has_secure_computing(struct thread_info *ti)
-{
-	return unlikely(test_ti_thread_flag(ti, TIF_SECCOMP));
-}
-
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
@@ -29,11 +24,6 @@ typedef struct { } seccomp_t;
 typedef struct { } seccomp_t;
 
 #define secure_computing(x) do { } while (0)
-/* static inline to preserve typechecking */
-static inline int has_secure_computing(struct thread_info *ti)
-{
-	return 0;
-}
 
 static inline long prctl_get_seccomp(void)
 {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -74,6 +74,9 @@ long prctl_set_seccomp(unsigned long sec
 	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
 		current->seccomp.mode = seccomp_mode;
 		set_thread_flag(TIF_SECCOMP);
+#ifdef TIF_NOTSC
+		disable_TSC();
+#endif
 		ret = 0;
 	}
 
