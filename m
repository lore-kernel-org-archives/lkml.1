Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYAXTjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYAXTjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYAXTfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:16 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46558 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYAXTel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:41 -0500
Message-Id: <20080124193437.670125114@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:56 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 15/26] mount options: fix hostfs
Content-Disposition: inline; filename=hostfs_opts.patch
Cc: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add the "host path" option to /proc/mounts for UML hostfs filesystems.

The mount source (mnt_devname) should really be used for this, but not
easy to change now in a backward compatible way.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/hostfs/hostfs_kern.c
===================================================================
--- linux.orig/fs/hostfs/hostfs_kern.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/hostfs/hostfs_kern.c	2008-01-21 19:19:55.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
+#include <linux/seq_file.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
@@ -322,12 +323,25 @@ static void hostfs_destroy_inode(struct 
 	kfree(HOSTFS_I(inode));
 }
 
+static int hostfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct inode *root = vfs->mnt_sb->s_root->d_inode;
+	const char *root_path = HOSTFS_I(root)->host_filename;
+	size_t offset = strlen(root_ino) + 1;
+
+	if (strlen(root_path) > offset)
+		seq_printf(seq, ",%s", root_path + offset);
+
+	return 0;
+}
+
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
 	.destroy_inode	= hostfs_destroy_inode,
 	.statfs		= hostfs_statfs,
+	.show_options	= hostfs_show_options,
 };
 
 int hostfs_readdir(struct file *file, void *ent, filldir_t filldir)

--
