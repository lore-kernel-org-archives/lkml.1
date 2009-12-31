Return-Path: <linux-kernel-owner+w=401wt.eu-S1751660AbZLaVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbZLaVBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 16:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLaVBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 16:01:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:47986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZLaVBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 16:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="228221990"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>
Date: Thu, 31 Dec 2009 13:01:49 -0800
Subject: [PATCH] proc: Get/set timer slack through /proc
Thread-Topic: [PATCH] proc: Get/set timer slack through /proc
Thread-Index: AcqKXHhtfRu+nQSNRImj44DOWYbF2A==
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1D19@orsmsx510.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Get/set timer_slack_ns through /proc

This patch makes the timer_slack_ns parameter accessible through the /proc system.

On 9/1/2008, arjan@linux.intel.com submitted a patch to allow a process to set the timer slack value as part of the range timers feature.  Further, he noted that "Applications and admins can override this [the timer slack value] via the prctl()."

We have found this feature useful in attempting to reduce system wakeups caused by timer interrupts.  But we have also found that while applications can set their own timer slack value, there is no provision for setting the timer slack for another process -- prctl() only operates on the current process.  

This patch solves the problem by adding a /proc entry point to show and set the timer_slack_ns value.  The new entry point is /proc/<procid>/task/<task_id>/timer_slack_ns and follows the same semantics as other single-valued /proc entry points.

Signed-off-by:  Geoff Smith <geoffx.smith@intel.com>


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 18d5cc6..e8183c1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1331,6 +1331,82 @@ static const struct file_operations proc_pid_set_comm_operations = {
 	.release	= single_release,
 };
 
+
+/*
+ * Show timer slack value
+ */
+static int timer_slack_ns_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+	task_lock(p);
+	seq_printf(m, "%lu", p->timer_slack_ns);
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static ssize_t
+timer_slack_ns_write(struct file *file, const char __user *buf,
+	    size_t count, loff_t *offset)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_struct *p;
+	char buff[30];
+	unsigned long timer_slack_ns;
+	int err;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	if (count > sizeof(buff))
+		return -EFAULT;
+
+	buff[sizeof(buff)-1] = 0;
+	if (strncpy_from_user(buff, buf, sizeof(buff)-1) < 0)
+		return -EFAULT;
+
+	err = strict_strtoul(strstrip(buff), 0, &timer_slack_ns);
+	if (err)
+		return -EINVAL;
+
+	task_lock(p);
+	p->timer_slack_ns = timer_slack_ns;
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return count;
+}
+
+static int timer_slack_ns_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, timer_slack_ns_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_pid_timer_slack_ns_operations = {
+	.open		= timer_slack_ns_open,
+	.read		= seq_read,
+	.write		= timer_slack_ns_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
@@ -2906,6 +2982,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
+	REG("timer_slack_ns", S_IRUGO|S_IWUSR, proc_pid_timer_slack_ns_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif

