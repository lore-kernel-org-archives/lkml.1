Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXIZOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXIZOXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbXIZOVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:21:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759902AbXIZOVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:21:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/24] CRED: Request a credential record for a kernel service
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 26 Sep 2007 15:21:30 +0100
Message-ID: <20070926142130.2656.73544.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
References: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
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
 include/linux/security.h |   43 +++++++++++++++++++++++++++++
 kernel/cred.c            |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 security/dummy.c         |   13 +++++++++
 security/selinux/hooks.c |   47 ++++++++++++++++++++++++++++++++
 5 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 78924d5..b2d0ac9 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -51,6 +51,8 @@ extern void change_fsgid(struct cred *, gid_t);
 extern void change_groups(struct cred *, struct group_info *);
 extern void change_cap(struct cred *, kernel_cap_t);
 extern struct cred *dup_cred(const struct cred *);
+extern struct cred *get_kernel_cred(const char *, struct task_struct *);
+extern int change_create_files_as(struct cred *, struct inode *);
 
 /**
  * get_cred - Get an extra reference on a credentials record
diff --git a/include/linux/security.h b/include/linux/security.h
index 0933333..b7c06c3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -514,6 +514,18 @@ struct request_sock;
  * @cred_destroy:
  *	Destroy the credentials attached to a cred structure.
  *	@cred points to the credentials structure that is to be destroyed.
+ * @cred_kernel_act_as:
+ *	Set the credentials for a kernel service to act as (subjective context).
+ *	@cred points to the credentials structure to be filled in.
+ *	@service names the service making the request.
+ *	@daemon: A userspace daemon to be used as a base for the context.
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
@@ -1275,6 +1287,9 @@ struct security_operations {
 
 	int (*cred_dup)(struct cred *cred);
 	void (*cred_destroy)(struct cred *cred);
+	int (*cred_kernel_act_as)(struct cred *cred, const char *service,
+			       struct task_struct *daemon);
+	int (*cred_create_files_as)(struct cred *cred, struct inode *inode);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*task_alloc_security) (struct task_struct * p);
@@ -1894,6 +1909,21 @@ static inline void security_cred_destroy(struct cred *cred)
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
@@ -2586,6 +2616,19 @@ static inline void security_cred_destroy(struct cred *cred)
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
index f545634..294b33a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -210,3 +210,71 @@ void change_cap(struct cred *cred, kernel_cap_t cap)
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
index 7e52156..348c09b 100644
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
@@ -1064,6 +1075,8 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, file_receive);
 	set_to_dummy_if_null(ops, cred_dup);
 	set_to_dummy_if_null(ops, cred_destroy);
+	set_to_dummy_if_null(ops, cred_kernel_act_as);
+	set_to_dummy_if_null(ops, cred_create_files_as);
 	set_to_dummy_if_null(ops, task_create);
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2ee1712..fc4e75d 100644
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
 
@@ -4888,6 +4933,8 @@ static struct security_operations selinux_ops = {
 
 	.cred_dup =			selinux_cred_dup,
 	.cred_destroy =			selinux_cred_destroy,
+	.cred_kernel_act_as =		selinux_cred_kernel_act_as,
+	.cred_create_files_as =		selinux_cred_create_files_as,
 
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,

