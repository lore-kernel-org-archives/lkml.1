Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXGRKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXGRKZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXGRKZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:25:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:41402 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbXGRKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=R+tv3Z458NZY12c039YiYeHy7qixLPLobx0+oi33Be84pKMht4bFZDLqO3hnAqZ6W3dgqhuJZ1sw6msGB6RFj5r5ebsRwJpFOSCJFSkxLNBOs/bomEvswMrcROGX5MRLsmGdI659HfTQza6eaRAIXNEYxzSeGV1h9Mrf8oYzLok=
Date: Wed, 18 Jul 2007 18:25:27 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs - use mutex instead of semaphore
Message-ID: <20070718182527.GA1827@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry,this is the right one. dir.c bin.c and symlink.c use the
mutex.h,should not be deleted.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---

fs/sysfs/bin.c     |    2 +-
fs/sysfs/dir.c     |    2 +-
fs/sysfs/file.c    |   14 +++++++-------
fs/sysfs/group.c   |    1 -
fs/sysfs/inode.c   |    1 -
fs/sysfs/mount.c   |    1 -
fs/sysfs/symlink.c |    2 +-
7 files changed, 10 insertions(+), 13 deletions(-)

diff -upr linux/fs/sysfs/bin.c linux.new/fs/sysfs/bin.c
--- linux/fs/sysfs/bin.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/bin.c	2007-07-18 18:18:06.000000000 +0000
@@ -14,9 +14,9 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -upr linux/fs/sysfs/dir.c linux.new/fs/sysfs/dir.c
--- linux/fs/sysfs/dir.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/dir.c	2007-07-18 18:18:26.000000000 +0000
@@ -10,8 +10,8 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
+#include <linux/mutex.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
diff -upr linux/fs/sysfs/file.c linux.new/fs/sysfs/file.c
--- linux/fs/sysfs/file.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/file.c	2007-07-18 17:40:37.000000000 +0000
@@ -8,8 +8,8 @@
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
@@ -55,7 +55,7 @@ struct sysfs_buffer {
 	loff_t			pos;
 	char			* page;
 	struct sysfs_ops	* ops;
-	struct semaphore	sem;
+	struct mutex		lock;
 	int			needs_read_fill;
 	int			event;
 };
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char 
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t retval = 0;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->lock);
 	if (buffer->needs_read_fill) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
@@ -139,7 +139,7 @@ sysfs_read_file(struct file *file, char 
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->lock);
 	return retval;
 }
 
@@ -228,13 +228,13 @@ sysfs_write_file(struct file *file, cons
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t len;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->lock);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-	up(&buffer->sem);
+	mutex_unlock(&buffer->lock);
 	return len;
 }
 
@@ -294,7 +294,7 @@ static int sysfs_open_file(struct inode 
 	if (!buffer)
 		goto err_out;
 
-	init_MUTEX(&buffer->sem);
+	mutex_init(&buffer->lock);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
diff -upr linux/fs/sysfs/group.c linux.new/fs/sysfs/group.c
--- linux/fs/sysfs/group.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/group.c	2007-07-18 17:40:37.000000000 +0000
@@ -14,7 +14,6 @@
 #include <linux/namei.h>
 #include <linux/err.h>
 #include <linux/fs.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 
diff -upr linux/fs/sysfs/inode.c linux.new/fs/sysfs/inode.c
--- linux/fs/sysfs/inode.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/inode.c	2007-07-18 17:40:37.000000000 +0000
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff -upr linux/fs/sysfs/mount.c linux.new/fs/sysfs/mount.c
--- linux/fs/sysfs/mount.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/mount.c	2007-07-18 17:40:37.000000000 +0000
@@ -8,7 +8,6 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -upr linux/fs/sysfs/symlink.c linux.new/fs/sysfs/symlink.c
--- linux/fs/sysfs/symlink.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/symlink.c	2007-07-18 18:18:38.000000000 +0000
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "sysfs.h"
 
