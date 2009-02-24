Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZBXUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZBXUxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZBXUxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:53:06 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39553 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbZBXUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:53:04 -0500
Date: Tue, 24 Feb 2009 20:51:52 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] shmem: fix shared anonymous accounting
Message-ID: <Pine.LNX.4.64.0902242044230.10483@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time I exit Firefox, /proc/meminfo's Committed_AS goes down almost
400 kB: OVERCOMMIT_NEVER would be allowing overcommits it should prohibit.

Commit fc8744adc870a8d4366908221508bb113d8b72ee "Stop playing silly games
with the VM_ACCOUNT flag" changed shmem_file_setup() to set the shmem file's
VM_ACCOUNT flag according to VM_NORESERVE not being set in the vma flags;
but did so only _after_ the shmem_acct_size(flags, size) call which is
expected to pre-account a shared anonymous object.

It's all clearer if we switch shmem.c over to use VM_NORESERVE throughout
in place of !VM_ACCOUNT.

But I very nearly sent in a patch which mistakenly removed the accounting
from tmpfs files: shmem_get_inode()'s memset was good for not setting
VM_ACCOUNT, but now it needs to set VM_NORESERVE.

Rather than setting that by default, then perhaps clearing it again in
shmem_file_setup(), let's pass it as a flag to shmem_get_inode(): that
allows us to remove the #ifdef CONFIG_SHMEM from shmem_file_setup().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- 2.6.29-rc6/mm/shmem.c	2009-02-08 21:25:25.000000000 +0000
+++ linux/mm/shmem.c	2009-02-24 19:48:58.000000000 +0000
@@ -169,13 +169,13 @@ static inline struct shmem_sb_info *SHME
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_ACCOUNT) ?
-		security_vm_enough_memory_kern(VM_ACCT(size)) : 0;
+	return (flags & VM_NORESERVE) ?
+		0 : security_vm_enough_memory_kern(VM_ACCT(size));
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
 {
-	if (flags & VM_ACCOUNT)
+	if (!(flags & VM_NORESERVE))
 		vm_unacct_memory(VM_ACCT(size));
 }
 
@@ -187,13 +187,13 @@ static inline void shmem_unacct_size(uns
  */
 static inline int shmem_acct_block(unsigned long flags)
 {
-	return (flags & VM_ACCOUNT) ?
-		0 : security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
+	return (flags & VM_NORESERVE) ?
+		security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE)) : 0;
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 {
-	if (!(flags & VM_ACCOUNT))
+	if (flags & VM_NORESERVE)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_CACHE_SIZE));
 }
 
@@ -1515,8 +1515,8 @@ static int shmem_mmap(struct file *file,
 	return 0;
 }
 
-static struct inode *
-shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
+static struct inode *shmem_get_inode(struct super_block *sb, int mode,
+					dev_t dev, unsigned long flags)
 {
 	struct inode *inode;
 	struct shmem_inode_info *info;
@@ -1537,6 +1537,7 @@ shmem_get_inode(struct super_block *sb,
 		info = SHMEM_I(inode);
 		memset(info, 0, (char *)inode - (char *)info);
 		spin_lock_init(&info->lock);
+		info->flags = flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
 
 		switch (mode & S_IFMT) {
@@ -1779,9 +1780,10 @@ static int shmem_statfs(struct dentry *d
 static int
 shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	struct inode *inode = shmem_get_inode(dir->i_sb, mode, dev);
+	struct inode *inode;
 	int error = -ENOSPC;
 
+	inode = shmem_get_inode(dir->i_sb, mode, dev, VM_NORESERVE);
 	if (inode) {
 		error = security_inode_init_security(inode, dir, NULL, NULL,
 						     NULL);
@@ -1920,7 +1922,7 @@ static int shmem_symlink(struct inode *d
 	if (len > PAGE_CACHE_SIZE)
 		return -ENAMETOOLONG;
 
-	inode = shmem_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
+	inode = shmem_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0, VM_NORESERVE);
 	if (!inode)
 		return -ENOSPC;
 
@@ -2332,7 +2334,7 @@ static int shmem_fill_super(struct super
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
-	inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0);
+	inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
 		goto failed;
 	inode->i_uid = sbinfo->uid;
@@ -2574,12 +2576,12 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
-#define shmem_file_operations ramfs_file_operations
-#define shmem_vm_ops generic_file_vm_ops
-#define shmem_get_inode ramfs_get_inode
-#define shmem_acct_size(a, b) 0
-#define shmem_unacct_size(a, b) do {} while (0)
-#define SHMEM_MAX_BYTES LLONG_MAX
+#define shmem_vm_ops				generic_file_vm_ops
+#define shmem_file_operations			ramfs_file_operations
+#define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
+#define shmem_acct_size(flags, size)		0
+#define shmem_unacct_size(flags, size)		do {} while (0)
+#define SHMEM_MAX_BYTES				LLONG_MAX
 
 #endif /* CONFIG_SHMEM */
 
@@ -2589,7 +2591,7 @@ int shmem_unuse(swp_entry_t entry, struc
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps
  * @size: size to be set for the file
- * @flags: vm_flags
+ * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 {
@@ -2623,13 +2625,10 @@ struct file *shmem_file_setup(char *name
 		goto put_dentry;
 
 	error = -ENOSPC;
-	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
+	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, flags);
 	if (!inode)
 		goto close_file;
 
-#ifdef CONFIG_SHMEM
-	SHMEM_I(inode)->flags = (flags & VM_NORESERVE) ? 0 : VM_ACCOUNT;
-#endif
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
