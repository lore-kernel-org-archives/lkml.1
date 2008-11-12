Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYKLQOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYKLQOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYKLQMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbYKLQL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:59 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 10/21] fanotify: blocking and access granting
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:19 -0500
Message-ID: <20081112161119.25434.18918.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces blocking an access granting for fanotify.  Events are
sent to userspace and the original process is blocked (assuming not
O_NONBLOCK) for at most the amount of time determined by the group.  Total
maximum blocking time is the sum of all groups possible blocking time.

O_NONBLOCK processes trying to read and a group registered to require
blocking/access control on read MUST have a fastpath entry in order to ever
make progress.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/aio.c                 |    7 ++
 fs/notify/Makefile       |    2 -
 fs/notify/access.c       |  164 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/notify/fanotify.c     |   46 +++++++++++--
 fs/notify/fanotify.h     |   17 ++++-
 fs/notify/group.c        |    8 ++
 fs/notify/notification.c |    2 +
 fs/open.c                |    5 +
 fs/read_write.c          |    6 ++
 include/linux/fanotify.h |   35 +++++++++-
 10 files changed, 278 insertions(+), 14 deletions(-)
 create mode 100644 fs/notify/access.c

diff --git a/fs/aio.c b/fs/aio.c
index f658441..008de79 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/eventfd.h>
+#include <linux/fanotify.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -1454,6 +1455,9 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
+		ret = fanotify(file, FAN_ACCESS_PERM);
+		if (unlikely(ret))
+			break;
 		ret = aio_setup_single_vector(kiocb);
 		if (ret)
 			break;
@@ -1486,6 +1490,9 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
+		ret = fanotify(file, FAN_ACCESS_PERM);
+		if (unlikely(ret))
+			break;
 		ret = aio_setup_vectored_rw(READ, kiocb);
 		if (ret)
 			break;
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 90cb910..0af890a 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
 
-obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o group.o fastpath.o
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o group.o fastpath.o access.o
diff --git a/fs/notify/access.c b/fs/notify/access.c
new file mode 100644
index 0000000..6a2606c
--- /dev/null
+++ b/fs/notify/access.c
@@ -0,0 +1,164 @@
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
+int fanotify_add_event_to_access(struct fanotify_group *group, struct fanotify_event *event)
+{
+	struct fanotify_event_holder *holder;
+
+	if (list_empty(&event->holder.event_list))
+		holder = (struct fanotify_event_holder *)event;
+	else
+		holder = alloc_event_holder();
+	if (!holder)
+		return -ENOMEM;
+
+	fanotify_get_event(event);
+
+	mutex_lock(&group->access_mutex);
+	spin_lock(&event->holder_spinlock);
+	holder->event = event;
+	list_add_tail(&holder->event_list, &group->access_list);
+	spin_unlock(&event->holder_spinlock);
+	mutex_unlock(&group->access_mutex);
+
+	return 0;
+}
+
+int fanotify_get_response_from_access(struct fanotify_group *group, struct fanotify_event *event)
+{
+	int ret;
+	ret = wait_event_interruptible_timeout(group->access_waitq,
+						event->response,
+						msecs_to_jiffies(5000));
+	/* Timeout or signal? */
+	if (ret <= 0) {
+		struct fanotify_event_holder *holder;
+
+		/* pull the event off the access_list */
+		mutex_lock(&group->access_mutex);
+		list_for_each_entry(holder, &group->access_list, event_list) {
+			if (holder->event != event)
+				continue;
+
+			spin_lock(&event->holder_spinlock);
+			holder->event = NULL;
+			/* as soon as we do this the event.holder might get reused */
+			list_del_init(&holder->event_list);
+			spin_unlock(&event->holder_spinlock);
+
+			if (event != (struct fanotify_event *)holder)
+				fanotify_destroy_event_holder(holder);
+			fanotify_put_event(event);
+			break;
+		}
+		mutex_unlock(&group->access_mutex);
+
+		/*
+		 * if we took a signal, return ERESTARTSYS
+		 * if we timed out userspace is broken so return ALLOW
+		 */
+		return ret;
+	}
+
+	/* userspace responded, convert to something usable */
+	switch (event->response) {
+	case FAN_ALLOW:
+		return 0;
+	case FAN_DENY:
+	default:
+		return -EPERM;
+	}
+}
+
+int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response)
+{
+	struct fanotify_event *event = NULL;
+	struct fanotify_event_holder *holder;
+
+	/*
+	 * make sure the response is valid, if invalid we do nothing and either
+	 * userspace can send a valid responce or we will clean it up after the
+	 * timeout
+	 */
+	if (response & ~(FAN_ALLOW | FAN_DENY))
+		return -EINVAL;
+
+	mutex_lock(&group->access_mutex);
+	list_for_each_entry(holder, &group->access_list, event_list) {
+		if (holder->event->cookie != cookie)
+			continue;
+
+		event = holder->event;
+		spin_lock(&event->holder_spinlock);
+		holder->event = NULL;
+		/* as soon as we do this the event.holder might be reused */
+		list_del_init(&holder->event_list);
+		spin_unlock(&event->holder_spinlock);
+
+		if (event != (struct fanotify_event *)holder)
+			fanotify_destroy_event_holder(holder);
+		break;
+	}
+	mutex_unlock(&group->access_mutex);
+
+	if (!event)
+		return -ENOENT;
+
+	event->response = response;
+	wake_up(&group->access_waitq);
+	fanotify_put_event(event);
+
+	return 0;
+}
+
+void fanotify_access_clear_group(struct fanotify_group *group)
+{
+	struct fanotify_event *event = NULL;
+	struct fanotify_event_holder *holder;
+
+	mutex_lock(&group->access_mutex);
+	list_for_each_entry(holder, &group->access_list, event_list) {
+		event = holder->event;
+		spin_lock(&event->holder_spinlock);
+		holder->event = NULL;
+		/* as soon as we do this the event.holder might be reused */
+		list_del_init(&holder->event_list);
+		spin_unlock(&event->holder_spinlock);
+
+		if (event != (struct fanotify_event *)holder)
+			fanotify_destroy_event_holder(holder);
+
+		event->response = FAN_ALLOW;
+		wake_up(&group->access_waitq);
+		fanotify_put_event(event);
+	}
+	mutex_unlock(&group->access_mutex);
+}
diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
index aa12e91..d995c14 100644
--- a/fs/notify/fanotify.c
+++ b/fs/notify/fanotify.c
@@ -44,22 +44,22 @@ void fanotify_inode_delete(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(fanotify_inode_delete);
 
-void fanotify(struct file *file, unsigned int mask)
+int fanotify(struct file *file, unsigned int mask)
 {
 	struct fanotify_group *group;
 	struct fanotify_event *event = NULL;
 	struct task_struct *tsk = current;
 	struct inode *inode = file->f_path.dentry->d_inode;
-	int idx;
+	int idx, ret = 0;
 
 	if (likely(list_empty(&fanotify_groups)))
-		return;
+		return 0;
 
 	if (tsk->flags & PF_NOFACCESS)
-		return;
+		return 0;
 
 	if (!S_ISREG(inode->i_mode))
-		return;
+		return 0;
 
 	if (mask & FAN_MODIFY)
 		fanotify_fastpath_clear(inode);
@@ -86,7 +86,39 @@ void fanotify(struct file *file, unsigned int mask)
 				if (!event)
 					break;
 			}
-			fanotify_add_event_to_notif(group, event);
+			if (mask & FAN_ALL_EVENTS_PERM) {
+				/*
+				 * if you register for READ_ACCESS you MUST be setting
+				 * fastpath events or the client will NEVER make progress.
+				 * open is a blocking event so we don't require fastpath
+				 * entries and will wait for a decision.
+				 *
+				 * someday we could do an add_timer here, schedule a workqueue,
+				 * and in there we could check to see if this file got a fastpath
+				 * groups which don't obey the protocol could be evicted or an
+				 * O_NONBLOCK exclusion added.  There are some locking and
+				 * security implications to doing it that way, so for now we
+				 * are just going to assume userspace is adding fastpaths for
+				 * O_NONBLOCK files.....
+				 */
+				if ((mask & FAN_ACCESS_PERM) && (file->f_flags & O_NONBLOCK)) {
+					fanotify_add_event_to_notif(group, event);
+					ret = -EWOULDBLOCK;
+					break;
+				}
+				event->cookie = atomic_long_inc_return(&group->cookie);
+				event->response = 0;
+				/* put on access_list first so userspace can't be so fast responding it isn't on the list yet */
+				fanotify_add_event_to_access(group, event);
+
+				fanotify_add_event_to_notif(group, event);
+
+				ret = fanotify_get_response_from_access(group, event);
+				if (ret)
+					break;
+			} else {
+				fanotify_add_event_to_notif(group, event);
+			}
 		}
 	}
 	srcu_read_unlock(&fanotify_grp_srcu_struct, idx);
@@ -96,6 +128,8 @@ void fanotify(struct file *file, unsigned int mask)
 	 */
 	if (event)
 		fanotify_put_event(event);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fanotify);
 
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index bcc3f4b..6423af1 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -14,12 +14,14 @@
 #include <linux/wait.h>
 
 /*
- * A single event can be queued in multiple group->notification_lists.
+ * A single event can be queued in multiple group->notification_lists and to at
+ * most one group->access_list at the same time.
  *
- * each group->notification_list will point to an event_holer which in turns points
- * to the actual event that needs to be sent to userspace.
+ * each group->notification_list or group->access_list will point to an
+ * event_holer which in turns points to the actual event that needs to be sent
+ * to userspace.
  *
- * Seemed cheaper to create a refcnt'd event and a small holder for every group
+ * Seemed cheaper to create a refcnt'd event and a small holder for every list
  * than create a different event for every group
  * 
  */
@@ -44,6 +46,9 @@ struct fanotify_event {
 	struct path path;	/* path from the original access */
 	unsigned int mask;	/* the type of access */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+	/* if waiting for a userspace access answer this is the cookie they will send back */
+	unsigned long cookie;
+	unsigned int response;	/* userspace answer to question */
 };
 
 /*
@@ -94,4 +99,8 @@ extern void fanotify_fastpath_clear(struct inode *inode);
 extern __init int fanotify_fastpath_init(void);
 extern __init int fanotify_fastpath_uninit(void);
 
+extern int fanotify_add_event_to_access(struct fanotify_group *group, struct fanotify_event *event);
+extern int fanotify_get_response_from_access(struct fanotify_group *group, struct fanotify_event *event);
+extern void fanotify_access_clear_group(struct fanotify_group *group);
+
 #endif	/* _LINUX_FANOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 37b8630..68f895e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -79,6 +79,11 @@ struct fanotify_group *fanotify_find_group(unsigned int priority, unsigned int g
 	mutex_init(&group->fastpath_mutex);
 	INIT_LIST_HEAD(&group->fastpath_entries);
 
+	atomic_set(&group->cookie, 0);
+	mutex_init(&group->access_mutex);
+	INIT_LIST_HEAD(&group->access_list);
+	init_waitqueue_head(&group->access_waitq);
+
 	/* Do we need to be the first entry? */
 	if (list_empty(&fanotify_groups)) {
 		list_add_rcu(&group->group_list, &fanotify_groups);
@@ -112,6 +117,9 @@ void fanotify_kill_group(struct fanotify_group *group)
 	/* clear all fastpath entries for this group */
 	fanotify_fastpath_clear_group(group);
 
+	/* set an allow for all outstanding access decisions */
+	fanotify_access_clear_group(group);
+
 	kfree(group);
 }
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 3dd69ef..89bb02c 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -176,6 +176,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->path.mnt = file->f_path.mnt;
 	path_get(&event->path);
 
+	event->cookie = 0;
 	event->mask = mask;
 
 	WARN_ON(!event->path.dentry);
@@ -241,6 +242,7 @@ int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event
 
 	data->fd = client_fd;
 	data->mask = event->mask;
+	data->cookie = event->cookie;
 
 	fanotify_put_event(event);
 
diff --git a/fs/open.c b/fs/open.c
index 9d69dd9..9a77834 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -29,6 +29,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/fanotify.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -820,6 +821,10 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	if (error)
 		goto cleanup_all;
 
+	error = fanotify(f, FAN_OPEN_PERM);
+	if (error)
+		goto cleanup_all;
+
 	if (!open && f->f_op)
 		open = f->f_op->open;
 	if (open) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 7eb2949..6f8cf69 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/fanotify.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -223,6 +224,11 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 				read_write == READ ? MAY_READ : MAY_WRITE);
 	if (retval)
 		return retval;
+	if (read_write == READ) {
+		retval = fanotify(file, FAN_ACCESS_PERM);
+		if (retval)
+			return retval;
+	}
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
 }
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index ae16b17..83c3d5e 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -17,6 +17,10 @@
 #define FAN_OPEN_NOEXEC		0x00000010	/* File was opened */
 #define FAN_OPEN_EXEC		0x00000020	/* File was opened with the intention of being exec'ed */
 
+/* userspace may also request blocking for permission checks for open and read */
+#define FAN_ACCESS_PERM		0x00000100
+#define FAN_OPEN_PERM		0x00000200
+
 /* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
 
@@ -33,6 +37,16 @@
 			 FAN_MODIFY |\
 			 FAN_CLOSE |\
 			 FAN_OPEN)
+/*
+ * Like the above list of events only these are the event types in which the
+ * kernel will wait for answers.
+ */
+#define FAN_ALL_EVENTS_PERM    (FAN_OPEN_PERM |\
+				FAN_ACCESS_PERM)
+
+/* answers will need to be either allow or deny */
+#define FAN_ALLOW		0x00000001
+#define FAN_DENY		0x00000002
 
 #include <linux/types.h>
 
@@ -48,6 +62,7 @@ struct fanotify_addr {
 struct fanotify_event_metadata {
 	__s32 fd;
 	__u32 mask;
+	__u64 cookie;
 }  __attribute__((packed));
 
 /* fanotify getsockopt optvals */
@@ -86,12 +101,18 @@ struct fanotify_group {
 	struct mutex fastpath_mutex;	/* protect fastpath_entries list */
 	struct list_head fastpath_entries; /* all fastpath entries for this group */
 
+	/* needed to track outstanding requests we expect to hear from userspace */
+	atomic_long_t cookie;		/* next cookie send to userspace for a decision */
+	struct mutex access_mutex;	/* protect access_list list */
+	struct list_head access_list;	/* event_holder we need an answer from userspace */
+	wait_queue_head_t access_waitq;	/* we wait here for userspace access decisions */
+
 	unsigned int priority;		/* order this group should receive msgs.  low first */
 };
 
 #ifdef CONFIG_FANOTIFY
 
-extern void fanotify(struct file *file, unsigned int mask);
+extern int fanotify(struct file *file, unsigned int mask);
 extern void fanotify_inode_delete(struct inode *inode);
 
 extern void fanotify_get_group(struct fanotify_group *group);
@@ -101,11 +122,14 @@ extern void fanotify_put_group(struct fanotify_group *group);
 /* things called from the socket */
 extern int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event_metadata *data, int nonblock);
 extern int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned int mask);
+extern int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response);
 
 #else
 
-static inline void fanotify(struct file *file, unsigned int mask)
-{}
+static inline int fanotify(struct file *file, unsigned int mask)
+{
+	return 0;
+}
 
 static inline void fanotify_get_group(struct fanotify_group *group)
 {}
@@ -132,6 +156,11 @@ static inline int fanotify_fastpath_add(struct fanotify_group *group, int fd, un
 static inline void fanotify_inode_delete(struct inode *inode)
 {}
 
+static inline int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FANOTIFY */
 
 #endif	/* __KERNEL __ */

