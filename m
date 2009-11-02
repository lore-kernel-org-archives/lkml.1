Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZKBKHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZKBKHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZKBKG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:06:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:47220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbZKBKG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:06:57 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 03/27] BKL: Remove BKL from simple_fill_super
Date: Mon,  2 Nov 2009 11:04:43 +0100
Message-Id: <1257156307-24175-4-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_fill_super is used in following filesystems that don't use the BKL
otherwise:
- security/selinux/selinuxfs.c
- security/inode.c
- security/smack/smackfs.c
- drivers/infiniband/hw/ipath/ipath_fs.c
- drivers/xen/xenfs/super.c
- fs/debugfs/inode.c

It is used in following filesystems that make use of the BKL:
- fs/fuse/control.c
- fs/binfmt_misc.c
- fs/nfsd/nfsctl.c

All three filesystems protect the call to simple_fill_super() by the BKL
themself. Therefore it is safe to remove the BKL from simpe_fill_super().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/libfs.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 3484040..4a70729 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -11,7 +11,6 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -423,8 +422,6 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	struct dentry *dentry;
 	int i;
 
-	lock_kernel();
-
 	s->s_blocksize = PAGE_CACHE_SIZE;
 	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	s->s_magic = magic;
@@ -432,10 +429,9 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	s->s_time_gran = 1;
 
 	inode = new_inode(s);
-	if (!inode) {
-		unlock_kernel();
+	if (!inode)
 		return -ENOMEM;
-	}
+
 	/*
 	 * because the root inode is 1, the files array must not contain an
 	 * entry at index 1
@@ -449,7 +445,6 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	for (i = 0; !files->name || files->name[0]; i++, files++) {
@@ -475,12 +470,10 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 		d_add(dentry, inode);
 	}
 	s->s_root = root;
-	unlock_kernel();
 	return 0;
 out:
 	d_genocide(root);
 	dput(root);
-	unlock_kernel();
 	return -ENOMEM;
 }
 
-- 
1.6.4.2

