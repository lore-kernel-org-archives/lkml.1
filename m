Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZDAAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZDAAaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZDAAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:30:15 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51859 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZDAAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:30:13 -0400
Date: Wed, 1 Apr 2009 01:28:01 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090331061615.GS28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
References: <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk>
 <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com>
 <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk>
 <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com>
 <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils>
 <20090331061615.GS28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Al Viro wrote:
> 
> Anyway, I've got that stuff to something reasonably-looking.  See the
> same branch (rebased), just 5 changesets now.  Have fun.  Cleanups are
> not part of that set.

Just a couple of things on that:

Minor bisectability issue: the third patch, which introduces
int unshare_fs_struct(void), needs to return 0 when it succeeds:
that gets corrected in the fourth patch.

Lockdep objects to how check_unsafe_exec nests write_lock(&p->fs_lock)
inside lock_task_sighand(p, &flags).  It's right: we sometimes take
sighand->siglock in interrupt, so if such an interrupt occurred just
after you take fs_lock elsewhere, that could deadlock with this.  It
seems happy with taking fs_lock just outside the lock_task_sighand.

Otherwise it looks good to me, except I keep worrying about those
EAGAINs.  The more so once I noticed current->cred_exec_mutex is
already being used to handle a similar issue with ptrace.  What
do you think of this rather smaller patch?  which I'd much rather
send after having slept on it, since it may be embarrassingly and
obviously wrong, but tomorrow may be too late ...

 fs/compat.c               |    6 +++---
 fs/exec.c                 |    6 +++---
 fs/namei.c                |    1 +
 include/linux/fs_struct.h |    1 +
 include/linux/init_task.h |    2 --
 include/linux/sched.h     |    1 -
 kernel/cred.c             |    4 +---
 kernel/fork.c             |   13 +++++++++++--
 kernel/ptrace.c           |    4 ++--
 9 files changed, 22 insertions(+), 16 deletions(-)

--- 2.6.29-git8/fs/compat.c	2009-03-31 16:04:22.000000000 +0100
+++ linux/fs/compat.c	2009-04-01 00:52:26.000000000 +0100
@@ -1432,7 +1432,7 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&current->fs->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
 	current->in_execve = 1;
@@ -1489,7 +1489,7 @@ int compat_do_execve(char * filename,
 
 	/* execve succeeded */
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->fs->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1508,7 +1508,7 @@ out_file:
 
 out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->fs->cred_exec_mutex);
 
 out_free:
 	free_bprm(bprm);
--- 2.6.29-git8/fs/exec.c	2009-03-31 16:04:22.000000000 +0100
+++ linux/fs/exec.c	2009-04-01 00:52:26.000000000 +0100
@@ -1287,7 +1287,7 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&current->fs->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
 	current->in_execve = 1;
@@ -1345,7 +1345,7 @@ int do_execve(char * filename,
 
 	/* execve succeeded */
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->fs->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
@@ -1364,7 +1364,7 @@ out_file:
 
 out_unlock:
 	current->in_execve = 0;
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->fs->cred_exec_mutex);
 
 out_free:
 	free_bprm(bprm);
--- 2.6.29-git8/fs/namei.c	2009-03-31 16:04:23.000000000 +0100
+++ linux/fs/namei.c	2009-04-01 00:52:26.000000000 +0100
@@ -2903,4 +2903,5 @@ struct fs_struct init_fs = {
 	.count		= ATOMIC_INIT(1),
 	.lock		= __RW_LOCK_UNLOCKED(init_fs.lock),
 	.umask		= 0022,
+	.cred_exec_mutex = __MUTEX_INITIALIZER(init_fs.cred_exec_mutex),
 };
--- 2.6.29-git8/include/linux/fs_struct.h	2009-03-31 16:04:24.000000000 +0100
+++ linux/include/linux/fs_struct.h	2009-04-01 00:52:26.000000000 +0100
@@ -11,6 +11,7 @@ struct fs_struct {
 	rwlock_t lock;
 	int umask;
 	struct path root, pwd;
+	struct mutex cred_exec_mutex;	/* execve cred calculation mutex */
 };
 
 extern struct kmem_cache *fs_cachep;
--- 2.6.29-git8/include/linux/init_task.h	2009-03-31 16:04:24.000000000 +0100
+++ linux/include/linux/init_task.h	2009-04-01 00:52:26.000000000 +0100
@@ -157,8 +157,6 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	.real_cred	= &init_cred,					\
 	.cred		= &init_cred,					\
-	.cred_exec_mutex =						\
-		 __MUTEX_INITIALIZER(tsk.cred_exec_mutex),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
--- 2.6.29-git8/include/linux/sched.h	2009-03-31 16:04:25.000000000 +0100
+++ linux/include/linux/sched.h	2009-04-01 00:52:26.000000000 +0100
@@ -1250,7 +1250,6 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct mutex cred_exec_mutex;	/* execve vs ptrace cred calculation mutex */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
--- 2.6.29-git8/kernel/cred.c	2009-03-23 23:12:14.000000000 +0000
+++ linux/kernel/cred.c	2009-04-01 00:52:26.000000000 +0100
@@ -167,7 +167,7 @@ EXPORT_SYMBOL(prepare_creds);
 
 /*
  * Prepare credentials for current to perform an execve()
- * - The caller must hold current->cred_exec_mutex
+ * - The caller must hold current->fs->cred_exec_mutex
  */
 struct cred *prepare_exec_creds(void)
 {
@@ -276,8 +276,6 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
-	mutex_init(&p->cred_exec_mutex);
-
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
--- 2.6.29-git8/kernel/fork.c	2009-03-31 16:04:26.000000000 +0100
+++ linux/kernel/fork.c	2009-04-01 00:52:26.000000000 +0100
@@ -695,6 +695,7 @@ static struct fs_struct *__copy_fs_struc
 		fs->pwd = old->pwd;
 		path_get(&old->pwd);
 		read_unlock(&old->lock);
+		mutex_init(&fs->cred_exec_mutex);
 	}
 	return fs;
 }
@@ -708,11 +709,19 @@ EXPORT_SYMBOL_GPL(copy_fs_struct);
 
 static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 {
+	struct fs_struct *fs = current->fs;
+
 	if (clone_flags & CLONE_FS) {
-		atomic_inc(&current->fs->count);
+		int retval = mutex_lock_interruptible(&fs->cred_exec_mutex);
+		if (retval < 0)
+			return retval;
+		/* tsk->fs is already what we want */
+		atomic_inc(&fs->count);
+		mutex_unlock(&fs->cred_exec_mutex);
 		return 0;
 	}
-	tsk->fs = __copy_fs_struct(current->fs);
+
+	tsk->fs = __copy_fs_struct(fs);
 	if (!tsk->fs)
 		return -ENOMEM;
 	return 0;
--- 2.6.29-git8/kernel/ptrace.c	2009-03-23 23:12:14.000000000 +0000
+++ linux/kernel/ptrace.c	2009-04-01 00:52:26.000000000 +0100
@@ -186,7 +186,7 @@ int ptrace_attach(struct task_struct *ta
 	/* Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&current->fs->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
 
@@ -230,7 +230,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&current->fs->cred_exec_mutex);
 out:
 	return retval;
 }
