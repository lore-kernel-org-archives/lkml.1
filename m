Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbXJXQ0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbXJXQ0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXJXQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33313 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756760AbXJXQWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:54 -0400
Date: Wed, 24 Oct 2007 18:23:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
Cc: ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] fs/ecryptfs/: possible cleanups
Message-ID: <20071024162323.GN30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global code static:
  - crypto.c:ecryptfs_lower_offset_for_extent()
  - crypto.c:key_tfm_list
  - crypto.c:key_tfm_list_mutex
  - inode.c:ecryptfs_getxattr()
  - main.c:ecryptfs_init_persistent_file()
- remove the no longer used mmap.c:ecryptfs_lower_page_cache
- #if 0 the unused read_write.c:ecryptfs_read()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |   10 ----------
 fs/ecryptfs/inode.c           |    2 +-
 fs/ecryptfs/main.c            |    2 +-
 fs/ecryptfs/mmap.c            |    2 --
 fs/ecryptfs/read_write.c      |    2 ++
 6 files changed, 8 insertions(+), 18 deletions(-)

023d44677d50f35c5fb44dd8ccfbcf4af11c5e25 
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 1ae90ef..614f53e 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -358,8 +358,8 @@ out:
  *
  * Convert an eCryptfs page index into a lower byte offset
  */
-void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
-				      struct ecryptfs_crypt_stat *crypt_stat)
+static void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
+					     struct ecryptfs_crypt_stat *crypt_stat)
 {
 	(*offset) = ((crypt_stat->extent_size
 		      * crypt_stat->num_header_extents_at_front)
@@ -1787,8 +1787,8 @@ out:
 }
 
 struct kmem_cache *ecryptfs_key_tfm_cache;
-struct list_head key_tfm_list;
-struct mutex key_tfm_list_mutex;
+static struct list_head key_tfm_list;
+static struct mutex key_tfm_list_mutex;
 
 int ecryptfs_init_crypto(void)
 {
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index ce7a5d4..466661c 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -322,9 +322,6 @@ struct ecryptfs_key_tfm {
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
-extern struct list_head key_tfm_list;
-extern struct mutex key_tfm_list_mutex;
-
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -525,7 +522,6 @@ extern struct kmem_cache *ecryptfs_header_cache_0;
 extern struct kmem_cache *ecryptfs_header_cache_1;
 extern struct kmem_cache *ecryptfs_header_cache_2;
 extern struct kmem_cache *ecryptfs_xattr_cache;
-extern struct kmem_cache *ecryptfs_lower_page_cache;
 extern struct kmem_cache *ecryptfs_key_record_cache;
 extern struct kmem_cache *ecryptfs_key_sig_cache;
 extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
@@ -576,8 +572,6 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length);
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
-ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
-			  size_t size);
 ssize_t
 ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
 			void *value, size_t size);
@@ -631,8 +625,6 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      char *sig);
 int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
 			 int num_zeros);
-void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
-				      struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
@@ -646,8 +638,6 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 				     pgoff_t page_index,
 				     size_t offset_in_page, size_t size,
 				     struct inode *ecryptfs_inode);
-int ecryptfs_read(char *data, loff_t offset, size_t size,
-		  struct file *ecryptfs_file);
 struct page *ecryptfs_get_locked_page(struct file *file, loff_t index);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0b1ab01..bf5ceed 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -966,7 +966,7 @@ out:
 	return rc;
 }
 
-ssize_t
+static ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b83a512..3baadc6 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -117,7 +117,7 @@ void __ecryptfs_printk(const char *fmt, ...)
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+static int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 16a7a55..e9cbda9 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -34,8 +34,6 @@
 #include <linux/scatterlist.h>
 #include "ecryptfs_kernel.h"
 
-struct kmem_cache *ecryptfs_lower_page_cache;
-
 /**
  * ecryptfs_get_locked_page
  *
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 2150edf..2facfa2 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -278,6 +278,7 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 	return rc;
 }
 
+#if 0
 /**
  * ecryptfs_read
  * @data: The virtual address into which to write the data read (and
@@ -356,3 +357,4 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 out:
 	return rc;
 }
+#endif  /*  0  */

