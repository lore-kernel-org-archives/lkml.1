Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYLUO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYLUO6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYLUO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:58:37 -0500
Received: from www.tglx.de ([62.245.132.106]:37938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYLUO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:58:35 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 2/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
	<868wq9h905.fsf@johno-ibook.fn.ogness.net>
Date: Sun, 21 Dec 2008 15:57:52 +0100
In-Reply-To: <868wq9h905.fsf@johno-ibook.fn.ogness.net> (John Ogness's message of "Sun\, 21 Dec 2008 15\:56\:42 +0100")
Message-ID: <864p0xh8y7.fsf_-_@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2: Creates /dev/dazukofs.0 for userspace applications to perform
         file access control. At this point, all applications are
         considered to be working together (in the same group).

Patched against 2.6.28-rc9.

Signed-off-by: John Ogness <dazukocode@ogness.net>
---
 Documentation/filesystems/dazukofs.txt |   89 +++
 fs/Kconfig                             |    3 
 fs/dazukofs/Makefile                   |    3 
 fs/dazukofs/dev.c                      |   85 +++
 fs/dazukofs/dev.h                      |   37 +
 fs/dazukofs/event.c                    |  628 +++++++++++++++++++++++
 fs/dazukofs/event.h                    |   32 +
 fs/dazukofs/file.c                     |    7 
 fs/dazukofs/group_dev.c                |  159 +++++
 fs/dazukofs/super.c                    |   16 
 10 files changed, 1046 insertions(+), 13 deletions(-)
Index: linux-2.6.27/fs/dazukofs/dev.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/dev.c	2008-12-21 15:10:09.000000000 +0100
@@ -0,0 +1,85 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+
+#include "dazukofs_fs.h"
+#include "event.h"
+#include "dev.h"
+
+static struct class *dazukofs_class;
+
+static int dev_major;
+static int dev_minor_start;
+static int dev_minor_end;
+
+int dazukofs_dev_init(void)
+{
+	int err = 0;
+	dev_t devt;
+
+	err = dazukofs_init_events();
+	if (err)
+		goto error_out1;
+
+	err = alloc_chrdev_region(&devt, 0, 1, DEVICE_NAME);
+	if (err)
+		goto error_out2;
+	dev_major = MAJOR(devt);
+	dev_minor_start = MINOR(devt);
+
+	/* create class */
+	dazukofs_class = class_create(THIS_MODULE, DEVICE_NAME);
+	if (IS_ERR(dazukofs_class)) {
+		err = PTR_ERR(dazukofs_class);
+		goto error_out3;
+	}
+
+	dev_minor_end = dazukofs_group_dev_init(dev_major,
+						dev_minor_start + 1,
+						dazukofs_class);
+	if (dev_minor_end < 0) {
+		err = dev_minor_end;
+		goto error_out4;
+	}
+
+	return 0;
+
+error_out4:
+	class_destroy(dazukofs_class);
+error_out3:
+	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start), 1);
+error_out2:
+	dazukofs_destroy_events();
+error_out1:
+	return err;
+}
+
+void dazukofs_dev_destroy(void)
+{
+	dazukofs_group_dev_destroy(dev_major, dev_minor_start + 1,
+				   dev_minor_end, dazukofs_class);
+	class_destroy(dazukofs_class);
+	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start), 1);
+	dazukofs_destroy_events();
+}
Index: linux-2.6.27/fs/dazukofs/group_dev.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/group_dev.c	2008-12-21 15:10:09.000000000 +0100
@@ -0,0 +1,159 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+
+#include "dazukofs_fs.h"
+#include "event.h"
+#include "dev.h"
+
+static ssize_t dazukofs_group_read(struct file *file,
+				   char __user *buffer, size_t length,
+				   loff_t *pos)
+{
+#define DAZUKOFS_MIN_READ_BUFFER 43
+	char tmp[DAZUKOFS_MIN_READ_BUFFER];
+	ssize_t tmp_used;
+	pid_t pid;
+	int fd;
+	int err;
+	unsigned long event_id;
+
+	if (*pos > 0)
+		return 0;
+
+	if (length < DAZUKOFS_MIN_READ_BUFFER)
+		return -EINVAL;
+
+	err = dazukofs_get_event(&event_id, &fd, &pid);
+	if (err) {
+		if (err == -ERESTARTSYS)
+			return -EINTR;
+		return err;
+	}
+
+	tmp_used = snprintf(tmp, sizeof(tmp)-1, "id=%lu\nfd=%d\npid=%d\n",
+			    event_id, fd, pid);
+	if (tmp_used >= sizeof(tmp))
+		return -EINVAL;
+
+	if (copy_to_user(buffer, tmp, tmp_used))
+		return -EFAULT;
+
+	*pos = tmp_used;
+
+	return tmp_used;
+}
+
+static ssize_t dazukofs_group_write(struct file *file,
+				    const char __user *buffer, size_t length,
+				    loff_t *pos)
+{
+#define DAZUKOFS_MAX_WRITE_BUFFER 19
+	char tmp[DAZUKOFS_MAX_WRITE_BUFFER];
+	int response;
+	unsigned long event_id;
+	char *p;
+	char *p2;
+	int ret;
+
+	if (length >= DAZUKOFS_MAX_WRITE_BUFFER)
+		length = DAZUKOFS_MAX_WRITE_BUFFER - 1;
+
+	if (copy_from_user(tmp, buffer, length))
+		return -EFAULT;
+	tmp[length] = 0;
+
+	p = strstr(tmp, "id=");
+	if (!p)
+		return -EINVAL;
+	event_id = simple_strtoul(p + 3, &p2, 10);
+
+	/*
+	 * checkpatch.pl recommends using strict_strtoul() instead of
+	 * simple_strtoul(). However, we _want_ a function that stops
+	 * on non-number characters rather than errors out.
+	 */
+
+	p = strstr(p2, "r=");
+	if (!p)
+		return -EINVAL;
+	response = (*(p + 2)) - '0';
+
+	ret = dazukofs_return_event(event_id, response);
+	if (ret == 0) {
+		*pos += length;
+		ret = length;
+	} else if (ret == -ERESTARTSYS) {
+		ret = -EINTR;
+	}
+
+	return ret;
+}
+
+static struct cdev group_cdev;
+
+static struct file_operations group_fops = {
+	.owner		= THIS_MODULE,
+	.read		= dazukofs_group_read,
+	.write		= dazukofs_group_write,
+};
+
+int dazukofs_group_dev_init(int dev_major, int dev_minor_start,
+			    struct class *dazukofs_class)
+{
+	int err = 0;
+	struct device *dev;
+	int dev_minor_end = dev_minor_start;
+
+	cdev_init(&group_cdev, &group_fops);
+	group_cdev.owner = THIS_MODULE;
+	err = cdev_add(&group_cdev, MKDEV(dev_major, dev_minor_start), 1);
+	if (err)
+		goto error_out1;
+
+	dev = device_create(dazukofs_class, NULL,
+			    MKDEV(dev_major, dev_minor_end), NULL,
+			    "%s.%d", DEVICE_NAME, 0);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto error_out2;
+	}
+	dev_minor_end++;
+
+	return dev_minor_end;
+
+error_out2:
+	device_destroy(dazukofs_class, MKDEV(dev_major, 0));
+error_out1:
+	cdev_del(&group_cdev);
+	return err;
+}
+
+void dazukofs_group_dev_destroy(int dev_major, int dev_minor_start,
+				int dev_minor_end,
+				struct class *dazukofs_class)
+{
+	device_destroy(dazukofs_class, MKDEV(dev_major, 0));
+	cdev_del(&group_cdev);
+}
Index: linux-2.6.27/fs/dazukofs/event.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/event.c	2008-12-21 15:10:09.000000000 +0100
@@ -0,0 +1,628 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/freezer.h>
+
+#include "dazukofs_fs.h"
+
+struct dazukofs_proc {
+	struct list_head list;
+	struct task_struct *curr;
+};
+
+struct dazukofs_event {
+	unsigned long event_id;
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+	pid_t pid;
+	wait_queue_head_t queue;
+
+	/* protects: deny, deprecated, assigned */
+	struct mutex assigned_mutex;
+
+	int deny;
+	int deprecated;
+	int assigned;
+};
+
+struct dazukofs_event_container {
+	struct list_head list;
+	struct dazukofs_event *event;
+	struct file *file;
+	int fd;
+};
+
+struct dazukofs_group {
+	struct dazukofs_event_container todo_list;
+	wait_queue_head_t queue;
+	struct dazukofs_event_container working_list;
+};
+
+static struct dazukofs_group reg_group;
+
+/* protects: grp->members, last_event_id,
+ *	     todo_list, working_list */
+static struct mutex work_mutex;
+
+static struct mutex proc_mutex;
+static struct dazukofs_proc proc_list;
+
+static struct kmem_cache *dazukofs_event_container_cachep;
+static struct kmem_cache *dazukofs_event_cachep;
+
+static int last_event_id;
+
+/**
+ * dazukofs_init_events - initialize event handling infrastructure
+ *
+ * Description: This is called once to initialize all the structures
+ * needed to manage event handling.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_init_events(void)
+{
+	mutex_init(&proc_mutex);
+	mutex_init(&work_mutex);
+	INIT_LIST_HEAD(&proc_list.list);
+
+	init_waitqueue_head(&reg_group.queue);
+	INIT_LIST_HEAD(&reg_group.todo_list.list);
+	INIT_LIST_HEAD(&reg_group.working_list.list);
+
+	dazukofs_event_container_cachep =
+		kmem_cache_create("dazukofs_event_container_cache",
+				  sizeof(struct dazukofs_event_container), 0,
+				  SLAB_HWCACHE_ALIGN, NULL);
+	if (!dazukofs_event_container_cachep)
+		goto error_out;
+
+	dazukofs_event_cachep =
+		kmem_cache_create("dazukofs_event_cache",
+				  sizeof(struct dazukofs_event), 0,
+				  SLAB_HWCACHE_ALIGN, NULL);
+	if (!dazukofs_event_cachep)
+		goto error_out;
+
+	return 0;
+
+error_out:
+	if (dazukofs_event_container_cachep)
+		kmem_cache_destroy(dazukofs_event_container_cachep);
+	if (dazukofs_event_cachep)
+		kmem_cache_destroy(dazukofs_event_cachep);
+	return -ENOMEM;
+}
+
+/**
+ * release_event - release (and possible free) an event
+ * @evt: the event to release
+ * @decrement_assigned: flag to signal if the assigned count should be
+ *                      decremented (only for registered processes)
+ * @deny: flag if file access event should be denied
+ *
+ * Description: This function will decrement the assigned count for the
+ * event. The "decrement_assigned" flag is used to distinguish between
+ * the anonymous process accessing a file and the registered process. The
+ * assigned count is only incremented for registered process (although the
+ * anonymous process will also have a handle to the event).
+ *
+ * For the anonymous process (decrement_assigned = false):
+ * If the assigned count is not zero, there are registered processes that
+ * have a handle to this event. The event is marked deprecated. Otherwise
+ * we free the event.
+ *
+ * For a registered process (decrement_assigned = true):
+ * The assigned count is decremented. If it is now zero and the event is
+ * not deprecated, then the anonymous process still has a handle. In this
+ * case we wake the anonymous process. Otherwise we free the event.
+ *
+ * Aside from releasing the event, the deny status of the event is also
+ * updated. The "normal" release process involves the registered processes
+ * first releasing (and providing their deny values) and finally the
+ * anonymous process will release (and free) the event after reading the
+ * deny value.
+ */
+static void release_event(struct dazukofs_event *evt, int decrement_assigned,
+			  int deny)
+{
+	int free_event = 0;
+
+	mutex_lock(&evt->assigned_mutex);
+	if (deny)
+		evt->deny |= 1;
+
+	if (decrement_assigned) {
+		evt->assigned--;
+		if (evt->assigned == 0) {
+			if (!evt->deprecated)
+				wake_up(&evt->queue);
+			else
+				free_event = 1;
+		}
+	} else {
+		if (evt->assigned == 0)
+			free_event = 1;
+		else
+			evt->deprecated = 1;
+	}
+	mutex_unlock(&evt->assigned_mutex);
+
+	if (free_event) {
+		dput(evt->dentry);
+		mntput(evt->mnt);
+		kmem_cache_free(dazukofs_event_cachep, evt);
+	}
+}
+
+/**
+ * __clear_group_event_list - cleanup/release event list
+ * @event_list - the list to clear
+ *
+ * Description: All events (and their containers) will be released/freed
+ * for the given event list. The event list will be an empty (yet still
+ * valid) list after this function is finished.
+ *
+ * IMPORTANT: This function requires work_mutex to be held!
+ */
+static void __clear_group_event_list(struct list_head *event_list)
+{
+	struct dazukofs_event_container *ec;
+	struct list_head *pos;
+	struct list_head *q;
+
+	list_for_each_safe(pos, q, event_list) {
+		ec = list_entry(pos, struct dazukofs_event_container, list);
+		list_del(pos);
+
+		release_event(ec->event, 1, 0);
+
+		kmem_cache_free(dazukofs_event_container_cachep, ec);
+	}
+}
+
+/**
+ * __remove_group - clear all activity associated with the group
+ * @grp: the group to clear
+ *
+ * Description: All pending and in-progress events are released/freed.
+ * Any processes waiting on the queue are woken.
+ *
+ * IMPORTANT: This function requires work_mutex to be held!
+ */
+static void __remove_group(struct dazukofs_group *grp)
+{
+	__clear_group_event_list(&grp->working_list.list);
+	__clear_group_event_list(&grp->todo_list.list);
+
+	/* notify all registered process waiting for an event */
+	wake_up_all(&grp->queue);
+}
+
+/**
+ * dazukofs_destroy_events - cleanup/shutdown event handling infrastructure
+ *
+ * Description: Release all pending events, free all allocated structures.
+ */
+void dazukofs_destroy_events(void)
+{
+	/* free the group items */
+	mutex_lock(&work_mutex);
+	__remove_group(&reg_group);
+	mutex_unlock(&work_mutex);
+
+	/* free everything else */
+	kmem_cache_destroy(dazukofs_event_container_cachep);
+	kmem_cache_destroy(dazukofs_event_cachep);
+}
+
+/**
+ * check_recursion - check if current process is recursing
+ *
+ * Description: A list of anonymous processes is managed to prevent
+ * access event recursion. This function checks if the current process is
+ * a part of that list.
+ *
+ * If the current process is found in the process list, it is removed.
+ *
+ * NOTE: The proc structure is not freed. It is only removed from the
+ *       list. Since it is a recursive call, the caller can free the
+ *       structure after the call chain is finished.
+ *
+ * Returns 0 if this is a recursive process call.
+ */
+static int check_recursion(void)
+{
+	struct dazukofs_proc *proc;
+	struct list_head *pos;
+	int found = 0;
+
+	mutex_lock(&proc_mutex);
+	list_for_each(pos, &proc_list.list) {
+		proc = list_entry(pos, struct dazukofs_proc, list);
+		if (proc->curr == current) {
+			found = 1;
+			list_del(pos);
+			break;
+		}
+	}
+	mutex_unlock(&proc_mutex);
+
+	/* process event if not found */
+	return !found;
+}
+
+/**
+ * event_assigned - check if event is (still) assigned
+ * @event: event to check
+ *
+ * Description: This function checks if an event is still assigned. An
+ * assigned event means that it is sitting on the todo or working list
+ * of a group.
+ *
+ * Returns the number assigned count.
+ */
+static int event_assigned(struct dazukofs_event *event)
+{
+	int val;
+	mutex_lock(&event->assigned_mutex);
+	val = event->assigned;
+	mutex_unlock(&event->assigned_mutex);
+	return val;
+}
+
+/**
+ * check_access_precheck - check if an access event should be generated
+ *
+ * Description: Check if the current process should cause an access event
+ * to be generated.
+ *
+ * Returns 0 if an access event should be generated.
+ */
+static int check_access_precheck(void)
+{
+	/* am I a recursion process? */
+	if (!check_recursion())
+		return -1;
+
+	return 0;
+}
+
+/**
+ * assign_event_to_group - post an event to be processed
+ * @evt: the event to be posted
+ * @ec: the container for the event
+ *
+ * Description: This function will assign a unique id to the event.
+ * The event will be associated with its container and placed on the
+ * group's todo list. The group will also be woken to handle the new
+ * event.
+ */
+static void
+assign_event_to_group(struct dazukofs_event *evt,
+		      struct dazukofs_event_container *ec) {
+	struct dazukofs_group *grp = &reg_group;
+
+	mutex_lock(&work_mutex);
+	mutex_lock(&evt->assigned_mutex);
+
+	/* assign the event a "unique" id */
+
+	last_event_id++;
+	evt->event_id = last_event_id;
+
+	ec->event = evt;
+	evt->assigned = 1;
+	list_add_tail(&ec->list, &grp->todo_list.list);
+
+	/* notify someone to handle the event */
+	wake_up(&grp->queue);
+
+	mutex_unlock(&evt->assigned_mutex);
+	mutex_unlock(&work_mutex);
+}
+
+/**
+ * allocate_event_and_container - allocate an event and event container
+ * @evt: event pointer to be assigned a new event
+ * @ec: event container to be assigned a new container
+ *
+ * Description: New event and event container structures are allocated
+ * and initialized.
+ *
+ * Returns 0 on success.
+ */
+static int allocate_event_and_container(struct dazukofs_event **evt,
+					struct dazukofs_event_container **ec)
+{
+	*evt = kmem_cache_zalloc(dazukofs_event_cachep, GFP_KERNEL);
+	if (!*evt)
+		return -1;
+	init_waitqueue_head(&(*evt)->queue);
+	mutex_init(&(*evt)->assigned_mutex);
+
+	/* allocate container now while we don't have a lock */
+	*ec = kmem_cache_zalloc(dazukofs_event_container_cachep, GFP_KERNEL);
+	if (!*ec)
+		goto error_out;
+
+	return 0;
+
+error_out:
+	kmem_cache_free(dazukofs_event_cachep, *evt);
+	*evt = NULL;
+	return -1;
+}
+
+/**
+ * dazukofs_check_access - check for allowed file access
+ * @dentry: the dentry associated with the file access
+ * @mnt: the vfsmount associated with the file access
+ *
+ * Description: This is the only function used by the stackable filesystem
+ * layer to check if a file may be accessed.
+ *
+ * Returns 0 if the file access is allowed.
+ */
+int dazukofs_check_access(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct dazukofs_event_container *ec;
+	struct dazukofs_event *evt;
+	int err;
+
+	if (check_access_precheck())
+		return 0;
+
+	/* at this point, the access should be handled */
+
+	if (allocate_event_and_container(&evt, &ec)) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	evt->dentry = dget(dentry);
+	evt->mnt = mntget(mnt);
+	evt->pid = current->pid;
+
+	assign_event_to_group(evt, ec);
+
+	/* wait until event completely processed or signal */
+	err = wait_event_freezable(evt->queue, event_assigned(evt) == 0);
+
+	if (evt->deny)
+		err = -EPERM;
+
+	release_event(evt, 0, 0);
+out:
+	return err;
+}
+
+/**
+ * dazukofs_return_event - return checked file access results
+ * @event_id: the id of the event
+ * @deny: a flag indicating if file access should be denied
+ *
+ * Description: This function is called by the device layer when returning
+ * results from a checked file access event. If the event_id was valid, the
+ * event container will be freed and the event released.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_return_event(unsigned long event_id, int deny)
+{
+	struct dazukofs_group *grp = &reg_group;
+	struct dazukofs_event_container *ec;
+	struct dazukofs_event *evt = NULL;
+	struct list_head *pos;
+	int found = 0;
+	int ret = 0;
+
+	mutex_lock(&work_mutex);
+	list_for_each(pos, &grp->working_list.list) {
+		ec = list_entry(pos, struct dazukofs_event_container, list);
+		evt = ec->event;
+		if (evt->event_id == event_id) {
+			found = 1;
+			list_del(pos);
+			kmem_cache_free(dazukofs_event_container_cachep, ec);
+			break;
+		}
+	}
+	mutex_unlock(&work_mutex);
+
+	if (found)
+		release_event(evt, 1, deny);
+	else
+		ret = -EFAULT;
+	return ret;
+}
+
+/**
+ * unclaim_event - return an event to the todo list
+ * @grp: group to which the event is assigned
+ * @ec: event container of the event to be returned
+ *
+ * Description: This function puts the given event container on the todo
+ * list and wake the group.
+ */
+static void unclaim_event(struct dazukofs_group *grp,
+			  struct dazukofs_event_container *ec)
+{
+	/* put the event on the todo list */
+	mutex_lock(&work_mutex);
+	list_add(&ec->list, &grp->todo_list.list);
+	mutex_unlock(&work_mutex);
+
+	/* wake up someone else to handle the event */
+	wake_up(&grp->queue);
+}
+
+/**
+ * claim_event - grab an event from the todo list
+ * @grp: the group
+ *
+ * Description: Take the first event from the todo list and move it to the
+ * working list. The event is then returned to its called for processing.
+ *
+ * Returns the claimed event.
+ */
+static struct dazukofs_event_container *claim_event(struct dazukofs_group *grp)
+{
+	struct dazukofs_event_container *ec = NULL;
+
+	/* move first todo-item to working list */
+	mutex_lock(&work_mutex);
+	if (!list_empty(&grp->todo_list.list)) {
+		ec = list_first_entry(&grp->todo_list.list,
+				      struct dazukofs_event_container, list);
+		list_del(&ec->list);
+		list_add(&ec->list, &grp->working_list.list);
+	}
+	mutex_unlock(&work_mutex);
+
+	return ec;
+}
+
+/**
+ * mask_proc - mask the current process
+ * @proc: process structure to use for the list
+ *
+ * Description: Assign the current process to the provided proc structure
+ * and add the structure to the list. The list is used to prevent
+ * generating recursive file access events. The process is removed from
+ * the list with the check_recursion() function.
+ */
+static void mask_proc(struct dazukofs_proc *proc)
+{
+	proc->curr = current;
+	mutex_lock(&proc_mutex);
+	list_add(&proc->list, &proc_list.list);
+	mutex_unlock(&proc_mutex);
+}
+
+/**
+ * open_file - open a file for the current process (avoiding recursion)
+ * @ec: event container to store opened file descriptor
+ *
+ * Description: This function will open a file using the information within
+ * the provided event container. The calling process will be temporarily
+ * masked so that the file open does not generate a file access event.
+ *
+ * Returns 0 on success.
+ */
+static int open_file(struct dazukofs_event_container *ec)
+{
+	struct dazukofs_event *evt = ec->event;
+	struct dazukofs_proc proc;
+	int ret = 0;
+
+	/* open the file read-only */
+
+	ec->fd = get_unused_fd();
+	if (ec->fd < 0) {
+		ret = ec->fd;
+		goto error_out1;
+	}
+
+	/* add myself to be ignored on file open (to avoid recursion) */
+	mask_proc(&proc);
+
+	ec->file = dentry_open(dget(evt->dentry), mntget(evt->mnt), O_RDONLY);
+	if (IS_ERR(ec->file)) {
+		check_recursion();  /* remove myself from proc_list */
+		ret = PTR_ERR(ec->file);
+		goto error_out2;
+	}
+
+	fd_install(ec->fd, ec->file);
+
+	return 0;
+
+error_out2:
+	put_unused_fd(ec->fd);
+error_out1:
+	return ret;
+}
+
+/**
+ * is_event_available - check if an event is available for processing
+ * @grp: the group
+ *
+ * Description: This function simply checks if there are any events posted
+ * in the group's todo list.
+ *
+ * Returns 0 if there are no events in the todo list.
+ */
+static int is_event_available(struct dazukofs_group *grp)
+{
+	int ret = 0;
+
+	mutex_lock(&work_mutex);
+	if (!list_empty(&grp->todo_list.list))
+		ret = 1;
+	mutex_unlock(&work_mutex);
+
+	return ret;
+}
+
+/**
+ * dazukofs_get_event - get an event to process
+ * @event_id: to be filled in with the new event id
+ * @fd: to be filled in with the opened file descriptor
+ * @pid: to be filled in with the pid of the process generating the event
+ *
+ * Description: This function is called by the device layer to get a new
+ * file access event to process. It waits until an event has been
+ * posted in the todo list (and is successfully claimed by this process).
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_get_event(unsigned long *event_id, int *fd, pid_t *pid)
+{
+	struct dazukofs_group *grp = &reg_group;
+	struct dazukofs_event_container *ec;
+	int ret = 0;
+
+	while (1) {
+		ret = wait_event_freezable(grp->queue,
+					   is_event_available(grp));
+		if (ret != 0)
+			break;
+
+		ec = claim_event(grp);
+		if (ec) {
+			ret = open_file(ec);
+			if (ret == 0) {
+				*event_id = ec->event->event_id;
+				*fd = ec->fd;
+				*pid = ec->event->pid;
+				break;
+			} else {
+				unclaim_event(grp, ec);
+			}
+		}
+	}
+	return ret;
+}
Index: linux-2.6.27/fs/dazukofs/dev.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/dev.h	2008-12-21 15:10:09.000000000 +0100
@@ -0,0 +1,37 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#ifndef __DEV_H
+#define __DEV_H
+
+struct class;
+
+#define DEVICE_NAME	"dazukofs"
+
+extern int dazukofs_dev_init(void);
+extern void dazukofs_dev_destroy(void);
+
+extern int dazukofs_group_dev_init(int dev_major, int dev_minor_start,
+				   struct class *dazukofs_class);
+extern void dazukofs_group_dev_destroy(int dev_major, int dev_minor_start,
+				       int dev_minor_end,
+				       struct class *dazukofs_class);
+
+#endif /* __DEV_H */
Index: linux-2.6.27/fs/dazukofs/Makefile
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/Makefile	2008-12-21 15:09:53.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/Makefile	2008-12-21 15:10:09.000000000 +0100
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_DAZUKOFS_FS) += dazukofs.o
 
-dazukofs-objs := super.o inode.o file.o dentry.o mmap.o
+dazukofs-objs := super.o inode.o file.o dentry.o mmap.o event.o \
+		 dev.o group_dev.o
Index: linux-2.6.27/fs/dazukofs/super.c
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/super.c	2008-12-21 15:09:53.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/super.c	2008-12-21 15:10:09.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 
 #include "dazukofs_fs.h"
+#include "dev.h"
 
 static struct kmem_cache *dazukofs_inode_info_cachep;
 static struct kmem_cache *dazukofs_sb_info_cachep;
@@ -306,19 +307,25 @@
 {
 	int err = 0;
 
-	err = init_caches();
+	err = dazukofs_dev_init();
 	if (err)
 		goto error_out1;
 
-	err = register_filesystem(&dazukofs_fs_type);
+	err = init_caches();
 	if (err)
 		goto error_out2;
 
+	err = register_filesystem(&dazukofs_fs_type);
+	if (err)
+		goto error_out3;
+
 	printk(KERN_INFO "dazukofs: loaded\n");
 	return 0;
 
-error_out2:
+error_out3:
 	destroy_caches();
+error_out2:
+	dazukofs_dev_destroy();
 error_out1:
 	return err;
 }
@@ -327,11 +334,12 @@
 {
 	unregister_filesystem(&dazukofs_fs_type);
 	destroy_caches();
+	dazukofs_dev_destroy();
 	printk(KERN_INFO "dazukofs: unloaded\n");
 }
 
 MODULE_AUTHOR("John Ogness");
-MODULE_DESCRIPTION("pass-through stackable filesystem");
+MODULE_DESCRIPTION("access control stackable filesystem");
 MODULE_LICENSE("GPL");
 module_init(init_dazukofs_fs)
 module_exit(exit_dazukofs_fs)
Index: linux-2.6.27/fs/dazukofs/file.c
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/file.c	2008-12-21 15:09:53.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/file.c	2008-12-21 15:10:09.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/fs_stack.h>
 
 #include "dazukofs_fs.h"
+#include "event.h"
 
 /**
  * Description: Called when the VFS needs to move the file position index.
@@ -174,7 +175,11 @@
 	struct dentry *lower_dentry = dget(GET_LOWER_DENTRY(dentry));
 	struct vfsmount *lower_mnt = mntget(GET_LOWER_MNT(dentry));
 	struct file *lower_file;
-	int err = 0;
+	int err;
+
+	err = dazukofs_check_access(file->f_dentry, file->f_vfsmnt);
+	if (err)
+		goto error_out1;
 
 	SET_FILE_INFO(file, kmem_cache_zalloc(dazukofs_file_info_cachep,
 		      GFP_KERNEL));
Index: linux-2.6.27/fs/dazukofs/event.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/event.h	2008-12-21 15:10:09.000000000 +0100
@@ -0,0 +1,32 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#ifndef __EVENT_H
+#define __EVENT_H
+
+extern int dazukofs_init_events(void);
+extern void dazukofs_destroy_events(void);
+
+extern int dazukofs_get_event(unsigned long *event_id, int *fd, pid_t *pid);
+extern int dazukofs_return_event(unsigned long event_id, int deny);
+
+extern int dazukofs_check_access(struct dentry *dentry, struct vfsmount *mnt);
+
+#endif /* __EVENT_H */
Index: linux-2.6.27/fs/Kconfig
===================================================================
--- linux-2.6.27.orig/fs/Kconfig	2008-12-21 15:09:53.000000000 +0100
+++ linux-2.6.27/fs/Kconfig	2008-12-21 15:10:09.000000000 +0100
@@ -820,7 +820,8 @@
 	tristate "DazukoFS filesystem layer support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-	  A pass-through stackable filesystem (also referred to as nullfs).
+	  A stackable filesystem to allow userspace applications to perform
+	  online file access control.
 	  See <file:Documentation/filesystems/dazukofs.txt> to learn more
 	  about DazukoFS.
 
Index: linux-2.6.27/Documentation/filesystems/dazukofs.txt
===================================================================
--- linux-2.6.27.orig/Documentation/filesystems/dazukofs.txt	2008-12-21 15:09:53.000000000 +0100
+++ linux-2.6.27/Documentation/filesystems/dazukofs.txt	2008-12-21 15:10:09.000000000 +0100
@@ -2,9 +2,10 @@
  ABOUT DAZUKOFS
 ================
 
-DazukoFS is a pass-through stackable filesystem. A filesystem that does
-not perform any special modification but simply passes VFS calls to and
-from the lower filesystem is typically known as nullfs.
+DazukoFS is a stackable filesystem to allow userspace applications to
+perform online file access control. It was originally developed to
+support online virus scanners, but could be useful for any application
+that wishes to perform online file access control.
 
 
 
@@ -19,7 +20,19 @@
 # mount -t dazukofs /opt /opt
 
 A process that accesses files in /opt will now be accessing them through
-DazukoFS. The stackable filesystem can then be unmounted with:
+DazukoFS. Such file access events will be detected by a process that is
+registered with DazukoFS. That process can then choose to allow or deny
+the access.
+
+IMPORTANT: DazukoFS does not allow file access events unless a registered
+           application has approved them. This means that no file access
+           can take place on a DazukoFS mount until an application has
+           registered to perform file access control with DazukoFS.
+           Attempts to access files on a DazukoFS mount will result in the
+           process blocking until a registered application has approved
+           the access.
+
+The stackable filesystem can then be unmounted with:
 
 # umount /opt
 
@@ -56,10 +69,11 @@
 If files are modified directly in /opt, the DazukoFS layer will not know
 about it. When DazukoFS later tries to access those files, it may result
 in corrupt data or kernel crashes. As long as /opt is modified ONLY through
-DazukoFS, there should not be any problems.
+DazukoFS (i.e. through /mnt), there should not be any problems.
 
 This method of mounting DazukoFS may be interesting for servers that export
-a part of the filesystem and the service is in a chroot environment.
+a part of the filesystem and the exporting service is within a chroot
+environment.
 
 
 
@@ -79,3 +93,66 @@
 Please report problems to the dazuko-devel mailing list
 (subscription required):
      http://lists.nongnu.org/mailman/listinfo/dazuko-devel
+
+
+
+=======================
+ DAZUKOFS APPLICATIONS
+=======================
+
+This last section is meant for developers of DazukoFS applications. This
+section will discuss the methods used for interacting with DazukoFS in
+order to perform online file access control.
+
+Although this section describes the low-level communication between
+application and kernel, be aware that a userspace library libdazukofs
+exists that has already implemented this communication. Using the
+library makes it very easy to write applications for DazukoFS. The
+library can be found on the Dazuko website: http://www.dazuko.org
+
+An application can register itself to receive notification about DazukoFS
+file access events. The application then also has the authority to block
+the file access.
+
+For each file access event, only one of the registered applications will
+be notified.
+
+By opening the device /dev/dazukofs.0 an application has registered itself.
+A read on the device will block until a file access event on DazukoFS has
+taken place. When a file access event has occured, the read will return with
+information about the file access event. For example:
+
+id=11
+fd=4
+pid=3226
+
+This means that the particular file access event has been given the id 11.
+The file descriptor 4 has been opened for the registered process. This file
+descriptor allows the registered process read-only access to the file being
+accessed. The pid of the accessing process is 3226.
+
+Using this information, the registered application must determine if the
+access should be denied or allowed. The application must then respond with
+an answer. This is done by writing to the device:
+
+id=11 r=0
+
+"r" is the response. A value of 0 means to allow the access. A value of 1
+means to deny the access.
+
+IMPORTANT: The application is responsible for closing the file descriptor
+           that was opened by DazukoFS.
+
+Since DazukoFS will open the file being accessed, the registered process
+only requires read/write permissions to the device in order to perform
+online file access control. The file is opened even if the registered
+application normally would not have access to the file. This allows an
+unprivileged process to perform file access control for any file on the
+system.
+
+By closing the device, the application will unregister itself.
+
+NOTE: It is not necessary for the device to be open while the application
+      decides if access should be allowed. In fact, it doesn't even have to
+      be the same process that responds. DazukoFS is only interested in a
+      response for the given event id.
