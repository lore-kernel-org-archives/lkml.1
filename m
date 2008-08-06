Return-Path: <linux-kernel-owner+w=401wt.eu-S964910AbYHFPoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910AbYHFPoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964819AbYHFPkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:40:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964805AbYHFPj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/24] CRED: Allow kernel services to override LSM settings
	for task actions [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:39:18 +0100
Message-ID: <20080806153917.14351.80732.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kernel services to override LSM settings appropriate to the actions
performed by a task by duplicating a set of credentials, modifying it and then
using task_struct::cred to point to it when performing operations on behalf of
a task.

This is used, for example, by CacheFiles which has to transparently access the
cache on behalf of a process that thinks it is doing, say, NFS accesses with a
potentially inappropriate (with respect to accessing the cache) set of
credentials.

This patch provides two LSM hooks for modifying a task security record:

 (*) security_kernel_act_as() which allows modification of the security datum
     with which a task acts on other objects (most notably files).

 (*) security_kernel_create_files_as() which allows modification of the
     security datum that is used to initialise the security data on a file that
     a task creates.

The patch also provides four new credentials handling functions, which wrap the
LSM functions:

 (1) prepare_kernel_cred()

     Prepare a set of credentials for a kernel service to use, based either on
     a daemon's credentials or on init_cred.  All the keyrings are cleared.

 (2) set_security_override()

     Set the LSM security ID in a set of credentials to a specific security
     context, assuming permission from the LSM policy.

 (3) set_security_override_from_ctx()

     As (2), but takes the security context as a string.

 (4) set_create_files_as()

     Set the file creation LSM security ID in a set of credentials to be the
     same as that on a particular inode.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com> [Smack changes]
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h       |    6 ++
 include/linux/security.h   |   28 +++++++++++
 kernel/cred.c              |  113 ++++++++++++++++++++++++++++++++++++++++++++
 security/capability.c      |   12 +++++
 security/security.c        |   10 ++++
 security/selinux/hooks.c   |   46 ++++++++++++++++++
 security/smack/smack_lsm.c |   37 ++++++++++++++
 7 files changed, 252 insertions(+), 0 deletions(-)


diff --git a/include/linux/cred.h b/include/linux/cred.h
index 7efcecb..b156ed4 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -18,6 +18,7 @@
 
 struct user_struct;
 struct cred;
+struct inode;
 
 /*
  * COW Supplementary groups list
@@ -148,6 +149,11 @@ extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
 extern const struct cred *override_creds(const struct cred *);
 extern void revert_creds(const struct cred *);
+extern struct cred *prepare_kernel_cred(struct task_struct *);
+extern int change_create_files_as(struct cred *, struct inode *);
+extern int set_security_override(struct cred *, u32);
+extern int set_security_override_from_ctx(struct cred *, const char *);
+extern int set_create_files_as(struct cred *, struct inode *);
 extern void __init cred_init(void);
 
 /**
diff --git a/include/linux/security.h b/include/linux/security.h
index 29a6a32..8317683 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -583,6 +583,19 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@new points to the new credentials.
  *	@old points to the original credentials.
  *	Install a new set of credentials.
+ * @kernel_act_as:
+ *	Set the credentials for a kernel service to act as (subjective context).
+ *	@new points to the credentials to be modified.
+ *	@secid specifies the security ID to be set
+ *	The current task must be the one that nominated @secid.
+ *	Return 0 if successful.
+ * @kernel_create_files_as:
+ *	Set the file creation context in a set of credentials to be the same as
+ *	the objective context of the specified inode.
+ *	@new points to the credentials to be modified.
+ *	@inode points to the inode to use as a reference.
+ *	The current task must be the one that nominated @inode.
+ *	Return 0 if successful.
  * @task_setuid:
  *	Check permission before setting one or more of the user identity
  *	attributes of the current process.  The @flags parameter indicates
@@ -1377,6 +1390,8 @@ struct security_operations {
 	int (*cred_prepare)(struct cred *new, const struct cred *old,
 			    gfp_t gfp);
 	void (*cred_commit)(struct cred *new, const struct cred *old);
+	int (*kernel_act_as)(struct cred *new, u32 secid);
+	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
 	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
 				int flags);
@@ -1631,6 +1646,8 @@ int security_task_create(unsigned long clone_flags);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_commit_creds(struct cred *new, const struct cred *old);
+int security_kernel_act_as(struct cred *new, u32 secid);
+int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags);
@@ -2140,6 +2157,17 @@ static inline void security_commit_creds(struct cred *new,
 {
 }
 
+static inline int security_kernel_act_as(struct cred *cred, u32 secid)
+{
+	return 0;
+}
+
+static inline int security_kernel_create_files_as(struct cred *cred,
+						  struct inode *inode)
+{
+	return 0;
+}
+
 static inline int security_task_setuid(uid_t id0, uid_t id1, uid_t id2,
 				       int flags)
 {
diff --git a/kernel/cred.c b/kernel/cred.c
index eff48a4..6e9cfbf 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -467,3 +467,116 @@ void __init cred_init(void)
 	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
+
+/**
+ * prepare_kernel_cred - Prepare a set of credentials for a kernel service
+ * @daemon: A userspace daemon to be used as a reference
+ *
+ * Prepare a set of credentials for a kernel service.  This can then be used to
+ * override a task's own credentials so that work can be done on behalf of that
+ * task that requires a different subjective context.
+ *
+ * @daemon is used to provide a base for the security record, but can be NULL.
+ * If @daemon is supplied, then the security data will be derived from that;
+ * otherwise they'll be set to 0 and no groups, full capabilities and no keys.
+ *
+ * The caller may change these controls afterwards if desired.
+ *
+ * Returns the new credentials or NULL if out of memory.
+ *
+ * Does not take, and does not return holding current->cred_replace_mutex.
+ */
+struct cred *prepare_kernel_cred(struct task_struct *daemon)
+{
+	const struct cred *old;
+	struct cred *new;
+
+	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	if (daemon)
+		old = get_task_cred(daemon);
+	else
+		old = get_cred(&init_cred);
+
+	get_uid(new->user);
+	get_group_info(new->group_info);
+
+#ifdef CONFIG_KEYS
+	atomic_inc(&init_tgcred.usage);
+	new->tgcred = &init_tgcred;
+	new->request_key_auth = NULL;
+	new->thread_keyring = NULL;
+	new->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+#endif
+
+#ifdef CONFIG_SECURITY
+	new->security = NULL;
+#endif
+	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+		goto error;
+
+	atomic_set(&new->usage, 1);
+	put_cred(old);
+	return new;
+
+error:
+	put_cred(new);
+	return NULL;
+}
+EXPORT_SYMBOL(prepare_kernel_cred);
+
+/**
+ * set_security_override - Set the security ID in a set of credentials
+ * @new: The credentials to alter
+ * @secid: The LSM security ID to set
+ *
+ * Set the LSM security ID in a set of credentials so that the subjective
+ * security is overridden when an alternative set of credentials is used.
+ */
+int set_security_override(struct cred *new, u32 secid)
+{
+	return security_kernel_act_as(new, secid);
+}
+EXPORT_SYMBOL(set_security_override);
+
+/**
+ * set_security_override_from_ctx - Set the security ID in a set of credentials
+ * @new: The credentials to alter
+ * @secctx: The LSM security context to generate the security ID from.
+ *
+ * Set the LSM security ID in a set of credentials so that the subjective
+ * security is overridden when an alternative set of credentials is used.  The
+ * security ID is specified in string form as a security context to be
+ * interpreted by the LSM.
+ */
+int set_security_override_from_ctx(struct cred *new, const char *secctx)
+{
+	u32 secid;
+	int ret;
+
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	if (ret < 0)
+		return ret;
+
+	return set_security_override(new, secid);
+}
+EXPORT_SYMBOL(set_security_override_from_ctx);
+
+/**
+ * set_create_files_as - Set the LSM file create context in a set of credentials
+ * @new: The credentials to alter
+ * @inode: The inode to take the context from
+ *
+ * Change the LSM file creation context in a set of credentials to be the same
+ * as the object context of the specified inode, so that the new inodes have
+ * the same MAC context as that inode.
+ */
+int set_create_files_as(struct cred *new, struct inode *inode)
+{
+	new->fsuid = inode->i_uid;
+	new->fsgid = inode->i_gid;
+	return security_kernel_create_files_as(new, inode);
+}
+EXPORT_SYMBOL(set_create_files_as);
diff --git a/security/capability.c b/security/capability.c
index 185804f..b9e3914 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -348,6 +348,16 @@ static void cap_cred_commit(struct cred *new, const struct cred *old)
 {
 }
 
+static int cap_kernel_act_as(struct cred *new, u32 secid)
+{
+	return 0;
+}
+
+static int cap_kernel_create_files_as(struct cred *new, struct inode *inode)
+{
+	return 0;
+}
+
 static int cap_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	return 0;
@@ -889,6 +899,8 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, cred_free);
 	set_to_cap_if_null(ops, cred_prepare);
 	set_to_cap_if_null(ops, cred_commit);
+	set_to_cap_if_null(ops, kernel_act_as);
+	set_to_cap_if_null(ops, kernel_create_files_as);
 	set_to_cap_if_null(ops, task_setuid);
 	set_to_cap_if_null(ops, task_fix_setuid);
 	set_to_cap_if_null(ops, task_setgid);
diff --git a/security/security.c b/security/security.c
index 3da7856..4a4f753 100644
--- a/security/security.c
+++ b/security/security.c
@@ -602,6 +602,16 @@ void security_commit_creds(struct cred *new, const struct cred *old)
 	return security_ops->cred_commit(new, old);
 }
 
+int security_kernel_act_as(struct cred *new, u32 secid)
+{
+	return security_ops->kernel_act_as(new, secid);
+}
+
+int security_kernel_create_files_as(struct cred *new, struct inode *inode)
+{
+	return security_ops->kernel_create_files_as(new, inode);
+}
+
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	return security_ops->task_setuid(id0, id1, id2, flags);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 14067df..1d2272b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3282,6 +3282,50 @@ static void selinux_cred_commit(struct cred *new, const struct cred *old)
 	secondary_ops->cred_commit(new, old);
 }
 
+/*
+ * set the security data for a kernel service
+ * - all the creation contexts are set to unlabelled
+ */
+static int selinux_kernel_act_as(struct cred *new, u32 secid)
+{
+	struct task_security_struct *tsec = new->security;
+	u32 sid = current_sid();
+	int ret;
+
+ 	ret = avc_has_perm(sid, secid,
+			   SECCLASS_KERNEL_SERVICE,
+			   KERNEL_SERVICE__USE_AS_OVERRIDE,
+			   NULL);
+	if (ret == 0) {
+		tsec->sid = secid;
+		tsec->create_sid = 0;
+		tsec->keycreate_sid = 0;
+		tsec->sockcreate_sid = 0;
+	}
+	return ret;
+}
+
+/*
+ * set the file creation context in a security record to the same as the
+ * objective context of the specified inode
+ */
+static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	struct task_security_struct *tsec = new->security;
+	u32 sid = current_sid();
+	int ret;
+
+ 	ret = avc_has_perm(sid, isec->sid,
+			   SECCLASS_KERNEL_SERVICE,
+			   KERNEL_SERVICE__CREATE_FILES_AS,
+			   NULL);
+
+	if (ret == 0)
+		tsec->create_sid = isec->sid;
+	return 0;
+}
+
 static int selinux_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	/* Since setuid only affects the current process, and
@@ -5494,6 +5538,8 @@ static struct security_operations selinux_ops = {
 	.cred_free =			selinux_cred_free,
 	.cred_prepare =			selinux_cred_prepare,
 	.cred_commit =			selinux_cred_commit,
+	.kernel_act_as =		selinux_kernel_act_as,
+	.kernel_create_files_as =	selinux_kernel_create_files_as,
 	.task_setuid =			selinux_task_setuid,
 	.task_fix_setuid =		selinux_task_fix_setuid,
 	.task_setgid =			selinux_task_setgid,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3cf91f5..808208e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1012,6 +1012,41 @@ static void smack_cred_commit(struct cred *new, const struct cred *old)
 }
 
 /**
+ * smack_kernel_act_as - Set the subjective context in a set of credentials
+ * @new points to the set of credentials to be modified.
+ * @secid specifies the security ID to be set
+ *
+ * Set the security data for a kernel service.
+ */
+static int smack_kernel_act_as(struct cred *new, u32 secid)
+{
+	char *smack = smack_from_secid(secid);
+
+	if (smack == NULL)
+		return -EINVAL;
+
+	new->security = smack;
+	return 0;
+}
+
+/**
+ * smack_kernel_create_files_as - Set the file creation label in a set of creds
+ * @new points to the set of credentials to be modified
+ * @inode points to the inode to use as a reference
+ *
+ * Set the file creation context in a set of credentials to the same
+ * as the objective context of the specified inode
+ */
+static int smack_kernel_create_files_as(struct cred *new,
+					struct inode *inode)
+{
+	struct inode_smack *isp = inode->i_security;
+
+	new->security = isp->smk_inode;
+	return 0;
+}
+
+/**
  * smack_task_setpgid - Smack check on setting pgid
  * @p: the task object
  * @pgid: unused
@@ -2638,6 +2673,8 @@ struct security_operations smack_ops = {
 	.cred_free =			smack_cred_free,
 	.cred_prepare =			smack_cred_prepare,
 	.cred_commit =			smack_cred_commit,
+	.kernel_act_as =		smack_kernel_act_as,
+	.kernel_create_files_as =	smack_kernel_create_files_as,
 	.task_fix_setuid =		cap_task_fix_setuid,
 	.task_setpgid = 		smack_task_setpgid,
 	.task_getpgid = 		smack_task_getpgid,

