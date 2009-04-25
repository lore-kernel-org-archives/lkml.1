Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZDYALd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZDYALd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZDYALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:11:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZDYALV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:11:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 05/17] arm: TIF_NOTIFY_RESUME
Message-Id: <20090425000937.3C485FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:09:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes arm support TIF_NOTIFY_RESUME, so that set_notify_resume()
requests a call to tracehook_notify_resume() on the way back to user mode.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/include/asm/thread_info.h |    4 ++++
 arch/arm/kernel/entry-common.S     |    2 +-
 arch/arm/kernel/signal.c           |    5 +++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 4f88482..def86a0 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -129,12 +129,14 @@ extern void vfp_sync_state(struct thread_info *thread);
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
+ *  TIF_NOTIFY_RESUME	- tracing notification pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_NOTIFY_RESUME	2
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
@@ -142,6 +144,7 @@ extern void vfp_sync_state(struct thread_info *thread);
 #define TIF_FREEZE		19
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
@@ -152,6 +155,7 @@ extern void vfp_sync_state(struct thread_info *thread);
  * Change these and you break ASM code in entry-common.S
  */
 #define _TIF_WORK_MASK		0x000000ff
+#define _TIF_DO_NOTIFY_RESUME	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index b55cb03..2523cac 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -51,7 +51,7 @@ fast_work_pending:
 work_pending:
 	tst	r1, #_TIF_NEED_RESCHED
 	bne	work_resched
-	tst	r1, #_TIF_SIGPENDING
+	tst	r1, #_TIF_DO_NOTIFY_RESUME
 	beq	no_work_pending
 	mov	r0, sp				@ 'regs'
 	mov	r2, why				@ 'syscall'
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 51e2187..6663ee0 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -705,4 +705,9 @@ do_notify_resume(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 {
 	if (thread_flags & _TIF_SIGPENDING)
 		do_signal(&current->blocked, regs, syscall);
+
+	if (thread_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
 }
