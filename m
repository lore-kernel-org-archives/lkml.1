Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZIGPWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZIGPWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZIGPWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:22:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56461 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZIGPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:22:16 -0400
To: akpm@linux-foundation.org
CC: Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, matthew@wil.cx,
       agruen@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       linux-kernel@vger.kernel.org
Subject: [patch] vfs: no "(unreachable)" prefix for SYSVIPC maps in /proc/PID/maps 
Message-Id: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 17:21:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another fix for vfs-fix-d_path-for-unreachable-paths.patch in -mm.

----
From: Miklos Szeredi <mszeredi@suse.cz>

The patch

  "vfs: fix d_path() for unreachable paths"

generally changed d_path() to report unreachable paths with a special
prefix.  This has an effect on /proc/${PID}/maps as well for memory
maps set up with shmem_file_setup() or hugetlb_file_setup().  These
functions set up unlinked files under a kernel-private vfsmount.
Since this vfsmount is unreachable from userspace, these maps will be
reported with the "(unreachable)" prefix.

This is undesirable, because it changes the kernel ABI and might break
applications for no good reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/hugetlbfs/inode.c |   17 +++++++++++++++++
 mm/shmem.c           |   17 +++++++++++++++++
 2 files changed, 34 insertions(+)

Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2009-09-07 16:27:57.000000000 +0200
+++ linux-2.6/mm/shmem.c	2009-09-07 16:46:41.000000000 +0200
@@ -2602,6 +2602,21 @@ int shmem_unuse(swp_entry_t entry, struc
 
 /* common code */
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *shmem_unlinked_d_dname(struct dentry *dentry, char *buf,
+				    int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations shmem_unlinked_dentry_operations = {
+	.d_dname = shmem_unlinked_d_dname,
+};
+
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps
@@ -2634,6 +2649,8 @@ struct file *shmem_file_setup(const char
 	if (!dentry)
 		goto put_memory;
 
+	dentry->d_op = &shmem_unlinked_dentry_operations;
+
 	error = -ENFILE;
 	file = get_empty_filp();
 	if (!file)
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c	2009-09-07 16:27:57.000000000 +0200
+++ linux-2.6/fs/hugetlbfs/inode.c	2009-09-07 16:46:51.000000000 +0200
@@ -930,6 +930,21 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *hugetlb_unlinked_d_dname(struct dentry *dentry, char *buf,
+				      int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations hugetlb_unlinked_dentry_operations = {
+	.d_dname = hugetlb_unlinked_d_dname,
+};
+
 static int can_do_hugetlb_shm(void)
 {
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
@@ -967,6 +982,8 @@ struct file *hugetlb_file_setup(const ch
 	if (!dentry)
 		goto out_shm_unlock;
 
+	dentry->d_op = &hugetlb_unlinked_dentry_operations;
+
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, current_fsuid(),
 				current_fsgid(), S_IFREG | S_IRWXUGO, 0);
