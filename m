Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbZE1MCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbZE1MCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbZE1MCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:02:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48980 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758400AbZE1MCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:02:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] 8250: Fix oops from setserial
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Date: Thu, 28 May 2009 14:01:35 +0100
Message-ID: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

[Impact: ok I just put this here to wind up Linus]

If you setserial a port which has never been initialised we change the type
but don't update the I/O method pointers. The same problem is true if you
change the io type of a port - but nobody ever does that so nobody noticed!

Remember the old type and when attaching if the type has changed reload the
port accessor pointers. We can't do it blindly as some 8250 drivers load custom
accessors and we must not stomp those.

Closes-bug: #13367
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/8250.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b4b3981..a0127e9 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -137,6 +137,7 @@ struct uart_8250_port {
 	unsigned char		mcr;
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
+	unsigned char		cur_iotype;	/* Running I/O type */
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
@@ -471,6 +472,7 @@ static void io_serial_out(struct uart_port *p, int offset, int value)
 
 static void set_io_from_upio(struct uart_port *p)
 {
+	struct uart_8250_port *up = (struct uart_8250_port *)p;
 	switch (p->iotype) {
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
@@ -509,6 +511,8 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = io_serial_out;
 		break;
 	}
+	/* Remember loaded iotype */
+	up->cur_iotype = p->iotype;
 }
 
 static void
@@ -1937,6 +1941,9 @@ static int serial8250_startup(struct uart_port *port)
 	up->capabilities = uart_config[up->port.type].flags;
 	up->mcr = 0;
 
+	if (up->port.iotype != up->cur_iotype)
+		set_io_from_upio(port);
+
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
@@ -2563,6 +2570,9 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (ret < 0)
 		probeflags &= ~PROBE_RSA;
 
+	if (up->port.iotype != up->cur_iotype)
+		set_io_from_upio(port);
+
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up, probeflags);
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
@@ -2671,6 +2681,11 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 {
 	int i;
 
+	for (i = 0; i < nr_uarts; i++) {
+		struct uart_8250_port *up = &serial8250_ports[i];
+		up->cur_iotype = 0xFF;
+	}
+
 	serial8250_isa_init_ports();
 
 	for (i = 0; i < nr_uarts; i++) {

