Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYAHL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYAHL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAHL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:57:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50984 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYAHL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:57:16 -0500
Date: Tue, 8 Jan 2008 11:51:49 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH: 1/2] [SERIAL] avoid waking up closed serial ports on resume
Message-ID: <20080108115148.GB10546@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we boot, serial ports remain in low power mode until they're
used either by userspace or for the kernel console.

However, if you suspend the system, and then resume, all serial ports
will be taken out of low power mode.  This is bad news for embedded
devices where this can mean higher power consumption.

Only bring a serial port out of low power mode if the port is being
used as the kernel console, or is in use by userspace.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3bb5d24..80486c6 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2029,8 +2029,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 	}
 	port->suspended = 0;
 
-	uart_change_pm(state, 0);
-
 	/*
 	 * Re-enable the console device after suspending.
 	 */
@@ -2049,6 +2047,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		if (state->info && state->info->tty && termios.c_cflag == 0)
 			termios = *state->info->tty->termios;
 
+		uart_change_pm(state, 0);
 		port->ops->set_termios(port, &termios, NULL);
 		console_start(port->cons);
 	}
@@ -2057,6 +2056,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		const struct uart_ops *ops = port->ops;
 		int ret;
 
+		uart_change_pm(state, 0);
 		ops->set_mctrl(port, 0);
 		ret = ops->startup(port);
 		if (ret == 0) {

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
