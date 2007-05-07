Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXEGCcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXEGCcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXEGCcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:32:32 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:40846 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXEGCcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:32:31 -0400
X-Greylist: delayed 1062 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 May 2007 22:32:30 EDT
Date: Mon, 7 May 2007 04:14:47 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: dan@dennedy.org
Cc: stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
Message-ID: <20070507021447.GA22197@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

This patch makes raw1394 in current Linux git tree (2.6.21-1570) usable to 32bit
applications running on 64bit kernel (tested on i386 app using x86_64 kernel).  I 
had to make following changes:

* read() always failed with -EFAULT.  This was happening due to
  raw1394_compat_read copying data to wrong location - access_ok always
  failed as 'r' is kernel address, not user.  Whole function just tried to
  copy data from 'r' to 'r', which is not good.

* write(fd, buf, 52) from 32bit app was returning 56.  Most of callers did not
  care, but some (arm registration) did, and anyway it looks bad if request for
  writing 52 bytes returns 56.  And returning sizeof anything in 'int' is not
  good as well.  So all functions now return '0' instead of
  sizeof(struct raw1394_request) on success, and write() itself provides correct
  return value (it just returns value it was asked to write on success as raw1394
  does not do any partial writes at all).

* Related to this was problem that write() could have returned 0 when kernel
  state would become corrupted and moved to different state than
  opened/initialized/connected.  Now it returns -EBADFD which seemed appropriate.

* And add compat_ioctl.  Although all structures are more or less same,
  raw1394_iso_packets got pointer inside, and raw1394_cycle_timer got unwanted
  padding in the middle.  I did not add any translation for ioctls passing array
  of integers around as integers seem to have same size (32 bits) on all 
  architectures supported by Linux.

With this in place I was able to run my test app and grab some mpegs, so I believe
that I got everything necessary done.  If you believe I have missed some ioctl, yell
at me.
						Thanks,
							Petr Vandrovec

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff -uprdN linux/drivers/ieee1394/raw1394.c linux/drivers/ieee1394/raw1394.c
--- linux/drivers/ieee1394/raw1394.c	2007-05-06 17:45:47.000000000 -0700
+++ linux/drivers/ieee1394/raw1394.c	2007-05-06 18:08:05.000000000 -0700
@@ -460,7 +460,7 @@ static const char __user *raw1394_compat
 static int
 raw1394_compat_read(const char __user *buf, struct raw1394_request *r)
 {
-	struct compat_raw1394_req __user *cr = (typeof(cr)) r;
+	struct compat_raw1394_req __user *cr = (typeof(cr)) buf;
 	if (!access_ok(VERIFY_WRITE, cr, sizeof(struct compat_raw1394_req)) ||
 	    P(type) ||
 	    P(error) ||
@@ -588,7 +588,7 @@ static int state_opened(struct file_info
 
 	req->req.length = 0;
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int state_initialized(struct file_info *fi, struct pending_request *req)
@@ -602,7 +602,7 @@ static int state_initialized(struct file
 		req->req.generation = atomic_read(&internal_generation);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -674,7 +674,7 @@ out_set_card:
 	}
 
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static void handle_iso_listen(struct file_info *fi, struct pending_request *req)
@@ -866,7 +866,7 @@ static int handle_async_request(struct f
 	if (req->req.error) {
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	hpsb_set_packet_complete_task(packet,
@@ -884,7 +884,7 @@ static int handle_async_request(struct f
 		hpsb_free_tlabel(packet);
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_iso_send(struct file_info *fi, struct pending_request *req,
@@ -908,7 +908,7 @@ static int handle_iso_send(struct file_i
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	req->req.length = 0;
@@ -928,7 +928,7 @@ static int handle_iso_send(struct file_i
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_async_send(struct file_info *fi, struct pending_request *req)
@@ -943,7 +943,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	packet = hpsb_alloc_packet(req->req.length - header_length);
@@ -956,7 +956,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	if (copy_from_user
@@ -965,7 +965,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	packet->type = hpsb_async;
@@ -993,7 +993,7 @@ static int handle_async_send(struct file
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
@@ -1868,7 +1868,7 @@ static int arm_register(struct file_info
 		spin_lock_irqsave(&host_info_lock, flags);
 		list_add_tail(&addr->addr_list, &fi->addr_list);
 		spin_unlock_irqrestore(&host_info_lock, flags);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_register_addrspace(&raw1394_highlevel, fi->host, &arm_ops,
@@ -1886,7 +1886,7 @@ static int arm_register(struct file_info
 		return (-EALREADY);
 	}
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_unregister(struct file_info *fi, struct pending_request *req)
@@ -1954,7 +1954,7 @@ static int arm_unregister(struct file_in
 		vfree(addr->addr_space_buffer);
 		kfree(addr);
 		free_pending_request(req);	/* immediate success or fail */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_unregister_addrspace(&raw1394_highlevel, fi->host,
@@ -1970,7 +1970,7 @@ static int arm_unregister(struct file_in
 	vfree(addr->addr_space_buffer);
 	kfree(addr);
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 /* Copy data from ARM buffer(s) to user buffer. */
@@ -2012,7 +2012,7 @@ static int arm_get_buf(struct file_info 
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_get_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2064,7 +2064,7 @@ static int arm_set_buf(struct file_info 
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_set_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2085,7 +2085,7 @@ static int reset_notification(struct fil
 	    (req->req.misc == RAW1394_NOTIFY_ON)) {
 		fi->notification = (u8) req->req.misc;
 		free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	/* error EINVAL (22) invalid argument */
 	return (-EINVAL);
@@ -2118,12 +2118,12 @@ static int write_phypacket(struct file_i
 		req->req.length = 0;
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int get_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	int status;
 
@@ -2153,7 +2153,7 @@ static int get_config_rom(struct file_in
 
 static int update_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -2220,7 +2220,7 @@ static int modify_config_rom(struct file
 
 			hpsb_update_config_rom_image(fi->host);
 			free_pending_request(req);
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 	}
 
@@ -2285,7 +2285,7 @@ static int modify_config_rom(struct file
 		/* we have to free the request, because we queue no response,
 		 * and therefore nobody will free it */
 		free_pending_request(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	} else {
 		for (dentry =
 		     fi->csr1212_dirs[dr]->value.directory.dentries_head;
@@ -2310,7 +2310,7 @@ static int state_connected(struct file_i
 
 	case RAW1394_REQ_ECHO:
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_ISO_SEND:
 		print_old_iso_deprecation();
@@ -2334,24 +2334,24 @@ static int state_connected(struct file_i
 	case RAW1394_REQ_ISO_LISTEN:
 		print_old_iso_deprecation();
 		handle_iso_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_FCP_LISTEN:
 		handle_fcp_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_RESET_BUS:
 		if (req->req.misc == RAW1394_LONG_RESET) {
 			DBGMSG("busreset called (type: LONG)");
 			hpsb_reset_bus(fi->host, LONG_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		if (req->req.misc == RAW1394_SHORT_RESET) {
 			DBGMSG("busreset called (type: SHORT)");
 			hpsb_reset_bus(fi->host, SHORT_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		/* error EINVAL (22) invalid argument */
 		return (-EINVAL);
@@ -2370,7 +2370,7 @@ static int state_connected(struct file_i
 		req->req.generation = get_hpsb_generation(fi->host);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -2383,7 +2383,7 @@ static int state_connected(struct file_i
 	if (req->req.length == 0) {
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	return handle_async_request(fi, req, node);
@@ -2394,7 +2394,7 @@ static ssize_t raw1394_write(struct file
 {
 	struct file_info *fi = (struct file_info *)file->private_data;
 	struct pending_request *req;
-	ssize_t retval = 0;
+	ssize_t retval = -EBADFD;
 
 #ifdef CONFIG_COMPAT
 	if (count == sizeof(struct compat_raw1394_req) &&
@@ -2436,6 +2436,9 @@ static ssize_t raw1394_write(struct file
 
 	if (retval < 0) {
 		free_pending_request(req);
+	} else {
+		BUG_ON(retval);
+		retval = count;
 	}
 
 	return retval;
@@ -2801,6 +2804,99 @@ static int raw1394_ioctl(struct inode *i
 	return -EINVAL;
 }
 
+#ifdef CONFIG_COMPAT
+struct raw1394_iso_packets32 {
+        __u32 n_packets;
+        compat_uptr_t infos;
+} __attribute__((packed));
+
+struct raw1394_cycle_timer32 {
+        __u32 cycle_timer;
+        __u64 local_time;
+} __attribute__((packed));
+
+#define RAW1394_IOC_ISO_RECV_PACKETS32          \
+        _IOW ('#', 0x25, struct raw1394_iso_packets32)
+#define RAW1394_IOC_ISO_XMIT_PACKETS32          \
+        _IOW ('#', 0x27, struct raw1394_iso_packets32)
+#define RAW1394_IOC_GET_CYCLE_TIMER32           \
+        _IOR ('#', 0x30, struct raw1394_cycle_timer32)
+	
+static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
+                                          struct raw1394_iso_packets32 __user *arg)
+{
+	compat_uptr_t infos32;
+	void *infos;
+	long err = -EFAULT;
+	struct raw1394_iso_packets __user *dst = compat_alloc_user_space(sizeof(struct raw1394_iso_packets));
+			
+	if (!copy_in_user(&dst->n_packets, &arg->n_packets, sizeof arg->n_packets) &&
+	    !copy_from_user(&infos32, &arg->infos, sizeof infos32)) {
+		infos = compat_ptr(infos32);
+		if (!copy_to_user(&dst->infos, &infos, sizeof infos))
+			err = raw1394_ioctl(NULL, file, cmd, (unsigned long)dst);
+	}
+	return err;
+}
+
+static long raw1394_read_cycle_timer32(struct file_info *fi, void __user * uaddr)
+{
+	struct raw1394_cycle_timer32 ct;
+	int err;
+
+	err = hpsb_read_cycle_timer(fi->host, &ct.cycle_timer, &ct.local_time);
+	if (!err)
+		if (copy_to_user(uaddr, &ct, sizeof(ct)))
+			err = -EFAULT;
+	return err;
+}
+
+static long raw1394_compat_ioctl(struct file *file,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct file_info *fi = file->private_data;
+	void __user *argp = (void __user *)arg;
+	long err;
+
+	lock_kernel();
+	switch (cmd) {
+	/* These requests have same format as long as 'int' has same size. */
+	case RAW1394_IOC_ISO_RECV_INIT:
+	case RAW1394_IOC_ISO_RECV_START:
+	case RAW1394_IOC_ISO_RECV_LISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_UNLISTEN_CHANNEL:
+	case RAW1394_IOC_ISO_RECV_SET_CHANNEL_MASK:
+	case RAW1394_IOC_ISO_RECV_RELEASE_PACKETS:
+	case RAW1394_IOC_ISO_RECV_FLUSH:
+	case RAW1394_IOC_ISO_XMIT_RECV_STOP:
+	case RAW1394_IOC_ISO_XMIT_INIT:
+	case RAW1394_IOC_ISO_XMIT_START:
+	case RAW1394_IOC_ISO_XMIT_SYNC:
+	case RAW1394_IOC_ISO_GET_STATUS:
+	case RAW1394_IOC_ISO_SHUTDOWN:
+	case RAW1394_IOC_ISO_QUEUE_ACTIVITY:
+		err = raw1394_ioctl(NULL, file, cmd, arg);
+		break;
+	/* These request have different format. */
+	case RAW1394_IOC_ISO_RECV_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_RECV_PACKETS, argp);
+		break;
+	case RAW1394_IOC_ISO_XMIT_PACKETS32:
+		err = raw1394_iso_xmit_recv_packets32(file, RAW1394_IOC_ISO_XMIT_PACKETS, argp);
+		break;
+	case RAW1394_IOC_GET_CYCLE_TIMER32:
+		err = raw1394_read_cycle_timer32(fi, argp);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	unlock_kernel();
+
+	return err;
+}
+#endif
+
 static unsigned int raw1394_poll(struct file *file, poll_table * pt)
 {
 	struct file_info *fi = file->private_data;
@@ -3040,7 +3136,9 @@ static const struct file_operations raw1
 	.write = raw1394_write,
 	.mmap = raw1394_mmap,
 	.ioctl = raw1394_ioctl,
-	// .compat_ioctl = ... someone needs to do this
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = raw1394_compat_ioctl,
+#endif
 	.poll = raw1394_poll,
 	.open = raw1394_open,
 	.release = raw1394_release,
