Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZHKQbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZHKQbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZHKQbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:31:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbZHKQa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:28 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/8] fsnotify: send struct file when sending events to parents
	when possible
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:28 -0400
Message-ID: <20090811163028.8648.45490.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify needs a path in order to open an fd to the object which changed.
Currently notifications to inode's parents are done using only the inode.
For some parental notification we have the entire file, send that so
fanotify can use it.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |   13 ++++++++++---
 include/linux/fsnotify.h         |   35 ++++++++++++++++++-----------------
 include/linux/fsnotify_backend.h |    4 ++--
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index b98be4a..d4b0272 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -77,13 +77,16 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 }
 
 /* Notify this dentry's parent about a child's events. */
-void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
 {
 	struct dentry *parent;
 	struct inode *p_inode;
 	bool send = false;
 	bool should_update_children = false;
 
+	if (file)
+		dentry = file->f_path.dentry;
+
 	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
 		return;
 
@@ -114,8 +117,12 @@ void __fsnotify_parent(struct dentry *dentry, __u32 mask)
 		 * specifies these are events which came from a child. */
 		mask |= FS_EVENT_ON_CHILD;
 
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
-			 dentry->d_name.name, 0);
+		if (file)
+			fsnotify(p_inode, mask, file, FSNOTIFY_EVENT_FILE,
+				 dentry->d_name.name, 0);
+		else
+			fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
+				 dentry->d_name.name, 0);
 		dput(parent);
 	}
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 36357a4..c0de28b 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -29,9 +29,14 @@ static inline void fsnotify_d_instantiate(struct dentry *entry,
 }
 
 /* Notify this dentry's parent about a child's events. */
-static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
+static inline void fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
 {
-	__fsnotify_parent(dentry, mask);
+	BUG_ON(file && dentry);
+
+	if (file)
+		dentry = file->f_path.dentry;
+
+	__fsnotify_parent(file, dentry, mask);
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 }
@@ -124,7 +129,7 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 	if (isdir)
 		mask |= FS_IN_ISDIR;
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(NULL, dentry, mask);
 }
 
 /*
@@ -185,8 +190,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_access(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
@@ -194,7 +198,7 @@ static inline void fsnotify_access(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(file, NULL, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
@@ -203,8 +207,7 @@ static inline void fsnotify_access(struct file *file)
  */
 static inline void fsnotify_modify(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
@@ -212,7 +215,7 @@ static inline void fsnotify_modify(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(file, NULL, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
@@ -221,8 +224,7 @@ static inline void fsnotify_modify(struct file *file)
  */
 static inline void fsnotify_open(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -230,7 +232,7 @@ static inline void fsnotify_open(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(file, NULL, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
@@ -239,8 +241,7 @@ static inline void fsnotify_open(struct file *file)
  */
 static inline void fsnotify_close(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
@@ -249,7 +250,7 @@ static inline void fsnotify_close(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(file, NULL, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
@@ -266,7 +267,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(dentry, mask);
+	fsnotify_parent(NULL, dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
@@ -302,7 +303,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 			mask |= FS_IN_ISDIR;
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-		fsnotify_parent(dentry, mask);
+		fsnotify_parent(NULL, dentry, mask);
 		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 2766df6..0e0c2b7 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -259,7 +259,7 @@ struct fsnotify_mark_entry {
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 		     const char *name, u32 cookie);
-extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
+extern void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
 extern u32 fsnotify_get_cookie(void);
 
@@ -367,7 +367,7 @@ static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int d
 			    const char *name, u32 cookie)
 {}
 
-static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+static inline void __fsnotify_parent(struct file *file, struct dentry *dentry, __u32 mask)
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)

