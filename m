Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZIDNqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZIDNqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZIDNqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZIDNqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:46:01 -0400
Date: Fri, 4 Sep 2009 15:39:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090904133956.GA9232@redhat.com>
References: <20090903160514.GA23646@redhat.com> <20090903200924.E46DF47C94@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903200924.E46DF47C94@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Roland McGrath wrote:
>
> The paired calls that leave the mutex locked in between should have some
> clear comments calling attention to their pairing.

Agreed. Please see the same patch + some comments below.

------------------------------------------------------------------------------
[PATCH] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex

Tom Horsley reports that his debugger hangs when it tries to read
/proc/pid_of_tracee/maps, this happens since

	"mm_for_maps: take ->cred_guard_mutex to fix the race with exec"
	04b836cbf19e885f8366bccb2e4b0474346c02d

commit in 2.6.31.

But I strongly believe we should blame another patch

	"CRED: Make execve() take advantage of copy-on-write credentials"
	a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d

The tracee must not sleep in TASK_TRACED holding this mutex (it was named
cred_exec_mutex). Even if we remove ->cred_guard_mutex from mm_for_maps()
and proc_pid_attr_write(), another task doing PTRACE_ATTACH should not
hang until it is killed or the tracee resumes.

With this patch do_execve() does not use ->cred_guard_mutex directly and
we do not hold it throughout, instead:

	- introduce prepare_bprm_creds() helper, it locks the mutex
	  and calls prepare_exec_creds() to initialize bprm->cred.

	- install_exec_creds() drops the mutex after commit_creds(),
	  and thus before tracehook_report_exec()->ptrace_stop().

	  or, if exec fails,

	  free_bprm() drops this mutex when bprm->cred != NULL which
	  indicates install_exec_creds() was not called.

Reported-by: Tom Horsley <tom.horsley@att.net>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---


--- WAIT/include/linux/binfmts.h~CRED_MUTEX_EEEVENT_EXEC	2009-07-24 19:02:19.000000000 +0200
+++ WAIT/include/linux/binfmts.h	2009-09-03 17:37:04.000000000 +0200
@@ -117,9 +117,10 @@ extern int setup_arg_pages(struct linux_
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
-extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
 extern void set_binfmt(struct linux_binfmt *new);
+extern int  prepare_bprm_creds(struct linux_binprm *bprm);
+extern void install_exec_creds(struct linux_binprm *bprm);
 extern void free_bprm(struct linux_binprm *);
 
 #endif /* __KERNEL__ */
--- WAIT/fs/exec.c~CRED_MUTEX_EEEVENT_EXEC	2009-09-03 15:31:08.000000000 +0200
+++ WAIT/fs/exec.c	2009-09-04 15:35:52.000000000 +0200
@@ -1018,6 +1018,35 @@ out:
 EXPORT_SYMBOL(flush_old_exec);
 
 /*
+ * Prepare credentials and lock ->cred_guard_mutex.
+ * install_exec_creds() commits the new creds and drops the lock.
+ * Or, if exec fails before, free_bprm() should release ->cred and
+ * and unlock.
+ */
+int prepare_bprm_creds(struct linux_binprm *bprm)
+{
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	bprm->cred = prepare_exec_creds();
+	if (likely(bprm->cred))
+		return 0;
+
+	mutex_unlock(&current->cred_guard_mutex);
+	return -ENOMEM;
+}
+
+void free_bprm(struct linux_binprm *bprm)
+{
+	free_arg_pages(bprm);
+	if (bprm->cred) {
+		mutex_unlock(&current->cred_guard_mutex);
+		abort_creds(bprm->cred);
+	}
+	kfree(bprm);
+}
+
+/*
  * install the new credentials for this executable
  */
 void install_exec_creds(struct linux_binprm *bprm)
@@ -1026,12 +1055,9 @@ void install_exec_creds(struct linux_bin
 
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
-
-	/* cred_guard_mutex must be held at least to this point to prevent
-	 * ptrace_attach() from altering our determination of the task's
-	 * credentials; any time after this it may be unlocked */
-
 	security_bprm_committed_creds(bprm);
+
+	mutex_unlock(&current->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
@@ -1248,14 +1274,6 @@ int search_binary_handler(struct linux_b
 
 EXPORT_SYMBOL(search_binary_handler);
 
-void free_bprm(struct linux_binprm *bprm)
-{
-	free_arg_pages(bprm);
-	if (bprm->cred)
-		abort_creds(bprm->cred);
-	kfree(bprm);
-}
-
 /*
  * sys_execve() executes a new program.
  */
@@ -1279,20 +1297,15 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	retval = prepare_bprm_creds(bprm);
+	if (retval)
 		goto out_free;
-	current->in_execve = 1;
-
-	retval = -ENOMEM;
-	bprm->cred = prepare_exec_creds();
-	if (!bprm->cred)
-		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
 	if (retval < 0)
-		goto out_unlock;
+		goto out_free;
 	clear_in_exec = retval;
+	current->in_execve = 1;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1342,7 +1355,6 @@ int do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1362,10 +1374,7 @@ out_file:
 out_unmark:
 	if (clear_in_exec)
 		current->fs->in_exec = 0;
-
-out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);
--- WAIT/fs/compat.c~CRED_MUTEX_EEEVENT_EXEC	2009-09-03 15:31:08.000000000 +0200
+++ WAIT/fs/compat.c	2009-09-03 16:42:17.000000000 +0200
@@ -1486,20 +1486,15 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	retval = prepare_bprm_creds(bprm);
+	if (retval)
 		goto out_free;
-	current->in_execve = 1;
-
-	retval = -ENOMEM;
-	bprm->cred = prepare_exec_creds();
-	if (!bprm->cred)
-		goto out_unlock;
 
 	retval = check_unsafe_exec(bprm);
 	if (retval < 0)
-		goto out_unlock;
+		goto out_free;
 	clear_in_exec = retval;
+	current->in_execve = 1;
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
@@ -1548,7 +1543,6 @@ int compat_do_execve(char * filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1568,10 +1562,7 @@ out_file:
 out_unmark:
 	if (clear_in_exec)
 		current->fs->in_exec = 0;
-
-out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_guard_mutex);
 
 out_free:
 	free_bprm(bprm);

