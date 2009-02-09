Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZBIVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZBIVSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZBIVQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZBIVQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:53 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 07/11] fsnotify: include pathnames with entries when
	possible
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:59 -0500
Message-ID: <20090209211558.8985.76834.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
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
 fs/notify/fsnotify.h             |    5 ++++-
 fs/notify/notification.c         |   18 +++++++++++++++++-
 include/linux/fsnotify.h         |   32 ++++++++++++++++----------------
 include/linux/fsnotify_backend.h |    7 +++++--
 5 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index e7e53f7..2aa437b 100644
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
index 6d6942c..72e163e 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -17,9 +17,12 @@ extern __u64 fsnotify_mask;
 
 extern void fsnotify_flush_notif(struct fsnotify_group *group);
 
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
 
+extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 3884879..21a8b03 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -62,6 +62,7 @@ void fsnotify_put_event(struct fsnotify_event *event)
 		event->mask = 0;
 
 		BUG_ON(!list_empty(&event->private_data_list));
+		kfree(event->file_name);
 		kmem_cache_free(event_kmem_cache, event);
 	}
 }
@@ -248,9 +249,12 @@ static void initialize_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->private_data_list);
 
 	event->to_tell = NULL;
+
+	event->file_name = NULL;
+	event->name_len = 0;
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name)
 {
 	struct fsnotify_event *event;
 
@@ -259,6 +263,15 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 		return NULL;
 
 	initialize_event(event);
+
+	if (name) {
+		event->file_name = kstrdup(name, GFP_KERNEL);
+		if (!event->file_name) {
+			kmem_cache_free(event_kmem_cache, event);
+			return NULL;
+		}
+		event->name_len = strlen(event->file_name);
+	}
 	event->to_tell = to_tell;
 
 	switch (data_is) {
@@ -284,6 +297,9 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 		event->flag = FSNOTIFY_EVENT_INODE;
 		break;
 	default:
+		event->path.dentry = NULL;
+		event->path.mnt = NULL;
+		event->inode = NULL;
 		BUG();
 	};
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index f5ce85b..3081d86 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -107,7 +107,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
 	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 		dput(parent);
 	} else {
 		spin_unlock(&dentry->d_lock);
@@ -161,18 +161,18 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
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
@@ -205,7 +205,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
 	__fsnotify_inode_delete(inode, FSNOTIFY_LAST_DENTRY);
 }
 
@@ -216,7 +216,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -228,7 +228,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -243,7 +243,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
 }
 
 /*
@@ -255,7 +255,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -273,7 +273,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -291,7 +291,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -309,7 +309,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -330,7 +330,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -348,7 +348,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -386,7 +386,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6223efa..b86b4ef 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -168,6 +168,9 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u64 mask;		/* the type of access */
 
+	char *file_name;
+	size_t name_len;
+
 	struct list_head private_data_list;
 };
 
@@ -198,7 +201,7 @@ struct fsnotify_mark_entry {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 extern void __fsnotify_inode_delete(struct inode *inode, int flag);
 
 /* called from fsnotify interfaces, such as fanotify or dnotify */
@@ -226,7 +229,7 @@ extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const char *name);
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode, int flag)

