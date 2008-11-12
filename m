Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYKLQMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYKLQMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYKLQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYKLQLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:21 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 03/21] fanotify: fscking all notify,
	system wide file access notification
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:42 -0500
Message-ID: <20081112161042.25434.64596.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new system wide file access notification system.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Kconfig        |   14 ++
 fs/notify/Makefile       |    2 
 fs/notify/fanotify.c     |   99 +++++++++++++++++
 fs/notify/fanotify.h     |   63 +++++++++++
 fs/notify/group.c        |  110 +++++++++++++++++++
 fs/notify/notification.c |  266 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild     |    1 
 include/linux/fanotify.h |   95 ++++++++++++++++
 include/linux/fsnotify.h |   14 ++
 include/linux/sched.h    |    1 
 10 files changed, 661 insertions(+), 4 deletions(-)
 create mode 100644 fs/notify/fanotify.c
 create mode 100644 fs/notify/fanotify.h
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 include/linux/fanotify.h

diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index 23415de..97cc832 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -36,3 +36,17 @@ config INOTIFY_USER
 	  For more information, see <file:Documentation/filesystems/inotify.txt>
 
 	  If unsure, say Y.
+
+config FANOTIFY
+        bool "Filesystem wide access notification"
+        select SECURITY
+        default y
+        ---help---
+           Say Y here to enable fanotify suport.  fanotify is a system wide
+           file access notification interface.  Events are read from from a
+           single open fd and in doing so a fd is created in the reading process
+           which points to the same data as the one on which the event occured.
+
+           For more information, see <file:Documentation/filesystems/fanotify.txt>
+
+           If unsure, say Y.
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 882ecf9..c467c97 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
+
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o group.o
diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
new file mode 100644
index 0000000..e2a338e
--- /dev/null
+++ b/fs/notify/fanotify.c
@@ -0,0 +1,99 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/rculist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/uaccess.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+struct dentry *fanotify_fs_root;
+
+void fanotify(struct file *file, unsigned int mask)
+{
+	struct fanotify_group *group;
+	struct fanotify_event *event = NULL;
+	struct task_struct *tsk = current;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int idx;
+
+	if (likely(list_empty(&fanotify_groups)))
+		return;
+
+	if (tsk->flags & PF_NOFACCESS)
+		return;
+
+	if (!S_ISREG(inode->i_mode))
+		return;
+
+	/*
+	 * SRCU!!  the groups list is very very much read only and the path is
+	 * very hot (assuming something is using fanotify)  Not blocking while
+	 * walking this list is ugly.  We could preallocate an event and an
+	 * event holder for every group that event might need to be put on, but
+	 * all that possibly wasted allocation is nuts.  For all we know there
+	 * are already fastpath entries, groups don't need this event, or all
+	 * sorts of reasons to believe not every kernel action is going to get
+	 * sent to userspace.  Hopefully this won't get shit on too much,
+	 * because going to a mutex here is really going to needlessly serialize
+	 * read/write/open/close across the whole system....
+	 */
+	idx = srcu_read_lock(&fanotify_grp_srcu_struct);
+	list_for_each_entry_rcu(group, &fanotify_groups, group_list) {
+		if (mask & group->mask) {
+			if (!event) {
+				event = create_event(file, mask);
+				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
+				if (!event)
+					break;
+			}
+			fanotify_add_event_to_notif(group, event);
+		}
+	}
+	srcu_read_unlock(&fanotify_grp_srcu_struct, idx);
+	/*
+	 * create_event() take a reference so the event can't be cleaned up while
+	 * we are still trying to add it to lists
+	 */
+	if (event)
+		fanotify_put_event(event);
+}
+EXPORT_SYMBOL_GPL(fanotify);
+
+static __init int fanotify_init(void)
+{
+	int ret;
+
+	ret = fanotify_notification_init();
+	if (ret)
+		return ret;
+
+	return init_srcu_struct(&fanotify_grp_srcu_struct);
+}
+__initcall(fanotify_init);
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
new file mode 100644
index 0000000..2cbe0ba
--- /dev/null
+++ b/fs/notify/fanotify.h
@@ -0,0 +1,63 @@
+#ifndef _LINUX_FANOTIFY_PRIVATE_H
+#define _LINUX_FANOTIFY_PRIVATE_H
+
+#include <linux/fanotify.h>
+
+
+#include <asm/atomic.h>
+#include <linux/dcache.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/path.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+/*
+ * A single event can be queued in multiple group->notification_lists.
+ *
+ * each group->notification_list will point to an event_holer which in turns points
+ * to the actual event that needs to be sent to userspace.
+ *
+ * Seemed cheaper to create a refcnt'd event and a small holder for every group
+ * than create a different event for every group
+ * 
+ */
+struct fanotify_event_holder {
+	struct fanotify_event *event;
+	struct list_head event_list;
+};
+
+/*
+ * all of the information about the original object we want to now send to
+ * a scanner.  If you want to carry more info from the accessing task to the
+ * listener this structure is where you need to be adding fields.
+ */
+struct fanotify_event {
+	/*
+	 * If we create an event we are also going to need to create a holder
+	 * to link to a group.  So embed one holder in the event.  Means only
+	 * one allocation for the common case where we only have one group
+	 */
+	struct fanotify_event_holder holder;
+	spinlock_t holder_spinlock; /* protection for the associated event_holder */
+	struct path path;	/* path from the original access */
+	unsigned int mask;	/* the type of access */
+	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+};
+
+extern struct srcu_struct fanotify_grp_srcu_struct;
+extern struct list_head fanotify_groups;
+
+extern int fanotify_check_notif_queue(struct fanotify_group *group);
+extern void fanotify_get_event(struct fanotify_event *event);
+extern void fanotify_put_event(struct fanotify_event *event);
+extern int fanotify_add_event_to_notif(struct fanotify_group *group, struct fanotify_event *event);
+extern struct fanotify_event *remove_event_from_group_notification(struct fanotify_group *group);
+extern void fanotify_notification_clear_group(struct fanotify_group *group);
+extern struct fanotify_event *create_event(struct file *file, unsigned int mask);
+extern struct fanotify_event_holder *alloc_event_holder(void);
+extern void fanotify_destroy_event_holder(struct fanotify_event_holder *holder);
+extern __init int fanotify_notification_init(void);
+extern __init int fanotify_notification_uninit(void);
+#endif	/* _LINUX_FANOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
new file mode 100644
index 0000000..fc3d736
--- /dev/null
+++ b/fs/notify/group.c
@@ -0,0 +1,110 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/rculist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/uaccess.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+DEFINE_MUTEX(fanotify_grp_mutex);
+struct srcu_struct fanotify_grp_srcu_struct;
+LIST_HEAD(fanotify_groups);
+
+void fanotify_get_group(struct fanotify_group *group)
+{
+	atomic_inc(&group->refcnt);
+}
+
+struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask)
+{
+	struct fanotify_group *group_iter;
+	struct fanotify_group *group = NULL;
+
+	mutex_lock(&fanotify_grp_mutex);
+	list_for_each_entry_rcu(group_iter, &fanotify_groups, group_list) {
+		if (group_iter->group_num == group_num) {
+			if (group_iter->mask == mask) {
+				fanotify_get_group(group_iter);
+				group = group_iter;
+			} else
+				group = ERR_PTR(-EEXIST);
+			goto out;
+		}
+	}
+
+	group = kmalloc(sizeof(struct fanotify_group), GFP_KERNEL);
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
+	/* add it */
+	list_add_rcu(&group->group_list, &fanotify_groups);
+
+out:
+	mutex_unlock(&fanotify_grp_mutex);
+	return group;
+}
+
+void fanotify_kill_group(struct fanotify_group *group)
+{
+	/* clear the notification queue of all events */
+	fanotify_notification_clear_group(group);
+
+	kfree(group);
+}
+
+void fanotify_put_group(struct fanotify_group *group)
+{
+	mutex_lock(&fanotify_grp_mutex);
+	if (atomic_dec_and_test(&group->refcnt)) {
+
+		list_del_rcu(&group->group_list);
+		mutex_unlock(&fanotify_grp_mutex);
+
+		synchronize_srcu(&fanotify_grp_srcu_struct);
+
+		fanotify_kill_group(group);
+
+		return;
+	}
+	mutex_unlock(&fanotify_grp_mutex);
+
+	return;
+}
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
new file mode 100644
index 0000000..3dd69ef
--- /dev/null
+++ b/fs/notify/notification.c
@@ -0,0 +1,266 @@
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
+#include <asm/atomic.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/path.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+static struct kmem_cache *event_kmem_cache;
+static struct kmem_cache *event_holder_kmem_cache;
+
+int fanotify_check_notif_queue(struct fanotify_group *group)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&group->notification_list))
+		return 1;
+	mutex_unlock(&group->notification_mutex);
+	return 0;
+}
+
+void fanotify_get_event(struct fanotify_event *event)
+{
+	atomic_inc(&event->refcnt);
+}
+
+void fanotify_put_event(struct fanotify_event *event)
+{
+	if (!event)
+		return;
+
+	if (atomic_dec_and_test(&event->refcnt)) {
+		path_put(&event->path);
+		event->path.dentry = NULL;
+		event->path.mnt = NULL;
+
+		event->mask = 0;
+		kmem_cache_free(event_kmem_cache, event);
+	}
+}
+
+struct fanotify_event_holder *alloc_event_holder(void)
+{
+	return kmem_cache_alloc(event_holder_kmem_cache, GFP_KERNEL);
+}
+
+void fanotify_destroy_event_holder(struct fanotify_event_holder *holder)
+{
+	kmem_cache_free(event_holder_kmem_cache, holder);
+}
+
+int fanotify_add_event_to_notif(struct fanotify_group *group, struct fanotify_event *event)
+{
+	struct fanotify_event_holder *holder;
+
+	/*
+	 * holder locking!!!
+	 *
+	 * only this task is going to be adding events to lists.  fanotify
+	 * listeners may be removing events from groups and freeing holders
+	 * but only we will be adding.  So locking is pretty easy.  We don't
+	 * need to lock when we check the list.  We don't really care what
+	 * order we see things from the freeing tasks.  If we see the holder
+	 * list is empty we know after we take the spinlock that holder will
+	 * be safe to use.
+	 *
+	 * When only looking at the notification list this is all useless since
+	 * everything meaningful is already being protected by the
+	 * notification_mutex but since access lists also use event_holders we
+	 * need this.
+	 */
+	if (list_empty(&event->holder.event_list))
+		holder = (struct fanotify_event_holder *)event;
+	else
+		holder = alloc_event_holder();
+	if (!holder)
+		return -ENOMEM;
+
+	fanotify_get_event(event);
+
+
+	mutex_lock(&group->notification_mutex);
+	spin_lock(&event->holder_spinlock);
+	holder->event = event;
+	list_add_tail(&holder->event_list, &group->notification_list);
+	spin_unlock(&event->holder_spinlock);
+	mutex_unlock(&group->notification_mutex);
+
+
+	wake_up(&group->notification_waitq);
+
+	return 0;
+}
+
+/*
+ * must be called with group->notification_mutex held and must know event is present.
+ * it is the responsibility of the caller to call put_event() on the returned
+ * structure
+ */
+struct fanotify_event *remove_event_from_group_notification(struct fanotify_group *group)
+{
+	struct fanotify_event *event;
+	struct fanotify_event_holder *holder;
+
+	holder = list_first_entry(&group->notification_list, struct fanotify_event_holder, event_list);
+
+	event = holder->event;
+
+	spin_lock(&event->holder_spinlock);
+	holder->event = NULL;
+	/*
+	 * be sure you are done with holder, since after this point it
+	 * could be reused in another group
+	 */
+	list_del_init(&holder->event_list);
+	spin_unlock(&event->holder_spinlock);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (event != (struct fanotify_event *)holder)
+		fanotify_destroy_event_holder(holder);
+
+	return event;
+}
+
+void fanotify_notification_clear_group(struct fanotify_group *group)
+{
+	struct fanotify_event *event;
+
+	while (fanotify_check_notif_queue(group)) {
+		event = remove_event_from_group_notification(group);
+		fanotify_put_event(event);
+		/* fanotify_check_notif_queue() took this lock */
+		mutex_unlock(&group->notification_mutex);
+	}
+}
+
+struct fanotify_event *create_event(struct file *file, unsigned int mask)
+{
+	struct fanotify_event *event;
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
+	event->path.dentry = file->f_path.dentry;
+	event->path.mnt = file->f_path.mnt;
+	path_get(&event->path);
+
+	event->mask = mask;
+
+	WARN_ON(!event->path.dentry);
+	WARN_ON(!event->path.mnt);
+
+	return event;
+}
+
+int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock)
+{
+	int rc;
+	int client_fd;
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+	struct file *new_file;
+
+	struct fanotify_event *event;
+
+	memset(data, 0, sizeof(struct fanotify_event_metadata));
+
+	/* get a notification off the queue blocking if we can/should */
+	if (fanotify_check_notif_queue(group)) {
+		event = remove_event_from_group_notification(group);
+		mutex_unlock(&group->notification_mutex);
+	} else {
+		if (nonblock)
+			return -EAGAIN;
+		rc = wait_event_interruptible(group->notification_waitq, fanotify_check_notif_queue(group));
+		if (!rc) {
+			event = remove_event_from_group_notification(group);
+			mutex_unlock(&group->notification_mutex);
+		} else {
+			return rc;
+		}
+	}
+
+	BUG_ON(!event);
+
+	client_fd = get_unused_fd();
+	if (client_fd < 0)
+		return client_fd;
+
+	/*
+	 * we need a new file handle for the userspace program so it can read even if it was
+	 * originally opened O_WRONLY.
+	 */
+	dentry = dget(event->path.dentry);
+	mnt = mntget(event->path.mnt);
+	new_file = dentry_open(dentry, mnt, O_RDONLY);
+	if (IS_ERR(new_file)) {
+		/*
+		 * we still send an event even if we can't open the file.  this
+		 * can happen for say tasks are gone and we try to open their
+		 * /proc entries or we try to open a WRONLY file like in sysfs
+		 * we just send the errno to userspace since there isn't much
+		 * else we can do.
+		 */
+		put_unused_fd(client_fd);
+		client_fd = PTR_ERR(new_file);
+	} else {
+		fd_install(client_fd, new_file);
+	}
+
+	data->fd = client_fd;
+	data->mask = event->mask;
+
+	fanotify_put_event(event);
+
+	return 0;
+}
+
+__init int fanotify_notification_uninit(void)
+{
+	kmem_cache_destroy(event_kmem_cache);
+	event_kmem_cache = NULL;
+	kmem_cache_destroy(event_holder_kmem_cache);
+	event_holder_kmem_cache = NULL;
+
+	return 0;
+}
+
+__init int fanotify_notification_init(void)
+{
+	event_kmem_cache = kmem_cache_create("fanotify_event", sizeof(struct fanotify_event), 0, SLAB_PANIC, NULL);
+	event_holder_kmem_cache = kmem_cache_create("fanotify_event_holder", sizeof(struct fanotify_event_holder), 0, SLAB_PANIC, NULL);
+
+	return 0;
+}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e531783..9f6d7d9 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -246,6 +246,7 @@ unifdef-y += inet_diag.h
 unifdef-y += in.h
 unifdef-y += in6.h
 unifdef-y += inotify.h
+unifdef-y += fanotify.h
 unifdef-y += input.h
 unifdef-y += ip.h
 unifdef-y += ipc.h
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
new file mode 100644
index 0000000..7f1179e
--- /dev/null
+++ b/include/linux/fanotify.h
@@ -0,0 +1,95 @@
+/*
+ * Filesystem access notification for Linux
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ * Basis of file stolen from inotify.h
+ */
+
+#ifndef _LINUX_FANOTIFY_H
+#define _LINUX_FANOTIFY_H
+
+/* the following events that user-space can register for */
+#define FAN_ACCESS		0x00000001	/* File was accessed */
+#define FAN_MODIFY		0x00000002	/* File was modified */
+#define FAN_CLOSE_NOWRITE	0x00000004	/* Unwrittable file closed */
+#define FAN_CLOSE_WRITE		0x00000008	/* Writtable file closed */
+#define FAN_OPEN		0x00000010	/* File was opened */
+
+/* FIXME currently Q's have no limit.... */
+#define FAN_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
+
+/* helper events */
+#define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
+
+/*
+ * All of the events - we build the list by hand so that we can add flags in
+ * the future and not break backward compatibility.  Apps will get only the
+ * events that they originally wanted.  Be sure to add new events here!
+ */
+#define FAN_ALL_EVENTS	(FAN_ACCESS |\
+			 FAN_MODIFY |\
+			 FAN_CLOSE |\
+			 FAN_OPEN)
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#include <sys/types.h>
+#endif
+
+struct fanotify_event_metadata {
+	int32_t fd;
+	uint32_t mask;
+};
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+
+#include <asm/atomic.h>
+
+struct fanotify_group {
+	struct list_head group_list;	/* list of all groups on the system */
+	unsigned int group_num;		/* the 'name' of the event */
+	unsigned int mask;			/* mask of events this group cares about */
+	atomic_t refcnt;		/* num of processes with a special file open */
+
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;/* protect the notification_list */
+	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+};
+
+#ifdef CONFIG_FANOTIFY
+
+extern void fanotify(struct file *file, unsigned int mask);
+
+extern void fanotify_get_group(struct fanotify_group *group);
+extern struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask);
+extern void fanotify_put_group(struct fanotify_group *group);
+#else
+
+static inline void fanotify(struct file *file, unsigned int mask)
+{}
+
+static inline void fanotify_get_group(struct fanotify_group *group)
+{}
+
+static inline struct fanotify_group *fanotify_find_group(unsigned int group_num, unsigned int mask)
+{
+	return NULL;
+}
+
+static inline extern void fanotify_put_group(struct fanotify_group *group)
+{}
+
+#endif	/* CONFIG_FANOTIFY */
+
+#endif	/* __KERNEL __ */
+
+#endif	/* _LINUX_FANOTIFY_H */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index dec1afb..3a1b0dc 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -13,6 +13,7 @@
 
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
+#include <linux/fanotify.h>
 #include <linux/audit.h>
 
 /*
@@ -148,6 +149,7 @@ static inline void fsnotify_access(struct file *file)
 	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	fanotify(file, FAN_ACCESS);
 }
 
 /*
@@ -165,6 +167,7 @@ static inline void fsnotify_modify(struct file *file)
 	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	fanotify(file, FAN_MODIFY);
 }
 
 /*
@@ -181,6 +184,7 @@ static inline void fsnotify_open(struct file *file)
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	fanotify(file, FAN_OPEN);
 }
 
 /*
@@ -192,13 +196,15 @@ static inline void fsnotify_close(struct file *file)
 	struct inode *inode = dentry->d_inode;
 	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
-	u32 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	u32 in_mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	u32 fan_mask = (mode & FMODE_WRITE) ? FAN_CLOSE_WRITE : FAN_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		in_mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, in_mask, 0, name);
+	inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
+	fanotify(file, fan_mask);
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 295b7c7..7e889f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1538,6 +1538,7 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_NOFACCESS	0x00000020	/* exclude from all faccesses */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */

