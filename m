Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXEaVFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXEaVFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXEaVEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:04:08 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.133]:43714 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXEaVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:04:00 -0400
Date: Thu, 31 May 2007 14:03:11 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 5/5] serial: assert DTR for serial console devices
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705311403.12238.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 5/5] serial: assert DTR for serial console devices

Some RS-232 devices require DTR to be asserted before they can be
used.  DTR is normally asserted in uart_startup() when the port is
opened.  But we don't actually open serial console ports, so assert
DTR when the port is added.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 326020f..e5a3d8b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2303,8 +2303,14 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * It may be that the port was not available.
 	 */
 	if (port->type != PORT_UNKNOWN &&
-	    port->cons && !(port->cons->flags & CON_ENABLED))
+	    port->cons && !(port->cons->flags & CON_ENABLED)) {
+		/*
+		 * We normally assert DTR when a port is opened, but serial
+		 * console devices aren't actually opened, so do it here.
+		 */
+		uart_set_mctrl(port, TIOCM_DTR);
 		register_console(port->cons);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
