Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZJEAyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZJEAyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZJEAyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:54:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42072 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbZJEAyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:54:49 -0400
Date: Sun, 4 Oct 2009 20:54:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 2/3] extend get/setrlimit to support setting rlimits
	external to a process (v4)
Message-ID: <20091005005405.GB7180@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091005002617.GA5736@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005002617.GA5736@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.5 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add syscall infrastructure for getprlimit/setprlimit

This patch adds the definitions for the get/setprlimit syscalls.  They are
identical to the get/setlimit calls, except that they allow the caller to
manipulate limits for processes other than themselves.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 include/linux/syscalls.h |    4 ++
 kernel/sys.c             |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 80de700..535210a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -584,11 +584,15 @@ asmlinkage long sys_newuname(struct new_utsname __user *name);
 
 asmlinkage long sys_getrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
+asmlinkage long sys_getprlimit(pid_t pid, unsigned int resource,
+				struct rlimit __user *rlim);
 #if defined(COMPAT_RLIM_OLD_INFINITY) || !(defined(CONFIG_IA64))
 asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *rlim);
 #endif
 asmlinkage long sys_setrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
+asmlinkage long	sys_setprlimit(pid_t pid, unsigned int resource,
+				struct rlimit __user *rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
 asmlinkage long sys_umask(int mask);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 05bd22a..4fe1140 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1211,6 +1211,50 @@ SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	}
 }
 
+SYSCALL_DEFINE3(getprlimit, pid_t, pid, unsigned int, resource,
+		struct rlimit __user *, rlim)
+{
+	unsigned long flags;
+	struct task_struct *tsk;
+	struct pid *ppid;
+	int retval = -EINVAL;
+
+	ppid = find_get_pid(pid);
+	if (!ppid)
+		goto out;
+
+	tsk = get_pid_task(ppid, PIDTYPE_PID);
+
+	if (!tsk)
+		goto out_put_pid;
+
+	if (resource >= RLIM_NLIMITS)
+		goto out_put_all;
+
+	retval = -EBUSY;
+	if (!lock_task_sighand(tsk, &flags))
+		goto out_put_all;
+
+	else {
+		struct rlimit val;
+
+		task_lock(tsk->group_leader);
+		val = current->signal->rlim[resource];
+		task_unlock(tsk->group_leader);
+		retval = copy_to_user(rlim, &val, sizeof(*rlim)) ? -EFAULT : 0;
+	}
+
+	unlock_task_sighand(tsk, &flags);
+
+out_put_all:
+	put_task_struct(tsk);
+out_put_pid:
+	put_pid(ppid);
+out:
+	return retval;
+}
+
+
 #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT
 
 /*
@@ -1301,6 +1345,46 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	return do_setrlimit(resource, &new_rlim, current);
 }
 
+SYSCALL_DEFINE3(setprlimit, pid_t, pid, unsigned int, resource,
+		struct rlimit __user *, rlim)
+{
+	struct task_struct *tsk;
+	struct pid *ppid;
+	unsigned long flags;
+	struct rlimit new_rlim;
+	int retval = -EINVAL;
+
+	ppid = find_get_pid(pid);
+	if (!ppid)
+		goto out;
+
+	tsk = get_pid_task(ppid, PIDTYPE_PID);
+
+	if (!tsk)
+		goto out_put_pid;
+
+	if (resource >= RLIM_NLIMITS)
+		goto out_put_all;
+
+	retval = -EFAULT;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		goto out_put_all;
+
+	if (!lock_task_sighand(tsk, &flags))
+		goto out_put_all;
+
+	retval = do_setrlimit(resource, &new_rlim, tsk);
+
+	unlock_task_sighand(tsk, &flags);
+
+out_put_all:
+	put_task_struct(tsk);
+out_put_pid:
+	put_pid(ppid);
+out:
+	return retval;
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
