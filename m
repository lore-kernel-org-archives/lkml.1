Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZD0V54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZD0V54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZD0VzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:55:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41460 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811AbZD0VzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:55:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 08/12] fsnotify: add correlations between events
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Mon, 27 Apr 2009 17:53:44 -0400
Message-ID: <20090427215344.14161.81966.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the standard inotify events it includes a correlation cookie
between two dentry move operations.  This patch includes the same behaviour
in fsnotify events.  It is needed so that inotify userspace can be
implemented on top of fsnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |    6 +++---
 fs/notify/notification.c         |   20 ++++++++++++++++++--
 include/linux/fsnotify.h         |   37 +++++++++++++++++++------------------
 include/linux/fsnotify_backend.h |   15 ++++++++++++---
 4 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index d73f9de..b453364 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -115,7 +115,7 @@ void __fsnotify_parent(struct dentry *dentry, __u32 mask)
 		mask |= FS_EVENT_ON_CHILD;
 
 		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
-			 dentry->d_name.name);
+			 dentry->d_name.name, 0);
 		dput(parent);
 	}
 
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(__fsnotify_parent);
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  */
-void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name)
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name, u32 cookie)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -157,7 +157,7 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name, cookie);
 				/* shit, we OOM'd and now we can't tell, maybe
 				 * someday someone else will want to do something
 				 * here */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index c69b18b..346f6e5 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/namei.h>
@@ -56,6 +57,17 @@ static struct kmem_cache *fsnotify_event_holder_cachep;
  * get set to 0 so it will never get 'freed'
  */
 static struct fsnotify_event q_overflow_event;
+static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+
+/**
+ * fsnotify_get_cookie - return a unique cookie for use in synchronizing events.
+ * Called from fsnotify_move, which is inlined into filesystem modules.
+ */
+u32 fsnotify_get_cookie(void)
+{
+	return atomic_inc_return(&fsnotify_sync_cookie);
+}
+EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
@@ -266,6 +278,8 @@ static void initialize_event(struct fsnotify_event *event)
 
 	event->file_name = NULL;
 	event->name_len = 0;
+
+	event->sync_cookie = 0;
 }
 
 /*
@@ -280,8 +294,8 @@ static void initialize_event(struct fsnotify_event *event)
  * @data_type flag indication if the data is a file, path, inode, nothing...
  * @name the filename, if available
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-					     void *data, int data_type, const char *name)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
+					     int data_type, const char *name, u32 cookie)
 {
 	struct fsnotify_event *event;
 
@@ -299,6 +313,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 		}
 		event->name_len = strlen(event->file_name);
 	}
+
+	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
 
 	switch (data_type) {
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 883ead4..bdf626b 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -58,7 +58,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -69,7 +69,7 @@ static inline void fsnotify_inode_remove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	__fsnotify_inode_delete(inode);
 }
 
@@ -81,7 +81,8 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	u32 in_cookie = inotify_get_cookie();
+	u32 fs_cookie = fsnotify_get_cookie();
 	__u32 old_dir_mask = 0;
 	__u32 new_dir_mask = 0;
 
@@ -98,13 +99,13 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	old_dir_mask |= FS_MOVED_FROM;
 	new_dir_mask |= FS_MOVED_TO;
 
-	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
+	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir, in_cookie, old_name,
 				  source);
-	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
+	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, in_cookie, new_name,
 				  source);
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
 
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
@@ -116,7 +117,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -150,7 +151,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -162,7 +163,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -177,7 +178,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
 
 /*
@@ -191,7 +192,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -208,7 +209,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -225,7 +226,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -242,7 +243,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -261,7 +262,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -278,7 +279,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -314,7 +315,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 52692f4..b78b557 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -193,6 +193,7 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
 
+	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
 };
@@ -227,9 +228,11 @@ struct fsnotify_mark_entry {
 /* called from the vfs helpers */
 
 /* main fsnotify call to send events */
-extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
+		     const char *name, u32 cookie);
 extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
+extern u32 fsnotify_get_cookie(void);
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
 {
@@ -322,12 +325,13 @@ extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-						    void *data, int data_is, const char *name);
+						    void *data, int data_is, const char *name,
+						    u32 cookie);
 
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
-			    const char *name);
+			    const char *name, u32 cookie)
 {}
 
 static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
@@ -342,6 +346,11 @@ static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {}
 
+static inline u32 fsnotify_get_cookie(void)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

