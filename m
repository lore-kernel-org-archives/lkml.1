Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZLKJTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZLKJTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZLKJS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:18:58 -0500
Received: from www84.your-server.de ([213.133.104.84]:53051 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZLKJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:18:44 -0500
Subject: [PATCH] kfifo: fix warn_unused_result
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 11 Dec 2009 10:18:28 +0100
Message-ID: <1260523108.27010.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Andrew Morton:

This patch fix the "ignoring return value of '...', declared with
attribute warn_unused_result" compiler warning in several users of the
new kfifo API.

The patch-set is against current mm tree from 11-Dec-2009

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c                       |    5 ++--
 drivers/char/sonypi.c                       |   10 ++++----
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   28 ++++++++++++++--------
 drivers/media/video/meye.c                  |   25 ++++++++++++--------
 drivers/net/wireless/libertas/main.c        |    9 ++++---
 drivers/platform/x86/sony-laptop.c          |   10 ++++----
 drivers/scsi/libiscsi.c                     |   18 +++++++++-----
 drivers/scsi/libiscsi_tcp.c                 |   35 +++++++++++++++++-----------
 drivers/scsi/libsrp.c                       |   14 +++++++----
 net/dccp/probe.c                            |    3 +-
 10 files changed, 99 insertions(+), 58 deletions(-)

diff -u -N -r -p mmotm/drivers/char/nozomi.c linux-2.6.32/drivers/char/nozomi.c
--- mmotm/drivers/char/nozomi.c	2009-12-11 08:31:46.670736197 +0100
+++ linux-2.6.32/drivers/char/nozomi.c	2009-12-11 09:25:46.941436203 +0100
@@ -685,8 +685,9 @@ static int nozomi_read_config_table(stru
 		dump_table(dc);
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
-			kfifo_alloc(&dc->port[i].fifo_ul,
-				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
+			if (kfifo_alloc(&dc->port[i].fifo_ul,
+				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC))
+					BUG();
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
diff -u -N -r -p mmotm/drivers/char/sonypi.c linux-2.6.32/drivers/char/sonypi.c
--- mmotm/drivers/char/sonypi.c	2009-12-11 08:31:46.687469885 +0100
+++ linux-2.6.32/drivers/char/sonypi.c	2009-12-11 09:26:32.956848176 +0100
@@ -828,9 +828,10 @@ static void sonypi_report_input_event(u8
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_in_locked(&sonypi_device.input_fifo,
+		if (kfifo_in_locked(&sonypi_device.input_fifo,
 			(unsigned char *)&kp, sizeof(kp),
-			&sonypi_device.input_fifo_lock);
+			&sonypi_device.input_fifo_lock) != sizeof(kp))
+				BUG();
 		schedule_work(&sonypi_device.input_work);
 	}
 }
@@ -882,8 +883,9 @@ found:
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
-			sizeof(event), &sonypi_device.fifo_lock);
+	if (kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
+		sizeof(event), &sonypi_device.fifo_lock) != sizeof(event))
+			BUG();
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
 
diff -u -N -r -p mmotm/drivers/infiniband/hw/cxgb3/cxio_resource.c linux-2.6.32/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- mmotm/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-12-11 08:31:46.872467869 +0100
+++ linux-2.6.32/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-12-11 09:30:12.686765202 +0100
@@ -59,7 +59,9 @@ static int __cxio_init_resource_fifo(str
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
+		if (kfifo_in(fifo, (unsigned char *) &entry,
+			sizeof(u32)) != sizeof(u32))
+				BUG();
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,23 +73,28 @@ static int __cxio_init_resource_fifo(str
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			kfifo_in(fifo,
+			if (kfifo_in(fifo,
 				(unsigned char *) &rarray[idx],
-				sizeof(u32));
+				sizeof(u32)) != sizeof(u32))
+					BUG();
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			kfifo_in(fifo,
+			if (kfifo_in(fifo,
 				(unsigned char *) &rarray[i],
-				sizeof(u32));
+				sizeof(u32)) != sizeof(u32))
+					BUG();
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
+			if (kfifo_in(fifo, (unsigned char *) &i,
+				sizeof(u32)) != sizeof(u32))
+					BUG();
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_out_locked(fifo, (unsigned char *) &entry,
-				sizeof(u32), fifo_lock);
+		if (kfifo_out_locked(fifo, (unsigned char *) &entry,
+				sizeof(u32), fifo_lock) != sizeof(u32))
+					BUG();
 	return 0;
 }
 
@@ -119,8 +126,9 @@ static int cxio_init_qpid_fifo(struct cx
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			kfifo_in(&rdev_p->rscp->qpid_fifo,
-				    (unsigned char *) &i, sizeof(u32));
+			if (kfifo_in(&rdev_p->rscp->qpid_fifo,
+			    (unsigned char *) &i, sizeof(u32)) != sizeof(u32))
+				BUG();
 	return 0;
 }
 
diff -u -N -r -p mmotm/drivers/media/video/meye.c linux-2.6.32/drivers/media/video/meye.c
--- mmotm/drivers/media/video/meye.c	2009-12-11 08:31:47.526583967 +0100
+++ linux-2.6.32/drivers/media/video/meye.c	2009-12-11 09:33:05.861721921 +0100
@@ -811,8 +811,9 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
-				sizeof(int), &meye.doneq_lock);
+		if (kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+			sizeof(int), &meye.doneq_lock) != sizeof(int))
+				BUG();
 		wake_up_interruptible(&meye.proc_list);
 	} else {
 		int size;
@@ -832,8 +833,9 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
-				sizeof(int), &meye.doneq_lock);
+		if (kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+			sizeof(int), &meye.doneq_lock) != sizeof(int))
+				BUG();
 		wake_up_interruptible(&meye.proc_list);
 	}
 	mchip_free_frame();
@@ -935,8 +937,9 @@ static int meyeioc_qbuf_capt(int *nb)
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
-			 &meye.grabq_lock);
+	if (kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+		 &meye.grabq_lock) != sizeof(int))
+			BUG();
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -968,8 +971,9 @@ static int meyeioc_sync(struct file *fil
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
-				sizeof(int), &meye.doneq_lock);
+		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
+			sizeof(int), &meye.doneq_lock) != sizeof(int))
+				BUG();
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
@@ -1456,8 +1460,9 @@ static int vidioc_qbuf(struct file *file
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
-			sizeof(int), &meye.grabq_lock);
+	if (kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
+		sizeof(int), &meye.grabq_lock) != sizeof(int))
+			BUG();
 	mutex_unlock(&meye.lock);
 
 	return 0;
diff -u -N -r -p mmotm/drivers/net/wireless/libertas/main.c linux-2.6.32/drivers/net/wireless/libertas/main.c
--- mmotm/drivers/net/wireless/libertas/main.c	2009-12-11 08:31:48.346583558 +0100
+++ linux-2.6.32/drivers/net/wireless/libertas/main.c	2009-12-11 09:35:22.549908343 +0100
@@ -514,8 +514,9 @@ static int lbs_thread(void *data)
 		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
 
-			kfifo_out(&priv->event_fifo, (unsigned char *) &event,
-				sizeof(event));
+			if (kfifo_out(&priv->event_fifo, (unsigned char *)
+				&event, sizeof(event)) != sizeof(event))
+					BUG();
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
 			spin_lock_irq(&priv->driver_lock);
@@ -1176,7 +1177,9 @@ void lbs_queue_event(struct lbs_private 
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	kfifo_in(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	if (kfifo_in(&priv->event_fifo, (unsigned char *) &event,
+		sizeof(u32)) != sizeof(u32))
+			BUG();
 
 	wake_up_interruptible(&priv->waitq);
 
diff -u -N -r -p mmotm/drivers/platform/x86/sony-laptop.c linux-2.6.32/drivers/platform/x86/sony-laptop.c
--- mmotm/drivers/platform/x86/sony-laptop.c	2009-12-11 08:31:48.459583608 +0100
+++ linux-2.6.32/drivers/platform/x86/sony-laptop.c	2009-12-11 09:36:20.365344161 +0100
@@ -363,9 +363,10 @@ static void sony_laptop_report_input_eve
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_in_locked(&sony_laptop_input.fifo,
+		if (kfifo_in_locked(&sony_laptop_input.fifo,
 			  (unsigned char *)&kp, sizeof(kp),
-			  &sony_laptop_input.fifo_lock);
+			  &sony_laptop_input.fifo_lock) != sizeof(kp))
+				BUG();
 
 		if (!work_pending(&sony_laptop_release_key_work))
 			queue_work(sony_laptop_input.wq,
@@ -2310,8 +2311,9 @@ static struct miscdevice sonypi_misc_dev
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_in_locked(&sonypi_compat.fifo, (unsigned char *)&event,
-			sizeof(event), &sonypi_compat.fifo_lock);
+	if (kfifo_in_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+		sizeof(event), &sonypi_compat.fifo_lock) != sizeof(event))
+			BUG();
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
 }
diff -u -N -r -p mmotm/drivers/scsi/libiscsi.c linux-2.6.32/drivers/scsi/libiscsi.c
--- mmotm/drivers/scsi/libiscsi.c	2009-12-11 08:31:48.989159288 +0100
+++ linux-2.6.32/drivers/scsi/libiscsi.c	2009-12-11 09:21:57.984708390 +0100
@@ -517,7 +517,9 @@ static void iscsi_free_task(struct iscsi
 	if (conn->login_task == task)
 		return;
 
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	if (kfifo_in(&session->cmdpool.queue, (void*)&task,
+	     sizeof(void*)) != sizeof(void*))
+		BUG();
 
 	if (sc) {
 		task->sc = NULL;
@@ -2469,7 +2471,9 @@ iscsi_pool_init(struct iscsi_pool *q, in
 			q->max = i;
 			goto enomem;
 		}
-		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		if (kfifo_in(&q->queue, (void*)&q->pool[i],
+		     sizeof(void*)) != sizeof(void*))
+			BUG();
 	}
 
 	if (items) {
@@ -2839,8 +2843,9 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	if (kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	     sizeof(void*)) != sizeof(void*))
+		BUG();
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -2902,8 +2907,9 @@ void iscsi_conn_teardown(struct iscsi_cl
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	if (kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	     sizeof(void*)) != sizeof(void*))
+		BUG();
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->lock);
diff -u -N -r -p mmotm/drivers/scsi/libiscsi_tcp.c linux-2.6.32/drivers/scsi/libiscsi_tcp.c
--- mmotm/drivers/scsi/libiscsi_tcp.c	2009-12-11 08:31:48.989159288 +0100
+++ linux-2.6.32/drivers/scsi/libiscsi_tcp.c	2009-12-11 09:41:25.819705434 +0100
@@ -446,15 +446,17 @@ void iscsi_tcp_cleanup_task(struct iscsi
 
 	/* flush task's r2t queues */
 	while (kfifo_out(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
+		if (kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*)) != sizeof(void*))
+				BUG();
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
+		if (kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*)) != sizeof(void*))
+				BUG();
 		tcp_task->r2t = NULL;
 	}
 }
@@ -554,8 +556,9 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
+		if (kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*)) != sizeof(void*))
+				BUG();
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -570,8 +573,9 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
-			    sizeof(void*));
+		if (kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+			    sizeof(void*)) != sizeof(void*))
+				BUG();
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -580,7 +584,9 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	if (kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*)) !=
+	     sizeof(void*))
+		BUG();
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -982,16 +988,19 @@ static struct iscsi_r2t_info *iscsi_tcp_
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				kfifo_in(&tcp_task->r2tpool.queue,
+				if (kfifo_in(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
-					    sizeof(void *));
+					    sizeof(void *)) != sizeof(void*))
+						BUG();
 				tcp_task->r2t = r2t = NULL;
 			}
 		}
 
 		if (r2t == NULL) {
-			kfifo_out(&tcp_task->r2tqueue,
-				    (void *)&tcp_task->r2t, sizeof(void *));
+			if (kfifo_out(&tcp_task->r2tqueue,
+				    (void *)&tcp_task->r2t,
+				    sizeof(void *)) != sizeof(void*))
+					BUG();
 			r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
diff -u -N -r -p mmotm/drivers/scsi/libsrp.c linux-2.6.32/drivers/scsi/libsrp.c
--- mmotm/drivers/scsi/libsrp.c	2009-12-11 08:31:48.992509364 +0100
+++ linux-2.6.32/drivers/scsi/libsrp.c	2009-12-11 09:42:52.551466710 +0100
@@ -61,7 +61,9 @@ static int srp_iu_pool_alloc(struct srp_
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
+		if (kfifo_in(&q->queue, (void *) &iue,
+		     sizeof(void *)) != sizeof(void*))
+			BUG();
 		iue->sbuf = ring[i];
 		iue++;
 	}
@@ -163,8 +165,9 @@ struct iu_entry *srp_iu_get(struct srp_t
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &target->iu_queue.lock);
+	if (kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
+		sizeof(void *), &target->iu_queue.lock) != sizeof(void*))
+			BUG();
 	if (!iue)
 		return iue;
 	iue->target = target;
@@ -176,8 +179,9 @@ EXPORT_SYMBOL_GPL(srp_iu_get);
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &iue->target->iu_queue.lock);
+	if (kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
+		sizeof(void *), &iue->target->iu_queue.lock) != sizeof(void*))
+			BUG();
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
diff -u -N -r -p mmotm/net/dccp/probe.c linux-2.6.32/net/dccp/probe.c
--- mmotm/net/dccp/probe.c	2009-12-11 08:31:51.810583482 +0100
+++ linux-2.6.32/net/dccp/probe.c	2009-12-11 09:43:20.478026812 +0100
@@ -67,7 +67,8 @@ static void printl(const char *fmt, ...)
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_in_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	if (kfifo_in_locked(&dccpw.fifo, tbuf, len, &dccpw.lock) != len)
+		BUG();
 	wake_up(&dccpw.wait);
 }
 


