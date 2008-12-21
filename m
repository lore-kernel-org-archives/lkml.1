Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYLUPBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYLUPBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYLUPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:00:53 -0500
Received: from www.tglx.de ([62.245.132.106]:56824 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYLUPAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:00:50 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 4/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
	<868wq9h905.fsf@johno-ibook.fn.ogness.net>
	<864p0xh8y7.fsf_-_@johno-ibook.fn.ogness.net>
	<86zlipfubt.fsf_-_@johno-ibook.fn.ogness.net>
Date: Sun, 21 Dec 2008 16:00:13 +0100
In-Reply-To: <86zlipfubt.fsf_-_@johno-ibook.fn.ogness.net> (John Ogness's message of "Sun\, 21 Dec 2008 15\:59\:02 +0100")
Message-ID: <86vdtdfu9u.fsf_-_@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 4: Adds a new (optional) command to allow registered processes
         to be tracked. The tracking allows processes to be
         automatically unregistered if they crash and also allows
         groups to be automatically deleted if no more processes are
         registered.

Patched against 2.6.28-rc9.

Signed-off-by: John Ogness <dazukocode@ogness.net>
---
 Documentation/filesystems/dazukofs.txt |   24 ++++-
 fs/dazukofs/ctrl_dev.c                 |   15 ++-
 fs/dazukofs/event.c                    |  102 +++++++++++++++++++++--
 fs/dazukofs/event.h                    |    7 +
 fs/dazukofs/group_dev.c                |   30 ++++++
 5 files changed, 161 insertions(+), 17 deletions(-)
Index: linux-2.6.27/fs/dazukofs/ctrl_dev.c
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/ctrl_dev.c	2008-12-21 15:10:24.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/ctrl_dev.c	2008-12-21 15:10:38.000000000 +0100
@@ -85,7 +85,7 @@
 }
 
 static int process_command(char *buf, const char *key,
-			   int (*func)(const char *),
+			   int (*func)(const char *, int), int arg2,
 			   int *retcode)
 {
 	char *p;
@@ -104,7 +104,7 @@
 		*retcode = -EINVAL;
 	} else {
 		*p2 = 0;
-		*retcode = func(p);
+		*retcode = func(p, arg2);
 		*p2 = ' ';
 	}
 
@@ -131,14 +131,21 @@
 
 	if (!match || (match && ret >= 0)) {
 		if (process_command(tmp, "del=",
-				    dazukofs_remove_group, &ret) == 0) {
+				    dazukofs_remove_group, 0, &ret) == 0) {
 			match = 1;
 		}
 	}
 
 	if (!match || (match && ret >= 0)) {
 		if (process_command(tmp, "add=",
-				    dazukofs_add_group, &ret) == 0) {
+				    dazukofs_add_group, 0, &ret) == 0) {
+			match = 1;
+		}
+	}
+
+	if (!match || (match && ret >= 0)) {
+		if (process_command(tmp, "addtrack=",
+				    dazukofs_add_group, 1, &ret) == 0) {
 			match = 1;
 		}
 	}
Index: linux-2.6.27/fs/dazukofs/event.c
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/event.c	2008-12-21 15:10:24.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/event.c	2008-12-21 15:10:38.000000000 +0100
@@ -64,6 +64,8 @@
 	wait_queue_head_t queue;
 	struct dazukofs_event_container working_list;
 	atomic_t use_count;
+	int tracking;
+	int track_count;
 	int deprecated;
 };
 
@@ -366,9 +368,10 @@
 }
 
 /**
- * __check_for_group - check if a group exists
+ * __check_for_group - check if a group exists and set tracking
  * @name: a group name to check for
  * @id: a group id to check for
+ * @track: flag set if tracking is to be used
  * @already_exists: will be set if the group already exists
  *
  * Description: This function checks names and id's to see if a group may
@@ -379,11 +382,17 @@
  * If the group name exists and the id is already that which is requested,
  * the function returns success, but sets the already_exists flag.
  *
+ * NOTE: Although the function name may imply read-only, this function
+ *       _will_ set a group to track if the group is found to exist and
+ *       tracking should be set. We do this because it is convenient
+ *       since the work_mutex is already locked.
+ *
  * IMPORTANT: This function requires work_mutex to be held!
  *
  * Returns 0 if the group exists or may be created.
  */
-static int __check_for_group(const char *name, int id, int *already_exists)
+static int __check_for_group(const char *name, int id, int track,
+			     int *already_exists)
 {
 	struct dazukofs_group *grp;
 	struct list_head *pos;
@@ -404,6 +413,8 @@
 		} else {
 			if (strcmp(name, grp->name) == 0) {
 				*already_exists = 1;
+				if (track)
+					grp->tracking = 1;
 				break;
 			} else if (grp->group_id == id) {
 				id_available = 0;
@@ -427,6 +438,7 @@
  * create_group - allocate and initialize a group structure
  * @name: the name of the new group
  * @id: the id of the new group
+ * @track: flag set if tracking is to be used
  *
  * Description: This function allocates and initializes a group
  * structure. The group_count should be locked to ensure that
@@ -435,7 +447,7 @@
  *
  * Returns the newly created and initialized group structure.
  */
-static struct dazukofs_group *create_group(const char *name, int id)
+static struct dazukofs_group *create_group(const char *name, int id, int track)
 {
 	struct dazukofs_group *grp;
 
@@ -454,20 +466,27 @@
 	init_waitqueue_head(&grp->queue);
 	INIT_LIST_HEAD(&grp->todo_list.list);
 	INIT_LIST_HEAD(&grp->working_list.list);
+	if (track)
+		grp->tracking = 1;
 	return grp;
 }
 
 /**
  * dazukofs_add_group - add a new group
  * @name: the name of the group to add
+ * @track: flag set if tracking is to be used
  *
  * Description: This function is called by the device layer to add a new
  * group. It returns success if the group has been successfully created
  * or if the group already exists.
  *
+ * If the group already exists and is not tracking, but "track" is set,
+ * the group will be changed to start tracking (actually done in the
+ * function __check_for_group()).
+ *
  * Returns 0 on success.
  */
-int dazukofs_add_group(const char *name)
+int dazukofs_add_group(const char *name, int track)
 {
 	int ret = 0;
 	int already_exists;
@@ -481,7 +500,8 @@
 	}
 
 	mutex_lock(&work_mutex);
-	while (__check_for_group(name, available_id, &already_exists) != 0) {
+	while (__check_for_group(name, available_id, track,
+				 &already_exists) != 0) {
 		/* try again with the next id */
 		available_id++;
 	}
@@ -498,7 +518,7 @@
 		goto out2;
 	}
 
-	grp = create_group(name, available_id);
+	grp = create_group(name, available_id, track);
 	if (!grp) {
 		ret = -ENOMEM;
 		goto out2;
@@ -518,14 +538,17 @@
 /**
  * dazukofs_remove_group - remove a group
  * @name: the name of the group to remove
+ * @unsued: argument not used
  *
  * Description: This function is called by the device layer to remove a
  * group. It returns success if the group has been deleted or the group
  * does not exist.
  *
+ * The unused argument exists for convenience to the device layer.
+ *
  * Returns 0 on success.
  */
-int dazukofs_remove_group(const char *name)
+int dazukofs_remove_group(const char *name, int unused)
 {
 	int ret = 0;
 	struct dazukofs_group *grp;
@@ -832,6 +855,71 @@
 }
 
 /**
+ * dazukofs_group_open_tracking - begin tracking this process
+ * @group_id: id of the group we belong to
+ *
+ * Description: This function is called by the device layer to begin
+ * tracking the current process (if tracking for that group is enabled).
+ *
+ * Tracking simply means to keep track if there are any processes still
+ * registered with the group, so we use a simple counter for that.
+ * dazukofs_group_release_tracking() must be called when this process
+ * unregisters.
+ *
+ * Returns 0 if tracking is _not_ enabled.
+ */
+int dazukofs_group_open_tracking(unsigned long group_id)
+{
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+	int tracking = 0;
+
+	mutex_lock(&work_mutex);
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated && grp->group_id == group_id) {
+			if (grp->tracking) {
+				atomic_inc(&grp->use_count);
+				grp->track_count++;
+				tracking = 1;
+			}
+			break;
+		}
+	}
+	mutex_unlock(&work_mutex);
+	return tracking;
+}
+
+/**
+ * dazukofs_group_release_tracking - stop tracking this process
+ * @group_id: id of the group we belong to
+ *
+ * Description: This function is called by the device layer when a process
+ * is no longer registered and thus tracking for this process should end
+ * (if tracking for the group is enabled).
+ */
+void dazukofs_group_release_tracking(unsigned long group_id)
+{
+	struct dazukofs_group *grp;
+	struct list_head *pos;
+
+	mutex_lock(&work_mutex);
+	list_for_each(pos, &group_list.list) {
+		grp = list_entry(pos, struct dazukofs_group, list);
+		if (!grp->deprecated && grp->group_id == group_id) {
+			if (grp->tracking) {
+				atomic_dec(&grp->use_count);
+				grp->track_count--;
+				if (grp->track_count == 0)
+					__remove_group(grp);
+			}
+			break;
+		}
+	}
+	mutex_unlock(&work_mutex);
+}
+
+/**
  * dazukofs_return_event - return checked file access results
  * @group_id: id of the group the event came from
  * @event_id: the id of the event
Index: linux-2.6.27/fs/dazukofs/event.h
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/event.h	2008-12-21 15:10:24.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/event.h	2008-12-21 15:10:38.000000000 +0100
@@ -31,8 +31,11 @@
 
 extern int dazukofs_check_access(struct dentry *dentry, struct vfsmount *mnt);
 
+extern int dazukofs_group_open_tracking(unsigned long group_id);
+extern void dazukofs_group_release_tracking(unsigned long group_id);
+
 extern int dazukofs_get_groups(char **buf);
-extern int dazukofs_add_group(const char *name);
-extern int dazukofs_remove_group(const char *name);
+extern int dazukofs_add_group(const char *name, int track);
+extern int dazukofs_remove_group(const char *name, int unused);
 
 #endif /* __EVENT_H */
Index: linux-2.6.27/fs/dazukofs/group_dev.c
===================================================================
--- linux-2.6.27.orig/fs/dazukofs/group_dev.c	2008-12-21 15:10:24.000000000 +0100
+++ linux-2.6.27/fs/dazukofs/group_dev.c	2008-12-21 15:10:38.000000000 +0100
@@ -27,6 +27,24 @@
 #include "event.h"
 #include "dev.h"
 
+static int dazukofs_group_open(int group_id, struct inode *inode,
+			       struct file *file)
+{
+	if (dazukofs_group_open_tracking(group_id))
+		file->private_data = file;
+	else
+		file->private_data = NULL;
+	return 0;
+}
+
+static int dazukofs_group_release(int group_id, struct inode *inode,
+				  struct file *file)
+{
+	if (file->private_data)
+		dazukofs_group_release_tracking(group_id);
+	return 0;
+}
+
 static ssize_t dazukofs_group_read(int group_id, struct file *file,
 				   char __user *buffer, size_t length,
 				   loff_t *pos)
@@ -112,6 +130,16 @@
 }
 
 #define DECLARE_GROUP_FOPS(group_id) \
+static int \
+dazukofs_group_open_##group_id(struct inode *inode, struct file *file) \
+{ \
+	return dazukofs_group_open(group_id, inode, file); \
+} \
+static int \
+dazukofs_group_release_##group_id(struct inode *inode, struct file *file) \
+{ \
+	return dazukofs_group_release(group_id, inode, file); \
+} \
 static ssize_t \
 dazukofs_group_read_##group_id(struct file *file, char __user *buffer, \
 			       size_t length, loff_t *pos) \
@@ -127,6 +155,8 @@
 } \
 static struct file_operations group_fops_##group_id = { \
 	.owner		= THIS_MODULE, \
+	.open		= dazukofs_group_open_##group_id, \
+	.release	= dazukofs_group_release_##group_id, \
 	.read		= dazukofs_group_read_##group_id, \
 	.write		= dazukofs_group_write_##group_id, \
 };
Index: linux-2.6.27/Documentation/filesystems/dazukofs.txt
===================================================================
--- linux-2.6.27.orig/Documentation/filesystems/dazukofs.txt	2008-12-21 15:10:24.000000000 +0100
+++ linux-2.6.27/Documentation/filesystems/dazukofs.txt	2008-12-21 15:10:38.000000000 +0100
@@ -180,10 +180,26 @@
 
 By closing the device, the application will unregister itself.
 
-NOTE: It is not necessary for the device to be open while the application
-      decides if access should be allowed. In fact, it doesn't even have to
-      be the same process that responds. DazukoFS is only interested in a
-      response that matches the pending event id.
+To provide crash protection for applications, groups can be added using
+the "addtrack" keyword instead of "add". The keyword "addtrack" tells
+DazukoFS to add the group and track the number of registered processes in
+that group. Tracking begins as soon as the first process has registered
+with DazukoFS. Once all processes of the group have unregistered, DazukoFS
+will automatically delete the group.
+
+If an application crashes, is killed, or ends without closing the device,
+DazukoFS will still unregister that process. Using "addtrack" will ensure
+that a created group is automatically deleted if the application is not
+able to shutdown in a clean manner.
+
+NOTE: If "addtrack" is used, it is necessary for the device to be kept open
+      the entire time the application is performing online file access
+      control. Otherwise the group may become unintentionally deleted.
+
+      If "add" is used, it is not necessary for the device to be kept open
+      while the application decides if access should be allowed. Actually,
+      DazukoFS doesn't care which process responds to a file access event.
+      DazukoFS is only interested in a response for the given event id.
 
 A group can be deleted by writing to the /dev/dazukofs.ctrl device. For
 example, writing:
