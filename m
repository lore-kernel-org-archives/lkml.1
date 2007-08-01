Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbXHAEce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbXHAEce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXHAEbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:31:52 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:47957 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754423AbXHAEbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:31:43 -0400
X-YMail-OSG: 9oHeAK4VM1lTPXCDN.D_fGwBupJ7IrhuYbbX_DfhZVCkK3BA54i5EbRKOTbH96bgrQ--
X-RocketYMMF: rancidfat
Date: Tue, 31 Jul 2007 21:31:40 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: [PATCH 2/2][RFC] v8  Simplified Mandatory Access Control Kernel
To: LSM List <linux-security-module@vger.kernel.org>,
       linux-kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <942133.83110.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/smack_lsm.c
linux-2.6.22/security/smack/smack_lsm.c
--- linux-2.6.22-base/security/smack/smack_lsm.c	1969-12-31 16:00:00.000000000
-0800
+++ linux-2.6.22/security/smack/smack_lsm.c	2007-07-24 15:02:16.000000000 -0700
@@ -0,0 +1,1989 @@
+/*
+ *  Simplified MAC Kernel (smack) security module
+ *
+ *  This file contains the smack hook function implementations.
+ *
+ *  Author:
+ *	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2,
+ *      as published by the Free Software Foundation.
+ */
+
+#include <linux/xattr.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/stat.h>
+#include <linux/ext2_fs.h>
+#include <linux/kd.h>
+#include <asm/ioctls.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/mutex.h>
+#include <net/netlabel.h>
+#include <net/cipso_ipv4.h>
+
+#include "smack.h"
+
+/*
+ * I hope these are the hokeyist lines of code in the module. Casey.
+ */
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+#define PIPEFS_MAGIC		0x50495045
+#define TMPFS_MAGIC		0x01021994
+
+/*
+ * These are maintained in smackfs
+ */
+extern smack_t smack_net_ambient;
+extern int smack_net_nltype;
+extern int smack_cipso_direct;
+extern struct smk_cipso_entry *smack_cipso;
+
+
+/*
+ * Fetch the smack label from a file.
+ */
+static int smk_fetch(struct inode *ip, struct dentry *dp, smack_t *isp)
+{
+	int rc;
+	smack_t smack;
+
+	if (ip->i_op->getxattr == NULL)
+		return -EOPNOTSUPP;
+
+	rc = ip->i_op->getxattr(dp, XATTR_NAME_SMACK, &smack, sizeof(smack_t));
+	if (rc > 0)
+		*isp = smk_from_buffer(&smack, rc);
+
+	return rc;
+}
+
+static smack_t *free_smack_t(smack_t *sp)
+{
+	kfree(sp);
+        return NULL;
+}
+
+struct inode_smack *new_inode_smack(smack_t smack)
+{
+	struct inode_smack *isp;
+
+        isp = kzalloc(sizeof(struct inode_smack), GFP_KERNEL);
+        if (isp == NULL)
+                return NULL;
+
+	isp->smk_inode = smack;
+	isp->smk_flags = 0;
+	mutex_init(&isp->smk_lock);
+
+	return isp;
+}
+
+/*
+ * LSM hooks.
+ * We he, that is fun!
+ */
+static int smack_ptrace(struct task_struct *ptp, struct task_struct *ctp)
+{
+	smack_t *psp = smk_of_task(ptp);
+	smack_t *csp = smk_of_task(ctp);
+	int rc;
+
+	rc = cap_ptrace(ptp, ctp);
+	if (rc != 0)
+		return rc;
+
+	rc = smk_access(psp, csp, MAY_READWRITE);
+	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
+		return 0;
+
+	return rc;
+}
+
+static int smack_syslog(int type)
+{
+	int rc;
+	smack_t *sp = smk_of_task(current);
+
+	rc = cap_syslog(type);
+	if (rc == 0)
+		 if (*sp != SMK_FLOOR)
+			rc = -EACCES;
+
+	return rc;
+}
+
+static int smack_task_alloc_security(struct task_struct *tsk)
+{
+	struct task_smack *tsp;
+	struct task_smack *ctsp = current->security;
+
+	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+	if (tsp == NULL)
+		return -ENOMEM;
+
+	*tsp = *ctsp;
+	tsk->security = tsp;
+
+	return 0;
+}
+
+static void smack_task_free_security(struct task_struct *task)
+{
+	kfree(task->security);
+	task->security = NULL;
+}
+
+static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_setnice(struct task_struct *p, int nice)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_setioprio(struct task_struct *p, int ioprio)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_getioprio(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_setscheduler(struct task_struct *p, int policy,
+				   struct sched_param *lp)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_getscheduler(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_movememory(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
+	return rc;
+}
+
+static int smack_task_kill(struct task_struct *p, struct siginfo *info,
+			   int sig, u32 secid)
+{
+	smack_t *tsp = smk_of_task(p);
+	int rc;
+
+	/*
+	 * Sending a signal requires that the sender
+	 * can write the receiver.
+	 */
+	rc = smk_curacc(tsp, MAY_WRITE);
+
+	return rc;
+}
+
+/*
+ * Superblock Hooks.
+ */
+static int smack_sb_alloc_security(struct super_block *sb)
+{
+	struct superblock_smack *sbsp;
+
+	sbsp = kzalloc(sizeof(struct superblock_smack), GFP_KERNEL);
+
+	if (sbsp == NULL)
+		return -ENOMEM;
+
+	sbsp->smk_root = SMK_FLOOR;
+	sbsp->smk_default = SMK_FLOOR;
+	sbsp->smk_floor = SMK_FLOOR;
+	sbsp->smk_hat = SMK_HAT;
+	sbsp->smk_initialized = 0;
+
+	sb->s_security = sbsp;
+
+	return 0;
+}
+
+static void smack_sb_free_security(struct super_block *sb)
+{
+	kfree(sb->s_security);
+	sb->s_security = NULL;
+}
+
+static int smack_sb_copy_data(struct file_system_type *type, void *orig,
+			      void *smackopts)
+{
+	char *cp, *commap, *otheropts, *dp;
+
+	/* Binary mount data: just copy */
+	if (type->fs_flags & FS_BINARY_MOUNTDATA) {
+		copy_page(smackopts, orig);
+		return 0;
+	}
+
+	otheropts = (char *)get_zeroed_page(GFP_KERNEL);
+	if (otheropts == NULL)
+		return -ENOMEM;
+
+	for (cp = orig, commap = orig; commap != NULL; cp = commap + 1) {
+		if (strstr(cp, SMK_FSDEFAULT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSFLOOR) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSHAT) == cp)
+			dp = smackopts;
+		else if (strstr(cp, SMK_FSROOT) == cp)
+			dp = smackopts;
+		else
+			dp = otheropts;
+
+		commap = strchr(cp, ',');
+		if (commap != NULL)
+			*commap = '\0';
+
+		if (*dp != '\0')
+			strcat(dp, ",");
+		strcat(dp, cp);
+	}
+
+	strcpy(orig, otheropts);
+	free_page((unsigned long)otheropts);
+
+	return 0;
+}
+
+static int smack_sb_kern_mount(struct super_block *sb, void *data)
+{
+	int rc;
+	struct dentry *root = sb->s_root;
+	struct inode *inode = root->d_inode;
+	struct superblock_smack *sp = sb->s_security;
+	struct inode_smack *isp;
+	char *op;
+	char *commap;
+
+	if (sp == NULL) {
+		rc = smack_sb_alloc_security(sb);
+		if (rc != 0)
+			return rc;
+	}
+	if (sp->smk_initialized != 0)
+		return 0;
+	if (inode == NULL)
+		return 0;
+
+	sp->smk_initialized = 1;
+
+	for (op = data; op != NULL; op = commap) {
+		commap = strchr(op, ',');
+		if (commap != NULL)
+			*commap++ = '\0';
+
+		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
+			op += strlen(SMK_FSHAT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_hat = smk_from_string(op);
+		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
+			op += strlen(SMK_FSFLOOR);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_floor = smk_from_string(op);
+		} else if (strncmp(op,SMK_FSDEFAULT,strlen(SMK_FSDEFAULT))==0) {
+			op += strlen(SMK_FSDEFAULT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_default = smk_from_string(op);
+		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
+			op += strlen(SMK_FSROOT);
+			if (strlen(op) <= SMK_MAXLEN)
+				sp->smk_root = smk_from_string(op);
+		}
+	}
+
+	/*
+	 * Initialize the root inode.
+	 */
+	isp = inode->i_security;
+	if (isp == NULL)
+		inode->i_security = new_inode_smack(sp->smk_root);
+	else
+		isp->smk_inode = sp->smk_root;
+
+	return 0;
+}
+
+static int smack_sb_statfs(struct dentry *dentry)
+{
+	struct superblock_smack *sbp;
+
+	if (dentry == NULL || dentry->d_sb == NULL ||
+	    dentry->d_sb->s_security == NULL)
+		return 0;
+
+	sbp = dentry->d_sb->s_security;
+
+	return smk_curacc(&sbp->smk_floor, MAY_READ);
+}
+
+static int smack_sb_mount(char *dev_name, struct nameidata *nd,
+        char *type, unsigned long flags, void *data)
+{
+	struct superblock_smack *sbp;
+	int rc;
+
+	if (nd == NULL || nd->mnt == NULL || nd->mnt->mnt_sb == NULL ||
+	    nd->mnt->mnt_sb->s_security == NULL)
+		return 0;
+
+	sbp = nd->mnt->mnt_sb->s_security;
+
+	rc = smk_curacc(&sbp->smk_floor, MAY_WRITE);
+	return rc;
+}
+
+static int smack_sb_umount(struct vfsmount *mnt, int flags)
+{
+	struct superblock_smack *sbp;
+	int rc;
+
+	sbp = mnt->mnt_sb->s_security;
+
+	rc = smk_curacc(&sbp->smk_floor, MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Inode hooks
+ */
+static int smack_inode_alloc_security(struct inode *inode)
+{
+	smack_t *csp = smk_of_task(current);
+
+        inode->i_security = new_inode_smack(*csp);
+        if (inode->i_security == NULL)
+                return -ENOMEM;
+	return 0;
+}
+
+static void smack_inode_free_security(struct inode *inode)
+{
+	kfree(inode->i_security);
+	inode->i_security = NULL;
+}
+
+static int smack_inode_init_security(struct inode *inode, struct inode *dir,
+                               char **name, void **value, size_t *len)
+{
+	smack_t *isp = smk_of_inode(inode);
+
+	if (name && (*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL)) == NULL)
+		return -ENOMEM;
+
+	if (value && (*value = kstrdup((char *)isp, GFP_KERNEL)) == NULL)
+		return -ENOMEM;
+
+	if (len)
+		*len = strlen((char *)isp) + 1;
+
+	return 0;
+}
+
+static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
+			    struct dentry *new_dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_symlink(struct inode *dir, struct dentry *dentry,
+			       const char *name)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_mknod(struct inode *dir, struct dentry *dentry,
+			     int mode, dev_t dev)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_rename(struct inode *old_inode,
+			      struct dentry *old_dentry,
+			      struct inode *new_inode,
+			      struct dentry *new_dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(old_inode), MAY_READWRITE);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(new_inode), MAY_READWRITE);
+	return rc;
+}
+
+static int smack_inode_readlink(struct dentry *dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_follow_link(struct dentry *dentry,
+				   struct nameidata *nameidata)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_permission(struct inode *inode, int mask,
+				  struct nameidata *nd)
+{
+	int rc;
+
+	/*
+	 * No permission to check. Existence test. Yup, it's there.
+	 */
+	if (mask == 0)
+		return 0;
+
+	rc = smk_curacc(smk_of_inode(inode), mask);
+	return rc;
+}
+
+static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+{
+	int rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+
+	return rc;
+}
+
+static int smack_inode_setxattr(struct dentry *dentry, char *name,
+			        void *value, size_t size, int flags)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_setxattr(dentry, name, value, size, flags);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
+				      void *value, size_t size, int flags)
+{
+	int i;
+	smack_t *vsp;
+	smack_t *isp;
+	char *nuller;
+
+	/*
+	 * Not SMACK
+	 */
+	if (strcmp(name, XATTR_NAME_SMACK))
+		return;
+
+	if (size >= sizeof(smack_t))
+		return;
+
+	vsp = (smack_t *)value;
+	isp = smk_of_inode(dentry->d_inode);
+	nuller = (char *)isp;
+
+	*isp = *vsp;
+
+	for (i = size; i < sizeof(smack_t); i++)
+		nuller[i] = '\0';
+
+	return;
+}
+
+static int smack_inode_getxattr(struct dentry *dentry, char *name)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_listxattr(struct dentry *dentry)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return rc;
+}
+
+static int smack_inode_removexattr(struct dentry *dentry, char *name)
+{
+	int rc;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
+		!__capable(current, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	rc = cap_inode_removexattr(dentry, name);
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
+}
+
+static const char *smack_inode_xattr_getsuffix(void)
+{
+	return XATTR_SMACK_SUFFIX;
+}
+
+static int smack_inode_getsecurity(const struct inode *inode, const char
*name, void *buffer, size_t size, int err)
+{
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+	smack_t *bsp = buffer;
+	smack_t *isp;
+
+	if (size < sizeof(smack_t) || name == NULL || bsp == NULL ||
+	    inode == NULL || inode->i_security == NULL)
+		return 0;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		isp = smk_of_inode(inode);
+		*bsp = *isp;
+		return strlen((char *)isp) + 1;
+	}
+
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	sbp = ip->i_sb;
+	if (sbp->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(ip);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0)
+		*bsp = ssp->smk_packet;
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		*bsp = ssp->smk_in;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		*bsp = ssp->smk_out;
+	else
+		return -EOPNOTSUPP;
+
+	return strlen((char *)bsp) + 1;
+}
+
+static int smack_inode_setsecurity(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	smack_t smack;
+	smack_t *isp = smk_of_inode(inode);
+	struct socket_smack *ssp;
+	struct socket *sock;
+	struct super_block *sbp;
+	struct inode *ip = (struct inode *)inode;
+
+	if (value == NULL || size > sizeof(smack_t))
+		return -EACCES;
+
+	smack = smk_from_buffer(value, size);
+	if (smack == SMK_INVALID)
+		return -EINVAL;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		*isp = smack;
+		return 0;
+	}
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	sbp = ip->i_sb;
+	if (sbp->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(ip);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_PACKET) == 0)
+		ssp->smk_packet = smack;
+	else if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		ssp->smk_in = smack;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
+		ssp->smk_out = smack;
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int smack_inode_listsecurity(struct inode *inode, char *buffer,
+				    size_t buffer_size)
+{
+	int len = strlen(XATTR_NAME_SMACK);
+
+	if (buffer != NULL && len <= buffer_size) {
+		memcpy(buffer, XATTR_NAME_SMACK, len);
+		return len;
+	}
+	return -EINVAL;
+}
+
+static void smack_d_instantiate (struct dentry *opt_dentry, struct inode
*inode)
+{
+	struct super_block *sbp;
+	struct superblock_smack *sbsp;
+	struct inode_smack *isp;
+	smack_t *csp = smk_of_task(current);
+	smack_t sbs;
+	smack_t final = SMK_UNSET;
+	struct dentry *dp;
+	int rc;
+
+	if (inode == NULL)
+		return;
+
+	if (inode->i_security == NULL)
+		inode->i_security = new_inode_smack(SMK_UNSET);
+
+	isp = inode->i_security;
+
+	mutex_lock(&isp->smk_lock);
+	/*
+	 * If the inode is already instantiated
+	 * take the quick way out
+	 */
+	if (isp->smk_flags & SMK_INODE_INSTANT)
+		goto unlockandout;
+
+	sbp = inode->i_sb;
+	sbsp = sbp->s_security;
+	/*
+	 * We're going to use the superblock default label
+	 * if there's no label on the file.
+	 */
+	sbs = sbsp->smk_default;
+
+	/*
+	 * This is pretty hackish.
+	 * Casey says that we shouldn't have to do
+	 * file system specific code, but it does help
+	 * with keeping it simple.
+	 */
+	switch (sbp->s_magic) {
+	case SMACK_MAGIC:
+		/*
+		 * Casey says that it's a little embarassing
+		 * that the smack file system doesn't do
+		 * extended attributes.
+		 */
+		final = SMK_STAR;
+		break;
+	case PIPEFS_MAGIC:
+		/*
+		 * Casey says pipes are easy (?)
+		 */
+		final = SMK_STAR;
+		break;
+	case DEVPTS_SUPER_MAGIC:
+		/*
+		 * devpts seems content with the label of the task.
+		 * Programs that change smack have to treat the
+		 * pty with respect.
+		 */
+		final = *csp;
+		break;
+	case SOCKFS_MAGIC:
+		/*
+		 * Casey says sockets get the smack of the task.
+		 */
+		final = *csp;
+		break;
+	case PROC_SUPER_MAGIC:
+		/*
+		 * Casey says procfs appears not to care.
+		 */
+		final = sbs;
+		break;
+	case TMPFS_MAGIC:
+		/*
+		 * Device labels should come from the filesystem,
+		 * but watch out, because they're volitile,
+		 * getting recreated on every reboot.
+		 */
+		sbs = SMK_STAR;
+		/*
+		 * No break.
+		 *
+		 * If a smack value has been set we want to use it,
+		 * but since tmpfs isn't giving us the opportunity
+		 * to set mount options simulate setting the
+		 * superblock default.
+		 */
+	default:
+		/*
+		 * This isn't an understood special case.
+		 * Get the value from the xattr.
+		 *
+		 * No xattr support means, alas, no SMACK label.
+		 * Use the aforeapplied default.
+		 * It would be curious if the label of the task
+		 * does not match that assigned.
+		 */
+		if (inode->i_op->getxattr == NULL) {
+			final = sbs;
+			break;
+		}
+		/*
+		 * Get the dentry for xattr.
+		 */
+		if (opt_dentry == NULL) {
+			dp = d_find_alias(inode);
+			if (dp == NULL) {
+				final = sbs;
+				break;
+			}
+		} else {
+			dp = dget(opt_dentry);
+			if (dp == NULL) {
+				final = sbs;
+				break;
+			}
+		}
+		
+		rc = smk_fetch(inode, dp, &final);
+		if (rc < 0)
+			final = sbs;
+
+		dput(dp);
+		break;
+	}
+
+	if (final == SMK_UNSET) {
+		printk("%s:%d unset? Investigate!\n", __FUNCTION__, __LINE__);
+		final = *csp;
+	}
+	isp->smk_inode = final;
+	isp->smk_flags |= SMK_INODE_INSTANT;
+
+unlockandout:
+	mutex_unlock(&isp->smk_lock);
+	return;
+}
+
+/*
+ * File Hooks
+ */
+
+static int smack_file_alloc_security(struct file *file)
+{
+	smack_t *csp = smk_of_task(current);
+
+	file->f_security = new_smack_t(*csp);
+	if (file->f_security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_file_free_security(struct file *file)
+{
+	file->f_security = free_smack_t(file->f_security);
+}
+
+/*
+ * Should access checks be done on each read or write?
+ * UNICOS and SELinux say yes.
+ * Trusted Solaris, Trusted Irix, and just about everyone else says no.
+ *
+ * I'll say no for now. Smack does not do the frequent
+ * label changing that SELinux does.
+ */
+static int smack_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+static int smack_file_ioctl(struct file *file, unsigned int cmd,
+                            unsigned long arg)
+{
+	int rc = 0;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+
+	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
+		rc = smk_curacc(file->f_security, MAY_READ);
+
+	return rc;
+}
+
+static int smack_file_lock(struct file *file, unsigned int cmd)
+{
+	int rc;
+
+	rc = smk_curacc(file->f_security, MAY_WRITE);
+	return rc;
+}
+
+static int smack_file_fcntl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int rc;
+
+	switch (cmd) {
+	case F_DUPFD:
+	case F_GETFD:
+	case F_GETFL:
+	case F_GETLK:
+	case F_GETOWN:
+	case F_GETSIG:
+		rc = smk_curacc(file->f_security, MAY_READ);
+		break;
+	case F_SETFD:
+	case F_SETFL:
+	case F_SETLK:
+	case F_SETLKW:
+	case F_SETOWN:
+	case F_SETSIG:
+		rc = smk_curacc(file->f_security, MAY_WRITE);
+		break;
+	default:
+		rc = smk_curacc(file->f_security, MAY_READWRITE);
+	}
+
+	return rc;
+}
+
+static int smack_file_send_sigiotask(struct task_struct *tsk,
+                                     struct fown_struct *fown, int signum)
+{
+	struct file *file;
+	int rc;
+
+	/*
+	 * struct fown_struct is never outside the context of a struct file
+	 */
+	file = (struct file *)((long)fown - offsetof(struct file,f_owner));
+	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
+	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
+		return 0;
+	return rc;
+}
+
+static inline int file_may(struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		return (file->f_mode & FMODE_WRITE) ? MAY_READWRITE : MAY_READ;
+
+	return (file->f_mode & FMODE_WRITE) ? MAY_WRITE : 0;
+}
+
+static int smack_file_receive(struct file *file)
+{
+	int may = 0;
+	int rc;
+
+	/*
+	 * This code relies on bitmasks.
+	 */
+	if (file->f_mode & FMODE_READ)
+		may = MAY_READ;
+	if (file->f_mode & FMODE_WRITE)
+		may |= MAY_WRITE;
+
+	rc = smk_curacc(file->f_security, may);
+	return rc;
+}
+
+/*
+ * Socket hooks.
+ */
+
+/*
+ * Initialize the socket blob from the associated task.
+ */
+static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t
priority)
+{
+	smack_t *csp = smk_of_task(current);
+	struct socket_smack *ssp;
+
+	ssp = kzalloc(sizeof(struct socket_smack), priority);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_in = *csp;
+	ssp->smk_out = *csp;
+	ssp->smk_packet = SMK_INVALID;
+
+	sk->sk_security = ssp;
+
+	return 0;
+}
+
+/*
+ * Free the blob.
+ */
+static void smack_sk_free_security(struct sock *sk)
+{
+	kfree(sk->sk_security);
+	sk->sk_security = NULL;
+}
+
+static void smack_set_catset(smack_t catset, struct netlbl_lsm_secattr *sap)
+{
+	unsigned char *cp;
+	unsigned char m;
+	int cat;
+	int rc;
+
+	if (catset == 0LL)
+		return;
+
+	sap->flags |= NETLBL_SECATTR_MLS_CAT;
+	sap->mls_cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+	sap->mls_cat->startbit = 0;
+
+	for (cat = 1, cp = (unsigned char *)&catset; *cp != 0; cp++)
+		for (m = 0x80; m != 0; m >>= 1, cat++) {
+			if ((m & *cp) == 0)
+				continue;
+			rc = netlbl_secattr_catmap_setbit(sap->mls_cat, cat,
+							  GFP_ATOMIC);
+		}
+}
+
+/*
+ * Casey says that CIPSO is good enough for now.
+ * It can be used to effect.
+ * It can also be abused to effect when necessary.
+ * Appologies to the TSIG group in general and GW in particular.
+ */
+static void smack_to_secattr(smack_t smack, struct netlbl_lsm_secattr *nlsp)
+{
+	struct smk_cipso_entry *scp;
+
+	switch (smack_net_nltype) {
+	case NETLBL_NLTYPE_CIPSOV4:
+		nlsp->domain = NULL;
+		nlsp->flags = NETLBL_SECATTR_DOMAIN;
+		nlsp->flags |= NETLBL_SECATTR_MLS_LVL;
+
+		for (scp = smack_cipso; scp != NULL; scp = scp->smk_next)
+			if (scp->smk_smack == smack)
+				break;
+
+		if (scp != NULL) {
+			nlsp->mls_lvl = scp->smk_level;
+			smack_set_catset(scp->smk_catset, nlsp);
+		} else {
+			nlsp->mls_lvl = smack_cipso_direct;
+			smack_set_catset(smack, nlsp);
+		}
+		break;
+	case NETLBL_NLTYPE_NONE:
+	case NETLBL_NLTYPE_UNLABELED:
+		break;
+	default:
+		break;
+	}
+}
+
+static int smack_netlabel(struct sock *sk)
+{
+	struct socket_smack *ssp = sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+	int rc;
+
+	netlbl_secattr_init(&secattr);
+	smack_to_secattr(ssp->smk_out, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(sk, &secattr);
+	else
+		rc = -EINVAL;
+
+	netlbl_secattr_destroy(&secattr);
+	return rc;
+}
+
+static int smack_socket_post_create(struct socket *sock, int family,
+				    int type, int protocol, int kern)
+{
+	struct inode_smack *isp;
+	smack_t *csp;
+	int rc = 0;
+
+	isp = SOCK_INODE(sock)->i_security;
+
+	if (isp == NULL) {
+		if (kern)
+			isp = new_inode_smack(SMK_FLOOR);
+		else {
+			csp = smk_of_task(current);
+			isp = new_inode_smack(*csp);
+		}
+		SOCK_INODE(sock)->i_security = isp;
+	}
+
+	if (family != PF_INET)
+		return 0;
+
+	/*
+	 * Set the outbound netlbl.
+	 */
+	rc = smack_netlabel(sock->sk);
+
+	return rc;
+}
+
+static int smack_inode_create(struct inode *dir, struct dentry *dentry,
+			      int mode)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're unlinking
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+static int smack_inode_mkdir(struct inode *dir, struct dentry *dentry, int
mode)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+	return rc;
+}
+
+static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *ip = dentry->d_inode;
+	int rc;
+
+	/*
+	 * You need write access to the thing you're removing
+	 */
+	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
+	if (rc == 0)
+		/*
+		 * You also need write access to the containing directory
+		 */
+		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+
+	return rc;
+}
+
+static int smack_file_set_fowner(struct file *file)
+{
+	smack_t *fsp = file->f_security;
+	smack_t *csp = smk_of_task(current);
+
+	*fsp = *csp;
+
+	return 0;
+}
+
+static int smack_task_getpgid(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static int smack_task_getsid(struct task_struct *p)
+{
+	int rc;
+
+	rc = smk_curacc(smk_of_task(p), MAY_READ);
+	return rc;
+}
+
+static void smack_task_getsecid(struct task_struct *p, u32 *secid)
+{
+	/*
+	 * This is supposed to be called once, at boot,
+	 * by the netlabel system.
+	 */
+	*secid = SMK32_FLOOR;
+}
+
+static int smack_flags_to_may(int flags)
+{
+	int may = 0;
+
+	if (flags & S_IRUGO)
+		may |= MAY_READ;
+	if (flags & S_IWUGO)
+		may |= MAY_WRITE;
+	if (flags & S_IXUGO)
+		may |= MAY_EXEC;
+
+	return may;
+}
+
+static int smack_msg_msg_alloc_security(struct msg_msg *msg)
+{
+	smack_t *csp = smk_of_task(current);
+
+	msg->security = new_smack_t(*csp);
+	if (msg->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_msg_msg_free_security(struct msg_msg *msg)
+{
+	msg->security = free_smack_t(msg->security);
+}
+
+
+static smack_t *smack_of_shm(struct shmid_kernel *shp)
+{
+	if (shp == NULL)
+		return NULL;
+
+	return (smack_t *)shp->shm_perm.security;
+}
+
+static int smack_shm_alloc_security(struct shmid_kernel *shp)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = new_smack_t(*csp);
+	if (isp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_shm_free_security(struct shmid_kernel *shp)
+{
+	struct kern_ipc_perm *isp = &shp->shm_perm;
+
+	isp->security = free_smack_t(isp->security);
+}
+
+static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(shmflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case SHM_STAT:
+		rc = MAY_READ;
+		break;
+	case IPC_SET:
+	case SHM_LOCK:
+	case SHM_UNLOCK:
+	case IPC_RMID:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SHM_INFO:
+		/*
+		 * System level information.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int
shmflg)
+{
+	smack_t *ssp = smack_of_shm(shp);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(shmflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static smack_t *smack_of_sem(struct sem_array *sma)
+{
+	if (sma == NULL)
+		return NULL;
+
+	return (smack_t *)sma->sem_perm.security;
+}
+
+static int smack_sem_alloc_security(struct sem_array *sma)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = new_smack_t(*csp);
+	if (isp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_sem_free_security(struct sem_array *sma)
+{
+	struct kern_ipc_perm *isp = &sma->sem_perm;
+
+	isp->security = free_smack_t(isp->security);
+}
+
+
+static int smack_sem_associate(struct sem_array *sma, int semflg)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(semflg);
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_sem_semctl(struct sem_array *sma, int cmd)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case GETPID:
+	case GETNCNT:
+	case GETZCNT:
+	case GETVAL:
+	case GETALL:
+	case IPC_STAT:
+	case SEM_STAT:
+		rc = MAY_READ;
+		break;
+	case SETVAL:
+	case SETALL:
+	case IPC_RMID:
+	case IPC_SET:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case SEM_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(ssp, rc);
+	return rc;
+}
+
+static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
unsigned nsops, int alter)
+{
+	smack_t *ssp = smack_of_sem(sma);
+	int rc;
+
+	if (ssp == NULL)
+		return 0;
+
+	rc = smk_curacc(ssp, MAY_READWRITE);
+	return rc;
+}
+
+static int smack_msg_queue_alloc_security(struct msg_queue *msq)
+{
+	smack_t *csp = smk_of_task(current);
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = new_smack_t(*csp);
+	if (kisp->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_msg_queue_free_security(struct msg_queue *msq)
+{
+	struct kern_ipc_perm *kisp = &msq->q_perm;
+
+	kisp->security = free_smack_t(kisp->security);
+}
+
+static smack_t *smack_of_msq(struct msg_queue *msq)
+{
+	if (msq == NULL)
+		return NULL;
+
+	return (smack_t *)msq->q_perm.security;
+}
+
+static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(msqflg);
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	switch(cmd) {
+	case IPC_STAT:
+	case MSG_STAT:
+		rc = MAY_READ;
+		break;
+	case IPC_SET:
+	case IPC_RMID:
+		rc = MAY_READWRITE;
+		break;
+	case IPC_INFO:
+	case MSG_INFO:
+		/*
+		 * System level information
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
int msqflg)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smack_flags_to_may(msqflg);
+	rc = smk_curacc(msp, rc);
+	return rc;
+}
+
+static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
struct task_struct *target, long type, int mode)
+{
+	smack_t *msp = smack_of_msq(msq);
+	int rc;
+
+	if (msp == NULL)
+		return 0;
+
+	rc = smk_curacc(msp, MAY_READWRITE);
+	return rc;
+}
+
+static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
+{
+	smack_t *isp = ipp->security;
+	int rc;
+
+	rc = smack_flags_to_may(flag);
+	rc = smk_curacc(isp, rc);
+
+	return rc;
+}
+
+static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
+{
+	smack_t *tsp = smk_of_task(p);
+	smack_t *isp = smk_of_inode(inode);
+
+	*isp = *tsp;
+}
+
+static int smack_task_wait(struct task_struct *p)
+{
+	smack_t *tsp = smk_of_task(p);
+	smack_t *csp = smk_of_task(current);
+	int rc;
+
+	rc = smk_access(csp, tsp, MAY_WRITE);
+	if (rc == 0)
+		return 0;
+
+	/*
+	 * Allow the operation to succeed if either task
+	 * has privilege to perform operations that might
+	 * account for the smack labels having gotten to
+	 * be different in the first place.
+	 *
+	 * This breaks the strict subjet/object access
+	 * control ideal, taking the object's privilege
+	 * state into account in the decision as well as
+	 * the smack value.
+	 */
+	if (__capable(current, CAP_MAC_OVERRIDE) ||
+		__capable(p, CAP_MAC_OVERRIDE))
+		return 0;
+	
+	return rc;
+}
+
+static int smack_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	smack_t *sp = smk_of_task(p);
+	int slen = strlen((char *)sp);
+
+	if (strcmp(name, "current") == 0) {
+		*value = (char *)new_smack_t(*sp);
+		return slen;
+	}
+
+	return -EINVAL;
+}
+
+static int smack_setprocattr(struct task_struct *p, char *name,
+			     void *value, size_t size)
+{
+	smack_t *psp = smk_of_task(p);
+	smack_t newsmack = 0LL;
+
+	if (!__capable(p, CAP_MAC_OVERRIDE))
+		return -EPERM;
+
+	if (value == NULL || size == 0 || size >= sizeof(smack_t))
+		return -EINVAL;
+
+	if (strcmp(name, "current") == 0) {
+		newsmack = smk_from_buffer(value, size);
+		if (newsmack == SMK_INVALID)
+			return -EINVAL;
+		*psp = newsmack;
+		return size;
+	}
+	return -EINVAL;
+}
+
+static int smack_unix_stream_connect(struct socket *sock,
+				     struct socket *other, struct sock *newsk)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+	int rc;
+
+	rc = smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_READWRITE);
+	return rc;
+}
+
+static int smack_unix_may_send(struct socket *sock, struct socket *other)
+{
+	struct inode *sp = SOCK_INODE(sock);
+	struct inode *op = SOCK_INODE(other);
+	int rc;
+
+	rc = smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Convert a netlabel mls_lvl/mls_cat pair into a smack value.
+ */
+
+static smack_t smack_from_secattr(struct netlbl_lsm_secattr *sap)
+{
+	struct smk_cipso_entry *scp;
+	smack_t smack = 0LL;
+	int pcat;
+
+	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) == 0) {
+		/*
+		 * If there are flags but no level netlabel isn't
+		 * behaving the way we expect it to.
+		 *
+		 * Without guidance regarding the smack value
+		 * for the packet fall back on the network
+		 * ambient value.
+		 */
+		return smack_net_ambient;
+	}
+	/*
+	 * Get the categories, if any
+	 */
+	if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
+		for (pcat = -1;;) {
+			pcat = netlbl_secattr_catmap_walk(sap->mls_cat, pcat+1);
+			if (pcat < 0)
+				break;
+			smack_catset_bit(pcat, &smack);
+		}
+	/*
+	 * If it is CIPSO using smack direct mapping
+	 * we are already done. WeeHee.
+	 */
+	if (sap->mls_lvl == smack_cipso_direct)
+		return smack;
+
+	/*
+	 * Look it up in the supplied table if it is not a direct mapping.
+	 */
+	for (scp = smack_cipso; scp != NULL; scp = scp->smk_next)
+		if (scp->smk_level == sap->mls_lvl && scp->smk_catset == smack)
+			return scp->smk_smack;
+	/*
+	 * It is CIPSO, but not one we know.
+	 */
+
+	return SMK_HUH;
+}
+
+static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct netlbl_lsm_secattr secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	smack_t si;
+	int rc;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return 0;
+
+	/*
+	 * Translate what netlabel gave us.
+	 */
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0)
+		si = smack_from_secattr(&secattr);
+	else
+		si = smack_net_ambient;
+	netlbl_secattr_destroy(&secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 * This is the simplist possible security model
+	 * for networking.
+	 */
+	rc = smk_access(&si, &ssp->smk_in, MAY_WRITE);
+
+	/*
+	 * Set the receive packet on success.
+	 */
+	if (rc == 0)
+		ssp->smk_packet = si;
+
+	return rc;
+}
+
+static void smack_sock_graft(struct sock *sk, struct socket *parent)
+{
+	struct socket_smack *ssp;
+	struct netlbl_lsm_secattr secattr;
+	smack_t ssi;
+	int rc;
+
+	if (sk == NULL || parent == NULL || parent->sk == NULL)
+		return;
+
+	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
+		return;
+
+	ssp = parent->sk->sk_security;
+
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_sock_getattr(sk, &secattr);
+	if (rc == 0)
+		ssi = smack_from_secattr(&secattr);
+	else
+		ssi = SMK_HUH;
+	netlbl_secattr_destroy(&secattr);
+
+	netlbl_secattr_init(&secattr);
+
+	smack_to_secattr(ssi, &secattr);
+	if (secattr.flags != NETLBL_SECATTR_NONE)
+		rc = netlbl_sock_setattr(parent->sk, &secattr);
+	netlbl_secattr_destroy(&secattr);
+}
+
+static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
+				   struct request_sock *req)
+{
+	struct netlbl_lsm_secattr skb_secattr;
+	struct socket_smack *ssp = sk->sk_security;
+	smack_t sb;
+	int rc;
+	
+	if (skb == NULL)
+		return -EACCES;
+
+	netlbl_secattr_init(&skb_secattr);
+	rc = netlbl_skbuff_getattr(skb, &skb_secattr);
+	if (rc == 0)
+		sb = smack_from_secattr(&skb_secattr);
+	else
+		sb = SMK_HUH;
+	netlbl_secattr_destroy(&skb_secattr);
+	/*
+	 * Receiving a packet requires that the other end
+	 * be able to write here. Read access is not required.
+	 */
+	rc = smk_access(&sb, &ssp->smk_in, MAY_WRITE);
+	return rc;
+}
+
+/*
+ * Key management security hooks
+ *
+ * Casey has not tested key support very heavily.
+ * The permission check is most likely too restrictive.
+ * If you care about keys please have a look.
+ */
+#ifdef CONFIG_KEYS
+static int smack_key_alloc(struct key *key, struct task_struct *tsk,
+			   unsigned long flags)
+{
+	key->security = new_smack_t(smack_of_task(tsk));
+	if (key->security == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void smack_key_free(struct key *key)
+{
+	key->security = free_smack_t(key->security);
+}
+
+/*
+ * Casey says that until he understands the key permissions
+ * better the task is only going to have access to the key
+ * if it has read and write access.
+ */
+static int smack_key_permission(key_ref_t key_ref,
+			        struct task_struct *context, key_perm_t perm)
+{
+	struct key *keyp;
+	smack_t *ksp;
+	smack_t *tsp;
+	int rc;
+
+	keyp = key_ref_to_ptr(key_ref);
+	if (keyp == NULL)
+		return -EINVAL;
+
+	ksp = keyp->security;
+	tsp = smk_of_task(context);
+
+	rc = smk_access(tsp, ksp, MAY_READWRITE);
+
+	return rc;
+}
+#endif /* CONFIG_KEYS */
+
+static struct security_operations smack_ops = {
+	.ptrace = 			smack_ptrace,
+	.capget = 			cap_capget,
+	.capset_check = 		cap_capset_check,
+	.capset_set = 			cap_capset_set,
+	.capable = 			cap_capable,
+	/* .acct			No hook required */
+	/* .sysctl			No hook required */
+	/* .quotactl			No hook required */
+	/* .quota_on			No hook required */
+	.syslog = 			smack_syslog,
+	.settime = 			cap_settime,
+	.vm_enough_memory = 		cap_vm_enough_memory,
+
+	/* .bprm_alloc_security		No hook required */
+	/* .bprm_free_security		No hook required */
+	.bprm_apply_creds = 		cap_bprm_apply_creds,
+	/* .bprm_post_apply_creds	No hook required */
+	.bprm_set_security = 		cap_bprm_set_security,
+	/* .bprm_check_security		No hook required */
+	.bprm_secureexec = 		cap_bprm_secureexec,
+
+	.sb_alloc_security = 		smack_sb_alloc_security,
+	.sb_free_security = 		smack_sb_free_security,
+	.sb_copy_data = 		smack_sb_copy_data,
+	.sb_kern_mount = 		smack_sb_kern_mount,
+	.sb_statfs = 			smack_sb_statfs,
+	.sb_mount = 			smack_sb_mount,
+	/* .sb_check_sb			No hook required */
+	.sb_umount = 			smack_sb_umount,
+	/* .sb_umount_close		No hook required */
+	/* .sb_umount_busy		No hook required */
+	/* .sb_post_remount		No hook required */
+	/* .sb_post_mountroot		No hook required */
+	/* .sb_post_addmount		No hook required */
+	/* .sb_pivotroot		No hook required */
+	/* .sb_post_pivotroot		No hook required */
+
+	.inode_alloc_security = 	smack_inode_alloc_security,
+	.inode_free_security = 		smack_inode_free_security,
+	.inode_init_security = 		smack_inode_init_security,
+	.inode_create = 		smack_inode_create,
+	.inode_link = 			smack_inode_link,
+	.inode_unlink = 		smack_inode_unlink,
+	.inode_symlink = 		smack_inode_symlink,
+	.inode_mkdir = 			smack_inode_mkdir,
+	.inode_rmdir = 			smack_inode_rmdir,
+	.inode_mknod = 			smack_inode_mknod,
+	.inode_rename = 		smack_inode_rename,
+	.inode_readlink = 		smack_inode_readlink,
+	.inode_follow_link = 		smack_inode_follow_link,
+	.inode_permission = 		smack_inode_permission,
+	.inode_setattr = 		smack_inode_setattr,
+	.inode_getattr = 		smack_inode_getattr,
+	/* .inode_delete		No hook required */
+	.inode_setxattr = 		smack_inode_setxattr,
+	.inode_post_setxattr = 		smack_inode_post_setxattr,
+	.inode_getxattr = 		smack_inode_getxattr,
+	.inode_listxattr = 		smack_inode_listxattr,
+	.inode_removexattr = 		smack_inode_removexattr,
+	.inode_xattr_getsuffix = 	smack_inode_xattr_getsuffix,
+	.inode_getsecurity = 		smack_inode_getsecurity,
+	.inode_setsecurity = 		smack_inode_setsecurity,
+	.inode_listsecurity = 		smack_inode_listsecurity,
+
+	.file_permission = 		smack_file_permission,
+	.file_alloc_security = 		smack_file_alloc_security,
+	.file_free_security = 		smack_file_free_security,
+	.file_ioctl = 			smack_file_ioctl,
+	/* .file_mmap			No hook required */
+	/* .file_mprotect		No hook required */
+	.file_lock = 			smack_file_lock,
+	.file_fcntl = 			smack_file_fcntl,
+	.file_set_fowner = 		smack_file_set_fowner,
+	.file_send_sigiotask = 		smack_file_send_sigiotask,
+	.file_receive = 		smack_file_receive,
+
+	/* .task_create			No hook required */
+	.task_alloc_security = 		smack_task_alloc_security,
+	.task_free_security = 		smack_task_free_security,
+	/* .task_setuid			No hook required */
+	.task_post_setuid =		cap_task_post_setuid,
+	/* .task_setgid			No hook required */
+	.task_setpgid = 		smack_task_setpgid,
+	.task_getpgid = 		smack_task_getpgid,
+	.task_getsid = 			smack_task_getsid,
+	.task_getsecid = 		smack_task_getsecid,
+	/* .task_setgroups		No hook required */
+	.task_setnice = 		smack_task_setnice,
+	.task_setioprio = 		smack_task_setioprio,
+	.task_getioprio = 		smack_task_getioprio,
+	/* .task_setrlimit		No hook required */
+	.task_setscheduler = 		smack_task_setscheduler,
+	.task_getscheduler = 		smack_task_getscheduler,
+	.task_movememory = 		smack_task_movememory,
+	.task_kill = 			smack_task_kill,
+	.task_wait = 			smack_task_wait,
+	/* .task_prctl			No hook required */
+	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_to_inode = 		smack_task_to_inode,
+
+	.ipc_permission = 		smack_ipc_permission,
+
+	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
+	.msg_msg_free_security = 	smack_msg_msg_free_security,
+
+	.msg_queue_alloc_security = 	smack_msg_queue_alloc_security,
+	.msg_queue_free_security = 	smack_msg_queue_free_security,
+	.msg_queue_associate = 		smack_msg_queue_associate,
+	.msg_queue_msgctl = 		smack_msg_queue_msgctl,
+	.msg_queue_msgsnd = 		smack_msg_queue_msgsnd,
+	.msg_queue_msgrcv = 		smack_msg_queue_msgrcv,
+
+	.shm_alloc_security = 		smack_shm_alloc_security,
+	.shm_free_security = 		smack_shm_free_security,
+	.shm_associate = 		smack_shm_associate,
+	.shm_shmctl = 			smack_shm_shmctl,
+	.shm_shmat = 			smack_shm_shmat,
+
+	.sem_alloc_security = 		smack_sem_alloc_security,
+	.sem_free_security = 		smack_sem_free_security,
+	.sem_associate = 		smack_sem_associate,
+	.sem_semctl = 			smack_sem_semctl,
+	.sem_semop = 			smack_sem_semop,
+
+	.netlink_send =			cap_netlink_send,
+	.netlink_recv = 		cap_netlink_recv,
+
+	/* .register_security		No hook required */
+	/* .unregister_security		No hook required */
+
+	.d_instantiate = 		smack_d_instantiate,
+
+	.getprocattr = 			smack_getprocattr,
+	.setprocattr = 			smack_setprocattr,
+	/* .secid_to_secctx		No hook required */
+	/* .release_secctx		No hook required */
+
+	.unix_stream_connect = 		smack_unix_stream_connect,
+	.unix_may_send = 		smack_unix_may_send,
+
+	/* .socket_create 		No hook required */
+	.socket_post_create = 		smack_socket_post_create,
+	/* .socket_bind 		No hook required */
+	/* .socket_connect 		No hook required */
+	/* .socket_listen 		No hook required */
+	/* .socket_accept 		No hook required */
+	/* .socket_post_accept 		No hook required */
+	/* .socket_sendmsg 		No hook required */
+	/* .socket_recvmsg 		No hook required */
+	/* .socket_getsockname		No hook required */
+	/* .socket_getpeername		No hook required */
+	/* .socket_getsockopt		No hook required */
+	/* .socket_setsockopt		No hook required */
+	/* .socket_shutdown		No hook required */
+	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
+	/* .socket_getpeersec_stream	No hook required */
+	/* .socket_getpeersec_dgram	No hook required */
+	.sk_alloc_security = 		smack_sk_alloc_security,
+	.sk_free_security = 		smack_sk_free_security,
+	/* .sk_clone_security 		No hook required */
+	/* .sk_getsecid 		No hook required */
+	.sock_graft = 			smack_sock_graft,
+	.inet_conn_request = 		smack_inet_conn_request,
+	/* .inet_csk_clone		No hook required */
+	/* .inet_conn_established	No hook required */
+
+	/* .req_classify_flow 		No hook required */
+	/* .xfrm_policy_alloc_security	no xfrm for smack */
+	/* .xfrm_policy_clone_security	no xfrm for smack */
+	/* .xfrm_policy_free_security	no xfrm for smack */
+	/* .xfrm_policy_delete_security	no xfrm for smack */
+	/* .xfrm_state_alloc_security	no xfrm for smack */
+	/* .xfrm_state_free_security	no xfrm for smack */
+	/* .xfrm_state_delete_security	no xfrm for smack */
+	/* .xfrm_policy_lookup		no xfrm for smack */
+	/* .xfrm_state_pol_flow_match	no xfrm for smack */
+	/* .xfrm_decode_session		no xfrm for smack */
+
+ /* key management security hooks */
+#ifdef CONFIG_KEYS
+	.key_alloc = 			smack_key_alloc,
+	.key_free = 			smack_key_free,
+	.key_permission = 		smack_key_permission,
+#endif /* CONFIG_KEYS */
+
+};
+
+static __init int smack_init(void)
+{
+	struct task_smack *tsp;
+	printk(KERN_INFO "Smack:  Initializing.\n");
+
+	/* Set the security state for the initial task. */
+
+	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+	if (tsp == NULL)
+		panic("smack:  Failed to initialize initial task.\n");
+
+	tsp->smk_task = SMK_FLOOR;
+	current->security = tsp;
+
+	if (register_security(&smack_ops))
+		panic("smack: Unable to register with kernel.\n");
+
+	return 0;
+}
+
+/* smack requires early initialization in order to label
+   all processes and objects when they are created. */
+security_initcall(smack_init);
+


Casey Schaufler
casey@schaufler-ca.com
