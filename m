Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZBCTVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZBCTVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZBCTVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:21:14 -0500
Received: from www.tglx.de ([62.245.132.106]:35996 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbZBCTVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:21:12 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 5/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
	<86ocxjfhv7.fsf_-_@johno.fn.ogness.net>
Date: Tue, 03 Feb 2009 20:20:35 +0100
In-Reply-To: <86ocxjfhv7.fsf_-_@johno.fn.ogness.net> (John Ogness's message of "Tue\, 03 Feb 2009 20\:19\:40 +0100")
Message-ID: <86k587fhto.fsf_-_@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 5: Creates /dev/dazukofs.ign as an (optional) mechanism for any
         processes to hide themselves from DazukoFS file access
         control.

Patched against 2.6.29-rc3.

Signed-off-by: John Ogness <dazukocode@ogness.net>
---
 Documentation/filesystems/dazukofs.txt |   24 ++
 fs/dazukofs/Makefile                   |    2 
 fs/dazukofs/dev.c                      |   22 +-
 fs/dazukofs/dev.h                      |    6 
 fs/dazukofs/event.c                    |    4 
 fs/dazukofs/ign_dev.c                  |  186 +++++++++++++++++++++++
 6 files changed, 237 insertions(+), 7 deletions(-)
Index: linux-2.6.28/fs/dazukofs/ign_dev.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.28/fs/dazukofs/ign_dev.c	2009-02-03 18:12:18.000000000 +0100
@@ -0,0 +1,186 @@
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
+#include "dev.h"
+
+struct dazukofs_proc {
+	struct list_head list;
+	struct task_struct *curr;
+};
+
+static struct dazukofs_proc ign_list;
+static struct mutex ign_list_mutex;
+static struct kmem_cache *dazukofs_ign_cachep;
+
+int dazukofs_check_ignore_process(void)
+{
+	struct list_head *pos;
+	struct dazukofs_proc *proc;
+	int found = 0;
+
+	mutex_lock(&ign_list_mutex);
+	list_for_each(pos, &ign_list.list) {
+		proc = list_entry(pos, struct dazukofs_proc, list);
+		if (proc->curr == current) {
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&ign_list_mutex);
+
+	return !found;
+}
+
+static int dazukofs_add_ign(struct file *file)
+{
+	struct dazukofs_proc *proc =
+		kmem_cache_zalloc(dazukofs_ign_cachep, GFP_KERNEL);
+	if (!proc) {
+		file->private_data = NULL;
+		return -ENOMEM;
+	}
+
+	file->private_data = proc;
+	proc->curr = current;
+
+	mutex_lock(&ign_list_mutex);
+	list_add(&proc->list, &ign_list.list);
+	mutex_unlock(&ign_list_mutex);
+
+	return 0;
+}
+
+static void dazukofs_remove_ign(struct file *file)
+{
+	struct list_head *pos;
+	struct dazukofs_proc *proc = NULL;
+	struct dazukofs_proc *check_proc = file->private_data;
+	int found = 0;
+
+	if (!check_proc)
+		return;
+
+	mutex_lock(&ign_list_mutex);
+	list_for_each(pos, &ign_list.list) {
+		proc = list_entry(pos, struct dazukofs_proc, list);
+		if (proc->curr == check_proc->curr) {
+			found = 1;
+			list_del(pos);
+			break;
+		}
+	}
+	mutex_unlock(&ign_list_mutex);
+
+	if (found) {
+		file->private_data = NULL;
+		kmem_cache_free(dazukofs_ign_cachep, proc);
+	}
+}
+
+static int dazukofs_ign_open(struct inode *inode, struct file *file)
+{
+	return dazukofs_add_ign(file);
+}
+
+static int dazukofs_ign_release(struct inode *inode, struct file *file)
+{
+	dazukofs_remove_ign(file);
+	return 0;
+}
+
+static void dazukofs_destroy_ignlist(void)
+{
+	struct list_head *pos;
+	struct list_head *q;
+	struct dazukofs_proc *proc;
+
+	list_for_each_safe(pos, q, &ign_list.list) {
+		proc = list_entry(pos, struct dazukofs_proc, list);
+		list_del(pos);
+		kmem_cache_free(dazukofs_ign_cachep, proc);
+	}
+}
+
+static struct cdev ign_cdev;
+
+static const struct file_operations ign_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dazukofs_ign_open,
+	.release	= dazukofs_ign_release,
+};
+
+int dazukofs_ign_dev_init(int dev_major, int dev_minor,
+			  struct class *dazukofs_class)
+{
+	int err = 0;
+	struct device *dev;
+
+	INIT_LIST_HEAD(&ign_list.list);
+	mutex_init(&ign_list_mutex);
+
+	dazukofs_ign_cachep =
+		kmem_cache_create("dazukofs_ign_cache",
+				  sizeof(struct dazukofs_proc), 0,
+				  SLAB_HWCACHE_ALIGN, NULL);
+	if (!dazukofs_ign_cachep) {
+		err = -ENOMEM;
+		goto error_out1;
+	}
+
+	/* setup cdev for ignore */
+	cdev_init(&ign_cdev, &ign_fops);
+	ign_cdev.owner = THIS_MODULE;
+	err = cdev_add(&ign_cdev, MKDEV(dev_major, dev_minor), 1);
+	if (err)
+		goto error_out2;
+
+	/* create ignore device */
+	dev = device_create(dazukofs_class, NULL, MKDEV(dev_major, dev_minor),
+			    NULL, "%s.ign", DEVICE_NAME);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto error_out3;
+	}
+
+	return 0;
+
+error_out3:
+	cdev_del(&ign_cdev);
+error_out2:
+	dazukofs_destroy_ignlist();
+	kmem_cache_destroy(dazukofs_ign_cachep);
+error_out1:
+	return err;
+}
+
+void dazukofs_ign_dev_destroy(int dev_major, int dev_minor,
+			      struct class *dazukofs_class)
+{
+	device_destroy(dazukofs_class, MKDEV(dev_major, dev_minor));
+	cdev_del(&ign_cdev);
+	dazukofs_destroy_ignlist();
+	kmem_cache_destroy(dazukofs_ign_cachep);
+}
Index: linux-2.6.28/fs/dazukofs/Makefile
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/Makefile	2009-02-03 18:11:01.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/Makefile	2009-02-03 18:12:18.000000000 +0100
@@ -5,4 +5,4 @@
 obj-$(CONFIG_DAZUKOFS_FS) += dazukofs.o
 
 dazukofs-objs := super.o inode.o file.o dentry.o mmap.o event.o \
-		 dev.o group_dev.o ctrl_dev.o
+		 dev.o group_dev.o ctrl_dev.o ign_dev.o
Index: linux-2.6.28/fs/dazukofs/event.c
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/event.c	2009-02-03 18:12:14.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/event.c	2009-02-03 18:12:18.000000000 +0100
@@ -619,6 +619,10 @@
 	if (!check_recursion())
 		return -1;
 
+	/* am I an ignored process? */
+	if (!dazukofs_check_ignore_process())
+		return -1;
+
 	return 0;
 }
 
Index: linux-2.6.28/fs/dazukofs/dev.c
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/dev.c	2009-02-03 18:11:01.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/dev.c	2009-02-03 18:12:18.000000000 +0100
@@ -42,7 +42,7 @@
 	if (err)
 		goto error_out1;
 
-	err = alloc_chrdev_region(&devt, 0, 1 + GROUP_COUNT, DEVICE_NAME);
+	err = alloc_chrdev_region(&devt, 0, 2 + GROUP_COUNT, DEVICE_NAME);
 	if (err)
 		goto error_out2;
 	dev_major = MAJOR(devt);
@@ -59,23 +59,31 @@
 	if (err)
 		goto error_out4;
 
+	err = dazukofs_ign_dev_init(dev_major, dev_minor_start + 1,
+				    dazukofs_class);
+	if (err)
+		goto error_out5;
+
 	dev_minor_end = dazukofs_group_dev_init(dev_major,
-						dev_minor_start + 1,
+						dev_minor_start + 2,
 						dazukofs_class);
 	if (dev_minor_end < 0) {
 		err = dev_minor_end;
-		goto error_out5;
+		goto error_out6;
 	}
 
 	return 0;
 
+error_out6:
+	dazukofs_ign_dev_destroy(dev_major, dev_minor_start + 1,
+				 dazukofs_class);
 error_out5:
 	dazukofs_ctrl_dev_destroy(dev_major, dev_minor_start, dazukofs_class);
 error_out4:
 	class_destroy(dazukofs_class);
 error_out3:
 	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start),
-				 1 + GROUP_COUNT);
+				 2 + GROUP_COUNT);
 error_out2:
 	dazukofs_destroy_events();
 error_out1:
@@ -84,11 +92,13 @@
 
 void dazukofs_dev_destroy(void)
 {
-	dazukofs_group_dev_destroy(dev_major, dev_minor_start + 1,
+	dazukofs_group_dev_destroy(dev_major, dev_minor_start + 2,
 				   dev_minor_end, dazukofs_class);
+	dazukofs_ign_dev_destroy(dev_major, dev_minor_start + 1,
+				 dazukofs_class);
 	dazukofs_ctrl_dev_destroy(dev_major, dev_minor_start, dazukofs_class);
 	class_destroy(dazukofs_class);
 	unregister_chrdev_region(MKDEV(dev_major, dev_minor_start),
-				 1 + GROUP_COUNT);
+				 2 + GROUP_COUNT);
 	dazukofs_destroy_events();
 }
Index: linux-2.6.28/fs/dazukofs/dev.h
===================================================================
--- linux-2.6.28.orig/fs/dazukofs/dev.h	2009-02-03 18:11:01.000000000 +0100
+++ linux-2.6.28/fs/dazukofs/dev.h	2009-02-03 18:12:18.000000000 +0100
@@ -40,4 +40,10 @@
 extern void dazukofs_ctrl_dev_destroy(int dev_major, int dev_minor,
 				      struct class *dazukofs_class);
 
+extern int dazukofs_ign_dev_init(int dev_major, int dev_minor,
+				 struct class *dazukofs_class);
+extern void dazukofs_ign_dev_destroy(int dev_major, int dev_minor,
+				     struct class *dazukofs_class);
+extern int dazukofs_check_ignore_process(void);
+
 #endif /* __DEV_H */
Index: linux-2.6.28/Documentation/filesystems/dazukofs.txt
===================================================================
--- linux-2.6.28.orig/Documentation/filesystems/dazukofs.txt	2009-02-03 18:12:14.000000000 +0100
+++ linux-2.6.28/Documentation/filesystems/dazukofs.txt	2009-02-03 18:12:18.000000000 +0100
@@ -223,3 +223,27 @@
 access events to be handled by each group. For this reason it is important
 that an application deletes a group it has created, once it should no longer
 perform online file access control.
+
+All processes on the system that try to access files on a DazukoFS mount will
+require authorization (if at least one group exists). This is also true for
+registered process that try to access files on a DazukoFS mount.
+
+IMPORTANT: If registered processes access files on a DazukoFS mount, they
+           will cause new file access events that must be authorized. This
+           could lead to deadlock if not properly considered.
+
+Since the registered process receives an open file descriptor to the file
+being accessed, there should be no need for that process to open other
+files. However, if the process must open additional files (and these
+files potentially lie on a DazukoFS mount), it is possible for processes
+to hide themselves from DazukoFS.
+
+By opening the /dev/dazukofs.ign device, a process will be ignored by
+DazukoFS. It does not matter if the process is registered or not. No data
+must be written or read from the device. It simply needs to be opened.
+
+WARNING: Make sure the permissions for /dev/dazukofs.ign are securely
+         set. Otherwise, any process could potentially hide itself.
+
+As soon as the /dev/dazukofs.ign device is closed, the process is no
+longer hidden.
