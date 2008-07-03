Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYGCOWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYGCOWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759286AbYGCOWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:22:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47442 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbYGCOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:22:10 -0400
To: viro@ZenIV.linux.org.uk
CC: akpm@linux-foundation.org, hch@infradead.org, eparis@redhat.com,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [patch] LSM/SELinux: show LSM mount options in /proc/mounts
Message-Id: <E1KEPh0-0002RC-KF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Jul 2008 16:21:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, could you please add this to your 2.6.27 queue?

Thanks,
Miklos

----
From: Eric Paris <eparis@redhat.com>

This patch causes SELinux mount options to show up in /proc/mounts.  As
with other code in the area seq_put errors are ignored.  Other LSM's
will not have their mount options displayed until they fill in their own
security_sb_show_options() function.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c           |   14 +++++++++--
 include/linux/security.h |    9 +++++++
 security/dummy.c         |    6 +++++
 security/security.c      |    5 ++++
 security/selinux/hooks.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 85 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-07-03 16:10:08.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-07-03 16:11:35.000000000 +0200
@@ -79,6 +79,7 @@ struct xfrm_selector;
 struct xfrm_policy;
 struct xfrm_state;
 struct xfrm_user_sec_ctx;
+struct seq_file;
 
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
@@ -1328,6 +1329,7 @@ struct security_operations {
 	void (*sb_free_security) (struct super_block *sb);
 	int (*sb_copy_data) (char *orig, char *copy);
 	int (*sb_kern_mount) (struct super_block *sb, void *data);
+	int (*sb_show_options) (struct seq_file *m, struct super_block *sb);
 	int (*sb_statfs) (struct dentry *dentry);
 	int (*sb_mount) (char *dev_name, struct path *path,
 			 char *type, unsigned long flags, void *data);
@@ -1606,6 +1608,7 @@ int security_sb_alloc(struct super_block
 void security_sb_free(struct super_block *sb);
 int security_sb_copy_data(char *orig, char *copy);
 int security_sb_kern_mount(struct super_block *sb, void *data);
+int security_sb_show_options(struct seq_file *m, struct super_block *sb);
 int security_sb_statfs(struct dentry *dentry);
 int security_sb_mount(char *dev_name, struct path *path,
 		      char *type, unsigned long flags, void *data);
@@ -1881,6 +1884,12 @@ static inline int security_sb_kern_mount
 	return 0;
 }
 
+static inline int security_sb_show_options(struct seq_file *m,
+					   struct super_block *sb)
+{
+	return 0;
+}
+
 static inline int security_sb_statfs(struct dentry *dentry)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-07-03 16:10:08.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-07-03 16:11:35.000000000 +0200
@@ -193,6 +193,11 @@ static int dummy_sb_kern_mount (struct s
 	return 0;
 }
 
+static int dummy_sb_show_options(struct seq_file *m, struct super_block *sb)
+{
+	return 0;
+}
+
 static int dummy_sb_statfs (struct dentry *dentry)
 {
 	return 0;
@@ -1087,6 +1092,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, sb_free_security);
 	set_to_dummy_if_null(ops, sb_copy_data);
 	set_to_dummy_if_null(ops, sb_kern_mount);
+	set_to_dummy_if_null(ops, sb_show_options);
 	set_to_dummy_if_null(ops, sb_statfs);
 	set_to_dummy_if_null(ops, sb_mount);
 	set_to_dummy_if_null(ops, sb_check_sb);
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-07-03 16:10:08.000000000 +0200
+++ linux-2.6/security/security.c	2008-07-03 16:11:35.000000000 +0200
@@ -291,6 +291,11 @@ int security_sb_kern_mount(struct super_
 	return security_ops->sb_kern_mount(sb, data);
 }
 
+int security_sb_show_options(struct seq_file *m, struct super_block *sb)
+{
+	return security_ops->sb_show_options(m, sb);
+}
+
 int security_sb_statfs(struct dentry *dentry)
 {
 	return security_ops->sb_statfs(dentry);
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-07-03 16:10:08.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-07-03 16:11:35.000000000 +0200
@@ -9,7 +9,8 @@
  *	      James Morris <jmorris@redhat.com>
  *
  *  Copyright (C) 2001,2002 Networks Associates Technology, Inc.
- *  Copyright (C) 2003 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ *  Copyright (C) 2003-2008 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ *					   Eric Paris <eparis@redhat.com>
  *  Copyright (C) 2004-2005 Trusted Computer Solutions, Inc.
  *			    <dgoeddel@trustedcs.com>
  *  Copyright (C) 2006, 2007 Hewlett-Packard Development Company, L.P.
@@ -956,6 +957,57 @@ out_err:
 	return rc;
 }
 
+void selinux_write_opts(struct seq_file *m, struct security_mnt_opts *opts)
+{
+	int i;
+	char *prefix;
+
+	for (i = 0; i < opts->num_mnt_opts; i++) {
+		char *has_comma = strchr(opts->mnt_opts[i], ',');
+
+		switch (opts->mnt_opts_flags[i]) {
+		case CONTEXT_MNT:
+			prefix = CONTEXT_STR;
+			break;
+		case FSCONTEXT_MNT:
+			prefix = FSCONTEXT_STR;
+			break;
+		case ROOTCONTEXT_MNT:
+			prefix = ROOTCONTEXT_STR;
+			break;
+		case DEFCONTEXT_MNT:
+			prefix = DEFCONTEXT_STR;
+			break;
+		default:
+			BUG();
+		};
+		/* we need a comma before each option */
+		seq_putc(m, ',');
+		seq_puts(m, prefix);
+		if (has_comma)
+			seq_putc(m, '\"');
+		seq_puts(m, opts->mnt_opts[i]);
+		if (has_comma)
+			seq_putc(m, '\"');
+	}
+}
+
+static int selinux_sb_show_options(struct seq_file *m, struct super_block *sb)
+{
+	struct security_mnt_opts opts;
+	int rc;
+
+	rc = selinux_get_mnt_opts(sb, &opts);
+	if (rc)
+		return rc;
+
+	selinux_write_opts(m, &opts);
+
+	security_free_mnt_opts(&opts);
+
+	return rc;
+}
+
 static inline u16 inode_mode_to_security_class(umode_t mode)
 {
 	switch (mode & S_IFMT) {
@@ -5343,6 +5395,7 @@ static struct security_operations selinu
 	.sb_free_security =		selinux_sb_free_security,
 	.sb_copy_data =			selinux_sb_copy_data,
 	.sb_kern_mount =		selinux_sb_kern_mount,
+	.sb_show_options =		selinux_sb_show_options,
 	.sb_statfs =			selinux_sb_statfs,
 	.sb_mount =			selinux_mount,
 	.sb_umount =			selinux_umount,
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2008-07-03 16:10:08.000000000 +0200
+++ linux-2.6/fs/namespace.c	2008-07-03 16:11:35.000000000 +0200
@@ -750,7 +750,7 @@ struct proc_fs_info {
 	const char *str;
 };
 
-static void show_sb_opts(struct seq_file *m, struct super_block *sb)
+static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
 	static const struct proc_fs_info fs_info[] = {
 		{ MS_SYNCHRONOUS, ",sync" },
@@ -764,6 +764,8 @@ static void show_sb_opts(struct seq_file
 		if (sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
+
+	return security_sb_show_options(m, sb);
 }
 
 static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
@@ -806,11 +808,14 @@ static int show_vfsmnt(struct seq_file *
 	seq_putc(m, ' ');
 	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
-	show_sb_opts(m, mnt->mnt_sb);
+	err = show_sb_opts(m, mnt->mnt_sb);
+	if (err)
+		goto out;
 	show_mnt_opts(m, mnt);
 	if (mnt->mnt_sb->s_op->show_options)
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
 	seq_puts(m, " 0 0\n");
+out:
 	return err;
 }
 
@@ -865,10 +870,13 @@ static int show_mountinfo(struct seq_fil
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_puts(m, sb->s_flags & MS_RDONLY ? " ro" : " rw");
-	show_sb_opts(m, sb);
+	err = show_sb_opts(m, sb);
+	if (err)
+		goto out;
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);
 	seq_putc(m, '\n');
+out:
 	return err;
 }
 
