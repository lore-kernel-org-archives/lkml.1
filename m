Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXJLW2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXJLW2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXJLWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:53170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXJLWS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/75] sysfs/file.c - use mutex instead of semaphore
Date: Fri, 12 Oct 2007 15:16:22 -0700
Message-Id: <11922275221643-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275181138-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Use mutex instead of semaphore in sysfs/file.c : sys_buffer.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3e1cc06..b21d11b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
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
@@ -128,7 +128,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct sysfs_buffer * buffer = file->private_data;
 	ssize_t retval = 0;
 
-	down(&buffer->sem);
+	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
@@ -139,7 +139,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
 					 buffer->count);
 out:
-	up(&buffer->sem);
+	mutex_unlock(&buffer->mutex);
 	return retval;
 }
 
@@ -228,13 +228,13 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
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
 
@@ -294,7 +294,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!buffer)
 		goto err_out;
 
-	init_MUTEX(&buffer->sem);
+	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
 	file->private_data = buffer;
-- 
1.5.3.4

