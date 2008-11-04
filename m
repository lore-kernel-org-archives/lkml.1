Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYKDVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYKDVk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYKDVkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:40:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35855 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYKDVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:40:09 -0500
Date: Tue, 4 Nov 2008 15:39:58 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: [PATCH 2/5] eCryptfs: Filename Encryption: Header updates
Message-ID: <20081104213958.GB6677@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extensions to the header file to support filename encryption.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |    4 +-
 fs/ecryptfs/ecryptfs_kernel.h |   61 +++++++++++++++++++++++++++++++++--------
 2 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 4857327..c9839df 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -175,8 +175,8 @@ out:
  *
  * Returns zero on success; non-zero on error.
  */
-static int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
-			      loff_t offset)
+int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
+		       loff_t offset)
 {
 	int rc = 0;
 	char dst[MD5_DIGEST_SIZE];
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 76a95bd..b648175 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -51,12 +51,16 @@
 #define ECRYPTFS_VERSIONING_XATTR                 0x00000010
 #define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
 #define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
+#define ECRYPTFS_VERSIONING_HMAC                  0x00000080
+#define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
+#define ECRYPTFS_VERSIONING_GCM                   0x00000200
 #define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
 				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
 				  | ECRYPTFS_VERSIONING_PUBKEY \
 				  | ECRYPTFS_VERSIONING_XATTR \
 				  | ECRYPTFS_VERSIONING_MULTKEY \
-				  | ECRYPTFS_VERSIONING_DEVMISC)
+				  | ECRYPTFS_VERSIONING_DEVMISC \
+				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
 #define ECRYPTFS_SALT_SIZE 8
@@ -232,23 +236,39 @@ struct ecryptfs_key_sig {
 	char keysig[ECRYPTFS_SIG_SIZE_HEX];
 };
 
+struct ecryptfs_filename {
+	struct list_head crypt_stat_list;
+#define ECRYPTFS_FILENAME_CONTAINS_DECRYPTED 0x00000001
+	u32 flags;
+	u32 seq_no;
+	char *filename;
+	char *encrypted_filename;
+	size_t filename_size;
+	size_t encrypted_filename_size;
+	char fnek_sig[ECRYPTFS_SIG_SIZE_HEX];
+	char dentry_name[ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN + 1];
+};
+
 /**
  * This is the primary struct associated with each encrypted file.
  *
  * TODO: cache align/pack?
  */
 struct ecryptfs_crypt_stat {
-#define ECRYPTFS_STRUCT_INITIALIZED 0x00000001
-#define ECRYPTFS_POLICY_APPLIED     0x00000002
-#define ECRYPTFS_NEW_FILE           0x00000004
-#define ECRYPTFS_ENCRYPTED          0x00000008
-#define ECRYPTFS_SECURITY_WARNING   0x00000010
-#define ECRYPTFS_ENABLE_HMAC        0x00000020
-#define ECRYPTFS_ENCRYPT_IV_PAGES   0x00000040
-#define ECRYPTFS_KEY_VALID          0x00000080
-#define ECRYPTFS_METADATA_IN_XATTR  0x00000100
-#define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
-#define ECRYPTFS_KEY_SET            0x00000400
+#define ECRYPTFS_STRUCT_INITIALIZED   0x00000001
+#define ECRYPTFS_POLICY_APPLIED       0x00000002
+#define ECRYPTFS_NEW_FILE             0x00000004
+#define ECRYPTFS_ENCRYPTED            0x00000008
+#define ECRYPTFS_SECURITY_WARNING     0x00000010
+#define ECRYPTFS_ENABLE_HMAC          0x00000020
+#define ECRYPTFS_ENCRYPT_IV_PAGES     0x00000040
+#define ECRYPTFS_KEY_VALID            0x00000080
+#define ECRYPTFS_METADATA_IN_XATTR    0x00000100
+#define ECRYPTFS_VIEW_AS_ENCRYPTED    0x00000200
+#define ECRYPTFS_KEY_SET              0x00000400
+#define ECRYPTFS_ENCRYPT_FILENAMES    0x00000800
+#define ECRYPTFS_ENCFN_USE_MOUNT_FNEK 0x00001000
+#define ECRYPTFS_ENCFN_USE_FEK        0x00002000
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -597,6 +617,15 @@ struct ecryptfs_open_req {
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       u32 flags);
+int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
+					struct dentry *lower_dentry,
+					struct ecryptfs_crypt_stat *crypt_stat,
+					struct inode *ecryptfs_dir_inode,
+					struct nameidata *ecryptfs_nd);
+int ecryptfs_decode_and_decrypt_filename(char **decrypted_name,
+					 size_t *decrypted_name_size,
+					 struct dentry *ecryptfs_dentry,
+					 const char *name, size_t name_size);
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length);
 int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
@@ -604,6 +633,12 @@ int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 int ecryptfs_encode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
 			     char **encoded_name);
+int ecryptfs_encrypt_and_encode_filename(
+	char **encoded_name,
+	size_t *encoded_name_size,
+	struct ecryptfs_crypt_stat *crypt_stat,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+	const char *name, size_t name_size);
 struct dentry *ecryptfs_lower_dentry(struct dentry *this_dentry);
 void ecryptfs_dump_hex(char *data, int bytes);
 int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
@@ -730,5 +765,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 			     size_t *packet_size,
 			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 			     char *data, size_t max_packet_size);
+int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
+		       loff_t offset);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
-- 
1.5.3.6

