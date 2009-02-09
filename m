Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZBIVTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZBIVTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZBIVQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZBIVQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:55 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 08/11] fsnotify: add correlations between events
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:16:04 -0500
Message-ID: <20090209211604.8985.9728.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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
 fs/notify/fsnotify.h             |    2 +-
 fs/notify/notification.c         |   14 +++++++++++++-
 include/linux/fsnotify.h         |   39 +++++++++++++++++++-------------------
 include/linux/fsnotify_backend.h |   11 +++++++++--
 5 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 2aa437b..8b816c0 100644
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
index 72e163e..b384fa8 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -17,7 +17,7 @@ extern __u64 fsnotify_mask;
 
 extern void fsnotify_flush_notif(struct fsnotify_group *group);
 
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 21a8b03..a636a1f 100644
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
@@ -35,6 +36,13 @@
 static struct kmem_cache *event_kmem_cache;
 static struct kmem_cache *event_holder_kmem_cache;
 static struct fsnotify_event q_overflow_event;
+static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
+
+u32 fsnotify_get_cookie(void)
+{
+	return atomic_inc_return(&fsnotify_sync_cookie);
+}
+EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 
 /* return 1 if something is available, return 0 otherwise */
 int fsnotify_check_notif_queue(struct fsnotify_group *group)
@@ -252,9 +260,11 @@ static void initialize_event(struct fsnotify_event *event)
 
 	event->file_name = NULL;
 	event->name_len = 0;
+
+	event->sync_cookie = 0;
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie)
 {
 	struct fsnotify_event *event;
 
@@ -272,6 +282,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 		}
 		event->name_len = strlen(event->file_name);
 	}
+
+	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
 
 	switch (data_is) {
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 3081d86..bdbc897 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -107,7 +107,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
 	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 		dput(parent);
 	} else {
 		spin_unlock(&dentry->d_lock);
@@ -139,7 +139,8 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	u32 in_cookie = inotify_get_cookie();
+	u32 fs_cookie = fsnotify_get_cookie();
 	__u64 old_dir_mask = 0;
 	__u64 new_dir_mask = 0;
 
@@ -156,23 +157,23 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
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
@@ -205,7 +206,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	__fsnotify_inode_delete(inode, FSNOTIFY_LAST_DENTRY);
 }
 
@@ -216,7 +217,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -228,7 +229,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -243,7 +244,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
 
 /*
@@ -255,7 +256,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -273,7 +274,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -291,7 +292,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -309,7 +310,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -330,7 +331,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -348,7 +349,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -386,7 +387,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b86b4ef..c86795d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -168,6 +168,7 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u64 mask;		/* the type of access */
 
+	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
 
@@ -201,8 +202,9 @@ struct fsnotify_mark_entry {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
+extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name, u32 cookie);
 extern void __fsnotify_inode_delete(struct inode *inode, int flag);
+extern u32 fsnotify_get_cookie(void);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
 extern void fsnotify_recalc_global_mask(void);
@@ -229,12 +231,17 @@ extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
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

