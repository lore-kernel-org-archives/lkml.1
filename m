Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbYDRX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbYDRX21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYDRXXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:32 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55965 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYDRXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:29 -0400
Message-Id: <a1b99cb872489214225e44e479180b6e9ccdb621.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: dtor@mail.ru
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/15] [INPUT, PCMCIA] avoid use of 'irq' function arg
Date: Fri, 18 Apr 2008 19:23:07 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: NOT FOR MERGE, NOT FOR UPSTREAM

Not-signed-off-by: ...

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

---
 drivers/input/serio/i8042.c |   23 +++++++++++++----------
 drivers/pcmcia/i82365.c     |   15 ++++++++++-----
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 65a74cf..ee2dfab 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -108,8 +108,6 @@ static unsigned char i8042_aux_irq_registered;
 static unsigned char i8042_suppress_kbd_ack;
 static struct platform_device *i8042_platform_device;
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id);
-
 /*
  * The i8042_wait_read() and i8042_wait_write functions wait for the i8042 to
  * be ready for reading values from it / writing values to it.
@@ -302,7 +300,7 @@ static void i8042_stop(struct serio *serio)
  * to the upper layers.
  */
 
-static irqreturn_t i8042_interrupt(int irq, void *dev_id)
+static irqreturn_t __i8042_interrupt(bool polled)
 {
 	struct i8042_port *port;
 	unsigned long flags;
@@ -315,7 +313,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 	str = i8042_read_status();
 	if (unlikely(~str & I8042_STR_OBF)) {
 		spin_unlock_irqrestore(&i8042_lock, flags);
-		if (irq) dbg("Interrupt %d, without any data", irq);
+		if (!polled) dbg("Interrupt without any data");
 		ret = 0;
 		goto out;
 	}
@@ -370,8 +368,8 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
 
 	port = &i8042_ports[port_no];
 
-	dbg("%02x <- i8042 (interrupt, %d, %d%s%s)",
-	    data, port_no, irq,
+	dbg("%02x <- i8042 (interrupt, %d, %s%s)",
+	    data, port_no,
 	    dfl & SERIO_PARITY ? ", bad parity" : "",
 	    dfl & SERIO_TIMEOUT ? ", timeout" : "");
 
@@ -389,6 +387,11 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
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
@@ -650,7 +653,7 @@ static int __devinit i8042_check_aux(void)
 	}
 
 	if (request_irq(I8042_AUX_IRQ, i8042_aux_test_irq, IRQF_SHARED,
-			"i8042", i8042_platform_device))
+			"i8042", NULL))
 		goto out;
 
 	irq_registered = 1;
@@ -953,7 +956,7 @@ static int i8042_resume(struct platform_device *dev)
 	if (i8042_ports[I8042_KBD_PORT_NO].serio)
 		i8042_enable_kbd_port();
 
-	i8042_interrupt(0, NULL);
+	__i8042_interrupt(true);
 
 	dev->dev.power.power_state = PMSG_ON;
 
@@ -1104,7 +1107,7 @@ static int __devinit i8042_setup_aux(void)
 	}
 
 	error = request_irq(I8042_AUX_IRQ, i8042_interrupt, IRQF_SHARED,
-			    "i8042", i8042_platform_device);
+			    "i8042", NULL);
 	if (error)
 		goto err_free_ports;
 
@@ -1130,7 +1133,7 @@ static int __devinit i8042_setup_kbd(void)
 		return error;
 
 	error = request_irq(I8042_KBD_IRQ, i8042_interrupt, IRQF_SHARED,
-			    "i8042", i8042_platform_device);
+			    "i8042", NULL);
 	if (error)
 		goto err_free_port;
 
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 32a2ab1..ce9364b 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -82,7 +82,8 @@ module_param(pc_debug, int, 0644);
 static irqreturn_t i365_count_irq(int, void *);
 static inline int _check_irq(int irq, int flags)
 {
-    if (request_irq(irq, i365_count_irq, flags, "x", i365_count_irq) != 0)
+    if (request_irq(irq, i365_count_irq, flags, "x",
+    		    (void *)(unsigned long) irq) != 0)
 	return -1;
     free_irq(irq, i365_count_irq);
     return 0;
@@ -497,8 +498,10 @@ static u_int __init set_bridge_opts(u_short s, u_short ns)
 static volatile u_int irq_hits;
 static u_short irq_sock;
 
-static irqreturn_t i365_count_irq(int irq, void *dev)
+static irqreturn_t i365_count_irq(int dummy, void *dev_id)
 {
+    int irq = (int)(unsigned long) dev_id;
+
     i365_get(irq_sock, I365_CSC);
     irq_hits++;
     debug(2, "-> hit on irq %d\n", irq);
@@ -509,7 +512,7 @@ static u_int __init test_irq(u_short sock, int irq)
 {
     debug(2, "  testing ISA irq %d\n", irq);
     if (request_irq(irq, i365_count_irq, IRQF_PROBE_SHARED, "scan",
-			i365_count_irq) != 0)
+		    (void *)(unsigned long) irq) != 0)
 	return 1;
     irq_hits = 0; irq_sock = sock;
     msleep(10);
@@ -847,8 +850,9 @@ static void __init isa_probe(void)
 
 /*====================================================================*/
 
-static irqreturn_t pcic_interrupt(int irq, void *dev)
+static irqreturn_t pcic_interrupt(int dummy, void *dev_id)
 {
+    int irq = (int)(unsigned long) dev_id;
     int i, j, csc;
     u_int events, active;
     u_long flags = 0;
@@ -1293,7 +1297,8 @@ static int __init init_i82365(void)
 
     /* Set up interrupt handler(s) */
     if (grab_irq != 0)
-	request_irq(cs_irq, pcic_interrupt, 0, "i82365", pcic_interrupt);
+	request_irq(cs_irq, pcic_interrupt, 0, "i82365",
+		    (void *)(unsigned long) cs_irq);
     
     /* register sockets with the pcmcia core */
     for (i = 0; i < sockets; i++) {
-- 
1.5.4.1

