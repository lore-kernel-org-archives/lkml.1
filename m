Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYHFPkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYHFPkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbYHFPjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbYHFPif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:38:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/24] CRED: Wrap access to SELinux's task SID [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:16 +0100
Message-ID: <20080806153816.14351.28421.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to SELinux's task SID, using task_sid() and current_sid() as
appropriate.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---

 security/selinux/hooks.c |  416 ++++++++++++++++++++++++----------------------
 1 files changed, 220 insertions(+), 196 deletions(-)


diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1efc990..27d1779 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -171,10 +171,35 @@ static int cred_alloc_security(struct cred *cred)
 	return 0;
 }
 
+/*
+ * get the security ID of a task
+ */
+static inline u32 task_sid(const struct task_struct *task)
+{
+	const struct task_security_struct *tsec;
+	u32 sid;
+
+	rcu_read_lock();
+	tsec = __task_cred(task)->security;
+	sid = tsec->sid;
+	rcu_read_unlock();
+	return sid;
+}
+
+/*
+ * get the security ID of the current task
+ */
+static inline u32 current_sid(void)
+{
+	const struct task_security_struct *tsec = current_cred()->security;
+
+	return tsec->sid;
+}
+
 static int inode_alloc_security(struct inode *inode)
 {
-	struct task_security_struct *tsec = current->cred->security;
 	struct inode_security_struct *isec;
+	u32 sid = current_sid();
 
 	isec = kmem_cache_zalloc(sel_inode_cache, GFP_NOFS);
 	if (!isec)
@@ -185,7 +210,7 @@ static int inode_alloc_security(struct inode *inode)
 	isec->inode = inode;
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
-	isec->task_sid = tsec->sid;
+	isec->task_sid = sid;
 	inode->i_security = isec;
 
 	return 0;
@@ -207,15 +232,15 @@ static void inode_free_security(struct inode *inode)
 
 static int file_alloc_security(struct file *file)
 {
-	struct task_security_struct *tsec = current->cred->security;
 	struct file_security_struct *fsec;
+	u32 sid = current_sid();
 
 	fsec = kzalloc(sizeof(struct file_security_struct), GFP_KERNEL);
 	if (!fsec)
 		return -ENOMEM;
 
-	fsec->sid = tsec->sid;
-	fsec->fown_sid = tsec->sid;
+	fsec->sid = sid;
+	fsec->fown_sid = sid;
 	file->f_security = fsec;
 
 	return 0;
@@ -329,8 +354,9 @@ static match_table_t tokens = {
 
 static int may_context_mount_sb_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
-			struct task_security_struct *tsec)
+			const struct cred *cred)
 {
+	const struct task_security_struct *tsec = cred->security;
 	int rc;
 
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
@@ -345,8 +371,9 @@ static int may_context_mount_sb_relabel(u32 sid,
 
 static int may_context_mount_inode_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
-			struct task_security_struct *tsec)
+			const struct cred *cred)
 {
+	const struct task_security_struct *tsec = cred->security;
 	int rc;
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
@@ -544,8 +571,8 @@ static int bad_option(struct superblock_security_struct *sbsec, char flag,
 static int selinux_set_mnt_opts(struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
+	const struct cred *cred = current_cred();
 	int rc = 0, i;
-	struct task_security_struct *tsec = current->cred->security;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *name = sb->s_type->name;
 	struct inode *inode = sbsec->sb->s_root->d_inode;
@@ -671,8 +698,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 
 	/* sets the context of the superblock for the fs being mounted. */
 	if (fscontext_sid) {
-
-		rc = may_context_mount_sb_relabel(fscontext_sid, sbsec, tsec);
+		rc = may_context_mount_sb_relabel(fscontext_sid, sbsec, cred);
 		if (rc)
 			goto out;
 
@@ -686,12 +712,14 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	 */
 	if (context_sid) {
 		if (!fscontext_sid) {
-			rc = may_context_mount_sb_relabel(context_sid, sbsec, tsec);
+			rc = may_context_mount_sb_relabel(context_sid, sbsec,
+							  cred);
 			if (rc)
 				goto out;
 			sbsec->sid = context_sid;
 		} else {
-			rc = may_context_mount_inode_relabel(context_sid, sbsec, tsec);
+			rc = may_context_mount_inode_relabel(context_sid, sbsec,
+							     cred);
 			if (rc)
 				goto out;
 		}
@@ -703,7 +731,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	}
 
 	if (rootcontext_sid) {
-		rc = may_context_mount_inode_relabel(rootcontext_sid, sbsec, tsec);
+		rc = may_context_mount_inode_relabel(rootcontext_sid, sbsec,
+						     cred);
 		if (rc)
 			goto out;
 
@@ -721,7 +750,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 
 		if (defcontext_sid != sbsec->def_sid) {
 			rc = may_context_mount_inode_relabel(defcontext_sid,
-							     sbsec, tsec);
+							     sbsec, cred);
 			if (rc)
 				goto out;
 		}
@@ -1336,18 +1365,23 @@ static inline u32 signal_to_av(int sig)
 	return perm;
 }
 
-/* Check permission betweeen a pair of tasks, e.g. signal checks,
-   fork check, ptrace check, etc. */
-static int task_has_perm(struct task_struct *tsk1,
-			 struct task_struct *tsk2,
+/*
+ * Check permission betweeen a pair of tasks, e.g. signal checks,
+ * fork check, ptrace check, etc.
+ * tsk1 is the actor and tsk2 is the target
+ */
+static int task_has_perm(const struct task_struct *tsk1,
+			 const struct task_struct *tsk2,
 			 u32 perms)
 {
-	struct task_security_struct *tsec1, *tsec2;
+	const struct task_security_struct *__tsec1, *__tsec2;
+	u32 sid1, sid2;
 
-	tsec1 = tsk1->cred->security;
-	tsec2 = tsk2->cred->security;
-	return avc_has_perm(tsec1->sid, tsec2->sid,
-			    SECCLASS_PROCESS, perms, NULL);
+	rcu_read_lock();
+	__tsec1 = __task_cred(tsk1)->security;	sid1 = __tsec1->sid;
+	__tsec2 = __task_cred(tsk2)->security;	sid2 = __tsec2->sid;
+	rcu_read_unlock();
+	return avc_has_perm(sid1, sid2, SECCLASS_PROCESS, perms, NULL);
 }
 
 #if CAP_LAST_CAP > 63
@@ -1358,13 +1392,11 @@ static int task_has_perm(struct task_struct *tsk1,
 static int task_has_capability(struct task_struct *tsk,
 			       int cap)
 {
-	struct task_security_struct *tsec;
 	struct avc_audit_data ad;
 	u16 sclass;
+	u32 sid = task_sid(tsk);
 	u32 av = CAP_TO_MASK(cap);
 
-	tsec = tsk->cred->security;
-
 	AVC_AUDIT_DATA_INIT(&ad, CAP);
 	ad.tsk = tsk;
 	ad.u.cap = cap;
@@ -1381,18 +1413,16 @@ static int task_has_capability(struct task_struct *tsk,
 		       "SELinux:  out of range capability %d\n", cap);
 		BUG();
 	}
-	return avc_has_perm(tsec->sid, tsec->sid, sclass, av, &ad);
+	return avc_has_perm(sid, sid, sclass, av, &ad);
 }
 
 /* Check whether a task is allowed to use a system operation. */
 static int task_has_system(struct task_struct *tsk,
 			   u32 perms)
 {
-	struct task_security_struct *tsec;
-
-	tsec = tsk->cred->security;
+	u32 sid = task_sid(tsk);
 
-	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
+	return avc_has_perm(sid, SECINITSID_KERNEL,
 			    SECCLASS_SYSTEM, perms, NULL);
 }
 
@@ -1404,14 +1434,14 @@ static int inode_has_perm(struct task_struct *tsk,
 			  u32 perms,
 			  struct avc_audit_data *adp)
 {
-	struct task_security_struct *tsec;
 	struct inode_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid;
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	tsec = tsk->cred->security;
+	sid = task_sid(tsk);
 	isec = inode->i_security;
 
 	if (!adp) {
@@ -1420,7 +1450,7 @@ static int inode_has_perm(struct task_struct *tsk,
 		ad.u.fs.inode = inode;
 	}
 
-	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, adp);
+	return avc_has_perm(sid, isec->sid, isec->sclass, perms, adp);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -1451,17 +1481,17 @@ static int file_has_perm(struct task_struct *tsk,
 				struct file *file,
 				u32 av)
 {
-	struct task_security_struct *tsec = tsk->cred->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct avc_audit_data ad;
+	u32 sid = task_sid(tsk);
 	int rc;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path = file->f_path;
 
-	if (tsec->sid != fsec->sid) {
-		rc = avc_has_perm(tsec->sid, fsec->sid,
+	if (sid != fsec->sid) {
+		rc = avc_has_perm(sid, fsec->sid,
 				  SECCLASS_FD,
 				  FD__USE,
 				  &ad);
@@ -1481,36 +1511,36 @@ static int may_create(struct inode *dir,
 		      struct dentry *dentry,
 		      u16 tclass)
 {
-	struct task_security_struct *tsec;
+	const struct cred *cred = current_cred();
+	const struct task_security_struct *tsec = cred->security;
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
-	u32 newsid;
+	u32 sid, newsid;
 	struct avc_audit_data ad;
 	int rc;
 
-	tsec = current->cred->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
+	sid = tsec->sid;
+	newsid = tsec->create_sid;
+
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.dentry = dentry;
 
-	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR,
+	rc = avc_has_perm(sid, dsec->sid, SECCLASS_DIR,
 			  DIR__ADD_NAME | DIR__SEARCH,
 			  &ad);
 	if (rc)
 		return rc;
 
-	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
-		newsid = tsec->create_sid;
-	} else {
-		rc = security_transition_sid(tsec->sid, dsec->sid, tclass,
-					     &newsid);
+	if (!newsid || sbsec->behavior == SECURITY_FS_USE_MNTPOINT) {
+		rc = security_transition_sid(sid, dsec->sid, tclass, &newsid);
 		if (rc)
 			return rc;
 	}
 
-	rc = avc_has_perm(tsec->sid, newsid, tclass, FILE__CREATE, &ad);
+	rc = avc_has_perm(sid, newsid, tclass, FILE__CREATE, &ad);
 	if (rc)
 		return rc;
 
@@ -1523,11 +1553,9 @@ static int may_create(struct inode *dir,
 static int may_create_key(u32 ksid,
 			  struct task_struct *ctx)
 {
-	struct task_security_struct *tsec;
-
-	tsec = ctx->cred->security;
+	u32 sid = task_sid(ctx);
 
-	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
+	return avc_has_perm(sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
 }
 
 #define MAY_LINK	0
@@ -1540,13 +1568,12 @@ static int may_link(struct inode *dir,
 		    int kind)
 
 {
-	struct task_security_struct *tsec;
 	struct inode_security_struct *dsec, *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	u32 av;
 	int rc;
 
-	tsec = current->cred->security;
 	dsec = dir->i_security;
 	isec = dentry->d_inode->i_security;
 
@@ -1555,7 +1582,7 @@ static int may_link(struct inode *dir,
 
 	av = DIR__SEARCH;
 	av |= (kind ? DIR__REMOVE_NAME : DIR__ADD_NAME);
-	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR, av, &ad);
+	rc = avc_has_perm(sid, dsec->sid, SECCLASS_DIR, av, &ad);
 	if (rc)
 		return rc;
 
@@ -1575,7 +1602,7 @@ static int may_link(struct inode *dir,
 		return 0;
 	}
 
-	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass, av, &ad);
+	rc = avc_has_perm(sid, isec->sid, isec->sclass, av, &ad);
 	return rc;
 }
 
@@ -1584,14 +1611,13 @@ static inline int may_rename(struct inode *old_dir,
 			     struct inode *new_dir,
 			     struct dentry *new_dentry)
 {
-	struct task_security_struct *tsec;
 	struct inode_security_struct *old_dsec, *new_dsec, *old_isec, *new_isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	u32 av;
 	int old_is_dir, new_is_dir;
 	int rc;
 
-	tsec = current->cred->security;
 	old_dsec = old_dir->i_security;
 	old_isec = old_dentry->d_inode->i_security;
 	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
@@ -1600,16 +1626,16 @@ static inline int may_rename(struct inode *old_dir,
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 
 	ad.u.fs.path.dentry = old_dentry;
-	rc = avc_has_perm(tsec->sid, old_dsec->sid, SECCLASS_DIR,
+	rc = avc_has_perm(sid, old_dsec->sid, SECCLASS_DIR,
 			  DIR__REMOVE_NAME | DIR__SEARCH, &ad);
 	if (rc)
 		return rc;
-	rc = avc_has_perm(tsec->sid, old_isec->sid,
+	rc = avc_has_perm(sid, old_isec->sid,
 			  old_isec->sclass, FILE__RENAME, &ad);
 	if (rc)
 		return rc;
 	if (old_is_dir && new_dir != old_dir) {
-		rc = avc_has_perm(tsec->sid, old_isec->sid,
+		rc = avc_has_perm(sid, old_isec->sid,
 				  old_isec->sclass, DIR__REPARENT, &ad);
 		if (rc)
 			return rc;
@@ -1619,13 +1645,13 @@ static inline int may_rename(struct inode *old_dir,
 	av = DIR__ADD_NAME | DIR__SEARCH;
 	if (new_dentry->d_inode)
 		av |= DIR__REMOVE_NAME;
-	rc = avc_has_perm(tsec->sid, new_dsec->sid, SECCLASS_DIR, av, &ad);
+	rc = avc_has_perm(sid, new_dsec->sid, SECCLASS_DIR, av, &ad);
 	if (rc)
 		return rc;
 	if (new_dentry->d_inode) {
 		new_isec = new_dentry->d_inode->i_security;
 		new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
-		rc = avc_has_perm(tsec->sid, new_isec->sid,
+		rc = avc_has_perm(sid, new_isec->sid,
 				  new_isec->sclass,
 				  (new_is_dir ? DIR__RMDIR : FILE__UNLINK), &ad);
 		if (rc)
@@ -1641,13 +1667,11 @@ static int superblock_has_perm(struct task_struct *tsk,
 			       u32 perms,
 			       struct avc_audit_data *ad)
 {
-	struct task_security_struct *tsec;
 	struct superblock_security_struct *sbsec;
+	u32 sid = task_sid(tsk);
 
-	tsec = tsk->cred->security;
 	sbsec = sb->s_security;
-	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
-			    perms, ad);
+	return avc_has_perm(sid, sbsec->sid, SECCLASS_FILESYSTEM, perms, ad);
 }
 
 /* Convert a Linux mode and permission mask to an access vector. */
@@ -1742,10 +1766,9 @@ static int selinux_ptrace_may_access(struct task_struct *child,
 		return rc;
 
 	if (mode == PTRACE_MODE_READ) {
-		struct task_security_struct *tsec = current->cred->security;
-		struct task_security_struct *csec = child->cred->security;
-		return avc_has_perm(tsec->sid, csec->sid,
-				    SECCLASS_FILE, FILE__READ, NULL);
+		u32 sid = current_sid();
+		u32 csid = task_sid(child);
+		return avc_has_perm(sid, csid, SECCLASS_FILE, FILE__READ, NULL);
 	}
 
 	return task_has_perm(current, child, PROCESS__PTRACE);
@@ -1850,15 +1873,14 @@ static int selinux_sysctl(ctl_table *table, int op)
 {
 	int error = 0;
 	u32 av;
-	struct task_security_struct *tsec;
-	u32 tsid;
+	u32 tsid, sid;
 	int rc;
 
 	rc = secondary_ops->sysctl(table, op);
 	if (rc)
 		return rc;
 
-	tsec = current->cred->security;
+	sid = current_sid();
 
 	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
 				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
@@ -1870,7 +1892,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 	/* The op values are "defined" in sysctl.c, thereby creating
 	 * a bad coupling between this module and sysctl.c */
 	if (op == 001) {
-		error = avc_has_perm(tsec->sid, tsid,
+		error = avc_has_perm(sid, tsid,
 				     SECCLASS_DIR, DIR__SEARCH, NULL);
 	} else {
 		av = 0;
@@ -1879,7 +1901,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 		if (op & 002)
 			av |= FILE__WRITE;
 		if (av)
-			error = avc_has_perm(tsec->sid, tsid,
+			error = avc_has_perm(sid, tsid,
 					     SECCLASS_FILE, av, NULL);
 	}
 
@@ -1965,11 +1987,11 @@ static int selinux_syslog(int type)
 static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 {
 	int rc, cap_sys_admin = 0;
-	struct task_security_struct *tsec = current->cred->security;
+	u32 sid = current_sid();
 
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
-		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
+		rc = avc_has_perm_noaudit(sid, sid,
 					  SECCLASS_CAPABILITY,
 					  CAP_TO_MASK(CAP_SYS_ADMIN),
 					  0,
@@ -2017,7 +2039,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
 	if (bsec->set)
 		return 0;
 
-	tsec = current->cred->security;
+	tsec = current_security();
 	isec = inode->i_security;
 
 	/* Default to the current task SID. */
@@ -2082,14 +2104,19 @@ static int selinux_bprm_check_security(struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_security_struct *tsec = current->cred->security;
+	const struct cred *cred = current_cred();
+	const struct task_security_struct *tsec = cred->security;
+	u32 sid, osid;
 	int atsecure = 0;
 
-	if (tsec->osid != tsec->sid) {
+	sid = tsec->sid;
+	osid = tsec->osid;
+
+	if (osid != sid) {
 		/* Enable secure mode for SIDs transitions unless
 		   the noatsecure permission is granted between
 		   the two SIDs, i.e. ahp returns 0. */
-		atsecure = avc_has_perm(tsec->osid, tsec->sid,
+		atsecure = avc_has_perm(osid, sid,
 					 SECCLASS_PROCESS,
 					 PROCESS__NOATSECURE, NULL);
 	}
@@ -2205,7 +2232,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 
 	secondary_ops->bprm_apply_creds(bprm, unsafe);
 
-	tsec = current->cred->security;
+	tsec = current_security();
 
 	bsec = bprm->security;
 	sid = bsec->sid;
@@ -2234,7 +2261,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 			rcu_read_lock();
 			tracer = tracehook_tracer_task(current);
 			if (likely(tracer != NULL)) {
-				sec = tracer->cred->security;
+				sec = __task_cred(tracer)->security;
 				ptsid = sec->sid;
 			}
 			rcu_read_unlock();
@@ -2263,7 +2290,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 	struct bprm_security_struct *bsec;
 	int rc, i;
 
-	tsec = current->cred->security;
+	tsec = current_security();
 	bsec = bprm->security;
 
 	if (bsec->unsafe) {
@@ -2504,21 +2531,22 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 				       char **name, void **value,
 				       size_t *len)
 {
-	struct task_security_struct *tsec;
+	const struct cred *cred = current_cred();
+	const struct task_security_struct *tsec = cred->security;
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
-	u32 newsid, clen;
+	u32 sid, newsid, clen;
 	int rc;
 	char *namep = NULL, *context;
 
-	tsec = current->cred->security;
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
 
-	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
-		newsid = tsec->create_sid;
-	} else {
-		rc = security_transition_sid(tsec->sid, dsec->sid,
+	sid = tsec->sid;
+	newsid = tsec->create_sid;
+
+	if (!newsid || sbsec->behavior == SECURITY_FS_USE_MNTPOINT) {
+		rc = security_transition_sid(sid, dsec->sid,
 					     inode_mode_to_security_class(inode->i_mode),
 					     &newsid);
 		if (rc) {
@@ -2696,12 +2724,11 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
-	struct task_security_struct *tsec = current->cred->security;
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
 	struct superblock_security_struct *sbsec;
 	struct avc_audit_data ad;
-	u32 newsid;
+	u32 newsid, sid = current_sid();
 	int rc = 0;
 
 	if (strcmp(name, XATTR_NAME_SELINUX))
@@ -2717,7 +2744,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.dentry = dentry;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass,
+	rc = avc_has_perm(sid, isec->sid, isec->sclass,
 			  FILE__RELABELFROM, &ad);
 	if (rc)
 		return rc;
@@ -2731,12 +2758,12 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 	if (rc)
 		return rc;
 
-	rc = avc_has_perm(tsec->sid, newsid, isec->sclass,
+	rc = avc_has_perm(sid, newsid, isec->sclass,
 			  FILE__RELABELTO, &ad);
 	if (rc)
 		return rc;
 
-	rc = security_validate_transition(isec->sid, newsid, tsec->sid,
+	rc = security_validate_transition(isec->sid, newsid, sid,
 					  isec->sclass);
 	if (rc)
 		return rc;
@@ -2804,7 +2831,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	u32 size;
 	int error;
 	char *context = NULL;
-	struct task_security_struct *tsec = current->cred->security;
+	struct task_security_struct *tsec = current_security();
 	struct inode_security_struct *isec = inode->i_security;
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
@@ -2915,16 +2942,16 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	struct task_security_struct *tsec = current->cred->security;
 	struct file_security_struct *fsec = file->f_security;
 	struct inode_security_struct *isec = inode->i_security;
+	u32 sid = current_sid();
 
 	if (!mask) {
 		/* No permission to check.  Existence test. */
 		return 0;
 	}
 
-	if (tsec->sid == fsec->sid && fsec->isid == isec->sid
+	if (sid == fsec->sid && fsec->isid == isec->sid
 	    && fsec->pseqno == avc_policy_seqno())
 		return selinux_netlbl_inode_permission(inode, mask);
 
@@ -2992,8 +3019,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
-	u32 sid = ((struct task_security_struct *)
-		   (current->cred->security))->sid;
+	u32 sid = current_sid();
 
 	if (addr < mmap_min_addr)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
@@ -3102,12 +3128,10 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 
 static int selinux_file_set_fowner(struct file *file)
 {
-	struct task_security_struct *tsec;
 	struct file_security_struct *fsec;
 
-	tsec = current->cred->security;
 	fsec = file->f_security;
-	fsec->fown_sid = tsec->sid;
+	fsec->fown_sid = current_sid();
 
 	return 0;
 }
@@ -3116,14 +3140,13 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 				       struct fown_struct *fown, int signum)
 {
 	struct file *file;
+	u32 sid = current_sid();
 	u32 perm;
-	struct task_security_struct *tsec;
 	struct file_security_struct *fsec;
 
 	/* struct fown_struct is never outside the context of a struct file */
 	file = container_of(fown, struct file, f_owner);
 
-	tsec = tsk->cred->security;
 	fsec = file->f_security;
 
 	if (!signum)
@@ -3131,7 +3154,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	else
 		perm = signal_to_av(signum);
 
-	return avc_has_perm(fsec->fown_sid, tsec->sid,
+	return avc_has_perm(fsec->fown_sid, sid,
 			    SECCLASS_PROCESS, perm, NULL);
 }
 
@@ -3186,7 +3209,7 @@ static int selinux_cred_alloc_security(struct cred *cred)
 	struct task_security_struct *tsec1, *tsec2;
 	int rc;
 
-	tsec1 = current->cred->security;
+	tsec1 = current_security();
 
 	rc = cred_alloc_security(cred);
 	if (rc)
@@ -3254,8 +3277,7 @@ static int selinux_task_getsid(struct task_struct *p)
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	struct task_security_struct *tsec = p->cred->security;
-	*secid = tsec->sid;
+	*secid = task_sid(p);
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
@@ -3336,7 +3358,6 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 {
 	u32 perm;
 	int rc;
-	struct task_security_struct *tsec;
 
 	rc = secondary_ops->task_kill(p, info, sig, secid);
 	if (rc)
@@ -3346,9 +3367,9 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
-	tsec = p->cred->security;
 	if (secid)
-		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
+		rc = avc_has_perm(secid, task_sid(p),
+				  SECCLASS_PROCESS, perm, NULL);
 	else
 		rc = task_has_perm(current, p, perm);
 	return rc;
@@ -3387,12 +3408,11 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct task_security_struct *tsec = p->cred->security;
 	struct inode_security_struct *isec = inode->i_security;
+	u32 sid = task_sid(p);
 
-	isec->sid = tsec->sid;
+	isec->sid = sid;
 	isec->initialized = 1;
-	return;
 }
 
 /* Returns error only if unable to parse addresses */
@@ -3631,19 +3651,19 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
 			   u32 perms)
 {
 	struct inode_security_struct *isec;
-	struct task_security_struct *tsec;
 	struct avc_audit_data ad;
+	u32 sid;
 	int err = 0;
 
-	tsec = task->cred->security;
 	isec = SOCK_INODE(sock)->i_security;
 
 	if (isec->sid == SECINITSID_KERNEL)
 		goto out;
+	sid = task_sid(task);
 
 	AVC_AUDIT_DATA_INIT(&ad, NET);
 	ad.u.net.sk = sock->sk;
-	err = avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
+	err = avc_has_perm(sid, isec->sid, isec->sclass, perms, &ad);
 
 out:
 	return err;
@@ -3652,18 +3672,20 @@ out:
 static int selinux_socket_create(int family, int type,
 				 int protocol, int kern)
 {
+	const struct cred *cred = current_cred();
+	const struct task_security_struct *tsec = cred->security;
+	u32 sid, newsid;
+	u16 secclass;
 	int err = 0;
-	struct task_security_struct *tsec;
-	u32 newsid;
 
 	if (kern)
 		goto out;
 
-	tsec = current->cred->security;
-	newsid = tsec->sockcreate_sid ? : tsec->sid;
-	err = avc_has_perm(tsec->sid, newsid,
-			   socket_type_to_security_class(family, type,
-			   protocol), SOCKET__CREATE, NULL);
+	sid = tsec->sid;
+	newsid = tsec->sockcreate_sid ?: sid;
+
+	secclass = socket_type_to_security_class(family, type, protocol);
+	err = avc_has_perm(sid, newsid, secclass, SOCKET__CREATE, NULL);
 
 out:
 	return err;
@@ -3672,18 +3694,26 @@ out:
 static int selinux_socket_post_create(struct socket *sock, int family,
 				      int type, int protocol, int kern)
 {
-	int err = 0;
+	const struct cred *cred = current_cred();
+	const struct task_security_struct *tsec = cred->security;
 	struct inode_security_struct *isec;
-	struct task_security_struct *tsec;
 	struct sk_security_struct *sksec;
-	u32 newsid;
+	u32 sid, newsid;
+	int err = 0;
+
+	sid = tsec->sid;
+	newsid = tsec->sockcreate_sid;
 
 	isec = SOCK_INODE(sock)->i_security;
 
-	tsec = current->cred->security;
-	newsid = tsec->sockcreate_sid ? : tsec->sid;
+	if (kern)
+		isec->sid = SECINITSID_KERNEL;
+	else if (newsid)
+		isec->sid = newsid;
+	else
+		isec->sid = sid;
+
 	isec->sclass = socket_type_to_security_class(family, type, protocol);
-	isec->sid = kern ? SECINITSID_KERNEL : newsid;
 	isec->initialized = 1;
 
 	if (sock->sk) {
@@ -3718,7 +3748,6 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 	if (family == PF_INET || family == PF_INET6) {
 		char *addrp;
 		struct inode_security_struct *isec;
-		struct task_security_struct *tsec;
 		struct avc_audit_data ad;
 		struct sockaddr_in *addr4 = NULL;
 		struct sockaddr_in6 *addr6 = NULL;
@@ -3726,7 +3755,6 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		struct sock *sk = sock->sk;
 		u32 sid, node_perm;
 
-		tsec = current->cred->security;
 		isec = SOCK_INODE(sock)->i_security;
 
 		if (family == PF_INET) {
@@ -4666,15 +4694,16 @@ static int ipc_alloc_security(struct task_struct *task,
 			      struct kern_ipc_perm *perm,
 			      u16 sclass)
 {
-	struct task_security_struct *tsec = task->cred->security;
 	struct ipc_security_struct *isec;
+	u32 sid;
 
 	isec = kzalloc(sizeof(struct ipc_security_struct), GFP_KERNEL);
 	if (!isec)
 		return -ENOMEM;
 
+	sid = task_sid(task);
 	isec->sclass = sclass;
-	isec->sid = tsec->sid;
+	isec->sid = sid;
 	perm->security = isec;
 
 	return 0;
@@ -4712,17 +4741,16 @@ static void msg_msg_free_security(struct msg_msg *msg)
 static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 			u32 perms)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 
-	tsec = current->cred->security;
 	isec = ipc_perms->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = ipc_perms->key;
 
-	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
+	return avc_has_perm(sid, isec->sid, isec->sclass, perms, &ad);
 }
 
 static int selinux_msg_msg_alloc_security(struct msg_msg *msg)
@@ -4738,22 +4766,21 @@ static void selinux_msg_msg_free_security(struct msg_msg *msg)
 /* message queue security operations */
 static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	int rc;
 
 	rc = ipc_alloc_security(current, &msq->q_perm, SECCLASS_MSGQ);
 	if (rc)
 		return rc;
 
-	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = msq->q_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	rc = avc_has_perm(sid, isec->sid, SECCLASS_MSGQ,
 			  MSGQ__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&msq->q_perm);
@@ -4769,17 +4796,16 @@ static void selinux_msg_queue_free_security(struct msg_queue *msq)
 
 static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 
-	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = msq->q_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	return avc_has_perm(sid, isec->sid, SECCLASS_MSGQ,
 			    MSGQ__ASSOCIATE, &ad);
 }
 
@@ -4813,13 +4839,12 @@ static int selinux_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 
 static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg, int msqflg)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct msg_security_struct *msec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	int rc;
 
-	tsec = current->cred->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
@@ -4831,9 +4856,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 		 * Compute new sid based on current process and
 		 * message queue this message will be stored in
 		 */
-		rc = security_transition_sid(tsec->sid,
-					     isec->sid,
-					     SECCLASS_MSG,
+		rc = security_transition_sid(sid, isec->sid, SECCLASS_MSG,
 					     &msec->sid);
 		if (rc)
 			return rc;
@@ -4843,16 +4866,16 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	ad.u.ipc_id = msq->q_perm.key;
 
 	/* Can this process write to the queue? */
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
+	rc = avc_has_perm(sid, isec->sid, SECCLASS_MSGQ,
 			  MSGQ__WRITE, &ad);
 	if (!rc)
 		/* Can this process send the message */
-		rc = avc_has_perm(tsec->sid, msec->sid,
-				  SECCLASS_MSG, MSG__SEND, &ad);
+		rc = avc_has_perm(sid, msec->sid, SECCLASS_MSG,
+				  MSG__SEND, &ad);
 	if (!rc)
 		/* Can the message be put in the queue? */
-		rc = avc_has_perm(msec->sid, isec->sid,
-				  SECCLASS_MSGQ, MSGQ__ENQUEUE, &ad);
+		rc = avc_has_perm(msec->sid, isec->sid, SECCLASS_MSGQ,
+				  MSGQ__ENQUEUE, &ad);
 
 	return rc;
 }
@@ -4861,23 +4884,22 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 				    struct task_struct *target,
 				    long type, int mode)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct msg_security_struct *msec;
 	struct avc_audit_data ad;
+	u32 sid = task_sid(target);
 	int rc;
 
-	tsec = target->cred->security;
 	isec = msq->q_perm.security;
 	msec = msg->security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = msq->q_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid,
+	rc = avc_has_perm(sid, isec->sid,
 			  SECCLASS_MSGQ, MSGQ__READ, &ad);
 	if (!rc)
-		rc = avc_has_perm(tsec->sid, msec->sid,
+		rc = avc_has_perm(sid, msec->sid,
 				  SECCLASS_MSG, MSG__RECEIVE, &ad);
 	return rc;
 }
@@ -4885,22 +4907,21 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 /* Shared Memory security operations */
 static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	int rc;
 
 	rc = ipc_alloc_security(current, &shp->shm_perm, SECCLASS_SHM);
 	if (rc)
 		return rc;
 
-	tsec = current->cred->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = shp->shm_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
+	rc = avc_has_perm(sid, isec->sid, SECCLASS_SHM,
 			  SHM__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&shp->shm_perm);
@@ -4916,17 +4937,16 @@ static void selinux_shm_free_security(struct shmid_kernel *shp)
 
 static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 
-	tsec = current->cred->security;
 	isec = shp->shm_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = shp->shm_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
+	return avc_has_perm(sid, isec->sid, SECCLASS_SHM,
 			    SHM__ASSOCIATE, &ad);
 }
 
@@ -4984,22 +5004,21 @@ static int selinux_shm_shmat(struct shmid_kernel *shp,
 /* Semaphore security operations */
 static int selinux_sem_alloc_security(struct sem_array *sma)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 	int rc;
 
 	rc = ipc_alloc_security(current, &sma->sem_perm, SECCLASS_SEM);
 	if (rc)
 		return rc;
 
-	tsec = current->cred->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = sma->sem_perm.key;
 
-	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
+	rc = avc_has_perm(sid, isec->sid, SECCLASS_SEM,
 			  SEM__CREATE, &ad);
 	if (rc) {
 		ipc_free_security(&sma->sem_perm);
@@ -5015,17 +5034,16 @@ static void selinux_sem_free_security(struct sem_array *sma)
 
 static int selinux_sem_associate(struct sem_array *sma, int semflg)
 {
-	struct task_security_struct *tsec;
 	struct ipc_security_struct *isec;
 	struct avc_audit_data ad;
+	u32 sid = current_sid();
 
-	tsec = current->cred->security;
 	isec = sma->sem_perm.security;
 
 	AVC_AUDIT_DATA_INIT(&ad, IPC);
 	ad.u.ipc_id = sma->sem_perm.key;
 
-	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
+	return avc_has_perm(sid, isec->sid, SECCLASS_SEM,
 			    SEM__ASSOCIATE, &ad);
 }
 
@@ -5115,7 +5133,7 @@ static void selinux_d_instantiate(struct dentry *dentry, struct inode *inode)
 static int selinux_getprocattr(struct task_struct *p,
 			       char *name, char **value)
 {
-	struct task_security_struct *tsec;
+	const struct task_security_struct *__tsec;
 	u32 sid;
 	int error;
 	unsigned len;
@@ -5126,22 +5144,24 @@ static int selinux_getprocattr(struct task_struct *p,
 			return error;
 	}
 
-	tsec = p->cred->security;
+	rcu_read_lock();
+	__tsec = __task_cred(p)->security;
 
 	if (!strcmp(name, "current"))
-		sid = tsec->sid;
+		sid = __tsec->sid;
 	else if (!strcmp(name, "prev"))
-		sid = tsec->osid;
+		sid = __tsec->osid;
 	else if (!strcmp(name, "exec"))
-		sid = tsec->exec_sid;
+		sid = __tsec->exec_sid;
 	else if (!strcmp(name, "fscreate"))
-		sid = tsec->create_sid;
+		sid = __tsec->create_sid;
 	else if (!strcmp(name, "keycreate"))
-		sid = tsec->keycreate_sid;
+		sid = __tsec->keycreate_sid;
 	else if (!strcmp(name, "sockcreate"))
-		sid = tsec->sockcreate_sid;
+		sid = __tsec->sockcreate_sid;
 	else
-		return -EINVAL;
+		goto invalid;
+	rcu_read_unlock();
 
 	if (!sid)
 		return 0;
@@ -5150,6 +5170,10 @@ static int selinux_getprocattr(struct task_struct *p,
 	if (error)
 		return error;
 	return len;
+
+invalid:
+	rcu_read_unlock();
+	return -EINVAL;
 }
 
 static int selinux_setprocattr(struct task_struct *p,
@@ -5254,9 +5278,7 @@ static int selinux_setprocattr(struct task_struct *p,
 		rcu_read_lock();
 		tracer = tracehook_tracer_task(p);
 		if (tracer != NULL) {
-			struct task_security_struct *ptsec =
-				tracer->cred->security;
-			u32 ptsid = ptsec->sid;
+			u32 ptsid = task_sid(tracer);
 			rcu_read_unlock();
 			error = avc_has_perm_noaudit(ptsid, sid,
 						     SECCLASS_PROCESS,
@@ -5299,19 +5321,22 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
 			     unsigned long flags)
 {
-	struct task_security_struct *tsec = tsk->cred->security;
+	const struct task_security_struct *__tsec;
 	struct key_security_struct *ksec;
 
 	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
 	if (!ksec)
 		return -ENOMEM;
 
-	if (tsec->keycreate_sid)
-		ksec->sid = tsec->keycreate_sid;
+	rcu_read_lock();
+	__tsec = __task_cred(tsk)->security;
+	if (__tsec->keycreate_sid)
+		ksec->sid = __tsec->keycreate_sid;
 	else
-		ksec->sid = tsec->sid;
-	k->security = ksec;
+		ksec->sid = __tsec->sid;
+	rcu_read_unlock();
 
+	k->security = ksec;
 	return 0;
 }
 
@@ -5328,13 +5353,8 @@ static int selinux_key_permission(key_ref_t key_ref,
 			    key_perm_t perm)
 {
 	struct key *key;
-	struct task_security_struct *tsec;
 	struct key_security_struct *ksec;
-
-	key = key_ref_to_ptr(key_ref);
-
-	tsec = ctx->cred->security;
-	ksec = key->security;
+	u32 sid;
 
 	/* if no specific permissions are requested, we skip the
 	   permission check. No serious, additional covert channels
@@ -5342,8 +5362,12 @@ static int selinux_key_permission(key_ref_t key_ref,
 	if (perm == 0)
 		return 0;
 
-	return avc_has_perm(tsec->sid, ksec->sid,
-			    SECCLASS_KEY, perm, NULL);
+	sid = task_sid(ctx);
+
+	key = key_ref_to_ptr(key_ref);
+	ksec = key->security;
+
+	return avc_has_perm(sid, ksec->sid, SECCLASS_KEY, perm, NULL);
 }
 
 static int selinux_key_getsecurity(struct key *key, char **_buffer)

