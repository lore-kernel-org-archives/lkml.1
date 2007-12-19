Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXLSUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXLSUAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXLSUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:00:27 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:45423 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751830AbXLSUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:00:26 -0500
X-YMail-OSG: twzC65EVM1kOtVQf2_LGdxg4nPRn4NSgQg5c30Y5FwBKG010zG5YQdP3qqdBlxPgY6zHOfo_jQ--
Date: Wed, 19 Dec 2007 13:51:35 -0600
From: Michael Halcrow <mike@halcrow.us>
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com
Subject: [PATCH] eCryptfs: Minor fixes to printk messages
Message-ID: <20071219195134.GR13486@halcrow.us>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk statements that result when the user does not have the
proper key available could use some refining.

Signed-off-by: Mike Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f8ef0af..beba580 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1552,9 +1552,10 @@ int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode)
 	size = ecryptfs_getxattr_lower(lower_dentry, ECRYPTFS_XATTR_NAME,
 				       page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
 	if (size < 0) {
-		printk(KERN_ERR "Error attempting to read the [%s] "
-		       "xattr from the lower file; return value = [%zd]\n",
-		       ECRYPTFS_XATTR_NAME, size);
+		if (unlikely(ecryptfs_verbosity > 0))
+			printk(KERN_INFO "Error attempting to read the [%s] "
+			       "xattr from the lower file; return value = "
+			       "[%zd]\n", ECRYPTFS_XATTR_NAME, size);
 		rc = -EINVAL;
 		goto out;
 	}
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index c98c469..2b8f5ed 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -209,9 +209,10 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
 				rc = -EIO;
-				printk(KERN_WARNING "Attempt to read file that "
+				printk(KERN_WARNING "Either the lower file "
 				       "is not in a valid eCryptfs format, "
-				       "and plaintext passthrough mode is not "
+				       "or the key could not be retrieved. "
+				       "Plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
 				mutex_unlock(&crypt_stat->cs_mutex);
 				goto out_free;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0b1ab01..2b29e2b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -887,11 +887,11 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
 				rc = -EIO;
-				printk(KERN_WARNING "Attempt to read file that "
+				printk(KERN_WARNING "Either the lower file "
 				       "is not in a valid eCryptfs format, "
-				       "and plaintext passthrough mode is not "
+				       "or the key could not be retrieved. "
+				       "Plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
-
 				mutex_unlock(&crypt_stat->cs_mutex);
 				goto out;
 			}
