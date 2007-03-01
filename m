Return-Path: <linux-kernel-owner+w=401wt.eu-S965511AbXCATWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbXCATWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965518AbXCATWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:22:30 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:17401 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965511AbXCATW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:22:29 -0500
X-AuditID: d80ac287-9e19abb000002978-9c-45e727f4f3c6 
Date: Thu, 1 Mar 2007 19:22:32 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] shmem and simple const super_operations
Message-ID: <Pine.LNX.4.64.0703011915460.17890@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 01 Mar 2007 19:22:28.0621 (UTC) FILETIME=[F37A33D0:01C75C36]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

shmem's super_operations were missed from the recent const-ification;
and simple_fill_super()'s, which can share with get_sb_pseudo()'s.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/libfs.c |   10 ++++++----
 mm/shmem.c |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

--- 2.6.21-rc2/fs/libfs.c	2007-02-28 08:30:26.000000000 +0000
+++ linux/fs/libfs.c	2007-02-28 13:12:07.000000000 +0000
@@ -190,6 +190,10 @@ const struct inode_operations simple_dir
 	.lookup		= simple_lookup,
 };
 
+static const struct super_operations simple_super_operations = {
+	.statfs		= simple_statfs,
+};
+
 /*
  * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
  * will never be mountable)
@@ -199,7 +203,6 @@ int get_sb_pseudo(struct file_system_typ
 	struct vfsmount *mnt)
 {
 	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
-	static const struct super_operations default_ops = {.statfs = simple_statfs};
 	struct dentry *dentry;
 	struct inode *root;
 	struct qstr d_name = {.name = name, .len = strlen(name)};
@@ -212,7 +215,7 @@ int get_sb_pseudo(struct file_system_typ
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = magic;
-	s->s_op = ops ? ops : &default_ops;
+	s->s_op = ops ? ops : &simple_super_operations;
 	s->s_time_gran = 1;
 	root = new_inode(s);
 	if (!root)
@@ -359,7 +362,6 @@ int simple_commit_write(struct file *fil
 
 int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
 {
-	static struct super_operations s_ops = {.statfs = simple_statfs};
 	struct inode *inode;
 	struct dentry *root;
 	struct dentry *dentry;
@@ -368,7 +370,7 @@ int simple_fill_super(struct super_block
 	s->s_blocksize = PAGE_CACHE_SIZE;
 	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	s->s_magic = magic;
-	s->s_op = &s_ops;
+	s->s_op = &simple_super_operations;
 	s->s_time_gran = 1;
 
 	inode = new_inode(s);
--- 2.6.21-rc2/mm/shmem.c	2007-02-28 08:30:33.000000000 +0000
+++ linux/mm/shmem.c	2007-02-28 13:12:07.000000000 +0000
@@ -175,7 +175,7 @@ static inline void shmem_unacct_blocks(u
 		vm_unacct_memory(pages * VM_ACCT(PAGE_CACHE_SIZE));
 }
 
-static struct super_operations shmem_ops;
+static const struct super_operations shmem_ops;
 static const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
 static const struct inode_operations shmem_inode_operations;
@@ -2382,7 +2382,7 @@ static const struct inode_operations shm
 #endif
 };
 
-static struct super_operations shmem_ops = {
+static const struct super_operations shmem_ops = {
 	.alloc_inode	= shmem_alloc_inode,
 	.destroy_inode	= shmem_destroy_inode,
 #ifdef CONFIG_TMPFS
