Return-Path: <linux-kernel-owner+w=401wt.eu-S941104AbXHJQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941104AbXHJQLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938250AbXHJQG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:06:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940323AbXHJQGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:06:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/16] CacheFiles: Add an act-as SID override in
	task_security_struct [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:05:48 +0100
Message-ID: <20070810160548.24698.37791.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an act-as SID to task_security_struct that is equivalent to fsuid/fsgid in
task_struct.  This permits a task to perform operations as if it is the
overriding SID, without changing its own SID as that might be needed to control
access to the process by ptrace, signals, /proc, etc.

This is useful for CacheFiles in that it allows CacheFiles to access the cache
files and directories using the cache's security context rather than the
security context of the process on whose behalf it is working, and in the
context of which it is running.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/security.h          |   36 ++++++++
 security/dummy.c                  |   14 +++
 security/selinux/exports.c        |    2 
 security/selinux/hooks.c          |  162 +++++++++++++++++++++++--------------
 security/selinux/include/objsec.h |    1 
 security/selinux/selinuxfs.c      |    2 
 security/selinux/xfrm.c           |    6 +
 7 files changed, 156 insertions(+), 67 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index edd1677..194ef49 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1156,6 +1156,18 @@ struct request_sock;
  *	@secid contains the security ID to set.
  *	@oldsecid points the location in which to return the old security ID.
  *
+ * @act_as_secid:
+ *	Set the security ID as which to act, returning the security ID as which
+ *      the process was previously acting.
+ *	@secid contains the security ID to act as.
+ *	@oldsecid points the location in which to return the displaced security ID.
+ *
+ * @act_as_self:
+ *	Reset the security ID as which to act to be the same as the process's
+ *      owning security ID, and return the security ID as which the process was
+ *      previously acting.
+ *	@oldsecid points the location in which to return the displaced security ID.
+ *
  * This is the main security structure.
  */
 struct security_operations {
@@ -1341,6 +1353,8 @@ struct security_operations {
 	void (*release_secctx)(char *secdata, u32 seclen);
 	int (*get_fscreate_secid)(u32 *secid);
 	int (*set_fscreate_secid)(u32 secid, u32 *oldsecid);
+	int (*act_as_secid)(u32 secid, u32 *oldsecid);
+	int (*act_as_self)(u32 *oldsecid);
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect) (struct socket * sock,
@@ -2148,6 +2162,16 @@ static inline int security_set_fscreate_secid(u32 secid, u32 *oldsecid)
 	return security_ops->set_fscreate_secid(secid, oldsecid);
 }
 
+static inline int security_act_as_secid(u32 secid, u32 *oldsecid)
+{
+	return security_ops->act_as_secid(secid, oldsecid);
+}
+
+static inline int security_act_as_self(u32 *oldsecid)
+{
+	return security_ops->act_as_self(oldsecid);
+}
+
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
@@ -2842,6 +2866,18 @@ static inline int security_set_fscreate_secid(u32 secid, u32 *oldsecid)
 	return 0;
 }
 
+static inline int security_act_as_secid(u32 secid, u32 *oldsecid)
+{
+	*oldsecid = 0;
+	return 0;
+}
+
+static inline u32 security_act_as_self(u32 *oldsecid)
+{
+	*oldsecid = 0;
+	return 0;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/security/dummy.c b/security/dummy.c
index 9e81edb..1a0be85 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -942,6 +942,18 @@ static int dummy_set_fscreate_secid(u32 secid, u32 *oldsecid)
 	return 0;
 }
 
+static int dummy_act_as_secid(u32 secid, u32 *oldsecid)
+{
+	*oldsecid = 0;
+	return 0;
+}
+
+static int dummy_act_as_self(u32 *oldsecid)
+{
+	*oldsecid = 0;
+	return 0;
+}
+
 #ifdef CONFIG_KEYS
 static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
 				  unsigned long flags)
@@ -1098,6 +1110,8 @@ void security_fixup_ops (struct security_operations *ops)
  	set_to_dummy_if_null(ops, release_secctx);
  	set_to_dummy_if_null(ops, get_fscreate_secid);
  	set_to_dummy_if_null(ops, set_fscreate_secid);
+ 	set_to_dummy_if_null(ops, act_as_secid);
+ 	set_to_dummy_if_null(ops, act_as_self);
 #ifdef CONFIG_SECURITY_NETWORK
 	set_to_dummy_if_null(ops, unix_stream_connect);
 	set_to_dummy_if_null(ops, unix_may_send);
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index b6f9694..b559699 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -79,7 +79,7 @@ int selinux_relabel_packet_permission(u32 sid)
 	if (selinux_enabled) {
 		struct task_security_struct *tsec = current->security;
 
-		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
+		return avc_has_perm(tsec->actor_sid, sid, SECCLASS_PACKET,
 				    PACKET__RELABELTO, NULL);
 	}
 	return 0;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f82a03d..2c64ec8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -162,7 +162,8 @@ static int task_alloc_security(struct task_struct *task)
 		return -ENOMEM;
 
 	tsec->task = task;
-	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
+	tsec->osid = tsec->actor_sid = tsec->sid = tsec->ptrace_sid =
+		SECINITSID_UNLABELED;
 	task->security = tsec;
 
 	return 0;
@@ -189,7 +190,7 @@ static int inode_alloc_security(struct inode *inode)
 	isec->inode = inode;
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
-	isec->task_sid = tsec->sid;
+	isec->task_sid = tsec->actor_sid;
 	inode->i_security = isec;
 
 	return 0;
@@ -219,8 +220,8 @@ static int file_alloc_security(struct file *file)
 		return -ENOMEM;
 
 	fsec->file = file;
-	fsec->sid = tsec->sid;
-	fsec->fown_sid = tsec->sid;
+	fsec->sid = tsec->actor_sid;
+	fsec->fown_sid = tsec->actor_sid;
 	file->f_security = fsec;
 
 	return 0;
@@ -337,12 +338,12 @@ static int may_context_mount_sb_relabel(u32 sid,
 {
 	int rc;
 
-	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
+	rc = avc_has_perm(tsec->actor_sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
 	if (rc)
 		return rc;
 
-	rc = avc_has_perm(tsec->sid, sid, SECCLASS_FILESYSTEM,
+	rc = avc_has_perm(tsec->actor_sid, sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELTO, NULL);
 	return rc;
 }
@@ -352,7 +353,7 @@ static int may_context_mount_inode_relabel(u32 sid,
 			struct task_security_struct *tsec)
 {
 	int rc;
-	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
+	rc = avc_has_perm(tsec->actor_sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
 	if (rc)
 		return rc;
@@ -1031,7 +1032,7 @@ static int task_has_perm(struct task_struct *tsk1,
 
 	tsec1 = tsk1->security;
 	tsec2 = tsk2->security;
-	return avc_has_perm(tsec1->sid, tsec2->sid,
+	return avc_has_perm(tsec1->actor_sid, tsec2->sid,
 			    SECCLASS_PROCESS, perms, NULL);
 }
 
@@ -1048,7 +1049,7 @@ static int task_has_capability(struct task_struct *tsk,
 	ad.tsk = tsk;
 	ad.u.cap = cap;
 
-	return avc_has_perm(tsec->sid, tsec->sid,
+	return avc_has_perm(tsec->actor_sid, tsec->actor_sid,
 			    SECCLASS_CAPABILITY, CAP_TO_MASK(cap), &ad);
 }
 
@@ -1060,7 +1061,7 @@ static int task_has_system(struct task_struct *tsk,
 
 	tsec = tsk->security;
 
-	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
+	return avc_has_perm(tsec->actor_sid, SECINITSID_KERNEL,
 			    SECCLASS_SYSTEM, perms, NULL);
 }
 
@@ -1088,7 +1089,8 @@ static int inode_has_perm(struct task_struct *tsk,
 		ad.u.fs.inode = inode;
 	}
 
-	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, adp);
+	return avc_has_perm(tsec->actor_sid, isec->sid, isec->sclass, perms,
+			    adp);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -1131,8 +1133,8 @@ static int file_has_perm(struct task_struct *tsk,
 	ad.u.fs.mnt = mnt;
 	ad.u.fs.dentry = dentry;
 
-	if (tsec->sid != fsec->sid) {
-		rc = avc_has_perm(tsec->sid, fsec->sid,
+	if (tsec->actor_sid != fsec->sid) {
+		rc = avc_has_perm(tsec->actor_sid, fsec->sid,
 				  SECCLASS_FD,
 				  FD__USE,
 				  &ad);
@@ -1166,7 +1168,7 @@ static int may_create(struct inode *dir,
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.dentry = dentry;
 
-	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR,
+	rc = avc_has_perm(tsec->actor_sid, dsec->sid, SECCLASS_DIR,
 			  DIR__ADD_NAME | DIR__SEARCH,
 			  &ad);
 	if (rc)
@@ -1175,13 +1177,13 @@ static int may_create(struct inode *dir,
 	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
 		newsid = tsec->create_sid;
 	} else {
-		rc = security_transition_sid(tsec->sid, dsec->sid, tclass,
-					     &newsid);
+		rc = security_transition_sid(tsec->actor_sid, dsec->sid,
+					     tclass, &newsid);
 		if (rc)
 			return rc;
 	}
 
-	rc = avc_has_perm(tsec->sid, newsid, tclass, FILE__CREATE, &ad);
+	rc = avc_has_perm(tsec->actor_sid, newsid, tclass, FILE__CREATE, &ad);
 	if (rc)
 		return rc;
 
@@ -1198,7 +1200,8 @@ static int may_create_key(u32 ksid,
 
 	tsec = ctx->security;
 
-	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
+	return avc_has_perm(tsec->actor_sid, ksid, SECCLASS_KEY, KEY__CREATE,
+			    NULL);
 }
 
 #define MAY_LINK   0
@@ -1226,7 +1229,7 @@ static int may_link(struct inode *dir,
 
 	av = DIR__SEARCH;
 	av |= (kind ? DIR__REMOVE_NAME : DIR__ADD_NAME);
-	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR, av, &ad);
+	rc = avc_has_perm(tsec->actor_sid, dsec->sid, SECCLASS_DIR, av, &ad);
 	if (rc)
 		return rc;
 
@@ -1245,7 +1248,7 @@ static int may_link(struct inode *dir,
 		return 0;
 	}
 
-	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass, av, &ad);
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, isec->sclass, av, &ad);
 	return rc;
 }
 
@@ -1270,16 +1273,16 @@ static inline int may_rename(struct inode *old_dir,
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 
 	ad.u.fs.dentry = old_dentry;
-	rc = avc_has_perm(tsec->sid, old_dsec->sid, SECCLASS_DIR,
+	rc = avc_has_perm(tsec->actor_sid, old_dsec->sid, SECCLASS_DIR,
 			  DIR__REMOVE_NAME | DIR__SEARCH, &ad);
 	if (rc)
 		return rc;
-	rc = avc_has_perm(tsec->sid, old_isec->sid,
+	rc = avc_has_perm(tsec->actor_sid, old_isec->sid,
 			  old_isec->sclass, FILE__RENAME, &ad);
 	if (rc)
 		return rc;
 	if (old_is_dir && new_dir != old_dir) {
-		rc = avc_has_perm(tsec->sid, old_isec->sid,
+		rc = avc_has_perm(tsec->actor_sid, old_isec->sid,
 				  old_isec->sclass, DIR__REPARENT, &ad);
 		if (rc)
 			return rc;
@@ -1289,15 +1292,17 @@ static inline int may_rename(struct inode *old_dir,
 	av = DIR__ADD_NAME | DIR__SEARCH;
 	if (new_dentry->d_inode)
 		av |= DIR__REMOVE_NAME;
-	rc = avc_has_perm(tsec->sid, new_dsec->sid, SECCLASS_DIR, av, &ad);
+	rc = avc_has_perm(tsec->actor_sid, new_dsec->sid, SECCLASS_DIR, av,
+			  &ad);
 	if (rc)
 		return rc;
 	if (new_dentry->d_inode) {
 		new_isec = new_dentry->d_inode->i_security;
 		new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
-		rc = avc_has_perm(tsec->sid, new_isec->sid,
+		rc = avc_has_perm(tsec->actor_sid, new_isec->sid,
 				  new_isec->sclass,
-				  (new_is_dir ? DIR__RMDIR : FILE__UNLINK), &ad);
+				  (new_is_dir ? DIR__RMDIR : FILE__UNLINK),
+				  &ad);
 		if (rc)
 			return rc;
 	}
@@ -1316,7 +1321,7 @@ static int superblock_has_perm(struct task_struct *tsk,
 
 	tsec = tsk->security;
 	sbsec = sb->s_security;
-	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
+	return avc_has_perm(tsec->actor_sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			    perms, ad);
 }
 
@@ -1380,7 +1385,7 @@ static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
 	rc = task_has_perm(parent, child, PROCESS__PTRACE);
 	/* Save the SID of the tracing process for later use in apply_creds. */
 	if (!(child->ptrace & PT_PTRACED) && !rc)
-		csec->ptrace_sid = psec->sid;
+		csec->ptrace_sid = psec->actor_sid;
 	return rc;
 }
 
@@ -1490,7 +1495,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 	/* The op values are "defined" in sysctl.c, thereby creating
 	 * a bad coupling between this module and sysctl.c */
 	if(op == 001) {
-		error = avc_has_perm(tsec->sid, tsid,
+		error = avc_has_perm(tsec->actor_sid, tsid,
 				     SECCLASS_DIR, DIR__SEARCH, NULL);
 	} else {
 		av = 0;
@@ -1499,7 +1504,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 		if (op & 002)
 			av |= FILE__WRITE;
 		if (av)
-			error = avc_has_perm(tsec->sid, tsid,
+			error = avc_has_perm(tsec->actor_sid, tsid,
 					     SECCLASS_FILE, av, NULL);
         }
 
@@ -1591,7 +1596,7 @@ static int selinux_vm_enough_memory(long pages)
 
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
-		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
+		rc = avc_has_perm_noaudit(tsec->actor_sid, tsec->actor_sid,
 					  SECCLASS_CAPABILITY,
 					  CAP_TO_MASK(CAP_SYS_ADMIN),
 					  0,
@@ -1644,7 +1649,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
-	bsec->sid = tsec->sid;
+	bsec->sid = tsec->actor_sid;
 
 	/* Reset fs, key, and sock SIDs on execve. */
 	tsec->create_sid = 0;
@@ -1657,7 +1662,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 		tsec->exec_sid = 0;
 	} else {
 		/* Check for a default transition on this program. */
-		rc = security_transition_sid(tsec->sid, isec->sid,
+		rc = security_transition_sid(tsec->actor_sid, isec->sid,
 		                             SECCLASS_PROCESS, &newsid);
 		if (rc)
 			return rc;
@@ -1668,16 +1673,16 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	ad.u.fs.dentry = bprm->file->f_path.dentry;
 
 	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
-		newsid = tsec->sid;
+		newsid = tsec->actor_sid;
 
-        if (tsec->sid == newsid) {
-		rc = avc_has_perm(tsec->sid, isec->sid,
+        if (tsec->actor_sid == newsid) {
+		rc = avc_has_perm(tsec->actor_sid, isec->sid,
 				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
 	} else {
 		/* Check permissions for the transition. */
-		rc = avc_has_perm(tsec->sid, newsid,
+		rc = avc_has_perm(tsec->actor_sid, newsid,
 				  SECCLASS_PROCESS, PROCESS__TRANSITION, &ad);
 		if (rc)
 			return rc;
@@ -1859,6 +1864,8 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 				return;
 			}
 		}
+		if (tsec->actor_sid == tsec->sid)
+			tsec->actor_sid = sid;
 		tsec->sid = sid;
 	}
 }
@@ -2133,7 +2140,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
 		newsid = tsec->create_sid;
 	} else {
-		rc = security_transition_sid(tsec->sid, dsec->sid,
+		rc = security_transition_sid(tsec->actor_sid, dsec->sid,
 					     inode_mode_to_security_class(inode->i_mode),
 					     &newsid);
 		if (rc) {
@@ -2324,7 +2331,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
 	AVC_AUDIT_DATA_INIT(&ad,FS);
 	ad.u.fs.dentry = dentry;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, isec->sclass,
 			  FILE__RELABELFROM, &ad);
 	if (rc)
 		return rc;
@@ -2333,12 +2340,12 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
 	if (rc)
 		return rc;
 
-	rc = avc_has_perm(tsec->sid, newsid, isec->sclass,
+	rc = avc_has_perm(tsec->actor_sid, newsid, isec->sclass,
 			  FILE__RELABELTO, &ad);
 	if (rc)
 		return rc;
 
-	rc = security_validate_transition(isec->sid, newsid, tsec->sid,
+	rc = security_validate_transition(isec->sid, newsid, tsec->actor_sid,
 	                                  isec->sclass);
 	if (rc)
 		return rc;
@@ -2746,7 +2753,7 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
 	tsec2 = tsk->security;
 
 	tsec2->osid = tsec1->osid;
-	tsec2->sid = tsec1->sid;
+	tsec2->actor_sid = tsec2->sid = tsec1->sid;
 
 	/* Retain the exec, fs, key, and sock SIDs across fork */
 	tsec2->exec_sid = tsec1->exec_sid;
@@ -2925,6 +2932,8 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 
 	tsec = p->security;
 	tsec->osid = tsec->sid;
+	if (tsec->actor_sid == tsec->sid)
+		tsec->actor_sid = SECINITSID_KERNEL;
 	tsec->sid = SECINITSID_KERNEL;
 	return;
 }
@@ -3172,7 +3181,8 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
 
 	AVC_AUDIT_DATA_INIT(&ad,NET);
 	ad.u.net.sk = sock->sk;
-	err = avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
+	err = avc_has_perm(tsec->actor_sid, isec->sid, isec->sclass, perms,
+			   &ad);
 
 out:
 	return err;
@@ -3189,8 +3199,8 @@ static int selinux_socket_create(int family, int type,
 		goto out;
 
 	tsec = current->security;
-	newsid = tsec->sockcreate_sid ? : tsec->sid;
-	err = avc_has_perm(tsec->sid, newsid,
+	newsid = tsec->sockcreate_sid ? : tsec->actor_sid;
+	err = avc_has_perm(tsec->actor_sid, newsid,
 			   socket_type_to_security_class(family, type,
 			   protocol), SOCKET__CREATE, NULL);
 
@@ -3210,7 +3220,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 	isec = SOCK_INODE(sock)->i_security;
 
 	tsec = current->security;
-	newsid = tsec->sockcreate_sid ? : tsec->sid;
+	newsid = tsec->sockcreate_sid ? : tsec->actor_sid;
 	isec->sclass = socket_type_to_security_class(family, type, protocol);
 	isec->sid = kern ? SECINITSID_KERNEL : newsid;
 	isec->initialized = 1;
@@ -4033,7 +4043,7 @@ static int ipc_alloc_security(struct task_struct *task,
 
 	isec->sclass = sclass;
 	isec->ipc_perm = perm;
-	isec->sid = tsec->sid;
+	isec->sid = tsec->actor_sid;
 	perm->security = isec;
 
 	return 0;
@@ -4082,7 +4092,8 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = ipc_perms->key;
 
-	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
+	return avc_has_perm(tsec->actor_sid, isec->sid, isec->sclass, perms,
+			    &ad);
 }
 
 static int selinux_msg_msg_alloc_security(struct msg_msg *msg)
@@ -4113,7 +4124,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
  	ad.u.ipc_id = msq->q_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_MSGQ,
 			  MSGQ__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&msq->q_perm);
@@ -4139,7 +4150,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = msq->q_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	return avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_MSGQ,
 			    MSGQ__ASSOCIATE, &ad);
 }
 
@@ -4191,7 +4202,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 		 * Compute new sid based on current process and
 		 * message queue this message will be stored in
 		 */
-		rc = security_transition_sid(tsec->sid,
+		rc = security_transition_sid(tsec->actor_sid,
 					     isec->sid,
 					     SECCLASS_MSG,
 					     &msec->sid);
@@ -4203,11 +4214,11 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	ad.u.ipc_id = msq->q_perm.key;
 
 	/* Can this process write to the queue? */
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_MSGQ,
 			  MSGQ__WRITE, &ad);
 	if (!rc)
 		/* Can this process send the message */
-		rc = avc_has_perm(tsec->sid, msec->sid,
+		rc = avc_has_perm(tsec->actor_sid, msec->sid,
 				  SECCLASS_MSG, MSG__SEND, &ad);
 	if (!rc)
 		/* Can the message be put in the queue? */
@@ -4234,10 +4245,10 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
  	ad.u.ipc_id = msq->q_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid,
 			  SECCLASS_MSGQ, MSGQ__READ, &ad);
 	if (!rc)
-		rc = avc_has_perm(tsec->sid, msec->sid,
+		rc = avc_has_perm(tsec->actor_sid, msec->sid,
 				  SECCLASS_MSG, MSG__RECEIVE, &ad);
 	return rc;
 }
@@ -4260,7 +4271,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
  	ad.u.ipc_id = shp->shm_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_SHM,
 			  SHM__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&shp->shm_perm);
@@ -4286,7 +4297,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = shp->shm_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
+	return avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_SHM,
 			    SHM__ASSOCIATE, &ad);
 }
 
@@ -4359,7 +4370,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
  	ad.u.ipc_id = sma->sem_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
+	rc = avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_SEM,
 			  SEM__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&sma->sem_perm);
@@ -4385,7 +4396,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = sma->sem_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
+	return avc_has_perm(tsec->actor_sid, isec->sid, SECCLASS_SEM,
 			    SEM__ASSOCIATE, &ad);
 }
 
@@ -4633,14 +4644,19 @@ static int selinux_setprocattr(struct task_struct *p,
 			error = avc_has_perm_noaudit(tsec->ptrace_sid, sid,
 						     SECCLASS_PROCESS,
 						     PROCESS__PTRACE, 0, &avd);
-			if (!error)
+			if (!error) {
+				if (tsec->actor_sid == tsec->sid)
+					tsec->actor_sid = sid;
 				tsec->sid = sid;
+			}
 			task_unlock(p);
 			avc_audit(tsec->ptrace_sid, sid, SECCLASS_PROCESS,
 				  PROCESS__PTRACE, &avd, error, NULL);
 			if (error)
 				return error;
 		} else {
+			if (tsec->actor_sid == tsec->sid)
+				tsec->actor_sid = sid;
 			tsec->sid = sid;
 			task_unlock(p);
 		}
@@ -4679,6 +4695,26 @@ static int selinux_set_fscreate_secid(u32 secid, u32 *oldsecid)
 	return 0;
 }
 
+static int selinux_act_as_secid(u32 secid, u32 *oldsecid)
+{
+	struct task_security_struct *tsec = current->security;
+	u32 oldactor_sid = tsec->actor_sid;
+
+	tsec->actor_sid = secid;
+	*oldsecid = oldactor_sid;
+	return 0;
+}
+
+static int selinux_act_as_self(u32 *oldsecid)
+{
+	struct task_security_struct *tsec = current->security;
+	u32 oldactor_sid = tsec->actor_sid;
+
+	tsec->actor_sid = tsec->sid;
+	*oldsecid = oldactor_sid;
+	return 0;
+}
+
 #ifdef CONFIG_KEYS
 
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
@@ -4728,7 +4764,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 	if (perm == 0)
 		return 0;
 
-	return avc_has_perm(tsec->sid, ksec->sid,
+	return avc_has_perm(tsec->actor_sid, ksec->sid,
 			    SECCLASS_KEY, perm, NULL);
 }
 
@@ -4863,6 +4899,8 @@ static struct security_operations selinux_ops = {
 	.release_secctx =		selinux_release_secctx,
 	.get_fscreate_secid =		selinux_get_fscreate_secid,
 	.set_fscreate_secid =		selinux_set_fscreate_secid,
+	.act_as_secid =			selinux_act_as_secid,
+	.act_as_self =			selinux_act_as_self,
 
         .unix_stream_connect =		selinux_socket_unix_stream_connect,
 	.unix_may_send =		selinux_socket_unix_may_send,
@@ -4928,7 +4966,7 @@ static __init int selinux_init(void)
 	if (task_alloc_security(current))
 		panic("SELinux:  Failed to initialize initial task.\n");
 	tsec = current->security;
-	tsec->osid = tsec->sid = SECINITSID_KERNEL;
+	tsec->osid = tsec->actor_sid = tsec->sid = SECINITSID_KERNEL;
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
 					    sizeof(struct inode_security_struct),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91b88f0..884df98 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -31,6 +31,7 @@ struct task_security_struct {
 	struct task_struct *task;      /* back pointer to task object */
 	u32 osid;            /* SID prior to last execve */
 	u32 sid;             /* current SID */
+	u32 actor_sid;       /* act-as SID (normally == sid) */
 	u32 exec_sid;        /* exec SID */
 	u32 create_sid;      /* fscreate SID */
 	u32 keycreate_sid;   /* keycreate SID */
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c9e92da..8df8e6a 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -83,7 +83,7 @@ static int task_has_security(struct task_struct *tsk,
 	if (!tsec)
 		return -EACCES;
 
-	return avc_has_perm(tsec->sid, SECINITSID_SECURITY,
+	return avc_has_perm(tsec->actor_sid, SECINITSID_SECURITY,
 			    SECCLASS_SECURITY, perms, NULL);
 }
 
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index ba715f4..873b6ba 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -240,7 +240,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	/*
 	 * Does the subject have permission to set security context?
 	 */
-	rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
+	rc = avc_has_perm(tsec->actor_sid, ctx->ctx_sid,
 			  SECCLASS_ASSOCIATION,
 			  ASSOCIATION__SETCONTEXT, NULL);
 	if (rc)
@@ -341,7 +341,7 @@ int selinux_xfrm_policy_delete(struct xfrm_policy *xp)
 	int rc = 0;
 
 	if (ctx)
-		rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
+		rc = avc_has_perm(tsec->actor_sid, ctx->ctx_sid,
 				  SECCLASS_ASSOCIATION,
 				  ASSOCIATION__SETCONTEXT, NULL);
 
@@ -383,7 +383,7 @@ int selinux_xfrm_state_delete(struct xfrm_state *x)
 	int rc = 0;
 
 	if (ctx)
-		rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
+		rc = avc_has_perm(tsec->actor_sid, ctx->ctx_sid,
 				  SECCLASS_ASSOCIATION,
 				  ASSOCIATION__SETCONTEXT, NULL);
 

