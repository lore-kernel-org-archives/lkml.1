Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbXJLWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbXJLWoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932681AbXJLWVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:49867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXJLWVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/75] sysfs: Simplify readdir.
Date: Fri, 12 Oct 2007 15:16:48 -0700
Message-Id: <11922276471365-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276433594-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

At some point someone wrote sysfs_readdir to insert a cursor
into the list of sysfs_dirents to ensure that sysfs_readdir would
restart properly.  That works but it is complex code and tends
to be expensive.

The same effect can be achieved by keeping the sysfs_dirents in
inode order and using the inode number as the f_pos.  Then
when we restart we just have to find the first dirent whose inode
number is equal or greater then the last sysfs_dirent we attempted
to return.

Removing the sysfs directory cursor also allows the remove of
all of the mysterious checks for sysfs_type(sd) != 0.   Which
were nonbovious checks to see if a cursor was in a directory list.

tj: offset marker for EOF is changed from UINT_MAX to INT_MAX to avoid
    overflow in case offset is 32bit.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |  175 ++++++++++++++------------------------------------------
 1 files changed, 44 insertions(+), 131 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b72b42e..953e843 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -33,10 +33,20 @@ static DEFINE_IDA(sysfs_ino_ida);
 static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd = sd->s_parent;
+	struct sysfs_dirent **pos;
 
 	BUG_ON(sd->s_sibling);
-	sd->s_sibling = parent_sd->s_children;
-	parent_sd->s_children = sd;
+
+	/* Store directory entries in order by ino.  This allows
+	 * readdir to properly restart without having to add a
+	 * cursor into the s_children list.
+	 */
+	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
+		if (sd->s_ino < (*pos)->s_ino)
+			break;
+	}
+	sd->s_sibling = *pos;
+	*pos = sd;
 }
 
 /**
@@ -659,7 +669,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 	struct sysfs_dirent *sd;
 
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
-		if (sysfs_type(sd) && !strcmp(sd->s_name, name))
+		if (!strcmp(sd->s_name, name))
 			return sd;
 	return NULL;
 }
@@ -811,7 +821,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) && sysfs_type(sd) != SYSFS_DIR)
+		if (sysfs_type(sd) != SYSFS_DIR)
 			sysfs_remove_one(&acxt, sd);
 		else
 			pos = &(*pos)->s_sibling;
@@ -976,37 +986,6 @@ again:
 	return error;
 }
 
-static int sysfs_dir_open(struct inode *inode, struct file *file)
-{
-	struct dentry * dentry = file->f_path.dentry;
-	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
-	struct sysfs_dirent * sd;
-
-	sd = sysfs_new_dirent("_DIR_", 0, 0);
-	if (sd) {
-		mutex_lock(&sysfs_mutex);
-		sd->s_parent = sysfs_get(parent_sd);
-		sysfs_link_sibling(sd);
-		mutex_unlock(&sysfs_mutex);
-	}
-
-	file->private_data = sd;
-	return sd ? 0 : -ENOMEM;
-}
-
-static int sysfs_dir_close(struct inode *inode, struct file *file)
-{
-	struct sysfs_dirent * cursor = file->private_data;
-
-	mutex_lock(&sysfs_mutex);
-	sysfs_unlink_sibling(cursor);
-	mutex_unlock(&sysfs_mutex);
-
-	release_sysfs_dirent(cursor);
-
-	return 0;
-}
-
 /* Relationship between s_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct sysfs_dirent *sd)
 {
@@ -1017,117 +996,51 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
-	struct sysfs_dirent *cursor = filp->private_data;
-	struct sysfs_dirent **pos;
+	struct sysfs_dirent *pos;
 	ino_t ino;
-	int i = filp->f_pos;
 
-	switch (i) {
-		case 0:
-			ino = parent_sd->s_ino;
-			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
-				break;
+	if (filp->f_pos == 0) {
+		ino = parent_sd->s_ino;
+		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		case 1:
-			if (parent_sd->s_parent)
-				ino = parent_sd->s_parent->s_ino;
-			else
-				ino = parent_sd->s_ino;
-			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
-				break;
+	}
+	if (filp->f_pos == 1) {
+		if (parent_sd->s_parent)
+			ino = parent_sd->s_parent->s_ino;
+		else
+			ino = parent_sd->s_ino;
+		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		default:
-			mutex_lock(&sysfs_mutex);
-
-			pos = &parent_sd->s_children;
-			while (*pos != cursor)
-				pos = &(*pos)->s_sibling;
-
-			/* unlink cursor */
-			*pos = cursor->s_sibling;
-
-			if (filp->f_pos == 2)
-				pos = &parent_sd->s_children;
-
-			for ( ; *pos; pos = &(*pos)->s_sibling) {
-				struct sysfs_dirent *next = *pos;
-				const char * name;
-				int len;
-
-				if (!sysfs_type(next))
-					continue;
-
-				name = next->s_name;
-				len = strlen(name);
-				ino = next->s_ino;
-
-				if (filldir(dirent, name, len, filp->f_pos, ino,
-						 dt_type(next)) < 0)
-					break;
-
-				filp->f_pos++;
-			}
+	}
+	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
+		mutex_lock(&sysfs_mutex);
 
-			/* put cursor back in */
-			cursor->s_sibling = *pos;
-			*pos = cursor;
+		/* Skip the dentries we have already reported */
+		pos = parent_sd->s_children;
+		while (pos && (filp->f_pos > pos->s_ino))
+			pos = pos->s_sibling;
 
-			mutex_unlock(&sysfs_mutex);
-	}
-	return 0;
-}
+		for ( ; pos; pos = pos->s_sibling) {
+			const char * name;
+			int len;
 
-static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
-{
-	struct dentry * dentry = file->f_path.dentry;
+			name = pos->s_name;
+			len = strlen(name);
+			filp->f_pos = ino = pos->s_ino;
 
-	switch (origin) {
-		case 1:
-			offset += file->f_pos;
-		case 0:
-			if (offset >= 0)
+			if (filldir(dirent, name, len, filp->f_pos, ino,
+					 dt_type(pos)) < 0)
 				break;
-		default:
-			return -EINVAL;
-	}
-	if (offset != file->f_pos) {
-		mutex_lock(&sysfs_mutex);
-
-		file->f_pos = offset;
-		if (file->f_pos >= 2) {
-			struct sysfs_dirent *sd = dentry->d_fsdata;
-			struct sysfs_dirent *cursor = file->private_data;
-			struct sysfs_dirent **pos;
-			loff_t n = file->f_pos - 2;
-
-			sysfs_unlink_sibling(cursor);
-
-			pos = &sd->s_children;
-			while (n && *pos) {
-				struct sysfs_dirent *next = *pos;
-				if (sysfs_type(next))
-					n--;
-				pos = &(*pos)->s_sibling;
-			}
-
-			cursor->s_sibling = *pos;
-			*pos = cursor;
 		}
-
+		if (!pos)
+			filp->f_pos = INT_MAX;
 		mutex_unlock(&sysfs_mutex);
 	}
-
-	return offset;
+	return 0;
 }
 
+
 const struct file_operations sysfs_dir_operations = {
-	.open		= sysfs_dir_open,
-	.release	= sysfs_dir_close,
-	.llseek		= sysfs_dir_lseek,
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 };
-- 
1.5.3.4

