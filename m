Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbXFVJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbXFVJNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXFVJNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:13:31 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXFVJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:13:31 -0400
Subject: [PATCH] sysfs_buffer: use mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 11:14:44 +0200
Message-Id: <1182503684.21939.76.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any reason why this is a semaphore, convert.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 fs/sysfs/file.c  |   13 +++++++------
 fs/sysfs/inode.c |    4 ++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

--- wireless-dev.orig/fs/sysfs/file.c	2007-06-13 23:33:29.878817885 +0200
+++ wireless-dev/fs/sysfs/file.c	2007-06-13 23:34:22.908817885 +0200
@@ -8,8 +8,8 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
@@ -136,7 +136,7 @@ sysfs_read_file(struct file *file, char 
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t retval = 0;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
 		if (buffer->orphaned)
 			retval = -ENODEV;
@@ -150,7 +150,7 @@ sysfs_read_file(struct file *file, char 
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return retval;
 }
 
@@ -230,7 +230,7 @@ sysfs_write_file(struct file *file, cons
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t len;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	if (buffer->orphaned) {
 		len = -ENODEV;
 		goto out;
@@ -241,7 +241,7 @@ sysfs_write_file(struct file *file, cons
 	if (len > 0)
 		*ppos += len;
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return len;
 }
 
@@ -317,7 +317,7 @@ static int sysfs_open_file(struct inode 
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (buffer) {
 		INIT_LIST_HEAD(&buffer->associates);
-		init_MUTEX(&buffer->sem);
+		mutex_init(&buffer->mutex);
 		buffer->needs_read_fill = 1;
 		buffer->ops = ops;
 		add_to_collection(buffer, inode);
@@ -354,6 +354,7 @@ static int sysfs_release(struct inode * 
 	if (buffer) {
 		if (buffer->page)
 			free_page((unsigned long)buffer->page);
+		mutex_destroy(&buffer->mutex);
 		kfree(buffer);
 	}
 	return 0;
--- wireless-dev.orig/fs/sysfs/sysfs.h	2007-06-13 23:34:32.868817885 +0200
+++ wireless-dev/fs/sysfs/sysfs.h	2007-06-13 23:34:58.338817885 +0200
@@ -51,7 +51,7 @@ struct sysfs_buffer {
 	loff_t				pos;
 	char				* page;
 	struct sysfs_ops		* ops;
-	struct semaphore		sem;
+	struct mutex			mutex;
 	int				orphaned;
 	int				needs_read_fill;
 	int				event;
--- wireless-dev.orig/fs/sysfs/inode.c	2007-06-13 23:35:14.248817885 +0200
+++ wireless-dev/fs/sysfs/inode.c	2007-06-13 23:35:25.788817885 +0200
@@ -230,9 +230,9 @@ static inline void orphan_all_buffers(st
 	set = node->i_private;
 	if (set) {
 		list_for_each_entry(buf, &set->associates, associates) {
-			down(&buf->sem);
+			mutex_lock(&buf->mutex);
 			buf->orphaned = 1;
-			up(&buf->sem);
+			mutex_unlock(&buf->mutex);
 		}
 	}
 	mutex_unlock(&node->i_mutex);


