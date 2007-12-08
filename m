Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXLHCHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXLHCHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXLHCHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:07:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbXLHCHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:07:30 -0500
Message-ID: <4759FC29.6030302@redhat.com>
Date: Fri, 07 Dec 2007 20:06:33 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH] ecryptfs: make show_options reflect actual mount options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ecryptfs_show_options to reflect the actual mount
options in use.  Note that this does away with the "dir="
output, which is not a valid mount option and appears to be
unused.

Mount options such as "ecryptfs_verbose" and
"ecryptfs_xattr_metadata" are somewhat indeterminate for
a given fs, but in any case the reported mount options can
be used in a new mount command to get the same behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

---

Index: linux/fs/ecryptfs/super.c
===================================================================
--- linux.orig/fs/ecryptfs/super.c
+++ linux/fs/ecryptfs/super.c
@@ -157,32 +157,42 @@ static void ecryptfs_clear_inode(struct 
 /**
  * ecryptfs_show_options
  *
- * Prints the directory we are currently mounted over.
- * Returns zero on success; non-zero otherwise
+ * Prints the mount options for a given superblock.
+ * Returns zero; does not fail.
  */
 static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
-	struct dentry *lower_root_dentry = ecryptfs_dentry_to_lower(sb->s_root);
-	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(sb->s_root);
-	char *tmp_page;
-	char *path;
-	int rc = 0;
-
-	tmp_page = (char *)__get_free_page(GFP_KERNEL);
-	if (!tmp_page) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	path = d_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
-	if (IS_ERR(path)) {
-		rc = PTR_ERR(path);
-		goto out;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
+	struct ecryptfs_global_auth_tok *walker;
+
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_for_each_entry(walker,
+			    &mount_crypt_stat->global_auth_tok_list,
+			    mount_crypt_stat_list) {
+		seq_printf(m, ",ecryptfs_sig=%s", walker->sig);
 	}
-	seq_printf(m, ",dir=%s", path);
-	free_page((unsigned long)tmp_page);
-out:
-	return rc;
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+
+	/* Note this is global and probably shouldn't be a mount option */
+	if (ecryptfs_verbosity)
+		seq_printf(m, ",ecryptfs_debug=%d\n", ecryptfs_verbosity);
+
+	seq_printf(m, ",ecryptfs_cipher=%s",
+		mount_crypt_stat->global_default_cipher_name);
+
+	if (mount_crypt_stat->global_default_cipher_key_size)
+		seq_printf(m, ",ecryptfs_key_bytes=%d",
+			   mount_crypt_stat->global_default_cipher_key_size);
+	if (mount_crypt_stat->flags & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)
+		seq_printf(m, ",ecryptfs_passthrough");
+	if (mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED)
+		seq_printf(m, ",ecryptfs_xattr_metadata");
+	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+		seq_printf(m, ",ecryptfs_encrypted_view");
+
+	return 0;
 }
 
 struct super_operations ecryptfs_sops = {



