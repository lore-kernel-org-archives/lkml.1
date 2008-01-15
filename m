Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYAOXve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYAOXve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYAOXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:48:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYAOXr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:47:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/26] Security: Allow kernel services to override LSM
	settings for task actions
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:47:51 +0000
Message-ID: <20080115234751.22183.35220.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
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

 include/linux/cred.h                |   23 +++++++
 include/linux/security.h            |   42 ++++++++++++-
 kernel/cred.c                       |  111 +++++++++++++++++++++++++++++++++++
 security/dummy.c                    |   17 +++++
 security/security.c                 |   15 ++++-
 security/selinux/hooks.c            |   51 ++++++++++++++++
 security/selinux/include/security.h |    2 -
 security/selinux/ss/services.c      |    5 +-
 8 files changed, 257 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/cred.h


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
index e8f2f2d..5a219ba 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -557,6 +557,19 @@ struct request_sock;
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
@@ -1325,6 +1338,11 @@ struct security_operations {
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
@@ -1393,7 +1411,7 @@ struct security_operations {
  	int (*getprocattr)(struct task_struct *p, char *name, char **value);
  	int (*setprocattr)(struct task_struct *p, char *name, void *value, size_t size);
 	int (*secid_to_secctx)(u32 secid, char **secdata, u32 *seclen);
-	int (*secctx_to_secid)(char *secdata, u32 seclen, u32 *secid);
+	int (*secctx_to_secid)(const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx)(char *secdata, u32 seclen);
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -1576,6 +1594,11 @@ int security_task_create(unsigned long clone_flags);
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
@@ -1628,7 +1651,7 @@ int security_setprocattr(struct task_struct *p, char *name, void *value, size_t
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_netlink_recv(struct sk_buff *skb, int cap);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
 
 #else /* CONFIG_SECURITY */
@@ -2060,6 +2083,19 @@ static inline int security_task_dup(struct task_security *p)
 	return 0;
 }
 
+static inline int security_task_kernel_act_as(struct task_struct *p,
+					      struct task_security *sec,
+					      u32 secid)
+{
+	return 0;
+}
+
+static inline int security_task_create_files_as(struct task_security *sec,
+						struct inode *inode)
+{
+	return 0;
+}
+
 static inline int security_task_setuid (uid_t id0, uid_t id1, uid_t id2,
 					int flags)
 {
@@ -2311,7 +2347,7 @@ static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *secle
 	return -EOPNOTSUPP;
 }
 
-static inline int security_secctx_to_secid(char *secdata,
+static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
 					   u32 *secid)
 {
diff --git a/kernel/cred.c b/kernel/cred.c
index ddf98c6..d740d47 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/key.h>
+#include <linux/keyctl.h>
 #include <linux/init_task.h>
 #include <linux/security.h>
 
@@ -137,3 +138,113 @@ void put_task_security(struct task_security *sec)
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
index 72f1666..139b9de 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -495,6 +495,19 @@ static int dummy_task_dup_security(struct task_security *p)
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
@@ -943,7 +956,7 @@ static int dummy_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 	return -EOPNOTSUPP;
 }
 
-static int dummy_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+static int dummy_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return -EOPNOTSUPP;
 }
@@ -1068,6 +1081,8 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);
 	set_to_dummy_if_null(ops, task_dup_security);
+	set_to_dummy_if_null(ops, task_kernel_act_as);
+	set_to_dummy_if_null(ops, task_create_files_as);
 	set_to_dummy_if_null(ops, task_setuid);
 	set_to_dummy_if_null(ops, task_post_setuid);
 	set_to_dummy_if_null(ops, task_setgid);
diff --git a/security/security.c b/security/security.c
index 1ef4908..a950909 100644
--- a/security/security.c
+++ b/security/security.c
@@ -583,6 +583,19 @@ int security_task_dup(struct task_security *sec)
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
@@ -821,7 +834,7 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return security_ops->secctx_to_secid(secdata, seclen, secid);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1d3eab7..781ed64 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2846,6 +2846,53 @@ static int selinux_task_dup_security(struct task_security *sec)
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
@@ -4734,7 +4781,7 @@ static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 	return security_sid_to_context(secid, secdata, seclen);
 }
 
-static int selinux_secctx_to_secid(char *secdata, u32 seclen, u32 *secid)
+static int selinux_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
 	return security_context_to_sid(secdata, seclen, secid);
 }
@@ -4889,6 +4936,8 @@ static struct security_operations selinux_ops = {
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
 	.task_dup_security =		selinux_task_dup_security,
+	.task_kernel_act_as =		selinux_task_kernel_act_as,
+	.task_create_files_as =		selinux_task_create_files_as,
 	.task_setuid =			selinux_task_setuid,
 	.task_post_setuid =		selinux_task_post_setuid,
 	.task_setgid =			selinux_task_setgid,
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 39337af..727b29e 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -66,7 +66,7 @@ int security_change_sid(u32 ssid, u32 tsid,
 int security_sid_to_context(u32 sid, char **scontext,
 	u32 *scontext_len);
 
-int security_context_to_sid(char *scontext, u32 scontext_len,
+int security_context_to_sid(const char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
 int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *out_sid, u32 def_sid);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index d572dc9..be4bed3 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -677,7 +677,8 @@ out:
 
 }
 
-static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid)
 {
 	char *scontext2;
 	struct context context;
@@ -803,7 +804,7 @@ out:
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
-int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
+int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
 	                                    sid, SECSID_NULL);

