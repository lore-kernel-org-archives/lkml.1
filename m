Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbXJLQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbXJLQGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbXJLQFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:05:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759906AbXJLQFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:05:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/52] CRED: Give in_group_p() a cred pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:05:29 +0100
Message-ID: <20071012160529.15119.29048.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass a credential record pointer to in_group_p() so that it refers to the
credentials set of interest, rather than current credentials.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/attr.c                   |   12 ++++++++----
 fs/configfs/inode.c         |    3 ++-
 fs/dquot.c                  |    2 +-
 fs/ext2/balloc.c            |    3 ++-
 fs/ext3/balloc.c            |    3 ++-
 fs/ext4/balloc.c            |    3 ++-
 fs/hugetlbfs/inode.c        |    2 +-
 fs/jffs2/fs.c               |    3 ++-
 fs/namei.c                  |    4 ++--
 fs/posix_acl.c              |    4 ++--
 fs/proc/proc_sysctl.c       |    2 +-
 fs/sysfs/inode.c            |    3 ++-
 fs/xfs/linux-2.6/xfs_iops.c |    3 ++-
 fs/xfs/xfs_inode.c          |    4 ++--
 fs/xfs/xfs_vnodeops.c       |    4 ++--
 include/linux/sched.h       |    4 ++--
 ipc/util.c                  |    3 ++-
 kernel/sys.c                |    5 ++---
 security/keys/keyctl.c      |    3 ++-
 19 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 3e6b911..f0adb92 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -36,7 +36,8 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
 	    (current->cred->uid != inode->i_uid ||
-	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
+	     (!in_group_p(current->cred, attr->ia_gid) &&
+	      attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
 
@@ -45,8 +46,10 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 		if (!is_owner_or_cap(inode))
 			goto error;
 		/* Also check the setgid bit! */
-		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-				inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(current->cred,
+				(ia_valid & ATTR_GID) ?
+				attr->ia_gid : inode->i_gid) &&
+		    !capable(CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -90,7 +93,8 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(current->cred, inode->i_gid) &&
+		    !capable(CAP_FSETID))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index ddc003a..654011f 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -106,7 +106,8 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(current->cred, inode->i_gid) &&
+		    !capable(CAP_FSETID))
 			mode &= ~S_ISGID;
 		sd_iattr->ia_mode = sd->s_mode = mode;
 	}
diff --git a/fs/dquot.c b/fs/dquot.c
index f1748c6..f98f4ff 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -834,7 +834,7 @@ static inline int need_print_warning(struct dquot *dquot)
 		case USRQUOTA:
 			return current->cred->uid == dquot->dq_id;
 		case GRPQUOTA:
-			return in_group_p(dquot->dq_id);
+			return in_group_p(current->cred, dquot->dq_id);
 	}
 	return 0;
 }
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 3517fce..ca88579 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -113,7 +113,8 @@ static int reserve_blocks(struct super_block *sb, int count)
 
 	if (free_blocks < root_blocks + count && !capable(CAP_SYS_RESOURCE) &&
 	    sbi->s_resuid != current->cred->uid &&
-	    (sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+	    (sbi->s_resgid == 0 ||
+	     !in_group_p (current->cred, sbi->s_resgid))) {
 		/*
 		 * We are too close to reserve and we are not privileged.
 		 * Can we allocate anything at all?
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6c4e82f..316ec8b 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1361,7 +1361,8 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->cred->uid &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+		(sbi->s_resgid == 0 ||
+		 !in_group_p (current->cred, sbi->s_resgid))) {
 		return 0;
 	}
 	return 1;
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1628c1b..a6ced53 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1378,7 +1378,8 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
 	root_blocks = ext4_r_blocks_count(sbi->s_es);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->cred->uid &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+		(sbi->s_resgid == 0 ||
+		 !in_group_p (current->cred, sbi->s_resgid))) {
 		return 0;
 	}
 	return 1;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 354f545..e0a4795 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -781,7 +781,7 @@ static struct vfsmount *hugetlbfs_vfsmount;
 static int can_do_hugetlb_shm(void)
 {
 	return likely(capable(CAP_IPC_LOCK) ||
-			in_group_p(sysctl_hugetlb_shm_group) ||
+			in_group_p(current->cred, sysctl_hugetlb_shm_group) ||
 			can_do_mlock());
 }
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index a3ae187..eed08a2 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -100,7 +100,8 @@ static int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 
 	if (ivalid & ATTR_MODE)
 		if (iattr->ia_mode & S_ISGID &&
-		    !in_group_p(je16_to_cpu(ri->gid)) && !capable(CAP_FSETID))
+		    !in_group_p(current->cred, je16_to_cpu(ri->gid)) &&
+		    !capable(CAP_FSETID))
 			ri->mode = cpu_to_jemode(iattr->ia_mode & ~S_ISGID);
 		else
 			ri->mode = cpu_to_jemode(iattr->ia_mode);
diff --git a/fs/namei.c b/fs/namei.c
index 3e10fff..3db9a41 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -196,7 +196,7 @@ int generic_permission(struct inode *inode, int mask,
 				return error;
 		}
 
-		if (in_group_p(inode->i_gid))
+		if (in_group_p(current->cred, inode->i_gid))
 			mode >>= 3;
 	}
 
@@ -439,7 +439,7 @@ static int exec_permission_lite(struct inode *inode,
 
 	if (current->cred->uid == inode->i_uid)
 		mode >>= 6;
-	else if (in_group_p(inode->i_gid))
+	else if (in_group_p(current->cred, inode->i_gid))
 		mode >>= 3;
 
 	if (mode & MAY_EXEC)
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index b36c79f..a78335c 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -225,14 +225,14 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
-                                if (in_group_p(inode->i_gid)) {
+                                if (in_group_p(current->cred, inode->i_gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
 						goto mask;
                                 }
 				break;
                         case ACL_GROUP:
-                                if (in_group_p(pa->e_id)) {
+                                if (in_group_p(current->cred, pa->e_id)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
 						goto mask;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 680c429..feaf4f5 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -393,7 +393,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 
 	if (current->euid == 0)
 		mode >>= 6;
-	else if (in_group_p(0))
+	else if (in_group_p(current->cred, 0))
 		mode >>= 3;
 
 	if ((mode & mask & (MAY_READ|MAY_WRITE|MAY_EXEC)) == mask)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 10d1b52..fc1934e 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -96,7 +96,8 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(current->cred, inode->i_gid) &&
+		    !capable(CAP_FSETID))
 			mode &= ~S_ISGID;
 		sd_iattr->ia_mode = sd->s_mode = mode;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 0b5fa12..4ffc42e 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -685,7 +685,8 @@ xfs_vn_setattr(
 	if (ia_valid & ATTR_MODE) {
 		vattr.va_mask |= XFS_AT_MODE;
 		vattr.va_mode = attr->ia_mode;
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(current->cred, inode->i_gid) &&
+		    !capable(CAP_FSETID))
 			inode->i_mode &= ~S_ISGID;
 	}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cdc4c28..4cd405f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1175,7 +1175,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
+	    (!in_group_p(current->cred, (gid_t)ip->i_d.di_gid))) {
 		ip->i_d.di_mode &= ~S_ISGID;
 	}
 
@@ -3635,7 +3635,7 @@ xfs_iaccess(
 
 	if (current_fsuid(cr) != ip->i_d.di_uid) {
 		mode >>= 3;
-		if (!in_group_p((gid_t)ip->i_d.di_gid))
+		if (!in_group_p(current->cred, (gid_t)ip->i_d.di_gid))
 			mode >>= 3;
 	}
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 6034592..0109281 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -393,7 +393,7 @@ xfs_setattr(
 			if ((vap->va_mode & S_ISUID) && !file_owner)
 				m |= S_ISUID;
 			if ((vap->va_mode & S_ISGID) &&
-			    !in_group_p((gid_t)ip->i_d.di_gid))
+			    !in_group_p(current->cred, (gid_t)ip->i_d.di_gid))
 				m |= S_ISGID;
 #if 0
 			/* Linux allows this, Irix doesn't. */
@@ -439,7 +439,7 @@ xfs_setattr(
 		 */
 		if (restricted_chown &&
 		    (iuid != uid || (igid != gid &&
-				     !in_group_p((gid_t)gid))) &&
+				     !in_group_p(current->cred, (gid_t)gid))) &&
 		    !capable(CAP_CHOWN)) {
 			code = XFS_ERROR(EPERM);
 			goto error_return;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fee8b1e..fb90406 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -835,7 +835,7 @@ struct group_info {
 extern struct group_info *groups_alloc(int gidsetsize);
 extern void groups_free(struct group_info *group_info);
 extern int set_current_groups(struct group_info *group_info);
-extern int groups_search(struct group_info *group_info, gid_t grp);
+extern int groups_search(const struct group_info *group_info, gid_t grp);
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
     ((gi)->blocks[(i)/NGROUPS_PER_BLOCK][(i)%NGROUPS_PER_BLOCK])
@@ -1493,7 +1493,7 @@ extern void FASTCALL(wake_up_new_task(struct task_struct * tsk,
 extern void sched_fork(struct task_struct *p, int clone_flags);
 extern void sched_dead(struct task_struct *p);
 
-extern int in_group_p(gid_t);
+extern int in_group_p(const struct cred *, gid_t);
 extern int in_egroup_p(gid_t);
 
 extern void proc_caches_init(void);
diff --git a/ipc/util.c b/ipc/util.c
index 44e5135..3daa63a 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -546,7 +546,8 @@ int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 	granted_mode = ipcp->mode;
 	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
 		granted_mode >>= 6;
-	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
+	else if (in_group_p(current->cred, ipcp->cgid) ||
+		 in_group_p(current->cred, ipcp->gid))
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
 	if ((requested_mode & ~granted_mode & 0007) && 
diff --git a/kernel/sys.c b/kernel/sys.c
index ff25530..5bfefd4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1796,7 +1796,7 @@ static void groups_sort(struct group_info *group_info)
 }
 
 /* a simple bsearch */
-int groups_search(struct group_info *group_info, gid_t grp)
+int groups_search(const struct group_info *group_info, gid_t grp)
 {
 	unsigned int left, right;
 
@@ -1901,9 +1901,8 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
 /*
  * Check whether we're fsgid/egid or in the supplemental group..
  */
-int in_group_p(gid_t grp)
+int in_group_p(const struct cred *cred, gid_t grp)
 {
-	struct cred *cred = current->cred;
 	int retval = 1;
 
 	if (grp != cred->gid)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 39e7971..e0a024a 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -713,7 +713,8 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 
 		/* only the sysadmin can set the key's GID to a group other
 		 * than one of those that the current process subscribes to */
-		if (gid != (gid_t) -1 && gid != key->gid && !in_group_p(gid))
+		if (gid != (gid_t) -1 && gid != key->gid &&
+		    !in_group_p(current->cred, gid))
 			goto error_put;
 	}
 

