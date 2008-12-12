Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYLLVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYLLVzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLLVwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYLLVw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:29 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 11/14] fsnotify: include pathnames with entries when
	possible
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:12 -0500
Message-ID: <20081212215212.27112.73418.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inotify wants to send events to a directory about a child it includes
the name of the original file.  This patch collects that filename and makes
it available for notification.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |    4 ++--
 fs/notify/fsnotify.h             |    9 ++++++---
 fs/notify/notification.c         |   19 ++++++++++++++++++-
 include/linux/fsnotify.h         |   34 +++++++++++++++++-----------------
 include/linux/fsnotify_backend.h |    4 ++--
 5 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 61157f2..c48dcf6 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -34,7 +34,7 @@ void __fsnotify_inode_delete(struct inode *inode, int flag)
 }
 EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
 
-void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
+void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *file_name)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -66,7 +66,7 @@ void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
 				if (!event)
 					break;
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 6b2dc15..89677ee 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -57,6 +57,9 @@ struct fsnotify_event {
 	__u64 mask;	/* the type of access */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 
+	char *file_name;
+	size_t name_len;
+
 	struct list_head private_data_list;
 };
 
@@ -99,13 +102,13 @@ extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
 
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
 extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
- extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
- extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index e039a47..8ed9d32 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -62,6 +62,7 @@ void fsnotify_put_event(struct fsnotify_event *event)
 		event->mask = 0;
 
 		BUG_ON(!list_empty(&event->private_data_list));
+		kfree(event->file_name);
 		kmem_cache_free(event_kmem_cache, event);
 	}
 }
@@ -196,7 +197,7 @@ void fsnotify_flush_notif(struct fsnotify_group *group)
 	mutex_unlock(&group->notification_mutex);
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name)
 {
 	struct fsnotify_event *event;
 
@@ -204,6 +205,18 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 	if (!event)
 		return NULL;
 
+	if (name) {
+		event->file_name = kstrdup(name, GFP_KERNEL);
+		if (!event->file_name) {
+			kmem_cache_free(event_kmem_cache, event);
+			return NULL;
+		}
+		event->name_len = strlen(event->file_name);
+	} else {
+		event->file_name = NULL;
+		event->name_len = 0;
+	}
+
 	event->holder.event = NULL;
 	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
@@ -222,6 +235,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 	switch (data_is) {
 	case FSNOTIFY_EVENT_FILE: {
 		struct file *file = data;
+
 		event->path.dentry = file->f_path.dentry;
 		event->path.mnt = file->f_path.mnt;
 		path_get(&event->path);
@@ -231,6 +245,9 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 		event->inode = data;
 		break;
 	default:
+		event->path.dentry = NULL;
+		event->path.mnt = NULL;
+		event->inode = NULL;
 		BUG();
 	};
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 791d288..8f4caf8 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -98,7 +98,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
 	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 		dput(parent);
 	} else {
 		spin_unlock(&dentry->d_lock);
@@ -152,18 +152,18 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name);
 
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
 		inotify_inode_is_dead(target);
-		fsnotify(target, FS_DELETE, target, FSNOTIFY_EVENT_INODE);
+		fsnotify(target, FS_DELETE, target, FSNOTIFY_EVENT_INODE, NULL);
 	}
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -196,7 +196,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
 	__fsnotify_inode_delete(inode, FSNOTIFY_LAST_DENTRY);
 }
 
@@ -207,7 +207,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -219,7 +219,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -234,7 +234,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
 }
 
 /*
@@ -246,7 +246,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -265,7 +265,7 @@ static inline void fsnotify_access(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -284,7 +284,7 @@ static inline void fsnotify_modify(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -299,7 +299,7 @@ static inline void fsnotify_open_exec(struct file *file)
 	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, FS_ACCESS);
-	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -318,7 +318,7 @@ static inline void fsnotify_open(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -339,7 +339,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -357,7 +357,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -395,7 +395,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b6d1895..cf24ff1 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -118,7 +118,7 @@ struct fsnotify_group {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 extern void __fsnotify_inode_delete(struct inode *inode, int flag);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
@@ -133,7 +133,7 @@ extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_grou
 extern struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, struct inode *inode, __u64 mask);
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode, int flag)

