Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbXITHKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbXITHKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbXITHFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbXITHFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=a7y8R0AP4FdW9S15eJEy0gj/5lbRvy8k9wQN/QCmMEAWJaatWtBeMOxvk0162+dU21NSX7rRLOdHIDabK8SQs6bTwAQiwYXP8m0wmbq1dLsKU/yiZrgNC4MKWvf+z8RvCctdJ6q3oonq6JQNJieQBrJxZAjeaHH4Sg9WElwtwQ8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 13/15] sysfs: move sysfs_dirent->s_children into sysfs_dirent->s_dir
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:12 +0900
Message-Id: <11902719123828-git-send-email-htejun@gmail.com>
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

Children list head is only meaninful for directory nodes.  Move it
into s_dir.  This doesn't save any space currently but it will with
further changes.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   17 +++++++++--------
 fs/sysfs/inode.c |    2 +-
 fs/sysfs/sysfs.h |    3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7500407..b81744b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -26,7 +26,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	@sd: sysfs_dirent of interest
  *
  *	Link @sd into its sibling list which starts from
- *	sd->s_parent->s_children.
+ *	sd->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -40,9 +40,9 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
 
 	/* Store directory entries in order by ino.  This allows
 	 * readdir to properly restart without having to add a
-	 * cursor into the s_children list.
+	 * cursor into the s_dir.children list.
 	 */
-	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
+	for (pos = &parent_sd->s_dir.children; *pos; pos = &(*pos)->s_sibling) {
 		if (sd->s_ino < (*pos)->s_ino)
 			break;
 	}
@@ -55,7 +55,7 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
  *	@sd: sysfs_dirent of interest
  *
  *	Unlink @sd from its sibling list which starts from
- *	sd->s_parent->s_children.
+ *	sd->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -64,7 +64,8 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent **pos;
 
-	for (pos = &sd->s_parent->s_children; *pos; pos = &(*pos)->s_sibling) {
+	for (pos = &sd->s_parent->s_dir.children; *pos;
+	     pos = &(*pos)->s_sibling) {
 		if (*pos == sd) {
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
@@ -566,7 +567,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 {
 	struct sysfs_dirent *sd;
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling)
 		if (!strcmp(sd->s_name, name))
 			return sd;
 	return NULL;
@@ -718,7 +719,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_children;
+	pos = &dir_sd->s_dir.children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
@@ -918,7 +919,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		mutex_lock(&sysfs_mutex);
 
 		/* Skip the dentries we have already reported */
-		pos = parent_sd->s_children;
+		pos = parent_sd->s_dir.children;
 		while (pos && (filp->f_pos > pos->s_ino))
 			pos = pos->s_sibling;
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index c40fb9f..2210cf0 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -127,7 +127,7 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 	struct sysfs_dirent *child;
 	int nr = 0;
 
-	for (child = sd->s_children; child; child = child->s_sibling)
+	for (child = sd->s_dir.children; child; child = child->s_sibling)
 		if (sysfs_type(child) == SYSFS_DIR)
 			nr++;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 60405a6..42b0327 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,6 +1,8 @@
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
+	/* children list starts here and goes through sd->s_sibling */
+	struct sysfs_dirent	*children;
 };
 
 struct sysfs_elem_symlink {
@@ -28,7 +30,6 @@ struct sysfs_dirent {
 	atomic_t		s_active;
 	struct sysfs_dirent	*s_parent;
 	struct sysfs_dirent	*s_sibling;
-	struct sysfs_dirent	*s_children;
 	const char		*s_name;
 
 	union {
-- 
1.5.0.3


