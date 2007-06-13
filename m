Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbXFMTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbXFMTCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759956AbXFMTCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:02:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50016 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959AbXFMTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:02:03 -0400
Date: Wed, 13 Jun 2007 13:54:56 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trevor.highland@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] eCryptfs: initialize crypt_stat in setattr
Message-ID: <20070613185456.GY13465@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070613185316.GX13465@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613185316.GX13465@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes in eCryptfs have made it possible to get to
ecryptfs_setattr() with an uninitialized crypt_stat struct. This
results in a wide and colorful variety of unpleasantries. This patch
properly initializes the crypt_stat structure in ecryptfs_setattr()
when it is necessary to do so.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0981ae3..83e94fe 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -894,9 +894,54 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	struct ecryptfs_crypt_stat *crypt_stat;
 
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	if (!(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
+		ecryptfs_init_crypt_stat(crypt_stat);
 	inode = dentry->d_inode;
 	lower_inode = ecryptfs_inode_to_lower(inode);
+	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	mutex_lock(&crypt_stat->cs_mutex);
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+	else if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
+		 || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
+		struct vfsmount *lower_mnt;
+		struct file *lower_file = NULL;
+		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+		int lower_flags;
+
+		lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+		lower_flags = O_RDONLY;
+		if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
+						   lower_mnt, lower_flags))) {
+			printk(KERN_ERR
+			       "Error opening lower file; rc = [%d]\n", rc);
+			mutex_unlock(&crypt_stat->cs_mutex);
+			goto out;
+		}
+		mount_crypt_stat = &ecryptfs_superblock_to_private(
+			dentry->d_sb)->mount_crypt_stat;
+		if ((rc = ecryptfs_read_metadata(dentry, lower_file))) {
+			if (!(mount_crypt_stat->flags
+			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
+				rc = -EIO;
+				printk(KERN_WARNING "Attempt to read file that "
+				       "is not in a valid eCryptfs format, "
+				       "and plaintext passthrough mode is not "
+				       "enabled; returning -EIO\n");
+
+				mutex_unlock(&crypt_stat->cs_mutex);
+				fput(lower_file);
+				goto out;
+			}
+			rc = 0;
+			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+			mutex_unlock(&crypt_stat->cs_mutex);
+			fput(lower_file);
+			goto out;
+		}
+		fput(lower_file);
+	}
+	mutex_unlock(&crypt_stat->cs_mutex);
 	if (ia->ia_valid & ATTR_SIZE) {
 		ecryptfs_printk(KERN_DEBUG,
 				"ia->ia_valid = [0x%x] ATTR_SIZE" " = [0x%x]\n",
