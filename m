Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYLLVxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYLLVxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYLLVv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:51:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbYLLVvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:51:54 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 05/14] fsnotify: unified filesystem notification
	backend
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:40 -0500
Message-ID: <20081212215140.27112.67859.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify is a backend for filesystem notification.  fsnotify does
not provide any userspace interface but does provide the basis
needed for other notification schemes such as dnotify.  fsnotify
can be extended to be the backend for inotify or the upcoming
fsnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Kconfig                |   12 +++
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   78 +++++++++++++++++++
 fs/notify/fsnotify.h             |   51 +++++++++++++
 fs/notify/group.c                |  153 ++++++++++++++++++++++++++++++++++++++
 fs/notify/notification.c         |  123 +++++++++++++++++++++++++++++++
 include/linux/fsnotify.h         |   57 ++++++++++++--
 include/linux/fsnotify_backend.h |  110 +++++++++++++++++++++++++++
 8 files changed, 578 insertions(+), 8 deletions(-)
 create mode 100644 fs/notify/fsnotify.c
 create mode 100644 fs/notify/fsnotify.h
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fsnotify_backend.h

diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index 50914d7..269b59a 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -1,2 +1,14 @@
+config FSNOTIFY
+        bool "Filesystem notification backend"
+        default y
+        ---help---
+           fsnotify is a backend for filesystem notification.  fsnotify does
+           not provide any userspace interface but does provide the basis
+           needed for other notification schemes such as dnotify and fsnotify.
+
+           Say Y here to enable fsnotify suport.
+
+           If unsure, say Y.
+
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 5a95b60..7cb285a 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -1,2 +1,4 @@
 obj-y			+= dnotify/
 obj-y			+= inotify/
+
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
new file mode 100644
index 0000000..93a0e8f
--- /dev/null
+++ b/fs/notify/fsnotify.c
@@ -0,0 +1,78 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/dcache.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/srcu.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event *event = NULL;
+	int idx;
+
+	if (list_empty(&fsnotify_groups))
+		return;
+
+	if (!(mask & fsnotify_mask))
+		return;
+
+	/*
+	 * SRCU!!  the groups list is very very much read only and the path is
+	 * very hot (assuming something is using fsnotify)  Not blocking while
+	 * walking this list is ugly.  We could preallocate an event and an
+	 * event holder for every group that event might need to be put on, but
+	 * all that possibly wasted allocation is nuts.  For all we know there
+	 * are already mark entries, groups don't need this event, or all
+	 * sorts of reasons to believe not every kernel action is going to get
+	 * sent to userspace.  Hopefully this won't get shit on too much,
+	 * because going to a mutex here is really going to needlessly serialize
+	 * read/write/open/close across the whole system....
+	 */
+	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
+	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
+		if (mask & group->mask) {
+			if (!event) {
+				event = fsnotify_create_event(to_tell, mask, data, data_is);
+				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
+				if (!event)
+					break;
+			}
+			group->ops->event_to_notif(group, event);
+		}
+	}
+	srcu_read_unlock(&fsnotify_grp_srcu_struct, idx);
+	/*
+	 * fsnotify_create_event() took a reference so the event can't be cleaned
+	 * up while we are still trying to add it to lists, drop that one.
+	 */
+	if (event)
+		fsnotify_put_event(event);
+}
+EXPORT_SYMBOL_GPL(fsnotify);
+
+static __init int fsnotify_init(void)
+{
+	return init_srcu_struct(&fsnotify_grp_srcu_struct);
+}
+subsys_initcall(fsnotify_init);
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
new file mode 100644
index 0000000..15bc151
--- /dev/null
+++ b/fs/notify/fsnotify.h
@@ -0,0 +1,51 @@
+#ifndef _LINUX_FSNOTIFY_PRIVATE_H
+#define _LINUX_FSNOTIFY_PRIVATE_H
+
+#include <linux/dcache.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/path.h>
+#include <linux/spinlock.h>
+
+#include <linux/fsnotify.h>
+
+#include <asm/atomic.h>
+
+struct fsnotify_event_private_data {
+	struct fsnotify_group *group;
+	struct list_head event_list;
+	char data[0];
+};
+
+/*
+ * all of the information about the original object we want to now send to
+ * a scanner.  If you want to carry more info from the accessing task to the
+ * listener this structure is where you need to be adding fields.
+ */
+struct fsnotify_event {
+	spinlock_t lock; /* protection for the associated event_holder and private_list */
+	struct inode *to_tell;
+	/*
+	 * depending on the event type we should have either a path, dentry, or inode
+	 * we should never have more than one....
+	 */
+	union {
+		struct path path;
+		struct inode *inode;
+	};
+	int flag;		/* which of the above we have */
+	__u64 mask;	/* the type of access */
+	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+
+	struct list_head private_data_list;
+};
+
+extern struct srcu_struct fsnotify_grp_srcu_struct;
+extern struct list_head fsnotify_groups;
+extern __u64 fsnotify_mask;
+
+extern void fsnotify_get_event(struct fsnotify_event *event);
+extern void fsnotify_put_event(struct fsnotify_event *event);
+extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
+#endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
new file mode 100644
index 0000000..40935c3
--- /dev/null
+++ b/fs/notify/group.c
@@ -0,0 +1,153 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/rculist.h>
+#include <linux/wait.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+#include <asm/atomic.h>
+
+DEFINE_MUTEX(fsnotify_grp_mutex);
+struct srcu_struct fsnotify_grp_srcu_struct;
+LIST_HEAD(fsnotify_groups);
+__u64 fsnotify_mask;
+
+void fsnotify_recalc_global_mask(void)
+{
+	struct fsnotify_group *group;
+	__u64 mask = 0;
+	int idx;
+
+	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
+	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
+		mask |= group->mask;
+	}
+	srcu_read_unlock(&fsnotify_grp_srcu_struct, idx);
+	fsnotify_mask = mask;
+}
+
+static void fsnotify_add_group(struct fsnotify_group *group)
+{
+	list_add_rcu(&group->group_list, &fsnotify_groups);
+}
+
+void fsnotify_get_group(struct fsnotify_group *group)
+{
+	atomic_inc(&group->refcnt);
+}
+
+static void fsnotify_destroy_group(struct fsnotify_group *group)
+{
+	if (group->ops->free_group_priv)
+		group->ops->free_group_priv(group);
+
+	kfree(group);
+}
+
+void fsnotify_put_group(struct fsnotify_group *group)
+{
+	if (atomic_dec_and_test(&group->refcnt)) {
+		mutex_lock(&fsnotify_grp_mutex);
+		list_del_rcu(&group->group_list);
+		mutex_unlock(&fsnotify_grp_mutex);
+
+		synchronize_srcu(&fsnotify_grp_srcu_struct);
+
+		/*
+		 * shit. something found us before we got off the list.
+		 * so lets put ourselves back...
+		 */
+		if (atomic_read(&group->refcnt)) {
+			mutex_lock(&fsnotify_grp_mutex);
+			if (atomic_read(&group->refcnt))
+				fsnotify_add_group(group);
+			mutex_unlock(&fsnotify_grp_mutex);
+			return;
+		}
+
+		fsnotify_recalc_global_mask();
+		fsnotify_destroy_group(group);
+	}
+}
+
+static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops)
+{
+	struct fsnotify_group *group_iter;
+	struct fsnotify_group *group = NULL;
+
+	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
+		if (group_iter->group_num == group_num) {
+			if ((group_iter->mask == mask) &&
+			    (group_iter->ops == ops)) {
+				fsnotify_get_group(group_iter);
+				group = group_iter;
+			} else
+				group = ERR_PTR(-EEXIST);
+		}
+	}
+	return group;
+}
+
+struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops)
+{
+	struct fsnotify_group *group, *tgroup;
+	int idx;
+
+	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
+	group = fsnotify_find_group(group_num, mask, ops);
+	srcu_read_unlock(&fsnotify_grp_srcu_struct, idx);
+	if (group)
+		return group;
+
+	group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&group->refcnt, 1);
+
+	group->group_num = group_num;
+	group->mask = mask;
+
+	group->ops = ops;
+	group->private = NULL;
+
+	mutex_lock(&fsnotify_grp_mutex);
+	tgroup = fsnotify_find_group(group_num, mask, ops);
+	/* we raced and something else inserted the same group */
+	if (tgroup) {
+		mutex_unlock(&fsnotify_grp_mutex);
+		/* destroy the new one we made */
+		fsnotify_put_group(group);
+		return tgroup;
+	}
+
+	/* ok, no races here, add it */
+	fsnotify_add_group(group);
+	mutex_unlock(&fsnotify_grp_mutex);
+
+	if (mask)
+		fsnotify_recalc_global_mask();
+
+	return group;
+}
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
new file mode 100644
index 0000000..f008a15
--- /dev/null
+++ b/fs/notify/notification.c
@@ -0,0 +1,123 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/path.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+static struct kmem_cache *event_kmem_cache;
+
+void fsnotify_get_event(struct fsnotify_event *event)
+{
+	atomic_inc(&event->refcnt);
+}
+
+void fsnotify_put_event(struct fsnotify_event *event)
+{
+	if (!event)
+		return;
+
+	if (atomic_dec_and_test(&event->refcnt)) {
+		if (event->flag == FSNOTIFY_EVENT_FILE) {
+			path_put(&event->path);
+			event->path.dentry = NULL;
+			event->path.mnt = NULL;
+		}
+
+		event->mask = 0;
+
+		BUG_ON(!list_empty(&event->private_data_list));
+		kmem_cache_free(event_kmem_cache, event);
+	}
+}
+
+struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_event_private_data *lpriv;
+	struct fsnotify_event_private_data *priv = NULL;
+
+	list_for_each_entry(lpriv, &event->private_data_list, event_list) {
+		if (lpriv->group == group) {
+			priv = lpriv;
+			break;
+		}
+	}
+	return priv;
+}
+
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
+{
+	struct fsnotify_event *event;
+
+	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	atomic_set(&event->refcnt, 1);
+
+	spin_lock_init(&event->lock);
+
+	event->path.dentry = NULL;
+	event->path.mnt = NULL;
+	event->inode = NULL;
+
+	INIT_LIST_HEAD(&event->private_data_list);
+
+	event->to_tell = to_tell;
+	event->flag = data_is;
+
+	switch (data_is) {
+	case FSNOTIFY_EVENT_FILE: {
+		struct file *file = data;
+		event->path.dentry = file->f_path.dentry;
+		event->path.mnt = file->f_path.mnt;
+		path_get(&event->path);
+		break;
+	}
+	case FSNOTIFY_EVENT_INODE:
+		event->inode = data;
+		break;
+	default:
+		BUG();
+	};
+
+	event->mask = mask;
+
+	return event;
+}
+
+__init int fsnotify_notification_init(void)
+{
+	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
+subsys_initcall(fsnotify_notification_init);
+
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 6fbf455..b084b98 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -13,6 +13,7 @@
 
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
 
 /*
@@ -43,28 +44,45 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 {
 	struct inode *source = moved->d_inode;
 	u32 cookie = inotify_get_cookie();
+	__u64 old_dir_mask = 0;
+	__u64 new_dir_mask = 0;
 
-	if (old_dir == new_dir)
+	if (old_dir == new_dir) {
 		inode_dir_notify(old_dir, DN_RENAME);
-	else {
+		old_dir_mask = FS_DN_RENAME;
+	} else {
 		inode_dir_notify(old_dir, DN_DELETE);
+		old_dir_mask = FS_DELETE;
 		inode_dir_notify(new_dir, DN_CREATE);
+		new_dir_mask = FS_CREATE;
 	}
 
-	if (isdir)
+	if (isdir) {
 		isdir = IN_ISDIR;
+		old_dir_mask |= FS_IN_ISDIR;
+		new_dir_mask |= FS_IN_ISDIR;
+	}
+
+	old_dir_mask |= FS_MOVED_FROM;
+	new_dir_mask |= FS_MOVED_TO;
+
 	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
 				  source);
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
 
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
+
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
 		inotify_inode_is_dead(target);
+		fsnotify(target, FS_DELETE, target, FSNOTIFY_EVENT_INODE);
 	}
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -87,6 +105,8 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
+
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -95,6 +115,8 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 static inline void fsnotify_link_count(struct inode *inode)
 {
 	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -106,6 +128,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
+
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -120,6 +144,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
 				  inode);
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
+
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -131,6 +157,8 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
 				  dentry->d_name.name, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
+
+	fsnotify(inode, FS_CREATE | FS_IN_ISDIR, dentry->d_inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -140,7 +168,7 @@ static inline void fsnotify_access(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ACCESS;
+	__u64 mask = IN_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
@@ -148,6 +176,8 @@ static inline void fsnotify_access(struct file *file)
 	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -157,7 +187,7 @@ static inline void fsnotify_modify(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_MODIFY;
+	__u64 mask = IN_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
@@ -165,6 +195,8 @@ static inline void fsnotify_modify(struct file *file)
 	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -178,6 +210,8 @@ static inline void fsnotify_open_exec(struct file *file)
 	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
+
+	fsnotify(inode, FS_ACCESS, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -187,13 +221,15 @@ static inline void fsnotify_open(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_OPEN;
+	__u64 mask = IN_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -205,13 +241,15 @@ static inline void fsnotify_close(struct file *file)
 	struct inode *inode = dentry->d_inode;
 	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
-	u32 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	__u64 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -220,13 +258,15 @@ static inline void fsnotify_close(struct file *file)
 static inline void fsnotify_xattr(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ATTRIB;
+	__u64 mask = IN_ATTRIB;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -276,6 +316,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
 						  dentry->d_name.name);
+		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
new file mode 100644
index 0000000..5264db1
--- /dev/null
+++ b/include/linux/fsnotify_backend.h
@@ -0,0 +1,110 @@
+/*
+ * Filesystem access notification for Linux
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ */
+
+#ifndef _LINUX_FSNOTIFY_BACKEND_H
+#define _LINUX_FSNOTIFY_BACKEND_H
+
+#ifdef __KERNEL__
+
+#include <linux/dcache.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+
+#include <asm/atomic.h>
+
+/*
+ * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
+ * convert between them.  dnotify only needs conversion at watch creation
+ * so no perf loss there.  fanotify isn't defined yet, so it can use the
+ * wholes if it needs more events.
+ */
+#define FS_ACCESS		0x0000000000000001ull	/* File was accessed */
+#define FS_MODIFY		0x0000000000000002ull	/* File was modified */
+#define FS_ATTRIB		0x0000000000000004ull	/* Metadata changed */
+#define FS_CLOSE_WRITE		0x0000000000000008ull	/* Writtable file was closed */
+#define FS_CLOSE_NOWRITE	0x0000000000000010ull	/* Unwrittable file closed */
+#define FS_OPEN			0x0000000000000020ull	/* File was opened */
+#define FS_MOVED_FROM		0x0000000000000040ull	/* File was moved from X */
+#define FS_MOVED_TO		0x0000000000000080ull	/* File was moved to Y */
+#define FS_CREATE		0x0000000000000100ull	/* Subfile was created */
+#define FS_DELETE		0x0000000000000200ull	/* Subfile was deleted */
+#define FS_DELETE_SELF		0x0000000000000400ull	/* Self was deleted */
+#define FS_MOVE_SELF		0x0000000000000800ull	/* Self was moved */
+
+#define FS_IN_UNMOUNT		0x0000000000002000ull	/* inode on umount fs */
+#define FS_Q_OVERFLOW		0x0000000000004000ull	/* Event queued overflowed */
+#define FS_IN_IGNORED		0x0000000000008000ull	/* last inotify event here */
+
+#define FS_IN_ISDIR		0x0000000040000000ull	/* event occurred against dir */
+#define FS_IN_ONESHOT		0x0000000080000000ull	/* only send event once */
+
+/*
+ * FSNOTIFY has decided to seperate out events for self vs events delivered to
+ * a parent baed on the actions of the child.  dnotify does this for 4 events
+ * ACCESS, MODIFY, ATTRIB, and DELETE.  Inotify adds to that list CLOSE_WRITE,
+ * CLOSE_NOWRITE, CREATE, MOVE_FROM, MOVE_TO, OPEN.  So all of these _CHILD
+ * events are defined the same as the regular only << 32 for easy conversion.
+ */
+#define FS_ACCESS_CHILD		0x0000000100000000ull	/* child was accessed */
+#define FS_MODIFY_CHILD		0x0000000200000000ull	/* child was modified */
+#define FS_ATTRIB_CHILD		0x0000000400000000ull	/* child attributed changed */
+#define FS_CLOSE_WRITE_CHILD	0x0000000800000000ull	/* Writtable file was closed */
+#define FS_CLOSE_NOWRITE_CHILD	0x0000001000000000ull	/* Unwrittable file closed */
+#define FS_OPEN_CHILD		0x0000002000000000ull	/* File was opened */
+#define FS_MOVED_FROM_CHILD	0x0000004000000000ull	/* File was moved from X */
+#define FS_MOVED_TO_CHILD	0x0000008000000000ull	/* File was moved to Y */
+#define FS_CREATE_CHILD		0x0000010000000000ull	/* Subfile was created */
+#define FS_DELETE_CHILD		0x0000020000000000ull	/* child was deleted */
+
+#define FS_DN_RENAME		0x1000000000000000ull	/* file renamed */
+#define FS_DN_MULTISHOT		0x2000000000000000ull	/* dnotify multishot */
+
+/* when calling fsnotify tell it if the data is a file, dentry, or inode */
+#define FSNOTIFY_EVENT_FILE     1
+#define FSNOTIFY_EVENT_INODE    2
+
+struct fsnotify_group;
+struct fsnotify_event;
+
+struct fsnotify_ops {
+	int (*event_to_notif)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*free_group_priv)(struct fsnotify_group *group);
+	void (*free_event_priv)(struct fsnotify_group *group, struct fsnotify_event *event);
+};
+
+struct fsnotify_group {
+	struct list_head group_list;	/* list of all groups on the system */
+	unsigned int group_num;		/* the 'name' of the event */
+	__u64 mask;			/* mask of events this group cares about */
+	atomic_t refcnt;		/* num of processes with a special file open */
+
+	const struct fsnotify_ops *ops;	/* how this group handles things */
+
+	void *private;			/* private data for implementers (dnotify, inotify, fanotify) */
+};
+
+#ifdef CONFIG_FSNOTIFY
+
+/* called from the vfs to signal fs events */
+extern void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+
+/* called from fsnotify interfaces, such as fanotify or dnotify */
+extern void fsnotify_recalc_global_mask(void);
+extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u64 mask, const struct fsnotify_ops *ops);
+extern void fsnotify_put_group(struct fsnotify_group *group);
+extern void fsnotify_get_group(struct fsnotify_group *group);
+
+#else
+
+static inline void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is);
+{}
+#endif	/* CONFIG_FSNOTIFY */
+
+#endif	/* __KERNEL __ */
+
+#endif	/* _LINUX_FSNOTIFY_BACKEND_H */

