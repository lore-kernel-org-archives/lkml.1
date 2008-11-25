Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYKYRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYKYRW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYKYRVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:21:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYKYRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:21:48 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 5/8] fsnotify: unified filesystem notification backend
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:21:18 -0500
Message-ID: <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
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

 fs/notify/Kconfig                |   12 ++
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   78 ++++++++++++++++
 fs/notify/fsnotify.h             |   69 ++++++++++++++
 fs/notify/group.c                |  124 +++++++++++++++++++++++++
 fs/notify/notification.c         |  188 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |   80 ++++++++++++++++
 7 files changed, 553 insertions(+), 0 deletions(-)
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
index 0000000..3c4262b
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
+void fsnotify(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event *event = NULL;
+	int idx;
+
+	if (likely(list_empty(&fsnotify_groups)))
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
+				event = fsnotify_create_event(file, dentry, inode, mask);
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
index 0000000..007bc28
--- /dev/null
+++ b/fs/notify/fsnotify.h
@@ -0,0 +1,69 @@
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
+/*
+ * A single event can be queued in multiple group->notification_lists.
+ *
+ * each group->notification_list will point to an event_holder which in turns points
+ * to the actual event that needs to be sent to userspace.
+ *
+ * Seemed cheaper to create a refcnt'd event and a small holder for every group
+ * than create a different event for every group
+ *
+ */
+struct fsnotify_event_holder {
+	struct fsnotify_event *event;
+	struct list_head event_list;
+};
+
+/*
+ * all of the information about the original object we want to now send to
+ * a scanner.  If you want to carry more info from the accessing task to the
+ * listener this structure is where you need to be adding fields.
+ */
+struct fsnotify_event {
+	/*
+	 * If we create an event we are also going to need to create a holder
+	 * to link to a group.  So embed one holder in the event.  Means only
+	 * one allocation for the common case where we only have one group
+	 */
+	struct fsnotify_event_holder holder;
+	spinlock_t holder_spinlock; /* protection for the associated event_holder */
+	/*
+	 * depending on the event type we should have either a path, dentry, or inode
+	 * we should never have more than one....
+	 */
+	union {
+		struct path path;
+		struct dentry *dentry;
+		struct inode *inode;
+	};
+#define FSNOTIFY_EVENT_PATH	1
+#define FSNOTIFY_EVENT_DENTRY	2
+#define FSNOTIFY_EVENT_INODE	3
+	int flag;		/* which of the above we have */
+	unsigned long mask;	/* the type of access */
+	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+};
+
+extern struct srcu_struct fsnotify_grp_srcu_struct;
+extern struct list_head fsnotify_groups;
+extern unsigned long fsnotify_mask;
+
+extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
+extern void fsnotify_clear_notif(struct fsnotify_group *group);
+extern void fsnotify_get_event(struct fsnotify_event *event);
+extern void fsnotify_put_event(struct fsnotify_event *event);
+extern struct fsnotify_event *fsnotify_create_event(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask);
+extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+#endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
new file mode 100644
index 0000000..dcc0547
--- /dev/null
+++ b/fs/notify/group.c
@@ -0,0 +1,124 @@
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
+unsigned long fsnotify_mask;
+
+void fsnotify_recalc_global_mask(void)
+{
+	struct fsnotify_group *group;
+	unsigned long mask = 0;
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
+void fsnotify_get_group(struct fsnotify_group *group)
+{
+	atomic_inc(&group->refcnt);
+}
+
+void fsnotify_kill_group(struct fsnotify_group *group)
+{
+	/* clear the notification queue of all events */
+	fsnotify_clear_notif(group);
+
+	kfree(group);
+}
+
+void fsnotify_put_group(struct fsnotify_group *group)
+{
+	mutex_lock(&fsnotify_grp_mutex);
+	if (atomic_dec_and_test(&group->refcnt)) {
+		list_del_rcu(&group->group_list);
+		mutex_unlock(&fsnotify_grp_mutex);
+
+		synchronize_srcu(&fsnotify_grp_srcu_struct);
+
+		fsnotify_recalc_global_mask();
+		fsnotify_kill_group(group);
+
+		return;
+	}
+	mutex_unlock(&fsnotify_grp_mutex);
+
+	return;
+}
+
+struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops)
+{
+	struct fsnotify_group *group_iter;
+	struct fsnotify_group *group = NULL;
+
+	mutex_lock(&fsnotify_grp_mutex);
+	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
+		if (group_iter->group_num == group_num) {
+			if ((group_iter->mask == mask) &&
+			    (group_iter->ops == ops)) {
+				fsnotify_get_group(group_iter);
+				group = group_iter;
+			} else
+				group = ERR_PTR(-EEXIST);
+			goto out;
+		}
+	}
+
+	group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
+	if (!group) {
+		group = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	atomic_set(&group->refcnt, 1);
+
+	group->group_num = group_num;
+	group->mask = mask;
+
+	mutex_init(&group->notification_mutex);
+	INIT_LIST_HEAD(&group->notification_list);
+	init_waitqueue_head(&group->notification_waitq);
+
+	group->ops = ops;
+
+	/* add it */
+	list_add_rcu(&group->group_list, &fsnotify_groups);
+
+out:
+	mutex_unlock(&fsnotify_grp_mutex);
+	fsnotify_recalc_global_mask();
+	return group;
+}
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
new file mode 100644
index 0000000..2467b5b
--- /dev/null
+++ b/fs/notify/notification.c
@@ -0,0 +1,188 @@
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
+static struct kmem_cache *event_holder_kmem_cache;
+
+int fsnotify_check_notif_queue(struct fsnotify_group *group)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&group->notification_list))
+		return 1;
+	mutex_unlock(&group->notification_mutex);
+	return 0;
+}
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
+		switch (event->flag) {
+		case FSNOTIFY_EVENT_PATH:
+			path_put(&event->path);
+			event->path.dentry = NULL;
+			event->path.mnt = NULL;
+			break;
+		case FSNOTIFY_EVENT_INODE:
+			iput(event->inode);
+			event->inode = NULL;
+			break;
+		case FSNOTIFY_EVENT_DENTRY:
+			dput(event->dentry);
+			event->dentry = NULL;
+			break;
+		default:
+			BUG();
+		};
+
+		event->mask = 0;
+		kmem_cache_free(event_kmem_cache, event);
+	}
+}
+
+struct fsnotify_event_holder *alloc_event_holder(void)
+{
+	return kmem_cache_alloc(event_holder_kmem_cache, GFP_KERNEL);
+}
+
+void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
+{
+	kmem_cache_free(event_holder_kmem_cache, holder);
+}
+
+/*
+ * must be called with group->notification_mutex held and must know event is present.
+ * it is the responsibility of the caller to call put_event() on the returned
+ * structure
+ */
+struct fsnotify_event *get_event_from_notif(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
+
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+
+	event = holder->event;
+
+	spin_lock(&event->holder_spinlock);
+	holder->event = NULL;
+	list_del_init(&holder->event_list);
+	spin_unlock(&event->holder_spinlock);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (event != (struct fsnotify_event *)holder)
+		fsnotify_destroy_event_holder(holder);
+
+	return event;
+}
+
+void fsnotify_clear_notif(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+
+	while (fsnotify_check_notif_queue(group)) {
+		event = get_event_from_notif(group);
+		fsnotify_put_event(event);
+		/* fsnotify_check_notif_queue() took this lock */
+		mutex_unlock(&group->notification_mutex);
+	}
+}
+
+struct fsnotify_event *fsnotify_create_event(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask)
+{
+	struct fsnotify_event *event;
+
+	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	event->holder.event = NULL;
+	INIT_LIST_HEAD(&event->holder.event_list);
+	atomic_set(&event->refcnt, 1);
+
+	spin_lock_init(&event->holder_spinlock);
+
+	event->path.dentry = NULL;
+	event->path.mnt = NULL;
+	event->dentry = NULL;
+	event->inode = NULL;
+
+	if (file) {
+		event->path.dentry = file->f_path.dentry;
+		event->path.mnt = file->f_path.mnt;
+		path_get(&event->path);
+		event->flag = FSNOTIFY_EVENT_PATH;
+	} else if (dentry) {
+		event->dentry = dget(dentry);
+		event->flag = FSNOTIFY_EVENT_DENTRY;
+	} else if (inode) {
+		event->inode = igrab(inode);
+		event->flag = FSNOTIFY_EVENT_INODE;
+	}
+
+#if 1
+	/* did we fuck up and get more than one? */
+	do {
+		int i = 0;
+		if (file)
+			i++;
+		if (dentry)
+			i++;
+		if (inode)
+			i++;
+		WARN_ON(i != 1);
+	} while (0);
+#endif
+
+	event->mask = mask;
+
+	return event;
+}
+
+__init int fsnotify_notification_init(void)
+{
+	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);
+	event_holder_kmem_cache = kmem_cache_create("fsnotify_event_holder", sizeof(struct fsnotify_event_holder), 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
+subsys_initcall(fsnotify_notification_init);
+
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
new file mode 100644
index 0000000..6a7b95c
--- /dev/null
+++ b/include/linux/fsnotify_backend.h
@@ -0,0 +1,80 @@
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
+#define FS_ACCESS		0x00000001	/* file was accessed */
+#define FS_ACCESS_CHILD		0x00000002	/* child was accessed */
+#define FS_MODIFY		0x00000004	/* file was modified */
+#define FS_MODIFY_CHILD		0x00000008	/* child was modified */
+#define FS_DELETE		0x00000010	/* deleted */
+#define FS_DELETE_CHILD		0x00000020	/* child was deleted */
+#define FS_ATTRIB		0x00000040	/* attributes were changed */
+#define FS_ATTRIB_CHILD		0x00000080	/* child attributed changed */
+#define FS_CLOSE_NOWRITE	0x00000100	/* Unwrittable file closed */
+#define FS_CLOSE_WRITE		0x00000200	/* Writtable file closed */
+#define FS_OPEN			0x00000400	/* File was opened */
+#define FS_CREATE		0x00000800	/* new file created */
+#define FS_RENAME		0x00001000	/* file renamed */
+
+/* FIXME currently Q's have no limit.... */
+#define FS_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
+#define FS_DN_MULTISHOT		0x40000000	/* dnotify multishot */
+
+/* helper events */
+#define FS_CLOSE		(FS_CLOSE_WRITE | FS_CLOSE_NOWRITE) /* close */
+
+struct fsnotify_group;
+struct fsnotify_event;
+
+struct fsnotify_ops {
+	int (*event_to_notif)(struct fsnotify_group *group, struct fsnotify_event *event);
+};
+
+struct fsnotify_group {
+	struct list_head group_list;	/* list of all groups on the system */
+	unsigned int group_num;		/* the 'name' of the event */
+	unsigned long mask;		/* mask of events this group cares about */
+	atomic_t refcnt;		/* num of processes with a special file open */
+
+	struct fsnotify_ops *ops;	/* how this group handles things */
+
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;/* protect the notification_list */
+	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+};
+
+#ifdef CONFIG_FSNOTIFY
+
+/* called from the vfs to signal fs events */
+extern void fsnotify(struct file *file, struct dentry *dentry, struct inode *inode, unsigned long mask);
+
+/* called from fsnotify interfaces, such as fanotify or dnotify */
+extern void fsnotify_recalc_global_mask(void);
+extern void fsnotify_get_group(struct fsnotify_group *group);
+extern struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops);
+extern void fsnotify_put_group(struct fsnotify_group *group);
+#else
+
+static inline void fsnotify(struct file *file, unsigned long mask)
+{}
+#endif	/* CONFIG_FSNOTIFY */
+
+#endif	/* __KERNEL __ */
+
+#endif	/* _LINUX_FSNOTIFY_BACKEND_H */

