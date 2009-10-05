Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZJEAyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZJEAyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZJEAyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:54:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42068 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZJEAyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:54:08 -0400
Date: Sun, 4 Oct 2009 20:53:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits
	external to a process (v4)
Message-ID: <20091005005321.GA7180@localhost.localdomain>
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

Augment /proc/<pid>/limits file to support limit setting

It was suggested to me recently that we support a mechanism by which we can set
various process limits from points external to the process.  The reasoning being
that some processes are very long lived, and it would be beneficial to these
long lived processes if we could modify their various limits without needing to
kill them, adjust the limits for the user and restarting them.  While individual
application can certainly export this control on their own, it would be nice if
such functionality were available to a sysadmin, without needing to have each
application re-invent the wheel.

As such, I've implemented the below patch, which makes /proc/pid/limits writable
for each process.  By writing the following format:
<limit> <current value> <max value>
to the limits file, an administrator can now dynamically change the limits for
the respective process.  Tested by myself with good results.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 fs/proc/base.c        |  183 +++++++++++++++++++++++++++++++++++++++++---------
 include/linux/sched.h |    3 
 kernel/sys.c          |   48 ++++++++-----
 3 files changed, 186 insertions(+), 48 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f742f6..631f01b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -49,6 +49,8 @@
 
 #include <asm/uaccess.h>
 
+#include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
@@ -455,72 +457,193 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 struct limit_names {
 	char *name;
 	char *unit;
+	char *match;
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
-	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
-	[RLIMIT_DATA] = {"Max data size", "bytes"},
-	[RLIMIT_STACK] = {"Max stack size", "bytes"},
-	[RLIMIT_CORE] = {"Max core file size", "bytes"},
-	[RLIMIT_RSS] = {"Max resident set", "bytes"},
-	[RLIMIT_NPROC] = {"Max processes", "processes"},
-	[RLIMIT_NOFILE] = {"Max open files", "files"},
-	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
-	[RLIMIT_AS] = {"Max address space", "bytes"},
-	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
-	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
-	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
-	[RLIMIT_NICE] = {"Max nice priority", NULL},
-	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
-	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_CPU] = {"Max cpu time", "ms", "cpu"},
+	[RLIMIT_FSIZE] = {"Max file size", "bytes", "fsize"},
+	[RLIMIT_DATA] = {"Max data size", "bytes", "data"},
+	[RLIMIT_STACK] = {"Max stack size", "bytes", "stack"},
+	[RLIMIT_CORE] = {"Max core file size", "bytes", "core"},
+	[RLIMIT_RSS] = {"Max resident set", "bytes", "rss"},
+	[RLIMIT_NPROC] = {"Max processes", "processes", "nproc"},
+	[RLIMIT_NOFILE] = {"Max open files", "files", "nofile"},
+	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes", "memlock"},
+	[RLIMIT_AS] = {"Max address space", "bytes", "as"},
+	[RLIMIT_LOCKS] = {"Max file locks", "locks", "locks"},
+	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals", "sigpending"},
+	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes", "msgqueue"},
+	[RLIMIT_NICE] = {"Max nice priority", NULL, "nice"},
+	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL, "rtprio"},
+	[RLIMIT_RTTIME] = {"Max realtime timeout", "us", "rttime"},
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static ssize_t proc_pid_limit_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
 {
 	unsigned int i;
-	int count = 0;
 	unsigned long flags;
-	char *bufptr = buffer;
+	char *bufptr;
+	size_t bcount = 0;
+	size_t ccount = -ENOMEM;
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
+	bufptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bufptr)
+		goto out;
+
+	ccount = -EBUSY;
+
 	if (!lock_task_sighand(task, &flags))
-		return 0;
+		goto out_free;
 	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
 	unlock_task_sighand(task, &flags);
 
 	/*
 	 * print the file header
 	 */
-	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+	bcount += sprintf(&bufptr[bcount], "%-25s %-20s %-20s %-10s\n",
 			"Limit", "Soft Limit", "Hard Limit", "Units");
 
 	for (i = 0; i < RLIM_NLIMITS; i++) {
 		if (rlim[i].rlim_cur == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-25s %-20s ",
+			bcount += sprintf(&bufptr[bcount], "%-25s %-20s ",
 					 lnames[i].name, "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+			bcount += sprintf(&bufptr[bcount], "%-25s %-20lu ",
 					 lnames[i].name, rlim[i].rlim_cur);
 
 		if (rlim[i].rlim_max == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+			bcount += sprintf(&bufptr[bcount], "%-20s ",
+					 "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-20lu ",
+			bcount += sprintf(&bufptr[bcount], "%-20lu ",
 					 rlim[i].rlim_max);
 
 		if (lnames[i].unit)
-			count += sprintf(&bufptr[count], "%-10s\n",
+			bcount += sprintf(&bufptr[bcount], "%-10s\n",
 					 lnames[i].unit);
 		else
-			count += sprintf(&bufptr[count], "\n");
+			bcount += sprintf(&bufptr[bcount], "\n");
 	}
 
-	return count;
+	ccount = -EMSGSIZE;
+
+	if (*ppos >= bcount)
+		goto out_task;
+
+	ccount = min(count, (size_t)(bcount-(*ppos)));
+	ccount = ccount - copy_to_user(buf, &bufptr[*ppos], ccount);
+	*ppos += ccount;
+
+out_task:
+	put_task_struct(task);
+out_free:
+	kfree(bufptr);
+out:
+	return ccount;
+}
+
+#define PROC_PID_BUF_SZ 128
+static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	char *buffer;
+	char *element, *vmc, *vmm;
+	struct rlimit new_rlim;
+	unsigned long flags;
+	int i;
+	int index = -1;
+	size_t wcount = -EMSGSIZE;
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+
+	if (*ppos != 0)
+		goto out;
+
+	if (count > PROC_PID_BUF_SZ)
+		goto out;
+
+	wcount = -ENOMEM;
+	buffer = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
+
+	if (!buffer)
+		goto out;
+
+	element = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
+	vmc = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
+	vmm = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
+
+	if (!element || !vmm || !vmc)
+		goto out_free;
+
+	wcount = -EFAULT;
+	if (copy_from_user(buffer, buf, count))
+		goto out_free;
+
+	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
+
+	if (i < 3)
+		goto out_free;
+
+	for (i = 0; i < strlen(element); i++)
+		element[i] = tolower(element[i]);
+
+	if (!strncmp(vmc, "unlimited", 9))
+		new_rlim.rlim_cur = RLIM_INFINITY;
+	else
+		new_rlim.rlim_cur = simple_strtoull(vmc, NULL, 10);
+
+	if (!strncmp(vmm, "unlimited", 9))
+		new_rlim.rlim_max = RLIM_INFINITY;
+	else
+		new_rlim.rlim_max = simple_strtoull(vmm, NULL, 10);
+
+
+	for (i = 0; i < RLIM_NLIMITS; i++) {
+		if ((lnames[i].match) &&
+		    !strncmp(element, lnames[i].match,
+		     strlen(lnames[i].match))) {
+			index = i;
+			break;
+		}
+	}
+
+	wcount = -EBUSY;
+
+	if (!lock_task_sighand(task, &flags))
+		goto out_free;
+
+	wcount = -ENOENT;
+
+	if ((index >= 0) && (index < RLIM_NLIMITS))
+		wcount = do_setrlimit(index, &new_rlim, task);
+
+	unlock_task_sighand(task, &flags);
+
+out_free:
+	kfree(element);
+	kfree(vmc);
+	kfree(vmm);
+	kfree(buffer);
+out:
+	if (!wcount) {
+		*ppos += count;
+		wcount = count;
+	}
+	put_task_struct(task);
+	return wcount;
 }
 
+
+static const struct file_operations proc_limit_operations = {
+	.read           = proc_pid_limit_read,
+	.write		= proc_pid_limit_write,
+};
+
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
@@ -2483,7 +2606,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	REG("limits",	  S_IRUSR|S_IWUSR, proc_limit_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2822,7 +2945,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	REG("limits",	 S_IRUSR|S_IWUSR, proc_limit_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..cada5d2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -631,6 +631,9 @@ struct signal_struct {
 #endif
 };
 
+extern int do_setrlimit(unsigned int resource, struct rlimit *new_rlim,
+			struct task_struct *tsk);
+
 /* Context switch must be unlocked if interrupts are to be enabled */
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 # define __ARCH_WANT_UNLOCKED_CTXSW
diff --git a/kernel/sys.c b/kernel/sys.c
index b3f1097..05bd22a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1236,41 +1236,41 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
-SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+int do_setrlimit(unsigned int resource, struct rlimit *new_rlim,
+		 struct task_struct *tsk)
 {
-	struct rlimit new_rlim, *old_rlim;
 	int retval;
+	struct rlimit *old_rlim;
 
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+
+	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	old_rlim = tsk->signal->rlim + resource;
+
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(resource, new_rlim);
 	if (retval)
 		return retval;
 
-	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
 		 * expiry.  But we use the zero value to mean "it was
 		 * never set".  So let's cheat and make it one second
 		 * instead
 		 */
-		new_rlim.rlim_cur = 1;
+		new_rlim->rlim_cur = 1;
 	}
 
-	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
-	task_unlock(current->group_leader);
+	task_lock(tsk->group_leader);
+	*old_rlim = *new_rlim;
+	task_unlock(tsk->group_leader);
 
 	if (resource != RLIMIT_CPU)
 		goto out;
@@ -1281,14 +1281,26 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(new_rlim->rlim_cur);
 out:
 	return 0;
 }
 
+SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+{
+	struct rlimit new_rlim;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+
+	return do_setrlimit(resource, &new_rlim, current);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
