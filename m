Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXHYWWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXHYWWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHYWV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:21:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:59577 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753205AbXHYWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:21:57 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX194FdZWfp94NX3zmIyJSckYq1g/5LZHxTmxHPcwDq
	22i6Hv7nNzV2Vk
Date: Sun, 26 Aug 2007 00:22:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-pm@lists.linux-foundation.org
Subject: [PATCH, RFC] wake up from a serial port
Message-ID: <Pine.LNX.4.60.0708260010250.3809@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable wakeup from serial ports, make it run-time configurable over sysfs, 
e.g.,

echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup

Requires

# CONFIG_SYSFS_DEPRECATED is not set

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

I've sent this rfc/patch earlier to linuxppc-dev (I need it for a ppc 
platform) and to linux-serial, and got no comments - but no objections 
either from either of them. So, re-sending to a broader and hopefully more 
relevant audience this time.

Thanks
Guennadi

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 0b3ec38..5118914 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -130,6 +130,7 @@ struct uart_8250_port {
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
 	unsigned char		lsr_break_flag;
+	char			suspended;
 
 	/*
 	 * We provide a per-port pm hook.
@@ -2673,6 +2674,14 @@ static int __devexit serial8250_remove(struct platform_device *dev)
 	return 0;
 }
 
+static int serial8250_match_port(struct device *dev, void *data)
+{
+	struct uart_port *port = data;
+	dev_t devt = MKDEV(serial8250_reg.major, serial8250_reg.minor) + port->line;
+
+	return dev->devt == devt; /* Actually, only one tty per port */
+}
+
 static int serial8250_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
@@ -2680,8 +2689,16 @@ static int serial8250_suspend(struct platform_device *dev, pm_message_t state)
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			uart_suspend_port(&serial8250_reg, &up->port);
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev) {
+			struct device *tty_dev = device_find_child(up->port.dev, &up->port,
+								   serial8250_match_port);
+			if (device_may_wakeup(tty_dev))
+				enable_irq_wake(up->port.irq);
+			else {
+				uart_suspend_port(&serial8250_reg, &up->port);
+				up->suspended = 1;
+			}
+		}
 	}
 
 	return 0;
@@ -2694,8 +2711,13 @@ static int serial8250_resume(struct platform_device *dev)
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			serial8250_resume_port(i);
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev) {
+			if (up->suspended) {
+				serial8250_resume_port(i);
+				up->suspended = 0;
+			} else
+				disable_irq_wake(up->port.irq);
+		}
 	}
 
 	return 0;
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 9c57486..716fbe2 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2266,6 +2266,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct uart_state *state;
 	int ret = 0;
+	struct device *tty_dev;
 
 	BUG_ON(in_interrupt());
 
@@ -2301,7 +2302,13 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this ports parameters.
 	 */
-	tty_register_device(drv->tty_driver, port->line, port->dev);
+	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
+	if (likely(!IS_ERR(tty_dev))) {
+		device_can_wakeup(tty_dev) = 1;
+		device_set_wakeup_enable(tty_dev, 0);
+	} else
+		printk(KERN_ERR "Cannot register tty device on line %d\n",
+		       port->line);
 
 	/*
 	 * If this driver supports console, and it hasn't been
