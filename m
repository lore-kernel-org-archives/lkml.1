Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZBCTT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZBCTT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZBCTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:19:16 -0500
Received: from www.tglx.de ([62.245.132.106]:38644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbZBCTTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:19:12 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 3/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
Date: Tue, 03 Feb 2009 20:18:29 +0100
In-Reply-To: <86wsc7fhzc.fsf_-_@johno.fn.ogness.net> (John Ogness's message of "Tue\, 03 Feb 2009 20\:17\:11 +0100")
Message-ID: <86skmvfhx6.fsf_-_@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 3: Creates /dev/dazukofs.ctrl to allow for groups to be added,
         listed, and deleted. Also, /dev/dazukofs.[0-9] devices are
         created to support multiple groups.

Patched against 2.6.29-rc3.

Signed-off-by: John Ogness <dazukocode@ogness.net>
---
 Documentation/filesystems/dazukofs.txt |   73 +++
 fs/dazukofs/Makefile                   |    2 
 fs/dazukofs/ctrl_dev.c                 |  198 ++++++++++
 fs/dazukofs/dev.c                      |   18 
 fs/dazukofs/dev.h                      |    6 
 fs/dazukofs/event.c                    |  445 ++++++++++++++++++++---
 fs/dazukofs/event.h                    |   10 
 fs/dazukofs/group_dev.c                |  107 ++++-
 8 files changed, 775 insertions(+), 84 deletions(-)
Index: linux-2.6.28/fs/dazukofs/event.c
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/event.c	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/event.c	2009-02-03 18:11:01.000000000 +0100
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/cred.h>
 
+#include "dev.h"
 #include "dazukofs_fs.h"
 
 struct dazukofs_proc {
@@ -56,20 +57,31 @@
 };
 
 struct dazukofs_group {
+	struct list_head list;
+	char *name;
+	size_t name_length;
+	unsigned long group_id;
 	struct dazukofs_event_container todo_list;
 	wait_queue_head_t queue;
 	struct dazukofs_event_container working_list;
+	atomic_t use_count;
+	int deprecated;
 };
 
-static struct dazukofs_group reg_group;
+static struct dazukofs_group group_list;
+static int group_count;
+
+/* protects: group_list, group_count */
+static rwlock_t group_count_rwlock;
 
-/* protects: grp->members, last_event_id,
+/* protects: group_list, grp->members, last_event_id,
  *	     todo_list, working_list */
 static struct mutex work_mutex;
 
 static struct mutex proc_mutex;
 static struct dazukofs_proc proc_list;
 
+static struct kmem_cache *dazukofs_group_cachep;
 static struct kmem_cache *dazukofs_event_container_cachep;
 static struct kmem_cache *dazukofs_event_cachep;
 
@@ -87,11 +99,17 @@
 {
 	mutex_init(&proc_mutex);
 	mutex_init(&work_mutex);
+	rwlock_init(&group_count_rwlock);
+
 	INIT_LIST_HEAD(&proc_list.list);
+	INIT_LIST_HEAD(&group_list.list);
 
-	init_waitqueue_head(&reg_group.queue);
-	INIT_LIST_HEAD(&reg_group.todo_list.list);
-	INIT_LIST_HEAD(&reg_group.working_list.list);
+	dazukofs_group_cachep =
+		kmem_cache_create("dazukofs_group_cache",
+				  sizeof(struct dazukofs_group), 0,
+				  SLAB_HWCACHE_ALIGN, NULL);
+	if (!dazukofs_group_cachep)
+		goto error_out;
 
 	dazukofs_event_container_cachep =
 		kmem_cache_create("dazukofs_event_container_cache",
@@ -110,6 +128,8 @@
 	return 0;
 
 error_out:
+	if (dazukofs_group_cachep)
+		kmem_cache_destroy(dazukofs_group_cachep);
 	if (dazukofs_event_container_cachep)
 		kmem_cache_destroy(dazukofs_event_container_cachep);
 	if (dazukofs_event_cachep)
@@ -211,10 +231,17 @@
  * Description: All pending and in-progress events are released/freed.
  * Any processes waiting on the queue are woken.
  *
+ * The actual group structure is not deleted, but rather marked as
+ * deprecated. Deprecated group structures are deleted as new
+ * groups are added.
+ *
  * IMPORTANT: This function requires work_mutex to be held!
  */
 static void __remove_group(struct dazukofs_group *grp)
 {
+	grp->deprecated = 1;
+	group_count--;
+
 	__clear_group_event_list(&grp->working_list.list);
 	__clear_group_event_list(&grp->todo_list.list);
 
@@ -229,17 +256,272 @@
  */
 void dazukofs_destroy_events(void)
 {
-	/* free the group items */
-	mutex_lock(&work_mutex);
-	__remove_group(&reg_group);
-	mutex_unlock(&work_mutex);
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+	struct list_head *q;
+
+	/*
+	 * We are not using any locks here because we assume
+	 * everything else has been already cleaned up by
+	 * the device layer.
+	 */
+
+	/* free the groups */
+	list_for_each_safe(pos, q, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		list_del(pos);
+
+		__remove_group(grp);
+
+		/* free group name */
+		kfree(grp->name);
+
+		/* free group */
+		kmem_cache_free(dazukofs_group_cachep, grp);
+	}
 
 	/* free everything else */
+	kmem_cache_destroy(dazukofs_group_cachep);
 	kmem_cache_destroy(dazukofs_event_container_cachep);
 	kmem_cache_destroy(dazukofs_event_cachep);
 }
 
 /**
+ * __check_for_group - check if a group exists
+ * @name: a group name to check for
+ * @id: a group id to check for
+ * @already_exists: will be set if the group already exists
+ *
+ * Description: This function checks names and id's to see if a group may
+ * be created. If the id already exists, but with a different group name,
+ * the group cannot be created. If the group name exists, but with a
+ * different id, the group cannot be created.
+ *
+ * If the group name exists and the id is already that which is requested,
+ * the function returns success, but sets the already_exists flag.
+ *
+ * IMPORTANT: This function requires work_mutex to be held!
+ *
+ * Returns 0 if the group exists or may be created.
+ */
+static int __check_for_group(const char *name, int id, int *already_exists)
+{
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+	struct list_head *q;
+	int id_available = 1;
+
+	*already_exists = 0;
+
+	list_for_each_safe(pos, q, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (grp->deprecated) {
+			/* cleanup deprecated groups */
+			if (atomic_read(&grp->use_count) == 0) {
+				list_del(pos);
+				kfree(grp->name);
+				kmem_cache_free(dazukofs_group_cachep, grp);
+			}
+		} else {
+			if (strcmp(name, grp->name) == 0) {
+				*already_exists = 1;
+				break;
+			} else if (grp->group_id == id) {
+				id_available = 0;
+				break;
+			}
+		}
+	}
+
+	if (*already_exists)
+		return 0;
+
+	if (id_available) {
+		/* we have found a free id */
+		return 0;
+	}
+
+	return -1;
+}
+
+/**
+ * __create_group - allocate and initialize a group structure
+ * @name: the name of the new group
+ * @id: the id of the new group
+ *
+ * Description: This function allocates and initializes a group
+ * structure. The group_count should be locked to ensure that
+ * the group id remains available until the group can be
+ * added to the group list.
+ *
+ * Returns the newly created and initialized group structure.
+ */
+static struct dazukofs_group *__create_group(const char *name, int id)
+{
+	struct dazukofs_group *grp;
+
+	grp = kmem_cache_zalloc(dazukofs_group_cachep, GFP_KERNEL);
+	if (!grp)
+		return NULL;
+
+	atomic_set(&grp->use_count, 0);
+	grp->group_id = id;
+	grp->name = kstrdup(name, GFP_KERNEL);
+	if (!grp->name) {
+		kmem_cache_free(dazukofs_group_cachep, grp);
+		return NULL;
+	}
+	grp->name_length = strlen(name);
+	init_waitqueue_head(&grp->queue);
+	INIT_LIST_HEAD(&grp->todo_list.list);
+	INIT_LIST_HEAD(&grp->working_list.list);
+	return grp;
+}
+
+/**
+ * dazukofs_add_group - add a new group
+ * @name: the name of the group to add
+ *
+ * Description: This function is called by the device layer to add a new
+ * group. It returns success if the group has been successfully created
+ * or if the group already exists.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_add_group(const char *name)
+{
+	int ret = 0;
+	int already_exists;
+	int available_id = 0;
+	struct dazukofs_group *grp;
+
+	write_lock(&group_count_rwlock);
+
+	mutex_lock(&work_mutex);
+	while (__check_for_group(name, available_id, &already_exists) != 0) {
+		/* try again with the next id */
+		available_id++;
+	}
+	mutex_unlock(&work_mutex);
+
+	if (already_exists)
+		goto out;
+
+	/* if we are here, the group doesn't already exist */
+
+	/* do we have room for a new group? */
+	if (group_count == GROUP_COUNT) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	grp = __create_group(name, available_id);
+	if (!grp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mutex_lock(&work_mutex);
+	list_add_tail(&grp->list, &group_list.list);
+	mutex_unlock(&work_mutex);
+
+	group_count++;
+out:
+	write_unlock(&group_count_rwlock);
+	return ret;
+}
+
+/**
+ * dazukofs_remove_group - remove a group
+ * @name: the name of the group to remove
+ *
+ * Description: This function is called by the device layer to remove a
+ * group. It returns success if the group has been deleted or the group
+ * does not exist.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_remove_group(const char *name)
+{
+	int ret = 0;
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+
+	write_lock(&group_count_rwlock);
+
+	if (group_count == 0)
+		goto out;
+
+	mutex_lock(&work_mutex);
+	/* set group deprecated */
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated && strcmp(name, grp->name) == 0) {
+			__remove_group(grp);
+			break;
+		}
+	}
+	mutex_unlock(&work_mutex);
+out:
+	write_unlock(&group_count_rwlock);
+	return ret;
+}
+
+/**
+ * dazukofs_get_groups - get the names and id's of active groups as strings
+ * @buf: to be assigned the list of groups as a single printable string
+ *
+ * Description: This function will allocate a string that includes all the
+ * active (not deprecated) groups and their id's. This function is called
+ * by the device layer for presenting userspace with the list of groups.
+ *
+ * This function will allocate memory that must be freed by the caller.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_get_groups(char **buf)
+{
+	struct dazukofs_group *grp;
+	char *tmp;
+	struct list_head *pos;
+	size_t buflen;
+	size_t allocsize = 256;
+
+tryagain:
+	*buf = kzalloc(allocsize, GFP_KERNEL);
+	if (!*buf)
+		return -ENOMEM;
+	tmp = *buf;
+	buflen = 1;
+
+	mutex_lock(&work_mutex);
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated)
+			buflen += grp->name_length + 3;
+	}
+	if (buflen < allocsize) {
+		list_for_each(pos, &group_list.list) {
+			grp = list_entry(pos, struct dazukofs_group, list);
+			if (!grp->deprecated) {
+				snprintf(tmp, (allocsize - 1) - (tmp - *buf),
+					 "%lu:%s\n", grp->group_id,
+					 grp->name);
+				tmp += grp->name_length + 3;
+			}
+		}
+		mutex_unlock(&work_mutex);
+	} else {
+		mutex_unlock(&work_mutex);
+		allocsize *= 2;
+		kfree(*buf);
+		goto tryagain;
+	}
+
+	return 0;
+}
+
+/**
  * check_recursion - check if current process is recursing
  *
  * Description: A list of anonymous processes is managed to prevent
@@ -296,14 +578,19 @@
 
 /**
  * check_access_precheck - check if an access event should be generated
+ * @grp_count: the current number of groups
  *
  * Description: Check if the current process should cause an access event
  * to be generated.
  *
  * Returns 0 if an access event should be generated.
  */
-static int check_access_precheck(void)
+static int check_access_precheck(int grp_count)
 {
+	/* do we have any groups? */
+	if (grp_count == 0)
+		return -1;
+
 	/* am I a recursion process? */
 	if (!check_recursion())
 		return -1;
@@ -312,19 +599,22 @@
 }
 
 /**
- * assign_event_to_group - post an event to be processed
+ * assign_event_to_groups - post an event to be processed
  * @evt: the event to be posted
- * @ec: the container for the event
+ * @ec_array: the containers for the event
  *
  * Description: This function will assign a unique id to the event.
- * The event will be associated with its container and placed on the
- * group's todo list. The group will also be woken to handle the new
- * event.
+ * The event will be associated with each container and the container is
+ * placed on each group's todo list. Each group will also be woken to
+ * handle the new event.
  */
 static void
-assign_event_to_group(struct dazukofs_event *evt,
-		      struct dazukofs_event_container *ec) {
-	struct dazukofs_group *grp = &reg_group;
+assign_event_to_groups(struct dazukofs_event *evt,
+		       struct dazukofs_event_container *ec_array[])
+{
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+	int i;
 
 	mutex_lock(&work_mutex);
 	mutex_lock(&evt->assigned_mutex);
@@ -334,44 +624,67 @@
 	last_event_id++;
 	evt->event_id = last_event_id;
 
-	ec->event = evt;
-	evt->assigned = 1;
-	list_add_tail(&ec->list, &grp->todo_list.list);
+	/* assign the event to each group */
+	i = 0;
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated) {
+			ec_array[i]->event = evt;
+
+			evt->assigned++;
+			list_add_tail(&ec_array[i]->list,
+				      &grp->todo_list.list);
 
-	/* notify someone to handle the event */
-	wake_up(&grp->queue);
+			/* notify someone to handle the event */
+			wake_up(&grp->queue);
+
+			i++;
+		}
+	}
 
 	mutex_unlock(&evt->assigned_mutex);
 	mutex_unlock(&work_mutex);
 }
 
 /**
- * allocate_event_and_container - allocate an event and event container
+ * allocate_event_and_containers - allocate an event and event containers
  * @evt: event pointer to be assigned a new event
- * @ec: event container to be assigned a new container
+ * @ec: event container array to be filled with new array of containers
+ * @grp_count: the number of groups (size of the array)
  *
  * Description: New event and event container structures are allocated
  * and initialized.
  *
  * Returns 0 on success.
  */
-static int allocate_event_and_container(struct dazukofs_event **evt,
-					struct dazukofs_event_container **ec)
+static int
+allocate_event_and_containers(struct dazukofs_event **evt,
+			      struct dazukofs_event_container *ec_array[],
+			      int grp_count)
 {
+	int i;
+
 	*evt = kmem_cache_zalloc(dazukofs_event_cachep, GFP_KERNEL);
 	if (!*evt)
 		return -1;
 	init_waitqueue_head(&(*evt)->queue);
 	mutex_init(&(*evt)->assigned_mutex);
 
-	/* allocate container now while we don't have a lock */
-	*ec = kmem_cache_zalloc(dazukofs_event_container_cachep, GFP_KERNEL);
-	if (!*ec)
-		goto error_out;
+	/* allocate containers now while we don't have a lock */
+	for (i = 0; i < grp_count; i++) {
+		ec_array[i] = kmem_cache_zalloc(
+				dazukofs_event_container_cachep, GFP_KERNEL);
+		if (!ec_array[i])
+			goto error_out;
+	}
 
 	return 0;
 
 error_out:
+	for (i--; i >= 0; i--) {
+		kmem_cache_free(dazukofs_event_container_cachep, ec_array[i]);
+		ec_array[i] = NULL;
+	}
 	kmem_cache_free(dazukofs_event_cachep, *evt);
 	*evt = NULL;
 	return -1;
@@ -389,16 +702,21 @@
  */
 int dazukofs_check_access(struct dentry *dentry, struct vfsmount *mnt)
 {
-	struct dazukofs_event_container *ec;
+	struct dazukofs_event_container *ec_array[GROUP_COUNT];
 	struct dazukofs_event *evt;
 	int err;
 
-	if (check_access_precheck())
+	read_lock(&group_count_rwlock);
+
+	if (check_access_precheck(group_count)) {
+		read_unlock(&group_count_rwlock);
 		return 0;
+	}
 
 	/* at this point, the access should be handled */
 
-	if (allocate_event_and_container(&evt, &ec)) {
+	if (allocate_event_and_containers(&evt, ec_array, group_count)) {
+		read_unlock(&group_count_rwlock);
 		err = -ENOMEM;
 		goto out;
 	}
@@ -407,7 +725,9 @@
 	evt->mnt = mntget(mnt);
 	evt->pid = current->pid;
 
-	assign_event_to_group(evt, ec);
+	assign_event_to_groups(evt, ec_array);
+
+	read_unlock(&group_count_rwlock);
 
 	/* wait until event completely processed or signal */
 	err = wait_event_freezable(evt->queue, event_assigned(evt) == 0);
@@ -422,6 +742,7 @@
 
 /**
  * dazukofs_return_event - return checked file access results
+ * @group_id: id of the group the event came from
  * @event_id: the id of the event
  * @deny: a flag indicating if file access should be denied
  *
@@ -431,9 +752,10 @@
  *
  * Returns 0 on success.
  */
-int dazukofs_return_event(unsigned long event_id, int deny)
+int dazukofs_return_event(unsigned long group_id, unsigned long event_id,
+			  int deny)
 {
-	struct dazukofs_group *grp = &reg_group;
+	struct dazukofs_group *grp;
 	struct dazukofs_event_container *ec;
 	struct dazukofs_event *evt = NULL;
 	struct list_head *pos;
@@ -441,6 +763,20 @@
 	int ret = 0;
 
 	mutex_lock(&work_mutex);
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated && grp->group_id == group_id) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		ret = -EFAULT;
+		mutex_unlock(&work_mutex);
+		goto out;
+	}
+
+	found = 0;
 	list_for_each(pos, &grp->working_list.list) {
 		ec = list_entry(pos, struct dazukofs_event_container, list);
 		evt = ec->event;
@@ -457,6 +793,7 @@
 		release_event(evt, 1, deny);
 	else
 		ret = -EFAULT;
+out:
 	return ret;
 }
 
@@ -591,6 +928,7 @@
 
 /**
  * dazukofs_get_event - get an event to process
+ * @group_id: id of the group we belong to
  * @event_id: to be filled in with the new event id
  * @fd: to be filled in with the opened file descriptor
  * @pid: to be filled in with the pid of the process generating the event
@@ -601,18 +939,43 @@
  *
  * Returns 0 on success.
  */
-int dazukofs_get_event(unsigned long *event_id, int *fd, pid_t *pid)
+int dazukofs_get_event(unsigned long group_id, unsigned long *event_id,
+		       int *fd, pid_t *pid)
 {
-	struct dazukofs_group *grp = &reg_group;
+	struct dazukofs_group *grp;
 	struct dazukofs_event_container *ec;
+	struct list_head *pos;
+	int found = 0;
 	int ret = 0;
 
+	mutex_lock(&work_mutex);
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated && grp->group_id == group_id) {
+			atomic_inc(&grp->use_count);
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&work_mutex);
+
+	if (!found) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	while (1) {
 		ret = wait_event_freezable(grp->queue,
-					   is_event_available(grp));
+					   is_event_available(grp) ||
+					   grp->deprecated);
 		if (ret != 0)
 			break;
 
+		if (grp->deprecated) {
+			ret = -EFAULT;
+			break;
+		}
+
 		ec = claim_event(grp);
 		if (ec) {
 			ret = open_file(ec);
@@ -626,5 +989,7 @@
 			}
 		}
 	}
+	atomic_dec(&grp->use_count);
+out:
 	return ret;
 }
Index: linux-2.6.28/fs/dazukofs/Makefile
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/Makefile	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/Makefile	2009-02-03 18:11:01.000000000 +0100
@@ -5,4 +5,4 @@
 obj-$(CONFIG_DAZUKOFS_FS) += dazukofs.o
 
 dazukofs-objs := super.o inode.o file.o dentry.o mmap.o event.o \
-		 dev.o group_dev.o
+		 dev.o group_dev.o ctrl_dev.o
Index: linux-2.6.28/fs/dazukofs/ctrl_dev.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.28/fs/dazukofs/ctrl_dev.c	2009-02-03 18:11:01.000000000 +0100
@@ -0,0 +1,198 @@
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
+#include "event.h"
+#include "dev.h"
+
+static int dazukofs_ctrl_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return 0;
+}
+
+static int dazukofs_ctrl_release(struct inode *inode, struct file *file)
+{
+	/*
+	 * checkpatch.pl recommends not checking for NULL before freeing
+	 * the data because kfree(NULL) is allowed. However, that is
+	 * poor style and leads to sloppy programming.
+	 */
+
+	if (file->private_data)
+		kfree(file->private_data);
+
+	return 0;
+}
+
+static ssize_t dazukofs_ctrl_read(struct file *file, char __user *buffer,
+				  size_t length, loff_t *pos)
+{
+	char *buf = file->private_data;
+	size_t buflen;
+	int err;
+
+	if (!file->private_data) {
+		err = dazukofs_get_groups(&buf);
+		if (err)
+			return err;
+		file->private_data = buf;
+	}
+	buflen = strlen(buf);
+
+	if (*pos >= buflen)
+		return 0;
+
+	if (length > buflen - *pos)
+		length = buflen - *pos;
+
+	if (copy_to_user(buffer, buf + *pos, length))
+		return -EFAULT;
+
+	*pos += length;
+
+	return length;
+}
+
+#define DAZUKOFS_ALLOWED_GROUPCHARS \
+	"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
+static int is_valid_char(char c)
+{
+	if (strchr(DAZUKOFS_ALLOWED_GROUPCHARS, c) != NULL)
+		return 1;
+	return 0;
+}
+
+static int process_command(char *buf, const char *key,
+			   int (*func)(const char *),
+			   int *retcode)
+{
+	char *p;
+	char *p2;
+
+	p = strstr(buf, key);
+	if (!p)
+		return -1;
+
+	p += strlen(key);
+
+	for (p2 = p; is_valid_char(*p2); p2++)
+		;
+
+	if (p == p2) {
+		*retcode = -EINVAL;
+	} else {
+		*p2 = 0;
+		*retcode = func(p);
+		*p2 = ' ';
+	}
+
+	return 0;
+}
+
+static ssize_t dazukofs_ctrl_write(struct file *file,
+				   const char __user *buffer, size_t length,
+				   loff_t *pos)
+{
+#define DAZUKOFS_MAX_WRITE_BUFFER 32
+	char tmp[DAZUKOFS_MAX_WRITE_BUFFER];
+	int match = 0;
+	int ret = -EINVAL;
+	int cp_len = length;
+
+	if (cp_len >= DAZUKOFS_MAX_WRITE_BUFFER)
+		cp_len = DAZUKOFS_MAX_WRITE_BUFFER - 1;
+
+	if (copy_from_user(tmp, buffer, cp_len))
+		return -EFAULT;
+
+	tmp[cp_len] = 0;
+
+	if (!match || (match && ret >= 0)) {
+		if (process_command(tmp, "del=",
+				    dazukofs_remove_group, &ret) == 0) {
+			match = 1;
+		}
+	}
+
+	if (!match || (match && ret >= 0)) {
+		if (process_command(tmp, "add=",
+				    dazukofs_add_group, &ret) == 0) {
+			match = 1;
+		}
+	}
+
+	if (ret >= 0) {
+		*pos += length;
+		ret = length;
+	}
+
+	return ret;
+}
+
+static struct cdev ctrl_cdev;
+
+static const struct file_operations ctrl_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dazukofs_ctrl_open,
+	.release	= dazukofs_ctrl_release,
+	.read		= dazukofs_ctrl_read,
+	.write		= dazukofs_ctrl_write,
+};
+
+int dazukofs_ctrl_dev_init(int dev_major, int dev_minor,
+			   struct class *dazukofs_class)
+{
+	int err = 0;
+	struct device *dev;
+
+	/* setup cdev for control */
+	cdev_init(&ctrl_cdev, &ctrl_fops);
+	ctrl_cdev.owner = THIS_MODULE;
+	err = cdev_add(&ctrl_cdev, MKDEV(dev_major, dev_minor), 1);
+	if (err)
+		goto error_out1;
+
+	/* create control device */
+	dev = device_create(dazukofs_class, NULL, MKDEV(dev_major, dev_minor),
+			    NULL, "%s.ctrl", DEVICE_NAME);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto error_out2;
+	}
+
+	return 0;
+
+error_out2:
+	cdev_del(&ctrl_cdev);
+error_out1:
+	return err;
+}
+
+void dazukofs_ctrl_dev_destroy(int dev_major, int dev_minor,
+			       struct class *dazukofs_class)
+{
+	device_destroy(dazukofs_class, MKDEV(dev_major, dev_minor));
+	cdev_del(&ctrl_cdev);
+}
Index: linux-2.6.28/fs/dazukofs/group_dev.c
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/group_dev.c	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/group_dev.c	2009-02-03 18:11:01.000000000 +0100
@@ -27,7 +27,7 @@
 #include "event.h"
 #include "dev.h"
 
-static ssize_t dazukofs_group_read(struct file *file,
+static ssize_t dazukofs_group_read(int group_id, struct file *file,
 				   char __user *buffer, size_t length,
 				   loff_t *pos)
 {
@@ -45,7 +45,7 @@
 	if (length < DAZUKOFS_MIN_READ_BUFFER)
 		return -EINVAL;
 
-	err = dazukofs_get_event(&event_id, &fd, &pid);
+	err = dazukofs_get_event(group_id, &event_id, &fd, &pid);
 	if (err) {
 		if (err == -ERESTARTSYS)
 			return -EINTR;
@@ -65,7 +65,7 @@
 	return tmp_used;
 }
 
-static ssize_t dazukofs_group_write(struct file *file,
+static ssize_t dazukofs_group_write(int group_id, struct file *file,
 				    const char __user *buffer, size_t length,
 				    loff_t *pos)
 {
@@ -100,7 +100,7 @@
 		return -EINVAL;
 	response = (*(p + 2)) - '0';
 
-	ret = dazukofs_return_event(event_id, response);
+	ret = dazukofs_return_event(group_id, event_id, response);
 	if (ret == 0) {
 		*pos += length;
 		ret = length;
@@ -111,12 +111,50 @@
 	return ret;
 }
 
-static struct cdev group_cdev;
+#define DECLARE_GROUP_FOPS(group_id) \
+static ssize_t \
+dazukofs_group_read_##group_id(struct file *file, char __user *buffer, \
+			       size_t length, loff_t *pos) \
+{ \
+	return dazukofs_group_read(group_id, file, buffer, length, pos); \
+} \
+static ssize_t \
+dazukofs_group_write_##group_id(struct file *file, \
+				const char __user *buffer, size_t length, \
+				loff_t *pos) \
+{ \
+	return dazukofs_group_write(group_id, file, buffer, length, pos); \
+} \
+static const struct file_operations group_fops_##group_id = { \
+	.owner		= THIS_MODULE, \
+	.read		= dazukofs_group_read_##group_id, \
+	.write		= dazukofs_group_write_##group_id, \
+};
 
-static const struct file_operations group_fops = {
-	.owner		= THIS_MODULE,
-	.read		= dazukofs_group_read,
-	.write		= dazukofs_group_write,
+DECLARE_GROUP_FOPS(0)
+DECLARE_GROUP_FOPS(1)
+DECLARE_GROUP_FOPS(2)
+DECLARE_GROUP_FOPS(3)
+DECLARE_GROUP_FOPS(4)
+DECLARE_GROUP_FOPS(5)
+DECLARE_GROUP_FOPS(6)
+DECLARE_GROUP_FOPS(7)
+DECLARE_GROUP_FOPS(8)
+DECLARE_GROUP_FOPS(9)
+
+static struct cdev groups_cdev[GROUP_COUNT];
+
+static const struct file_operations *group_fops[GROUP_COUNT] = {
+	&group_fops_0,
+	&group_fops_1,
+	&group_fops_2,
+	&group_fops_3,
+	&group_fops_4,
+	&group_fops_5,
+	&group_fops_6,
+	&group_fops_7,
+	&group_fops_8,
+	&group_fops_9,
 };
 
 int dazukofs_group_dev_init(int dev_major, int dev_minor_start,
@@ -124,29 +162,41 @@
 {
 	int err;
 	struct device *dev;
+	int i;
+	int cdev_count;
 	int dev_minor_end = dev_minor_start;
 
-	cdev_init(&group_cdev, &group_fops);
-	group_cdev.owner = THIS_MODULE;
-	err = cdev_add(&group_cdev, MKDEV(dev_major, dev_minor_start), 1);
-	if (err)
-		goto error_out1;
-
-	dev = device_create(dazukofs_class, NULL,
-			    MKDEV(dev_major, dev_minor_end), NULL,
-			    "%s.%d", DEVICE_NAME, 0);
-	if (IS_ERR(dev)) {
-		err = PTR_ERR(dev);
-		goto error_out2;
+	/* setup cdevs for groups */
+	for (cdev_count = 0; cdev_count < GROUP_COUNT; cdev_count++) {
+		cdev_init(&groups_cdev[cdev_count], group_fops[cdev_count]);
+		groups_cdev[cdev_count].owner = THIS_MODULE;
+		err = cdev_add(&groups_cdev[cdev_count],
+			       MKDEV(dev_major, dev_minor_start + cdev_count),
+			       GROUP_COUNT);
+		if (err)
+			goto error_out1;
+	}
+
+	/* create group devices */
+	for (i = 0; i < GROUP_COUNT; i++) {
+		dev = device_create(dazukofs_class, NULL,
+				    MKDEV(dev_major, dev_minor_end), NULL,
+				    "%s.%d", DEVICE_NAME, i);
+		if (IS_ERR(dev)) {
+			err = PTR_ERR(dev);
+			goto error_out2;
+		}
+		dev_minor_end++;
 	}
-	dev_minor_end++;
 
 	return dev_minor_end;
 
 error_out2:
-	device_destroy(dazukofs_class, MKDEV(dev_major, 0));
+	for (i = dev_minor_start; i < dev_minor_end; i++)
+		device_destroy(dazukofs_class, MKDEV(dev_major, i));
 error_out1:
-	cdev_del(&group_cdev);
+	for (i = 0; i < cdev_count; i++)
+		cdev_del(&groups_cdev[i]);
 	return err;
 }
 
@@ -154,6 +204,11 @@
 				int dev_minor_end,
 				struct class *dazukofs_class)
 {
-	device_destroy(dazukofs_class, MKDEV(dev_major, 0));
-	cdev_del(&group_cdev);
+	int i;
+
+	for (i = dev_minor_start; i < dev_minor_end; i++)
+		device_destroy(dazukofs_class, MKDEV(dev_major, i));
+
+	for (i = 0; i < GROUP_COUNT; i++)
+		cdev_del(&groups_cdev[i]);
 }
Index: linux-2.6.28/fs/dazukofs/dev.c
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/dev.c	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/dev.c	2009-02-03 18:11:01.000000000 +0100
@@ -42,7 +42,7 @@
 	if (err)
 		goto error_out1;
 
-	err = alloc_chrdev_region(&devt, 0, 1, DEVICE_NAME);
+	err = alloc_chrdev_region(&devt, 0, 1 + GROUP_COUNT, DEVICE_NAME);
 	if (err)
 		goto error_out2;
 	dev_major = MAJOR(devt);
@@ -54,20 +54,28 @@
 		goto error_out3;
 	}
 
+	err = dazukofs_ctrl_dev_init(dev_major, dev_minor_start,
+				     dazukofs_class);
+	if (err)
+		goto error_out4;
+
 	dev_minor_end = dazukofs_group_dev_init(dev_major,
 						dev_minor_start + 1,
 						dazukofs_class);
 	if (dev_minor_end < 0) {
 		err = dev_minor_end;
-		goto error_out4;
+		goto error_out5;
 	}
 
 	return 0;
 
+error_out5:
+	dazukofs_ctrl_dev_destroy(dev_major, dev_minor_start, dazukofs_class);
 error_out4:
 	class_destroy(dazukofs_class);
 error_out3:
-	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start), 1);
+	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start),
+				 1 + GROUP_COUNT);
 error_out2:
 	dazukofs_destroy_events();
 error_out1:
@@ -78,7 +86,9 @@
 {
 	dazukofs_group_dev_destroy(dev_major, dev_minor_start + 1,
 				   dev_minor_end, dazukofs_class);
+	dazukofs_ctrl_dev_destroy(dev_major, dev_minor_start, dazukofs_class);
 	class_destroy(dazukofs_class);
-	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start), 1);
+	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start),
+				 1 + GROUP_COUNT);
 	dazukofs_destroy_events();
 }
Index: linux-2.6.28/fs/dazukofs/dev.h
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/dev.h	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/dev.h	2009-02-03 18:11:01.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 
 #define DEVICE_NAME	"dazukofs"
+#define GROUP_COUNT	10
 
 extern int dazukofs_dev_init(void);
 extern void dazukofs_dev_destroy(void);
@@ -34,4 +35,9 @@
 				       int dev_minor_end,
 				       struct class *dazukofs_class);
 
+extern int dazukofs_ctrl_dev_init(int dev_major, int dev_minor,
+				  struct class *dazukofs_class);
+extern void dazukofs_ctrl_dev_destroy(int dev_major, int dev_minor,
+				      struct class *dazukofs_class);
+
 #endif /* __DEV_H */
Index: linux-2.6.28/fs/dazukofs/event.h
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/event.h	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/event.h	2009-02-03 18:11:01.000000000 +0100
@@ -24,9 +24,15 @@
 extern int dazukofs_init_events(void);
 extern void dazukofs_destroy_events(void);
 
-extern int dazukofs_get_event(unsigned long *event_id, int *fd, pid_t *pid);
-extern int dazukofs_return_event(unsigned long event_id, int deny);
+extern int dazukofs_get_event(unsigned long group_id,
+			      unsigned long *event_id, int *fd, pid_t *pid);
+extern int dazukofs_return_event(unsigned long group_id,
+				 unsigned long event_id, int deny);
 
 extern int dazukofs_check_access(struct dentry *dentry, struct vfsmount *mnt);
 
+extern int dazukofs_get_groups(char **buf);
+extern int dazukofs_add_group(const char *name);
+extern int dazukofs_remove_group(const char *name);
+
 #endif /* __EVENT_H */
Index: linux-2.6.28/Documentation/filesystems/dazukofs.txt
===================================================================
--- linux-2.6.28.orig/Documentation/filesystems/dazukofs.txt	2009-02-03 18:10:46.000000000 +0100
+++ linux-2.6.28/Documentation/filesystems/dazukofs.txt	2009-02-03 18:11:01.000000000 +0100
@@ -24,13 +24,10 @@
 registered with DazukoFS. That process can then choose to allow or deny
 the access.
 
-IMPORTANT: DazukoFS does not allow file access events unless a registered
-           application has approved them. This means that no file access
-           can take place on a DazukoFS mount until an application has
-           registered to perform file access control with DazukoFS.
-           Attempts to access files on a DazukoFS mount will result in the
-           process blocking until a registered application has approved
-           the access.
+IMPORTANT: Initially, DazukoFS will allow all file access events to occur
+           until an application registers to perform file access control.
+           Once an application has registered with DazukoFS, all file access
+           events must be authorized by the registered application.
 
 The stackable filesystem can then be unmounted with:
 
@@ -114,10 +111,41 @@
 file access events. The application then also has the authority to block
 the file access.
 
-For each file access event, only one of the registered applications will
-be notified.
+DazukoFS supports multiple groups. A group is a set of registered processes
+that work together. For each file access event, only one of the registered
+processes of a group will be notified. By registering multiple processes
+within the same group, an application will be able to perform file access
+control for multiple files simultaneously.
 
-By opening the device /dev/dazukofs.0 an application has registered itself.
+A list of registered groups can be seen by reading from the
+/dev/dazukofs.ctrl device. For example:
+
+0:Group_A
+1:Group_B
+
+This means that the group named "Group_A" has been assigned the group id 0
+and the group name "Group_B" has been assigned the group id 1. Groups can
+be added by writing to the /dev/dazukofs.ctrl device. For example, writing:
+
+add=My_New_Group
+
+will create a new group, which will be assigned an available group id. The
+creation of the group should be verified by reading from the
+/dev/dazukofs.ctrl device. This is also necessary to see which group id was
+assigned to the new group.
+
+0:Group_A
+1:Group_B
+2:My_New_Group
+
+The new group "My_New_Group" has been assigned the group id 2. Group names
+are restricted to the characters: a-z A-Z 0-9 - _
+
+Each group has their own device /dev/dazukofs.N in order to interact with
+DazukoFS (where 'N' is the group id). For "My_New_Group" we are assigned
+/dev/dazukofs.2 to use.
+
+By opening the device /dev/dazukofs.N an application has registered itself.
 A read on the device will block until a file access event on DazukoFS has
 taken place. When a file access event has occured, the read will return with
 information about the file access event. For example:
@@ -155,4 +183,27 @@
 NOTE: It is not necessary for the device to be open while the application
       decides if access should be allowed. In fact, it doesn't even have to
       be the same process that responds. DazukoFS is only interested in a
-      response for the given event id.
+      response that matches the pending event id.
+
+A group can be deleted by writing to the /dev/dazukofs.ctrl device. For
+example, writing:
+
+del=My_New_Group
+
+When a group is deleted, any processes registered with that group will
+be interrupted. Further reads on /dev/dazukofs.N will result in an error
+(until some other group has been assigned that group id).
+
+The deletion of the group should be verified by reading from the
+/dev/dazukofs.ctrl device.
+
+0:Group_A
+1:Group_B
+
+If no groups have been added, DazukoFS will allow all file access events. If,
+however, at least one group is added, DazukoFS will expect one process from
+each group to handle every file access event. Even if no processes are
+registered but one or more groups exist, DazukoFS will still wait for file
+access events to be handled by each group. For this reason it is important
+that an application deletes a group it has created, once it should no longer
+perform online file access control.
