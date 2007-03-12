Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXCLQSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXCLQSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCLQSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:18:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59218 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXCLQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:17:59 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] sanitize security_getprocattr() API
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HQnDi-0008Ll-26@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 12 Mar 2007 16:17:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


have it return the buffer it had allocated

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/proc/base.c           |   21 ++++++---------------
 include/linux/security.h |    8 ++++----
 security/dummy.c         |    2 +-
 security/selinux/hooks.c |    8 ++++++--
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4f5745a..6bbfe91 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1558,29 +1558,20 @@ static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
 	struct inode * inode = file->f_path.dentry->d_inode;
-	unsigned long page;
+	char *p = NULL;
 	ssize_t length;
 	struct task_struct *task = get_proc_task(inode);
 
-	length = -ESRCH;
 	if (!task)
-		goto out_no_task;
-
-	if (count > PAGE_SIZE)
-		count = PAGE_SIZE;
-	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_KERNEL)))
-		goto out;
+		return -ESRCH;
 
 	length = security_getprocattr(task,
 				      (char*)file->f_path.dentry->d_name.name,
-				      (void*)page, count);
-	if (length >= 0)
-		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
-	free_page(page);
-out:
+				      &p);
 	put_task_struct(task);
-out_no_task:
+	if (length > 0)
+		length = simple_read_from_buffer(buf, count, ppos, p, length);
+	kfree(p);
 	return length;
 }
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 7f88d97..47e82c1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1324,7 +1324,7 @@ struct security_operations {
 
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
- 	int (*getprocattr)(struct task_struct *p, char *name, void *value, size_t size);
+ 	int (*getprocattr)(struct task_struct *p, char *name, char **value);
  	int (*setprocattr)(struct task_struct *p, char *name, void *value, size_t size);
 	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
 	void (*release_secctx)(char *secdata, u32 seclen);
@@ -2092,9 +2092,9 @@ static inline void security_d_instantiate (struct dentry *dentry, struct inode *
 	security_ops->d_instantiate (dentry, inode);
 }
 
-static inline int security_getprocattr(struct task_struct *p, char *name, void *value, size_t size)
+static inline int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	return security_ops->getprocattr(p, name, value, size);
+	return security_ops->getprocattr(p, name, value);
 }
 
 static inline int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
@@ -2749,7 +2749,7 @@ static inline int security_sem_semop (struct sem_array * sma,
 static inline void security_d_instantiate (struct dentry *dentry, struct inode *inode)
 { }
 
-static inline int security_getprocattr(struct task_struct *p, char *name, void *value, size_t size)
+static inline int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
 	return -EINVAL;
 }
diff --git a/security/dummy.c b/security/dummy.c
index 558795b..8ffd764 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -907,7 +907,7 @@ static void dummy_d_instantiate (struct dentry *dentry, struct inode *inode)
 	return;
 }
 
-static int dummy_getprocattr(struct task_struct *p, char *name, void *value, size_t size)
+static int dummy_getprocattr(struct task_struct *p, char *name, char **value)
 {
 	return -EINVAL;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b1ac22d..0b265a5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4468,11 +4468,12 @@ static void selinux_d_instantiate (struct dentry *dentry, struct inode *inode)
 }
 
 static int selinux_getprocattr(struct task_struct *p,
-			       char *name, void *value, size_t size)
+			       char *name, char **value)
 {
 	struct task_security_struct *tsec;
 	u32 sid;
 	int error;
+	unsigned len;
 
 	if (current != p) {
 		error = task_has_perm(current, p, PROCESS__GETATTR);
@@ -4500,7 +4501,10 @@ static int selinux_getprocattr(struct task_struct *p,
 	if (!sid)
 		return 0;
 
-	return selinux_getsecurity(sid, value, size);
+	error = security_sid_to_context(sid, value, &len);
+	if (error)
+		return error;
+	return len;
 }
 
 static int selinux_setprocattr(struct task_struct *p,
-- 
1.5.0-rc2.GIT

