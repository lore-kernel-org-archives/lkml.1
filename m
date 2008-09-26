Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbYIZVUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbYIZVUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYIZVTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbYIZVTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:18 -0400
Subject: [RFC 7/11] fanotify: blocking and access granting
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:07 -0400
Message-Id: <1222463947.2872.219.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: blocking and access granting

From: Eric Paris <eparis@redhat.com>

This patch introduces blocking an access granting for fanotify.  Events are
sent to userspace and the original process is blocked (assuming not
O_NONBLOCK) for at most the amount of time determined by the group.  Total
maximum blocking time is the sum of all groups possible blocking time.

O_NONBLOCK processes trying to read and a group registered to require
blocking/access control on read MUST have a fastpath entry in order to ever
make progress.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/aio.c                      |    7 ++
 fs/notify/Makefile            |    2 -
 fs/notify/access.c            |  137 +++++++++++++++++++++++++++++++++++++++
 fs/notify/access_user.c       |  144 +++++++++++++++++++++++++++++++++++++++++
 fs/notify/fanotify.c          |   47 +++++++++++--
 fs/notify/fanotify.h          |   27 +++++++-
 fs/notify/fastpath.c          |    2 -
 fs/notify/group.c             |    9 +++
 fs/notify/notification.c      |    1 
 fs/notify/notification_user.c |   75 +++++++++++++++++++--
 fs/open.c                     |    5 +
 fs/read_write.c               |    6 ++
 include/linux/fanotify.h      |   23 ++++++-
 13 files changed, 462 insertions(+), 23 deletions(-)
 create mode 100644 fs/notify/access.c
 create mode 100644 fs/notify/access_user.c


diff --git a/fs/aio.c b/fs/aio.c
index f658441..febe4d0 100644
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
+		ret = fanotify(file, FAN_READ_ACCESS);
+		if (unlikely(ret))
+			break;
 		ret = aio_setup_single_vector(kiocb);
 		if (ret)
 			break;
@@ -1486,6 +1490,9 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
+		ret = fanotify(file, FAN_READ_ACCESS);
+		if (unlikely(ret))
+			break;
 		ret = aio_setup_vectored_rw(READ, kiocb);
 		if (ret)
 			break;
diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 8fac822..e29435a 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
 
-obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o notification_user.o group.o group_user.o info_user.o fastpath.o fastpath_user.o
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o notification_user.o group.o group_user.o info_user.o fastpath.o fastpath_user.o access.o access_user.o
diff --git a/fs/notify/access.c b/fs/notify/access.c
new file mode 100644
index 0000000..132ef7b
--- /dev/null
+++ b/fs/notify/access.c
@@ -0,0 +1,137 @@
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
+int add_event_to_group_access(struct fanotify_group *group, struct fanotify_event *event)
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
+	mutex_lock(&group->access_mutex);
+	list_add_tail(&holder->event_list, &group->access_list);
+	mutex_unlock(&group->access_mutex);
+
+	return 0;
+}
+
+int get_response_from_group_access(struct fanotify_group *group, struct fanotify_event *event)
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
+			holder->event = NULL;
+			/* as soon as we do this the event.holder might get reused */
+			list_del_init(&holder->event_list);
+
+			if (event != (struct fanotify_event *)holder)
+				destroy_event_holder(holder);
+			put_event(event);
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
+		holder->event = NULL;
+		/* as soon as we do this the event.holder might be reused */
+		list_del_init(&holder->event_list);
+
+		if (event != (struct fanotify_event *)holder)
+			destroy_event_holder(holder);
+		break;
+	}
+	mutex_unlock(&group->access_mutex);
+
+	if (!event)
+		return -ENOENT;
+
+	event->response = response;
+	wake_up(&group->access_waitq);
+	put_event(event);
+
+	return 0;
+}
diff --git a/fs/notify/access_user.c b/fs/notify/access_user.c
new file mode 100644
index 0000000..afd1c7f
--- /dev/null
+++ b/fs/notify/access_user.c
@@ -0,0 +1,144 @@
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
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include <linux/fanotify.h>
+#include "fanotify.h"
+
+static ssize_t fanotify_access_write(struct file *file, const char __user *buf, size_t lenp, loff_t *offset)
+{
+	char *p;
+	unsigned long cookie;
+	unsigned int response;
+	int rc = 0;
+	struct fanotify_group *group = file->f_path.dentry->d_inode->i_private;
+
+	if (!group)
+		return -EBADF;
+
+	if (!lenp)
+		return 0;
+
+	if (*offset)
+		return -EINVAL;
+
+	if (lenp > PAGE_SIZE)
+		return -ENOMEM;
+
+	p = (char *)get_zeroed_page(GFP_KERNEL);
+
+	rc = copy_from_user(p, buf, lenp);
+	if (rc)
+		goto out;
+	rc = sscanf(p, "%lu %x\n", &cookie, &response);
+	if (rc != 2) {
+		rc = -EPROTO;
+		goto out;
+	}
+
+	rc = fanotify_process_access_response(group, cookie, response);
+	if (rc)
+		goto out;
+
+	rc = lenp;
+out:
+	free_page((unsigned long)p);
+	return rc;
+}
+
+static int fanotify_access_open(struct inode *inode, struct file *file)
+{
+	struct fanotify_group *fgroup = inode->i_private;
+	struct fanotify_group *lgroup;
+	int found = 0;
+
+	/*
+	 * we can't trust fgroup as this open might be simultaneous with an
+	 * unregister.  Since unregister is done with the mutex and makes
+	 * sure there are no users if we get() the group under the lock it
+	 * can't disappear under us.
+	 */
+	mutex_lock(&groups_mutex);
+	list_for_each_entry(lgroup, &groups, group_list) {
+		if (lgroup == fgroup) {
+			fanotify_get_group(lgroup);
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&groups_mutex);
+
+	if (!found)
+		return -EINVAL;
+	return 0;
+}
+
+static int fanotify_access_release(struct inode *inode, struct file *file)
+{
+	struct fanotify_group *group = inode->i_private;
+
+	BUG_ON(!group);
+
+	fanotify_put_group(group);
+
+	return 0;
+}
+
+static struct file_operations access_fops = {
+	.open =		fanotify_access_open,
+	.release =	fanotify_access_release,
+	.write =	fanotify_access_write,
+};
+
+int fanotify_access_user_destroy(struct fanotify_group *group)
+{
+	securityfs_remove(group->access);
+	group->access = NULL;
+
+	return 0;
+}
+
+int fanotify_access_user_create(struct fanotify_group *group)
+{
+	struct dentry *access_file;
+
+	group->access = NULL;
+
+	access_file = securityfs_create_file("access", S_IRUSR|S_IWUSR, group->subdir, group, &access_fops);
+	if (IS_ERR(access_file))
+		return PTR_ERR(access_file);
+
+	group->access = access_file;
+
+	/* initialize the access list elements */
+	atomic_long_set(&group->cookie, 0);
+	INIT_LIST_HEAD(&group->access_list);
+	mutex_init(&group->access_mutex);
+	init_waitqueue_head(&group->access_waitq);
+
+	return 0;
+}
diff --git a/fs/notify/fanotify.c b/fs/notify/fanotify.c
index c7aa1ad..a55d76c 100644
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
 
 	if (likely(list_empty(&groups)))
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
-			add_event_to_group_notification(group, event);
+			if (mask & FAN_ALL_EVENTS_ACCESS) {
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
+				if ((mask & FAN_READ_ACCESS) && (file->f_flags & O_NONBLOCK)) {
+					add_event_to_group_notification(group, event);
+					ret = -EWOULDBLOCK;
+					break;
+				}
+				event->cookie = atomic_long_inc_return(&group->cookie);
+				event->response = 0;
+				/* put on access_list first so userspace can't be so fast responding it isn't on the list yet */
+				add_event_to_group_access(group, event);
+
+				add_event_to_group_notification(group, event);
+
+				ret = get_response_from_group_access(group, event);
+				if (ret)
+					break;
+			} else {
+				add_event_to_group_notification(group, event);
+			}
 		}
 	}
 	srcu_read_unlock(&groups_srcu_struct, idx);
@@ -96,10 +128,11 @@ void fanotify(struct file *file, unsigned int mask)
 	 */
 	if (event)
 		put_event(event);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fanotify);
 
-
 static __init int fanotify_init(void)
 {
 	int rc;
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 12fb8d3..38e156e 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -21,6 +21,12 @@ struct fanotify_group {
 	struct list_head notification_list; /* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq; /* read() on the notification file blocks on this waitq */
 
+	/* needed to track outstanding requests we expect to hear from userspace */
+	atomic_long_t cookie;		/* next cookie send to userspace for a decision */
+	struct mutex access_mutex;	/* protect access_list list */
+	struct list_head access_list;	/* event_holder we need an answer from userspace */
+	wait_queue_head_t access_waitq;	/* we wait here for userspace access decisions */
+
 	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
 	struct mutex fastpath_mutex;	/* protect fastpath_entries list */
 	struct list_head fastpath_entries; /* all fastpath entries for this group */
@@ -31,15 +37,18 @@ struct fanotify_group {
 	struct dentry *notification;	/* pointer to fanotify/name/notification dentry */
 	struct dentry *info;		/* pointer to fanotify/name/info dentry */
 	struct dentry *fastpath;	/* pointer to fanotify/name/fastpath dentry */
+	struct dentry *access;		/* pointer to fanotify/name/access dentry */
 };
 
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
@@ -63,6 +72,9 @@ struct fanotify_event {
 	struct path path;	/* path from the original access */
 	unsigned int mask;	/* the type of access */
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+	/* if waiting for a userspace access answer this is the cookie they will send back */
+	unsigned long cookie;
+	unsigned int response;	/* userspace answer to question */
 };
 
 
@@ -128,6 +140,13 @@ extern int fanotify_fastpath_add(struct fanotify_group *group, int fd, unsigned
 extern __init int fastpath_init(void);
 extern __init int fastpath_uninit(void);
 
+extern int fanotify_access_user_create(struct fanotify_group *group);
+extern int fanotify_access_user_destroy(struct fanotify_group *group);
+
+extern int add_event_to_group_access(struct fanotify_group *group, struct fanotify_event *event);
+extern int get_response_from_group_access(struct fanotify_group *group, struct fanotify_event *event);
+extern int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response);
+
 extern void fanotify_get_group(struct fanotify_group *group);
 extern void fanotify_put_group(struct fanotify_group *group);
 extern int fanotify_register_group(char *name, unsigned int priority, unsigned int mask);
diff --git a/fs/notify/fastpath.c b/fs/notify/fastpath.c
index c134426..7f783c0 100644
--- a/fs/notify/fastpath.c
+++ b/fs/notify/fastpath.c
@@ -74,7 +74,7 @@ int is_fastpath(struct file *file, unsigned int mask, struct fanotify_group *gro
 	int found = 0;
 
 	/* if noone is listening, might as well fastpath this group huh? */
-	if (!atomic_read(&group->num_clients))
+	if (unlikely(!atomic_read(&group->num_clients)))
 		return 1;
 
 	read_lock(&inode->fastpath_rwlock);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 81563ad..90cf59e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -49,6 +49,8 @@ void fanotify_kill_group(struct fanotify_group *group)
 
 	fanotify_fastpath_user_destroy(group);
 
+	fanotify_access_user_destroy(group);
+
 	securityfs_remove(group->subdir);
 	group->subdir = NULL;
 
@@ -123,6 +125,11 @@ int fanotify_register_group(char *name, unsigned int priority, unsigned int mask
 	if (rc)
 		goto out_clean_info;
 
+	rc = fanotify_access_user_create(group);
+	if (rc)
+		goto out_clean_fastpath;
+
+
 	/* Do we need to be the first entry? */
 	if (list_empty(&groups)) {
 		list_add_rcu(&group->group_list, &groups);
@@ -148,6 +155,8 @@ int fanotify_register_group(char *name, unsigned int priority, unsigned int mask
 
 	return 0;
 
+out_clean_fastpath:
+	fanotify_fastpath_user_destroy(group);
 out_clean_info:
 	fanotify_info_user_destroy(group);
 out_clean_notification:
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 8f4f439..e1a6a24 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -140,6 +140,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->path.mnt = file->f_path.mnt;
 	path_get(&event->path);
 
+	event->cookie = 0;
 	event->mask = mask;
 
 	WARN_ON(!event->path.dentry);
diff --git a/fs/notify/notification_user.c b/fs/notify/notification_user.c
index 4cea5f2..b492137 100644
--- a/fs/notify/notification_user.c
+++ b/fs/notify/notification_user.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/dcache.h>
+#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -41,15 +42,17 @@
  *    %d  = 11 characters
  *    %ld = 19 characters
  *    %x  = 8 characters
+ *    %lu = 19 characters
  *
  * "fd=%d "	= 15 characters
  * "mask=%x "	= 14 characters
+ * "cookie=%lu "= 27 characters
  * "\n "	=  2 characters
  * NULL		=  1 character
  * 
- * MAX_MESG_LEN = 32
+ * MAX_MESG_LEN = 59
  */
-#define MAX_MESG_LEN 32
+#define MAX_MESG_LEN 59
 
 static ssize_t fanotify_notification_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
 {
@@ -74,6 +77,7 @@ static ssize_t fanotify_notification_read(struct file *file, char __user *buf, s
 	if (lenp > PAGE_SIZE)
 		lenp = PAGE_SIZE;
 
+
 	output = kmalloc(lenp, GFP_KERNEL);
 	if (!output)
 		return -ENOMEM;
@@ -129,7 +133,7 @@ static ssize_t fanotify_notification_read(struct file *file, char __user *buf, s
 	 * Build metadata string to send to the listener
 	 * IF YOU CHANGE THIS STRING UPDATE MAX_MSG_LEN!!!!!!11111!!!!
 	 */
-	rc = snprintf(output, lenp-1, "fd=%d mask=%x\n", client_fd, event->mask);
+	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu\n", client_fd, event->mask, event->cookie);
 	if (rc < 0)
 		goto out;
 	output[rc] = '\0';
@@ -164,7 +168,6 @@ static int fanotify_notification_open(struct inode *inode, struct file *file)
 {
 	struct fanotify_group *fgroup = inode->i_private;
 	struct fanotify_group *lgroup;
-	struct task_struct *tsk = current;
 	int found = 0;
 
 	/*
@@ -176,7 +179,7 @@ static int fanotify_notification_open(struct inode *inode, struct file *file)
 	mutex_lock(&groups_mutex);
 	list_for_each_entry(lgroup, &groups, group_list) {
 		if (lgroup == fgroup) {
-			tsk->flags |= PF_NOFACCESS;
+			current->flags |= PF_NOFACCESS;
 			fanotify_get_group(lgroup);
 			found = 1;
 			break;
@@ -193,12 +196,70 @@ static int fanotify_notification_open(struct inode *inode, struct file *file)
 static int fanotify_notification_release(struct inode *inode, struct file *file)
 {
 	struct fanotify_group *group = inode->i_private;
-	struct task_struct *tsk = current;
+	struct fanotify_group *lgroup;
+	struct files_struct *files;
+	struct file *testfile;
+	struct inode *testinode;
+	struct fdtable *fdt;
+	long j = -1;
+	unsigned long set, i;
+	int found = 0, fput_needed;
 
 	BUG_ON(!group);
 
+	/*
+	 * we do all of this shit to figure out if this process is closing the last
+	 * open it has for any of he magic group->access files.  If this is the last
+	 * access being closed we clear the exclusion flag.  If this is not the last
+	 * close we should remain excluded.
+	 *
+	 * the basic idea behind running all of the open fd's was stolen from
+	 * fs/exec.c:flush_old_files.
+	 */
+	files = current->files;
+	/* if the process is ending current->files will be null */
+	if (files)
+		spin_lock(&files->file_lock);
+	for (; !found && files ;) {
+		j++;
+		i = j * __NFDBITS;
+		fdt = files_fdtable(files);
+		if (i >= fdt->max_fds)
+			break;
+		set = fdt->open_fds->fds_bits[j];
+		if (!set)
+			continue;
+		spin_unlock(&files->file_lock);
+		for ( ; set && !found ; i++, set >>= 1) {
+			if (set & 1) {
+				testfile = fget_light(i, &fput_needed);
+				if (!testfile)
+					continue;
+				/* don't count this file we are closing as being a reference to an access file */
+				if (testfile == file)
+					continue;
+				mutex_lock(&groups_mutex);
+				list_for_each_entry(lgroup, &groups, group_list) {
+					testinode = testfile->f_path.dentry->d_inode;
+					if (testinode == lgroup->access->d_inode) {
+						found = 1;
+						break;
+					}
+					
+				}
+				mutex_unlock(&groups_mutex);
+				fput_light(testfile, fput_needed);
+			}
+		}
+		spin_lock(&files->file_lock);
+	}
+	if (files)
+		spin_unlock(&files->file_lock);
+
 	fanotify_put_group(group);
-	tsk->flags &= ~PF_NOFACCESS;
+
+	if (!found)
+		current->flags &= ~PF_NOFACCESS;
 
 	return 0;
 }
diff --git a/fs/open.c b/fs/open.c
index 1057c34..06a6f79 100644
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
 
+	error = fanotify(f, FAN_OPEN_ACCESS);
+	if (error)
+		goto cleanup_all;
+
 	if (!open && f->f_op)
 		open = f->f_op->open;
 	if (open) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 39f1fce..3cc8c41 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/fanotify.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -201,6 +202,11 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 				read_write == READ ? MAY_READ : MAY_WRITE);
 	if (retval)
 		return retval;
+	if (read_write == READ) {
+		retval = fanotify(file, FAN_READ_ACCESS);
+		if (retval)
+			return retval;
+	}
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
 }
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index a23ab97..5d3e5d0 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -16,6 +16,10 @@
 #define FAN_CLOSE_NOWRITE	0x00000008	/* Unwrittable file closed */
 #define FAN_OPEN		0x00000010	/* File was opened */
 
+/* userspace may also request blocking for permission checks for open and read */
+#define FAN_OPEN_ACCESS		0x00000100
+#define FAN_READ_ACCESS		0x00000200
+
 /* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
 
@@ -33,6 +37,17 @@
 			 FAN_CLOSE_NOWRITE |\
 			 FAN_OPEN)
 
+/*
+ * Like the above list of events only these are the event types in which the
+ * kernel will wait for answers.
+ */
+#define FAN_ALL_EVENTS_ACCESS   (FAN_OPEN_ACCESS |\
+				 FAN_READ_ACCESS)
+
+/* answers will need to be either allow or deny */
+#define FAN_ALLOW		0x00000001
+#define FAN_DENY		0x00000010
+
 #ifdef __KERNEL__
 
 #include <linux/fs.h>
@@ -40,13 +55,15 @@
 
 #ifdef CONFIG_FANOTIFY
 
-extern void fanotify(struct file *file, unsigned int mask);
+extern int fanotify(struct file *file, unsigned int mask);
 extern void fanotify_inode_delete(struct inode *inode);
 
 #else
 
-static inline void fanotify(struct file *file, unsigned int mask)
-{}
+static inline int fanotify(struct file *file, unsigned int mask)
+{
+	return 0;
+}
 
 static inline void fanotify_inode_delete(struct inode *inode)
 {}


