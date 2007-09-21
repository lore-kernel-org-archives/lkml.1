Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbXIUTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbXIUTuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbXIUTtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:49:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762345AbXIUTtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:49:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/22] CRED: Request a credential record for a kernel service
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:47:24 +0100
Message-ID: <20070921144724.8323.92646.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Request a credential record for the named kernel service.  This produces a
cred struct with appropriate DAC and MAC controls for effecting that service.
It may be used to override the credentials on a task to do work on that task's
behalf.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h     |    2 +
 include/linux/security.h |   45 ++++++++++++++++++++++++++++++
 kernel/cred.c            |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 security/dummy.c         |   13 +++++++++
 security/selinux/hooks.c |   47 ++++++++++++++++++++++++++++++++
 5 files changed, 175 insertions(+), 0 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index f2df1c3..fcbfc89 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -49,6 +49,8 @@ extern void change_fsgid(struct cred *, gid_t);
 extern void change_groups(struct cred *, struct group_info *);
 extern void change_cap(struct cred *, kernel_cap_t);
 extern struct cred *dup_cred(const struct cred *);
+extern struct cred *get_kernel_cred(const char *, struct task_struct *);
+extern int change_create_files_as(struct cred *, struct inode *);
 
 /**
  * get_cred - Get an extra reference on a credentials record
diff --git a/include/linux/security.h b/include/linux/security.h
index 74cc204..7f11e6d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -514,6 +514,20 @@ struct request_sock;
  * @cred_destroy:
  *	Destroy the credentials attached to a cred structure.
  *	@cred points to the credentials structure that is to be destroyed.
+ * @cred_kernel_act_as:
+ *	Set the credentials for a kernel service to act as (subjective context).
+ *	@cred points to the credentials structure to be filled in.
+ *	@service names the service making the request.
+ *	@daemon: A userspace daemon to be used as a base for the context.
+ *	@dentry: A file or dir to be used as a base for the file creation
+ *	  context.
+ *	Return 0 if successful.
+ * @cred_create_files_as:
+ *	Set the file creation context in a credentials record to be the same as
+ *	the objective context of an inode.
+ *	@cred points to the credentials structure to be altered.
+ *	@inode points to the inode to use as a reference.
+ *	Return 0 if successful.
  *
  * Security hooks for task operations.
  *
@@ -1270,6 +1284,9 @@ struct security_operations {
 
 	int (*cred_dup)(struct cred *cred);
 	void (*cred_destroy)(struct cred *cred);
+	int (*cred_kernel_act_as)(struct cred *cred, const char *service,
+			       struct task_struct *daemon);
+	int (*cred_create_files_as)(struct cred *cred, struct inode *inode);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*task_alloc_security) (struct task_struct * p);
@@ -1888,6 +1905,21 @@ static inline void security_cred_destroy(struct cred *cred)
 	return security_ops->cred_destroy(cred);
 }
 
+static inline int security_cred_kernel_act_as(struct cred *cred,
+					   const char *service,
+					   struct task_struct *daemon)
+{
+	return security_ops->cred_kernel_act_as(cred, service, daemon);
+}
+
+static inline int security_cred_create_files_as(struct cred *cred,
+						struct inode *inode)
+{
+	if (IS_PRIVATE(inode))
+		return -EINVAL;
+	return security_ops->cred_create_files_as(cred, inode);
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return security_ops->task_create (clone_flags);
@@ -2579,6 +2611,19 @@ static inline void security_cred_destroy(struct cred *cred)
 {
 }
 
+static inline int security_cred_kernel_act_as(struct cred *cred,
+					      const char *service,
+					      struct task_struct *daemon)
+{
+	return 0;
+}
+
+static inline int security_cred_create_files_as(struct cred *cred,
+						struct inode *inode)
+{
+	return 0;
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return 0;
diff --git a/kernel/cred.c b/kernel/cred.c
index c391f66..46a6661 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -206,3 +206,71 @@ void change_cap(struct cred *cred, kernel_cap_t cap)
 }
 
 EXPORT_SYMBOL(change_cap);
+
+/**
+ * get_kernel_cred - Get credentials for a named kernel service
+ * @service: The name of the service
+ * @daemon: A userspace daemon to be used as a base for the context
+ *
+ * Get a set of credentials for a specific kernel service.  These can then be
+ * used to override a task's credentials so that work can be done on behalf of
+ * that task.
+ *
+ * @daemon is used to provide a base for the security context, but can be NULL.
+ * If @deamon is supplied, then the cred's uid, gid and groups list will be
+ * derived from that; otherwise they'll be set to 0 and no groups.
+ *
+ * @daemon is also passd to the LSM module as a base from which to initialise
+ * any MAC controls.
+ *
+ * The caller may change these controls afterwards if desired.
+ */
+struct cred *get_kernel_cred(const char *service,
+			     struct task_struct *daemon)
+{
+	struct cred *cred, *dcred;
+	int ret;
+
+	cred = kzalloc(sizeof *cred, GFP_KERNEL);
+	if (!cred)
+		return ERR_PTR(-ENOMEM);
+
+	if (daemon) {
+		rcu_read_lock();
+		dcred = task_cred(daemon);
+		cred->uid = dcred->uid;
+		cred->gid = dcred->gid;
+		cred->group_info = dcred->group_info;
+		atomic_inc(&cred->group_info->usage);
+		rcu_read_unlock();
+	} else {
+		cred->group_info = &init_groups;
+		atomic_inc(&init_groups.usage);
+	}
+
+	ret = security_cred_kernel_act_as(cred, service, daemon);
+	if (ret < 0) {
+		put_cred(cred);
+		return ERR_PTR(ret);
+	}
+
+	return cred;
+}
+
+EXPORT_SYMBOL(get_kernel_cred);
+
+/**
+ * change_create_files_as - Change the file creation context in a new cred record
+ * @cred: The credential record to alter
+ * @inode: The inode to take the context from
+ *
+ * Change the file creation context in a new credentials record to be the same
+ * as the object context of the specified inode, so that the new inodes have
+ * the same MAC context as that inode.
+ */
+int change_create_files_as(struct cred *cred, struct inode *inode)
+{
+	return security_cred_create_files_as(cred, inode);
+}
+
+EXPORT_SYMBOL(change_create_files_as);
diff --git a/security/dummy.c b/security/dummy.c
index f403658..004bb21 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -488,6 +488,17 @@ static void dummy_cred_destroy(struct cred *cred)
 {
 }
 
+static int dummy_cred_kernel_act_as(struct cred *cred, const char *service,
+				    struct task_struct *daemon)
+{
+	return 0;
+}
+
+static int dummy_cred_create_files_as(struct cred *cred, struct inode *inode)
+{
+	return 0;
+}
+
 static int dummy_task_create (unsigned long clone_flags)
 {
 	return 0;
@@ -1063,6 +1074,8 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, file_receive);
 	set_to_dummy_if_null(ops, cred_dup);
 	set_to_dummy_if_null(ops, cred_destroy);
+	set_to_dummy_if_null(ops, cred_kernel_act_as);
+	set_to_dummy_if_null(ops, cred_create_files_as);
 	set_to_dummy_if_null(ops, task_create);
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4e72dbb..fa11211 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2771,6 +2771,51 @@ static void selinux_cred_destroy(struct cred *cred)
 	kfree(cred->security);
 }
 
+/*
+ * get the credentials for a kernel service, deriving the subjective context
+ * from the credentials of a userspace daemon if one supplied
+ * - all the creation contexts are set to unlabelled
+ */
+static int selinux_cred_kernel_act_as(struct cred *cred,
+				      const char *service,
+				      struct task_struct *daemon)
+{
+	struct task_security_struct *tsec;
+	struct cred_security_struct *csec;
+	u32 ksid;
+	int ret;
+
+	tsec = daemon ? daemon->security : init_task.security;
+
+	ret = security_transition_sid(tsec->victim_sid, SECINITSID_KERNEL,
+				      SECCLASS_PROCESS, &ksid);
+	if (ret < 0)
+		return ret;
+
+	csec = kzalloc(sizeof(struct cred_security_struct), GFP_KERNEL);
+	if (!csec)
+		return -ENOMEM;
+
+	csec->action_sid = ksid;
+	csec->create_sid = SECINITSID_UNLABELED;
+	csec->keycreate_sid = SECINITSID_UNLABELED;
+	csec->sockcreate_sid = SECINITSID_UNLABELED;
+	cred->security = csec;
+	return 0;
+}
+
+/*
+ * set the file creation context in a credentials record to the same as the
+ * objective context of the specified inode
+ */
+static int selinux_cred_create_files_as(struct cred *cred, struct inode *inode)
+{
+	struct cred_security_struct *csec = cred->security;
+	struct inode_security_struct *isec = inode->i_security;
+
+	csec->create_sid = isec->sid;
+	return 0;
+}
 
 /* task security operations */
 
@@ -4887,6 +4932,8 @@ static struct security_operations selinux_ops = {
 
 	.cred_dup =			selinux_cred_dup,
 	.cred_destroy =			selinux_cred_destroy,
+	.cred_kernel_act_as =		selinux_cred_kernel_act_as,
+	.cred_create_files_as =		selinux_cred_create_files_as,
 
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,

