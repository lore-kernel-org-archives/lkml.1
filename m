Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983Ab0CMAVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:07 -0500
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934882Ab0CMAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.895788453@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [patch 054/123] sysfs: Cache the last sysfs_dirent to improve readdir scalability v2
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit 1e5289c97bba2d8ee7239a416bc3f28743362cd9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c |   82 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 22 deletions(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -837,11 +837,46 @@ static inline unsigned char dt_type(stru
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
@@ -857,29 +892,31 @@ static int sysfs_readdir(struct file * f
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
-		mutex_lock(&sysfs_mutex);
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
-
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
@@ -888,5 +925,6 @@ static int sysfs_readdir(struct file * f
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
+	.release	= sysfs_dir_release,
 	.llseek		= generic_file_llseek,
 };


