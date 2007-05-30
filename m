Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbXE3Bt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbXE3Bt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXE3Bse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:48:34 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:30469 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXE3Bsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:48:32 -0400
Date: Tue, 29 May 2007 18:45:57 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 5/5] serial: set DTR in uart for kernel serial console
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705291845.57949.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 5/5] serial: set DTR in uart for kernel serial console

Some UARTs on other side need host uart DTR is set, otherwise will not
receive char from the host that kernel is runing during kernel boot stage.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 326020f..bec5eb5 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2303,8 +2303,14 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * It may be that the port was not available.
 	 */
 	if (port->type != PORT_UNKNOWN &&
-	    port->cons && !(port->cons->flags & CON_ENABLED))
+	    port->cons && !(port->cons->flags & CON_ENABLED)) {
+		/*
+		 * some uarts on other side don't support no flow control.
+		 * So we set DTR in host uart to make them happy  --- YHLU
+		 */
+		port->mctrl |= TIOCM_DTR;
 		register_console(port->cons);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
