Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbXHXRl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbXHXRl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762397AbXHXRk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:40:57 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37030 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761683AbXHXRkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:40:55 -0400
Message-ID: <46CF1826.9050101@steeleye.com>
Date: Fri, 24 Aug 2007 13:40:54 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, david@dgreaves.com,
       Wouter Verhelst <w@uter.be>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/2] NBD: allow hung network I/O to be cancelled
References: <46CF101F.4050603@steeleye.com>
In-Reply-To: <46CF101F.4050603@steeleye.com>
Content-Type: multipart/mixed;
 boundary="------------030305040601060007030607"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030305040601060007030607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch allows NBD I/O to be cancelled when a network outage occurs. 
Previously, I/O would just hang, and if enough I/O was hung in nbd, the 
system (at least user-level) would completely hang until a TCP timeout 
(default, 15 minutes) occurred.

The patch introduces a new ioctl NBD_SET_TIMEOUT that allows a transmit 
timeout value (in seconds) to be specified. Any network send that 
exceeds the timeout will be cancelled and the nbd connection will be 
shut down. I've tested with various timeout values and 6 seconds seems 
to be a good choice for the timeout. If the NBD_SET_TIMEOUT ioctl is not 
called, you get the old (I/O hang) behavior.

Patch applies and was tested against 2.6.23-rc2-mm2.

Thanks,
Paul

--------------030305040601060007030607
Content-Type: text/x-patch;
 name="nbd_xmit_timeout_26.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_xmit_timeout_26.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./drivers/block/nbd.c.SIZE_ZERO	2007-08-16 13:08:06.000000000 -0400
+++ ./drivers/block/nbd.c	2007-08-23 16:42:09.000000000 -0400
@@ -113,12 +113,42 @@ static void nbd_end_request(struct reque
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+static void sock_shutdown(struct nbd_device *lo, int lock)
+{
+	/* Forcibly shutdown the socket causing all listeners
+	 * to error
+	 *
+	 * FIXME: This code is duplicated from sys_shutdown, but
+	 * there should be a more generic interface rather than
+	 * calling socket ops directly here */
+	if (lock)
+		mutex_lock(&lo->tx_lock);
+	if (lo->sock) {
+		printk(KERN_WARNING "%s: shutting down socket\n",
+			lo->disk->disk_name);
+		lo->sock->ops->shutdown(lo->sock, SEND_SHUTDOWN|RCV_SHUTDOWN);
+		lo->sock = NULL;
+	}
+	if (lock)
+		mutex_unlock(&lo->tx_lock);
+}
+
+static void nbd_xmit_timeout(unsigned long arg)
+{
+	struct task_struct *task = (struct task_struct *)arg;
+
+	printk(KERN_WARNING "nbd: killing hung xmit (%s, pid: %d)\n",
+		task->comm, task->pid);
+	force_sig(SIGKILL, task);
+}
+
 /*
  *  Send or receive packet.
  */
-static int sock_xmit(struct socket *sock, int send, void *buf, int size,
+static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 		int msg_flags)
 {
+	struct socket *sock = lo->sock;
 	int result;
 	struct msghdr msg;
 	struct kvec iov;
@@ -139,9 +169,20 @@ static int sock_xmit(struct socket *sock
 		msg.msg_controllen = 0;
 		msg.msg_flags = msg_flags | MSG_NOSIGNAL;
 
-		if (send)
+		if (send) {
+			struct timer_list ti;
+
+			if (lo->xmit_timeout) {
+				init_timer(&ti);
+				ti.function = nbd_xmit_timeout;
+				ti.data = (unsigned long)current;
+				ti.expires = jiffies + lo->xmit_timeout;
+				add_timer(&ti);
+			}
 			result = kernel_sendmsg(sock, &msg, &iov, 1, size);
-		else
+			if (lo->xmit_timeout)
+				del_timer_sync(&ti);
+		} else
 			result = kernel_recvmsg(sock, &msg, &iov, 1, size, 0);
 
 		if (signal_pending(current)) {
@@ -150,6 +191,7 @@ static int sock_xmit(struct socket *sock
 				current->pid, current->comm,
 				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
+			sock_shutdown(lo, !send);
 			break;
 		}
 
@@ -167,23 +209,22 @@ static int sock_xmit(struct socket *sock
 	return result;
 }
 
-static inline int sock_send_bvec(struct socket *sock, struct bio_vec *bvec,
+static inline int sock_send_bvec(struct nbd_device *lo, struct bio_vec *bvec,
 		int flags)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(sock, 1, kaddr + bvec->bv_offset, bvec->bv_len,
-			flags);
+	result = sock_xmit(lo, 1, kaddr + bvec->bv_offset, bvec->bv_len, flags);
 	kunmap(bvec->bv_page);
 	return result;
 }
 
+/* always call with the tx_lock held */
 static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
 	int result, i, flags;
 	struct nbd_request request;
 	unsigned long size = req->nr_sectors << 9;
-	struct socket *sock = lo->sock;
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
@@ -196,8 +237,8 @@ static int nbd_send_req(struct nbd_devic
 			nbdcmd_to_ascii(nbd_cmd(req)),
 			(unsigned long long)req->sector << 9,
 			req->nr_sectors << 9);
-	result = sock_xmit(sock, 1, &request, sizeof(request),
-			(nbd_cmd(req) == NBD_CMD_WRITE)? MSG_MORE: 0);
+	result = sock_xmit(lo, 1, &request, sizeof(request),
+			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
 		printk(KERN_ERR "%s: Send control failed (result %d)\n",
 				lo->disk->disk_name, result);
@@ -219,7 +260,7 @@ static int nbd_send_req(struct nbd_devic
 				dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
 						lo->disk->disk_name, req,
 						bvec->bv_len);
-				result = sock_send_bvec(sock, bvec, flags);
+				result = sock_send_bvec(lo, bvec, flags);
 				if (result <= 0) {
 					printk(KERN_ERR "%s: Send data failed (result %d)\n",
 							lo->disk->disk_name,
@@ -261,11 +302,11 @@ out:
 	return ERR_PTR(err);
 }
 
-static inline int sock_recv_bvec(struct socket *sock, struct bio_vec *bvec)
+static inline int sock_recv_bvec(struct nbd_device *lo, struct bio_vec *bvec)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(sock, 0, kaddr + bvec->bv_offset, bvec->bv_len,
+	result = sock_xmit(lo, 0, kaddr + bvec->bv_offset, bvec->bv_len,
 			MSG_WAITALL);
 	kunmap(bvec->bv_page);
 	return result;
@@ -277,10 +318,9 @@ static struct request *nbd_read_stat(str
 	int result;
 	struct nbd_reply reply;
 	struct request *req;
-	struct socket *sock = lo->sock;
 
 	reply.magic = 0;
-	result = sock_xmit(sock, 0, &reply, sizeof(reply), MSG_WAITALL);
+	result = sock_xmit(lo, 0, &reply, sizeof(reply), MSG_WAITALL);
 	if (result <= 0) {
 		printk(KERN_ERR "%s: Receive control failed (result %d)\n",
 				lo->disk->disk_name, result);
@@ -322,7 +362,7 @@ static struct request *nbd_read_stat(str
 		rq_for_each_bio(bio, req) {
 			struct bio_vec *bvec;
 			bio_for_each_segment(bvec, bio, i) {
-				result = sock_recv_bvec(sock, bvec);
+				result = sock_recv_bvec(lo, bvec);
 				if (result <= 0) {
 					printk(KERN_ERR "%s: Receive data failed (result %d)\n",
 							lo->disk->disk_name,
@@ -401,6 +441,7 @@ static void nbd_clear_que(struct nbd_dev
 	}
 }
 
+
 /*
  * We always wait for result of write, for now. It would be nice to make it optional
  * in future
@@ -511,7 +552,9 @@ static int nbd_ioctl(struct inode *inode
 		sreq.nr_sectors = 0;
                 if (!lo->sock)
 			return -EINVAL;
+		mutex_lock(&lo->tx_lock);
                 nbd_send_req(lo, &sreq);
+		mutex_unlock(&lo->tx_lock);
                 return 0;
  
 	case NBD_CLEAR_SOCK:
@@ -555,6 +598,9 @@ static int nbd_ioctl(struct inode *inode
 		set_blocksize(inode->i_bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+	case NBD_SET_TIMEOUT:
+		lo->xmit_timeout = arg * HZ;
+		return 0;
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		inode->i_bdev->bd_inode->i_size = lo->bytesize;
@@ -567,22 +613,7 @@ static int nbd_ioctl(struct inode *inode
 		error = nbd_do_it(lo);
 		if (error)
 			return error;
-		/* on return tidy up in case we have a signal */
-		/* Forcibly shutdown the socket causing all listeners
-		 * to error
-		 *
-		 * FIXME: This code is duplicated from sys_shutdown, but
-		 * there should be a more generic interface rather than
-		 * calling socket ops directly here */
-		mutex_lock(&lo->tx_lock);
-		if (lo->sock) {
-			printk(KERN_WARNING "%s: shutting down socket\n",
-				lo->disk->disk_name);
-			lo->sock->ops->shutdown(lo->sock,
-				SEND_SHUTDOWN|RCV_SHUTDOWN);
-			lo->sock = NULL;
-		}
-		mutex_unlock(&lo->tx_lock);
+		sock_shutdown(lo, 1);
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
--- ./include/linux/nbd.h.PRISTINE	2007-08-22 13:15:45.000000000 -0400
+++ ./include/linux/nbd.h	2007-08-22 13:17:02.000000000 -0400
@@ -26,6 +26,7 @@
 #define NBD_PRINT_DEBUG	_IO( 0xab, 6 )
 #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
 #define NBD_DISCONNECT  _IO( 0xab, 8 )
+#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
 
 enum {
 	NBD_CMD_READ = 0,
@@ -65,6 +66,7 @@ struct nbd_device {
 	int blksize;
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
+	int xmit_timeout;
 };
 
 #endif

--------------030305040601060007030607--
