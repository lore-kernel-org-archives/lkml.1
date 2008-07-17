Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYGQHuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYGQHuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYGQHuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:50:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbYGQHuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:50:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 5/6] x86: tracehook: TIF_NOTIFY_RESUME
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20080717075001.8C62C1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:50:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds TIF_NOTIFY_RESUME support for x86, both 64-bit and 32-bit.
When set, we call tracehook_notify_resume() on the way to user mode.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/signal_32.c   |    5 +++++
 arch/x86/kernel/signal_64.c   |    5 +++++
 include/asm-x86/thread_info.h |    4 +++-
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 3ffb88f..c17c0cb 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -663,6 +663,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
+
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
 		hrtick_resched();
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e78b97f..f65ece6 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -471,6 +471,11 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
+
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
 		hrtick_resched();
 }
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 0a8f27d..6ed4362 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -71,6 +71,7 @@ struct thread_info {
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -94,6 +95,7 @@ struct thread_info {
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
@@ -135,7 +137,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
