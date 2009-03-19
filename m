Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZCSSJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZCSSJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbZCSSHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46012 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbZCSSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 09/13] fsnotify: add correlations between events
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:42 -0400
Message-ID: <20090319180541.17449.38096.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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
 fs/notify/notification.c         |   15 ++++++++++++++-
 include/linux/fsnotify.h         |   37 +++++++++++++++++++------------------
 include/linux/fsnotify_backend.h |   15 ++++++++++++---
 4 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 6816b81..5b4622b 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  */
-void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name)
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *file_name, u32 cookie)
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *event = NULL;
@@ -62,7 +62,7 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
 			if (!event) {
-				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name);
+				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name, cookie);
 				/* shit, we OOM'd and now we can't tell, maybe
 				 * someday someone else will want to do something
 				 * here */
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 1e7b4ca..ecab682 100644
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
@@ -41,6 +42,13 @@ static struct kmem_cache *event_holder_kmem_cache;
  * get set to 0 so it will never get 'freed'
  */
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
@@ -244,6 +252,8 @@ static void initialize_event(struct fsnotify_event *event)
 
 	event->file_name = NULL;
 	event->name_len = 0;
+
+	event->sync_cookie = 0;
 }
 
 /*
@@ -254,7 +264,8 @@ static void initialize_event(struct fsnotify_event *event)
  * @data pointer to the object which was actually affected
  * @data_type flag indication if the data is a file, path, inode, nothing...
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type, const char *name)
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
+					     int data_type, const char *name, u32 cookie)
 {
 	struct fsnotify_event *event;
 
@@ -272,6 +283,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 		}
 		event->name_len = strlen(event->file_name);
 	}
+
+	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
 
 	switch (data_type) {
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 48762b1..7f4efee 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -54,7 +54,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
 	spin_unlock(&dentry->d_lock);
 
 	if (send) {
-		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 		dput(parent);
 	}
 }
@@ -92,7 +92,7 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
 
-	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	__fsnotify_inode_delete(inode);
 }
 
@@ -104,7 +104,8 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	u32 in_cookie = inotify_get_cookie();
+	u32 fs_cookie = fsnotify_get_cookie();
 	__u32 old_dir_mask = 0;
 	__u32 new_dir_mask = 0;
 
@@ -121,20 +122,20 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
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
 
 	if (target)
 		fsnotify_inoderemove(target);
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
-		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -158,7 +159,7 @@ static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
 
-	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -170,7 +171,7 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -185,7 +186,7 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 
-	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name);
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
 }
 
 /*
@@ -197,7 +198,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
-	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name);
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
 }
 
 /*
@@ -215,7 +216,7 @@ static inline void fsnotify_access(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -233,7 +234,7 @@ static inline void fsnotify_modify(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -251,7 +252,7 @@ static inline void fsnotify_open(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -272,7 +273,7 @@ static inline void fsnotify_close(struct file *file)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL);
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE, NULL, 0);
 }
 
 /*
@@ -290,7 +291,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
-	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 }
 
 /*
@@ -328,7 +329,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 						  dentry->d_name.name);
 
 		fsnotify_parent(dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a2c3b06..467ced7 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -160,6 +160,7 @@ struct fsnotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	__u32 mask;		/* the type of access */
 
+	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
 };
@@ -192,8 +193,9 @@ struct fsnotify_mark_entry {
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs to signal fs events */
-extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name, u32 cookie);
 extern void __fsnotify_inode_delete(struct inode *inode);
+extern u32 fsnotify_get_cookie(void);
 
 static inline int fsnotify_inode_watches_children(struct inode *inode)
 {
@@ -251,11 +253,13 @@ extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
 
 /* put here because inotify does some weird stuff when destroying watches */
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
+						    int data_is, const char *name, __u32 cookie);
 
 #else
 
-static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const char *name);
+static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
+			    const char *name, u32 cookie);
 {}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)
@@ -264,6 +268,11 @@ static inline void __fsnotify_inode_delete(struct inode *inode)
 static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
 {}
 
+static inline u32 fsnotify_get_cookie(void)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

