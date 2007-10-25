Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXJYQq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXJYQq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXJYQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:36:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXJYQgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:36:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/31] IGET: Stop PROCFS from using iget() and read_inode()
	[try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:35:56 +0100
Message-ID: <20071025163556.5057.44268.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the PROCFS filesystem from using iget() and read_inode().  Merge
procfs_read_inode() into procfs_get_inode(), and have that call iget_locked()
instead of iget().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/inode.c |   60 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index abe6a3f..1b597b7 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -78,11 +78,6 @@ static void proc_delete_inode(struct inode *inode)
 
 struct vfsmount *proc_mnt;
 
-static void proc_read_inode(struct inode * inode)
-{
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-}
-
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
@@ -133,7 +128,6 @@ static int proc_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
-	.read_inode	= proc_read_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
@@ -406,39 +400,41 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 
-	inode = iget(sb, ino);
+	inode = iget_locked(sb, ino);
 	if (!inode)
 		goto out_ino;
-
-	PROC_I(inode)->fd = 0;
-	PROC_I(inode)->pde = de;
-	if (de) {
-		if (de->mode) {
-			inode->i_mode = de->mode;
-			inode->i_uid = de->uid;
-			inode->i_gid = de->gid;
-		}
-		if (de->size)
-			inode->i_size = de->size;
-		if (de->nlink)
-			inode->i_nlink = de->nlink;
-		if (de->proc_iops)
-			inode->i_op = de->proc_iops;
-		if (de->proc_fops) {
-			if (S_ISREG(inode->i_mode)) {
+	if (inode->i_state & I_NEW) {
+		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+		PROC_I(inode)->fd = 0;
+		PROC_I(inode)->pde = de;
+		if (de) {
+			if (de->mode) {
+				inode->i_mode = de->mode;
+				inode->i_uid = de->uid;
+				inode->i_gid = de->gid;
+			}
+			if (de->size)
+				inode->i_size = de->size;
+			if (de->nlink)
+				inode->i_nlink = de->nlink;
+			if (de->proc_iops)
+				inode->i_op = de->proc_iops;
+			if (de->proc_fops) {
+				if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-				if (!de->proc_fops->compat_ioctl)
-					inode->i_fop =
-						&proc_reg_file_ops_no_compat;
-				else
+					if (!de->proc_fops->compat_ioctl)
+						inode->i_fop =
+							&proc_reg_file_ops_no_compat;
+					else
 #endif
-					inode->i_fop = &proc_reg_file_ops;
+						inode->i_fop = &proc_reg_file_ops;
+				}
+				else
+					inode->i_fop = de->proc_fops;
 			}
-			else
-				inode->i_fop = de->proc_fops;
 		}
+		unlock_new_inode(inode);
 	}
-
 	return inode;
 
 out_ino:

