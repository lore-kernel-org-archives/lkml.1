Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZKTIXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZKTIXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZKTIXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:23:04 -0500
Received: from www84.your-server.de ([213.133.104.84]:50116 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZKTIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:23:03 -0500
Subject: Re: [PATCH 3/7] kfifo: cleanup namespace
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1258704942.4426.5.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 Nov 2009 09:22:54 +0100
Message-ID: <1258705374.4426.12.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change name of __kfifo_* functions to kfifo_*, because 
the prefix __kfifo should be reserved for internal functions only.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/nozomi.c                       |   12 +++++-----
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   10 ++++----
 drivers/net/wireless/libertas/cmd.c         |    4 +--
 drivers/net/wireless/libertas/main.c        |    8 +++----
 drivers/platform/x86/sony-laptop.c          |    2 -
 drivers/scsi/libiscsi.c                     |   14 ++++++------
 drivers/scsi/libiscsi_tcp.c                 |   20 ++++++++---------
 drivers/scsi/libsrp.c                       |    2 -
 drivers/usb/host/fhci.h                     |    6 ++---
 drivers/usb/serial/generic.c                |    4 +--
 include/linux/kfifo.h                       |   32 ++++++----------------------
 kernel/kfifo.c                              |   12 +++++-----
 net/dccp/probe.c                            |    2 -
 13 files changed, 55 insertions(+), 73 deletions(-)

diff -u -N -r -p kfifo2/drivers/char/nozomi.c kfifo3/drivers/char/nozomi.c
--- kfifo2/drivers/char/nozomi.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/drivers/char/nozomi.c	2009-10-19 21:13:38.000000000 +0200
@@ -798,7 +798,7 @@ static int send_data(enum port_type inde
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = __kfifo_get(&port->fifo_ul, dc->send_buf,
+	size = kfifo_get(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -988,11 +988,11 @@ static int receive_flow_control(struct n
 
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
@@ -1672,7 +1672,7 @@ static int ntty_write(struct tty_struct 
 		goto exit;
 	}
 
-	rval = __kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
@@ -1720,7 +1720,7 @@ static int ntty_write_room(struct tty_st
 	if (!port->port.count)
 		goto exit;
 
-	room = port->fifo_ul.size - __kfifo_len(&port->fifo_ul);
+	room = port->fifo_ul.size - kfifo_len(&port->fifo_ul);
 
 exit:
 	mutex_unlock(&port->tty_sem);
@@ -1877,7 +1877,7 @@ static s32 ntty_chars_in_buffer(struct t
 		goto exit_in_buffer;
 	}
 
-	rval = __kfifo_len(&port->fifo_ul);
+	rval = kfifo_len(&port->fifo_ul);
 
 exit_in_buffer:
 	return rval;
diff -u -N -r -p kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-10-19 21:13:38.000000000 +0200
@@ -59,7 +59,7 @@ static int __cxio_init_resource_fifo(str
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		__kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,19 +71,19 @@ static int __cxio_init_resource_fifo(str
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
@@ -119,7 +119,7 @@ static int cxio_init_qpid_fifo(struct cx
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			__kfifo_put(&rdev_p->rscp->qpid_fifo,
+			kfifo_put(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
diff -u -N -r -p kfifo2/drivers/net/wireless/libertas/cmd.c kfifo3/drivers/net/wireless/libertas/cmd.c
--- kfifo2/drivers/net/wireless/libertas/cmd.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/drivers/net/wireless/libertas/cmd.c	2009-10-19 21:13:38.000000000 +0200
@@ -1869,7 +1869,7 @@ static void lbs_send_confirmsleep(struct
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* If nothing to do, go back to sleep (?) */
-	if (!__kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
+	if (!kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1943,7 +1943,7 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 	}
 
 	/* Pending events or command responses? */
-	if (__kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
+	if (kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
 		allowed = 0;
 		lbs_deb_host("pending events or command responses\n");
 	}
diff -u -N -r -p kfifo2/drivers/net/wireless/libertas/main.c kfifo3/drivers/net/wireless/libertas/main.c
--- kfifo2/drivers/net/wireless/libertas/main.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/drivers/net/wireless/libertas/main.c	2009-10-19 21:13:38.000000000 +0200
@@ -772,7 +772,7 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
 			shouldsleep = 0;	/* We have a command to send */
-		else if (__kfifo_len(&priv->event_fifo))
+		else if (kfifo_len(&priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
 		else
 			shouldsleep = 1;	/* No command */
@@ -851,10 +851,10 @@ static int lbs_thread(void *data)
 
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
@@ -1579,7 +1579,7 @@ void lbs_queue_event(struct lbs_private 
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	__kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -u -N -r -p kfifo2/drivers/platform/x86/sony-laptop.c kfifo3/drivers/platform/x86/sony-laptop.c
--- kfifo2/drivers/platform/x86/sony-laptop.c	2009-10-19 20:58:34.482782781 +0200
+++ kfifo3/drivers/platform/x86/sony-laptop.c	2009-10-19 21:13:38.000000000 +0200
@@ -2107,7 +2107,7 @@ static int sonypi_misc_open(struct inode
 	spin_lock_irqsave(&sonypi_compat.fifo_lock, flags);
 
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
-		__kfifo_reset(&sonypi_compat.fifo);
+		kfifo_reset(&sonypi_compat.fifo);
 
 	spin_unlock_irqrestore(&sonypi_compat.fifo_lock, flags);
 
diff -u -N -r -p kfifo2/drivers/scsi/libiscsi.c kfifo3/drivers/scsi/libiscsi.c
--- kfifo2/drivers/scsi/libiscsi.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/drivers/scsi/libiscsi.c	2009-10-19 21:13:38.000000000 +0200
@@ -431,7 +431,7 @@ static void iscsi_free_task(struct iscsi
 	if (conn->login_task == task)
 		return;
 
-	__kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -642,7 +642,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn 
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!__kfifo_get(&session->cmdpool.queue,
+		if (!kfifo_get(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1473,7 +1473,7 @@ static inline struct iscsi_task *iscsi_a
 {
 	struct iscsi_task *task;
 
-	if (!__kfifo_get(&conn->session->cmdpool.queue,
+	if (!kfifo_get(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2260,7 +2260,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 			q->max = i;
 			goto enomem;
 		}
-		__kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2609,7 +2609,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!__kfifo_get(&session->cmdpool.queue,
+	if (!kfifo_get(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2629,7 +2629,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2692,7 +2692,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -u -N -r -p kfifo2/drivers/scsi/libiscsi_tcp.c kfifo3/drivers/scsi/libiscsi_tcp.c
--- kfifo2/drivers/scsi/libiscsi_tcp.c	2009-10-19 20:58:34.863588144 +0200
+++ kfifo3/drivers/scsi/libiscsi_tcp.c	2009-10-19 21:13:38.000000000 +0200
@@ -445,15 +445,15 @@ void iscsi_tcp_cleanup_task(struct iscsi
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
@@ -541,7 +541,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 		return 0;
 	}
 
-	rc = __kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	__kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -951,7 +951,7 @@ int iscsi_tcp_task_init(struct iscsi_tas
 		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
 
-	BUG_ON(__kfifo_len(&tcp_task->r2tqueue));
+	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
@@ -982,7 +982,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				__kfifo_put(&tcp_task->r2tpool.queue,
+				kfifo_put(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		}
 
 		if (r2t == NULL) {
-			__kfifo_get(&tcp_task->r2tqueue,
+			kfifo_get(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
diff -u -N -r -p kfifo2/drivers/scsi/libsrp.c kfifo3/drivers/scsi/libsrp.c
--- kfifo2/drivers/scsi/libsrp.c	2009-10-19 20:58:34.419253835 +0200
+++ kfifo3/drivers/scsi/libsrp.c	2009-10-19 21:13:38.943924131 +0200
@@ -61,7 +61,7 @@ static int srp_iu_pool_alloc(struct srp_
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
diff -u -N -r -p kfifo2/drivers/usb/host/fhci.h kfifo3/drivers/usb/host/fhci.h
--- kfifo2/drivers/usb/host/fhci.h	2009-10-19 20:58:34.893303070 +0200
+++ kfifo3/drivers/usb/host/fhci.h	2009-10-19 21:13:38.762150583 +0200
@@ -505,19 +505,19 @@ static inline void cq_delete(struct kfif
 
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
 
diff -u -N -r -p kfifo2/drivers/usb/serial/generic.c kfifo3/drivers/usb/serial/generic.c
--- kfifo2/drivers/usb/serial/generic.c	2009-10-19 20:58:34.197586887 +0200
+++ kfifo3/drivers/usb/serial/generic.c	2009-10-19 21:13:38.852212480 +0200
@@ -276,7 +276,7 @@ static int usb_serial_generic_write_star
 	if (port->write_urb_busy)
 		start_io = false;
 	else {
-		start_io = (__kfifo_len(port->write_fifo) != 0);
+		start_io = (kfifo_len(port->write_fifo) != 0);
 		port->write_urb_busy = start_io;
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -370,7 +370,7 @@ int usb_serial_generic_write_room(struct
 				(serial->type->max_in_flight_urbs -
 				 port->urbs_in_flight);
 	} else if (serial->num_bulk_out)
-		room = port->write_fifo->size - __kfifo_len(port->write_fifo);
+		room = port->write_fifo->size - kfifo_len(port->write_fifo);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, room);
diff -u -N -r -p kfifo2/include/linux/kfifo.h kfifo3/include/linux/kfifo.h
--- kfifo2/include/linux/kfifo.h	2009-11-19 20:53:21.526214294 +0100
+++ kfifo3/include/linux/kfifo.h	2009-11-19 20:53:37.620542297 +0100
@@ -37,34 +37,25 @@ extern void kfifo_init(struct kfifo *fif
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern unsigned int __kfifo_put(struct kfifo *fifo,
+extern unsigned int kfifo_put(struct kfifo *fifo,
 				const unsigned char *buffer, unsigned int len);
-extern unsigned int __kfifo_get(struct kfifo *fifo,
+extern unsigned int kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
 
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
 
@@ -92,7 +83,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_put(fifo, from, n);
+	ret = kfifo_put(fifo, from, n);
 
 	spin_unlock_irqrestore(lock, flags);
 
@@ -117,7 +108,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_get(fifo, to, n);
+	ret = kfifo_get(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
@@ -131,13 +122,4 @@ static inline __must_check unsigned int 
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
diff -u -N -r -p kfifo2/kernel/kfifo.c kfifo3/kernel/kfifo.c
--- kfifo2/kernel/kfifo.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/kernel/kfifo.c	2009-10-19 21:13:38.000000000 +0200
@@ -100,7 +100,7 @@ void kfifo_free(struct kfifo *fifo)
 EXPORT_SYMBOL(kfifo_free);
 
 /**
- * __kfifo_put - puts some data into the FIFO, no locking version
+ * kfifo_put - puts some data into the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @buffer: the data to be added.
  * @len: the length of the data to be added.
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(kfifo_free);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_put(struct kfifo *fifo,
+unsigned int kfifo_put(struct kfifo *fifo,
 			const unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
@@ -144,10 +144,10 @@ unsigned int __kfifo_put(struct kfifo *f
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_put);
+EXPORT_SYMBOL(kfifo_put);
 
 /**
- * __kfifo_get - gets some data from the FIFO, no locking version
+ * kfifo_get - gets some data from the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @buffer: where the data must be copied.
  * @len: the size of the destination buffer.
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(__kfifo_put);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_get(struct kfifo *fifo,
+unsigned int kfifo_get(struct kfifo *fifo,
 			 unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
@@ -190,4 +190,4 @@ unsigned int __kfifo_get(struct kfifo *f
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_get);
+EXPORT_SYMBOL(kfifo_get);
diff -u -N -r -p kfifo2/net/dccp/probe.c kfifo3/net/dccp/probe.c
--- kfifo2/net/dccp/probe.c	2009-10-19 20:58:34.000000000 +0200
+++ kfifo3/net/dccp/probe.c	2009-10-19 21:13:38.000000000 +0200
@@ -132,7 +132,7 @@ static ssize_t dccpprobe_read(struct fil
 		return -ENOMEM;
 
 	error = wait_event_interruptible(dccpw.wait,
-					 __kfifo_len(&dccpw.fifo) != 0);
+					 kfifo_len(&dccpw.fifo) != 0);
 	if (error)
 		goto out_free;
 


