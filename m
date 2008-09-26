Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYIZVTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYIZVTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYIZVSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:18:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48393 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYIZVSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:18:54 -0400
Subject: [RFC 4/11] fanotify: display group registration info
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:18:50 -0400
Message-Id: <1222463930.2872.213.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: display group registration info

From: Eric Paris <eparis@redhat.com>

new file /security/fanotify/[name]/info will display registration
information so a process can know if the group gives what it wants, needs
to be cleanup up, should be reused, etc etc.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Makefile    |    2 +
 fs/notify/fanotify.h  |    4 ++
 fs/notify/group.c     |    7 ++++
 fs/notify/info_user.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 1 deletions(-)
 create mode 100644 fs/notify/info_user.c


diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 21ca1da..01915f7 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 
 obj-$(CONFIG_DNOTIFY)		+= dnotify.o
 
-obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o notification_user.o group.o group_user.o
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o notification.o notification_user.o group.o group_user.o info_user.o
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index d6bc0c0..78d8be0 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -24,6 +24,7 @@ struct fanotify_group {
 	char *name;			/* group name used for register/unregister matching */
 	struct dentry *subdir;		/* pointer to fanotify/name dentry */
 	struct dentry *notification;	/* pointer to fanotify/name/notification dentry */
+	struct dentry *info;		/* pointer to fanotify/name/info dentry */
 };
 
 /*
@@ -66,6 +67,9 @@ extern struct list_head groups;
 extern __init int fanotify_register_init(void);
 extern __init int fanotify_register_uninit(void);
 
+extern int fanotify_info_user_destroy(struct fanotify_group *group);
+extern int fanotify_info_user_create(struct fanotify_group *group);
+
 extern int fanotify_notification_user_destroy(struct fanotify_group *group);
 extern int fanotify_notification_user_create(struct fanotify_group *group);
 
diff --git a/fs/notify/group.c b/fs/notify/group.c
index a7a4d7f..926d0a4 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -45,6 +45,7 @@ void fanotify_get_group(struct fanotify_group *group)
 void fanotify_kill_group(struct fanotify_group *group)
 {
 	fanotify_notification_user_destroy(group);
+	fanotify_info_user_destroy(group);
 
 	securityfs_remove(group->subdir);
 	group->subdir = NULL;
@@ -107,12 +108,18 @@ int fanotify_register_group(char *name, unsigned int mask)
 	if (rc)
 		goto out_clean_subdir;
 
+	rc = fanotify_info_user_create(group);
+	if (rc)
+		goto out_clean_notification;
+
 	/* add it */
 	list_add_rcu(&group->group_list, &groups);
 	mutex_unlock(&groups_mutex);
 
 	return 0;
 
+out_clean_notification:
+	fanotify_notification_user_destroy(group);
 out_clean_subdir:
 	securityfs_remove(subdir);
 out_free_name:
diff --git a/fs/notify/info_user.c b/fs/notify/info_user.c
new file mode 100644
index 0000000..21a4465
--- /dev/null
+++ b/fs/notify/info_user.c
@@ -0,0 +1,85 @@
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
+#include <linux/gfp.h>
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
+static ssize_t fanotify_info_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
+{
+	struct fanotify_group *group = file->f_path.dentry->d_inode->i_private;
+	int len;
+	char *output;
+
+	BUG_ON(!group);
+
+	output = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
+
+	/* Build metadata string to send to the listener */
+	len = snprintf(output, PAGE_SIZE, "%s %x\n", group->name, group->mask);
+	if (len < 0)
+		goto out;
+	len = simple_read_from_buffer(buf, lenp, offset, output, len);
+out:
+	free_page((unsigned long)output);
+	return len;
+}
+
+static struct file_operations info_fops = {
+	.read =		fanotify_info_read,
+};
+
+int fanotify_info_user_destroy(struct fanotify_group *group)
+{
+	securityfs_remove(group->info);
+	group->info = NULL;
+
+	return 0;
+}
+
+int fanotify_info_user_create(struct fanotify_group *group)
+{
+	struct dentry *info_file;
+
+	group->info = NULL;
+
+	info_file = securityfs_create_file("info", S_IRUSR|S_IWUSR, group->subdir, group, &info_fops);
+	if (IS_ERR(info_file))
+		return PTR_ERR(info_file);
+
+	group->info = info_file;
+
+	return 0;
+}


