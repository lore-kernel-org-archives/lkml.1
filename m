Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYLLV4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYLLV4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYLLVwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbYLLVwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:32 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 12/14] fsnotify: add correlations between events
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:17 -0500
Message-ID: <20081212215217.27112.75137.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify sends userspace a correlation between events when they are related
(aka when dentries are moved).  This adds that same support for all
fsnotify events.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |    4 ++--
 fs/notify/fsnotify.h             |    3 ++-
 fs/notify/notification.c         |   12 ++++++++++-
 include/linux/fsnotify.h         |   41 +++++++++++++++++++-------------------
 include/linux/fsnotify_backend.h |   10 +++++++--
 5 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index c48dcf6..f6973a8 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -34,7 +34,7 @@ void __fsnotify_inode_delete(struct inode *inode, int flag)
 }
 EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
 
-void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *file_name)
+void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *file_name, u32 cookie)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -66,7 +66,7 @@ void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name, cookie);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
 				if (!event)
 					break;
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 89677ee..cb143bf 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -57,6 +57,7 @@ struct fsnotify_event {
 	__u64 mask;	/* the type of access */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 
+	u32 sync_cookie;
 	char *file_name;
 	size_t name_len;
 
@@ -102,7 +103,7 @@ extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
 
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 8ed9d32..7243b20 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/namei.h>
@@ -34,6 +35,13 @@
 
 static struct kmem_cache *event_kmem_cache;
 static struct kmem_cache *event_holder_kmem_cache;
+static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+
+u32 fsnotify_get_cookie(void)
+{
+        return atomic_inc_return(&fsnotify_sync_cookie);
+}
+EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
 int fsnotify_check_notif_queue(struct fsnotify_group *group)
 {
@@ -197,7 +205,7 @@ void fsnotify_flush_notif(struct fsnotify_group *group)
 	mutex_unlock(&group->notification_mutex);
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie)
 {
 	struct fsnotify_event *event;
 
@@ -217,6 +225,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 		event->name_len = 0;
 	}
 
+	event->sync_cookie = cookie;
+
 	event->holder.event = NULL;
 	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 8f4caf8..c1a7b61 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -98,7 +98,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
 	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 		dput(parent);
 	} else {
 		spin_unlock(&dentry->d_lock);
@@ -130,7 +130,8 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	u32 in_cookie = inotify_get_cookie();
+	u32 fs_cookie = fsnotify_get_cookie();
 	__u64 old_dir_mask = 0;
 	__u64 new_dir_mask = 0;
 
@@ -147,23 +148,23 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	old_dir_mask |= FS_MOVED_FROM;
 	new_dir_mask |= FS_MOVED_TO;
 
-	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
+	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,in_cookie,old_name,
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
 		inotify_inode_is_dead(target);
-		fsnotify(target, FS_DELETE, target, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(target, FS_DELETE, target, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -196,7 +197,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	__fsnotify_inode_delete(inode, FSNOTIFY_LAST_DENTRY);
 }
 
@@ -207,7 +208,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -219,7 +220,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -234,7 +235,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
 
 /*
@@ -246,7 +247,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -265,7 +266,7 @@ static inline void fsnotify_access(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -284,7 +285,7 @@ static inline void fsnotify_modify(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -299,7 +300,7 @@ static inline void fsnotify_open_exec(struct file *file)
 	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, FS_ACCESS);
-	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -318,7 +319,7 @@ static inline void fsnotify_open(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -339,7 +340,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -357,7 +358,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -395,7 +396,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index cf24ff1..a068b80 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -118,8 +118,9 @@ struct fsnotify_group {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
+extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie);
 extern void __fsnotify_inode_delete(struct inode *inode, int flag);
+extern u32 fsnotify_get_cookie(void);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
@@ -133,12 +134,17 @@ extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_grou
 extern struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, __u64 mask);
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
+static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie);
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode, int flag)
 {}
 
+static inline u32 fsnotify_get_cookie(void)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

