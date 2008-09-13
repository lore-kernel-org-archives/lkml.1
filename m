Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYIMEUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYIMEUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYIMEUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:20:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34991
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYIMEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:20:19 -0400
Date: Fri, 12 Sep 2008 21:20:13 -0700 (PDT)
Message-Id: <20080912.212013.205659677.davem@davemloft.net>
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: [NONSERIOUS PATCH]: Change Sun serial major/minor numbers...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Resending, my first send trigger'd vger filters ]

This is the non-serious patch I mentioned in my first posting
which changes all of the major/minor numbers used by the Sun
serial drivers in order to get out of the way of 8250's
major/minor namespace.

Again, this patch isn't meant to be taken seriously at all.
I'm not even willing to sign off on it :-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 05c8064..0d1b1f9 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2807,6 +2807,15 @@ Your cooperation is appreciated.
 		    ...
 		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
 		 191 = /dev/xvc0		Xen virtual console - port 0
+		 192 = /dev/ttySZ0		Sun Zilog - port 0
+		    ...
+		 207 = /dev/ttySZ15		Sun Zilog - port 15
+		 208 = /dev/ttySU0		Sun SU - port 0
+		    ...
+		 215 = /dev/ttySU7		Sun SU - port 7
+		 216 = /dev/ttySB0		Sun SAB82532 - port 0
+		 217 = /dev/ttySB1		Sun SAB82532 - port 1
+		 218 = /dev/ttyHV0		Sun Hypervisor console - port 0
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index a94a2ab..9858b76 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -32,6 +32,11 @@
 
 #include "suncore.h"
 
+#define SUNHV_MAJOR	204
+#define SUNHV_MINOR	218
+#define SUNHV_NR	1
+#define SUNHV_NAME	"ttyHV"
+
 #define CON_BREAK	((long)-1)
 #define CON_HUP		((long)-2)
 
@@ -393,8 +398,10 @@ static struct uart_ops sunhv_pops = {
 static struct uart_driver sunhv_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "sunhv",
-	.dev_name		= "ttyS",
-	.major			= TTY_MAJOR,
+	.dev_name		= SUNHV_NAME,
+	.major			= SUNHV_MAJOR,
+	.minor			= SUNHV_MINOR,
+	.nr			= SUNHV_NR,
 };
 
 static struct uart_port *sunhv_port;
@@ -561,7 +568,7 @@ static int __devinit hv_probe(struct of_device *op, const struct of_device_id *m
 
 	port->dev = &op->dev;
 
-	err = sunserial_register_minors(&sunhv_reg, 1);
+	err = uart_register_driver(&sunhv_reg);
 	if (err)
 		goto out_free_con_read_page;
 
@@ -584,7 +591,7 @@ out_remove_port:
 	uart_remove_one_port(&sunhv_reg, port);
 
 out_unregister_driver:
-	sunserial_unregister_minors(&sunhv_reg, 1);
+	uart_unregister_driver(&sunhv_reg);
 
 out_free_con_read_page:
 	kfree(con_read_page);
@@ -606,7 +613,7 @@ static int __devexit hv_remove(struct of_device *dev)
 
 	uart_remove_one_port(&sunhv_reg, port);
 
-	sunserial_unregister_minors(&sunhv_reg, 1);
+	uart_unregister_driver(&sunhv_reg);
 
 	kfree(port);
 	sunhv_port = NULL;
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index 0355efe..924c059 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -47,6 +47,11 @@
 #include "suncore.h"
 #include "sunsab.h"
 
+#define SUNSAB_MAJOR		204
+#define SUNSAB_MINOR		216
+#define SUNSAB_NR		2
+#define SUNSAB_NAME		"ttySB"
+
 struct uart_sunsab_port {
 	struct uart_port		port;		/* Generic UART port	*/
 	union sab82532_async_regs	__iomem *regs;	/* Chip registers	*/
@@ -827,8 +832,10 @@ static struct uart_ops sunsab_pops = {
 static struct uart_driver sunsab_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "sunsab",
-	.dev_name		= "ttyS",
-	.major			= TTY_MAJOR,
+	.dev_name		= SUNSAB_NAME,
+	.major			= SUNSAB_MAJOR,
+	.minor			= SUNSAB_MINOR,
+	.nr			= SUNSAB_NR,
 };
 
 static struct uart_sunsab_port *sunsab_ports;
@@ -880,8 +887,8 @@ static int sunsab_console_setup(struct console *con, char *options)
 	if (up->port.type != PORT_SUNSAB)
 		return -1;
 
-	printk("Console: ttyS%d (SAB82532)\n",
-	       (sunsab_reg.minor - 64) + con->index);
+	printk("Console: ttySB%d (SAB82532)\n",
+	       (sunsab_reg.minor - SUNSAB_MINOR) + con->index);
 
 	sunserial_console_termios(con);
 
@@ -935,7 +942,7 @@ static int sunsab_console_setup(struct console *con, char *options)
 }
 
 static struct console sunsab_console = {
-	.name	=	"ttyS",
+	.name	=	SUNSAB_NAME,
 	.write	=	sunsab_console_write,
 	.device	=	uart_console_device,
 	.setup	=	sunsab_console_setup,
@@ -1110,31 +1117,31 @@ static int __init sunsab_init(void)
 			num_channels += 2;
 	}
 
+	err = uart_register_driver(&sunsab_reg);
+	if (err)
+		return err;
+
 	if (num_channels) {
 		sunsab_ports = kzalloc(sizeof(struct uart_sunsab_port) *
 				       num_channels, GFP_KERNEL);
-		if (!sunsab_ports)
+		if (!sunsab_ports) {
+			uart_unregister_driver(&sunsab_reg);
 			return -ENOMEM;
-
-		sunsab_reg.cons = SUNSAB_CONSOLE();
-		err = sunserial_register_minors(&sunsab_reg, num_channels);
-		if (err) {
-			kfree(sunsab_ports);
-			sunsab_ports = NULL;
-
-			return err;
 		}
 	}
 
-	return of_register_driver(&sab_driver, &of_bus_type);
+	err = of_register_driver(&sab_driver, &of_bus_type);
+	if (err) {
+		kfree(sunsab_ports);
+		uart_unregister_driver(&sunsab_reg);
+	}
+	return err;
 }
 
 static void __exit sunsab_exit(void)
 {
 	of_unregister_driver(&sab_driver);
-	if (sunsab_reg.nr) {
-		sunserial_unregister_minors(&sunsab_reg, sunsab_reg.nr);
-	}
+	sunserial_unregister_minors(&sunsab_reg, sunsab_reg.nr);
 
 	kfree(sunsab_ports);
 	sunsab_ports = NULL;
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index a4dc79b..68b21b8 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -49,6 +49,11 @@
 
 #include "suncore.h"
 
+#define SUNSU_MAJOR		204
+#define SUNSU_MINOR		208
+#define SUNSU_NR		4
+#define SUNSU_NAME		"ttySU"
+
 /* We are on a NS PC87303 clocked with 24.0 MHz, which results
  * in a UART clock of 1.8462 MHz.
  */
@@ -1174,8 +1179,10 @@ out:
 static struct uart_driver sunsu_reg = {
 	.owner			= THIS_MODULE,
 	.driver_name		= "sunsu",
-	.dev_name		= "ttyS",
-	.major			= TTY_MAJOR,
+	.dev_name		= SUNSU_NAME,
+	.major			= SUNSU_MAJOR,
+	.minor			= SUNSU_MINOR,
+	.nr			= SUNSU_NR,
 };
 
 static int __init sunsu_kbd_ms_init(struct uart_sunsu_port *up)
@@ -1335,8 +1342,8 @@ static int __init sunsu_console_setup(struct console *co, char *options)
 	int parity = 'n';
 	int flow = 'n';
 
-	printk("Console: ttyS%d (SU)\n",
-	       (sunsu_reg.minor - 64) + co->index);
+	printk("Console: ttySU%d (SU)\n",
+	       (sunsu_reg.minor - SUNSU_MINOR) + co->index);
 
 	/*
 	 * Check whether an invalid uart number has been specified, and
@@ -1359,7 +1366,7 @@ static int __init sunsu_console_setup(struct console *co, char *options)
 }
 
 static struct console sunsu_console = {
-	.name	=	"ttyS",
+	.name	=	SUNSU_NAME,
 	.write	=	sunsu_console_write,
 	.device	=	uart_console_device,
 	.setup	=	sunsu_console_setup,
@@ -1549,23 +1556,20 @@ static int __init sunsu_init(void)
 		}
 	}
 
-	if (num_uart) {
-		err = sunserial_register_minors(&sunsu_reg, num_uart);
-		if (err)
-			return err;
-	}
+	err = uart_register_driver(&sunsu_reg);
+	if (err)
+		return err;
 
 	err = of_register_driver(&su_driver, &of_bus_type);
-	if (err && num_uart)
-		sunserial_unregister_minors(&sunsu_reg, num_uart);
+	if (err)
+		uart_unregister_driver(&sunsu_reg);
 
 	return err;
 }
 
 static void __exit sunsu_exit(void)
 {
-	if (sunsu_reg.nr)
-		sunserial_unregister_minors(&sunsu_reg, sunsu_reg.nr);
+	uart_unregister_driver(&sunsu_reg);
 }
 
 module_init(sunsu_init);
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 45a299f..edb70dc 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -47,6 +47,11 @@
 #include "suncore.h"
 #include "sunzilog.h"
 
+#define SUNZILOG_MAJOR		204
+#define SUNZILOG_MINOR		192
+#define SUNZILOG_NR		16
+#define SUNZILOG_NAME		"ttySZ"
+
 /* On 32-bit sparcs we need to delay after register accesses
  * to accommodate sun4 systems, but we do not need to flush writes.
  * On 64-bit sparc we only need to flush single writes to ensure
@@ -1024,8 +1029,10 @@ static struct uart_sunzilog_port *sunzilog_irq_chain;
 static struct uart_driver sunzilog_reg = {
 	.owner		=	THIS_MODULE,
 	.driver_name	=	"sunzilog",
-	.dev_name	=	"ttyS",
-	.major		=	TTY_MAJOR,
+	.dev_name	=	SUNZILOG_NAME,
+	.major		=	SUNZILOG_MAJOR,
+	.minor		=	SUNZILOG_MINOR,
+	.nr		=	SUNZILOG_NR,
 };
 
 static int __init sunzilog_alloc_tables(int num_sunzilog)
@@ -1176,8 +1183,8 @@ static int __init sunzilog_console_setup(struct console *con, char *options)
 	if (up->port.type != PORT_SUNZILOG)
 		return -1;
 
-	printk(KERN_INFO "Console: ttyS%d (SunZilog zs%d)\n",
-	       (sunzilog_reg.minor - 64) + con->index, con->index);
+	printk(KERN_INFO "Console: ttySZ%d (SunZilog zs%d)\n",
+	       (sunzilog_reg.minor - SUNZILOG_MINOR) + con->index, con->index);
 
 	/* Get firmware console settings.  */
 	sunserial_console_termios(con);
@@ -1213,7 +1220,7 @@ static int __init sunzilog_console_setup(struct console *con, char *options)
 }
 
 static struct console sunzilog_console_ops = {
-	.name	=	"ttyS",
+	.name	=	SUNZILOG_NAME,
 	.write	=	sunzilog_console_write,
 	.device	=	uart_console_device,
 	.setup	=	sunzilog_console_setup,
@@ -1502,6 +1509,10 @@ static int __init sunzilog_init(void)
 	int num_keybms = 0;
 	int num_sunzilog = 0;
 
+	err = uart_register_driver(&sunzilog_reg);
+	if (err)
+		goto out;
+
 	for_each_node_by_name(dp, "zs") {
 		num_sunzilog++;
 		if (of_find_property(dp, "keyboard", NULL))
@@ -1511,19 +1522,14 @@ static int __init sunzilog_init(void)
 	if (num_sunzilog) {
 		err = sunzilog_alloc_tables(num_sunzilog);
 		if (err)
-			goto out;
+			goto out_unregister_uart;
 
 		uart_chip_count = num_sunzilog - num_keybms;
-
-		err = sunserial_register_minors(&sunzilog_reg,
-						uart_chip_count * 2);
-		if (err)
-			goto out_free_tables;
 	}
 
 	err = of_register_driver(&zs_driver, &of_bus_type);
 	if (err)
-		goto out_unregister_uart;
+		goto out_free_tables;
 
 	if (zilog_irq != -1) {
 		struct uart_sunzilog_port *up = sunzilog_irq_chain;
@@ -1551,14 +1557,12 @@ out:
 out_unregister_driver:
 	of_unregister_driver(&zs_driver);
 
-out_unregister_uart:
-	if (num_sunzilog) {
-		sunserial_unregister_minors(&sunzilog_reg, num_sunzilog);
-		sunzilog_reg.cons = NULL;
-	}
-
 out_free_tables:
 	sunzilog_free_tables();
+
+out_unregister_uart:
+	uart_unregister_driver(&sunzilog_reg);
+	sunzilog_reg.cons = NULL;
 	goto out;
 }
 
@@ -1585,10 +1589,8 @@ static void __exit sunzilog_exit(void)
 		zilog_irq = -1;
 	}
 
-	if (sunzilog_reg.nr) {
-		sunserial_unregister_minors(&sunzilog_reg, sunzilog_reg.nr);
-		sunzilog_free_tables();
-	}
+	uart_unregister_driver(&sunzilog_reg);
+	sunzilog_free_tables();
 }
 
 module_init(sunzilog_init);
