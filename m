Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYD2Bzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYD2Bzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYD2BxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37585 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbYD2BxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:03 -0400
Message-Id: <20080429015302.250786152@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:39 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 8/9] x86: thread_info: merge tif masks.
Content-Disposition: inline; filename=merge_tif_masks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TIF masks are basically the same. x86_32 also has _TIF_SYSCALL_EMU which is
zero for the 64 bit case. The tif masks become the same.

x86_64 has an additional _TIF_DONOTIFY_MASK. Does not hurt for the 32 bit case
since it is only used in x86_64 arch code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |   51 +++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:57:21.724529078 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:57:48.509890170 -0700
@@ -123,6 +123,27 @@ struct thread_info {
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK							\
+	(0x0000FFFF &							\
+	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|	\
+	 _TIF_SECCOMP|_TIF_SYSCALL_EMU))
+
+/* work to do on any return to user space */
+#define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
+
+#define _TIF_DO_NOTIFY_MASK						\
+	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+
+/* flags to check in __switch_to() */
+#define _TIF_WORK_CTXSW							\
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS| \
+								_TIF_NOTSC)
+
+#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
+#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
+
+
 #define PREEMPT_ACTIVE		0x10000000
 
 #ifdef CONFIG_X86_32
@@ -174,20 +195,6 @@ static inline struct thread_info *curren
 
 #endif
 
-/* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK							\
-	(0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT |	\
-			_TIF_SECCOMP | _TIF_SYSCALL_EMU))
-/* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
-
-/* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW						\
-	(_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR |	\
-	 _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
-#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
-#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)
-
 #else /* X86_32 */
 
 #include <asm/pda.h>
@@ -231,22 +238,6 @@ static inline struct thread_info *stack_
 
 #endif
 
-/* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK							\
-	(0x0000FFFF &							\
-	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_SECCOMP))
-/* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
-
-#define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
-
-/* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|_TIF_NOTSC)
-#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
-#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
-
 #endif /* !X86_32 */
 
 /*

-- 
