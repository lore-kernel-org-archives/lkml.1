Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYGQHee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYGQHee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYGQHa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbYGQHay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 17/23] tracehook: force signal_pending()
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: don't try this at home, kids!
Message-Id: <20080717073050.85E5915411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines a new hook tracehook_force_sigpending() that lets
tracing code decide to force TIF_SIGPENDING on in recalc_sigpending().

This is not used yet, so it compiles away to nothing for now.
It lays the groundwork for new tracing code that can interrupt
a task synthetically without actually sending a signal.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   14 ++++++++++++++
 kernel/signal.c           |    4 +++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 4c50e1b..43bc51b 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -423,6 +423,20 @@ static inline int tracehook_consider_fatal_signal(struct task_struct *task,
 }
 
 /**
+ * tracehook_force_sigpending - let tracing force signal_pending(current) on
+ *
+ * Called when recomputing our signal_pending() flag.  Return nonzero
+ * to force the signal_pending() flag on, so that tracehook_get_signal()
+ * will be called before the next return to user mode.
+ *
+ * Called with @current->sighand->siglock held.
+ */
+static inline int tracehook_force_sigpending(void)
+{
+	return 0;
+}
+
+/**
  * tracehook_get_signal - deliver synthetic signal to traced task
  * @task:		@current
  * @regs:		task_pt_regs(@current)
diff --git a/kernel/signal.c b/kernel/signal.c
index cbec18e..44b5823 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -134,7 +134,9 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current) && !freezing(current))
+	if (unlikely(tracehook_force_sigpending()))
+		set_thread_flag(TIF_SIGPENDING);
+	else if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
