Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYLMChY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYLMChY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYLMChK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:37:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43913 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYLMChI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:37:08 -0500
Date: Fri, 12 Dec 2008 18:36:25 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, roland@redhat.com,
       bastian@waldi.eu.org, Pavel Emelyanov <xemul@openvz.org>,
       sukadev@linux.vnet.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pid: Generalize task_active_pid_ns
Message-ID: <20081213023625.GB4147@us.ibm.com>
References: <20081213023144.GA3951@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213023144.GA3951@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 12 Dec 2008 11:49:27 -0800
Subject: [PATCH 2/2] pid: Generalize task_active_pid_ns

Currently task_active_pid_ns is not safe to call after a
task becomes a zombie and exit_task_namespaces is called,
as nsproxy becomes NULL.  By reading the pid namespace from
the pid of the task we can trivially solve this problem at
the cost of one extra memory read in what should be the
same cacheline as we read the namespace from.

When moving things around I have made task_active_pid_ns
out of line because keeping it in pid_namespace.h would
require adding includes of pid.h and sched.h that I
don't think we want.

This change does make task_active_pid_ns unsafe to call during
copy_process until we attach a pid on the task_struct which
seems to be a reasonable trade off.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/pid_namespace.h |    6 +-----
 kernel/fork.c                 |    4 ++--
 kernel/pid.c                  |    6 ++++++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index d82fe82..38d1032 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -79,11 +79,7 @@ static inline void zap_pid_ns_processes(struct pid_namespace *ns)
 }
 #endif /* CONFIG_PID_NS */
 
-static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
-{
-	return tsk->nsproxy->pid_ns;
-}
-
+extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pidmap_init(void);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index dba2d3f..9fa1d91 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1100,12 +1100,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	if (pid != &init_struct_pid) {
 		retval = -ENOMEM;
-		pid = alloc_pid(task_active_pid_ns(p));
+		pid = alloc_pid(p->nsproxy->pid_ns);
 		if (!pid)
 			goto bad_fork_cleanup_io;
 
 		if (clone_flags & CLONE_NEWPID) {
-			retval = pid_ns_prepare_proc(task_active_pid_ns(p));
+			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
 			if (retval < 0)
 				goto bad_fork_free_pid;
 		}
diff --git a/kernel/pid.c b/kernel/pid.c
index 064e76a..c5513fe 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -474,6 +474,12 @@ pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 }
 EXPORT_SYMBOL(task_session_nr_ns);
 
+struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
+{
+	return ns_of_pid(task_pid(tsk));
+}
+EXPORT_SYMBOL_GPL(task_active_pid_ns);
+
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
-- 
1.5.2.5

