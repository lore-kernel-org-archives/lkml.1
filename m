Return-Path: <linux-kernel-owner+w=401wt.eu-S1422947AbXD3EDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422947AbXD3EDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422958AbXD3ECr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:02:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422947AbXD3ECn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:02:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/utrace
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Move sig_kernel_* et al macros to linux/signal.h
Message-Id: <20070430040238.B5B971801A4@magilla.sf.frob.com>
Date: Sun, 29 Apr 2007 21:02:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the sig_kernel_* and related macros from kernel/signal.c
to linux/signal.h, and cleans them up slightly.  I need the sig_kernel_*
macros for default signal behavior in the utrace code, and want to avoid
duplication or overhead to share the knowledge.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/signal.h |  125 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/signal.c        |  119 ---------------------------------------------
 2 files changed, 125 insertions(+), 119 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 1474905..9850667 100644  
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -243,6 +243,131 @@ extern int get_signal_to_deliver(siginfo
 
 extern struct kmem_cache *sighand_cachep;
 
+/*
+ * In POSIX a signal is sent either to a specific thread (Linux task)
+ * or to the process as a whole (Linux thread group).  How the signal
+ * is sent determines whether it's to one thread or the whole group,
+ * which determines which signal mask(s) are involved in blocking it
+ * from being delivered until later.  When the signal is delivered,
+ * either it's caught or ignored by a user handler or it has a default
+ * effect that applies to the whole thread group (POSIX process).
+ *
+ * The possible effects an unblocked signal set to SIG_DFL can have are:
+ *   ignore	- Nothing Happens
+ *   terminate	- kill the process, i.e. all threads in the group,
+ * 		  similar to exit_group.  The group leader (only) reports
+ *		  WIFSIGNALED status to its parent.
+ *   coredump	- write a core dump file describing all threads using
+ *		  the same mm and then kill all those threads
+ *   stop 	- stop all the threads in the group, i.e. TASK_STOPPED state
+ *
+ * SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.
+ * Other signals when not blocked and set to SIG_DFL behaves as follows.
+ * The job control signals also have other special effects.
+ *
+ *	+--------------------+------------------+
+ *	|  POSIX signal      |  default action  |
+ *	+--------------------+------------------+
+ *	|  SIGHUP            |  terminate	|
+ *	|  SIGINT            |	terminate	|
+ *	|  SIGQUIT           |	coredump 	|
+ *	|  SIGILL            |	coredump 	|
+ *	|  SIGTRAP           |	coredump 	|
+ *	|  SIGABRT/SIGIOT    |	coredump 	|
+ *	|  SIGBUS            |	coredump 	|
+ *	|  SIGFPE            |	coredump 	|
+ *	|  SIGKILL           |	terminate(+)	|
+ *	|  SIGUSR1           |	terminate	|
+ *	|  SIGSEGV           |	coredump 	|
+ *	|  SIGUSR2           |	terminate	|
+ *	|  SIGPIPE           |	terminate	|
+ *	|  SIGALRM           |	terminate	|
+ *	|  SIGTERM           |	terminate	|
+ *	|  SIGCHLD           |	ignore   	|
+ *	|  SIGCONT           |	ignore(*)	|
+ *	|  SIGSTOP           |	stop(*)(+)  	|
+ *	|  SIGTSTP           |	stop(*)  	|
+ *	|  SIGTTIN           |	stop(*)  	|
+ *	|  SIGTTOU           |	stop(*)  	|
+ *	|  SIGURG            |	ignore   	|
+ *	|  SIGXCPU           |	coredump 	|
+ *	|  SIGXFSZ           |	coredump 	|
+ *	|  SIGVTALRM         |	terminate	|
+ *	|  SIGPROF           |	terminate	|
+ *	|  SIGPOLL/SIGIO     |	terminate	|
+ *	|  SIGSYS/SIGUNUSED  |	coredump 	|
+ *	|  SIGSTKFLT         |	terminate	|
+ *	|  SIGWINCH          |	ignore   	|
+ *	|  SIGPWR            |	terminate	|
+ *	|  SIGRTMIN-SIGRTMAX |	terminate       |
+ *	+--------------------+------------------+
+ *	|  non-POSIX signal  |  default action  |
+ *	+--------------------+------------------+
+ *	|  SIGEMT            |  coredump	|
+ *	+--------------------+------------------+
+ *
+ * (+) For SIGKILL and SIGSTOP the action is "always", not just "default".
+ * (*) Special job control effects:
+ * When SIGCONT is sent, it resumes the process (all threads in the group)
+ * from TASK_STOPPED state and also clears any pending/queued stop signals
+ * (any of those marked with "stop(*)").  This happens regardless of blocking,
+ * catching, or ignoring SIGCONT.  When any stop signal is sent, it clears
+ * any pending/queued SIGCONT signals; this happens regardless of blocking,
+ * catching, or ignored the stop signal, though (except for SIGSTOP) the
+ * default action of stopping the process may happen later or never.
+ */
+
+#ifdef SIGEMT
+#define SIGEMT_MASK	rt_sigmask(SIGEMT)
+#else
+#define SIGEMT_MASK	0
+#endif
+
+#if SIGRTMIN > BITS_PER_LONG
+#define rt_sigmask(sig)	(1ULL << ((sig)-1))
+#else
+#define rt_sigmask(sig)	sigmask(sig)
+#endif
+#define siginmask(sig, mask) (rt_sigmask(sig) & (mask))
+
+#define SIG_KERNEL_ONLY_MASK (\
+	rt_sigmask(SIGKILL)   |  rt_sigmask(SIGSTOP))
+
+#define SIG_KERNEL_STOP_MASK (\
+	rt_sigmask(SIGSTOP)   |  rt_sigmask(SIGTSTP)   | \
+	rt_sigmask(SIGTTIN)   |  rt_sigmask(SIGTTOU)   )
+
+#define SIG_KERNEL_COREDUMP_MASK (\
+        rt_sigmask(SIGQUIT)   |  rt_sigmask(SIGILL)    | \
+	rt_sigmask(SIGTRAP)   |  rt_sigmask(SIGABRT)   | \
+        rt_sigmask(SIGFPE)    |  rt_sigmask(SIGSEGV)   | \
+	rt_sigmask(SIGBUS)    |  rt_sigmask(SIGSYS)    | \
+        rt_sigmask(SIGXCPU)   |  rt_sigmask(SIGXFSZ)   | \
+	SIGEMT_MASK				       )
+
+#define SIG_KERNEL_IGNORE_MASK (\
+        rt_sigmask(SIGCONT)   |  rt_sigmask(SIGCHLD)   | \
+	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    )
+
+#define sig_kernel_only(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_ONLY_MASK))
+#define sig_kernel_coredump(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_COREDUMP_MASK))
+#define sig_kernel_ignore(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_IGNORE_MASK))
+#define sig_kernel_stop(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
+
+#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
+
+#define sig_user_defined(t, signr) \
+	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
+	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
+
+#define sig_fatal(t, signr) \
+	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
+	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNAL_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index 3670225..4a5e1db 100644  
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -39,125 +39,6 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-/*
- * In POSIX a signal is sent either to a specific thread (Linux task)
- * or to the process as a whole (Linux thread group).  How the signal
- * is sent determines whether it's to one thread or the whole group,
- * which determines which signal mask(s) are involved in blocking it
- * from being delivered until later.  When the signal is delivered,
- * either it's caught or ignored by a user handler or it has a default
- * effect that applies to the whole thread group (POSIX process).
- *
- * The possible effects an unblocked signal set to SIG_DFL can have are:
- *   ignore	- Nothing Happens
- *   terminate	- kill the process, i.e. all threads in the group,
- * 		  similar to exit_group.  The group leader (only) reports
- *		  WIFSIGNALED status to its parent.
- *   coredump	- write a core dump file describing all threads using
- *		  the same mm and then kill all those threads
- *   stop 	- stop all the threads in the group, i.e. TASK_STOPPED state
- *
- * SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.
- * Other signals when not blocked and set to SIG_DFL behaves as follows.
- * The job control signals also have other special effects.
- *
- *	+--------------------+------------------+
- *	|  POSIX signal      |  default action  |
- *	+--------------------+------------------+
- *	|  SIGHUP            |  terminate	|
- *	|  SIGINT            |	terminate	|
- *	|  SIGQUIT           |	coredump 	|
- *	|  SIGILL            |	coredump 	|
- *	|  SIGTRAP           |	coredump 	|
- *	|  SIGABRT/SIGIOT    |	coredump 	|
- *	|  SIGBUS            |	coredump 	|
- *	|  SIGFPE            |	coredump 	|
- *	|  SIGKILL           |	terminate(+)	|
- *	|  SIGUSR1           |	terminate	|
- *	|  SIGSEGV           |	coredump 	|
- *	|  SIGUSR2           |	terminate	|
- *	|  SIGPIPE           |	terminate	|
- *	|  SIGALRM           |	terminate	|
- *	|  SIGTERM           |	terminate	|
- *	|  SIGCHLD           |	ignore   	|
- *	|  SIGCONT           |	ignore(*)	|
- *	|  SIGSTOP           |	stop(*)(+)  	|
- *	|  SIGTSTP           |	stop(*)  	|
- *	|  SIGTTIN           |	stop(*)  	|
- *	|  SIGTTOU           |	stop(*)  	|
- *	|  SIGURG            |	ignore   	|
- *	|  SIGXCPU           |	coredump 	|
- *	|  SIGXFSZ           |	coredump 	|
- *	|  SIGVTALRM         |	terminate	|
- *	|  SIGPROF           |	terminate	|
- *	|  SIGPOLL/SIGIO     |	terminate	|
- *	|  SIGSYS/SIGUNUSED  |	coredump 	|
- *	|  SIGSTKFLT         |	terminate	|
- *	|  SIGWINCH          |	ignore   	|
- *	|  SIGPWR            |	terminate	|
- *	|  SIGRTMIN-SIGRTMAX |	terminate       |
- *	+--------------------+------------------+
- *	|  non-POSIX signal  |  default action  |
- *	+--------------------+------------------+
- *	|  SIGEMT            |  coredump	|
- *	+--------------------+------------------+
- *
- * (+) For SIGKILL and SIGSTOP the action is "always", not just "default".
- * (*) Special job control effects:
- * When SIGCONT is sent, it resumes the process (all threads in the group)
- * from TASK_STOPPED state and also clears any pending/queued stop signals
- * (any of those marked with "stop(*)").  This happens regardless of blocking,
- * catching, or ignoring SIGCONT.  When any stop signal is sent, it clears
- * any pending/queued SIGCONT signals; this happens regardless of blocking,
- * catching, or ignored the stop signal, though (except for SIGSTOP) the
- * default action of stopping the process may happen later or never.
- */
-
-#ifdef SIGEMT
-#define M_SIGEMT	M(SIGEMT)
-#else
-#define M_SIGEMT	0
-#endif
-
-#if SIGRTMIN > BITS_PER_LONG
-#define M(sig) (1ULL << ((sig)-1))
-#else
-#define M(sig) (1UL << ((sig)-1))
-#endif
-#define T(sig, mask) (M(sig) & (mask))
-
-#define SIG_KERNEL_ONLY_MASK (\
-	M(SIGKILL)   |  M(SIGSTOP)                                   )
-
-#define SIG_KERNEL_STOP_MASK (\
-	M(SIGSTOP)   |  M(SIGTSTP)   |  M(SIGTTIN)   |  M(SIGTTOU)   )
-
-#define SIG_KERNEL_COREDUMP_MASK (\
-        M(SIGQUIT)   |  M(SIGILL)    |  M(SIGTRAP)   |  M(SIGABRT)   | \
-        M(SIGFPE)    |  M(SIGSEGV)   |  M(SIGBUS)    |  M(SIGSYS)    | \
-        M(SIGXCPU)   |  M(SIGXFSZ)   |  M_SIGEMT                     )
-
-#define SIG_KERNEL_IGNORE_MASK (\
-        M(SIGCONT)   |  M(SIGCHLD)   |  M(SIGWINCH)  |  M(SIGURG)    )
-
-#define sig_kernel_only(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_ONLY_MASK))
-#define sig_kernel_coredump(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_COREDUMP_MASK))
-#define sig_kernel_ignore(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_IGNORE_MASK))
-#define sig_kernel_stop(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_STOP_MASK))
-
-#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
-
-#define sig_user_defined(t, signr) \
-	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
-	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
-
-#define sig_fatal(t, signr) \
-	(!T(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
-	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
