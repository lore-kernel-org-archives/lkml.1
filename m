Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKLREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKLREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKLREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:04:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48452 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYKLREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:04:43 -0500
Date: Wed, 12 Nov 2008 11:04:13 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: [PATCH] eCryptfs: Fix data types (int/size_t)
Message-ID: <20081112170413.GC6842@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104213908.GA6677@halcrowt61p.austin.ibm.com> <20081106141234.ba53c112.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141234.ba53c112.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:12:34PM -0800, Andrew Morton wrote:
> On Tue, 4 Nov 2008 15:39:08 -0600
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
> > +		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
> 
> size_t's must be printed with %zd.

Correct several format string data type specifiers. Correct filename
size data types; they should be size_t rather than int when passed as
parameters to some other functions (although note that the filenames
will never be larger than int).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c   |    4 ++--
 fs/ecryptfs/file.c     |    2 +-
 fs/ecryptfs/inode.c    |    2 +-
 fs/ecryptfs/keystore.c |   24 ++++++++++++------------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 490b129..e935a22 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -2093,7 +2093,7 @@ int ecryptfs_encrypt_and_encode_filename(
 		filename = kzalloc(sizeof(*filename), GFP_KERNEL);
 		if (!filename) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kzalloc [%d] bytes\n", __func__,
+			       "to kzalloc [%zd] bytes\n", __func__,
 			       sizeof(*filename));
 			rc = -ENOMEM;
 			goto out;
@@ -2127,7 +2127,7 @@ int ecryptfs_encrypt_and_encode_filename(
 		(*encoded_name) = kmalloc((*encoded_name_size) + 1, GFP_KERNEL);
 		if (!(*encoded_name)) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kzalloc [%d] bytes\n", __func__,
+			       "to kzalloc [%zd] bytes\n", __func__,
 			       (*encoded_name_size));
 			rc = -ENOMEM;
 			kfree(filename->encrypted_filename);
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 6b0a99d..284ccb6 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -82,7 +82,7 @@ ecryptfs_filldir(void *dirent, const char *lower_name, int lower_namelen,
 {
 	struct ecryptfs_getdents_callback *buf =
 	    (struct ecryptfs_getdents_callback *)dirent;
-	int name_size;
+	size_t name_size;
 	char *name;
 	int rc;
 
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index cf50729..d7f449e 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -362,7 +362,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
 				      struct nameidata *ecryptfs_nd)
 {
 	char *encrypted_and_encoded_name = NULL;
-	int encrypted_and_encoded_name_size;
+	size_t encrypted_and_encoded_name_size;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat = NULL;
 	struct ecryptfs_inode_info *inode_info;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 5cfd830..71dcf0e 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -556,8 +556,8 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		goto out_unlock;
 	}
 	if (s->max_packet_size > (*remaining_bytes)) {
-		printk(KERN_WARNING "%s: Require [%d] bytes to write; only "
-		       "[%d] available\n", __func__, s->max_packet_size,
+		printk(KERN_WARNING "%s: Require [%zd] bytes to write; only "
+		       "[%zd] available\n", __func__, s->max_packet_size,
 		       (*remaining_bytes));
 		rc = -EINVAL;
 		goto out_unlock;
@@ -594,7 +594,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		mount_crypt_stat->global_default_fn_cipher_key_bytes);
 	if (s->cipher_code == 0) {
 		printk(KERN_WARNING "%s: Unable to generate code for "
-		       "cipher [%s] with key bytes [%d]\n", __func__,
+		       "cipher [%s] with key bytes [%zd]\n", __func__,
 		       mount_crypt_stat->global_default_fn_cipher_name,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		rc = -EINVAL;
@@ -693,7 +693,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
@@ -703,7 +703,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
@@ -787,7 +787,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
-		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -825,8 +825,8 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 					  - ECRYPTFS_SIG_SIZE - 1);
 	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)
 	    > max_packet_size) {
-		printk(KERN_WARNING "%s: max_packet_size is [%d]; real packet "
-		       "size is [%d]\n", __func__, max_packet_size,
+		printk(KERN_WARNING "%s: max_packet_size is [%zd]; real packet "
+		       "size is [%zd]\n", __func__, max_packet_size,
 		       (1 + s->packet_size_len + 1
 			+ s->block_aligned_filename_size));
 		rc = -EINVAL;
@@ -860,7 +860,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_unlock;
 	}
@@ -869,7 +869,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 					GFP_KERNEL);
 	if (!s->decrypted_filename) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__,
+		       "kmalloc [%zd] bytes\n", __func__,
 		       s->block_aligned_filename_size);
 		rc = -ENOMEM;
 		goto out_unlock;
@@ -880,7 +880,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert decrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_free_unlock;
 	}
@@ -944,7 +944,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	(*filename) = kmalloc(((*filename_size) + 1), GFP_KERNEL);
 	if (!(*filename)) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__,
+		       "kmalloc [%zd] bytes\n", __func__,
 		       ((*filename_size) + 1));
 		rc = -ENOMEM;
 		goto out_free_unlock;
-- 
1.5.3.7

