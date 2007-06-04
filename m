Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXFDQ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXFDQ1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbXFDQ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:27:46 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:59381 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756295AbXFDQ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:27:45 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@lists.osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
Date: Mon, 04 Jun 2007 18:25:28 +0200
Message-ID: <87odjvu1on.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In a few files a function such as usb_submit_urb is taking GFP_KERNEL
as an argument whereas this function call is inside a
spin_lock_irqsave region of code. Documentation says that it must be
GFP_ATOMIC instead.

Me and my colleagues have made a tool targeting program
transformations in device drivers. We have designed a scripting
language for specifying easily program transformations and a
transformation engine for performing them. In the spirit of Linux
development practice, the language is based on the patch syntax. We
call our scripts "semantic patches" because as opposed to traditional
patches, our semantic patches do not work at the line level but on a
high level representation of the C program.

FYI here is our semantic patch detecting invalid use of GFP_KERNEL and
fixing the problem:

@@
identifier fn;
@@

 spin_lock_irqsave(...)
 ... when != spin_unlock_irqrestore(...)
 fn(...,
- GFP_KERNEL
+ GFP_ATOMIC
   ,...
   )
 
And now the real patch resulting from the automated transformation:

 net/wan/lmc/lmc_main.c        |    2 +-
 scsi/megaraid/megaraid_mm.c   |    2 +-
 usb/serial/io_ti.c            |    2 +-
 usb/serial/ti_usb_3410_5052.c |    2 +-
 usb/serial/whiteheat.c        |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index ae132c1..750b3ef 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -483,7 +483,7 @@ #endif /* end ifdef _DBG_EVENTLOG */
                             break;
                     }
 
-                    data = kmalloc(xc.len, GFP_KERNEL);
+                    data = kmalloc(xc.len, GFP_ATOMIC);
                     if(data == 0x0){
                             printk(KERN_WARNING "%s: Failed to allocate memory for copy\n", dev->name);
                             ret = -ENOMEM;
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index e075a52..edee220 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -547,7 +547,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, 
 
 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
+	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_ATOMIC,
 							&kioc->buf_paddr);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 544098d..9ec38e3 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2351,7 +2351,7 @@ static int restart_read(struct edgeport_
 		urb->complete = edge_bulk_in_callback;
 		urb->context = edge_port;
 		urb->dev = edge_port->port->serial->dev;
-		status = usb_submit_urb(urb, GFP_KERNEL);
+		status = usb_submit_urb(urb, GFP_ATOMIC);
 	}
 	edge_port->ep_read_urb_state = EDGE_READ_URB_RUNNING;
 	edge_port->shadow_mcr |= MCR_RTS;
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 4203e2b..10dc36f 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1559,7 +1559,7 @@ static int ti_restart_read(struct ti_por
 		urb->complete = ti_bulk_in_callback;
 		urb->context = tport;
 		urb->dev = tport->tp_port->serial->dev;
-		status = usb_submit_urb(urb, GFP_KERNEL);
+		status = usb_submit_urb(urb, GFP_ATOMIC);
 	}
 	tport->tp_read_urb_state = TI_READ_URB_RUNNING;
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 27c5f8f..1b01207 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1116,7 +1116,7 @@ static int firm_send_command (struct usb
 	memcpy (&transfer_buffer[1], data, datasize);
 	command_port->write_urb->transfer_buffer_length = datasize + 1;
 	command_port->write_urb->dev = port->serial->dev;
-	retval = usb_submit_urb (command_port->write_urb, GFP_KERNEL);
+	retval = usb_submit_urb (command_port->write_urb, GFP_ATOMIC);
 	if (retval) {
 		dbg("%s - submit urb failed", __FUNCTION__);
 		goto exit;
@@ -1316,7 +1316,7 @@ static int start_command_port(struct usb
 		usb_clear_halt(serial->dev, command_port->read_urb->pipe);
 
 		command_port->read_urb->dev = serial->dev;
-		retval = usb_submit_urb(command_port->read_urb, GFP_KERNEL);
+		retval = usb_submit_urb(command_port->read_urb, GFP_ATOMIC);
 		if (retval) {
 			err("%s - failed submitting read urb, error %d", __FUNCTION__, retval);
 			goto exit;
@@ -1363,7 +1363,7 @@ static int start_port_read(struct usb_se
 		wrap = list_entry(tmp, struct whiteheat_urb_wrap, list);
 		urb = wrap->urb;
 		urb->dev = port->serial->dev;
-		retval = usb_submit_urb(urb, GFP_KERNEL);
+		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval) {
 			list_add(tmp, &info->rx_urbs_free);
 			list_for_each_safe(tmp, tmp2, &info->rx_urbs_submitted) {

