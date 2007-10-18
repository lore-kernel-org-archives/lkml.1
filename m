Return-Path: <linux-kernel-owner+w=401wt.eu-S1764012AbXJRQMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764012AbXJRQMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXJRQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:12:11 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:63729 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbXJRQMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:12:09 -0400
Date: Fri, 19 Oct 2007 01:13:55 +0900 (JST)
Message-Id: <20071019.011355.39154656.anemo@mba.ocn.ne.jp>
To: rmk+kernel@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] serial: do not call ->pm() on initialization for console
 port
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This commit in current git tree broke serial console for serial_txx9 driver.

> commit 97d97224ff361e08777fb33e0fd193ca877dac28
> Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> Date:   Sat Sep 1 21:25:09 2007 +0100
> 
>     [SERIAL] Fix console initialisation ordering

The serial_txx9 driver initialize its port entirely on its ->pm()
method if new state was 0.  With the commit, serial_core calls ->pm()
even if the port was used for console.

Attached patch fixes this problem.  Is this a right way?
If not, I will fix the serial_txx9 driver to skip the initialization in
->pm() if oldstate was -1.


------------------------------------------------------
Subject: serial: do not call ->pm() on initialization for console port
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

If the port was already enabled as a serial console, there is no need
to call pm callback to power it up.  This patch fixes serial console
initialization on serial_txx9 driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 68aa4da..5a38076 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2326,7 +2326,6 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	}
 
 	state->port = port;
-	state->pm_state = -1;
 
 	port->cons = drv->cons;
 	port->info = state->info;
@@ -2336,6 +2335,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * initialised.
 	 */
 	if (!(uart_console(port) && (port->cons->flags & CON_ENABLED))) {
+		state->pm_state = -1;
 		spin_lock_init(&port->lock);
 		lockdep_set_class(&port->lock, &port_lock_key);
 	}
