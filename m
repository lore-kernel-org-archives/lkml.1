Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbZJTAyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbZJTAyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZJTAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:54:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50779 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbZJTAyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:54:16 -0400
Date: Mon, 19 Oct 2009 20:54:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 2/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091020005412.GC8886@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020005214.GA8886@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Implement sys_getprlimit and sys_setprlimit syscalls
    
    This patch adds the code to support hte sys_setprlimit and set_getprlimit
    syscalls which modify the rlim values of a selected process
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 include/linux/syscalls.h |    4 ++
 kernel/sys.c             |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a990ace..9f357ab 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -702,11 +702,15 @@ asmlinkage long sys_newuname(struct new_utsname __user *name);
 
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
index 0e210a4..6ca9e7f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1213,6 +1213,50 @@ SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
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
@@ -1303,6 +1347,46 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
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
