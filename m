Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYBKVpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYBKVpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYBKVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:44:57 -0500
Received: from homer.mvista.com ([63.81.120.158]:55198 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbYBKVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:44:55 -0500
Message-ID: <47B0C1D4.5080808@ct.jp.nec.com>
Date: Mon, 11 Feb 2008 13:44:52 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [RFC PATCH] RTTIME watchdog timer proc interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I think an interface to access RLIMIT_RTTIME from outside is useful.
It makes administrator able to set RLIMIT_RTTIME watchdog to existing
real-time applications without impact.

I implemented that interface with /proc filesystem.

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce new proc interface for RTTIME watchdog.
It makes administrator able to set RTTIME watchdog to existing applications.

$ echo 10000000 > /proc/<pid>/rttime
set RTTIME current value to 10000000, it means 10sec.

$ echo "10000000 20000000" > /proc/<pid>/rttime
set RTTIME current value to 10000000 and max value to 20000000.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7c6b4ec..5689c0e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -381,6 +381,93 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
+static int rttime_show_proc(struct seq_file *m, void *v)
+{
+	struct task_struct *task = m->private;
+	struct signal_struct *signal = task->signal;
+	struct rlimit *rt = &signal->rlim[RLIMIT_RTTIME];
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
+	return 0;
+}
+
+static int rttime_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct seq_file *m;
+	struct task_struct *task = get_proc_task(inode);
+
+	ret = single_open(file, rttime_show_proc, NULL);
+	if (!ret) {
+		m = file->private_data;
+		m->private = task;
+	}
+	return ret;
+}
+
+static ssize_t rttime_write(struct file *file,
+			    const char __user *buf,
+			    size_t count,
+			    loff_t *ppos)
+{
+	struct seq_file *m = file->private_data;
+	struct task_struct *task = m->private;
+	char buffer[PROC_NUMBUF], *end;
+	struct rlimit new_rlim, *old_rlim;
+	int n, ret;
+
+	old_rlim = task->signal->rlim + RLIMIT_RTTIME;
+	new_rlim = *old_rlim;
+	memset(buffer, 0, sizeof(buffer));
+	n = count;
+	if (n > sizeof(buffer) - 1)
+		n = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, n))
+		return -EFAULT;
+	new_rlim.rlim_cur = simple_strtoul(buffer, &end, 0);
+	if (*end == ' ') {
+		++end;
+		buf += end - buffer;
+		memset(buffer, 0, sizeof(buffer));
+		n = count - (end - buffer);
+		if (n > sizeof(buffer) - 1)
+			n = sizeof(buffer) - 1;
+		if (copy_from_user(buffer, buf, n))
+			return -EFAULT;
+		new_rlim.rlim_max = simple_strtoul(buffer, &end, 0);
+	}
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
+	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	    !capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+	ret = security_task_setrlimit(RLIMIT_RTTIME, &new_rlim);
+	if (ret)
+		return ret;
+	task_lock(task->group_leader);
+	*old_rlim = new_rlim;
+	task_unlock(task->group_leader);
+
+	return count;
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
@@ -2300,6 +2387,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
+	REG("rttime",     S_IRUSR|S_IWUSR, rttime),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
-- 
1.5.3.8

