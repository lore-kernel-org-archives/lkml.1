Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbXKYWIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbXKYWIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbXKYWI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:08:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790AbXKYWIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:08:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 24/27] x86: debugctlmsr context switch
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220819.B7D4726F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:08:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds low-level support for a per-thread value of MSR_IA32_DEBUGCTLMSR.
The per-thread value is switched in when TIF_DEBUGCTLMSR is set.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/process_32.c     |    6 +++++-
 arch/x86/kernel/process_64.c     |    3 +++
 include/asm-x86/processor_32.h   |    2 ++
 include/asm-x86/processor_64.h   |    2 ++
 include/asm-x86/thread_info_32.h |    6 ++++--
 include/asm-x86/thread_info_64.h |    4 +++-
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f59544e..3a822e3 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -581,10 +581,14 @@ static noinline void
 __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		 struct tss_struct *tss)
 {
-	struct thread_struct *next;
+	struct thread_struct *prev, *next;
 
+	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (next->debugctlmsr != prev->debugctlmsr)
+		wrmsr(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr, 0);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		set_debugreg(next->debugreg[0], 0);
 		set_debugreg(next->debugreg[1], 1);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 586f88e..c1e2e9a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -544,6 +544,9 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (next->debugctlmsr != prev->debugctlmsr)
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr);
+
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
 		loaddebug(next, 0);
 		loaddebug(next, 1);
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 34e8063..660d9b0 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -370,6 +370,8 @@ struct thread_struct {
  	unsigned long	iopl;
 /* max allowed port in the bitmap, in bytes: */
 	unsigned long	io_bitmap_max;
+/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
+	unsigned long	debugctlmsr;
 };
 
 #define INIT_THREAD  {							\
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index 2dd739a..1d6daa0 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -239,6 +239,8 @@ struct thread_struct {
 	int		ioperm;
 	unsigned long	*io_bitmap_ptr;
 	unsigned io_bitmap_max;
+/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
+	unsigned long	debugctlmsr;
 /* cached TLS descriptors. */
 	u64 tls_array[GDT_ENTRY_TLS_ENTRIES];
 } __attribute__((aligned(16)));
diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index 8a6483f..d5ae1e9 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -138,6 +138,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_NOTSC		20	/* TSC is not accessible in userland */
 #define TIF_FORCED_TF		21	/* true if TF in eflags artificially */
+#define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -153,6 +154,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_NOTSC		(1<<TIF_NOTSC)
 #define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
+#define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -162,8 +164,8 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG)
-#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC)
+#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG | _TIF_DEBUGCTLMSR)
+#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR)
 
 /*
  * Thread-synchronous status.
diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index 0ebcac4..8f36bbc 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -123,6 +123,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_DEBUGCTLMSR		24	/* uses thread_struct.debugctlmsr */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -140,6 +141,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -148,7 +150,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR)
 
 #define PREEMPT_ACTIVE     0x10000000
 
