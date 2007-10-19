Return-Path: <linux-kernel-owner+w=401wt.eu-S966553AbXJSH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966553AbXJSH3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXJSH3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:29:16 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59916 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXJSH3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:29:15 -0400
Date: Fri, 19 Oct 2007 03:29:14 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] parport: Consolidate code copies into a single generic
	irq handler
Message-ID: <20071019072914.GA5591@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 73ae204aa2b83cee2a9156ff72ef1da99612074e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 01:42:14 2007 -0400

    [PARPORT] Consolidate code copies into a single generic irq handler
    
    Several arches used the exact same code for their parport irq handling.
    Make that code generic, in parport_irq_handler().
    
    Also, s/__inline__/inline/ in include/linux/parport.h.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/parport/parport_amiga.c   |    9 +--------
 drivers/parport/parport_atari.c   |    9 +--------
 drivers/parport/parport_ax88796.c |   10 +---------
 drivers/parport/parport_gsc.c     |    8 +-------
 drivers/parport/parport_ip32.c    |    6 ++++--
 drivers/parport/parport_pc.c      |    9 +--------
 drivers/parport/parport_sunbpp.c  |    8 +-------
 drivers/parport/share.c           |   10 ++++++++++
 include/linux/parport.h           |    6 +++++-
 9 files changed, 25 insertions(+), 50 deletions(-)

73ae204aa2b83cee2a9156ff72ef1da99612074e
diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index a0afaee..1586e1c 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -137,13 +137,6 @@ static unsigned char amiga_read_status(struct parport *p)
 	return status;
 }
 
-/* as this ports irq handling is already done, we use a generic funktion */
-static irqreturn_t amiga_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void amiga_enable_irq(struct parport *p)
 {
 	enable_irq(IRQ_AMIGA_CIAA_FLG);
@@ -255,7 +248,7 @@ static int __init parport_amiga_init(void)
 	if (!p)
 		goto out_port;
 
-	err = request_irq(IRQ_AMIGA_CIAA_FLG, amiga_interrupt, 0, p->name, p);
+	err = request_irq(IRQ_AMIGA_CIAA_FLG, parport_irq_handler, 0, p->name, p);
 	if (err)
 		goto out_irq;
 
diff --git a/drivers/parport/parport_atari.c b/drivers/parport/parport_atari.c
index 6ea9929..ad4cdd2 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -103,13 +103,6 @@ parport_atari_restore_state(struct parport *p, struct parport_state *s)
 {
 }
 
-static irqreturn_t
-parport_atari_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void
 parport_atari_enable_irq(struct parport *p)
 {
@@ -208,7 +201,7 @@ static int __init parport_atari_init(void)
 					  &parport_atari_ops);
 		if (!p)
 			return -ENODEV;
-		if (request_irq(IRQ_MFP_BUSY, parport_atari_interrupt,
+		if (request_irq(IRQ_MFP_BUSY, parport_irq_handler,
 				IRQ_TYPE_SLOW, p->name, p)) {
 			parport_put_port (p);
 			return -ENODEV;
diff --git a/drivers/parport/parport_ax88796.c b/drivers/parport/parport_ax88796.c
index 74f4e97..4ec220b 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -232,14 +232,6 @@ parport_ax88796_restore_state(struct parport *p, struct parport_state *s)
 	writeb(s->u.ax88796.cpr, dd->spp_cpr);
 }
 
-static irqreturn_t
-parport_ax88796_interrupt(int irq, void *dev_id)
-{
-        parport_generic_irq(irq, dev_id);
-        return IRQ_HANDLED;
-}
-
-
 static struct parport_operations parport_ax88796_ops = {
 	.write_data	= parport_ax88796_write_data,
 	.read_data	= parport_ax88796_read_data,
@@ -344,7 +336,7 @@ static int parport_ax88796_probe(struct platform_device *pdev)
 
 	if (irq >= 0) {
 		/* request irq */
-		ret = request_irq(irq, parport_ax88796_interrupt,
+		ret = request_irq(irq, parport_irq_handler,
 				  IRQF_TRIGGER_FALLING, pdev->name, pp);
 
 		if (ret < 0)
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 43652ba..0e77ae2 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -80,12 +80,6 @@ static int clear_epp_timeout(struct parport *pb)
  * of these are in parport_gsc.h.
  */
 
-static irqreturn_t parport_gsc_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 void parport_gsc_init_state(struct pardevice *dev, struct parport_state *s)
 {
 	s->u.pc.ctr = 0xc | (dev->irq_func ? 0x10 : 0x0);
@@ -324,7 +318,7 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	printk("]\n");
 
 	if (p->irq != PARPORT_IRQ_NONE) {
-		if (request_irq (p->irq, parport_gsc_interrupt,
+		if (request_irq (p->irq, parport_irq_handler,
 				 0, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
diff --git a/drivers/parport/parport_ip32.c b/drivers/parport/parport_ip32.c
index ec44efd..6d58bf8 100644
--- a/drivers/parport/parport_ip32.c
+++ b/drivers/parport/parport_ip32.c
@@ -778,14 +778,16 @@ static irqreturn_t parport_ip32_interrupt(int irq, void *dev_id)
 	struct parport * const p = dev_id;
 	struct parport_ip32_private * const priv = p->physport->private_data;
 	enum parport_ip32_irq_mode irq_mode = priv->irq_mode;
+
 	switch (irq_mode) {
 	case PARPORT_IP32_IRQ_FWD:
-		parport_generic_irq(irq, p);
-		break;
+		return parport_irq_handler(irq, dev_id);
+
 	case PARPORT_IP32_IRQ_HERE:
 		parport_ip32_wakeup(p);
 		break;
 	}
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index e2be840..e9743d3 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -272,13 +272,6 @@ static int clear_epp_timeout(struct parport *pb)
  * of these are in parport_pc.h.
  */
 
-static irqreturn_t parport_pc_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	/* FIXME! Was it really ours? */
-	return IRQ_HANDLED;
-}
-
 static void parport_pc_init_state(struct pardevice *dev, struct parport_state *s)
 {
 	s->u.pc.ctr = 0xc;
@@ -2301,7 +2294,7 @@ struct parport *parport_pc_probe_port (unsigned long int base,
 		EPP_res = NULL;
 	}
 	if (p->irq != PARPORT_IRQ_NONE) {
-		if (request_irq (p->irq, parport_pc_interrupt,
+		if (request_irq (p->irq, parport_irq_handler,
 				 0, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index d27019c..9d595aa 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -46,12 +46,6 @@
 #define dprintk(x)
 #endif
 
-static irqreturn_t parport_sunbpp_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void parport_sunbpp_disable_irq(struct parport *p)
 {
 	struct bpp_regs __iomem *regs = (struct bpp_regs __iomem *)p->base;
@@ -324,7 +318,7 @@ static int __devinit init_one_port(struct sbus_dev *sdev)
 	p->size = size;
 	p->dev = &sdev->ofdev.dev;
 
-	if ((err = request_irq(p->irq, parport_sunbpp_interrupt,
+	if ((err = request_irq(p->irq, parport_irq_handler,
 			       IRQF_SHARED, p->name, p)) != 0) {
 		goto out_put_port;
 	}
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index cd66442..414c52a 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -995,6 +995,15 @@ void parport_release(struct pardevice *dev)
 	}
 }
 
+irqreturn_t parport_irq_handler(int irq, void *dev_id)
+{
+	struct parport *port = dev_id;
+
+	parport_generic_irq(irq, port);
+
+	return IRQ_HANDLED;
+}
+
 /* Exported symbols for modules. */
 
 EXPORT_SYMBOL(parport_claim);
@@ -1011,5 +1020,6 @@ EXPORT_SYMBOL(parport_get_port);
 EXPORT_SYMBOL(parport_put_port);
 EXPORT_SYMBOL(parport_find_number);
 EXPORT_SYMBOL(parport_find_base);
+EXPORT_SYMBOL(parport_irq_handler);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/parport.h b/include/linux/parport.h
index ec3f765..66026ea 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,6 +100,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/irqreturn.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/semaphore.h>
@@ -366,6 +367,9 @@ extern void parport_unregister_driver (struct parport_driver *);
 extern struct parport *parport_find_number (int);
 extern struct parport *parport_find_base (unsigned long);
 
+/* generic irq handler, if it suits your needs */
+extern irqreturn_t parport_irq_handler(int irq, void *dev_id);
+
 /* Reference counting for ports. */
 extern struct parport *parport_get_port (struct parport *);
 extern void parport_put_port (struct parport *);
@@ -514,7 +518,7 @@ extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
-static __inline__ void parport_generic_irq(int irq, struct parport *port)
+static inline void parport_generic_irq(int irq, struct parport *port)
 {
 	parport_ieee1284_interrupt (irq, port);
 	read_lock(&port->cad_lock);
