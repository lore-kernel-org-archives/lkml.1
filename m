Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZGAAix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZGAAix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbZGAAch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:37 -0400
Received: from kroah.org ([198.145.64.141]:59723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbZGAAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:48 2009
Message-Id: <20090701001548.246214392@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:13:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [patch 02/35] 8250: Fix oops from setserial
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=8250-fix-oops-from-setserial.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit b8e7e40abeac49644fec4a4f52ffe74c7b05eca0 upstream.

If you setserial a port which has never been initialised we change the type
but don't update the I/O method pointers. The same problem is true if you
change the io type of a port - but nobody ever does that so nobody noticed!

Remember the old type and when attaching if the type has changed reload the
port accessor pointers. We can't do it blindly as some 8250 drivers load custom
accessors and we must not stomp those.

Tested-by: Victor Seryodkin <vvscore@gmail.com>
Closes-bug: #13367
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -137,6 +137,7 @@ struct uart_8250_port {
 	unsigned char		mcr;
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
+	unsigned char		cur_iotype;	/* Running I/O type */
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
@@ -471,6 +472,7 @@ static void io_serial_out(struct uart_po
 
 static void set_io_from_upio(struct uart_port *p)
 {
+	struct uart_8250_port *up = (struct uart_8250_port *)p;
 	switch (p->iotype) {
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
@@ -509,6 +511,8 @@ static void set_io_from_upio(struct uart
 		p->serial_out = io_serial_out;
 		break;
 	}
+	/* Remember loaded iotype */
+	up->cur_iotype = p->iotype;
 }
 
 static void
@@ -1937,6 +1941,9 @@ static int serial8250_startup(struct uar
 	up->capabilities = uart_config[up->port.type].flags;
 	up->mcr = 0;
 
+	if (up->port.iotype != up->cur_iotype)
+		set_io_from_upio(port);
+
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
@@ -2563,6 +2570,9 @@ static void serial8250_config_port(struc
 	if (ret < 0)
 		probeflags &= ~PROBE_RSA;
 
+	if (up->port.iotype != up->cur_iotype)
+		set_io_from_upio(port);
+
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up, probeflags);
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
@@ -2671,6 +2681,11 @@ serial8250_register_ports(struct uart_dr
 {
 	int i;
 
+	for (i = 0; i < nr_uarts; i++) {
+		struct uart_8250_port *up = &serial8250_ports[i];
+		up->cur_iotype = 0xFF;
+	}
+
 	serial8250_isa_init_ports();
 
 	for (i = 0; i < nr_uarts; i++) {


