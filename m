Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbYDCWnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbYDCWnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYDCWne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:43:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:56914 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYDCWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:43:33 -0400
Message-ID: <47F55D8D.3060700@ct.jp.nec.com>
Date: Thu, 03 Apr 2008 15:43:25 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RESEND][RFC v3 PATCH] RTTIME watchdog timer proc interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce new proc interface for RTTIME watchdog.
It makes administrator able to set RTTIME watchdog to exisiting real-time
applications without impact. It's useful we don't want to change software
stack, but want to use RTTIME watchdog for that software.

New proc files:
 /proc/<pid>/rttime
 /proc/<pid>/task/<tid>/rttime
these files have same content.

$ cat /proc/<pid>/rttime
10000000 20000000
It shows current RLIMIT_RTTIME values, and the unit is nsec.
If the value is RLIM_INFINITY, it prints "unlimited".

$ echo "10000000" > /proc/<pid>/rttime
It sets RTTIME current value to 10000000.

$ echo "10000000 20000000" > /proc/<pid>/rttime
It sets RTTIME current value to 10000000 and max value to 20000000.

$ echo "0 0" > /proc/<pid>/rttime
It sets RTTIME values to unlimited.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 Update for 2.6.25-rc8

 fs/proc/base.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 81d7d14..07cbbae 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -376,6 +376,107 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
+static int rttime_show_proc(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
+	struct rlimit *rt;
+
+	if (!task)
+		return -ESRCH;
+
+	rt = &task->signal->rlim[RLIMIT_RTTIME];
+
+	if (rt->rlim_cur == RLIM_INFINITY)
+		seq_printf(m, "unlimited ");
+	else
+		seq_printf(m, "%lu ", rt->rlim_cur);
+
+	if (rt->rlim_max == RLIM_INFINITY)
+		seq_printf(m, "unlimited\n");
+	else
+		seq_printf(m, "%lu\n", rt->rlim_max);
+
+	put_task_struct(task);
+
+	return 0;
+}
+
+static int rttime_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rttime_show_proc, inode);
+}
+
+static ssize_t rttime_do_write(struct task_struct *task,
+			       const char __user *buf,
+			       size_t count)
+{
+	char buffer[PROC_NUMBUF], *end;
+	struct rlimit new_rlim, *old_rlim;
+	size_t bufsz;
+	int ret;
+
+	old_rlim = task->signal->rlim + RLIMIT_RTTIME;
+	new_rlim = *old_rlim;
+	memset(buffer, 0, sizeof(buffer));
+	bufsz = min(count, sizeof(buffer) - 1);
+	if (copy_from_user(buffer, buf, bufsz))
+		return -EFAULT;
+	new_rlim.rlim_cur = simple_strtoul(buffer, &end, 0);
+	if (end - buffer == 0)
+		return -EINVAL;
+	/* 0 means unlimited */
+	if (new_rlim.rlim_cur == 0)
+		new_rlim.rlim_cur = RLIM_INFINITY;
+	if (*end == ' ') {
+		++end;
+		buf += end - buffer;
+		memset(buffer, 0, sizeof(buffer));
+		bufsz = min(count - (end - buffer), sizeof(buffer) - 1);
+		if (copy_from_user(buffer, buf, bufsz))
+			return -EFAULT;
+		ret = strict_strtoul(buffer, 0, &new_rlim.rlim_max);
+		if (ret)
+			return ret;
+		/* 0 means unlimited */
+		if (new_rlim.rlim_max == 0)
+			new_rlim.rlim_max = RLIM_INFINITY;
+	}
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
+	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	    !__capable(task, CAP_SYS_RESOURCE))
+		return -EPERM;
+	task_lock(task->group_leader);
+	*old_rlim = new_rlim;
+	task_unlock(task->group_leader);
+
+	return count;
+}
+
+static ssize_t rttime_write(struct file *file,
+			    const char __user *buf,
+			    size_t count,
+			    loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	int ret;
+
+	if (!task)
+		return -ESRCH;
+	ret = rttime_do_write(task, buf, count);
+	put_task_struct(task);
+	return ret;
+}
+
+static const struct file_operations proc_rttime_operations = {
+	.open		= rttime_open,
+	.read		= seq_read,
+	.write		= rttime_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* The badness from the OOM killer */
 unsigned long badness(struct task_struct *p, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
@@ -2312,6 +2413,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
+	REG("rttime",     S_IRUSR|S_IWUSR, rttime),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
@@ -2643,6 +2745,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	LNK("root",      root),
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
+	REG("rttime",    S_IRUSR|S_IWUSR, rttime),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
-- 
1.5.4.1

