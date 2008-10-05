Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYJEQe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYJEQe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbYJEQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:24:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34343 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759388AbYJEQYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:24:48 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 73/76] serial: fix device name reporting when minor space is
	shared between drivers
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:24:48 +0100
Message-ID: <20081005162446.1997.73482.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

The multiple drivers share the minor space occupied by a particular major
number, the actual index within the device name's space is indicated by
the tty_driver->name_base + uart_port->line

Another usable formula is (uart_driver->minor - MINOR_BASE) + port->line

Use those to print the device names properly in such situations in
serial_core.c and 8250.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250.c        |   22 +++++++++++++++-------
 drivers/serial/serial_core.c |    7 +++++--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c07afb2..b43dad6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -57,6 +57,13 @@ static unsigned int share_irqs = SERIAL8250_SHARE_IRQS;
 
 static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
 
+static struct uart_driver serial8250_reg;
+
+static int serial_index(struct uart_port *port)
+{
+	return (serial8250_reg.minor - 64) + port->line;
+}
+
 /*
  * Debugging.
  */
@@ -1001,7 +1008,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		return;
 
 	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04x, 0x%p): ",
-			up->port.line, up->port.iobase, up->port.membase);
+		       serial_index(&up->port), up->port.iobase, up->port.membase);
 
 	/*
 	 * We really do need global IRQs disabled here - we're going to
@@ -1136,8 +1143,8 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	if (up->capabilities != uart_config[up->port.type].flags) {
 		printk(KERN_WARNING
 		       "ttyS%d: detected caps %08x should be %08x\n",
-			up->port.line, up->capabilities,
-			uart_config[up->port.type].flags);
+		       serial_index(&up->port), up->capabilities,
+		       uart_config[up->port.type].flags);
 	}
 
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
@@ -1902,7 +1909,8 @@ static int serial8250_startup(struct uart_port *port)
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
 	    (serial_inp(up, UART_LSR) == 0xff)) {
-		printk("ttyS%d: LSR safety check engaged!\n", up->port.line);
+		printk(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
+		       serial_index(&up->port));
 		return -ENODEV;
 	}
 
@@ -1957,7 +1965,8 @@ static int serial8250_startup(struct uart_port *port)
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
 			up->bugs |= UART_BUG_THRE;
-			pr_debug("ttyS%d - using backup timer\n", port->line);
+			pr_debug("ttyS%d - using backup timer\n",
+				 serial_index(port));
 		}
 	}
 
@@ -2017,7 +2026,7 @@ static int serial8250_startup(struct uart_port *port)
 		if (!(up->bugs & UART_BUG_TXEN)) {
 			up->bugs |= UART_BUG_TXEN;
 			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
-				 port->line);
+				 serial_index(port));
 		}
 	} else {
 		up->bugs &= ~UART_BUG_TXEN;
@@ -2678,7 +2687,6 @@ static int serial8250_console_early_setup(void)
 	return serial8250_find_port_for_earlycon();
 }
 
-static struct uart_driver serial8250_reg;
 static struct console serial8250_console = {
 	.name		= "ttyS",
 	.write		= serial8250_console_write,
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 308588e..6bdf336 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2051,7 +2051,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 					"transmitter\n",
 			       port->dev ? port->dev->bus_id : "",
 			       port->dev ? ": " : "",
-			       drv->dev_name, port->line);
+			       drv->dev_name,
+			       drv->tty_driver->name_base + port->line);
 
 		ops->shutdown(port);
 	}
@@ -2176,7 +2177,9 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	printk(KERN_INFO "%s%s%s%d at %s (irq = %d) is a %s\n",
 	       port->dev ? port->dev->bus_id : "",
 	       port->dev ? ": " : "",
-	       drv->dev_name, port->line, address, port->irq, uart_type(port));
+	       drv->dev_name,
+	       drv->tty_driver->name_base + port->line,
+	       address, port->irq, uart_type(port));
 }
 
 static void

