Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbZEGJWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbZEGJWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:22:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZEGJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:22:24 -0400
Date: Thu, 7 May 2009 09:21:49 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144549.794157000@intel.com>
References: <20090403144549.794157000@intel.com>
Subject: [tip:tracing/core] sched, hw-branch-tracer: add wait_task_context_switch() function to sched.h
Message-ID: <tip-a26b89f05d194413c7238e0bea071054f6b5d3c8@git.kernel.org>
Git-Commit-ID: a26b89f05d194413c7238e0bea071054f6b5d3c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:21:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a26b89f05d194413c7238e0bea071054f6b5d3c8
Gitweb:     http://git.kernel.org/tip/a26b89f05d194413c7238e0bea071054f6b5d3c8
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:12 +0200

sched, hw-branch-tracer: add wait_task_context_switch() function to sched.h

Add a function to wait until some other task has been
switched out at least once.

This differs from wait_task_inactive() subtly, in that the
latter will wait until the task has left the CPU.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: markus.t.metzger@gmail.com
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144549.794157000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    2 ++
 kernel/sched.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b94f354..a5b9a83 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1993,8 +1993,10 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+extern void wait_task_context_switch(struct task_struct *p);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline void wait_task_context_switch(struct task_struct *p) {}
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc1fd5..f91bc81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2003,6 +2003,49 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 }
 
 /*
+ * wait_task_context_switch -	wait for a thread to complete at least one
+ *				context switch.
+ *
+ * @p must not be current.
+ */
+void wait_task_context_switch(struct task_struct *p)
+{
+	unsigned long nvcsw, nivcsw, flags;
+	int running;
+	struct rq *rq;
+
+	nvcsw	= p->nvcsw;
+	nivcsw	= p->nivcsw;
+	for (;;) {
+		/*
+		 * The runqueue is assigned before the actual context
+		 * switch. We need to take the runqueue lock.
+		 *
+		 * We could check initially without the lock but it is
+		 * very likely that we need to take the lock in every
+		 * iteration.
+		 */
+		rq = task_rq_lock(p, &flags);
+		running = task_running(rq, p);
+		task_rq_unlock(rq, &flags);
+
+		if (likely(!running))
+			break;
+		/*
+		 * The switch count is incremented before the actual
+		 * context switch. We thus wait for two switches to be
+		 * sure at least one completed.
+		 */
+		if ((p->nvcsw - nvcsw) > 1)
+			break;
+		if ((p->nivcsw - nivcsw) > 1)
+			break;
+
+		cpu_relax();
+	}
+}
+
+/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
