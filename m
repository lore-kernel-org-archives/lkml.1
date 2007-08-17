Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXHQXfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXHQXfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXHQXfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:35:24 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55688 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXHQXfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:35:23 -0400
Date: Fri, 17 Aug 2007 16:41:55 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: keep the DTR setting for serial console.
To: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708171641.56603.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: keep the DTR setting for serial console.

with reverting "x86, serial: convert legacy COM ports to platform devices", we will have the serial console before the port is probled again.

uart_add_one_port==>uart_configure_port==>set_mcttrl(port, 0) will clear the DTR setting by uart_set_options(). then I will lose my output from serial console again.

So try to keep DTR in uart_configure_port()

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 030a606..70f1106 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2117,10 +2117,11 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 
 		/*
 		 * Ensure that the modem control lines are de-activated.
+		 * keep the DTR setting that is set in uart_set_options()
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, 0);
+		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
