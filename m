Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXITIK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXITIK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbXITIGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42005 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbXITIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=C63/oQFmm+rTpsXmD+6s+3RhF9km5Lt5dywBVCsbGy7C7LfB+zQ+PFimb29g2HRhTCYLHqZWFNS9+mfOUPSteX1KJ97K1YdwjdaYvvP5zN9UEVg06Cr2THRmZ/iWdr5Y10Tqn0XLZB39S5o1hg11StRXIxaVJWhedEY56EINQ1s=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 14/22] sysfs: s/symlink/link/g
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755404139-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sysfs symlinks are either called symlinks or links.  Rename
everything to link and drop attr and _sd postfix as new interface
won't be bound to kobj.

This patch doesn't introduce any logic change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |    6 +++---
 fs/sysfs/inode.c   |    4 ++--
 fs/sysfs/symlink.c |    9 ++++-----
 fs/sysfs/sysfs.h   |   16 ++++++++--------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 263d346..a20beff 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -277,8 +277,8 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 */
 	parent_sd = sd->s_parent;
 
-	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
-		sysfs_put(sd->s_symlink.target_sd);
+	if (sysfs_type(sd) == SYSFS_LINK)
+		sysfs_put(sd->s_link.target);
 	if (sd->s_flags & SYSFS_FLAG_NAME_COPIED)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
@@ -345,7 +345,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	case SYSFS_BIN:
 		mode |= S_IFREG;
 		break;
-	case SYSFS_KOBJ_LINK:
+	case SYSFS_LINK:
 		mode |= S_IFLNK;
 		break;
 	}
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index d303e62..8df357e 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -168,8 +168,8 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_size = sd->s_bin.size;
 		inode->i_fop = &sysfs_bin_file_operations;
 		break;
-	case SYSFS_KOBJ_LINK:
-		inode->i_op = &sysfs_symlink_inode_operations;
+	case SYSFS_LINK:
+		inode->i_op = &sysfs_link_inode_operations;
 		break;
 	default:
 		BUG();
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 9c15a32..2c3e4f7 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -82,12 +82,11 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		goto out_put;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(name, S_IRWXUGO | SYSFS_COPY_NAME,
-			      SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(name, S_IRWXUGO | SYSFS_COPY_NAME, SYSFS_LINK);
 	if (!sd)
 		goto out_put;
 
-	sd->s_symlink.target_sd = target_sd;
+	sd->s_link.target = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt);
@@ -131,7 +130,7 @@ static int sysfs_getlink(struct dentry *dentry, char * path)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent *target_sd = sd->s_symlink.target_sd;
+	struct sysfs_dirent *target_sd = sd->s_link.target;
 	int error;
 
 	mutex_lock(&sysfs_mutex);
@@ -158,7 +157,7 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd, void *co
 		free_page((unsigned long)page);
 }
 
-const struct inode_operations sysfs_symlink_inode_operations = {
+const struct inode_operations sysfs_link_inode_operations = {
 	.readlink = generic_readlink,
 	.follow_link = sysfs_follow_link,
 	.put_link = sysfs_put_link,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index d8c61c5..c5593f9 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -7,8 +7,8 @@ struct sysfs_elem_dir {
 	struct sysfs_dirent	*children;
 };
 
-struct sysfs_elem_symlink {
-	struct sysfs_dirent	*target_sd;
+struct sysfs_elem_link {
+	struct sysfs_dirent	*target;
 };
 
 struct sysfs_elem_file {
@@ -39,10 +39,10 @@ struct sysfs_dirent {
 	const char		*s_name;
 
 	union {
-		struct sysfs_elem_dir		s_dir;
-		struct sysfs_elem_symlink	s_symlink;
-		struct sysfs_elem_file		s_file;
-		struct sysfs_elem_bin		s_bin;
+		struct sysfs_elem_dir	s_dir;
+		struct sysfs_elem_link	s_link;
+		struct sysfs_elem_file	s_file;
+		struct sysfs_elem_bin	s_bin;
 	};
 
 	unsigned int		s_flags;
@@ -57,7 +57,7 @@ struct sysfs_dirent {
 #define SYSFS_DIR			0x0001
 #define SYSFS_FILE			0x0002
 #define SYSFS_BIN			0x0004
-#define SYSFS_KOBJ_LINK			0x0008
+#define SYSFS_LINK			0x0008
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
@@ -156,4 +156,4 @@ extern const struct file_operations sysfs_bin_file_operations;
 /*
  * symlink.c
  */
-extern const struct inode_operations sysfs_symlink_inode_operations;
+extern const struct inode_operations sysfs_link_inode_operations;
-- 
1.5.0.3


