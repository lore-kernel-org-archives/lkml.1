Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXB1RHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXB1RHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXB1RG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:06:59 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:24277 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXB1RG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:06:59 -0500
To: LKML <linux-kernel@vger.kernel.org>
CC: mhalcrow@us.ibm.com
Subject: [PATCH] ecryptfs: check xattr operation support fix 
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 28 Feb 2007 20:05:16 +0300
Message-ID: <871wkaxlf7.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  - ecryptfs_write_inode_size_to_metadata() error code was ignored.
  - i_op->setxattr() must be supported by lower fs because used below.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 fs/ecryptfs/inode.c |    6 +++---
 fs/ecryptfs/mmap.c  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 27fd14a..9ccefad 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -168,9 +168,9 @@ static int grow_file(struct dentry *ecryptfs_dentry, struct file *lower_file,
 		goto out;
 	}
 	i_size_write(inode, 0);
-	ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode, inode,
-					      ecryptfs_dentry,
-					      ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
+	rc = ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode,
+			inode, ecryptfs_dentry,
+			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
 	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
 out:
 	return rc;
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 1e5d2ba..416985f 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -491,7 +491,8 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *lower_inode,
 		goto out;
 	}
 	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	if (!lower_dentry->d_inode->i_op->getxattr) {
+	if (!lower_dentry->d_inode->i_op->getxattr ||
+			!lower_dentry->d_inode->i_op->setxattr) {
 		printk(KERN_WARNING
 		       "No support for setting xattr in lower filesystem\n");
 		rc = -ENOSYS;
-- 
1.5.0.1


