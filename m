Return-Path: <linux-kernel-owner+w=401wt.eu-S965343AbXBLTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343AbXBLTnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXBLTnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:43:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40975 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXBLTnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:43:13 -0500
Date: Mon, 12 Feb 2007 13:43:07 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] eCryptfs: Reduce stack usage in ecryptfs_generate_key_packet_set()
Message-ID: <20070212194307.GA6398@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs is gobbling a lot of stack in
ecryptfs_generate_key_packet_set() because it allocates a temporary
memory-hungry ecryptfs_key_record struct. This patch introduces a new
kmem_cache for that struct and converts
ecryptfs_generate_key_packet_set() to use it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/keystore.c        |   26 ++++++++++++++++++--------
 fs/ecryptfs/main.c            |    5 +++++
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 046f0c3..c290df2 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -480,6 +480,7 @@ extern struct kmem_cache *ecryptfs_header_cache_1;
 extern struct kmem_cache *ecryptfs_header_cache_2;
 extern struct kmem_cache *ecryptfs_xattr_cache;
 extern struct kmem_cache *ecryptfs_lower_page_cache;
+extern struct kmem_cache *ecryptfs_key_record_cache;
 
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 81156e9..b550dea 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1638,6 +1638,8 @@ out:
 	return rc;
 }
 
+struct kmem_cache *ecryptfs_key_record_cache;
+
 /**
  * ecryptfs_generate_key_packet_set
  * @dest: Virtual address from which to write the key record set
@@ -1664,50 +1666,55 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	size_t written;
-	struct ecryptfs_key_record key_rec;
+	struct ecryptfs_key_record *key_rec;
 	int rc = 0;
 
 	(*len) = 0;
+	key_rec = kmem_cache_alloc(ecryptfs_key_record_cache, GFP_KERNEL);
+	if (!key_rec) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	if (mount_crypt_stat->global_auth_tok) {
 		auth_tok = mount_crypt_stat->global_auth_tok;
 		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
 			rc = write_tag_3_packet((dest_base + (*len)),
 						max, auth_tok,
-						crypt_stat, &key_rec,
+						crypt_stat, key_rec,
 						&written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 3 packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 			/* Write auth tok signature packet */
 			rc = write_tag_11_packet(
 				(dest_base + (*len)),
 				(max - (*len)),
-				key_rec.sig, ECRYPTFS_SIG_SIZE, &written);
+				key_rec->sig, ECRYPTFS_SIG_SIZE, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_ERR, "Error writing "
 						"auth tok signature packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 		} else if (auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
 			rc = write_tag_1_packet(dest_base + (*len),
 						max, auth_tok,
 						crypt_stat,mount_crypt_stat,
-						&key_rec, &written);
+						key_rec, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 1 packet\n");
-				goto out;
+				goto out_free;
 			}
 			(*len) += written;
 		} else {
 			ecryptfs_printk(KERN_WARNING, "Unsupported "
 					"authentication token type\n");
 			rc = -EINVAL;
-			goto out;
+			goto out_free;
 		}
 	} else
 		BUG();
@@ -1717,6 +1724,9 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 		ecryptfs_printk(KERN_ERR, "Error writing boundary byte\n");
 		rc = -EIO;
 	}
+
+out_free:
+	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
 out:
 	if (rc)
 		(*len) = 0;
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 26fe405..80044d1 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -651,6 +651,11 @@ static struct ecryptfs_cache_info {
 		.name = "ecryptfs_lower_page_cache",
 		.size = PAGE_CACHE_SIZE,
 	},
+	{
+		.cache = &ecryptfs_key_record_cache,
+		.name = "ecryptfs_key_record_cache",
+		.size = sizeof(struct ecryptfs_key_record),
+	},
 };
 
 static void ecryptfs_free_kmem_caches(void)
-- 
1.4.4.4

