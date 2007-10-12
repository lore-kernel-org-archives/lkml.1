Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXJLQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXJLQQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbXJLQHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235AbXJLQHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/52] CRED: Pass credentials through the truncate() inode
	operation
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:06 +0100
Message-ID: <20071012160706.15119.21839.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the truncate() inode operation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/attr.c                |    3 ++-
 fs/buffer.c              |    3 ++-
 fs/ext3/inode.c          |    6 +++---
 fs/ext3/super.c          |    3 ++-
 fs/fat/file.c            |    2 +-
 fs/fat/inode.c           |    4 +++-
 fs/nfs/inode.c           |    4 +++-
 fs/splice.c              |    2 +-
 include/linux/ext3_fs.h  |    2 +-
 include/linux/fs.h       |    2 +-
 include/linux/mm.h       |    3 ++-
 include/linux/msdos_fs.h |    2 +-
 mm/filemap.c             |    3 ++-
 mm/memory.c              |    5 +++--
 mm/shmem.c               |    4 ++--
 15 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f0adb92..06a3145 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -68,11 +68,12 @@ EXPORT_SYMBOL(inode_change_ok);
 
 int inode_setattr(struct inode * inode, struct iattr * attr)
 {
+	struct cred *cred = current->cred;
 	unsigned int ia_valid = attr->ia_valid;
 
 	if (ia_valid & ATTR_SIZE &&
 	    attr->ia_size != i_size_read(inode)) {
-		int error = vmtruncate(inode, attr->ia_size);
+		int error = vmtruncate(inode, attr->ia_size, cred);
 		if (error)
 			return error;
 	}
diff --git a/fs/buffer.c b/fs/buffer.c
index 0c8444a..e7f59c3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2013,6 +2013,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 static int __generic_cont_expand(struct inode *inode, loff_t size,
 				 pgoff_t index, unsigned int offset)
 {
+	struct cred *cred = current->cred;
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
 	unsigned long limit;
@@ -2039,7 +2040,7 @@ static int __generic_cont_expand(struct inode *inode, loff_t size,
 		 */
 		unlock_page(page);
 		page_cache_release(page);
-		vmtruncate(inode, inode->i_size);
+		vmtruncate(inode, inode->i_size, cred);
 		goto out;
 	}
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4313d20..31e5b38 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -181,6 +181,7 @@ static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
  */
 void ext3_delete_inode (struct inode * inode)
 {
+	struct cred *cred = &writeback_cred;
 	handle_t *handle;
 
 	truncate_inode_pages(&inode->i_data, 0);
@@ -203,7 +204,7 @@ void ext3_delete_inode (struct inode * inode)
 		handle->h_sync = 1;
 	inode->i_size = 0;
 	if (inode->i_blocks)
-		ext3_truncate(inode);
+		ext3_truncate(inode, cred);
 	/*
 	 * Kill off the orphan record which ext3_truncate created.
 	 * AKPM: I think this can be inside the above `if'.
@@ -2227,9 +2228,8 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
  * that's fine - as long as they are linked from the inode, the post-crash
  * ext3_truncate() run will find them and release them.
  */
-void ext3_truncate(struct inode *inode)
+void ext3_truncate(struct inode *inode, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	__le32 *i_data = ei->i_data;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 14a558b..4bb76d3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1259,6 +1259,7 @@ static int ext3_check_descriptors (struct super_block * sb)
 static void ext3_orphan_cleanup (struct super_block * sb,
 				 struct ext3_super_block * es)
 {
+	struct cred *cred = current->cred;
 	unsigned int s_flags = sb->s_flags;
 	int nr_orphans = 0, nr_truncates = 0;
 #ifdef CONFIG_QUOTA
@@ -1321,7 +1322,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 				__FUNCTION__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
 				  inode->i_ino, inode->i_size);
-			ext3_truncate(inode);
+			ext3_truncate(inode, cred);
 			nr_truncates++;
 		} else {
 			printk(KERN_DEBUG
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 69a83b5..a871db8 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -282,7 +282,7 @@ static int fat_free(struct inode *inode, int skip)
 	return fat_free_clusters(inode, free_start);
 }
 
-void fat_truncate(struct inode *inode)
+void fat_truncate(struct inode *inode, struct cred *cred)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	const unsigned int cluster_size = sbi->cluster_size;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 955ccaf..045647d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -430,11 +430,13 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 
 static void fat_delete_inode(struct inode *inode)
 {
+	struct cred *cred = &writeback_cred;
+
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (!is_bad_inode(inode)) {
 		inode->i_size = 0;
-		fat_truncate(inode);
+		fat_truncate(inode, cred);
 	}
 	clear_inode(inode);
 }
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 300560f..8b21608 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -368,6 +368,8 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
  */
 void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 {
+	struct cred *acred = current->cred;
+
 	if ((attr->ia_valid & (ATTR_MODE|ATTR_UID|ATTR_GID)) != 0) {
 		if ((attr->ia_valid & ATTR_MODE) != 0) {
 			int mode = attr->ia_mode & S_IALLUGO;
@@ -385,7 +387,7 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		nfs_inc_stats(inode, NFSIOS_SETATTRTRUNC);
 		inode->i_size = attr->ia_size;
-		vmtruncate(inode, attr->ia_size);
+		vmtruncate(inode, attr->ia_size, acred);
 	}
 }
 
diff --git a/fs/splice.c b/fs/splice.c
index e95a362..52d4c96 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -612,7 +612,7 @@ find_page:
 		 * outside i_size.  Trim these off again.
 		 */
 		if (sd->pos + this_len > isize)
-			vmtruncate(mapping->host, isize);
+			vmtruncate(mapping->host, isize, file->f_cred);
 
 		goto out_ret;
 	}
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 23db760..a2b686d 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -827,7 +827,7 @@ extern void ext3_discard_reservation (struct inode *);
 extern void ext3_dirty_inode(struct inode *);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
-extern void ext3_truncate (struct inode *);
+extern void ext3_truncate (struct inode *, struct cred *);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6d9bfc4..747fc5b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1148,7 +1148,7 @@ struct inode_operations {
 	int (*readlink) (struct dentry *, char __user *,int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
-	void (*truncate) (struct inode *);
+	void (*truncate) (struct inode *, struct cred *);
 	int (*permission) (struct inode *, int, struct nameidata *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1692dd6..aae6d3c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -20,6 +20,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct cred;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -790,7 +791,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 	unmap_mapping_range(mapping, holebegin, holelen, 0);
 }
 
-extern int vmtruncate(struct inode * inode, loff_t offset);
+extern int vmtruncate(struct inode * inode, loff_t offset, struct cred *cred);
 extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
 
 #ifdef CONFIG_MMU
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index f950921..ddd669c 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -402,7 +402,7 @@ extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
 extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
-extern void fat_truncate(struct inode *inode);
+extern void fat_truncate(struct inode *inode, struct cred *cred);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 15c8413..ab89eac 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1841,6 +1841,7 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		size_t count, ssize_t written)
 {
 	struct file *file = iocb->ki_filp;
+	struct cred *cred = file->f_cred;
 	struct address_space * mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	struct inode 	*inode = mapping->host;
@@ -1924,7 +1925,7 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 			 * outside i_size.  Trim these off again.
 			 */
 			if (pos + bytes > isize)
-				vmtruncate(inode, isize);
+				vmtruncate(inode, isize, cred);
 			break;
 		}
 		if (likely(nr_segs == 1))
diff --git a/mm/memory.c b/mm/memory.c
index f82b359..85dca9b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1999,12 +1999,13 @@ EXPORT_SYMBOL(unmap_mapping_range);
  * vmtruncate - unmap mappings "freed" by truncate() syscall
  * @inode: inode of the file used
  * @offset: file offset to start truncating
+ * @cred: the credentials to use
  *
  * NOTE! We have to be ready to update the memory sharing
  * between the file and the memory map for a potential last
  * incomplete page.  Ugly, but necessary.
  */
-int vmtruncate(struct inode * inode, loff_t offset)
+int vmtruncate(struct inode * inode, loff_t offset, struct cred *cred)
 {
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long limit;
@@ -2042,7 +2043,7 @@ do_expand:
 
 out_truncate:
 	if (inode->i_op && inode->i_op->truncate)
-		inode->i_op->truncate(inode);
+		inode->i_op->truncate(inode, cred);
 	return 0;
 out_sig:
 	send_sig(SIGXFSZ, current, 0);
diff --git a/mm/shmem.c b/mm/shmem.c
index 49a4b40..accaa18 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -708,7 +708,7 @@ done2:
 	}
 }
 
-static void shmem_truncate(struct inode *inode)
+static void shmem_truncate(struct inode *inode, struct cred *cred)
 {
 	shmem_truncate_range(inode, inode->i_size, (loff_t)-1);
 }
@@ -770,7 +770,7 @@ static void shmem_delete_inode(struct inode *inode)
 		truncate_inode_pages(inode->i_mapping, 0);
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
-		shmem_truncate(inode);
+		shmem_truncate(inode, &writeback_cred);
 		if (!list_empty(&info->swaplist)) {
 			spin_lock(&shmem_swaplist_lock);
 			list_del_init(&info->swaplist);

