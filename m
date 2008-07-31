Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYGaWvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYGaWvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbYGaWuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353AbYGaWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fw5YzePVTpncGu4HVzOiAKcYu3n+MR5FzD5DKqU3OWyDB/DfVOiqm9VySV0RGb24py
         YYqBcWdQgSMg+NKk0VsgkDT69miGTby7NTWhbk77H0ky5hGuyD8fRKEekH52SVzmQckM
         TmbIyBu5FgXOYI0JqPG/jrGqSqNHpqZpjQOhg=
From: Andrea Righi <righi.andrea@gmail.com>
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com
Cc: Matt Heaton <matt@bluehost.com>, Mark Seger <Mark.Seger@hp.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 3/4] kernel->userspace interface
Date: Fri,  1 Aug 2008 00:49:58 +0200
Message-Id: <1217544599-8935-4-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interface to export per task/thread/block device i/o statistics to userspace
applications.

Also simplify do_io_accounting() using seq_printf() to export aggregate i/o
statistics.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/proc/base.c |  178 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 167 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01ed610..c77d501 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -66,6 +66,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
 #include <linux/resource.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/security.h>
@@ -2401,7 +2402,8 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 }
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
+static void do_io_accounting(struct task_struct *task,
+				struct seq_file *m, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
@@ -2409,14 +2411,13 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
-		task_io_accounting_add(&acct, &task->signal->ioac);
+		task_io_account_add(&acct, &task->signal->ioac);
 		while_each_thread(task, t)
-			task_io_accounting_add(&acct, &t->ioac);
+			task_io_account_add(&acct, &t->ioac);
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
-			"rchar: %llu\n"
+	seq_printf(m, "rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
 			"syscw: %llu\n"
@@ -2429,17 +2430,166 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			acct.cancelled_write_bytes);
 }
 
-static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+static int tid_io_accounting_show(struct seq_file *m, void *v)
 {
-	return do_io_accounting(task, buffer, 0);
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	do_io_accounting(task, m, 0);
+	put_task_struct(task);
+	return 0;
 }
 
-static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
+static int tgid_io_accounting_show(struct seq_file *m, void *v)
 {
-	return do_io_accounting(task, buffer, 1);
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	do_io_accounting(task, m, 1);
+	put_task_struct(task);
+	return 0;
 }
+
+static int tid_io_accounting_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tid_io_accounting_show, inode);
+}
+
+static int tgid_io_accounting_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tgid_io_accounting_show, inode);
+}
+
+static const struct file_operations proc_tid_io_accounting_operations = {
+	.open		= tid_io_accounting_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations proc_tgid_io_accounting_operations = {
+	.open		= tgid_io_accounting_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+
+#define TASK_IO_ACCT_TID_STAT	0
+#define TASK_IO_ACCT_SIG_STAT	1
+
+static void seq_printf_io_acct_dev(struct seq_file *m, struct pid_namespace *ns,
+			struct task_struct *task, int type,
+			struct task_io_acct_node *io)
+{
+	pid_t tid = task_pid_nr_ns(task, ns);
+
+	seq_printf(m, "%d %c %d,%d %llu %llu %llu\n",
+		tid, type ? 'c' : 't', MAJOR(io->dev), MINOR(io->dev),
+		io->read_bytes, io->write_bytes, io->cancelled_write_bytes);
+}
+
+/* Note: called with task->ioac.lock held */
+static void show_dev_io_accounting_single(struct pid_namespace *ns,
+				struct task_struct *task, struct seq_file *m)
+{
+	struct rb_node *n;
+
+	for (n = rb_first(&task->ioac.tree); n; n = rb_next(n)) {
+		struct task_io_acct_node *io = rb_entry(n,
+				struct task_io_acct_node, node);
+		seq_printf_io_acct_dev(m, ns, task,
+					TASK_IO_ACCT_TID_STAT, io);
+	}
+}
+
+static void show_dev_io_accounting_whole(struct pid_namespace *ns,
+				struct task_struct *task, struct seq_file *m)
+{
+	struct rb_node *n;
+	struct task_struct *t = task;
+	struct signal_struct *sig = task->signal;
+	unsigned long flags;
+
+	if (!lock_task_sighand(task, &flags))
+		return;
+	do {
+		spin_lock(&t->ioac.lock);
+		show_dev_io_accounting_single(ns, t, m);
+		spin_unlock(&t->ioac.lock);
+	} while_each_thread(task, t);
+
+	/* no need to lock sig->ioac.lock here, just use lock_task_sighand() */
+	for (n = rb_first(&sig->ioac.tree); n; n = rb_next(n)) {
+		struct task_io_acct_node *io = rb_entry(n,
+					struct task_io_acct_node, node);
+		seq_printf_io_acct_dev(m, ns, task,
+					TASK_IO_ACCT_SIG_STAT, io);
+	}
+	unlock_task_sighand(task, &flags);
+}
+
+static int bdev_tid_io_accounting_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	spin_lock_irq(&task->ioac.lock);
+	show_dev_io_accounting_single(ns, task, m);
+	spin_unlock_irq(&task->ioac.lock);
+
+	put_task_struct(task);
+	return 0;
+}
+
+static int bdev_tgid_io_accounting_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	show_dev_io_accounting_whole(ns, task, m);
+
+	put_task_struct(task);
+	return 0;
+}
+
+static int bdev_tid_io_accounting_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bdev_tid_io_accounting_show, inode);
+}
+
+static int bdev_tgid_io_accounting_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bdev_tgid_io_accounting_show, inode);
+}
+
+static const struct file_operations proc_bdev_tid_io_accounting_operations = {
+	.open		= bdev_tid_io_accounting_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations proc_bdev_tgid_io_accounting_operations = {
+	.open		= bdev_tgid_io_accounting_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif /* CONFIG_TASK_IO_ACCOUNTING_BDEV */
+
 /*
  * Thread groups
  */
@@ -2513,7 +2663,10 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, tgid_io_accounting),
+	REG("io",	S_IRUGO, tgid_io_accounting),
+#endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+	REG("blockio",	S_IRUGO, bdev_tgid_io_accounting),
 #endif
 };
 
@@ -2844,7 +2997,10 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, tid_io_accounting),
+	REG("io",	S_IRUGO, tid_io_accounting),
+#endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING_BDEV
+	REG("blockio",	S_IRUGO, bdev_tid_io_accounting),
 #endif
 };
 
-- 
1.5.4.3

