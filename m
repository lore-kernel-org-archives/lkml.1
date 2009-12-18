Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbZLRIMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbZLRIMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZLRIMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:12:45 -0500
Received: from www84.your-server.de ([213.133.104.84]:38447 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZLRIMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:12:44 -0500
Subject: [patch] media video cx23888 driver: ported to new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Dec 2009 09:12:34 +0100
Message-ID: <1261123954.13116.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will fix the cx23888 driver to use the new kfifo API.

The patch-set is against current mm tree from 11-Dec-2009

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 cx23888-ir.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

--- mmotm.orig/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 08:42:53.936778002 +0100
+++ mmotm/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 09:03:04.808703259 +0100
@@ -124,15 +124,12 @@ struct cx23888_ir_state {
 	atomic_t rxclk_divider;
 	atomic_t rx_invert;
 
-	struct kfifo *rx_kfifo;
+	struct kfifo rx_kfifo;
 	spinlock_t rx_kfifo_lock;
 
 	struct v4l2_subdev_ir_parameters tx_params;
 	struct mutex tx_params_lock;
 	atomic_t txclk_divider;
-
-	struct kfifo *tx_kfifo;
-	spinlock_t tx_kfifo_lock;
 };
 
 static inline struct cx23888_ir_state *to_state(struct v4l2_subdev *sd)
@@ -594,8 +591,9 @@ static int cx23888_ir_irq_handler(struct
 			if (i == 0)
 				break;
 			j = i * sizeof(u32);
-			k = kfifo_put(state->rx_kfifo,
-				      (unsigned char *) rx_data, j);
+			k = kfifo_in_locked(&state->rx_kfifo,
+				      (unsigned char *) rx_data, j,
+				      &state->rx_kfifo_lock);
 			if (k != j)
 				kror++; /* rx_kfifo over run */
 		}
@@ -631,7 +629,7 @@ static int cx23888_ir_irq_handler(struct
 		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
 		*handled = true;
 	}
-	if (kfifo_len(state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
+	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
 		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
 
 	if (events)
@@ -657,7 +655,7 @@ static int cx23888_ir_rx_read(struct v4l
 		return 0;
 	}
 
-	n = kfifo_get(state->rx_kfifo, buf, n);
+	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
 
 	n /= sizeof(u32);
 	*num = n * sizeof(u32);
@@ -785,7 +783,7 @@ static int cx23888_ir_rx_s_parameters(st
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
-		kfifo_reset(state->rx_kfifo);
+		kfifo_reset(&state->rx_kfifo);
 		if (p->interrupt_enable)
 			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
 		control_rx_enable(dev, p->enable);
@@ -892,7 +890,6 @@ static int cx23888_ir_tx_s_parameters(st
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
-		kfifo_reset(state->tx_kfifo);
 		if (p->interrupt_enable)
 			irqenable_tx(dev, IRQEN_TSE);
 		control_tx_enable(dev, p->enable);
@@ -1168,19 +1165,9 @@ int cx23888_ir_probe(struct cx23885_dev 
 		return -ENOMEM;
 
 	spin_lock_init(&state->rx_kfifo_lock);
-	state->rx_kfifo = kfifo_alloc(CX23888_IR_RX_KFIFO_SIZE, GFP_KERNEL,
-				      &state->rx_kfifo_lock);
-	if (state->rx_kfifo == NULL)
+	if (kfifo_alloc(&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE, GFP_KERNEL))
 		return -ENOMEM;
 
-	spin_lock_init(&state->tx_kfifo_lock);
-	state->tx_kfifo = kfifo_alloc(CX23888_IR_TX_KFIFO_SIZE, GFP_KERNEL,
-				      &state->tx_kfifo_lock);
-	if (state->tx_kfifo == NULL) {
-		kfifo_free(state->rx_kfifo);
-		return -ENOMEM;
-	}
-
 	state->dev = dev;
 	state->id = V4L2_IDENT_CX23888_IR;
 	state->rev = 0;
@@ -1211,8 +1198,7 @@ int cx23888_ir_probe(struct cx23885_dev 
 		       sizeof(struct v4l2_subdev_ir_parameters));
 		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
 	} else {
-		kfifo_free(state->rx_kfifo);
-		kfifo_free(state->tx_kfifo);
+		kfifo_free(&state->rx_kfifo);
 	}
 	return ret;
 }
@@ -1231,8 +1217,7 @@ int cx23888_ir_remove(struct cx23885_dev
 
 	state = to_state(sd);
 	v4l2_device_unregister_subdev(sd);
-	kfifo_free(state->rx_kfifo);
-	kfifo_free(state->tx_kfifo);
+	kfifo_free(&state->rx_kfifo);
 	kfree(state);
 	/* Nothing more to free() as state held the actual v4l2_subdev object */
 	return 0;


