Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYBTQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYBTQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbYBTQIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:08:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764603AbYBTQIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/37] Security: Allow kernel services to override LSM
	settings for task actions
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:47 +0000
Message-ID: <20080220160646.4715.7268.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kernel services to override LSM settings appropriate to the actions
performed by a task by duplicating a security record, modifying it and then
using task_struct::act_as to point to it when performing operations on behalf
of a task.

This is used, for example, by CacheFiles which has to transparently access the
cache on behalf of a process that thinks it is doing, say, NFS accesses with a
potentially inappropriate (with respect to accessing the cache) set of
security data.

This patch provides two LSM hooks for modifying a task security record:

 (*) security_kernel_act_as() which allows modification of the security datum
     with which a task acts on other objects (most notably files).

 (*) security_create_files_as() which allows modification of the security
     datum that is used to initialise the security data on a file that a task
     creates.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/capability.h          |   12 ++--
 include/linux/cred.h                |   23 +++++++
 include/linux/security.h            |   43 +++++++++++++
 kernel/cred.c                       |  112 +++++++++++++++++++++++++++++++++++
 security/dummy.c                    |   17 +++++
 security/security.c                 |   15 ++++-
 security/selinux/hooks.c            |   51 ++++++++++++++++
 security/selinux/include/security.h |    2 -
 security/selinux/ss/services.c      |    5 +-
 security/smack/smack_lsm.c          |   32 ++++++++++
 10 files changed, 297 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/cred.h


diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7d50ff6..424de01 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -364,12 +364,12 @@ typedef struct kernel_cap_struct {
 # error Fix up hand-coded capability macro initializers
 #else /* HAND-CODED capability initializers */
 
-# define CAP_EMPTY_SET    {{ 0, 0 }}
-# define CAP_FULL_SET     {{ ~0, ~0 }}
-# define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}
-# define CAP_FS_SET       {{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } }
-# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
-			     CAP_FS_MASK_B1 } }
+# define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
+# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
+# define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
+# define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
+# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
+					CAP_FS_MASK_B1 } })
 
 #endif /* _LINUX_CAPABILITY_U32S != 2 */
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
new file mode 100644
index 0000000..497af5b
--- /dev/null
+++ b/include/linux/cred.h
@@ -0,0 +1,23 @@
+/* Credential management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_CRED_H
+#define _LINUX_CRED_H
+
+struct task_security;
+struct inode;
+
+extern struct task_security *get_kernel_security(struct task_struct *);
+extern int set_security_override(struct task_security *, u32);
+extern int set_security_override_from_ctx(struct task_security *, const char *);
+extern int change_create_files_as(struct task_security *, struct inode *);
+
+#endif /* _LINUX_CRED_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 9bf93c7..1c17b91 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -568,6 +568,19 @@ struct request_sock;
  *	Duplicate and attach the security structure currently attached to the
  *	p->security field.
  *	Return 0 if operation was successful.
+ * @task_kernel_act_as:
+ *	Set the credentials for a kernel service to act as (subjective context).
+ *	@p points to the task that nominated @secid.
+ *	@sec points to the task security record to be modified.
+ *	@secid specifies the security ID to be set
+ *	Return 0 if successful.
+ * @task_create_files_as:
+ *	Set the file creation context in a task security record to be the same
+ *	as the objective context of the specified inode.
+ *	@p points to the task that nominated @inode.
+ *	@sec points to the task security record to be modified.
+ *	@inode points to the inode to use as a reference.
+ *	Return 0 if successful.
  * @task_setuid:
  *	Check permission before setting one or more of the user identity
  *	attributes of the current process.  The @flags parameter indicates
@@ -1342,6 +1355,11 @@ struct security_operations {
 	int (*task_alloc_security) (struct task_struct *p);
 	void (*task_free_security) (struct task_security *p);
 	int (*task_dup_security) (struct task_security *p);
+	int (*task_kernel_act_as)(struct task_struct *p,
+				  struct task_security *sec, u32 secid);
+	int (*task_create_files_as)(struct task_struct *p,
+				    struct task_security *sec,
+				    struct inode *inode);
 	int (*task_setuid) (uid_t id0, uid_t id1, uid_t id2, int flags);
 	int (*task_post_setuid) (uid_t old_ruid /* or fsuid */ ,
 				 uid_t old_euid, uid_t old_suid, int flags);
@@ -1410,7 +1428,7 @@ struct security_operations {
  	int (*getprocattr)(struct task_struct *p, char *name, char **value);
  	int (*setprocattr)(struct task_struct *p, char *name, void *value, size_t size);
 	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
-	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
+	int (*secctx_to_secid)(const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx)(char *secdata, u32 seclen);
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -1599,6 +1617,11 @@ int security_task_create(unsigned long clone_flags);
 int security_task_alloc(struct task_struct *p);
 void security_task_free(struct task_security *p);
 int security_task_dup(struct task_security *p);
+int security_task_kernel_act_as(struct task_struct *p,
+				struct task_security *sec, u32 secid);
+int security_task_create_files_as(struct task_struct *p,
+				  struct task_security *sec,
+				  struct inode *inode);
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags);
 int security_task_post_setuid(uid_t old_ruid, uid_t old_euid,
 			       uid_t old_suid, int flags);
@@ -1651,7 +1674,7 @@ int security_setprocattr(struct task_struct *p, char *name, void *value, size_t
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_netlink_recv(struct sk_buff *skb, int cap);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
 
 #else /* CONFIG_SECURITY */
@@ -2080,6 +2103,20 @@ static inline int security_task_dup(struct task_security *p)
 	return 0;
 }
 
+static inline int security_task_kernel_act_as(struct task_struct *p,
+					      struct task_security *sec,
+					      u32 secid)
+{
+	return 0;
+}
+
+static inline int security_task_create_files_as(struct task_struct *p,
+						struct task_security *sec,
+						struct inode *inode)
+{
+	return 0;
+}
+
 static inline int security_task_setuid (uid_t id0, uid_t id1, uid_t id2,
 					int flags)
 {
@@ -2331,7 +2368,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 	return -EOPNOTSUPP;
 }
 
-static inline int security_secctx_to_secid(char *secdata,
+static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
 					   u32 *secid)
 {
diff --git a/kernel/cred.c b/kernel/cred.c
index 298f26e..aaa630a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/key.h>
+#include <linux/keyctl.h>
 #include <linux/init_task.h>
 #include <linux/security.h>
 
@@ -138,3 +139,114 @@ void put_task_security(struct task_security *sec)
 	}
 }
 EXPORT_SYMBOL(put_task_security);
+
+/**
+ * get_kernel_security - Get a task security record for a kernel service
+ * @daemon: A userspace daemon to be used as a reference
+ *
+ * Get a task security record for a kernel service.  This can then be used to
+ * override a task's own security so that work can be done on behalf of that
+ * task that requires a different security context.
+ *
+ * @daemon is used to provide a base for the security record, but can be NULL.
+ * If @daemon is supplied, then the security data will be derived from that;
+ * otherwise they'll be set to 0 and no groups, full capabilities and no keys.
+ *
+ * The caller may change these controls afterwards if desired.
+ */
+struct task_security *get_kernel_security(struct task_struct *daemon)
+{
+	const struct task_security *dsec;
+	struct task_security *sec;
+
+	sec = kzalloc(sizeof *sec, GFP_KERNEL);
+	if (!sec)
+		return ERR_PTR(-ENOMEM);
+
+	if (daemon) {
+		rcu_read_lock();
+		dsec = rcu_dereference(daemon->sec);
+		*sec = *dsec;
+		get_group_info(sec->group_info);
+		get_uid(sec->user);
+		rcu_read_unlock();
+#ifdef CONFIG_KEYS
+		sec->request_key_auth = NULL;
+		sec->thread_keyring = NULL;
+		sec->tgsec = NULL;
+#endif
+	} else {
+		sec->keep_capabilities = 0;
+		sec->cap_inheritable = CAP_INIT_INH_SET;
+		sec->cap_permitted = CAP_FULL_SET;
+		sec->cap_effective = CAP_INIT_EFF_SET;
+		sec->cap_bset = CAP_INIT_BSET;
+		sec->user = &root_user;
+		get_uid(sec->user);
+		sec->group_info = &init_groups;
+		get_group_info(sec->group_info);
+	}
+
+	atomic_set(&sec->usage, 1);
+	spin_lock_init(&sec->lock);
+#ifdef CONFIG_KEYS
+	sec->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+#endif
+
+	return sec;
+}
+EXPORT_SYMBOL(get_kernel_security);
+
+/**
+ * set_security_override - Set the security ID in a security record
+ * @sec: The security record to alter
+ * @secid: The LSM security ID to set
+ *
+ * Set the LSM security ID in a security record so that the subjective security
+ * is overridden when the act_as pointer of a task is overridden.
+ */
+int set_security_override(struct task_security *sec, u32 secid)
+{
+	return security_task_kernel_act_as(current, sec, secid);
+}
+EXPORT_SYMBOL(set_security_override);
+
+/**
+ * set_security_override_from_ctx - Set the security ID in a security record
+ * @sec: The security record to alter
+ * @secctx: The LSM security context to generate the security ID from.
+ *
+ * Set the LSM security ID in a security record so that the subjective security
+ * is overridden when the act_as pointer of a task is overridden.  The security
+ * ID is specified in string form as a security context to be interpreted by
+ * the LSM.
+ */
+int set_security_override_from_ctx(struct task_security *sec, const char *secctx)
+{
+	u32 secid;
+	int ret;
+
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	if (ret < 0)
+		return ret;
+
+	return set_security_override(sec, secid);
+}
+EXPORT_SYMBOL(set_security_override_from_ctx);
+
+/**
+ * change_create_files_as - Change the file create context in a security record
+ * @sec: The security record to alter
+ * @inode: The inode to take the context from
+ *
+ * Change the file creation context in a security record to be the same as the
+ * object context of the specified inode, so that the new inodes have the same
+ * MAC context as that inode.
+ */
+int change_create_files_as(struct task_security *sec, struct inode *inode)
+{
+	sec->fsuid = inode->i_uid;
+	sec->fsgid = inode->i_gid;
+	return security_task_create_files_as(current, sec, inode);
+}
+EXPORT_SYMBOL(change_create_files_as);
diff --git a/security/dummy.c b/security/dummy.c
index cc516ab..965504a 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -518,6 +518,19 @@ static int dummy_task_dup_security(struct task_security *p)
 	return 0;
 }
 
+static int dummy_task_kernel_act_as(struct task_struct *p,
+				    struct task_security *sec, u32 secid)
+{
+	return 0;
+}
+
+static int dummy_task_create_files_as(struct task_struct *p,
+				      struct task_security *sec,
+				      struct inode *inode)
+{
+	return 0;
+}
+
 static int dummy_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	return 0;
@@ -966,7 +979,7 @@ static int dummy_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 	return -EOPNOTSUPP;
 }
 
-static int dummy_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+static int dummy_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return -EOPNOTSUPP;
 }
@@ -1093,6 +1106,8 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
 	set_to_dummy_if_null(ops, task_dup_security);
+	set_to_dummy_if_null(ops, task_kernel_act_as);
+	set_to_dummy_if_null(ops, task_create_files_as);
 	set_to_dummy_if_null(ops, task_setuid);
 	set_to_dummy_if_null(ops, task_post_setuid);
 	set_to_dummy_if_null(ops, task_setgid);
diff --git a/security/security.c b/security/security.c
index 3aceeac..e7345e1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -600,6 +600,19 @@ int security_task_dup(struct task_security *sec)
 	return security_ops->task_dup_security(sec);
 }
 
+int security_task_kernel_act_as(struct task_struct *p,
+				struct task_security *sec, u32 secid)
+{
+	return security_ops->task_kernel_act_as(p, sec, secid);
+}
+
+int security_task_create_files_as(struct task_struct *p,
+				  struct task_security *sec,
+				  struct inode *inode)
+{
+	return security_ops->task_create_files_as(p, sec, inode);
+}
+
 int security_task_setuid(uid_t id0, uid_t id1, uid_t id2, int flags)
 {
 	return security_ops->task_setuid(id0, id1, id2, flags);
@@ -838,7 +851,7 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return security_ops->secctx_to_secid(secdata, seclen, secid);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ca180b6..81b2fc0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3097,6 +3097,53 @@ static int selinux_task_dup_security(struct task_security *sec)
 	return 0;
 }
 
+/*
+ * set the security data for a kernel service
+ * - all the creation contexts are set to unlabelled
+ */
+static int selinux_task_kernel_act_as(struct task_struct *p,
+				      struct task_security *sec, u32 secid)
+{
+	struct task_security_struct *tsec = sec->security;
+	struct task_security_struct *ptsec = p->act_as->security;
+	int ret;
+
+ 	ret = avc_has_perm(ptsec->sid, secid,
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
+static int selinux_task_create_files_as(struct task_struct *p,
+					struct task_security *sec,
+					struct inode *inode)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	struct task_security_struct *tsec = sec->security;
+	struct task_security_struct *ptsec = p->act_as->security;
+	int ret;
+
+ 	ret = avc_has_perm(ptsec->sid, isec->sid,
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
@@ -5169,7 +5216,7 @@ static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 	return security_sid_to_context(secid, secdata, seclen);
 }
 
-static int selinux_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+static int selinux_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return security_context_to_sid(secdata, seclen, secid);
 }
@@ -5327,6 +5374,8 @@ static struct security_operations selinux_ops = {
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
 	.task_dup_security =		selinux_task_dup_security,
+	.task_kernel_act_as =		selinux_task_kernel_act_as,
+	.task_create_files_as =		selinux_task_create_files_as,
 	.task_setuid =			selinux_task_setuid,
 	.task_post_setuid =		selinux_task_post_setuid,
 	.task_setgid =			selinux_task_setgid,
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 837ce42..7c1e8ba 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -78,7 +78,7 @@ int security_change_sid(u32 ssid, u32 tsid,
 int security_sid_to_context(u32 sid, char **scontext,
 	u32 *scontext_len);
 
-int security_context_to_sid(char *scontext, u32 scontext_len,
+int security_context_to_sid(const char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
 int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *out_sid, u32 def_sid);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f374186..519b2c1 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -680,7 +680,8 @@ out:
 
 }
 
-static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid)
 {
 	char *scontext2;
 	struct context context;
@@ -806,7 +807,7 @@ out:
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
-int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
+int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
 	                                    sid, SECSID_NULL);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index dbce607..6a3707b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -976,6 +976,36 @@ static int smack_task_dup_security(struct task_security *sec)
 }
 
 /**
+ * smack_task_kernel_act_as - Set the subjective context in a security record
+ * @p points to the task that nominated @secid.
+ * @sec points to the task security record to be modified.
+ * @secid specifies the security ID to be set
+ *
+ * Set the security data for a kernel service.
+ */
+static int smack_task_kernel_act_as(struct task_struct *p,
+				    struct task_security *sec, u32 secid)
+{
+	return -ENOTSUPP;
+}
+
+/**
+ * smack_task_create_files_as - Set the file creation label in a security record
+ * @p points to the task that nominated @inode.
+ * @sec points to the task security record to be modified.
+ * @inode points to the inode to use as a reference.
+ *
+ * Set the file creation context in a security record to the same as the
+ * objective context of the specified inode
+ */
+static int smack_task_create_files_as(struct task_struct *p,
+				      struct task_security *sec,
+				      struct inode *inode)
+{
+	return -ENOTSUPP;
+}
+
+/**
  * smack_task_setpgid - Smack check on setting pgid
  * @p: the task object
  * @pgid: unused
@@ -2444,6 +2474,8 @@ static struct security_operations smack_ops = {
 	.task_alloc_security = 		smack_task_alloc_security,
 	.task_free_security = 		smack_task_free_security,
 	.task_dup_security =		smack_task_dup_security,
+	.task_kernel_act_as =		smack_task_kernel_act_as,
+	.task_create_files_as =		smack_task_create_files_as,
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_setpgid = 		smack_task_setpgid,
 	.task_getpgid = 		smack_task_getpgid,

