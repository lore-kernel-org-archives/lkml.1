Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZK0XHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZK0XHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZK0XHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:07:40 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60485 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZK0XGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 24/27] core: implement getprlimit and setprlimit syscalls
Date: Sat, 28 Nov 2009 00:06:04 +0100
Message-Id: <1259363167-9347-24-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the code to support the sys_setprlimit and set_getprlimit
syscalls which modify the rlim values of a selected process.

All rlim users now either use newly added accessors or doesn't need them
due to
- locking
- a process was just forked and nobody else knows about it yet (and
  nobody can't thus read/write limits)

Based on Neil's work. Thank him.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h |    4 ++
 kernel/sys.c             |   86 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a990ace..6fd7ba6 100644
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
+asmlinkage long sys_setprlimit(pid_t pid, unsigned int resource,
+				struct rlimit __user *rlim);
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru);
 asmlinkage long sys_umask(int mask);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index c4065c5..626148f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1212,6 +1212,61 @@ SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	}
 }
 
+static int check_prlimit_permission(struct task_struct *task)
+{
+	const struct cred *cred = current_cred(), *tcred;
+	int ret = 0;
+
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if ((cred->uid != tcred->euid ||
+	     cred->uid != tcred->suid ||
+	     cred->uid != tcred->uid  ||
+	     cred->gid != tcred->egid ||
+	     cred->gid != tcred->sgid ||
+	     cred->gid != tcred->gid) &&
+	     !capable(CAP_SYS_RESOURCE)) {
+		ret = -EPERM;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+SYSCALL_DEFINE3(getprlimit, pid_t, pid, unsigned int, resource,
+		struct rlimit __user *, rlim)
+{
+	struct rlimit val;
+	struct task_struct *tsk;
+	int ret;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+
+	read_lock(&tasklist_lock);
+
+	tsk = find_task_by_vpid(pid);
+	if (!tsk || !tsk->sighand) {
+		ret = -ESRCH;
+		goto err_unlock;
+	}
+
+	ret = check_prlimit_permission(tsk);
+	if (ret)
+		goto err_unlock;
+
+	task_lock(tsk->group_leader);
+	val = tsk->signal->rlim[resource];
+	task_unlock(tsk->group_leader);
+
+	read_unlock(&tasklist_lock);
+
+	return copy_to_user(rlim, &val, sizeof(*rlim)) ? -EFAULT : 0;
+err_unlock:
+	read_unlock(&tasklist_lock);
+	return ret;
+}
+
+
 #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT
 
 /*
@@ -1310,6 +1365,37 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	return do_setrlimit(current, resource, &new_rlim);
 }
 
+SYSCALL_DEFINE3(setprlimit, pid_t, pid, unsigned int, resource,
+		struct rlimit __user *, rlim)
+{
+	struct task_struct *tsk;
+	struct rlimit new_rlim;
+	int ret;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	tsk = find_task_by_vpid(pid);
+	if (!tsk) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	get_task_struct(tsk);
+	rcu_read_unlock();
+
+	ret = check_prlimit_permission(tsk);
+	if (!ret)
+		ret = do_setrlimit(tsk, resource, &new_rlim);
+
+	put_task_struct(tsk);
+
+	return ret;
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
-- 
1.6.5.3

