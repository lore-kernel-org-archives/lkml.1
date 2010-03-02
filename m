Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0CBX4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:56:05 -0500
Received: from kroah.org ([198.145.64.141]:38547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab0CBX3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/62] sysfs: Cache the last sysfs_dirent to improve readdir scalability v2
Date: Tue,  2 Mar 2010 15:28:21 -0800
Message-Id: <1267572541-410-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When sysfs_readdir stops short we now cache the next
sysfs_dirent to return to user space in filp->private_data.
There is no impact on the rest of sysfs by doing this and
in the common case it allows us to pick up exactly where
we left off with no seeking.

Additionally I drop and regrab the sysfs_mutex around
filldir to avoid a page fault abritrarily increasing the
hold time on the sysfs_mutex.

v2: Returned to using INT_MAX as the EOF condition.
    seekdir is ambiguous unless all directory entries have
    a unique f_pos value.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14949

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   82 +++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 699f371..5c4703d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -837,11 +837,46 @@ static inline unsigned char dt_type(struct sysfs_dirent *sd)
 	return (sd->s_mode >> 12) & 15;
 }
 
+static int sysfs_dir_release(struct inode *inode, struct file *filp)
+{
+	sysfs_put(filp->private_data);
+	return 0;
+}
+
+static struct sysfs_dirent *sysfs_dir_pos(struct sysfs_dirent *parent_sd,
+	ino_t ino, struct sysfs_dirent *pos)
+{
+	if (pos) {
+		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
+			pos->s_parent == parent_sd &&
+			ino == pos->s_ino;
+		sysfs_put(pos);
+		if (valid)
+			return pos;
+	}
+	pos = NULL;
+	if ((ino > 1) && (ino < INT_MAX)) {
+		pos = parent_sd->s_dir.children;
+		while (pos && (ino > pos->s_ino))
+			pos = pos->s_sibling;
+	}
+	return pos;
+}
+
+static struct sysfs_dirent *sysfs_dir_next_pos(struct sysfs_dirent *parent_sd,
+	ino_t ino, struct sysfs_dirent *pos)
+{
+	pos = sysfs_dir_pos(parent_sd, ino, pos);
+	if (pos)
+		pos = pos->s_sibling;
+	return pos;
+}
+
 static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
-	struct sysfs_dirent *pos;
+	struct sysfs_dirent *pos = filp->private_data;
 	ino_t ino;
 
 	if (filp->f_pos == 0) {
@@ -857,29 +892,31 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
-		mutex_lock(&sysfs_mutex);
-
-		/* Skip the dentries we have already reported */
-		pos = parent_sd->s_dir.children;
-		while (pos && (filp->f_pos > pos->s_ino))
-			pos = pos->s_sibling;
-
-		for ( ; pos; pos = pos->s_sibling) {
-			const char * name;
-			int len;
-
-			name = pos->s_name;
-			len = strlen(name);
-			filp->f_pos = ino = pos->s_ino;
+	mutex_lock(&sysfs_mutex);
+	for (pos = sysfs_dir_pos(parent_sd, filp->f_pos, pos);
+	     pos;
+	     pos = sysfs_dir_next_pos(parent_sd, filp->f_pos, pos)) {
+		const char * name;
+		unsigned int type;
+		int len, ret;
+
+		name = pos->s_name;
+		len = strlen(name);
+		ino = pos->s_ino;
+		type = dt_type(pos);
+		filp->f_pos = ino;
+		filp->private_data = sysfs_get(pos);
 
-			if (filldir(dirent, name, len, filp->f_pos, ino,
-					 dt_type(pos)) < 0)
-				break;
-		}
-		if (!pos)
-			filp->f_pos = INT_MAX;
 		mutex_unlock(&sysfs_mutex);
+		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		mutex_lock(&sysfs_mutex);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&sysfs_mutex);
+	if ((filp->f_pos > 1) && !pos) { /* EOF */
+		filp->f_pos = INT_MAX;
+		filp->private_data = NULL;
 	}
 	return 0;
 }
@@ -888,5 +925,6 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
+	.release	= sysfs_dir_release,
 	.llseek		= generic_file_llseek,
 };
-- 
1.7.0.1

