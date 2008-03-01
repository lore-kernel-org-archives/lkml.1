Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYCATyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYCATyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbYCATyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:54:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:62585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbYCATyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=nZ8bTWo3o9Sk/5Dr91IQ/Tu+qDEFtZc+JAOGnjx3h5IRAPdBQD3AyTKiG5JuH2ODU7A6GX4bp1eg0wIW4TL5Wx6JY3USqJgiZ8O079En+EJM03x4QzVdqz8M+LAS5qcJ1cize8SqGqK8LfGgfHeVw5a7gQYfRyLZTLAD7V/QdLQ=
Date: Sat, 1 Mar 2008 21:51:09 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 1/9] LSM: Introduce inode_getsecid and ipc_getsecid hooks
Message-ID: <20080301195109.GB19636@ubuntu>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301194752.GA19636@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid)
LSM hooks. These hooks will be used instead of similar exported 
SELinux interfaces.

Let {inode,ipc,task}_getsecid hooks set the secid to 0 by default 
if CONFIG_SECURITY is not defined or if the hook is set to 
NULL (dummy). This is done to notify the caller that no valid 
secid exists.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 include/linux/security.h |   30 +++++++++++++++++++++++++++++-
 security/dummy.c         |   16 +++++++++++++++-
 security/security.c      |   10 ++++++++++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index a33fd03..205a053 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -449,6 +449,11 @@ struct request_sock;
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
@@ -617,6 +622,8 @@ struct request_sock;
  * @task_getsecid:
  *	Retrieve the security identifier of the process @p.
  *	@p contains the task_struct for the process and place is into @secid.
+ *	In case of failure, @secid will be set to zero.
+ *
  * @task_setgroups:
  *	Check permission before setting the supplementary group set of the
  *	current process.
@@ -989,6 +996,11 @@ struct request_sock;
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
@@ -1310,6 +1322,7 @@ struct security_operations {
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
+	void (*inode_getsecid)(const struct inode *inode, u32 *secid);
 
 	int (*file_permission) (struct file * file, int mask);
 	int (*file_alloc_security) (struct file * file);
@@ -1362,6 +1375,7 @@ struct security_operations {
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
 	int (*ipc_permission) (struct kern_ipc_perm * ipcp, short flag);
+	void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);
 
 	int (*msg_msg_alloc_security) (struct msg_msg * msg);
 	void (*msg_msg_free_security) (struct msg_msg * msg);
@@ -1571,6 +1585,7 @@ int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
+void security_inode_getsecid(const struct inode *inode, u32 *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -1615,6 +1630,7 @@ int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
@@ -1985,6 +2001,11 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
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
@@ -2100,7 +2121,9 @@ static inline int security_task_getsid (struct task_struct *p)
 }
 
 static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static inline int security_task_setgroups (struct group_info *group_info)
 {
@@ -2179,6 +2202,11 @@ static inline int security_ipc_permission (struct kern_ipc_perm *ipcp,
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
index 6a0056b..f5e5f95 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -422,6 +422,11 @@ static int dummy_inode_listsecurity(struct inode *inode, char *buffer, size_t bu
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
@@ -540,7 +545,9 @@ static int dummy_task_getsid (struct task_struct *p)
 }
 
 static void dummy_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static int dummy_task_setgroups (struct group_info *group_info)
 {
@@ -614,6 +621,11 @@ static int dummy_ipc_permission (struct kern_ipc_perm *ipcp, short flag)
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
@@ -1062,6 +1074,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
+	set_to_dummy_if_null(ops, inode_getsecid);
 	set_to_dummy_if_null(ops, file_permission);
 	set_to_dummy_if_null(ops, file_alloc_security);
 	set_to_dummy_if_null(ops, file_free_security);
@@ -1098,6 +1111,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, task_reparent_to_init);
  	set_to_dummy_if_null(ops, task_to_inode);
 	set_to_dummy_if_null(ops, ipc_permission);
+	set_to_dummy_if_null(ops, ipc_getsecid);
 	set_to_dummy_if_null(ops, msg_msg_alloc_security);
 	set_to_dummy_if_null(ops, msg_msg_free_security);
 	set_to_dummy_if_null(ops, msg_queue_alloc_security);
diff --git a/security/security.c b/security/security.c
index 3e75b90..1748329 100644
--- a/security/security.c
+++ b/security/security.c
@@ -516,6 +516,11 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
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
@@ -705,6 +710,11 @@ int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
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

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

