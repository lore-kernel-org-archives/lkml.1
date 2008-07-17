Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYGQH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYGQH3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYGQH3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:29:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbYGQH3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:29:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 04/23] tracehook: exit
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: more boundary conditions than the Middle East.
Message-Id: <20080717072840.C60F91541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:28:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the PTRACE_EVENT_EXIT tracing into a tracehook.h inline,
tracehook_report_exec().  The change has no effect, just clean-up.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   15 +++++++++++++++
 kernel/exit.c             |    6 ++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6276353..967ab47 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -95,4 +95,19 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 		send_sig(SIGTRAP, current, 0);
 }
 
+/**
+ * tracehook_report_exit - task has begun to exit
+ * @exit_code:		pointer to value destined for @current->exit_code
+ *
+ * @exit_code points to the value passed to do_exit(), which tracing
+ * might change here.  This is almost the first thing in do_exit(),
+ * before freeing any resources or setting the %PF_EXITING flag.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_report_exit(long *exit_code)
+{
+	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/exit.c b/kernel/exit.c
index 93d2711..bd243c3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -46,6 +46,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1005,10 +1006,7 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
-	if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
-		current->ptrace_message = code;
-		ptrace_notify((PTRACE_EVENT_EXIT << 8) | SIGTRAP);
-	}
+	tracehook_report_exit(&code);
 
 	/*
 	 * We're taking recursive faults here in do_exit. Safest is to just
