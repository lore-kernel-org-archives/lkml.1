Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYIZVSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYIZVSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYIZVSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:18:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYIZVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:18:33 -0400
Subject: [RFC 3/11] fanotify: fscking all notify, system wide file access
	notification
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:18:24 -0400
Message-Id: <1222463904.2872.212.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: fscking all notify, system wide file access notification

From: Eric Paris <eparis@redhat.com>

A new system wide file access notification system.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Kconfig             |   14 ++
 fs/notify/Makefile            |    2 
 fs/notify/fanotify.c          |  117 ++++++++++++++++++++
 fs/notify/fanotify.h          |   87 +++++++++++++++
 fs/notify/group.c             |  153 ++++++++++++++++++++++++++
 fs/notify/group_user.c        |  156 +++++++++++++++++++++++++++
 fs/notify/notification.c      |  167 +++++++++++++++++++++++++++++
 fs/notify/notification_user.c |  239 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fanotify.h      |   53 +++++++++
 include/linux/fsnotify.h      |   14 ++
 include/linux/sched.h         |    1 
 11 files changed, 999 insertions(+), 4 deletions(-)
 create mode 100644 fs/notify/fanotify.c
 create mode 100644 fs/notify/fanotify.h
 create mode 100644 fs/notify/group.c
 create mode 100644 fs/notify/group_user.c
 create mode 100644 fs/notify/notification.c
 create mode 100644 fs/notify/notification_user.c
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
index 882ecf9..21ca1da 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
+
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o notification_user.o group.o group_user.o
diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
new file mode 100644
index 0000000..d3ee8d1
--- /dev/null
+++ b/fs/notify/fanotify.c
@@ -0,0 +1,117 @@
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
+	if (likely(list_empty(&groups)))
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
+	idx = srcu_read_lock(&groups_srcu_struct);
+	list_for_each_entry_rcu(group, &groups, group_list) {
+		if (mask & group->mask) {
+			if (!event) {
+				event = create_event(file, mask);
+				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
+				if (!event)
+					break;
+			}
+			add_event_to_group_notification(group, event);
+		}
+	}
+	srcu_read_unlock(&groups_srcu_struct, idx);
+	/*
+	 * create_event() take a reference so the event can't be cleaned up while
+	 * we are still trying to add it to lists
+	 */
+	if (event)
+		put_event(event);
+}
+EXPORT_SYMBOL_GPL(fanotify);
+
+
+static __init int fanotify_init(void)
+{
+	int rc;
+
+	fanotify_fs_root = securityfs_create_dir("fanotify", NULL);
+	if (IS_ERR(fanotify_fs_root)) {
+		printk(KERN_ERR "fanotify: failed to create root directory: %ld\n", PTR_ERR(fanotify_fs_root));
+		return PTR_ERR(fanotify_fs_root);
+	}
+
+	rc = fanotify_register_init();
+	if (rc) {
+		securityfs_remove(fanotify_fs_root);
+		fanotify_fs_root = NULL;
+		return rc;
+	}
+
+	rc = fanotify_notification_init();
+	if (rc) {
+		fanotify_register_uninit();
+		securityfs_remove(fanotify_fs_root);
+		fanotify_fs_root = NULL;
+		return rc;
+	}
+
+	return 0;
+}
+__initcall(fanotify_init);
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
new file mode 100644
index 0000000..d6bc0c0
--- /dev/null
+++ b/fs/notify/fanotify.h
@@ -0,0 +1,87 @@
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
+#include <linux/types.h>
+#include <linux/wait.h>
+
+struct fanotify_group {
+	struct list_head group_list;	/* list of all groups on the system */
+	unsigned int mask;		/* mask of events this group cares about */
+	atomic_t num_clients;		/* num of processes with a special file open */
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;/* protect the notification_list */
+	struct list_head notification_list; /* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq; /* read() on the notification file blocks on this waitq */
+
+	char *name;			/* group name used for register/unregister matching */
+	struct dentry *subdir;		/* pointer to fanotify/name dentry */
+	struct dentry *notification;	/* pointer to fanotify/name/notification dentry */
+};
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
+	struct path path;	/* path from the original access */
+	unsigned int mask;	/* the type of access */
+	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+};
+
+extern struct dentry *fanotify_fs_root;
+extern struct mutex groups_mutex;
+extern struct srcu_struct groups_srcu_struct;
+extern struct list_head groups;
+
+extern __init int fanotify_register_init(void);
+extern __init int fanotify_register_uninit(void);
+
+extern int fanotify_notification_user_destroy(struct fanotify_group *group);
+extern int fanotify_notification_user_create(struct fanotify_group *group);
+
+extern int check_notification_queue(struct fanotify_group *group);
+extern void get_event(struct fanotify_event *event);
+extern void put_event(struct fanotify_event *event);
+extern int add_event_to_group_notification(struct fanotify_group *group, struct fanotify_event *event);
+extern struct fanotify_event *remove_event_from_group_notification(struct fanotify_group *group);
+extern struct fanotify_event *create_event(struct file *file, unsigned int mask);
+extern struct fanotify_event_holder *alloc_event_holder(void);
+extern void destroy_event_holder(struct fanotify_event_holder *holder);
+extern __init int fanotify_notification_init(void);
+extern __init int fanotify_notification_uninit(void);
+
+extern void fanotify_get_group(struct fanotify_group *group);
+extern void fanotify_put_group(struct fanotify_group *group);
+extern int fanotify_register_group(char *name, unsigned int mask);
+extern int fanotify_unregister_group(char *name, unsigned int mask);
+#endif	/* _LINUX_FANOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
new file mode 100644
index 0000000..a7a4d7f
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
+DEFINE_MUTEX(groups_mutex);
+struct srcu_struct groups_srcu_struct;
+LIST_HEAD(groups);
+
+void fanotify_get_group(struct fanotify_group *group)
+{
+	atomic_inc(&group->num_clients);
+}
+
+void fanotify_kill_group(struct fanotify_group *group)
+{
+	fanotify_notification_user_destroy(group);
+
+	securityfs_remove(group->subdir);
+	group->subdir = NULL;
+
+	kfree(group->name);
+	group->name = NULL;
+	kfree(group);
+}
+
+void fanotify_put_group(struct fanotify_group *group)
+{
+	if (atomic_dec_and_test(&group->num_clients)) {
+		struct fanotify_event *event;
+		while (!atomic_read(&group->num_clients) && check_notification_queue(group)) {
+			event = remove_event_from_group_notification(group);
+			put_event(event);
+			/* check_notification_queue() took this lock */
+			mutex_unlock(&group->notification_mutex);
+		}
+	}
+	return;
+}
+
+int fanotify_register_group(char *name, unsigned int mask)
+{
+	struct dentry *subdir;
+	struct fanotify_group *group, *group_iter;
+	int rc = -ENOMEM;
+
+	mutex_lock(&groups_mutex);
+	list_for_each_entry_rcu(group_iter, &groups, group_list) {
+		if (!strcmp(name, group_iter->name)) {
+			mutex_unlock(&groups_mutex);
+			return -EEXIST;
+		}
+	}
+
+	group = kmalloc(sizeof(struct fanotify_group), GFP_KERNEL);
+	if (!group)
+		goto out;
+
+	group->name = kstrdup(name, GFP_KERNEL);
+	if (!group->name)
+		goto out;
+
+	atomic_set(&group->num_clients, 0);
+
+	group->mask = mask;
+
+	/* create sub-directory for this group. */
+	subdir = securityfs_create_dir(name, fanotify_fs_root);
+	if (IS_ERR(subdir)) {
+		rc = PTR_ERR(subdir);
+		goto out_free_name;
+	}
+
+	group->subdir = subdir;
+
+	rc = fanotify_notification_user_create(group);
+	if (rc)
+		goto out_clean_subdir;
+
+	/* add it */
+	list_add_rcu(&group->group_list, &groups);
+	mutex_unlock(&groups_mutex);
+
+	return 0;
+
+out_clean_subdir:
+	securityfs_remove(subdir);
+out_free_name:
+	kfree(group->name);
+out:
+	kfree(group);
+	return rc;
+}
+
+int fanotify_unregister_group(char *name, unsigned int mask)
+{
+	int found = 0;
+	struct fanotify_group *group;
+
+	mutex_lock(&groups_mutex);
+	list_for_each_entry_rcu(group, &groups, group_list) {
+		if (!strcmp(group->name, name) && (group->mask == mask)) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found && !atomic_read(&group->num_clients))
+		list_del_rcu(&group->group_list);
+	mutex_unlock(&groups_mutex);
+
+	if (!found)
+		return -EINVAL;
+
+	if (atomic_read(&group->num_clients))
+		return -EBUSY;
+
+	synchronize_srcu(&groups_srcu_struct);
+
+	fanotify_kill_group(group);
+
+	return 0;
+}
diff --git a/fs/notify/group_user.c b/fs/notify/group_user.c
new file mode 100644
index 0000000..49ba712
--- /dev/null
+++ b/fs/notify/group_user.c
@@ -0,0 +1,156 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+static struct dentry *d_register;
+static struct dentry *d_unregister;
+
+static ssize_t fanotify_register_write(struct file *file, const char __user *buf, size_t lenp, loff_t *offset)
+{
+	char *p;
+	char *group_name;
+	unsigned int mask;
+	int rc = 0;
+
+	p = simple_transaction_get(file, buf, lenp);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	group_name = kzalloc(lenp, GFP_KERNEL);
+	if (!group_name) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = sscanf(p, "%s %x\n", group_name, &mask);
+	if (rc != 2) {
+		if (rc >= 0)
+			rc = -EPROTO;
+		goto out;
+	}
+
+	// FIXME do mask validation
+	rc = fanotify_register_group(group_name, mask);
+	if (rc)
+		goto out;
+
+	rc = lenp;
+
+out:
+	kfree(group_name);
+	return rc;
+}
+
+static ssize_t fanotify_unregister_write(struct file *file, const char __user *buf, size_t lenp, loff_t *offset)
+{
+	char *p;
+	char *group_name;
+	unsigned int mask;
+	int rc = 0;
+
+	group_name = kzalloc(lenp, GFP_KERNEL);
+	if (!group_name)
+		return -ENOMEM;
+
+	p = simple_transaction_get(file, buf, lenp);
+	if (IS_ERR(p)) {
+		rc = PTR_ERR(p);
+		goto out;
+	}
+
+	rc = sscanf(p, "%s %x\n", group_name, &mask);
+	if (rc != 2) {
+		if (rc >= 0)
+			rc = -EPROTO;
+		goto out;
+	}
+
+	rc = fanotify_unregister_group(group_name, mask);
+	if (rc)
+		goto out;
+
+	return lenp;
+out:
+	kfree(group_name);
+	return rc;
+}
+
+static struct file_operations fanotify_register_fops = {
+	.write =	fanotify_register_write,
+	.release = 	simple_transaction_release,
+};
+
+static struct file_operations fanotify_unregister_fops = {
+	.write =	fanotify_unregister_write,
+	.release = 	simple_transaction_release,
+};
+
+__init int fanotify_register_uninit(void)
+{
+	if (d_register);
+		securityfs_remove(d_register);
+	d_register = NULL;
+
+	if (d_unregister);
+		securityfs_remove(d_unregister);
+	d_unregister = NULL;
+
+	cleanup_srcu_struct(&groups_srcu_struct);
+
+	return 0;
+}
+__init int fanotify_register_init(void)
+{
+	d_register = securityfs_create_file("register", S_IRUSR|S_IWUSR, fanotify_fs_root, NULL, &fanotify_register_fops);
+	if (IS_ERR(d_register)) {
+		printk(KERN_ERR "fanotify: failed to create register file: %ld\n", PTR_ERR(d_register));
+		fanotify_register_uninit();
+		return PTR_ERR(d_register);
+	}
+
+	d_unregister = securityfs_create_file("unregister", S_IRUSR|S_IWUSR, fanotify_fs_root, NULL, &fanotify_unregister_fops);
+	if (IS_ERR(d_unregister)) {
+		printk(KERN_ERR "fanotify: failed to create unregister file: %ld\n", PTR_ERR(d_unregister));
+		securityfs_remove(d_register);
+		return PTR_ERR(d_unregister);
+	}
+
+	init_srcu_struct(&groups_srcu_struct);
+
+	return 0;
+}
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
new file mode 100644
index 0000000..8f4f439
--- /dev/null
+++ b/fs/notify/notification.c
@@ -0,0 +1,167 @@
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
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
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
+int check_notification_queue(struct fanotify_group *group)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&group->notification_list))
+		return 1;
+	mutex_unlock(&group->notification_mutex);
+	return 0;
+}
+
+void get_event(struct fanotify_event *event)
+{
+	atomic_inc(&event->refcnt);
+}
+
+void put_event(struct fanotify_event *event)
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
+void destroy_event_holder(struct fanotify_event_holder *holder)
+{
+	kmem_cache_free(event_holder_kmem_cache, holder);
+}
+
+int add_event_to_group_notification(struct fanotify_group *group, struct fanotify_event *event)
+{
+	struct fanotify_event_holder *holder;
+
+	if (!atomic_read(&group->num_clients))
+		return 0;
+
+	if (list_empty(&event->holder.event_list))
+		holder = (struct fanotify_event_holder *)event;
+	else
+		holder = alloc_event_holder();
+	if (!holder)
+		return -ENOMEM;
+
+	get_event(event);
+	holder->event = event;
+
+	mutex_lock(&group->notification_mutex);
+	list_add_tail(&holder->event_list, &group->notification_list);
+	mutex_unlock(&group->notification_mutex);
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
+	holder->event = NULL;
+	/*
+	 * be sure you are done with holder, since after this point it
+	 * could be reused in another group
+	 */
+	list_del_init(&holder->event_list);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (event != (struct fanotify_event *)holder)
+		destroy_event_holder(holder);
+
+	return event;
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
diff --git a/fs/notify/notification_user.c b/fs/notify/notification_user.c
new file mode 100644
index 0000000..4cea5f2
--- /dev/null
+++ b/fs/notify/notification_user.c
@@ -0,0 +1,239 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+/*
+ * MAX_MESG_LEN is calculated by hand based on the snprintf below. PLEASE
+ * UPDATE ME IF YOU CHANGE THE SNPRINTF !!!!!111111oneone11!!!!!!!
+ *
+ *    %d  = 11 characters
+ *    %ld = 19 characters
+ *    %x  = 8 characters
+ *
+ * "fd=%d "	= 15 characters
+ * "mask=%x "	= 14 characters
+ * "\n "	=  2 characters
+ * NULL		=  1 character
+ * 
+ * MAX_MESG_LEN = 32
+ */
+#define MAX_MESG_LEN 32
+
+static ssize_t fanotify_notification_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
+{
+	struct fanotify_group *group = file->f_path.dentry->d_inode->i_private;
+	struct file *new_file;
+	struct fanotify_event *event = NULL;
+	int client_fd;
+	int len, rc = 0;
+	char *output;
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+
+	BUG_ON(!group);
+
+	if (unlikely(!lenp))
+		return 0;
+
+	/* make sure lenp can hold the whole message */
+	if (lenp < MAX_MESG_LEN)
+		return -ENOMEM;
+
+	if (lenp > PAGE_SIZE)
+		lenp = PAGE_SIZE;
+
+	output = kmalloc(lenp, GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
+
+	if (check_notification_queue(group)) {
+		event = remove_event_from_group_notification(group);
+		mutex_unlock(&group->notification_mutex);
+	} else {
+		if (file->f_flags & O_NONBLOCK) {
+			rc = -EAGAIN;
+			goto out;
+		}
+		rc = wait_event_interruptible(group->notification_waitq, check_notification_queue(group));
+		if (!rc) {
+			event = remove_event_from_group_notification(group);
+			mutex_unlock(&group->notification_mutex);
+		} else {
+			/* we took a signal waiting.... */
+			goto out;
+		}
+	}
+
+	BUG_ON(!event);
+
+	client_fd = get_unused_fd();
+	if (client_fd < 0) {
+		rc = client_fd;
+		goto out;
+	}
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
+	/*
+	 * Build metadata string to send to the listener
+	 * IF YOU CHANGE THIS STRING UPDATE MAX_MSG_LEN!!!!!!11111!!!!
+	 */
+	rc = snprintf(output, lenp-1, "fd=%d mask=%x\n", client_fd, event->mask);
+	if (rc < 0)
+		goto out;
+	output[rc] = '\0';
+	len = rc + 1;
+
+	rc = copy_to_user(buf, output, len);
+	if (!rc)
+		rc = len;
+out:
+	put_event(event);
+	kfree(output);
+	return rc;
+}
+
+static unsigned int fanotify_notification_poll(struct file *file, struct poll_table_struct *polltbl)
+{
+	struct fanotify_group *group = file->f_path.dentry->d_inode->i_private;
+	int ret = 0;
+
+	BUG_ON(!group);
+
+	poll_wait(file, &group->notification_waitq, polltbl);
+	if (check_notification_queue(group)) {
+		ret = POLLIN | POLLRDNORM;
+		mutex_unlock(&group->notification_mutex);
+	}
+
+	return ret;
+}
+
+static int fanotify_notification_open(struct inode *inode, struct file *file)
+{
+	struct fanotify_group *fgroup = inode->i_private;
+	struct fanotify_group *lgroup;
+	struct task_struct *tsk = current;
+	int found = 0;
+
+	/*
+	 * we can't trust fgroup as this open might be simultaneous with an
+	 * unregister.  Since unregister is done with the mutex and makes
+	 * sure there are no users if we get() the group under a mutex it
+	 * can't disappear under us.
+	 */
+	mutex_lock(&groups_mutex);
+	list_for_each_entry(lgroup, &groups, group_list) {
+		if (lgroup == fgroup) {
+			tsk->flags |= PF_NOFACCESS;
+			fanotify_get_group(lgroup);
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&groups_mutex);
+
+	if (!found)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fanotify_notification_release(struct inode *inode, struct file *file)
+{
+	struct fanotify_group *group = inode->i_private;
+	struct task_struct *tsk = current;
+
+	BUG_ON(!group);
+
+	fanotify_put_group(group);
+	tsk->flags &= ~PF_NOFACCESS;
+
+	return 0;
+}
+
+static struct file_operations notification_fops = {
+	.open =		fanotify_notification_open,
+	.release =	fanotify_notification_release,
+	.read =		fanotify_notification_read,
+	.poll =		fanotify_notification_poll
+};
+
+int fanotify_notification_user_destroy(struct fanotify_group *group)
+{
+	securityfs_remove(group->notification);
+	group->notification = NULL;
+
+	return 0;
+}
+
+int fanotify_notification_user_create(struct fanotify_group *group)
+{
+	struct dentry *notification_file;
+
+	group->notification = NULL;
+
+	notification_file = securityfs_create_file("notification", S_IRUSR|S_IWUSR, group->subdir, group, &notification_fops);
+	if (IS_ERR(notification_file))
+		return PTR_ERR(notification_file);
+
+	group->notification = notification_file;
+
+	/* initialize the notification list elements */
+	INIT_LIST_HEAD(&group->notification_list);
+	mutex_init(&group->notification_mutex);
+	init_waitqueue_head(&group->notification_waitq);
+
+	return 0;
+}
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
new file mode 100644
index 0000000..16ff769
--- /dev/null
+++ b/include/linux/fanotify.h
@@ -0,0 +1,53 @@
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
+#define FAN_CLOSE_WRITE		0x00000004	/* Writtable file was closed */
+#define FAN_CLOSE_NOWRITE	0x00000008	/* Unwrittable file closed */
+#define FAN_OPEN		0x00000010	/* File was opened */
+
+/* FIXME currently Q's have no limit.... */
+#define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
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
+			 FAN_CLOSE_WRITE |\
+			 FAN_CLOSE_NOWRITE |\
+			 FAN_OPEN)
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+#ifdef CONFIG_FANOTIFY
+
+extern void fanotify(struct file *file, unsigned int mask);
+
+#else
+
+static inline void fanotify(struct file *file, unsigned int mask)
+{}
+
+#endif	/* CONFIG_FANOTIFY */
+
+#endif	/* __KERNEL __ */
+
+#endif	/* _LINUX_FANOTIFY_H */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index dd76948..50d8d8b 100644
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
 	mode_t mode = file->f_mode;
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
index 3d9120c..101bff4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1488,6 +1488,7 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_NOFACCESS	0x00000020	/* exclude from all faccesses */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
 #define PF_DUMPCORE	0x00000200	/* dumped core */


