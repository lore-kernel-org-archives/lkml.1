Return-Path: <linux-kernel-owner+w=401wt.eu-S1030792AbXDSX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030792AbXDSX4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031103AbXDSX4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:56:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:35303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423009AbXDSXzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:55:01 -0400
Message-Id: <20070419234704.340406253@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:08 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 5/7] Remove duplicate proc code
Content-Disposition: inline; filename=proc-mounts-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some duplicate code in generating the contents of /proc/mounts and
/proc/$pid/mountstats.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/proc/base.c |   45 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -359,7 +359,8 @@ struct proc_mounts {
 	int event;
 };
 
-static int mounts_open(struct inode *inode, struct file *file)
+static int __mounts_open(struct inode *inode, struct file *file,
+			 struct seq_operations *seq_ops)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct mnt_namespace *ns = NULL;
@@ -382,7 +383,7 @@ static int mounts_open(struct inode *ino
 		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
 		if (p) {
 			file->private_data = &p->m;
-			ret = seq_open(file, &mounts_op);
+			ret = seq_open(file, seq_ops);
 			if (!ret) {
 				p->m.private = ns;
 				p->event = ns->event;
@@ -395,17 +396,25 @@ static int mounts_open(struct inode *ino
 	return ret;
 }
 
+static int mounts_open(struct inode *inode, struct file *file)
+{
+	return __mounts_open(inode, file, &mounts_op);
+}
+
 static int mounts_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = file->private_data;
-	struct mnt_namespace *ns = m->private;
+	struct proc_mounts *p =
+		container_of(file->private_data, struct proc_mounts, m);
+	struct mnt_namespace *ns = p->m.private;
+
 	put_mnt_ns(ns);
 	return seq_release(inode, file);
 }
 
 static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
-	struct proc_mounts *p = file->private_data;
+	struct proc_mounts *p =
+		container_of(file->private_data, struct proc_mounts, m);
 	struct mnt_namespace *ns = p->m.private;
 	unsigned res = 0;
 
@@ -432,31 +441,7 @@ static const struct file_operations proc
 extern struct seq_operations mountstats_op;
 static int mountstats_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &mountstats_op);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct mnt_namespace *mnt_ns = NULL;
-		struct task_struct *task = get_proc_task(inode);
-
-		if (task) {
-			task_lock(task);
-			if (task->nsproxy)
-				mnt_ns = task->nsproxy->mnt_ns;
-			if (mnt_ns)
-				get_mnt_ns(mnt_ns);
-			task_unlock(task);
-			put_task_struct(task);
-		}
-
-		if (mnt_ns)
-			m->private = mnt_ns;
-		else {
-			seq_release(inode, file);
-			ret = -EINVAL;
-		}
-	}
-	return ret;
+	return __mounts_open(inode, file, &mountstats_op);
 }
 
 static const struct file_operations proc_mountstats_operations = {

-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

