Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZJ0TJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZJ0TJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZJ0TJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZJ0TJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:09:53 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/6] fsnotify: kill FSNOTIFY_EVENT_FILE
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:09:53 -0400
Message-ID: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fsnotify operations send a struct file.  This is more information than
we technically need.  We instead send a struct path in all cases instead of
sometimes a path and sometimes a file.

Sigend-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |   12 +++++-------
 fs/notify/notification.c         |    9 ---------
 include/linux/fsnotify.h         |   36 +++++++++++++++++++-----------------
 include/linux/fsnotify_backend.h |    5 ++---
 4 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 5d1d2ed..b076b06 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -78,15 +78,15 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 }
 
 /* Notify this dentry's parent about a child's events. */
-void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
+void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {
 	struct dentry *parent;
 	struct inode *p_inode;
 	bool send = false;
 	bool should_update_children = false;
 
-	if (file)
-		dentry = file->f_path.dentry;
+	if (!dentry)
+		dentry = path->dentry;
 
 	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
 		return;
@@ -118,8 +118,8 @@ void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
 		 * specifies these are events which came from a child. */
 		mask |= FS_EVENT_ON_CHILD;
 
-		if (file)
-			fsnotify(p_inode, mask, file, FSNOTIFY_EVENT_FILE,
+		if (path)
+			fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
 				 dentry->d_name.name, 0);
 		else
 			fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
@@ -193,8 +193,6 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
  
 	if (data_is == FSNOTIFY_EVENT_PATH)
 		mnt = ((struct path *)data)->mnt;
-	else if (data_is == FSNOTIFY_EVENT_FILE)
-		mnt = ((struct file *)data)->f_path.mnt;
 
 	/* if this inode's directed listeners don't care and nothing on the vfsmount
 	 * listeners list cares, nothing to do */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index dafd0b7..066f1f9 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -390,15 +390,6 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 	event->data_type = data_type;
 
 	switch (data_type) {
-	case FSNOTIFY_EVENT_FILE: {
-		struct file *file = data;
-		struct path *path = &file->f_path;
-		event->path.dentry = path->dentry;
-		event->path.mnt = path->mnt;
-		path_get(&event->path);
-		event->data_type = FSNOTIFY_EVENT_PATH;
-		break;
-	}
 	case FSNOTIFY_EVENT_PATH: {
 		struct path *path = data;
 		event->path.dentry = path->dentry;
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index c0de28b..2d032b9 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -29,14 +29,12 @@ static inline void fsnotify_d_instantiate(struct dentry *entry,
 }
 
 /* Notify this dentry's parent about a child's events. */
-static inline void fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
+static inline void fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {
-	BUG_ON(file && dentry);
+	if (!dentry)
+		dentry = path->dentry;
 
-	if (file)
-		dentry = file->f_path.dentry;
-
-	__fsnotify_parent(file, dentry, mask);
+	__fsnotify_parent(path, dentry, mask);
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 }
@@ -190,7 +188,8 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_access(struct file *file)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct path *path = &file->f_path;
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
@@ -198,8 +197,8 @@ static inline void fsnotify_access(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(file, NULL, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
@@ -207,7 +206,8 @@ static inline void fsnotify_access(struct file *file)
  */
 static inline void fsnotify_modify(struct file *file)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct path *path = &file->f_path;
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
@@ -215,8 +215,8 @@ static inline void fsnotify_modify(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(file, NULL, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
@@ -224,7 +224,8 @@ static inline void fsnotify_modify(struct file *file)
  */
 static inline void fsnotify_open(struct file *file)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct path *path = &file->f_path;
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -232,8 +233,8 @@ static inline void fsnotify_open(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(file, NULL, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
@@ -241,6 +242,7 @@ static inline void fsnotify_open(struct file *file)
  */
 static inline void fsnotify_close(struct file *file)
 {
+	struct path *path = &file->f_path;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
@@ -250,8 +252,8 @@ static inline void fsnotify_close(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(file, NULL, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index cf16585..7a6ba75 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -214,7 +214,6 @@ struct fsnotify_event {
 #define FSNOTIFY_EVENT_NONE	0
 #define FSNOTIFY_EVENT_PATH	1
 #define FSNOTIFY_EVENT_INODE	2
-#define FSNOTIFY_EVENT_FILE	3
 	int data_type;		/* which of the above union we have */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
@@ -280,7 +279,7 @@ struct fsnotify_mark_entry {
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 		     const char *name, u32 cookie);
-extern void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask);
+extern void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
 extern u32 fsnotify_get_cookie(void);
 
@@ -393,7 +392,7 @@ static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int d
 			    const char *name, u32 cookie)
 {}
 
-static inline void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
+static inline void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)

