Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYH0Nw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYH0Nw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYH0Nse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbYH0Nsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 32/59] CRED: Wrap task credential accesses in the hugetlbfs
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, William Irwin <wli@holomorphy.com>
Date: Wed, 27 Aug 2008 14:48:27 +0100
Message-ID: <20080827134827.19980.60333.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: William Irwin <wli@holomorphy.com>
---

 fs/hugetlbfs/inode.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f58923..4c428f5 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -551,9 +551,9 @@ static int hugetlbfs_mknod(struct inode *dir,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		gid = current->fsgid;
+		gid = current_fsgid();
 	}
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid, gid, mode, dev);
+	inode = hugetlbfs_get_inode(dir->i_sb, current_fsuid(), gid, mode, dev);
 	if (inode) {
 		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 		d_instantiate(dentry, inode);
@@ -586,9 +586,9 @@ static int hugetlbfs_symlink(struct inode *dir,
 	if (dir->i_mode & S_ISGID)
 		gid = dir->i_gid;
 	else
-		gid = current->fsgid;
+		gid = current_fsgid();
 
-	inode = hugetlbfs_get_inode(dir->i_sb, current->fsuid,
+	inode = hugetlbfs_get_inode(dir->i_sb, current_fsuid(),
 					gid, S_IFLNK|S_IRWXUGO, 0);
 	if (inode) {
 		int l = strlen(symname)+1;
@@ -854,8 +854,8 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
-	config.uid = current->fsuid;
-	config.gid = current->fsgid;
+	config.uid = current_fsuid();
+	config.gid = current_fsgid();
 	config.mode = 0755;
 	config.hstate = &default_hstate;
 	ret = hugetlbfs_parse_options(data, &config);
@@ -970,8 +970,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 		goto out_shm_unlock;
 
 	error = -ENOSPC;
-	inode = hugetlbfs_get_inode(root->d_sb, current->fsuid,
-				current->fsgid, S_IFREG | S_IRWXUGO, 0);
+	inode = hugetlbfs_get_inode(root->d_sb, current_fsuid(),
+				current_fsgid(), S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
 		goto out_dentry;
 

