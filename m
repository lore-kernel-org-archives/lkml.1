Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZD1Jva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZD1Jva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZD1JvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:51:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZD1JvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] FRV: Implement TIF_NOTIFY_RESUME
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, hch@lst.de, roland@redhat.com,
       linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 10:49:36 +0100
Message-ID: <20090428094936.11879.96224.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090428094931.11879.99536.stgit@warthog.procyon.org.uk>
References: <20090428094931.11879.99536.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the TIF_NOTIFY_RESUME thread flag, making it call do_notify_resume()
which then clears it.  This will be made use of later by tracehooks in the
new-style ptrace implementation

Also discard TIF_IRET as that's not used by FRV.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/thread_info.h |   10 +++++-----
 arch/frv/kernel/signal.c           |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index bb53ab7..e8a5ed7 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -109,20 +109,20 @@ register struct thread_info *__current_thread_info asm("gr15");
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
-#define TIF_IRET		4	/* return with iret */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 3bdb368..7ae290a 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -564,4 +564,9 @@ asmlinkage void do_notify_resume(__u32 thread_info_flags)
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal();
 
+	/* deal with notification on about to resume userspace execution */
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+	}
+
 } /* end do_notify_resume() */

