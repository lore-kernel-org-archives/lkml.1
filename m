Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXJSHa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXJSHa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbXJSHaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:30:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49727 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbXJSHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:30:12 -0400
Date: Fri, 19 Oct 2007 03:30:10 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] parport: Kill useless 'irq' arg from
	parport_{generic_irq,ieee1284_interrupt
Message-ID: <20071019073010.GA5611@havoc.gtf.org>
References: <20071019072914.GA5591@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019072914.GA5591@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 69a4a1aad140a3d9e17d3e313a3633445a7934fe
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 01:56:02 2007 -0400

    [PARPORT] Kill useless 'irq' arg from parport_{generic_irq,ieee1284_interrupt}
    
    parport_ieee1284_interrupt() was not using its first arg at all.
    Delete.
    
    parport_generic_irq()'s second arg makes its first arg completely
    redundant.  Delete, and use port->irq in the one place where we actually
    need it.
    
    Also, s/__inline__/inline/ to make the code look nicer.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/parport/ieee1284.c     |    2 +-
 drivers/parport/parport_mfc3.c |    2 +-
 drivers/parport/share.c        |    2 +-
 drivers/usb/misc/uss720.c      |    4 ++--
 include/linux/parport.h        |    8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

69a4a1aad140a3d9e17d3e313a3633445a7934fe
diff --git a/drivers/parport/ieee1284.c b/drivers/parport/ieee1284.c
index 5accaa7..54a6ef7 100644
--- a/drivers/parport/ieee1284.c
+++ b/drivers/parport/ieee1284.c
@@ -571,7 +571,7 @@ static int parport_ieee1284_ack_data_avail (struct parport *port)
 #endif /* IEEE1284 support */
 
 /* Handle an interrupt. */
-void parport_ieee1284_interrupt (int which, void *handle)
+void parport_ieee1284_interrupt (void *handle)
 {
 	struct parport *port = handle;
 	parport_ieee1284_wakeup (port);
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 77726fc..6dec9ba 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -219,7 +219,7 @@ static irqreturn_t mfc3_interrupt(int irq, void *dev_id)
 		if (this_port[i] != NULL)
 			if (pia(this_port[i])->crb & 128) { /* Board caused interrupt */
 				dummy = pia(this_port[i])->pprb; /* clear irq bit */
-				parport_generic_irq(irq, this_port[i]);
+				parport_generic_irq(this_port[i]);
 			}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index 414c52a..d0b353c 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -999,7 +999,7 @@ irqreturn_t parport_irq_handler(int irq, void *dev_id)
 {
 	struct parport *port = dev_id;
 
-	parport_generic_irq(irq, port);
+	parport_generic_irq(port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 2734fe2..f1255b0 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -128,7 +128,7 @@ static void async_complete(struct urb *urb)
 #endif
 		/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 		if (rq->reg[2] & rq->reg[1] & 0x10 && pp)
-			parport_generic_irq(0, pp);
+			parport_generic_irq(pp);
 	}
 	complete(&rq->compl);
 	kref_put(&rq->ref_count, destroy_async);
@@ -337,7 +337,7 @@ static int uss720_irq(int usbstatus, void *buffer, int len, void *dev_id)
 	memcpy(priv->reg, buffer, 4);
 	/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 	if (priv->reg[2] & priv->reg[1] & 0x10)
-		parport_generic_irq(0, pp);
+		parport_generic_irq(pp);
 	return 1;
 }
 #endif
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 66026ea..557c37d 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -465,7 +465,7 @@ static __inline__ int parport_yield_blocking(struct pardevice *dev)
 #define PARPORT_FLAG_EXCL		(1<<1)	/* EXCL driver registered. */
 
 /* IEEE1284 functions */
-extern void parport_ieee1284_interrupt (int, void *);
+extern void parport_ieee1284_interrupt (void *);
 extern int parport_negotiate (struct parport *, int mode);
 extern ssize_t parport_write (struct parport *, const void *buf, size_t len);
 extern ssize_t parport_read (struct parport *, void *buf, size_t len);
@@ -518,12 +518,12 @@ extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
-static inline void parport_generic_irq(int irq, struct parport *port)
+static inline void parport_generic_irq(struct parport *port)
 {
-	parport_ieee1284_interrupt (irq, port);
+	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
-		port->cad->irq_func(irq, port->cad->private);
+		port->cad->irq_func(port->irq, port->cad->private);
 	read_unlock(&port->cad_lock);
 }
 
