Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYAHF0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYAHF0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYAHF0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:26:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57231 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYAHF0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:26:05 -0500
Date: Mon, 7 Jan 2008 23:25:42 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, shaggy@us.ibm.com, sandeen@redhat.com,
       jmoyer@redhat.com
Subject: [PATCH] eCryptfs: Fix dentry handling on create error, unlink, and inode destroy
Message-ID: <20080108052542.GX10989@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects some erroneous dentry handling in eCryptfs.

If there is a problem creating the lower file, then there is nothing
that the persistent lower file can do to really help us. This patch
makes a vfs_create() failure in the lower filesystem always lead to an
unconditional do_create failure in eCryptfs.

Under certain sequences of operations, the eCryptfs dentry can remain
in the dcache after an unlink. This patch calls d_drop() on the
eCryptfs dentry to correct this.

eCryptfs has no business calling d_delete() directly on a lower
filesystem's dentry. This patch removes the call to d_delete() on the
lower persistent file's dentry in ecryptfs_destroy_inode().

(Thanks to David Kleikamp, Eric Sandeen, and Jeff Moyer for helping
identify and resolve this issue)

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/inode.c |   20 ++++----------------
 fs/ecryptfs/super.c |    1 -
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0b1ab01..5a71918 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -120,22 +120,9 @@ ecryptfs_do_create(struct inode *directory_inode,
 	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
 					     ecryptfs_dentry, mode, nd);
 	if (rc) {
-		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
-		struct ecryptfs_inode_info *inode_info =
-			ecryptfs_inode_to_private(ecryptfs_inode);
-
-		printk(KERN_WARNING "%s: Error creating underlying file; "
-		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
-		if (inode_info) {
-			mutex_lock(&inode_info->lower_file_mutex);
-			if (!inode_info->lower_file) {
-				mutex_unlock(&inode_info->lower_file_mutex);
-				printk(KERN_ERR "%s: Failure to set underlying "
-				       "file; rc = [%d]\n", __FUNCTION__, rc);
-				goto out_lock;
-			}
-			mutex_unlock(&inode_info->lower_file_mutex);
-		}
+		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
+		       "rc = [%d]\n", __FUNCTION__, rc);
+		goto out_lock;
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
 				directory_inode->i_sb, 0);
@@ -451,6 +438,7 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 	dentry->d_inode->i_nlink =
 		ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink;
 	dentry->d_inode->i_ctime = dir->i_ctime;
+	d_drop(dentry);
 out_unlock:
 	unlock_parent(lower_dentry);
 	return rc;
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index f8cdab2..4859c4e 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -86,7 +86,6 @@ static void ecryptfs_destroy_inode(struct inode *inode)
 			fput(inode_info->lower_file);
 			inode_info->lower_file = NULL;
 			d_drop(lower_dentry);
-			d_delete(lower_dentry);
 		}
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
-- 
1.5.3.6

