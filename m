Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZHPUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZHPUxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZHPUxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:53:48 -0400
Received: from www84.your-server.de ([213.133.104.84]:53394 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZHPUxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:53:47 -0400
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and
 kfifo_get... into kfifo_out...
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <1250455161.28540.4.camel@wall-e>
References: <1250455161.28540.4.camel@wall-e>
Content-Type: text/plain
Date: Sun, 16 Aug 2009 22:53:37 +0200
Message-Id: <1250456017.28540.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename kfifo_put... into kfifo_in... to prevent miss use of old non in kernel-tree drivers
ditto for kfifo_get... -> kfifo_out...

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c                       |    4 +--
 drivers/char/sonypi.c                       |    8 +++----
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   16 +++++++-------
 drivers/media/video/meye.c                  |   16 +++++++-------
 drivers/net/wireless/libertas/main.c        |    4 +--
 drivers/platform/x86/fujitsu-laptop.c       |    4 +--
 drivers/platform/x86/sony-laptop.c          |    8 +++----
 drivers/scsi/libiscsi.c                     |   14 ++++++------
 drivers/scsi/libiscsi_tcp.c                 |   18 +++++++--------
 drivers/scsi/libsrp.c                       |    6 ++---
 drivers/usb/host/fhci.h                     |    4 +--
 include/linux/kfifo.h                       |   20 ++++++++---------
 kernel/kfifo.c                              |   32 ++++++++++++++--------------
 net/dccp/probe.c                            |    4 +--
 14 files changed, 79 insertions(+), 79 deletions(-)

diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/char/nozomi.c linux-2.6.31-rc4-kfifo4/drivers/char/nozomi.c
--- linux-2.6.31-rc4-kfifo3/drivers/char/nozomi.c	2009-08-11 13:14:26.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/char/nozomi.c	2009-08-11 13:26:07.000000000 +0200
@@ -797,7 +797,7 @@
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = kfifo_get(&port->fifo_ul, dc->send_buf,
+	size = kfifo_out(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -1671,7 +1671,7 @@
 		goto exit;
 	}
 
-	rval = kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/char/sonypi.c linux-2.6.31-rc4-kfifo4/drivers/char/sonypi.c
--- linux-2.6.31-rc4-kfifo3/drivers/char/sonypi.c	2009-08-11 12:56:44.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/char/sonypi.c	2009-08-11 13:26:11.000000000 +0200
@@ -776,7 +776,7 @@
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_get_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
+	while (kfifo_out_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
 			 sizeof(kp), &sonypi_device.input_fifo_lock)
 			== sizeof(kp)) {
 		msleep(10);
@@ -827,7 +827,7 @@
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_put_locked(&sonypi_device.input_fifo,
+		kfifo_in_locked(&sonypi_device.input_fifo,
 			(unsigned char *)&kp, sizeof(kp),
 			&sonypi_device.input_fifo_lock);
 		schedule_work(&sonypi_device.input_work);
@@ -881,7 +881,7 @@
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_put_locked(&sonypi_device.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
 			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
@@ -931,7 +931,7 @@
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get_locked(&sonypi_device.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_device.fifo, &c, sizeof(c),
 				 &sonypi_device.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c linux-2.6.31-rc4-kfifo4/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- linux-2.6.31-rc4-kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-11 13:14:18.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-11 13:26:03.000000000 +0200
@@ -59,7 +59,7 @@
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,22 +71,22 @@
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			kfifo_put(fifo,
+			kfifo_in(fifo,
 				(unsigned char *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			kfifo_put(fifo,
+			kfifo_in(fifo,
 				(unsigned char *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
+			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_get_locked(fifo, (unsigned char *) &entry,
+		kfifo_out_locked(fifo, (unsigned char *) &entry,
 				sizeof(u32), fifo_lock);
 	return 0;
 }
@@ -119,7 +119,7 @@
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			kfifo_put(&rdev_p->rscp->qpid_fifo,
+			kfifo_in(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
@@ -180,7 +180,7 @@
 static u32 cxio_hal_get_resource(struct kfifo *fifo, spinlock_t * lock)
 {
 	u32 entry;
-	if (kfifo_get_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
+	if (kfifo_out_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
 		return entry;
 	else
 		return 0;	/* fifo emptry */
@@ -190,7 +190,7 @@
 		u32 entry)
 {
 	BUG_ON(
-	kfifo_put_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
+	kfifo_in_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
 	== 0);
 }
 
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/media/video/meye.c linux-2.6.31-rc4-kfifo4/drivers/media/video/meye.c
--- linux-2.6.31-rc4-kfifo3/drivers/media/video/meye.c	2009-08-09 11:40:34.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/media/video/meye.c	2009-08-11 13:25:56.000000000 +0200
@@ -799,7 +799,7 @@
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
@@ -810,7 +810,7 @@
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	} else {
@@ -820,7 +820,7 @@
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
@@ -831,7 +831,7 @@
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	}
@@ -934,7 +934,7 @@
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_put_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
 			 &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -967,7 +967,7 @@
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_get_locked(&meye.doneq, (unsigned char *)&unused,
+		kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
 				sizeof(int), &meye.doneq_lock);
 	}
 	*i = meye.grab_buffer[*i].size;
@@ -1455,7 +1455,7 @@
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_put_locked(&meye.grabq, (unsigned char *)&buf->index,
+	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
 			sizeof(int), &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -1482,7 +1482,7 @@
 		return -EINTR;
 	}
 
-	if (!kfifo_get_locked(&meye.doneq, (unsigned char *)&reqnr,
+	if (!kfifo_out_locked(&meye.doneq, (unsigned char *)&reqnr,
 		       sizeof(int), &meye.doneq_lock)) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/main.c linux-2.6.31-rc4-kfifo4/drivers/net/wireless/libertas/main.c
--- linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/main.c	2009-08-11 13:14:41.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/net/wireless/libertas/main.c	2009-08-11 13:26:16.000000000 +0200
@@ -854,7 +854,7 @@
 		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
 
-			kfifo_get(&priv->event_fifo, (unsigned char *) &event,
+			kfifo_out(&priv->event_fifo, (unsigned char *) &event,
 				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
@@ -1578,7 +1578,7 @@
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_in(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/platform/x86/fujitsu-laptop.c linux-2.6.31-rc4-kfifo4/drivers/platform/x86/fujitsu-laptop.c
--- linux-2.6.31-rc4-kfifo3/drivers/platform/x86/fujitsu-laptop.c	2009-08-11 22:47:25.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/platform/x86/fujitsu-laptop.c	2009-08-11 22:47:40.000000000 +0200
@@ -1007,7 +1007,7 @@
 				vdbg_printk(FUJLAPTOP_DBG_TRACE,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
-				status = kfifo_put_locked(&fujitsu_hotkey->fifo,
+				status = kfifo_in_locked(&fujitsu_hotkey->fifo,
 						   (unsigned char *)&keycode,
 						   sizeof(keycode),
 						   &fujitsu_hotkey->fifo_lock);
@@ -1021,7 +1021,7 @@
 				}
 			} else if (keycode == 0) {
 				while ((status =
-					kfifo_get_locked(
+					kfifo_out_locked(
 					 &fujitsu_hotkey->fifo,
 					 (unsigned char *) &keycode_r,
 					 sizeof(keycode_r),
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/platform/x86/sony-laptop.c linux-2.6.31-rc4-kfifo4/drivers/platform/x86/sony-laptop.c
--- linux-2.6.31-rc4-kfifo3/drivers/platform/x86/sony-laptop.c	2009-08-11 13:13:24.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/platform/x86/sony-laptop.c	2009-08-11 13:25:37.000000000 +0200
@@ -300,7 +300,7 @@
 {
 	struct sony_laptop_keypress kp;
 
-	while (kfifo_get_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
+	while (kfifo_out_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
 			sizeof(kp), &sony_laptop_input.fifo_lock)
 			== sizeof(kp)) {
 		msleep(10);
@@ -363,7 +363,7 @@
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_put_locked(&sony_laptop_input.fifo,
+		kfifo_in_locked(&sony_laptop_input.fifo,
 			  (unsigned char *)&kp, sizeof(kp),
 			  &sony_laptop_input.fifo_lock);
 
@@ -2144,7 +2144,7 @@
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get_locked(&sonypi_compat.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_compat.fifo, &c, sizeof(c),
 			  &sonypi_compat.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
@@ -2324,7 +2324,7 @@
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_put_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_compat.fifo, (unsigned char *)&event,
 			sizeof(event), &sonypi_compat.fifo_lock);
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi.c linux-2.6.31-rc4-kfifo4/drivers/scsi/libiscsi.c
--- linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi.c	2009-08-11 13:13:43.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/scsi/libiscsi.c	2009-08-11 13:25:42.000000000 +0200
@@ -428,7 +428,7 @@
 	if (conn->login_task == task)
 		return;
 
-	kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -614,7 +614,7 @@
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_get(&session->cmdpool.queue,
+		if (!kfifo_out(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1376,7 +1376,7 @@
 {
 	struct iscsi_task *task;
 
-	if (!kfifo_get(&conn->session->cmdpool.queue,
+	if (!kfifo_out(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2129,7 +2129,7 @@
 			q->max = i;
 			goto enomem;
 		}
-		kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2476,7 +2476,7 @@
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!kfifo_get(&session->cmdpool.queue,
+	if (!kfifo_out(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2496,7 +2496,7 @@
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2559,7 +2559,7 @@
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi_tcp.c linux-2.6.31-rc4-kfifo4/drivers/scsi/libiscsi_tcp.c
--- linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi_tcp.c	2009-08-11 22:41:20.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/scsi/libiscsi_tcp.c	2009-08-11 22:41:29.000000000 +0200
@@ -445,15 +445,15 @@
 		return;
 
 	/* flush task's r2t queues */
-	while (kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+	while (kfifo_out(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -541,7 +541,7 @@
 		return 0;
 	}
 
-	rc = kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = kfifo_out(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -982,7 +982,7 @@
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				kfifo_put(&tcp_task->r2tpool.queue,
+				kfifo_in(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@
 		}
 
 		if (r2t == NULL) {
-			kfifo_get(&tcp_task->r2tqueue,
+			kfifo_out(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/scsi/libsrp.c linux-2.6.31-rc4-kfifo4/drivers/scsi/libsrp.c
--- linux-2.6.31-rc4-kfifo3/drivers/scsi/libsrp.c	2009-08-11 13:14:12.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/scsi/libsrp.c	2009-08-11 13:25:50.000000000 +0200
@@ -61,7 +61,7 @@
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
@@ -163,7 +163,7 @@
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_get_locked(&target->iu_queue.queue, (void *) &iue,
+	kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
 			sizeof(void *), &target->iu_queue.lock);
 	if (!iue)
 		return iue;
@@ -176,7 +176,7 @@
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_put_locked(&iue->target->iu_queue.queue, (void *) &iue,
+	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
 			sizeof(void *), &iue->target->iu_queue.lock);
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
diff -u -N -r linux-2.6.31-rc4-kfifo3/drivers/usb/host/fhci.h linux-2.6.31-rc4-kfifo4/drivers/usb/host/fhci.h
--- linux-2.6.31-rc4-kfifo3/drivers/usb/host/fhci.h	2009-08-11 13:14:36.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/drivers/usb/host/fhci.h	2009-08-11 13:26:13.000000000 +0200
@@ -510,14 +510,14 @@
 
 static inline int cq_put(struct kfifo *kfifo, void *p)
 {
-	return kfifo_put(kfifo, (void *)&p, sizeof(p));
+	return kfifo_in(kfifo, (void *)&p, sizeof(p));
 }
 
 static inline void *cq_get(struct kfifo *kfifo)
 {
 	void *p = NULL;
 
-	kfifo_get(kfifo, (void *)&p, sizeof(p));
+	kfifo_out(kfifo, (void *)&p, sizeof(p));
 	return p;
 }
 
diff -u -N -r linux-2.6.31-rc4-kfifo3/include/linux/kfifo.h linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo3/include/linux/kfifo.h	2009-08-16 22:15:37.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h	2009-08-16 22:16:13.000000000 +0200
@@ -37,10 +37,10 @@
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern unsigned int kfifo_put(struct kfifo *fifo,
-				const unsigned char *buffer, unsigned int len);
-extern unsigned int kfifo_get(struct kfifo *fifo,
-				unsigned char *buffer, unsigned int len);
+extern __must_check unsigned int kfifo_in(struct kfifo *fifo,
+				const unsigned char *from, unsigned int len);
+extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
+				unsigned char *to, unsigned int len);
 
 /**
  * kfifo_reset - removes the entire FIFO contents
@@ -65,7 +65,7 @@
 }
 
 /**
- * kfifo_put_locked - puts some data into the FIFO using a spinlock for locking
+ * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @from: the data to be added.
  * @len: the length of the data to be added.
@@ -75,7 +75,7 @@
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline __must_check unsigned int kfifo_put_locked(struct kfifo *fifo,
+static inline __must_check unsigned int kfifo_in_locked(struct kfifo *fifo,
 		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
@@ -83,7 +83,7 @@
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = kfifo_put(fifo, from, n);
+	ret = kfifo_in(fifo, from, n);
 
 	spin_unlock_irqrestore(lock, flags);
 
@@ -91,7 +91,7 @@
 }
 
 /**
- * kfifo_get_locked - gets some data from the FIFO using a spinlock for locking
+ * kfifo_out_locked - gets some data from the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
@@ -100,7 +100,7 @@
  * This function copies at most @len bytes from the FIFO into the
  * @to buffer and returns the number of copied bytes.
  */
-static inline __must_check unsigned int kfifo_get_locked(struct kfifo *fifo,
+static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
 	unsigned char *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
@@ -108,7 +108,7 @@
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = kfifo_get(fifo, to, n);
+	ret = kfifo_out(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
diff -u -N -r linux-2.6.31-rc4-kfifo3/kernel/kfifo.c linux-2.6.31-rc4-kfifo4/kernel/kfifo.c
--- linux-2.6.31-rc4-kfifo3/kernel/kfifo.c	2009-08-16 22:08:48.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/kernel/kfifo.c	2009-08-16 22:08:56.000000000 +0200
@@ -100,20 +100,20 @@
 EXPORT_SYMBOL(kfifo_free);
 
 /**
- * kfifo_put - puts some data into the FIFO, no locking version
+ * kfifo_in - puts some data into the FIFO
  * @fifo: the fifo to be used.
- * @buffer: the data to be added.
+ * @from: the data to be added.
  * @len: the length of the data to be added.
  *
- * This function copies at most @len bytes from the @buffer into
+ * This function copies at most @len bytes from the @from buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_put(struct kfifo *fifo,
-			const unsigned char *buffer, unsigned int len)
+unsigned int kfifo_in(struct kfifo *fifo,
+			const unsigned char *from, unsigned int len)
 {
 	unsigned int l;
 
@@ -128,10 +128,10 @@
 
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - (fifo->in & (fifo->size - 1)));
-	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), buffer, l);
+	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), from, l);
 
 	/* then put the rest (if any) at the beginning of the buffer */
-	memcpy(fifo->buffer, buffer + l, len - l);
+	memcpy(fifo->buffer, from + l, len - l);
 
 	/*
 	 * Ensure that we add the bytes to the kfifo -before-
@@ -144,22 +144,22 @@
 
 	return len;
 }
-EXPORT_SYMBOL(kfifo_put);
+EXPORT_SYMBOL(kfifo_in);
 
 /**
- * kfifo_get - gets some data from the FIFO, no locking version
+ * kfifo_out - gets some data from the FIFO
  * @fifo: the fifo to be used.
- * @buffer: where the data must be copied.
+ * @to: where the data must be copied.
  * @len: the size of the destination buffer.
  *
  * This function copies at most @len bytes from the FIFO into the
- * @buffer and returns the number of copied bytes.
+ * @to buffer and returns the number of copied bytes.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_get(struct kfifo *fifo,
-			 unsigned char *buffer, unsigned int len)
+unsigned int kfifo_out(struct kfifo *fifo,
+			 unsigned char *to, unsigned int len)
 {
 	unsigned int l;
 
@@ -174,10 +174,10 @@
 
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - (fifo->out & (fifo->size - 1)));
-	memcpy(buffer, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
+	memcpy(to, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
 
 	/* then get the rest (if any) from the beginning of the buffer */
-	memcpy(buffer + l, fifo->buffer, len - l);
+	memcpy(to + l, fifo->buffer, len - l);
 
 	/*
 	 * Ensure that we remove the bytes from the kfifo -before-
@@ -190,4 +190,4 @@
 
 	return len;
 }
-EXPORT_SYMBOL(kfifo_get);
+EXPORT_SYMBOL(kfifo_out);
diff -u -N -r linux-2.6.31-rc4-kfifo3/net/dccp/probe.c linux-2.6.31-rc4-kfifo4/net/dccp/probe.c
--- linux-2.6.31-rc4-kfifo3/net/dccp/probe.c	2009-08-11 13:15:34.000000000 +0200
+++ linux-2.6.31-rc4-kfifo4/net/dccp/probe.c	2009-08-11 13:26:33.000000000 +0200
@@ -67,7 +67,7 @@
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_put_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	kfifo_in_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	wake_up(&dccpw.wait);
 }
 
@@ -136,7 +136,7 @@
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_get_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	cnt = kfifo_out_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:


