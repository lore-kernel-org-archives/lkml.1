Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXJIXWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXJIXWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXJIXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:21:43 -0400
Received: from namei.org ([69.55.235.186]:44181 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751839AbXJIXVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:21:41 -0400
Date: Wed, 10 Oct 2007 09:21:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 3/6] SELinux: Improve read/write performance
In-Reply-To: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0710100920410.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuichi Nakamura <ynakam@hitachisoft.jp>

It reduces the selinux overhead on read/write by only revalidating
permissions in selinux_file_permission if the task or inode labels have
changed or the policy has changed since the open-time check.  A new LSM
hook, security_dentry_open, is added to capture the necessary state at open
time to allow this optimization.

(see http://marc.info/?l=selinux&m=118972995207740&w=2)

Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@localhost.localdomain>
---
 fs/open.c                         |    4 +++
 include/linux/security.h          |   18 ++++++++++++
 security/dummy.c                  |    6 ++++
 security/selinux/avc.c            |    5 +++
 security/selinux/hooks.c          |   53 ++++++++++++++++++++++++++++++++++++-
 security/selinux/include/avc.h    |    2 +
 security/selinux/include/objsec.h |    2 +
 7 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..044bfa8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -757,6 +757,10 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	f->f_op = fops_get(inode->i_fop);
 	file_move(f, &inode->i_sb->s_files);
 
+	error = security_dentry_open(f);
+	if (error)
+		goto cleanup_all;
+
 	if (!open && f->f_op)
 		open = f->f_op->open;
 	if (open) {
diff --git a/include/linux/security.h b/include/linux/security.h
index 1a15526..928d479 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -504,6 +504,13 @@ struct request_sock;
  *	@file contains the file structure being received.
  *	Return 0 if permission is granted.
  *
+ * Security hook for dentry
+ *
+ * @dentry_open
+ *	Save open-time permission checking state for later use upon
+ *	file_permission, and recheck access if anything has changed
+ *	since inode_permission.
+ *
  * Security hooks for task operations.
  *
  * @task_create:
@@ -1256,6 +1263,7 @@ struct security_operations {
 	int (*file_send_sigiotask) (struct task_struct * tsk,
 				    struct fown_struct * fown, int sig);
 	int (*file_receive) (struct file * file);
+	int (*dentry_open)  (struct file *file);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*task_alloc_security) (struct task_struct * p);
@@ -1864,6 +1872,11 @@ static inline int security_file_receive (struct file *file)
 	return security_ops->file_receive (file);
 }
 
+static inline int security_dentry_open (struct file *file)
+{
+	return security_ops->dentry_open (file);
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return security_ops->task_create (clone_flags);
@@ -2546,6 +2559,11 @@ static inline int security_file_receive (struct file *file)
 	return 0;
 }
 
+static inline int security_dentry_open (struct file *file)
+{
+	return 0;
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return 0;
diff --git a/security/dummy.c b/security/dummy.c
index 853ec22..64b647a 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -463,6 +463,11 @@ static int dummy_file_receive (struct file *file)
 	return 0;
 }
 
+static int dummy_dentry_open (struct file *file)
+{
+	return 0;
+}
+
 static int dummy_task_create (unsigned long clone_flags)
 {
 	return 0;
@@ -1033,6 +1038,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, file_set_fowner);
 	set_to_dummy_if_null(ops, file_send_sigiotask);
 	set_to_dummy_if_null(ops, file_receive);
+	set_to_dummy_if_null(ops, dentry_open);
 	set_to_dummy_if_null(ops, task_create);
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 0e69adf..81b3dff 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -916,3 +916,8 @@ int avc_has_perm(u32 ssid, u32 tsid, u16 tclass,
 	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
 	return rc;
 }
+
+u32 avc_policy_seqno(void)
+{
+	return avc_cache.latest_notif;
+}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0753b20..e842308 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -14,6 +14,8 @@
  *                          <dgoeddel@trustedcs.com>
  *  Copyright (C) 2006 Hewlett-Packard Development Company, L.P.
  *                     Paul Moore, <paul.moore@hp.com>
+ *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
+ *                     Yuichi Nakamura <ynakam@hitachisoft.jp>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -2464,7 +2466,7 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 
 /* file security operations */
 
-static int selinux_file_permission(struct file *file, int mask)
+static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
 	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -2486,6 +2488,25 @@ static int selinux_file_permission(struct file *file, int mask)
 	return selinux_netlbl_inode_permission(inode, mask);
 }
 
+static int selinux_file_permission(struct file *file, int mask)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_security_struct *tsec = current->security;
+	struct file_security_struct *fsec = file->f_security;
+	struct inode_security_struct *isec = inode->i_security;
+
+	if (!mask) {
+		/* No permission to check.  Existence test. */
+		return 0;
+	}
+
+	if (tsec->sid == fsec->sid && fsec->isid == isec->sid
+	    && fsec->pseqno == avc_policy_seqno())
+		return selinux_netlbl_inode_permission(inode, mask);
+
+	return selinux_revalidate_file_permission(file, mask);
+}
+
 static int selinux_file_alloc_security(struct file *file)
 {
 	return file_alloc_security(file);
@@ -2725,6 +2746,34 @@ static int selinux_file_receive(struct file *file)
 	return file_has_perm(current, file, file_to_av(file));
 }
 
+static int selinux_dentry_open(struct file *file)
+{
+	struct file_security_struct *fsec;
+	struct inode *inode;
+	struct inode_security_struct *isec;
+	inode = file->f_path.dentry->d_inode;
+	fsec = file->f_security;
+	isec = inode->i_security;
+	/*
+	 * Save inode label and policy sequence number
+	 * at open-time so that selinux_file_permission
+	 * can determine whether revalidation is necessary.
+	 * Task label is already saved in the file security
+	 * struct as its SID.
+	 */
+	fsec->isid = isec->sid;
+	fsec->pseqno = avc_policy_seqno();
+	/*
+	 * Since the inode label or policy seqno may have changed
+	 * between the selinux_inode_permission check and the saving
+	 * of state above, recheck that access is still permitted.
+	 * Otherwise, access might never be revalidated against the
+	 * new inode label or new policy.
+	 * This check is not redundant - do not remove.
+	 */
+	return inode_has_perm(current, inode, file_to_av(file), NULL);
+}
+
 /* task security operations */
 
 static int selinux_task_create(unsigned long clone_flags)
@@ -4790,6 +4839,8 @@ static struct security_operations selinux_ops = {
 	.file_send_sigiotask =		selinux_file_send_sigiotask,
 	.file_receive =			selinux_file_receive,
 
+	.dentry_open =                  selinux_dentry_open,
+
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index e145f6e..553607a 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -112,6 +112,8 @@ int avc_has_perm(u32 ssid, u32 tsid,
                  u16 tclass, u32 requested,
                  struct avc_audit_data *auditdata);
 
+u32 avc_policy_seqno(void);
+
 #define AVC_CALLBACK_GRANT		1
 #define AVC_CALLBACK_TRY_REVOKE		2
 #define AVC_CALLBACK_REVOKE		4
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91b88f0..642a9fd 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -53,6 +53,8 @@ struct file_security_struct {
 	struct file *file;              /* back pointer to file object */
 	u32 sid;              /* SID of open file description */
 	u32 fown_sid;         /* SID of file owner (for SIGIO) */
+	u32 isid;             /* SID of inode at the time of file open */
+	u32 pseqno;           /* Policy seqno at the time of file open */
 };
 
 struct superblock_security_struct {
-- 
1.5.2.4

