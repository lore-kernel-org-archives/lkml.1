Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbYGQHgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbYGQHgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbYGQHbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:31:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986AbYGQHbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:31:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 18/23] tracehook: TIF_NOTIFY_RESUME
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080717073101.E62B515411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:31:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds tracehook.h inlines to enable a new arch feature in support
of user debugging/tracing.  This is not used yet, but it lays the
groundwork for a debugger to be able to wrangle a task that's possibly
running, without interrupting its syscalls in progress.

Each arch should define TIF_NOTIFY_RESUME, and in their entry.S code
treat it much like TIF_SIGPENDING.  That is, it causes you to take the
slow path when returning to user mode, where you get the full user-mode
state accessible as for signal handling or ptrace.  The arch code
should check TIF_NOTIFY_RESUME after handling TIF_SIGPENDING.
When it's set, clear it and then call tracehook_notify_resume().

In future, tracing code will call set_notify_resume() when it
wants to get a callback in tracehook_notify_resume().

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 43bc51b..32867ab 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -537,4 +537,38 @@ static inline void tracehook_report_death(struct task_struct *task,
 {
 }
 
+#ifdef TIF_NOTIFY_RESUME
+/**
+ * set_notify_resume - cause tracehook_notify_resume() to be called
+ * @task:		task that will call tracehook_notify_resume()
+ *
+ * Calling this arranges that @task will call tracehook_notify_resume()
+ * before returning to user mode.  If it's already running in user mode,
+ * it will enter the kernel and call tracehook_notify_resume() soon.
+ * If it's blocked, it will not be woken.
+ */
+static inline void set_notify_resume(struct task_struct *task)
+{
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
+		kick_process(task);
+}
+
+/**
+ * tracehook_notify_resume - report when about to return to user mode
+ * @regs:		user-mode registers of @current task
+ *
+ * This is called when %TIF_NOTIFY_RESUME has been set.  Now we are
+ * about to return to user mode, and the user state in @regs can be
+ * inspected or adjusted.  The caller in arch code has cleared
+ * %TIF_NOTIFY_RESUME before the call.  If the flag gets set again
+ * asynchronously, this will be called again before we return to
+ * user mode.
+ *
+ * Called without locks.
+ */
+static inline void tracehook_notify_resume(struct pt_regs *regs)
+{
+}
+#endif	/* TIF_NOTIFY_RESUME */
+
 #endif	/* <linux/tracehook.h> */
