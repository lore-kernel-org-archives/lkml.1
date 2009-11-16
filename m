Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZKPVLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZKPVLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZKPVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:11:17 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37165 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZKPVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:11:15 -0500
Subject: [PATCH] Allow threads to rename siblings via
 /proc/pid/tasks/tid/comm
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <87aayy6j8b.fsf@basil.nowhere.org>
References: <1256347303.5059.26.camel@localhost.localdomain>
	 <1257557918.3298.21.camel@localhost.localdomain>
	 <87aayy6j8b.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 16 Nov 2009 13:11:07 -0800
Message-Id: <1258405867.10576.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,
	So far I've not had any objections to this version of the patch, so I
wanted to resend this for consideration for inclusion in -mm.

Thanks to Andi and Arjan for catching and suggesting a fix to the safe
lockless string write issue.

thanks
-john


Setting a thread's comm to be something unique is a very useful ability
and is helpful for debugging complicated threaded applications. However
currently the only way to set a thread name is for the thread to name
itself via the PR_SET_NAME prctl.

However, there may be situations where it would be advantageous for a
thread dispatcher to be naming the threads its managing, rather then
having the threads self-describe themselves. This sort of behavior is
available on other systems via the pthread_setname_np() interface.

This patch exports a task's comm via proc/pid/comm and
proc/pid/task/tid/comm interfaces, and allows thread siblings to write
to these values.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/fs/exec.c b/fs/exec.c
index d49be6b..90003f8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -926,6 +926,15 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
+
+	/*
+	 * Threads may access current->comm without holding
+	 * the task lock, so write the string carefully.
+	 * Readers without a lock may see incomplete new
+	 * names but are safe from non-terminating string reads.
+	 */
+	memset(tsk->comm, 0, TASK_COMM_LEN);
+	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 837469a..7f59af1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1265,6 +1265,78 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
+
+
+static ssize_t
+comm_write(struct file *file, const char __user *buf,
+	    size_t count, loff_t *offset)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_struct *p;
+	char buffer[TASK_COMM_LEN];
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	if (same_thread_group(current, p))
+		set_task_comm(p, buffer);
+	else
+		count = -EINVAL;
+
+	put_task_struct(p);
+
+	return count;
+}
+
+
+static int comm_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	task_lock(p);
+	seq_printf(m, "%s\n", p->comm);
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static int comm_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, comm_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+
+static const struct file_operations proc_pid_set_comm_operations = {
+	.open		= comm_open,
+	.read		= seq_read,
+	.write		= comm_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
@@ -2504,6 +2576,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
@@ -2839,6 +2912,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif


