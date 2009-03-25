Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZCYApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZCYApZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZCYAa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:27 -0400
Received: from kroah.org ([198.145.64.141]:54161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756879AbZCYAaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/61] sysfs: reference sysfs_dirent from sysfs inodes
Date: Tue, 24 Mar 2009 17:26:46 -0700
Message-Id: <1237940825-22904-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

The sysfs_dirent serves as both an inode and a directory entry
for sysfs.  To prevent the sysfs inode numbers from being freed
prematurely hold a reference to sysfs_dirent from the sysfs inode.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |   17 +++++++++++++++++
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index dfa3d94..555f0ff 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -147,6 +147,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct bin_attribute *bin_attr;
 
+	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
@@ -214,6 +215,22 @@ struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
 	return inode;
 }
 
+/*
+ * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
+ * To prevent the sysfs inode numbers from being freed prematurely we take a
+ * reference to sysfs_dirent from the sysfs inode.  A
+ * super_operations.delete_inode() implementation is needed to drop that
+ * reference upon inode destruction.
+ */
+void sysfs_delete_inode(struct inode *inode)
+{
+	struct sysfs_dirent *sd  = inode->i_private;
+
+	truncate_inode_pages(&inode->i_data, 0);
+	clear_inode(inode);
+	sysfs_put(sd);
+}
+
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 84ef378..4974995 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ struct kmem_cache *sysfs_dir_cachep;
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.delete_inode	= sysfs_delete_inode,
 };
 
 struct sysfs_dirent sysfs_root = {
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 93c6d6b..9055d04 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -145,6 +145,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
  * inode.c
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
-- 
1.6.2

