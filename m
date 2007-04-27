Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbXD0MIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbXD0MIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbXD0MII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:08:08 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:53840 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbXD0MIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:08:04 -0400
Message-Id: <20070427120531.054028653@szeredi.hu>
References: <20070427120417.110164241@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 27 Apr 2007 14:04:20 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 03/10] unprivileged mounts: account user mounts
Content-Disposition: inline; filename=unprivileged-mounts-account-user-mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add sysctl variables for accounting and limiting the number of user
mounts.

The maximum number of user mounts is set to 1024 by default.  This
won't in itself enable user mounts, setting a mount to be owned by a
user is first needed

[akpm]
 - don't use enumerated sysctls

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2007-04-26 13:08:35.000000000 +0200
+++ linux/Documentation/filesystems/proc.txt	2007-04-26 13:17:13.000000000 +0200
@@ -923,6 +923,15 @@ reaches aio-max-nr then io_setup will fa
 raising aio-max-nr does not result in the pre-allocation or re-sizing
 of any kernel data structures.
 
+nr_user_mounts and max_user_mounts
+----------------------------------
+
+These represent the number of "user" mounts and the maximum number of
+"user" mounts respectively.  User mounts may be created by
+unprivileged users.  User mounts may also be created with sysadmin
+privileges on behalf of a user, in which case nr_user_mounts may
+exceed max_user_mounts.
+
 2.2 /proc/sys/fs/binfmt_misc - Miscellaneous binary formats
 -----------------------------------------------------------
 
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-04-26 13:16:21.000000000 +0200
+++ linux/fs/namespace.c	2007-04-26 13:17:13.000000000 +0200
@@ -39,6 +39,9 @@ static int hash_mask __read_mostly, hash
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
+int nr_user_mounts;
+int max_user_mounts = 1024;
+
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);
 EXPORT_SYMBOL_GPL(fs_subsys);
@@ -227,11 +230,30 @@ static struct vfsmount *skip_mnt_tree(st
 	return p;
 }
 
+static void dec_nr_user_mounts(void)
+{
+	spin_lock(&vfsmount_lock);
+	nr_user_mounts--;
+	spin_unlock(&vfsmount_lock);
+}
+
 static void set_mnt_user(struct vfsmount *mnt)
 {
 	BUG_ON(mnt->mnt_flags & MNT_USER);
 	mnt->mnt_uid = current->fsuid;
 	mnt->mnt_flags |= MNT_USER;
+	spin_lock(&vfsmount_lock);
+	nr_user_mounts++;
+	spin_unlock(&vfsmount_lock);
+}
+
+static void clear_mnt_user(struct vfsmount *mnt)
+{
+	if (mnt->mnt_flags & MNT_USER) {
+		mnt->mnt_uid = 0;
+		mnt->mnt_flags &= ~MNT_USER;
+		dec_nr_user_mounts();
+	}
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
@@ -283,6 +305,7 @@ static inline void __mntput(struct vfsmo
 {
 	struct super_block *sb = mnt->mnt_sb;
 	dput(mnt->mnt_root);
+	clear_mnt_user(mnt);
 	free_vfsmnt(mnt);
 	deactivate_super(sb);
 }
@@ -1028,6 +1051,7 @@ static int do_remount(struct nameidata *
 	down_write(&sb->s_umount);
 	err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
+		clear_mnt_user(nd->mnt);
 		nd->mnt->mnt_flags = mnt_flags;
 		if (flags & MS_SETUSER)
 			set_mnt_user(nd->mnt);
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-04-26 13:08:36.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-26 13:17:13.000000000 +0200
@@ -50,6 +50,9 @@ extern struct inodes_stat_t inodes_stat;
 
 extern int leases_enable, lease_break_time;
 
+extern int nr_user_mounts;
+extern int max_user_mounts;
+
 #ifdef CONFIG_DNOTIFY
 extern int dir_notify_enable;
 #endif
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c	2007-04-26 13:08:35.000000000 +0200
+++ linux/kernel/sysctl.c	2007-04-26 13:17:13.000000000 +0200
@@ -1064,6 +1064,22 @@ static ctl_table fs_table[] = {
 #endif	
 #endif
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_user_mounts",
+		.data		= &nr_user_mounts,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "max_user_mounts",
+		.data		= &max_user_mounts,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_SETUID_DUMPABLE,
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,

--
