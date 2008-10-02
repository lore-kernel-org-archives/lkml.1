Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYJBKwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYJBKwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 06:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYJBKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 06:52:21 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56382 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbYJBKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:52:20 -0400
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: ptrace_attach() should use the target process's mutex
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp>
	<20081001153823.9930.86648.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081001153823.9930.86648.stgit@warthog.procyon.org.uk>
Message-Id: <200810021952.GFJ87098.VQFtMOHJOFFLSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 2 Oct 2008 19:52:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

TOMOYO Linux is now trying to use CRED API, but some troubles were found.
Thus, I want the below patch for TOMOYO Linux.

Regards.
-----
Subject: Add hooks for notifying of start/finish of an execve operation.

This patch adds two hooks, security_start_execve() / security_finish_execve(),
for notifying an LSM module of an execve operation is about to start and
finish.

TOMOYO Linux checks read and/or write permissions at security_dentry_open()
if security_dentry_open() is called outside do_execve() (e.g. sys_open()).
But TOMOYO Linux wants to skip permission checks at security_dentry_open()
if security_dentry_open() is called inside do_execve() (i.e. open_exec()), for
TOMOYO Linux checks permissions at security_bprm_check() using
current->cred->security for program and bprm->cred->security for interpreter.

To implement this exception, I have to tell whether TOMOYO Linux should do
permission checks at security_dentry_open(). And I want a flag that tells
whether the current process is in an execve operation or not.

I tried to use

  static int tmy_dentry_open(struct file *f, const struct cred *cred)
  {
          ...
          /* Don't check read permission here if called from do_execve(). */
          if (mutex_is_locked(&current->cred_exec_mutex))
                  return 0;
          ...
  }

for judging whether the current process is in an execve operation or not.
But it turned out that this code won't work because current->cred_exec_mutex
can be locked by other processes. Thus, I'm trying to use

  struct execve_entry {
         struct list_head list;
         struct task_struct *task;
  };
  
  static LIST_HEAD(execve_list);
  static DEFINE_SPINLOCK(execve_list_lock);
  
  static int tmy_start_execve(void)
  {
          struct execve_entry *ee = kmalloc(sizeof(*ee), GFP_KERNEL);
          if (!ee)
                 return -ENOMEM;
          ee->task = current;
          spin_lock(&execve_list_lock);
          list_add(&ee->list, &execve_list);
          spin_unlock(&execve_list_lock);
          return 0;
  }
  
  static bool tmy_in_execve(void)
  {
          struct task_struct *task = current;
          struct execve_entry *p;
          bool found = false;
          spin_lock(&execve_list_lock);
          list_for_each_entry(p, &execve_list, list) {
                  if (p->task != task)
                          continue;
                  found = true;
                  break;
          }
          spin_unlock(&execve_list_lock);
          return found;
  }
  
  static void tmy_finish_execve(void)
  {
          struct task_struct *task = current;
          struct execve_entry *p;
          struct execve_entry *ee = NULL;
          spin_lock(&execve_list_lock);
          list_for_each_entry(p, &execve_list, list) {
                  if (p->task != task)
                          continue;
                  list_del(&p->list);
                  ee = p;
                  break;
          }
          spin_unlock(&execve_list_lock);
          if (ee)
                 kfree(ee);
  }

and replace mutex_is_locked(&current->cred_exec_mutex) with tmy_in_execve().
To call tmy_start_execve() and tmy_finish_execve(),
I want security_start_execve() / security_finish_execve().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/compat.c              |    6 ++++++
 fs/exec.c                |    6 ++++++
 include/linux/security.h |   22 ++++++++++++++++++++++
 security/capability.c    |   11 +++++++++++
 security/security.c      |   10 ++++++++++
 5 files changed, 55 insertions(+)

--- linux-2.6.27-rc7-mm1.orig/fs/compat.c
+++ linux-2.6.27-rc7-mm1/fs/compat.c
@@ -1397,6 +1397,10 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out_free;
 
+	retval = security_start_execve();
+	if (retval < 0)
+		goto out_unlock;
+
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
@@ -1448,6 +1452,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	security_finish_execve();
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1464,6 +1469,7 @@ out_file:
 	}
 
 out_unlock:
+	security_finish_execve();
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.27-rc7-mm1.orig/fs/exec.c
+++ linux-2.6.27-rc7-mm1/fs/exec.c
@@ -1302,6 +1302,10 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out_free;
 
+	retval = security_start_execve();
+	if (retval < 0)
+		goto out_unlock;
+
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
@@ -1354,6 +1358,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	security_finish_execve();
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1372,6 +1377,7 @@ out_file:
 	}
 
 out_unlock:
+	security_finish_execve();
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.27-rc7-mm1.orig/include/linux/security.h
+++ linux-2.6.27-rc7-mm1/include/linux/security.h
@@ -192,6 +192,15 @@ static inline void security_free_mnt_opt
  *	on the initial stack to the ELF interpreter to indicate whether libc
  *	should enable secure mode.
  *	@bprm contains the linux_binprm structure.
+ * @start_execve:
+ *	Notify current process of an execve operation is about to start.
+ *	This is called immediately after obtaining current->cred_exec_mutex
+ *	mutex.
+ *	Return 0 if operation was successful.
+ * @finish_execve:
+ *	Notify current process of an execve operation is about to finish.
+ *	This is called immediately before releasing current->cred_exec_mutex
+ *	mutex.
  *
  * Security hooks for filesystem operations.
  *
@@ -1352,6 +1361,8 @@ struct security_operations {
 	int (*settime) (struct timespec *ts, struct timezone *tz);
 	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
+	int (*start_execve) (void);
+	void (*finish_execve) (void);
 	int (*bprm_set_creds) (struct linux_binprm *bprm);
 	int (*bprm_check_security) (struct linux_binprm *bprm);
 	int (*bprm_secureexec) (struct linux_binprm *bprm);
@@ -1632,6 +1643,8 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
+int security_start_execve(void);
+void security_finish_execve(void);
 int security_bprm_set_creds(struct linux_binprm *bprm);
 int security_bprm_check(struct linux_binprm *bprm);
 void security_bprm_committing_creds(struct linux_binprm *bprm);
@@ -1879,6 +1892,15 @@ static inline int security_vm_enough_mem
 	return cap_vm_enough_memory(mm, pages);
 }
 
+static inline int security_start_execve(void)
+{
+	return 0;
+}
+
+static inline void security_finish_execve(void)
+{
+}
+
 static inline int security_bprm_set_creds(struct linux_binprm *bprm)
 {
 	return cap_bprm_set_creds(bprm);
--- linux-2.6.27-rc7-mm1.orig/security/capability.c
+++ linux-2.6.27-rc7-mm1/security/capability.c
@@ -32,6 +32,15 @@ static int cap_quota_on(struct dentry *d
 	return 0;
 }
 
+static int cap_start_execve(void)
+{
+	return 0;
+}
+
+static void cap_finish_execve(void)
+{
+}
+
 static int cap_bprm_check_security (struct linux_binprm *bprm)
 {
 	return 0;
@@ -877,6 +886,8 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, syslog);
 	set_to_cap_if_null(ops, settime);
 	set_to_cap_if_null(ops, vm_enough_memory);
+	set_to_cap_if_null(ops, start_execve);
+	set_to_cap_if_null(ops, finish_execve);
 	set_to_cap_if_null(ops, bprm_set_creds);
 	set_to_cap_if_null(ops, bprm_committing_creds);
 	set_to_cap_if_null(ops, bprm_committed_creds);
--- linux-2.6.27-rc7-mm1.orig/security/security.c
+++ linux-2.6.27-rc7-mm1/security/security.c
@@ -199,6 +199,16 @@ int security_vm_enough_memory_mm(struct 
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
+int security_start_execve(void)
+{
+	return security_ops->start_execve();
+}
+
+void security_finish_execve(void)
+{
+	security_ops->finish_execve();
+}
+
 int security_bprm_set_creds(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_set_creds(bprm);
