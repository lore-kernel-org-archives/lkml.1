Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbZEHM6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbZEHM6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbZEHM55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:57:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715AbZEHM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:57:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] CRED: Rename cred_exec_mutex to reflect that it's a guard
	against ptrace
To: roland@redhat.com, jmorris@namei.org, chrisw@sous-sol.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, eparis@redhat.com,
       sds@tycho.nsa.gov, David Howells <dhowells@redhat.com>
Date: Fri, 08 May 2009 13:55:22 +0100
Message-ID: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename cred_exec_mutex to reflect that it's a guard against foreign
intervention on a process's credential state, such as is made by ptrace().  The
attachment of a debugger to a process affects execve()'s calculation of the new
credential state - _and_ also setprocattr()'s calculation of that state.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c               |    6 +++---
 fs/exec.c                 |   10 +++++-----
 include/linux/init_task.h |    4 ++--
 include/linux/sched.h     |    4 +++-
 kernel/cred.c             |    4 ++--
 kernel/ptrace.c           |    9 +++++----
 6 files changed, 20 insertions(+), 17 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 681ed81..bb2a9b2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1488,7 +1488,7 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
 	if (retval < 0)
 		goto out_free;
 	current->in_execve = 1;
@@ -1550,7 +1550,7 @@ int compat_do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1573,7 +1573,7 @@ out_unmark:
 
 out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);
diff --git a/fs/exec.c b/fs/exec.c
index 639177b..998e856 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1045,7 +1045,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
 
-	/* cred_exec_mutex must be held at least to this point to prevent
+	/* cred_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
 	 * credentials; any time after this it may be unlocked */
 
@@ -1055,7 +1055,7 @@ EXPORT_SYMBOL(install_exec_creds);
 
 /*
  * determine how safe it is to execute the proposed program
- * - the caller must hold current->cred_exec_mutex to protect against
+ * - the caller must hold current->cred_guard_mutex to protect against
  *   PTRACE_ATTACH
  */
 int check_unsafe_exec(struct linux_binprm *bprm)
@@ -1297,7 +1297,7 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
 	if (retval < 0)
 		goto out_free;
 	current->in_execve = 1;
@@ -1360,7 +1360,7 @@ int do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1383,7 +1383,7 @@ out_unmark:
 
 out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d87247d..7f54ba9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -145,8 +145,8 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	.real_cred	= &init_cred,					\
 	.cred		= &init_cred,					\
-	.cred_exec_mutex =						\
-		 __MUTEX_INITIALIZER(tsk.cred_exec_mutex),		\
+	.cred_guard_mutex =						\
+		 __MUTEX_INITIALIZER(tsk.cred_guard_mutex),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3fa82b3..5932ace 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1247,7 +1247,9 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct mutex cred_exec_mutex;	/* execve vs ptrace cred calculation mutex */
+	struct mutex cred_guard_mutex;	/* guard against foreign influences on
+					 * credential calculations
+					 * (notably. ptrace) */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
diff --git a/kernel/cred.c b/kernel/cred.c
index 3a03918..1bb4d7e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -167,7 +167,7 @@ EXPORT_SYMBOL(prepare_creds);
 
 /*
  * Prepare credentials for current to perform an execve()
- * - The caller must hold current->cred_exec_mutex
+ * - The caller must hold current->cred_guard_mutex
  */
 struct cred *prepare_exec_creds(void)
 {
@@ -276,7 +276,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	struct cred *new;
 	int ret;
 
-	mutex_init(&p->cred_exec_mutex);
+	mutex_init(&p->cred_guard_mutex);
 
 	if (
 #ifdef CONFIG_KEYS
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0692ab5..27ac802 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -185,10 +185,11 @@ int ptrace_attach(struct task_struct *task)
 	if (same_thread_group(task, current))
 		goto out;
 
-	/* Protect exec's credential calculations against our interference;
-	 * SUID, SGID and LSM creds get determined differently under ptrace.
+	/* Protect the target's credential calculations against our
+	 * interference; SUID, SGID and LSM creds get determined differently
+	 * under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
 	if (retval  < 0)
 		goto out;
 
@@ -232,7 +233,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
-	mutex_unlock(&task->cred_exec_mutex);
+	mutex_unlock(&task->cred_guard_mutex);
 out:
 	return retval;
 }

