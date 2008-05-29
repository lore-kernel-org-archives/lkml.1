Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbYE2WHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbYE2WHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYE2WHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:07:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37047 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYE2WHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:07:07 -0400
Date: Thu, 29 May 2008 17:08:17 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shaggy@us.ibm.com, sandeen@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: Remove unnecessary page decrypt call
Message-ID: <20080529220817.GF7450@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page decrypt calls in ecryptfs_write() are both pointless and
buggy. Pointless because ecryptfs_get_locked_page() has already
brought the page up to date, and buggy because prior mmap writes will
just be blown away by the decrypt call.

This patch also removes the declaration of a now-nonexistent function
ecryptfs_write_zeros().

Thanks to Eric Sandeen and David Kleikamp for helping to track this
down.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    2 --
 fs/ecryptfs/read_write.c      |   22 ----------------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index c1f4de1..b4a0ccc 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -674,8 +674,6 @@ int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig);
-int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
-			 int num_zeros);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index ebf5515..75c2ea9 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -157,20 +157,6 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		if (start_offset_in_page) {
-			/* Read in the page from the lower
-			 * into the eCryptfs inode page cache,
-			 * decrypting */
-			rc = ecryptfs_decrypt_page(ecryptfs_page);
-			if (rc) {
-				printk(KERN_ERR "%s: Error decrypting "
-				       "page; rc = [%d]\n",
-				       __func__, rc);
-				ClearPageUptodate(ecryptfs_page);
-				page_cache_release(ecryptfs_page);
-				goto out;
-			}
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 
 		/*
@@ -349,14 +335,6 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		rc = ecryptfs_decrypt_page(ecryptfs_page);
-		if (rc) {
-			printk(KERN_ERR "%s: Error decrypting "
-			       "page; rc = [%d]\n", __func__, rc);
-			ClearPageUptodate(ecryptfs_page);
-			page_cache_release(ecryptfs_page);
-			goto out;
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 		memcpy((data + data_offset),
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
-- 
1.5.3.6

