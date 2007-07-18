Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbXGRKKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbXGRKKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbXGRKJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:09:51 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:56217 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbXGRKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=IrUFIEOcTCIj+0Sgi1e1W4yXoC4zKCUs6w4nAa+7woe5S3barjkSUtYRuqTdTrg4zMIomuGVNtPYV7dv4xvtJE2YYWUHva4x278j/duviLTVGcrf1eQd9ice/nU8djUcv+f5ChdifNzqzI1UGmCGGIWAEjmJfkR790jYByWPHS4=
Date: Wed, 18 Jul 2007 18:09:50 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs - use mutex instead of semaphore
Message-ID: <20070718180950.GA1701@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Use mutex instead of semaphore in sysfs/file.c, and the unnecessary
semaphore.h in other files are remove as well.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---

fs/sysfs/bin.c     |    1 -
fs/sysfs/dir.c     |    1 -
fs/sysfs/file.c    |   14 +++++++-------
fs/sysfs/group.c   |    1 -
fs/sysfs/inode.c   |    1 -
fs/sysfs/mount.c   |    1 -
fs/sysfs/symlink.c |    1 -
7 files changed, 7 insertions(+), 13 deletions(-)

diff -upr linux/fs/sysfs/bin.c linux.new/fs/sysfs/bin.c
--- linux/fs/sysfs/bin.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/bin.c	2007-07-18 17:40:37.000000000 +0000
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -upr linux/fs/sysfs/dir.c linux.new/fs/sysfs/dir.c
--- linux/fs/sysfs/dir.c	2007-07-18 17:40:46.000000000 +0000
+++ linux.new/fs/sysfs/dir.c	2007-07-18 17:40:37.000000000 +0000
@@ -11,7 +11,6 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
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
+++ linux.new/fs/sysfs/symlink.c	2007-07-18 17:40:37.000000000 +0000
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
