Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbZDWT1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbZDWT1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbZDWT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:26:54 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36070 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760310AbZDWT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:26:52 -0400
Date: Thu, 23 Apr 2009 14:26:49 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net,
       Dustin Kirkland <dustin.kirkland@gmail.com>
Subject: [GIT PULL] eCryptfs fixes for 2.6.30-rc3
Message-ID: <20090423192646.GA11388@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus - Please pull the 2.6.30-rc3 eCryptfs bug fixes from:

	git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

to get these changes:

Tyler Hicks (7):
	eCryptfs: Copy lower inode attrs before dentry instantiation
	eCryptfs: NULL pointer dereference in ecryptfs_send_miscdev()
	eCryptfs: Print FNEK sig properly in /proc/mounts
	eCryptfs: Fix data corruption when using ecryptfs_passthrough
	eCryptfs: Remove ecryptfs_unlink_sigs warnings
	eCryptfs: Lock lower directory inode mutex during lookup
	eCryptfs: Larger buffer for encrypted symlink targets

 fs/ecryptfs/crypto.c          |   21 +---------
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/inode.c           |   37 ++++++++++++++----
 fs/ecryptfs/main.c            |   14 ++++--
 fs/ecryptfs/messaging.c       |   82 -----------------------------------------
 fs/ecryptfs/miscdev.c         |   28 +++++--------
 fs/ecryptfs/mmap.c            |   11 +++++
 fs/ecryptfs/read_write.c      |   32 ++++++++++-----
 fs/ecryptfs/super.c           |    7 +++-
 9 files changed, 90 insertions(+), 143 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 8b65f28..b91851f 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -483,15 +483,7 @@ int ecryptfs_encrypt_page(struct page *page)
 	ecryptfs_inode = page->mapping->host;
 	crypt_stat =
 		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
-	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
-		rc = ecryptfs_write_lower_page_segment(ecryptfs_inode, page,
-						       0, PAGE_CACHE_SIZE);
-		if (rc)
-			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __func__,
-			       page->index);
-		goto out;
-	}
+	BUG_ON(!(crypt_stat->flags & ECRYPTFS_ENCRYPTED));
 	enc_extent_page = alloc_page(GFP_USER);
 	if (!enc_extent_page) {
 		rc = -ENOMEM;
@@ -620,16 +612,7 @@ int ecryptfs_decrypt_page(struct page *page)
 	ecryptfs_inode = page->mapping->host;
 	crypt_stat =
 		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
-	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
-		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
-						      PAGE_CACHE_SIZE,
-						      ecryptfs_inode);
-		if (rc)
-			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __func__,
-			       page->index);
-		goto out;
-	}
+	BUG_ON(!(crypt_stat->flags & ECRYPTFS_ENCRYPTED));
 	enc_extent_page = alloc_page(GFP_USER);
 	if (!enc_extent_page) {
 		rc = -ENOMEM;
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 064c582..00b30a2 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -269,6 +269,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_ENCRYPT_FILENAMES    0x00000800
 #define ECRYPTFS_ENCFN_USE_MOUNT_FNEK 0x00001000
 #define ECRYPTFS_ENCFN_USE_FEK        0x00002000
+#define ECRYPTFS_UNLINK_SIGS	      0x00004000
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 55b3145..93bc0f8 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -379,9 +379,11 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 		goto out_d_drop;
 	}
 	lower_dir_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry->d_parent);
+	mutex_lock(&lower_dir_dentry->d_inode->i_mutex);
 	lower_dentry = lookup_one_len(ecryptfs_dentry->d_name.name,
 				      lower_dir_dentry,
 				      ecryptfs_dentry->d_name.len);
+	mutex_unlock(&lower_dir_dentry->d_inode->i_mutex);
 	if (IS_ERR(lower_dentry)) {
 		rc = PTR_ERR(lower_dentry);
 		printk(KERN_ERR "%s: lookup_one_len() returned [%d] on "
@@ -406,9 +408,11 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 		       "filename; rc = [%d]\n", __func__, rc);
 		goto out_d_drop;
 	}
+	mutex_lock(&lower_dir_dentry->d_inode->i_mutex);
 	lower_dentry = lookup_one_len(encrypted_and_encoded_name,
 				      lower_dir_dentry,
 				      encrypted_and_encoded_name_size - 1);
+	mutex_unlock(&lower_dir_dentry->d_inode->i_mutex);
 	if (IS_ERR(lower_dentry)) {
 		rc = PTR_ERR(lower_dentry);
 		printk(KERN_ERR "%s: lookup_one_len() returned [%d] on "
@@ -636,8 +640,9 @@ static int
 ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 {
 	char *lower_buf;
+	size_t lower_bufsiz;
 	struct dentry *lower_dentry;
-	struct ecryptfs_crypt_stat *crypt_stat;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	char *plaintext_name;
 	size_t plaintext_name_size;
 	mm_segment_t old_fs;
@@ -648,12 +653,21 @@ ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 		rc = -EINVAL;
 		goto out;
 	}
-	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+						dentry->d_sb)->mount_crypt_stat;
+	/*
+	 * If the lower filename is encrypted, it will result in a significantly
+	 * longer name.  If needed, truncate the name after decode and decrypt.
+	 */
+	if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+		lower_bufsiz = PATH_MAX;
+	else
+		lower_bufsiz = bufsiz;
 	/* Released in this function */
-	lower_buf = kmalloc(bufsiz, GFP_KERNEL);
+	lower_buf = kmalloc(lower_bufsiz, GFP_KERNEL);
 	if (lower_buf == NULL) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__, bufsiz);
+		       "kmalloc [%d] bytes\n", __func__, lower_bufsiz);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -661,7 +675,7 @@ ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 	set_fs(get_ds());
 	rc = lower_dentry->d_inode->i_op->readlink(lower_dentry,
 						   (char __user *)lower_buf,
-						   bufsiz);
+						   lower_bufsiz);
 	set_fs(old_fs);
 	if (rc >= 0) {
 		rc = ecryptfs_decode_and_decrypt_filename(&plaintext_name,
@@ -674,7 +688,9 @@ ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 				rc);
 			goto out_free_lower_buf;
 		}
-		rc = copy_to_user(buf, plaintext_name, plaintext_name_size);
+		/* Check for bufsiz <= 0 done in sys_readlinkat() */
+		rc = copy_to_user(buf, plaintext_name,
+				  min((unsigned) bufsiz, plaintext_name_size));
 		if (rc)
 			rc = -EFAULT;
 		else
@@ -814,6 +830,13 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 		size_t num_zeros = (PAGE_CACHE_SIZE
 				    - (new_length & ~PAGE_CACHE_MASK));
 
+		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
+			rc = vmtruncate(inode, new_length);
+			if (rc)
+				goto out_free;
+			rc = vmtruncate(lower_dentry->d_inode, new_length);
+			goto out_free;
+		}
 		if (num_zeros) {
 			char *zeros_virt;
 
@@ -915,8 +938,6 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 			}
 			rc = 0;
 			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-			mutex_unlock(&crypt_stat->cs_mutex);
-			goto out;
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index aed56c2..ccabd5f 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -190,14 +190,14 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 		init_special_inode(inode, lower_inode->i_mode,
 				   lower_inode->i_rdev);
 	dentry->d_op = &ecryptfs_dops;
-	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
-		d_add(dentry, inode);
-	else
-		d_instantiate(dentry, inode);
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
+	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
+		d_add(dentry, inode);
+	else
+		d_instantiate(dentry, inode);
 out:
 	return rc;
 }
@@ -208,7 +208,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
-       ecryptfs_opt_err };
+       ecryptfs_opt_unlink_sigs, ecryptfs_opt_err };
 
 static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -222,6 +222,7 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_fnek_sig, "ecryptfs_fnek_sig=%s"},
 	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=%s"},
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
+	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -402,6 +403,9 @@ static int ecryptfs_parse_options(struct super_block *sb, char *options)
 				fn_cipher_key_bytes;
 			fn_cipher_key_bytes_set = 1;
 			break;
+		case ecryptfs_opt_unlink_sigs:
+			mount_crypt_stat->flags |= ECRYPTFS_UNLINK_SIGS;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 295e7fa..f1c17e8 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -133,45 +133,6 @@ out:
 	return rc;
 }
 
-static int
-ecryptfs_send_message_locked(char *data, int data_len, u8 msg_type,
-			     struct ecryptfs_msg_ctx **msg_ctx);
-
-/**
- * ecryptfs_send_raw_message
- * @msg_type: Message type
- * @daemon: Daemon struct for recipient of message
- *
- * A raw message is one that does not include an ecryptfs_message
- * struct. It simply has a type.
- *
- * Must be called with ecryptfs_daemon_hash_mux held.
- *
- * Returns zero on success; non-zero otherwise
- */
-static int ecryptfs_send_raw_message(u8 msg_type,
-				     struct ecryptfs_daemon *daemon)
-{
-	struct ecryptfs_msg_ctx *msg_ctx;
-	int rc;
-
-	rc = ecryptfs_send_message_locked(NULL, 0, msg_type, &msg_ctx);
-	if (rc) {
-		printk(KERN_ERR "%s: Error whilst attempting to send "
-		       "message to ecryptfsd; rc = [%d]\n", __func__, rc);
-		goto out;
-	}
-	/* Raw messages are logically context-free (e.g., no
-	 * reply is expected), so we set the state of the
-	 * ecryptfs_msg_ctx object to indicate that it should
-	 * be freed as soon as the message is sent. */
-	mutex_lock(&msg_ctx->mux);
-	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_NO_REPLY;
-	mutex_unlock(&msg_ctx->mux);
-out:
-	return rc;
-}
-
 /**
  * ecryptfs_spawn_daemon - Create and initialize a new daemon struct
  * @daemon: Pointer to set to newly allocated daemon struct
@@ -212,49 +173,6 @@ out:
 }
 
 /**
- * ecryptfs_process_helo
- * @euid: The user ID owner of the message
- * @user_ns: The namespace in which @euid applies
- * @pid: The process ID for the userspace program that sent the
- *       message
- *
- * Adds the euid and pid values to the daemon euid hash.  If an euid
- * already has a daemon pid registered, the daemon will be
- * unregistered before the new daemon is put into the hash list.
- * Returns zero after adding a new daemon to the hash list;
- * non-zero otherwise.
- */
-int ecryptfs_process_helo(uid_t euid, struct user_namespace *user_ns,
-			  struct pid *pid)
-{
-	struct ecryptfs_daemon *new_daemon;
-	struct ecryptfs_daemon *old_daemon;
-	int rc;
-
-	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_find_daemon_by_euid(&old_daemon, euid, user_ns);
-	if (rc != 0) {
-		printk(KERN_WARNING "Received request from user [%d] "
-		       "to register daemon [0x%p]; unregistering daemon "
-		       "[0x%p]\n", euid, pid, old_daemon->pid);
-		rc = ecryptfs_send_raw_message(ECRYPTFS_MSG_QUIT, old_daemon);
-		if (rc)
-			printk(KERN_WARNING "Failed to send QUIT "
-			       "message to daemon [0x%p]; rc = [%d]\n",
-			       old_daemon->pid, rc);
-		hlist_del(&old_daemon->euid_chain);
-		kfree(old_daemon);
-	}
-	rc = ecryptfs_spawn_daemon(&new_daemon, euid, user_ns, pid);
-	if (rc)
-		printk(KERN_ERR "%s: The gods are displeased with this attempt "
-		       "to create a new daemon object for euid [%d]; pid "
-		       "[0x%p]; rc = [%d]\n", __func__, euid, pid, rc);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
-	return rc;
-}
-
-/**
  * ecryptfs_exorcise_daemon - Destroy the daemon struct
  *
  * Must be called ceremoniously while in possession of
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index dda3c58..4ec8f61 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -193,26 +193,20 @@ int ecryptfs_send_miscdev(char *data, size_t data_size,
 	int rc = 0;
 
 	mutex_lock(&msg_ctx->mux);
-	if (data) {
-		msg_ctx->msg = kmalloc((sizeof(*msg_ctx->msg) + data_size),
-				       GFP_KERNEL);
-		if (!msg_ctx->msg) {
-			rc = -ENOMEM;
-			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc(%zd, GFP_KERNEL)\n", __func__,
-			       (sizeof(*msg_ctx->msg) + data_size));
-			goto out_unlock;
-		}
-	} else
-		msg_ctx->msg = NULL;
+	msg_ctx->msg = kmalloc((sizeof(*msg_ctx->msg) + data_size),
+			       GFP_KERNEL);
+	if (!msg_ctx->msg) {
+		rc = -ENOMEM;
+		printk(KERN_ERR "%s: Out of memory whilst attempting "
+		       "to kmalloc(%zd, GFP_KERNEL)\n", __func__,
+		       (sizeof(*msg_ctx->msg) + data_size));
+		goto out_unlock;
+	}
 	msg_ctx->msg->index = msg_ctx->index;
 	msg_ctx->msg->data_len = data_size;
 	msg_ctx->type = msg_type;
-	if (data) {
-		memcpy(msg_ctx->msg->data, data, data_size);
-		msg_ctx->msg_size = (sizeof(*msg_ctx->msg) + data_size);
-	} else
-		msg_ctx->msg_size = 0;
+	memcpy(msg_ctx->msg->data, data, data_size);
+	msg_ctx->msg_size = (sizeof(*msg_ctx->msg) + data_size);
 	mutex_lock(&daemon->mux);
 	list_add_tail(&msg_ctx->daemon_out_list, &daemon->msg_ctx_out_queue);
 	daemon->num_queued_msg_ctx++;
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 46cec2b..5c6bab9 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -449,6 +449,7 @@ int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptfs_inode)
 	struct ecryptfs_crypt_stat *crypt_stat;
 
 	crypt_stat = &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
+	BUG_ON(!(crypt_stat->flags & ECRYPTFS_ENCRYPTED));
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
 		return ecryptfs_write_inode_size_to_xattr(ecryptfs_inode);
 	else
@@ -490,6 +491,16 @@ static int ecryptfs_write_end(struct file *file,
 		ecryptfs_printk(KERN_DEBUG, "Not a new file\n");
 	ecryptfs_printk(KERN_DEBUG, "Calling fill_zeros_to_end_of_page"
 			"(page w/ index = [0x%.16x], to = [%d])\n", index, to);
+	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
+		rc = ecryptfs_write_lower_page_segment(ecryptfs_inode, page, 0,
+						       to);
+		if (!rc) {
+			rc = copied;
+			fsstack_copy_inode_size(ecryptfs_inode,
+				ecryptfs_inode_to_lower(ecryptfs_inode));
+		}
+		goto out;
+	}
 	/* Fills in zeros if 'to' goes beyond inode size */
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 75c2ea9..a137c6e 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -117,13 +117,15 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		   size_t size)
 {
 	struct page *ecryptfs_page;
+	struct ecryptfs_crypt_stat *crypt_stat;
+	struct inode *ecryptfs_inode = ecryptfs_file->f_dentry->d_inode;
 	char *ecryptfs_page_virt;
-	loff_t ecryptfs_file_size =
-		i_size_read(ecryptfs_file->f_dentry->d_inode);
+	loff_t ecryptfs_file_size = i_size_read(ecryptfs_inode);
 	loff_t data_offset = 0;
 	loff_t pos;
 	int rc = 0;
 
+	crypt_stat = &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
 	/*
 	 * if we are writing beyond current size, then start pos
 	 * at the current size - we'll fill in zeros from there.
@@ -184,7 +186,13 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
 		unlock_page(ecryptfs_page);
-		rc = ecryptfs_encrypt_page(ecryptfs_page);
+		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED)
+			rc = ecryptfs_encrypt_page(ecryptfs_page);
+		else
+			rc = ecryptfs_write_lower_page_segment(ecryptfs_inode,
+						ecryptfs_page,
+						start_offset_in_page,
+						data_offset);
 		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
@@ -194,14 +202,16 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		pos += num_bytes;
 	}
 	if ((offset + size) > ecryptfs_file_size) {
-		i_size_write(ecryptfs_file->f_dentry->d_inode, (offset + size));
-		rc = ecryptfs_write_inode_size_to_metadata(
-			ecryptfs_file->f_dentry->d_inode);
-		if (rc) {
-			printk(KERN_ERR	"Problem with "
-			       "ecryptfs_write_inode_size_to_metadata; "
-			       "rc = [%d]\n", rc);
-			goto out;
+		i_size_write(ecryptfs_inode, (offset + size));
+		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED) {
+			rc = ecryptfs_write_inode_size_to_metadata(
+								ecryptfs_inode);
+			if (rc) {
+				printk(KERN_ERR	"Problem with "
+				       "ecryptfs_write_inode_size_to_metadata; "
+				       "rc = [%d]\n", rc);
+				goto out;
+			}
 		}
 	}
 out:
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index c27ac2b..fa4c7e7 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -170,7 +170,10 @@ static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 	list_for_each_entry(walker,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
-		seq_printf(m, ",ecryptfs_sig=%s", walker->sig);
+		if (walker->flags & ECRYPTFS_AUTH_TOK_FNEK)
+			seq_printf(m, ",ecryptfs_fnek_sig=%s", walker->sig);
+		else
+			seq_printf(m, ",ecryptfs_sig=%s", walker->sig);
 	}
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 
@@ -186,6 +189,8 @@ static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 		seq_printf(m, ",ecryptfs_xattr_metadata");
 	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
 		seq_printf(m, ",ecryptfs_encrypted_view");
+	if (mount_crypt_stat->flags & ECRYPTFS_UNLINK_SIGS)
+		seq_printf(m, ",ecryptfs_unlink_sigs");
 
 	return 0;
 }
