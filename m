Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZA2BTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZA2BTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZA2BTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:19:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbZA2BTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:19:32 -0500
Date: Wed, 28 Jan 2009 17:18:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Paul.Clements@steeleye.com
Subject: Re: nbd: add locking to nbd_ioctl
Message-Id: <20090128171855.6d5c59c8.akpm@linux-foundation.org>
In-Reply-To: <20090126173132.GA2605@elf.ucw.cz>
References: <20090126173132.GA2605@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 18:31:33 +0100
Pavel Machek <pavel@suse.cz> wrote:

> The code was written to rely on big kernel lock to protect it from
> races. It mostly works when interface is not abused.
> 
> So this uses tx_lock to protect data structures from concurrent use
> between ioctl and worker threads.
> 
> Next step will be moving from ioctl to unlocked_ioctl. 

I dinked with this rather a lot.  Moved all those case statements in a
tabstop (makes it all fit into 80 cols without adding weird
linebreaks), moved a few `return' statements to more logical places,
etc.

Please apply and double-check?

--- a/drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl-checkpatch-fixes
+++ a/drivers/block/nbd.c
@@ -565,61 +565,59 @@ static int __nbd_ioctl(struct block_devi
 		       unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
-	case NBD_DISCONNECT:
+	case NBD_DISCONNECT: {
+		struct request sreq;
+
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
-		{
-			struct request sreq;
 
-			blk_rq_init(NULL, &sreq);
-			sreq.cmd_type = REQ_TYPE_SPECIAL;
-			nbd_cmd(&sreq) = NBD_CMD_DISC;
-			/*
-			 * Set these to sane values in case server implementation
-			 * fails to check the request type first and also to keep
-			 * debugging output cleaner.
-			 */
-			sreq.sector = 0;
-			sreq.nr_sectors = 0;
-			if (!lo->sock)
-				return -EINVAL;
-			nbd_send_req(lo, &sreq);
-		}
+		blk_rq_init(NULL, &sreq);
+		sreq.cmd_type = REQ_TYPE_SPECIAL;
+		nbd_cmd(&sreq) = NBD_CMD_DISC;
+		/*
+		 * Set these to sane values in case server implementation
+		 * fails to check the request type first and also to keep
+		 * debugging output cleaner.
+		 */
+		sreq.sector = 0;
+		sreq.nr_sectors = 0;
+		if (!lo->sock)
+			return -EINVAL;
+		nbd_send_req(lo, &sreq);
                 return 0;
+	}
  
-	case NBD_CLEAR_SOCK:
-		{
-			struct file *file;
-
-			lo->sock = NULL;
-			file = lo->file;
-			lo->file = NULL;
-			nbd_clear_que(lo);
-			BUG_ON(!list_empty(&lo->queue_head));
-			if (file)
-				fput(file);
-		}
-	return 0;
+	case NBD_CLEAR_SOCK: {
+		struct file *file;
 
-	case NBD_SET_SOCK:
-		{
-			struct file *file;
-			if (lo->file)
-				return -EBUSY;
-			file = fget(arg);
-			if (file) {
-				struct inode *inode = file->f_path.dentry->d_inode;
-				if (S_ISSOCK(inode->i_mode)) {
-					lo->file = file;
-					lo->sock = SOCKET_I(inode);
-					if (max_part > 0)
-						bdev->bd_invalidated = 1;
-					return 0;
-				} else {
-					fput(file);
-				}
+		lo->sock = NULL;
+		file = lo->file;
+		lo->file = NULL;
+		nbd_clear_que(lo);
+		BUG_ON(!list_empty(&lo->queue_head));
+		if (file)
+			fput(file);
+		return 0;
+	}
+
+	case NBD_SET_SOCK: {
+		struct file *file;
+		if (lo->file)
+			return -EBUSY;
+		file = fget(arg);
+		if (file) {
+			struct inode *inode = file->f_path.dentry->d_inode;
+			if (S_ISSOCK(inode->i_mode)) {
+				lo->file = file;
+				lo->sock = SOCKET_I(inode);
+				if (max_part > 0)
+					bdev->bd_invalidated = 1;
+				return 0;
+			} else {
+				fput(file);
 			}
 		}
 		return -EINVAL;
+	}
 
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
@@ -647,45 +645,44 @@ static int __nbd_ioctl(struct block_devi
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
 
-	case NBD_DO_IT:
-		{
-			struct task_struct *thread;
-			struct file *file;
-			int error;
-
-			if (lo->pid)
-				return -EBUSY;
-			if (!lo->file)
-				return -EINVAL;
-
-			mutex_unlock(&lo->tx_lock);
-
-			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
-			if (IS_ERR(thread)) {
-				mutex_lock(&lo->tx_lock);
-				return PTR_ERR(thread);
-			}
-			wake_up_process(thread);
-			error = nbd_do_it(lo);
-			kthread_stop(thread);
+	case NBD_DO_IT: {
+		struct task_struct *thread;
+		struct file *file;
+		int error;
+
+		if (lo->pid)
+			return -EBUSY;
+		if (!lo->file)
+			return -EINVAL;
+
+		mutex_unlock(&lo->tx_lock);
 
+		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		if (IS_ERR(thread)) {
 			mutex_lock(&lo->tx_lock);
-			if (error)
-				return error;
-			sock_shutdown(lo, 0);
-			file = lo->file;
-			lo->file = NULL;
-			nbd_clear_que(lo);
-			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
-			if (file)
-				fput(file);
-			lo->bytesize = 0;
-			bdev->bd_inode->i_size = 0;
-			set_capacity(lo->disk, 0);
-			if (max_part > 0)
-				ioctl_by_bdev(bdev, BLKRRPART, 0);
-			return lo->harderror;
+			return PTR_ERR(thread);
 		}
+		wake_up_process(thread);
+		error = nbd_do_it(lo);
+		kthread_stop(thread);
+
+		mutex_lock(&lo->tx_lock);
+		if (error)
+			return error;
+		sock_shutdown(lo, 0);
+		file = lo->file;
+		lo->file = NULL;
+		nbd_clear_que(lo);
+		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+		if (file)
+			fput(file);
+		lo->bytesize = 0;
+		bdev->bd_inode->i_size = 0;
+		set_capacity(lo->disk, 0);
+		if (max_part > 0)
+			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		return lo->harderror;
+	}
 
 	case NBD_CLEAR_QUE:
 		/*
_

