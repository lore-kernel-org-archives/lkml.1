Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZLCFxe (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 3 Dec 2009 00:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZLCFxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:53:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZLCFxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:53:30 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/5] fsnotify: Infrastructure for per-mount watches
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        eparis@redhat.com
Date: Thu, 03 Dec 2009 00:53:28 -0500
Message-ID: <20091203055328.21918.26026.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Per-mount watches allow groups to listen to fsnotify events on an entire
mount.  This patch simply adds and initializes the fields needed in the
vfsmount struct to make this happen.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/namespace.c                   |    1 +
 fs/notify/fsnotify.c             |    5 +++++
 fs/notify/fsnotify.h             |    2 ++
 include/linux/fsnotify.h         |    8 ++++++++
 include/linux/fsnotify_backend.h |    4 ++++
 5 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2bff3b1..356d6cf 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -614,6 +614,7 @@ static inline void __mntput(struct vfsmount *mnt)
 	 * provides barriers, so count_mnt_writers() below is safe.  AV
 	 */
 	WARN_ON(count_mnt_writers(mnt));
+	fsnotify_vfsmount_delete(mnt);
 	dput(mnt->mnt_root);
 	free_vfsmnt(mnt);
 	deactivate_super(sb);
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 8ed9fb5..990929b 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -35,6 +35,11 @@ void __fsnotify_inode_delete(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
 
+void __fsnotify_vfsmount_delete(struct vfsmount *mnt)
+{
+	fsnotify_clear_marks_by_mount(mnt);
+}
+
 /*
  * Given an inode, first check if we care what happens to our children.  Inotify
  * and dnotify both tell their parents about events.  If we care about any event
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 38f3fb5..204353c 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -42,6 +42,8 @@ extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
 extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
+/* run the list of all marks associated with vfsmount and flag them to be freed */
+extern void fsnotify_clear_marks_by_mount(struct vfsmount *mnt);
 /*
  * update the dentry->d_flags of all of inode's children to indicate if inode cares
  * about events that happen to its children.
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index cc4dead..4d76d41 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -118,6 +118,14 @@ static inline void fsnotify_inode_delete(struct inode *inode)
 }
 
 /*
+ * fsnotify_vfsmount_delete - a vfsmount is being destroyed, clean up is needed
+ */
+static inline void fsnotify_vfsmount_delete(struct vfsmount *mnt)
+{
+	__fsnotify_vfsmount_delete(mnt);
+}
+
+/*
  * fsnotify_nameremove - a filename was removed from a directory
  */
 static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index f21ff1b..1af42cb 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -282,6 +282,7 @@ extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 		     const char *name, u32 cookie);
 extern void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
+extern void __fsnotify_vfsmount_delete(struct vfsmount *mnt);
 extern u32 fsnotify_get_cookie(void);
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
@@ -402,6 +403,9 @@ static inline void __fsnotify_parent(struct path *path, struct dentry *dentry, _
 static inline void __fsnotify_inode_delete(struct inode *inode)
 {}
 
+static inline void __fsnotify_vfsmount_delete(struct vfsmount *mnt)
+{}
+
 static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 {}
 

