Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbXKSWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbXKSWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXKSWF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:05:59 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47466 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbXKSWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:05:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/4] proc: Implement proc_single_file_operations
References: <20071117183109.GA2605@tv-sign.ru>
	<m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
Date: Mon, 19 Nov 2007 15:04:46 -0700
In-Reply-To: <m1abp9vqua.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Mon, 19 Nov 2007 14:59:57 -0700")
Message-ID: <m163zxvqm9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently many /proc/pid files use a crufty precursor to
the current seq_file api, and they don't have direct access
to the pid_namespace or the pid of for which they are displaying
data.

So implement proc_single_file_operations to make the seq_file
routines easy to use, and to give access to the full state of the
pid of we are displaying data for.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c          |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a17c268..e9ff77e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -125,6 +125,10 @@ struct pid_entry {
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
+#define ONE(NAME, MODE, OTYPE)				\
+	NOD(NAME, (S_IFREG|(MODE)), 			\
+		NULL, &proc_single_file_operations,	\
+		{ .proc_show = &proc_##OTYPE } )
 
 int maps_protect;
 EXPORT_SYMBOL(maps_protect);
@@ -571,6 +575,45 @@ static const struct file_operations proc_info_file_operations = {
 	.read		= proc_info_read,
 };
 
+static int proc_single_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct pid_namespace *ns;
+	struct pid *pid;
+	struct task_struct *task;
+	int ret;
+
+	ns = inode->i_sb->s_fs_info;
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return -ESRCH;
+
+	ret = PROC_I(inode)->op.proc_show(m, ns, pid, task);
+
+	put_task_struct(task);
+	return ret;
+}
+
+static int proc_single_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	ret = single_open(filp, proc_single_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_single_file_operations = {
+	.open		= proc_single_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 1273c6e..69307c9 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -257,6 +257,9 @@ extern void kclist_add(struct kcore_list *, void *, size_t);
 union proc_op {
 	int (*proc_get_link)(struct inode *, struct dentry **, struct vfsmount **);
 	int (*proc_read)(struct task_struct *task, char *page);
+	int (*proc_show)(struct seq_file *m,
+		struct pid_namespace *ns, struct pid *pid,
+		struct task_struct *task);
 };
 
 struct proc_inode {
-- 
1.5.3.rc6.17.g1911

