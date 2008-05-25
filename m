Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYEYSE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYEYSE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYEYSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:03:55 -0400
Received: from atflat.net ([80.229.16.180]:43721 "EHLO holly.atflat.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756578AbYEYSDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:03:53 -0400
From: Tom Spink <tspink@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Spink <tspink@gmail.com>
Subject: [RFC PATCH 1/2] vfs: Introduce on-demand filesystem initialisation
Date: Sun, 25 May 2008 18:48:18 +0100
Message-Id: <1211737699-25615-2-git-send-email-tspink@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1211737699-25615-1-git-send-email-tspink@gmail.com>
References: <>
 <1211737699-25615-1-git-send-email-tspink@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds on-demand filesystem initialisation capabilities to the VFS,
whereby an init routine will be executed on first use of a particular
filesystem type.  Also, an exit routine will be executed when the last
superblock of a filesystem type is deactivated.

This is useful for filesystems that share global resources between all
instances of the filesystem, but only need those resources when there are
any users of the filesystem.  This lets the filesystem initialise those
resources (kernel threads or caches, say) when the first superblock is
created.  It also lets the filesystem clean up those resources when the
last superblock is deactivated.

Signed-off-by: Tom Spink <tspink@gmail.com>
---
 fs/filesystems.c   |    2 ++
 fs/super.c         |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h |    3 +++
 3 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..59b2eaa 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -79,6 +79,7 @@ int register_filesystem(struct file_system_type * fs)
 		res = -EBUSY;
 	else
 		*p = fs;
+	mutex_init(&fs->fs_supers_lock);
 	write_unlock(&file_systems_lock);
 	return res;
 }
@@ -105,6 +106,7 @@ int unregister_filesystem(struct file_system_type * fs)
 	tmp = &file_systems;
 	while (*tmp) {
 		if (fs == *tmp) {
+			mutex_destroy(&fs->fs_supers_lock);
 			*tmp = fs->next;
 			fs->next = NULL;
 			write_unlock(&file_systems_lock);
diff --git a/fs/super.c b/fs/super.c
index 453877c..af20175 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -181,7 +181,21 @@ void deactivate_super(struct super_block *s)
 		spin_unlock(&sb_lock);
 		DQUOT_OFF(s, 0);
 		down_write(&s->s_umount);
+
+		/* Take the mutex before calling kill_sb, because it may
+		 * modify the fs_supers list.
+		 */
+		mutex_lock(&fs->fs_supers_lock);
 		fs->kill_sb(s);
+
+		/* Check to see if this is the last superblock of the
+		 * filesystem going down, and if it is, then run the exit
+		 * routine.
+		 */
+		if (list_empty(&fs->fs_supers) && fs->exit)
+			fs->exit();
+		mutex_unlock(&fs->fs_supers_lock);
+
 		put_filesystem(fs);
 		put_super(s);
 	}
@@ -338,6 +352,7 @@ struct super_block *sget(struct file_system_type *type,
 	struct super_block *old;
 	int err;
 
+	mutex_lock(&type->fs_supers_lock);
 retry:
 	spin_lock(&sb_lock);
 	if (test) {
@@ -348,14 +363,17 @@ retry:
 				goto retry;
 			if (s)
 				destroy_super(s);
+			mutex_unlock(&type->fs_supers_lock);
 			return old;
 		}
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
 		s = alloc_super(type);
-		if (!s)
+		if (!s) {
+			mutex_unlock(&type->fs_supers_lock);
 			return ERR_PTR(-ENOMEM);
+		}
 		goto retry;
 	}
 		
@@ -363,14 +381,41 @@ retry:
 	if (err) {
 		spin_unlock(&sb_lock);
 		destroy_super(s);
+		mutex_unlock(&type->fs_supers_lock);
 		return ERR_PTR(err);
 	}
+
+	/* If this is the first superblock of this particular filesystem,
+	 * run the init routine, if any.  If we're going to do this, then we
+	 * also need to drop the sb_lock spinlock.
+	 */
+	if (list_empty(&type->fs_supers) && type->init) {
+		spin_unlock(&sb_lock);
+
+		/* We can do this, because we're holding the fs_supers_lock
+		 * mutex.
+		 */
+		err = type->init();
+		if (err < 0) {
+			/* If the filesystem failed to initialise, then back
+			 * out, destroy the superblock and return the error.
+			 */
+			destroy_super(s);
+			mutex_unlock(&type->fs_supers_lock);
+			return ERR_PTR(err);
+		}
+
+		spin_lock(&sb_lock);
+	}
+
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
 	list_add(&s->s_instances, &type->fs_supers);
 	spin_unlock(&sb_lock);
 	get_filesystem(type);
+
+	mutex_unlock(&type->fs_supers_lock);
 	return s;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f413085..92d446f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,8 +1477,11 @@ struct file_system_type {
 	int (*get_sb) (struct file_system_type *, int,
 		       const char *, void *, struct vfsmount *);
 	void (*kill_sb) (struct super_block *);
+	int (*init) (void);
+	void (*exit) (void);
 	struct module *owner;
 	struct file_system_type * next;
+	struct mutex fs_supers_lock;
 	struct list_head fs_supers;
 
 	struct lock_class_key s_lock_key;
-- 
1.5.4.3

