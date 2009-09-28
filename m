Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZI1UGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZI1UGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZI1UGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:06:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46732 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZI1UGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:06:08 -0400
Date: Mon, 28 Sep 2009 16:06:00 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com
Subject: [PATCH] proc: augment /proc/pid/limits to allow setting of process
	limits.
Message-ID: <20090928200600.GA3053@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.4 (----)
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


 base.c |  167 +++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 138 insertions(+), 29 deletions(-)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f742f6..cdf6748 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -49,6 +49,8 @@
 
 #include <asm/uaccess.h>
 
+#include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/time.h>
 #include <linux/proc_fs.h>
@@ -455,72 +457,179 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
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
+	size_t ccount = 0;
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
+	bufptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bufptr)
+		goto out;
+
 	if (!lock_task_sighand(task, &flags))
-		return 0;
+		goto out;
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
 
+	if (*ppos >= bcount)
+		goto out_task;
+
+	ccount = min(count, (size_t)(bcount-(*ppos)));
+	ccount = ccount - copy_to_user(buf, &bufptr[*ppos], ccount);
+	*ppos += ccount;
+	kfree(bufptr);
+out_task:
+	put_task_struct(task);
+out:
+	return ccount;
+}
+
+static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	char *buffer;
+	char *element, *vmc, *vmm;
+	unsigned long long valuec, valuem;
+	unsigned long flags;
+	int i;
+	int index = -1;
+	size_t wcount = 0;
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+
+
+	if (*ppos != 0)
+		goto out;
+
+	if (count > 128)
+		goto out;
+	buffer = kzalloc(128, GFP_KERNEL);
+
+	if (!buffer)
+		goto out;
+
+	element = kzalloc(sizeof(buffer), GFP_KERNEL);
+	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
+	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);
+
+	if (!element || !vmm || !vmc)
+		goto out_free;
+
+	wcount = count - copy_from_user(buffer, buf, count);
+	if (wcount < count)
+		goto out_free;
+
+	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
+
+	if (i < 3)
+		goto out_free;
+
+	for (i = 0; i <= strlen(element); i++)
+		element[i] = tolower(element[i]);
+
+	if (!strncmp(vmc, "unlimited", 9))
+		valuec = RLIM_INFINITY;
+	else
+		valuec = simple_strtoull(vmc, NULL, 10);
+
+	if (!strncmp(vmm, "unlimited", 9))
+		valuem = RLIM_INFINITY;
+	else
+		valuem = simple_strtoull(vmm, NULL, 10);
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
+	if (!lock_task_sighand(task, &flags))
+		goto out_free;
+
+	if (index >= 0) {
+		task->signal->rlim[index].rlim_cur = valuec;
+		task->signal->rlim[index].rlim_max = valuem;
+	}
+
+	unlock_task_sighand(task, &flags);
+
+out_free:
+	kfree(element);
+	kfree(vmc);
+	kfree(vmm);
+	kfree(buffer);
+out:
+	*ppos += count;
+	put_task_struct(task);
 	return count;
 }
 
+
+static const struct file_operations proc_limit_operations = {
+        .read           = proc_pid_limit_read,
+	.write		= proc_pid_limit_write,
+};
+
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
@@ -2483,7 +2592,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	REG("limits",	  S_IRUSR|S_IWUSR, proc_limit_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2822,7 +2931,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	REG("limits",	 S_IRUSR|S_IWUSR, proc_limit_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
