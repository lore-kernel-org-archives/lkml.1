Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYGCUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYGCUcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbYGCUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:32:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:39316 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYGCUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MN+zJtZzdDDf2WygbnPBkREJrhQTWjtycZ6YvDJ/qE6dObIWLGGKgPkhrU344UjM2I
         30ZrsvPeE+i76UAibUgf2g49/XUpl9Vtc08llIqoPE3no2xma2Ku4z6rsPuo0GCAEbQl
         nclj/E/i4I1i+npEkGZivST9VIEgUzCmJqFjU=
Subject: [PATCH 2/2] ecryptfs: inode.c mmap.c use unaligned byteorder
	helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 13:31:24 -0700
Message-Id: <1215117084.16647.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixe sparse warnings:
fs/ecryptfs/inode.c:368:15: warning: cast to restricted __be64
fs/ecryptfs/mmap.c:385:12: warning: incorrect type in assignment (different base types)
fs/ecryptfs/mmap.c:385:12:    expected unsigned long long [unsigned] [assigned] [usertype] file_size
fs/ecryptfs/mmap.c:385:12:    got restricted __be64 [usertype] <noident>
fs/ecryptfs/mmap.c:428:12: warning: incorrect type in assignment (different base types)
fs/ecryptfs/mmap.c:428:12:    expected unsigned long long [unsigned] [assigned] [usertype] file_size
fs/ecryptfs/mmap.c:428:12:    got restricted __be64 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ecryptfs/inode.c |    4 ++--
 fs/ecryptfs/mmap.c  |   11 +++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index c92cc1c..7315547 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -31,6 +31,7 @@
 #include <linux/mount.h>
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 static struct dentry *lock_parent(struct dentry *dentry)
@@ -364,8 +365,7 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 		else
 			file_size = i_size_read(lower_dentry->d_inode);
 	} else {
-		memcpy(&file_size, page_virt, sizeof(file_size));
-		file_size = be64_to_cpu(file_size);
+		file_size = get_unaligned_be64(page_virt);
 	}
 	i_size_write(dentry->d_inode, (loff_t)file_size);
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 2b6fe1e..245c2dc 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -372,7 +373,6 @@ out:
  */
 static int ecryptfs_write_inode_size_to_header(struct inode *ecryptfs_inode)
 {
-	u64 file_size;
 	char *file_size_virt;
 	int rc;
 
@@ -381,9 +381,7 @@ static int ecryptfs_write_inode_size_to_header(struct inode *ecryptfs_inode)
 		rc = -ENOMEM;
 		goto out;
 	}
-	file_size = (u64)i_size_read(ecryptfs_inode);
-	file_size = cpu_to_be64(file_size);
-	memcpy(file_size_virt, &file_size, sizeof(u64));
+	put_unaligned_be64(i_size_read(ecryptfs_inode), file_size_virt);
 	rc = ecryptfs_write_lower(ecryptfs_inode, file_size_virt, 0,
 				  sizeof(u64));
 	kfree(file_size_virt);
@@ -403,7 +401,6 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *ecryptfs_inode)
 	struct dentry *lower_dentry =
 		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file->f_dentry;
 	struct inode *lower_inode = lower_dentry->d_inode;
-	u64 file_size;
 	int rc;
 
 	if (!lower_inode->i_op->getxattr || !lower_inode->i_op->setxattr) {
@@ -424,9 +421,7 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *ecryptfs_inode)
 					   xattr_virt, PAGE_CACHE_SIZE);
 	if (size < 0)
 		size = 8;
-	file_size = (u64)i_size_read(ecryptfs_inode);
-	file_size = cpu_to_be64(file_size);
-	memcpy(xattr_virt, &file_size, sizeof(u64));
+	put_unaligned_be64(i_size_read(ecryptfs_inode), xattr_virt);
 	rc = lower_inode->i_op->setxattr(lower_dentry, ECRYPTFS_XATTR_NAME,
 					 xattr_virt, size, 0);
 	mutex_unlock(&lower_inode->i_mutex);
-- 
1.5.6.1.281.g1087e

