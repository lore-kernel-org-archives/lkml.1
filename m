Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXGZDCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXGZDCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbXGZDCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:02:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:25696 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbXGZDCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MxX6vRdX/zsLSe/kkruCu1TovydLw/1CgOU9GykQIYyr81kfL1ekb8MQgzLXuPB81j5Dhz7HK7cLrC1xAjPa2sgSLHaGpCdbiYKkMO1VOzyLS7y6iFcq22mSrFvF1NJghbMkWWqtFSwklfuTJVgrEgJ0ZrV8u/1FmiXphTWCl+A=
Date: Thu, 26 Jul 2007 11:03:54 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH][resend] sysfs/file.c - use mutex instead of semaphore
Message-ID: <20070726110354.GA3672@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in sysfs/file.c : sys_buffer.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
fs/sysfs/file.c |   14 +++++++-------
1 file changed, 7 insertions(+), 7 deletions(-)

diff -upr linux/fs/sysfs/file.c linux.new/fs/sysfs/file.c
--- linux/fs/sysfs/file.c	2007-07-26 10:55:11.000000000 +0000
+++ linux.new/fs/sysfs/file.c	2007-07-26 10:57:13.000000000 +0000
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
+	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
 };
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char 
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t retval = 0;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
@@ -139,7 +139,7 @@ sysfs_read_file(struct file *file, char 
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return retval;
 }
 
@@ -228,13 +228,13 @@ sysfs_write_file(struct file *file, cons
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t len;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return len;
 }
 
@@ -294,7 +294,7 @@ static int sysfs_open_file(struct inode 
 	if (!buffer)
 		goto err_out;
 
-	init_MUTEX(&buffer->sem);
+	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
