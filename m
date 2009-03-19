Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZCSSKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZCSSKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZCSSHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46020 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbZCSSHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 08/13] fsnotify: include pathnames with entries when possible
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:36 -0400
Message-ID: <20090319180536.17449.95844.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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
 fs/notify/fsnotify.h             |    4 ++++
 fs/notify/notification.c         |   19 ++++++++++++++++++-
 include/linux/fsnotify.h         |   30 +++++++++++++++---------------
 include/linux/fsnotify_backend.h |    9 ++++++---
 5 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4cc2d46..6816b81 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  */
-void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -62,7 +62,7 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
 				/* shit, we OOM'd and now we can't tell, maybe
 				 * someday someone else will want to do something
 				 * here */
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 4ae0741..06585db 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -19,4 +19,8 @@ extern void fsnotify_flush_notif(struct fsnotify_group *group);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
+
+extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index be98511..1e7b4ca 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -62,6 +62,8 @@ void fsnotify_put_event(struct fsnotify_event *event)
 	if (atomic_dec_and_test(&event->refcnt)) {
 		if (event->data_type == FSNOTIFY_EVENT_PATH)
 			path_put(&event->path);
+
+		kfree(event->file_name);
 		kmem_cache_free(event_kmem_cache, event);
 	}
 }
@@ -239,6 +241,9 @@ static void initialize_event(struct fsnotify_event *event)
 	event->data_type = FSNOTIFY_EVENT_NONE;
 
 	event->to_tell = NULL;
+
+	event->file_name = NULL;
+	event->name_len = 0;
 }
 
 /*
@@ -249,7 +254,7 @@ static void initialize_event(struct fsnotify_event *event)
  * @data pointer to the object which was actually affected
  * @data_type flag indication if the data is a file, path, inode, nothing...
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type, const char *name)
 {
 	struct fsnotify_event *event;
 
@@ -258,6 +263,15 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
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
 
 	switch (data_type) {
@@ -283,6 +297,9 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 		event->data_type = FSNOTIFY_EVENT_INODE;
 		break;
 	default:
+		event->path.dentry = NULL;
+		event->path.mnt = NULL;
+		event->inode = NULL;
 		BUG();
 	};
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 8b9539c..48762b1 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -54,7 +54,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
 	spin_unlock(&dentry->d_lock);
 
 	if (send) {
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 		dput(parent);
 	}
 }
@@ -92,7 +92,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
 	__fsnotify_inode_delete(inode);
 }
 
@@ -126,15 +126,15 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
 
-	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
-	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name);
 
 	if (target)
 		fsnotify_inoderemove(target);
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -158,7 +158,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -170,7 +170,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -185,7 +185,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
 }
 
 /*
@@ -197,7 +197,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
 }
 
 /*
@@ -215,7 +215,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -233,7 +233,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -251,7 +251,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -272,7 +272,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
 }
 
 /*
@@ -290,7 +290,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 }
 
 /*
@@ -328,7 +328,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e5b674e..a2c3b06 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -159,6 +159,9 @@ struct fsnotify_event {
 	int data_type;		/* which of the above union we have */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access */
+
+	char *file_name;
+	size_t name_len;
 };
 
 /*
@@ -189,7 +192,7 @@ struct fsnotify_mark_entry {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
 extern void __fsnotify_inode_delete(struct inode *inode);
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
@@ -248,11 +251,11 @@ extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 
 /* put here because inotify does some weird stuff when destroying watches */
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
 
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)

