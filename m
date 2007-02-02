Return-Path: <linux-kernel-owner+w=401wt.eu-S1422699AbXBBJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422699AbXBBJPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXBBJPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:15:20 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXBBJPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:15:18 -0500
Date: Fri, 2 Feb 2007 11:15:15 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: lirc@bartelmus.de
cc: linux-kernel@vger.kernel.org
Subject: lirc: igorplususb error handling cleanup
Message-ID: <Pine.LNX.4.64.0702021113160.22862@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Use goto instead of a big ugly switch for error handling. Convert some 
kmalloc + memset pairs to kzalloc too.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/lirc_igorplugusb/lirc_igorplugusb.c |  116 +++++++++++++---------------
 1 file changed, 54 insertions(+), 62 deletions(-)

Index: lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_igorplugusb/lirc_igorplugusb.c
+++ lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
@@ -405,7 +405,7 @@ static int usb_remote_probe(struct usb_i
 	int minor = 0;
 	char buf[63], name[128]="";
 	int mem_failure = 0;
-	int ret;
+	int ret, err;
 
 	dprintk(DRIVER_NAME ": usb probe called.\n");
 
@@ -430,67 +430,44 @@ static int usb_remote_probe(struct usb_i
 		devnum, bytes_in_key, maxp);
 
 
-	/* allocate kernel memory */
-	mem_failure = 0;
-	if (!(ir = kmalloc(sizeof(struct irctl), GFP_KERNEL))) {
-		mem_failure = 1;
-	} else {
-		memset(ir, 0, sizeof(struct irctl));
-
-		if (!(plugin = kmalloc(sizeof(struct lirc_plugin), GFP_KERNEL))) {
-			mem_failure = 2;
-		} else if (!(rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL))) {
-			mem_failure = 3;
-		} else if (lirc_buffer_init(rbuf, bytes_in_key, 
-                		DEVICE_BUFLEN+ADDITIONAL_LIRC_BYTES)) {
-			mem_failure = 4;
-		} else if (!(ir->buf_in = usb_buffer_alloc(dev, 
-				DEVICE_BUFLEN+DEVICE_HEADERLEN, 
-                                GFP_ATOMIC, &ir->dma_in))) {
-			mem_failure = 5;
-		} else {
-
-			memset(plugin, 0, sizeof(struct lirc_plugin));
-
-			strcpy(plugin->name, DRIVER_NAME " ");
-			plugin->minor = -1;
-			plugin->code_length = bytes_in_key*8; /* in bits */
-			plugin->features = LIRC_CAN_REC_MODE2;
-			plugin->data = ir;
-			plugin->rbuf = rbuf;
-			plugin->set_use_inc = &set_use_inc;
-			plugin->set_use_dec = &set_use_dec;
-			plugin->sample_rate = SAMPLE_RATE;    /* per second */
-			plugin->add_to_buf = &usb_remote_poll;
-			plugin->owner = THIS_MODULE;
-
-			init_MUTEX(&ir->lock);
-			init_waitqueue_head(&ir->wait_out);
-
-			if ((minor = lirc_register_plugin(plugin)) < 0) {
-				mem_failure = 9;
-			}
-		}
-	}
-
-	/* free allocated memory in case of failure */
-	switch (mem_failure) {
-	case 9:
-		usb_buffer_free(dev, DEVICE_BUFLEN+DEVICE_HEADERLEN, 
-                	ir->buf_in, ir->dma_in);
-	case 5:
-		lirc_buffer_free(rbuf);
-	case 4:
-		kfree(rbuf);
-	case 3:
-		kfree(plugin);
-	case 2:
-		kfree(ir);
-	case 1:
-		printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n",
-			devnum, mem_failure);
-		return -ENOMEM;
-	}
+	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
+	if (!ir)
+		goto failed_ctl_alloc;
+
+	plugin = kzalloc(sizeof(struct lirc_plugin), GFP_KERNEL);
+	if (!plugin)
+		goto failed_plugin_alloc;
+	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+	if (!rbuf)
+		goto failed_rbuf_alloc;
+
+	err = lirc_buffer_init(rbuf, bytes_in_key, DEVICE_BUFLEN +
+			       ADDITIONAL_LIRC_BYTES);
+	if (err)
+		goto failed_buffer_init;
+
+	ir->buf_in = usb_buffer_alloc(dev, DEVICE_BUFLEN+DEVICE_HEADERLEN, GFP_ATOMIC, &ir->dma_in);
+	if (!ir->buf_in)
+		goto failed_buf_in_alloc;
+
+	strcpy(plugin->name, DRIVER_NAME " ");
+	plugin->minor = -1;
+	plugin->code_length = bytes_in_key*8; /* in bits */
+	plugin->features = LIRC_CAN_REC_MODE2;
+	plugin->data = ir;
+	plugin->rbuf = rbuf;
+	plugin->set_use_inc = &set_use_inc;
+	plugin->set_use_dec = &set_use_dec;
+	plugin->sample_rate = SAMPLE_RATE;    /* per second */
+	plugin->add_to_buf = &usb_remote_poll;
+	plugin->owner = THIS_MODULE;
+
+	init_MUTEX(&ir->lock);
+	init_waitqueue_head(&ir->wait_out);
+
+	minor = lirc_register_plugin(plugin);
+	if (minor < 0)
+		goto failed_register;
 
 	plugin->minor = minor;
 	ir->p = plugin;
@@ -522,6 +499,21 @@ static int usb_remote_probe(struct usb_i
 
 	usb_set_intfdata(intf, ir);
 	return SUCCESS;
+
+  failed_register:
+	usb_buffer_free(dev, DEVICE_BUFLEN+DEVICE_HEADERLEN, ir->buf_in,
+			ir->dma_in);
+  failed_buf_in_alloc:
+	lirc_buffer_free(rbuf);
+  failed_buffer_init:
+	kfree(rbuf);
+  failed_rbuf_alloc:
+	kfree(plugin);
+  failed_plugin_alloc:
+	kfree(ir);
+  failed_ctl_alloc:
+	printk(DRIVER_NAME "[%d]: out of memory (code=%d)\n", devnum, mem_failure);
+	return -ENOMEM;
 }
 
 
