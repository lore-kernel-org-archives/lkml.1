Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZHNLn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZHNLn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZHNLn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:43:28 -0400
Received: from www84.your-server.de ([213.133.104.84]:43812 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZHNLn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:43:27 -0400
Subject: [PATCH 2/6] new kfifo API v0.3 - Cleanup namespace
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 13:43:27 +0200
Message-Id: <1250250207.19690.93.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 2/6 of the new kfifo API:
 rename all __kfifo_* into kfifo_*
 
 drivers/char/nozomi.c                       |   12 +++++-----
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   10 ++++----
 drivers/net/wireless/libertas/cmd.c         |    4 +--
 drivers/net/wireless/libertas/main.c        |    8 +++----
 drivers/platform/x86/sony-laptop.c          |    2 -
 drivers/scsi/libiscsi.c                     |   14 ++++++------
 drivers/scsi/libiscsi_tcp.c                 |   20 ++++++++---------
 drivers/scsi/libsrp.c                       |    2 -
 drivers/usb/host/fhci.h                     |    6 ++---
 include/linux/kfifo.h                       |   32 ++++++----------------------
 kernel/kfifo.c                              |   12 +++++-----
 net/dccp/probe.c                            |    2 -
 12 files changed, 53 insertions(+), 71 deletions(-)

Signed-off-by: Stefani Seibold <stefani@seibold.net>

diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/char/nozomi.c linux-2.6.31-rc4-kfifo3/drivers/char/nozomi.c
--- linux-2.6.31-rc4-kfifo2/drivers/char/nozomi.c	2009-08-11 12:46:56.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/char/nozomi.c	2009-08-11 13:14:26.000000000 +0200
@@ -797,7 +797,7 @@
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = __kfifo_get(&port->fifo_ul, dc->send_buf,
+	size = kfifo_get(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -987,11 +987,11 @@
 
 	} else if (old_ctrl.CTS == 0 && ctrl_dl.CTS == 1) {
 
-		if (__kfifo_len(&dc->port[port].fifo_ul)) {
+		if (kfifo_len(&dc->port[port].fifo_ul)) {
 			DBG1("Enable interrupt (0x%04X) on port: %d",
 				enable_ier, port);
 			DBG1("Data in buffer [%d], enable transmit! ",
-				__kfifo_len(&dc->port[port].fifo_ul));
+				kfifo_len(&dc->port[port].fifo_ul));
 			enable_transmit_ul(port, dc);
 		} else {
 			DBG1("No data in buffer...");
@@ -1671,7 +1671,7 @@
 		goto exit;
 	}
 
-	rval = __kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
@@ -1719,7 +1719,7 @@
 	if (!port->port.count)
 		goto exit;
 
-	room = port->fifo_ul.size - __kfifo_len(&port->fifo_ul);
+	room = port->fifo_ul.size - kfifo_len(&port->fifo_ul);
 
 exit:
 	mutex_unlock(&port->tty_sem);
@@ -1876,7 +1876,7 @@
 		goto exit_in_buffer;
 	}
 
-	rval = __kfifo_len(&port->fifo_ul);
+	rval = kfifo_len(&port->fifo_ul);
 
 exit_in_buffer:
 	return rval;
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c linux-2.6.31-rc4-kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- linux-2.6.31-rc4-kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-11 12:47:57.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-11 13:14:18.000000000 +0200
@@ -59,7 +59,7 @@
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		__kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,19 +71,19 @@
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			__kfifo_put(fifo,
+			kfifo_put(fifo,
 				(unsigned char *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			__kfifo_put(fifo,
+			kfifo_put(fifo,
 				(unsigned char *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			__kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
+			kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
 		kfifo_get_locked(fifo, (unsigned char *) &entry,
@@ -119,7 +119,7 @@
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			__kfifo_put(&rdev_p->rscp->qpid_fifo,
+			kfifo_put(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/cmd.c linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/cmd.c
--- linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/cmd.c	2009-08-11 12:51:53.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/cmd.c	2009-08-11 13:14:45.000000000 +0200
@@ -1862,7 +1862,7 @@
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* If nothing to do, go back to sleep (?) */
-	if (!__kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
+	if (!kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1936,7 +1936,7 @@
 	}
 
 	/* Pending events or command responses? */
-	if (__kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
+	if (kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
 		allowed = 0;
 		lbs_deb_host("pending events or command responses\n");
 	}
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/main.c linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/main.c
--- linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/main.c	2009-08-11 12:45:53.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/net/wireless/libertas/main.c	2009-08-11 13:14:41.000000000 +0200
@@ -772,7 +772,7 @@
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
 			shouldsleep = 0;	/* We have a command to send */
-		else if (__kfifo_len(&priv->event_fifo))
+		else if (kfifo_len(&priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
 		else
 			shouldsleep = 1;	/* No command */
@@ -851,10 +851,10 @@
 
 		/* Process hardware events, e.g. card removed, link lost */
 		spin_lock_irq(&priv->driver_lock);
-		while (__kfifo_len(&priv->event_fifo)) {
+		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
 
-			__kfifo_get(&priv->event_fifo, (unsigned char *) &event,
+			kfifo_get(&priv->event_fifo, (unsigned char *) &event,
 				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
@@ -1578,7 +1578,7 @@
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	__kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/platform/x86/sony-laptop.c linux-2.6.31-rc4-kfifo3/drivers/platform/x86/sony-laptop.c
--- linux-2.6.31-rc4-kfifo2/drivers/platform/x86/sony-laptop.c	2009-08-11 12:49:23.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/platform/x86/sony-laptop.c	2009-08-11 13:13:24.000000000 +0200
@@ -2121,7 +2121,7 @@
 	spin_lock_irqsave(&sonypi_compat.fifo_lock, flags);
 
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
-		__kfifo_reset(&sonypi_compat.fifo);
+		kfifo_reset(&sonypi_compat.fifo);
 
 	spin_unlock_irqrestore(&sonypi_compat.fifo_lock, flags);
 
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi.c linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi.c
--- linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi.c	2009-08-09 16:15:00.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi.c	2009-08-11 13:13:43.000000000 +0200
@@ -428,7 +428,7 @@
 	if (conn->login_task == task)
 		return;
 
-	__kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -614,7 +614,7 @@
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!__kfifo_get(&session->cmdpool.queue,
+		if (!kfifo_get(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1376,7 +1376,7 @@
 {
 	struct iscsi_task *task;
 
-	if (!__kfifo_get(&conn->session->cmdpool.queue,
+	if (!kfifo_get(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2129,7 +2129,7 @@
 			q->max = i;
 			goto enomem;
 		}
-		__kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2476,7 +2476,7 @@
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!__kfifo_get(&session->cmdpool.queue,
+	if (!kfifo_get(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2496,7 +2496,7 @@
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2559,7 +2559,7 @@
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi_tcp.c linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi_tcp.c
--- linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi_tcp.c	2009-08-11 22:41:11.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/scsi/libiscsi_tcp.c	2009-08-11 22:41:20.000000000 +0200
@@ -445,15 +445,15 @@
 		return;
 
 	/* flush task's r2t queues */
-	while (__kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+	while (kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -541,7 +541,7 @@
 		return 0;
 	}
 
-	rc = __kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	__kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -951,7 +951,7 @@
 		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
 
-	BUG_ON(__kfifo_len(&tcp_task->r2tqueue));
+	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
@@ -982,7 +982,7 @@
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				__kfifo_put(&tcp_task->r2tpool.queue,
+				kfifo_put(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@
 		}
 
 		if (r2t == NULL) {
-			__kfifo_get(&tcp_task->r2tqueue,
+			kfifo_get(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/scsi/libsrp.c linux-2.6.31-rc4-kfifo3/drivers/scsi/libsrp.c
--- linux-2.6.31-rc4-kfifo2/drivers/scsi/libsrp.c	2009-08-09 16:18:53.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/scsi/libsrp.c	2009-08-11 13:14:12.000000000 +0200
@@ -61,7 +61,7 @@
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
diff -u -N -r linux-2.6.31-rc4-kfifo2/drivers/usb/host/fhci.h linux-2.6.31-rc4-kfifo3/drivers/usb/host/fhci.h
--- linux-2.6.31-rc4-kfifo2/drivers/usb/host/fhci.h	2009-08-11 12:46:08.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/drivers/usb/host/fhci.h	2009-08-11 13:14:36.000000000 +0200
@@ -505,19 +505,19 @@
 
 static inline unsigned int cq_howmany(struct kfifo *kfifo)
 {
-	return __kfifo_len(kfifo) / sizeof(void *);
+	return kfifo_len(kfifo) / sizeof(void *);
 }
 
 static inline int cq_put(struct kfifo *kfifo, void *p)
 {
-	return __kfifo_put(kfifo, (void *)&p, sizeof(p));
+	return kfifo_put(kfifo, (void *)&p, sizeof(p));
 }
 
 static inline void *cq_get(struct kfifo *kfifo)
 {
 	void *p = NULL;
 
-	__kfifo_get(kfifo, (void *)&p, sizeof(p));
+	kfifo_get(kfifo, (void *)&p, sizeof(p));
 	return p;
 }
 
diff -u -N -r linux-2.6.31-rc4-kfifo2/include/linux/kfifo.h linux-2.6.31-rc4-kfifo3/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo2/include/linux/kfifo.h	2009-08-14 10:51:07.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/include/linux/kfifo.h	2009-08-14 10:48:30.000000000 +0200
@@ -37,34 +37,25 @@
 extern __must_check int kfifo_alloc(struct kfifo *fifo,
 			unsigned int size, gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern __must_check unsigned int __kfifo_put(struct kfifo *fifo,
+extern __must_check unsigned int kfifo_put(struct kfifo *fifo,
 				const unsigned char *from, unsigned int len);
-extern __must_check unsigned int __kfifo_get(struct kfifo *fifo,
+extern __must_check unsigned int kfifo_get(struct kfifo *fifo,
 				unsigned char *to, unsigned int len);
 
 /**
- * __kfifo_reset - removes the entire FIFO contents, no locking version
- * @fifo: the fifo to be emptied.
- */
-static inline void __kfifo_reset(struct kfifo *fifo)
-{
-	fifo->in = fifo->out = 0;
-}
-
-/**
  * kfifo_reset - removes the entire FIFO contents
  * @fifo: the fifo to be emptied.
  */
 static inline void kfifo_reset(struct kfifo *fifo)
 {
-	__kfifo_reset(fifo);
+	fifo->in = fifo->out = 0;
 }
 
 /**
- * __kfifo_len - returns the number of bytes available in the FIFO
+ * kfifo_len - returns the number of used bytes in the FIFO
  * @fifo: the fifo to be used.
  */
-static inline unsigned int __kfifo_len(struct kfifo *fifo)
+static inline unsigned int kfifo_len(struct kfifo *fifo)
 {
 	register unsigned int	out;
 
@@ -92,7 +83,7 @@
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_put(fifo, from, n);
+	ret = kfifo_put(fifo, from, n);
 
 	spin_unlock_irqrestore(lock, flags);
 
@@ -117,7 +108,7 @@
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_get(fifo, to, n);
+	ret = kfifo_get(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
@@ -131,13 +122,4 @@
 	return ret;
 }
 
-/**
- * kfifo_len - returns the number of bytes available in the FIFO
- * @fifo: the fifo to be used.
- */
-static inline unsigned int kfifo_len(struct kfifo *fifo)
-{
-	return __kfifo_len(fifo);
-}
-
 #endif
diff -u -N -r linux-2.6.31-rc4-kfifo2/kernel/kfifo.c linux-2.6.31-rc4-kfifo3/kernel/kfifo.c
--- linux-2.6.31-rc4-kfifo2/kernel/kfifo.c	2009-08-14 09:41:17.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/kernel/kfifo.c	2009-08-14 09:40:05.000000000 +0200
@@ -99,7 +99,7 @@
 EXPORT_SYMBOL(kfifo_free);
 
 /**
- * __kfifo_put - puts some data into the FIFO, no locking version
+ * kfifo_put - puts some data into the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @from: the data to be added.
  * @len: the length of the data to be added.
@@ -111,7 +111,7 @@
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_put(struct kfifo *fifo,
+unsigned int kfifo_put(struct kfifo *fifo,
 			const unsigned char *from, unsigned int len)
 {
 	unsigned int l;
@@ -143,10 +143,10 @@
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_put);
+EXPORT_SYMBOL(kfifo_put);
 
 /**
- * __kfifo_get - gets some data from the FIFO, no locking version
+ * kfifo_get - gets some data from the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
@@ -157,7 +157,7 @@
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_get(struct kfifo *fifo,
+unsigned int kfifo_get(struct kfifo *fifo,
 			 unsigned char *to, unsigned int len)
 {
 	unsigned int l;
@@ -189,4 +189,4 @@
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_get);
+EXPORT_SYMBOL(kfifo_get);
diff -u -N -r linux-2.6.31-rc4-kfifo2/net/dccp/probe.c linux-2.6.31-rc4-kfifo3/net/dccp/probe.c
--- linux-2.6.31-rc4-kfifo2/net/dccp/probe.c	2009-08-11 12:50:28.000000000 +0200
+++ linux-2.6.31-rc4-kfifo3/net/dccp/probe.c	2009-08-11 13:15:34.000000000 +0200
@@ -132,7 +132,7 @@
 		return -ENOMEM;
 
 	error = wait_event_interruptible(dccpw.wait,
-					 __kfifo_len(&dccpw.fifo) != 0);
+					 kfifo_len(&dccpw.fifo) != 0);
 	if (error)
 		goto out_free;
 


