Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXKAEmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXKAEmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXKAEla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:41:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46630 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbXKAEl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:41:27 -0400
Message-Id: <20071101044124.835937000@us.ibm.com>
References: <20071101033508.720885000@us.ibm.com>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 20:35:11 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC][PATCH 3/3] [RFC][PATCH] Make /proc/pid/exe symlink changeable
Content-Disposition: inline; filename=writeable_proc_pid_exe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the /proc/<pid>|self/exe symlink writeable. This
functionality could be useful to potential checkpoint/restart implementations
restarting Java VMs, for example. Java uses this symlink to locate 
JAVAHOME so any restarted Java program requires that /proc/self/exe points to
the jvm and not the restart exectuable.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
---
 fs/proc/base.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6.23/fs/proc/base.c
===================================================================
--- linux-2.6.23.orig/fs/proc/base.c
+++ linux-2.6.23/fs/proc/base.c
@@ -930,10 +930,37 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
 #endif
 
+static int proc_pid_exe_symlink(struct inode *inode, struct dentry *dentry,
+				const char *path)
+{
+	struct file *new_exe_file;
+	struct task_struct *task;
+	struct mm_struct *mm;
+	int error;
+
+	if (!proc_fd_access_allowed(dentry->d_inode))
+		return -EACCES;
+	task = get_proc_task(inode);
+	if (!task)
+		return -ENOENT;
+	mm = get_task_mm(task);
+	put_task_struct(task);
+	if (!mm)
+		return -ENOENT;
+	new_exe_file = open_exec(path);
+	error = PTR_ERR(new_exe_file);
+	if (!IS_ERR(error)) {
+		set_mm_exe_file(mm, new_exe_file);
+		error = 0;
+	}
+	mmput(mm);
+	return error;
+}
+
 static int proc_exe_link(struct inode *inode, struct dentry **dentry,
 			 struct vfsmount **mnt)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
@@ -1027,10 +1054,16 @@ static const struct inode_operations pro
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
 };
 
+static const struct inode_operations proc_pid_exe_inode_operations = {
+	.readlink	= proc_pid_readlink,
+	.follow_link	= proc_pid_follow_link,
+	.symlink	= proc_pid_exe_symlink,
+	.setattr	= proc_setattr,
+};
 
 /* building an inode */
 
 static int task_dumpable(struct task_struct *task)
 {
@@ -2087,11 +2120,13 @@ static const struct pid_entry tgid_base_
 	REG("numa_maps",  S_IRUGO, numa_maps),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, mem),
 	LNK("cwd",        cwd),
 	LNK("root",       root),
-	LNK("exe",        exe),
+	NOD("exe", (S_IFLNK|S_IRWXUGO),
+		&proc_pid_exe_inode_operations, NULL,
+		{ .proc_get_link = &proc_exe_link }),
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),

--
