Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXJLQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXJLQWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXJLQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008AbXJLQIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 33/52] CRED: Make the get_parent() export op take a credential
	pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:08 +0100
Message-ID: <20071012160808.15119.3400.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the get_parent() export op take a credential pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/namei.c          |    3 +--
 fs/ext3/namei.h          |    2 +-
 fs/fat/inode.c           |    2 +-
 include/linux/exportfs.h |    5 +++--
 mm/shmem.c               |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index cd0fcde..aa741bb 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1072,9 +1072,8 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 }
 
 
-struct dentry *ext3_get_parent(struct dentry *child)
+struct dentry *ext3_get_parent(struct dentry *child, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	unsigned long ino;
 	struct dentry *parent;
 	struct inode *inode;
diff --git a/fs/ext3/namei.h b/fs/ext3/namei.h
index f2ce2b0..53d7c59 100644
--- a/fs/ext3/namei.h
+++ b/fs/ext3/namei.h
@@ -5,4 +5,4 @@
  *
 */
 
-extern struct dentry *ext3_get_parent(struct dentry *child);
+extern struct dentry *ext3_get_parent(struct dentry *child, struct cred *cred);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 045647d..519e1b4 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -748,7 +748,7 @@ fat_encode_fh(struct dentry *de, __u32 *fh, int *lenp, int connectable)
 	return 3;
 }
 
-static struct dentry *fat_get_parent(struct dentry *child)
+static struct dentry *fat_get_parent(struct dentry *child, struct cred *cred)
 {
 	struct buffer_head *bh;
 	struct msdos_dir_entry *de;
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 8872fe8..895fd2d 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -73,7 +73,8 @@ struct vfsmount;
  * get_parent:
  *    @get_parent should find the parent directory for the given @child which
  *    is also a directory.  In the event that it cannot be found, or storage
- *    space cannot be allocated, a %ERR_PTR should be returned.
+ *    space cannot be allocated, a %ERR_PTR should be returned.  @cred indicates
+ *    the credentials to be used for the lookup.
  *
  * get_dentry:
  *    Given a &super_block (@sb) and a pointer to a file-system specific inode
@@ -103,7 +104,7 @@ struct export_operations {
 			int connectable);
 	int (*get_name)(struct dentry *parent, char *name,
 			struct dentry *child);
-	struct dentry * (*get_parent)(struct dentry *child);
+	struct dentry * (*get_parent)(struct dentry *child, struct cred *cred);
 	struct dentry * (*get_dentry)(struct super_block *sb, void *inump);
 
 	/* This is set by the exporting module to a standard helper */
diff --git a/mm/shmem.c b/mm/shmem.c
index fc834e7..ee0b20a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1994,7 +1994,7 @@ static struct xattr_handler *shmem_xattr_handlers[] = {
 };
 #endif
 
-static struct dentry *shmem_get_parent(struct dentry *child)
+static struct dentry *shmem_get_parent(struct dentry *child, struct cred *cred)
 {
 	return ERR_PTR(-ESTALE);
 }

