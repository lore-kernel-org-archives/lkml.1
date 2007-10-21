Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXJUHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXJUHz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXJUHwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35359 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbXJUHwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:38 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: dtor@mail.ru
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 10/17] drivers/input/serio/i8042.c: irq handler clean
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075237.EC51B19041D@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:37 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit bdf311215ef8dbae0254c092deaed1d5928b013e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:28:54 2007 -0400

    drivers/input/serio/i8042.c: irq handler clean
    
    * remove unnecessary prototype
    
    * distinguish between polled and irq-driven event handling
    
    * don't bother worrying about 'irq' function arg
    
    * dev_id passed to irq handlers is unused, to change the request_irq()
      argument to NULL
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/input/serio/i8042.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

bdf311215ef8dbae0254c092deaed1d5928b013e
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 11dafc0..51c57f0 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -102,8 +102,6 @@ static unsigned char i8042_aux_irq_registered;
 static unsigned char i8042_suppress_kbd_ack;
 static struct platform_device *i8042_platform_device;
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id);
-
 /*
  * The i8042_wait_read() and i8042_wait_write functions wait for the i8042 to
  * be ready for reading values from it / writing values to it.
@@ -288,7 +286,7 @@ static void i8042_stop(struct serio *serio)
  * to the upper layers.
  */
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id)
+static irqreturn_t __i8042_interrupt(bool polled)
 {
 	struct i8042_port *port;
 	unsigned long flags;
@@ -301,7 +299,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	str = i8042_read_status();
 	if (unlikely(~str & I8042_STR_OBF)) {
 		spin_unlock_irqrestore(&i8042_lock, flags);
-		if (irq) dbg("Interrupt %d, without any data", irq);
+		if (!polled) dbg("Interrupt without any data");
 		ret = 0;
 		goto out;
 	}
@@ -356,8 +354,8 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 
 	port = &i8042_ports[port_no];
 
-	dbg("%02x <- i8042 (interrupt, %d, %d%s%s)",
-	    data, port_no, irq,
+	dbg("%02x <- i8042 (interrupt, %d, %s%s)",
+	    data, port_no,
 	    dfl & SERIO_PARITY ? ", bad parity" : "",
 	    dfl & SERIO_TIMEOUT ? ", timeout" : "");
 
@@ -375,6 +373,11 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	return IRQ_RETVAL(ret);
 }
 
+static irqreturn_t i8042_interrupt(int dummy, void *dev_id)
+{
+	return __i8042_interrupt(false);
+}
+
 /*
  * i8042_enable_kbd_port enables keybaord port on chip
  */
@@ -636,7 +639,7 @@ static int __devinit i8042_check_aux(void)
 	}
 
 	if (request_irq(I8042_AUX_IRQ, i8042_aux_test_irq, IRQF_SHARED,
-			"i8042", i8042_platform_device))
+			"i8042", NULL))
 		goto out;
 
 	irq_registered = 1;
@@ -939,7 +942,7 @@ static int i8042_resume(struct platform_device *dev)
 	if (i8042_ports[I8042_KBD_PORT_NO].serio)
 		i8042_enable_kbd_port();
 
-	i8042_interrupt(0, NULL);
+	__i8042_interrupt(true);
 
 	dev->dev.power.power_state = PMSG_ON;
 
@@ -1090,7 +1093,7 @@ static int __devinit i8042_setup_aux(void)
 	}
 
 	error = request_irq(I8042_AUX_IRQ, i8042_interrupt, IRQF_SHARED,
-			    "i8042", i8042_platform_device);
+			    "i8042", NULL);
 	if (error)
 		goto err_free_ports;
 
@@ -1116,7 +1119,7 @@ static int __devinit i8042_setup_kbd(void)
 		return error;
 
 	error = request_irq(I8042_KBD_IRQ, i8042_interrupt, IRQF_SHARED,
-			    "i8042", i8042_platform_device);
+			    "i8042", NULL);
 	if (error)
 		goto err_free_port;
 
