Return-Path: <linux-kernel-owner+w=401wt.eu-S1030230AbXBOQ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbXBOQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXBOQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:58:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030218AbXBOQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:58:46 -0500
Date: Thu, 15 Feb 2007 17:52:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 03/14] syslets: generic kernel bits
Message-ID: <20070215165220.GD4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add the kernel generic bits - these are present even if !CONFIG_ASYNC_SUPPORT.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/sched.h |   23 ++++++++++++++++++++++-
 kernel/exit.c         |    3 +++
 kernel/fork.c         |    2 ++
 kernel/sched.c        |    9 +++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -83,12 +83,12 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/async.h>
 
 #include <asm/processor.h>
 
 struct exec_domain;
 struct futex_pi_state;
-
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.
@@ -997,6 +997,12 @@ struct task_struct {
 /* journalling filesystem info */
 	void *journal_info;
 
+/* async syscall support: */
+	struct async_thread *at, *async_ready;
+	struct async_head *ah;
+	struct async_thread __at;
+	struct async_head __ah;
+
 /* VM state */
 	struct reclaim_state *reclaim_state;
 
@@ -1053,6 +1059,21 @@ struct task_struct {
 #endif
 };
 
+/*
+ * Is an async syscall being executed currently?
+ */
+#ifdef CONFIG_ASYNC_SUPPORT
+static inline int async_syscall(struct task_struct *t)
+{
+	return t->async_ready != NULL;
+}
+#else /* !CONFIG_ASYNC_SUPPORT */
+static inline int async_syscall(struct task_struct *t)
+{
+	return 0;
+}
+#endif /* !CONFIG_ASYNC_SUPPORT */
+
 static inline pid_t process_group(struct task_struct *tsk)
 {
 	return tsk->signal->pgrp;
Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -26,6 +26,7 @@
 #include <linux/ptrace.h>
 #include <linux/profile.h>
 #include <linux/mount.h>
+#include <linux/async.h>
 #include <linux/proc_fs.h>
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
@@ -889,6 +890,8 @@ fastcall NORET_TYPE void do_exit(long co
 		schedule();
 	}
 
+	async_exit(tsk);
+
 	tsk->flags |= PF_EXITING;
 
 	if (unlikely(in_atomic()))
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -22,6 +22,7 @@
 #include <linux/personality.h>
 #include <linux/mempolicy.h>
 #include <linux/sem.h>
+#include <linux/async.h>
 #include <linux/file.h>
 #include <linux/key.h>
 #include <linux/binfmts.h>
@@ -1054,6 +1055,7 @@ static struct task_struct *copy_process(
 
 	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
+	async_init(p);
 	p->security = NULL;
 	p->io_context = NULL;
 	p->io_wait = NULL;
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -38,6 +38,7 @@
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/async.h>
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/timer.h>
@@ -3436,6 +3437,14 @@ asmlinkage void __sched schedule(void)
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
+	prev = current;
+	if (unlikely(prev->async_ready)) {
+		if (prev->state && !(preempt_count() & PREEMPT_ACTIVE) &&
+			(!(prev->state & TASK_INTERRUPTIBLE) ||
+				!signal_pending(prev)))
+			__async_schedule(prev);
+	}
+
 need_resched:
 	preempt_disable();
 	prev = current;
