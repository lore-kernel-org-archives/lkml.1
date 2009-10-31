Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbZJaCdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbZJaCdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 22:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757650AbZJaCdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 22:33:53 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:37275 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbZJaCdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 22:33:53 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, David Howells <dhowells@redhat.com>,
       Michael Cree <mcree@orcon.net.nz>
Subject: [PATCH] Alpha: Rearrange thread info flags fixing two regressions
Date: Sat, 31 Oct 2009 15:33:03 +1300
Message-Id: <1256956383-2652-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AE8D005.1030302@twiddle.net>
References: <4AE8D005.1030302@twiddle.net>
X-DSPAM-Check: by mx6.orcon.net.nz on Sat, 31 Oct 2009 15:33:56 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Oct 31 15:33:57 2009
X-DSPAM-Confidence: 0.9920
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of the TIF_NOTIFY_RESUME flag, commit a583f1b54249b
"remove unused TIF_NOTIFY_RESUME flag," resulted in incorrect
setting of the unaligned access control flags by the prctl syscall.

The re-addition of the TIF_NOTIFY_RESUME flag, commit d0420c83f39f
"KEYS: Extend TIF_NOTIFY_RESUME to (almost) all architectures [try #6]"
further caused problems, namely incorrect operands to assembler code
as evidenced by:

AS      arch/alpha/kernel/entry.o
arch/alpha/kernel/entry.S: Assembler messages:
arch/alpha/kernel/entry.S:326: Warning: operand out of range (0x0000000000000406 is not between 0x0000000000000000 and 0x00000000000000ff)

Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
in lower 8 bits of the thread info flags, and (2) making sure that
ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/thread_info.h |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index e7a07f6..3ba4ded 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -61,21 +61,24 @@ register struct thread_info *__current_thread_info __asm__("$8");
 /*
  * Thread information flags:
  * - these are process state flags and used from assembly
- * - pending work-to-be-done flags come first to fit in and immediate operand.
+ * - pending work-to-be-done flags come first and must be assigned to be
+ *   within bits 0 to 7 to fit in and immediate operand.
+ * - ALPHA_UAC_SHIFT below must be kept consistent with the unaligned 
+ *   control flags.
  *
  * TIF_SYSCALL_TRACE is known to be 0 via blbs.
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	3	/* poll_idle is polling NEED_RESCHED */
-#define TIF_DIE_IF_KERNEL	4	/* dik recursion lock */
-#define TIF_UAC_NOPRINT		5	/* see sysinfo.h */
-#define TIF_UAC_NOFIX		6
-#define TIF_UAC_SIGBUS		7
-#define TIF_MEMDIE		8
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
-#define TIF_NOTIFY_RESUME	10	/* callback before returning to user */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	8	/* poll_idle is polling NEED_RESCHED */
+#define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
+#define TIF_UAC_NOPRINT		10	/* see sysinfo.h */
+#define TIF_UAC_NOFIX		11
+#define TIF_UAC_SIGBUS		12
+#define TIF_MEMDIE		13
+#define TIF_RESTORE_SIGMASK	14	/* restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -94,7 +97,7 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
 				 | _TIF_SYSCALL_TRACE)
 
-#define ALPHA_UAC_SHIFT		6
+#define ALPHA_UAC_SHIFT		10
 #define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
 				 1 << TIF_UAC_SIGBUS)
 
-- 
1.6.3.3

