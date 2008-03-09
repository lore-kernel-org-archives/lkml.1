Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYCIWr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYCIWr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 18:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYCIWrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 18:47:19 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:46497 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbYCIWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:47:18 -0400
Message-ID: <47D468F0.8000506@steeleye.com>
Date: Sun, 09 Mar 2008 18:47:12 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 1/1] NBD: allow nbd to be used locally
Content-Type: multipart/mixed;
 boundary="------------010108040009030105060703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010108040009030105060703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch allows a Network Block Device to be mounted locally 
(nbd-client to nbd-server over 127.0.0.1).

It creates a kthread to avoid the deadlock described in NBD tools 
documentation. So, if nbd-client hangs waiting for pages, the kblockd 
thread can continue its work and free pages.

I have tested the patch to verify that it avoids the hang that occurs 
when writing to a localhost nbd connection. I have also tested to verify 
that no performance degradation results from the additional thread and 
queue.

Patch originally from Laurent Vivier.

Thanks,
Paul

--------------010108040009030105060703
Content-Type: text/x-patch;
 name="nbd_local.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_local.diff"

This patch allows Network Block Device to be mounted locally (nbd-client to nbd-server over 127.0.0.1).

It creates a kthread to avoid the deadlock described in NBD tools documentation.
So, if nbd-client hangs waiting for pages, the kblockd thread can continue its
work and free pages.

I have tested the patch to verify that it avoids the hang that always occurs when writing to a localhost nbd connection. I have also tested to verify that no performance degradation results from the additional thread and queue.

Patch originally from Laurent Vivier.

Thanks,
Paul


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>

--- ./drivers/block/nbd.c.deadline	2008-02-09 08:55:27.000000000 -0500
+++ ./drivers/block/nbd.c	2008-02-09 09:08:11.000000000 -0500
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <net/sock.h>
 #include <linux/net.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -434,6 +435,85 @@ static void nbd_clear_que(struct nbd_dev
 }
 
 
+static void nbd_handle_req(struct nbd_device *lo, struct request *req)
+{
+	if (!blk_fs_request(req))
+		goto error_out;
+
+	nbd_cmd(req) = NBD_CMD_READ;
+	if (rq_data_dir(req) == WRITE) {
+		nbd_cmd(req) = NBD_CMD_WRITE;
+		if (lo->flags & NBD_READ_ONLY) {
+			printk(KERN_ERR "%s: Write on read-only\n",
+					lo->disk->disk_name);
+			goto error_out;
+		}
+	}
+
+	req->errors = 0;
+
+	mutex_lock(&lo->tx_lock);
+	if (unlikely(!lo->sock)) {
+		mutex_unlock(&lo->tx_lock);
+		printk(KERN_ERR "%s: Attempted send on closed socket\n",
+		       lo->disk->disk_name);
+		req->errors++;
+		nbd_end_request(req);
+		return;
+	}
+
+	lo->active_req = req;
+
+	if (nbd_send_req(lo, req) != 0) {
+		printk(KERN_ERR "%s: Request send failed\n",
+				lo->disk->disk_name);
+		req->errors++;
+		nbd_end_request(req);
+	} else {
+		spin_lock(&lo->queue_lock);
+		list_add(&req->queuelist, &lo->queue_head);
+		spin_unlock(&lo->queue_lock);
+	}
+
+	lo->active_req = NULL;
+	mutex_unlock(&lo->tx_lock);
+	wake_up_all(&lo->active_wq);
+
+	return;
+
+error_out:
+	req->errors++;
+	nbd_end_request(req);
+}
+
+static int nbd_thread(void *data)
+{
+	struct nbd_device *lo = data;
+	struct request *req;
+
+	set_user_nice(current, -20);
+	while (!kthread_should_stop() || !list_empty(&lo->waiting_queue)) {
+		/* wait for something to do */
+		wait_event_interruptible(lo->waiting_wq,
+					 kthread_should_stop() ||
+					 !list_empty(&lo->waiting_queue));
+
+		/* extract request */
+		if (list_empty(&lo->waiting_queue))
+			continue;
+
+		spin_lock_irq(&lo->queue_lock);
+		req = list_entry(lo->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		spin_unlock_irq(&lo->queue_lock);
+
+		/* handle request */
+		nbd_handle_req(lo, req);
+	}
+	return 0;
+}
+
 /*
  * We always wait for result of write, for now. It would be nice to make it optional
  * in future
@@ -449,65 +529,23 @@ static void do_nbd_request(struct reques
 		struct nbd_device *lo;
 
 		blkdev_dequeue_request(req);
+
+		spin_unlock_irq(q->queue_lock);
+
 		dprintk(DBG_BLKDEV, "%s: request %p: dequeued (flags=%x)\n",
 				req->rq_disk->disk_name, req, req->cmd_type);
 
-		if (!blk_fs_request(req))
-			goto error_out;
-
 		lo = req->rq_disk->private_data;
 
 		BUG_ON(lo->magic != LO_MAGIC);
 
-		nbd_cmd(req) = NBD_CMD_READ;
-		if (rq_data_dir(req) == WRITE) {
-			nbd_cmd(req) = NBD_CMD_WRITE;
-			if (lo->flags & NBD_READ_ONLY) {
-				printk(KERN_ERR "%s: Write on read-only\n",
-						lo->disk->disk_name);
-				goto error_out;
-			}
-		}
-
-		req->errors = 0;
-		spin_unlock_irq(q->queue_lock);
-
-		mutex_lock(&lo->tx_lock);
-		if (unlikely(!lo->sock)) {
-			mutex_unlock(&lo->tx_lock);
-			printk(KERN_ERR "%s: Attempted send on closed socket\n",
-			       lo->disk->disk_name);
-			req->errors++;
-			nbd_end_request(req);
-			spin_lock_irq(q->queue_lock);
-			continue;
-		}
+		spin_lock_irq(&lo->queue_lock);
+		list_add_tail(&req->queuelist, &lo->waiting_queue);
+		spin_unlock_irq(&lo->queue_lock);
 
-		lo->active_req = req;
-
-		if (nbd_send_req(lo, req) != 0) {
-			printk(KERN_ERR "%s: Request send failed\n",
-					lo->disk->disk_name);
-			req->errors++;
-			nbd_end_request(req);
-		} else {
-			spin_lock(&lo->queue_lock);
-			list_add(&req->queuelist, &lo->queue_head);
-			spin_unlock(&lo->queue_lock);
-		}
-
-		lo->active_req = NULL;
-		mutex_unlock(&lo->tx_lock);
-		wake_up_all(&lo->active_wq);
+		wake_up(&lo->waiting_wq);
 
 		spin_lock_irq(q->queue_lock);
-		continue;
-
-error_out:
-		req->errors++;
-		spin_unlock(q->queue_lock);
-		nbd_end_request(req);
-		spin_lock(q->queue_lock);
 	}
 }
 
@@ -517,6 +555,7 @@ static int nbd_ioctl(struct inode *inode
 	struct nbd_device *lo = inode->i_bdev->bd_disk->private_data;
 	int error;
 	struct request sreq ;
+	struct task_struct *thread;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -599,7 +638,12 @@ static int nbd_ioctl(struct inode *inode
 	case NBD_DO_IT:
 		if (!lo->file)
 			return -EINVAL;
+		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		if (IS_ERR(thread))
+			return PTR_ERR(thread);
+		wake_up_process(thread);
 		error = nbd_do_it(lo);
+		kthread_stop(thread);
 		if (error)
 			return error;
 		sock_shutdown(lo, 1);
@@ -688,10 +732,12 @@ static int __init nbd_init(void)
 		nbd_dev[i].file = NULL;
 		nbd_dev[i].magic = LO_MAGIC;
 		nbd_dev[i].flags = 0;
+		INIT_LIST_HEAD(&nbd_dev[i].waiting_queue);
 		spin_lock_init(&nbd_dev[i].queue_lock);
 		INIT_LIST_HEAD(&nbd_dev[i].queue_head);
 		mutex_init(&nbd_dev[i].tx_lock);
 		init_waitqueue_head(&nbd_dev[i].active_wq);
+		init_waitqueue_head(&nbd_dev[i].waiting_wq);
 		nbd_dev[i].blksize = 1024;
 		nbd_dev[i].bytesize = 0;
 		disk->major = NBD_MAJOR;
--- ./include/linux/nbd.h.max_nbd_killed	2008-02-07 16:46:13.000000000 -0500
+++ ./include/linux/nbd.h	2008-02-09 09:05:18.000000000 -0500
@@ -56,9 +56,11 @@ struct nbd_device {
 	int magic;
 
 	spinlock_t queue_lock;
-	struct list_head queue_head;/* Requests are added here...	*/
+	struct list_head queue_head;	/* Requests waiting result */
 	struct request *active_req;
 	wait_queue_head_t active_wq;
+	struct list_head waiting_queue;	/* Requests to be sent */
+	wait_queue_head_t waiting_wq;
 
 	struct mutex tx_lock;
 	struct gendisk *disk;

--------------010108040009030105060703--
