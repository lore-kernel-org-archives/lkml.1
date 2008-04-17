Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbYDQLG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbYDQLG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbYDQLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbYDQLGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:31 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 01/12] LSM: Introduce inode_getsecid and ipc_getsecid hooks
Date: Thu, 17 Apr 2008 11:05:58 +0000
Message-Id: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid)
LSM hooks. These hooks will be used instead of similar exported
SELinux interfaces.

Let {inode,ipc,task}_getsecid hooks set the secid to 0 by default
if CONFIG_SECURITY is not defined or if the hook is set to
NULL (dummy). This is done to notify the caller that no valid
secid exists.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 include/linux/security.h |   30 +++++++++++++++++++++++++++++-
 security/dummy.c         |   16 +++++++++++++++-
 security/security.c      |   10 ++++++++++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index c673dfd..45717d9 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -468,6 +468,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@dentry is the dentry being changed.
  *	Return 0 on success.  If error is returned, then the operation
  *	causing setuid bit removal is failed.
+ * @inode_getsecid:
+ *	Get the secid associated with the node.
+ *	@inode contains a pointer to the inode.
+ *	@secid contains a pointer to the location where result will be saved.
+ *	In case of failure, @secid will be set to zero.
  *
  * Security hooks for file operations
  *
@@ -636,6 +641,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * @task_getsecid:
  *	Retrieve the security identifier of the process @p.
  *	@p contains the task_struct for the process and place is into @secid.
+ *	In case of failure, @secid will be set to zero.
+ *
  * @task_setgroups:
  *	Check permission before setting the supplementary group set of the
  *	current process.
@@ -997,6 +1004,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@ipcp contains the kernel IPC permission structure
  *	@flag contains the desired (requested) permission set
  *	Return 0 if permission is granted.
+ * @ipc_getsecid:
+ *	Get the secid associated with the ipc object.
+ *	@ipcp contains the kernel IPC permission structure.
+ *	@secid contains a pointer to the location where result will be saved.
+ *	In case of failure, @secid will be set to zero.
  *
  * Security hooks for individual messages held in System V IPC message queues
  * @msg_msg_alloc_security:
@@ -1317,6 +1329,7 @@ struct security_operations {
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
+	void (*inode_getsecid)(const struct inode *inode, u32 *secid);
 
 	int (*file_permission) (struct file * file, int mask);
 	int (*file_alloc_security) (struct file * file);
@@ -1369,6 +1382,7 @@ struct security_operations {
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
 	int (*ipc_permission) (struct kern_ipc_perm * ipcp, short flag);
+	void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);
 
 	int (*msg_msg_alloc_security) (struct msg_msg * msg);
 	void (*msg_msg_free_security) (struct msg_msg * msg);
@@ -1578,6 +1592,7 @@ int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
+void security_inode_getsecid(const struct inode *inode, u32 *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -1622,6 +1637,7 @@ int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
@@ -2022,6 +2038,11 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return 0;
 }
 
+static inline void security_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -2137,7 +2158,9 @@ static inline int security_task_getsid (struct task_struct *p)
 }
 
 static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static inline int security_task_setgroups (struct group_info *group_info)
 {
@@ -2216,6 +2239,11 @@ static inline int security_ipc_permission (struct kern_ipc_perm *ipcp,
 	return 0;
 }
 
+static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_msg_msg_alloc (struct msg_msg * msg)
 {
 	return 0;
diff --git a/security/dummy.c b/security/dummy.c
index 78d8f92..fb2e942 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -424,6 +424,11 @@ static int dummy_inode_listsecurity(struct inode *inode, char *buffer, size_t bu
 	return 0;
 }
 
+static void dummy_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+}
+
 static int dummy_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -542,7 +547,9 @@ static int dummy_task_getsid (struct task_struct *p)
 }
 
 static void dummy_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static int dummy_task_setgroups (struct group_info *group_info)
 {
@@ -616,6 +623,11 @@ static int dummy_ipc_permission (struct kern_ipc_perm *ipcp, short flag)
 	return 0;
 }
 
+static void dummy_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	*secid = 0;
+}
+
 static int dummy_msg_msg_alloc_security (struct msg_msg *msg)
 {
 	return 0;
@@ -1058,6 +1070,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
+	set_to_dummy_if_null(ops, inode_getsecid);
 	set_to_dummy_if_null(ops, file_permission);
 	set_to_dummy_if_null(ops, file_alloc_security);
 	set_to_dummy_if_null(ops, file_free_security);
@@ -1094,6 +1107,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, task_reparent_to_init);
  	set_to_dummy_if_null(ops, task_to_inode);
 	set_to_dummy_if_null(ops, ipc_permission);
+	set_to_dummy_if_null(ops, ipc_getsecid);
 	set_to_dummy_if_null(ops, msg_msg_alloc_security);
 	set_to_dummy_if_null(ops, msg_msg_free_security);
 	set_to_dummy_if_null(ops, msg_queue_alloc_security);
diff --git a/security/security.c b/security/security.c
index b1387a6..33e59a7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -523,6 +523,11 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
+void security_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	security_ops->inode_getsecid(inode, secid);
+}
+
 int security_file_permission(struct file *file, int mask)
 {
 	return security_ops->file_permission(file, mask);
@@ -712,6 +717,11 @@ int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 	return security_ops->ipc_permission(ipcp, flag);
 }
 
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	security_ops->ipc_getsecid(ipcp, secid);
+}
+
 int security_msg_msg_alloc(struct msg_msg *msg)
 {
 	return security_ops->msg_msg_alloc_security(msg);
-- 
1.5.4.2

