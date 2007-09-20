Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbXITHJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbXITHJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbXITHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:43226 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXITHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=bhnl94Tf5P4kplOD1vnEas9MqoYB7rweO/LRjWKpYM9dSxe6MOs/vj7wMu2Qg9+Sxt4/R28VVOUSWzn5slGo7S1lSJUFFMHT29SnJSXdmEi69iwumgjISNUw7iJmFbzjtS1JE5eS/bBEuwXh5vBq+ZFajZYjFx7YFi4+fwWUzbA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 12/15] sysfs: make sysfs_root a regular directory dirent
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:12 +0900
Message-Id: <11902719122289-git-send-email-htejun@gmail.com>
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

sysfs_root is different from a regular directory dirent in that it's
of type SYSFS_ROOT and doesn't have a name.  These differences aren't
used by anybody and only adds to complexity.  Make sysfs_root a
regular directory dirent.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/inode.c |    5 -----
 fs/sysfs/mount.c |    3 ++-
 fs/sysfs/sysfs.h |    9 ++++-----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index b6ac4e6..c40fb9f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -157,11 +157,6 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 	/* initialize inode according to type */
 	switch (sysfs_type(sd)) {
-	case SYSFS_ROOT:
-		inode->i_op = &sysfs_dir_inode_operations;
-		inode->i_fop = &sysfs_dir_operations;
-		inc_nlink(inode); /* directory, account for "." */
-		break;
 	case SYSFS_DIR:
 		inode->i_op = &sysfs_dir_inode_operations;
 		inode->i_fop = &sysfs_dir_operations;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 28bf359..465902c 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -24,8 +24,9 @@ static const struct super_operations sysfs_ops = {
 };
 
 struct sysfs_dirent sysfs_root = {
+	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
-	.s_flags	= SYSFS_ROOT,
+	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
 };
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2a68bfa..60405a6 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -48,11 +48,10 @@ struct sysfs_dirent {
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
 #define SYSFS_TYPE_MASK			0x00ff
-#define SYSFS_ROOT			0x0001
-#define SYSFS_DIR			0x0002
-#define SYSFS_KOBJ_ATTR			0x0004
-#define SYSFS_KOBJ_BIN_ATTR		0x0008
-#define SYSFS_KOBJ_LINK			0x0020
+#define SYSFS_DIR			0x0001
+#define SYSFS_KOBJ_ATTR			0x0002
+#define SYSFS_KOBJ_BIN_ATTR		0x0004
+#define SYSFS_KOBJ_LINK			0x0008
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
-- 
1.5.0.3


