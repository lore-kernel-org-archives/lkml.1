Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0CBXgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:36:55 -0500
Received: from kroah.org ([198.145.64.141]:51542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab0CBXgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Shmulik Ladkani <shmulik@jungo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/36] serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup
Date: Tue,  2 Mar 2010 15:36:09 -0800
Message-Id: <1267573003-782-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik@jungo.com>

Augment the UPF_FIXED_TYPE logic, which currently applies to UART ports
provisioned using platform_device_register.

The suggested patch applies same logic into 'serial8250_register_ports',
making UART ports provisioned using early_serial_setup inherit their
properties from the uart_config entry.

Signed-off-by: Shmulik Ladkani <shmulik@jungo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a81ff7b..7c4ebe6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2690,6 +2690,15 @@ static void __init serial8250_isa_init_ports(void)
 	}
 }
 
+static void
+serial8250_init_fixed_type_port(struct uart_8250_port *up, unsigned int type)
+{
+	up->port.type = type;
+	up->port.fifosize = uart_config[type].fifo_size;
+	up->capabilities = uart_config[type].flags;
+	up->tx_loadsz = uart_config[type].tx_loadsz;
+}
+
 static void __init
 serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 {
@@ -2706,6 +2715,10 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		up->port.dev = dev;
+
+		if (up->port.flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(up, up->port.type);
+
 		uart_add_one_port(drv, &up->port);
 	}
 }
@@ -3118,12 +3131,8 @@ int serial8250_register_port(struct uart_port *port)
 		if (port->dev)
 			uart->port.dev = port->dev;
 
-		if (port->flags & UPF_FIXED_TYPE) {
-			uart->port.type = port->type;
-			uart->port.fifosize = uart_config[port->type].fifo_size;
-			uart->capabilities = uart_config[port->type].flags;
-			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
-		}
+		if (port->flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(uart, port->type);
 
 		set_io_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */
-- 
1.7.0.1

