Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZJRPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZJRPqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 11:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZJRPqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 11:46:39 -0400
Received: from ns.penguin.cz ([84.21.108.25]:49913 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZJRPqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 11:46:38 -0400
Subject: Re: [PATCH] serial-core: resume serial hardware with
	no_console_suspend
From: Stanislav Brabec <utx@penguin.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, s.hauer@pengutronix.de, saxena@laptop.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <1255878358.4581.29.camel@utx.utx.cz>
References: <1253021938.6597.16.camel@hammer.suse.cz>
	 <20090924170503.37cbe4ed.akpm@linux-foundation.org>
	 <20090925073617.GA5856@n2100.arm.linux.org.uk>
	 <1253872547.13257.18.camel@hammer.suse.cz>
	 <20091005162741.599a1be9.akpm@linux-foundation.org>
	 <1255878358.4581.29.camel@utx.utx.cz>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Oct 2009 17:46:40 +0200
Message-Id: <1255880800.4581.40.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attaching rebased patch.

Untested! (Explained in the previous mail.)

Also sending a "diff -w" on the same code in the next mail﻿ for easier
review.

-

﻿BIOS-less devices may require hardware resume for proper work. It did
not happen with ﻿no_console_suspend (at least before ba15ab0e).

Perform a tricky suspend/resume with no_console_suspend.

Attempt to:
- Save the hardware state
- Perform buffer flush in time of its suspend call
- Tell the driver that port is suspended
- But still accept new data
- And keep console hardware in state that allows to send them

Signed-off-by: Stanislav Brabec <utx@penguin.cz>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index dcc7244..f1e1ab2 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2008,12 +2008,6 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 
 	mutex_lock(&port->mutex);
 
-	if (!console_suspend_enabled && uart_console(uport)) {
-		/* we're going to avoid suspending serial console */
-		mutex_unlock(&port->mutex);
-		return 0;
-	}
-
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (device_may_wakeup(tty_dev)) {
 		enable_irq_wake(uport->irq);
@@ -2021,20 +2015,23 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
-	uport->suspended = 1;
+	if (console_suspend_enabled || !uart_console(uport))
+		uport->suspended = 1;
 
 	if (port->flags & ASYNC_INITIALIZED) {
 		const struct uart_ops *ops = uport->ops;
 		int tries;
 
-		set_bit(ASYNCB_SUSPENDED, &port->flags);
-		clear_bit(ASYNCB_INITIALIZED, &port->flags);
+		if (console_suspend_enabled || !uart_console(uport)) {
+			set_bit(ASYNCB_SUSPENDED, &port->flags);
+			clear_bit(ASYNCB_INITIALIZED, &port->flags);
 
-		spin_lock_irq(&uport->lock);
-		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
-		ops->stop_rx(uport);
-		spin_unlock_irq(&uport->lock);
+			spin_lock_irq(&uport->lock);
+			ops->stop_tx(uport);
+			ops->set_mctrl(uport, 0);
+			ops->stop_rx(uport);
+			spin_unlock_irq(&uport->lock);
+		}
 
 		/*
 		 * Wait for the transmitter to empty.
@@ -2049,16 +2046,18 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 			       drv->dev_name,
 			       drv->tty_driver->name_base + uport->line);
 
-		ops->shutdown(uport);
+		if (console_suspend_enabled || !uart_console(uport))
+			ops->shutdown(uport);
 	}
 
 	/*
 	 * Disable the console device before suspending.
 	 */
-	if (uart_console(uport))
+	if (console_suspend_enabled && uart_console(uport))
 		console_stop(uport->cons);
 
-	uart_change_pm(state, 3);
+	if (console_suspend_enabled || !uart_console(uport))
+		uart_change_pm(state, 3);
 
 	mutex_unlock(&port->mutex);
 
@@ -2075,29 +2074,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 	mutex_lock(&port->mutex);
 
-	if (!console_suspend_enabled && uart_console(uport)) {
-		/* no need to resume serial console, it wasn't suspended */
-		/*
-		 * First try to use the console cflag setting.
-		 */
-		memset(&termios, 0, sizeof(struct ktermios));
-		termios.c_cflag = uport->cons->cflag;
-		/*
-		 * If that's unset, use the tty termios setting.
-		 */
-		if (termios.c_cflag == 0)
-			termios = *state->port.tty->termios;
-		else {
-			termios.c_ispeed = termios.c_ospeed =
-				tty_termios_input_baud_rate(&termios);
-			termios.c_ispeed = termios.c_ospeed =
-				tty_termios_baud_rate(&termios);
-		}
-		uport->ops->set_termios(uport, &termios, NULL);
-		mutex_unlock(&port->mutex);
-		return 0;
-	}
-
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
 		disable_irq_wake(uport->irq);
@@ -2123,21 +2099,23 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 		spin_lock_irq(&uport->lock);
 		ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
-		ret = ops->startup(uport);
-		if (ret == 0) {
-			uart_change_speed(state, NULL);
-			spin_lock_irq(&uport->lock);
-			ops->set_mctrl(uport, uport->mctrl);
-			ops->start_tx(uport);
-			spin_unlock_irq(&uport->lock);
-			set_bit(ASYNCB_INITIALIZED, &port->flags);
-		} else {
-			/*
-			 * Failed to resume - maybe hardware went away?
-			 * Clear the "initialized" flag so we won't try
-			 * to call the low level drivers shutdown method.
-			 */
-			uart_shutdown(state);
+		if (console_suspend_enabled || !uart_console(uport)) {
+			ret = ops->startup(uport);
+			if (ret == 0) {
+				uart_change_speed(state, NULL);
+				spin_lock_irq(&uport->lock);
+				ops->set_mctrl(uport, uport->mctrl);
+				ops->start_tx(uport);
+				spin_unlock_irq(&uport->lock);
+				set_bit(ASYNCB_INITIALIZED, &port->flags);
+			} else {
+				/*
+				 * Failed to resume - maybe hardware went away?
+				 * Clear the "initialized" flag so we won't try
+				 * to call the low level drivers shutdown method.
+				 */
+				uart_shutdown(state);
+			}
 		}
 
 		clear_bit(ASYNCB_SUSPENDED, &port->flags);


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

