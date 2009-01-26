Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZAZRb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZAZRb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZAZRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:31:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36381 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZAZRbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:31:45 -0500
Date: Mon, 26 Jan 2009 18:31:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, Paul.Clements@steeleye.com
Subject: nbd: add locking to nbd_ioctl
Message-ID: <20090126173132.GA2605@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The code was written to rely on big kernel lock to protect it from
races. It mostly works when interface is not abused.

So this uses tx_lock to protect data structures from concurrent use
between ioctl and worker threads.

Next step will be moving from ioctl to unlocked_ioctl. 

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 34f80fa..81c94a4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -559,74 +557,68 @@ static void do_nbd_request(struct reques
 	}
 }
 
-static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
-		     unsigned int cmd, unsigned long arg)
-{
-	struct nbd_device *lo = bdev->bd_disk->private_data;
-	struct file *file;
-	int error;
-	struct request sreq ;
-	struct task_struct *thread;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	BUG_ON(lo->magic != LO_MAGIC);
-
-	/* Anyone capable of this syscall can do *real bad* things */
-	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
-			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
+/* Must be called with tx_lock held */
 
+static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo, 
+		       unsigned int cmd, unsigned long arg)
+{
 	switch (cmd) {
 	case NBD_DISCONNECT:
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
-		blk_rq_init(NULL, &sreq);
-		sreq.cmd_type = REQ_TYPE_SPECIAL;
-		nbd_cmd(&sreq) = NBD_CMD_DISC;
-		/*
-		 * Set these to sane values in case server implementation
-		 * fails to check the request type first and also to keep
-		 * debugging output cleaner.
-		 */
-		sreq.sector = 0;
-		sreq.nr_sectors = 0;
-                if (!lo->sock)
-			return -EINVAL;
-		mutex_lock(&lo->tx_lock);
-                nbd_send_req(lo, &sreq);
-		mutex_unlock(&lo->tx_lock);
+		{
+			struct request sreq;
+
+			blk_rq_init(NULL, &sreq);
+			sreq.cmd_type = REQ_TYPE_SPECIAL;
+			nbd_cmd(&sreq) = NBD_CMD_DISC;
+			/*
+			 * Set these to sane values in case server implementation
+			 * fails to check the request type first and also to keep
+			 * debugging output cleaner.
+			 */
+			sreq.sector = 0;
+			sreq.nr_sectors = 0;
+			if (!lo->sock)
+				return -EINVAL;
+			nbd_send_req(lo, &sreq);
+		}
                 return 0;
  
 	case NBD_CLEAR_SOCK:
-		error = 0;
-		mutex_lock(&lo->tx_lock);
-		lo->sock = NULL;
-		mutex_unlock(&lo->tx_lock);
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		BUG_ON(!list_empty(&lo->queue_head));
-		if (file)
-			fput(file);
-		return error;
-	case NBD_SET_SOCK:
-		if (lo->file)
-			return -EBUSY;
-		error = -EINVAL;
-		file = fget(arg);
-		if (file) {
-			struct inode *inode = file->f_path.dentry->d_inode;
-			if (S_ISSOCK(inode->i_mode)) {
-				lo->file = file;
-				lo->sock = SOCKET_I(inode);
-				if (max_part > 0)
-					bdev->bd_invalidated = 1;
-				error = 0;
-			} else {
+		{
+			struct file *file;
+
+			lo->sock = NULL;
+			file = lo->file;
+			lo->file = NULL;
+			nbd_clear_que(lo);
+			BUG_ON(!list_empty(&lo->queue_head));
+			if (file)
 				fput(file);
+		}
+	return 0;
+
+	case NBD_SET_SOCK:
+		{
+			struct file *file;
+			if (lo->file)
+				return -EBUSY;
+			file = fget(arg);
+			if (file) {
+				struct inode *inode = file->f_path.dentry->d_inode;
+				if (S_ISSOCK(inode->i_mode)) {
+					lo->file = file;
+					lo->sock = SOCKET_I(inode);
+					if (max_part > 0)
+						bdev->bd_invalidated = 1;
+					return 0;
+				} else {
+					fput(file);
+				}
 			}
 		}
-		return error;
+		return -EINVAL;
+
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
 		lo->bytesize &= ~(lo->blksize-1);
@@ -634,47 +626,65 @@ static int nbd_ioctl(struct block_device
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_SET_SIZE:
 		lo->bytesize = arg & ~(lo->blksize-1);
 		bdev->bd_inode->i_size = lo->bytesize;
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_SET_TIMEOUT:
 		lo->xmit_timeout = arg * HZ;
 		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		bdev->bd_inode->i_size = lo->bytesize;
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_DO_IT:
-		if (lo->pid)
-			return -EBUSY;
-		if (!lo->file)
-			return -EINVAL;
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
-		if (IS_ERR(thread))
-			return PTR_ERR(thread);
-		wake_up_process(thread);
-		error = nbd_do_it(lo);
-		kthread_stop(thread);
-		if (error)
-			return error;
-		sock_shutdown(lo, 1);
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
-		if (file)
-			fput(file);
-		lo->bytesize = 0;
-		bdev->bd_inode->i_size = 0;
-		set_capacity(lo->disk, 0);
-		if (max_part > 0)
-			ioctl_by_bdev(bdev, BLKRRPART, 0);
-		return lo->harderror;
+		{
+			struct task_struct *thread;
+			struct file *file;
+			int error;
+
+			if (lo->pid)
+				return -EBUSY;
+			if (!lo->file)
+				return -EINVAL;
+
+			mutex_unlock(&lo->tx_lock);
+
+			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+			if (IS_ERR(thread)) {
+				mutex_lock(&lo->tx_lock);
+				return PTR_ERR(thread);
+			}
+			wake_up_process(thread);
+			error = nbd_do_it(lo);
+			kthread_stop(thread);
+
+			mutex_lock(&lo->tx_lock);
+			if (error)
+				return error;
+			sock_shutdown(lo, 0);
+			file = lo->file;
+			lo->file = NULL;
+			nbd_clear_que(lo);
+			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+			if (file)
+				fput(file);
+			lo->bytesize = 0;
+			bdev->bd_inode->i_size = 0;
+			set_capacity(lo->disk, 0);
+			if (max_part > 0)
+				ioctl_by_bdev(bdev, BLKRRPART, 0);
+			return lo->harderror;
+		}
+
 	case NBD_CLEAR_QUE:
 		/*
 		 * This is for compatibility only.  The queue is always cleared
@@ -682,6 +692,7 @@ static int nbd_ioctl(struct block_device
 		 */
 		BUG_ON(!lo->sock && !list_empty(&lo->queue_head));
 		return 0;
+
 	case NBD_PRINT_DEBUG:
 		printk(KERN_INFO "%s: next = %p, prev = %p, head = %p\n",
 			bdev->bd_disk->disk_name,
@@ -689,7 +700,29 @@ static int nbd_ioctl(struct block_device
 			&lo->queue_head);
 		return 0;
 	}
-	return -EINVAL;
+}
+
+
+static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
+		     unsigned int cmd, unsigned long arg)
+{
+	struct nbd_device *lo = bdev->bd_disk->private_data;
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	BUG_ON(lo->magic != LO_MAGIC);
+
+	/* Anyone capable of this syscall can do *real bad* things */
+	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
+			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
+
+	mutex_lock(&lo->tx_lock);
+	error = __nbd_ioctl(bdev, lo, cmd, arg);
+	mutex_unlock(&lo->tx_lock);
+
+	return error;
 }
 
 static struct block_device_operations nbd_fops =


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

