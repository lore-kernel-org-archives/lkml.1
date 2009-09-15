Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZIONjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZIONjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZIONi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:38:57 -0400
Received: from ns.penguin.cz ([84.21.108.25]:42638 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZIONi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:38:57 -0400
Subject: [PATCH] serial-core: resume serial hardware with no_console_suspend
From: Stanislav Brabec <utx@penguin.cz>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Tue, 15 Sep 2009 15:38:58 +0200
Message-Id: <1253021938.6597.16.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware may need re-initialization to get serial port working after
resume. It does not happen with no_console_suspend. Attached patch
attempts to fix it.

The patch attempts to keep hardware running before suspend and run
hardware re-initialization after resume. Maybe simpler approach is
possible.

Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index b0bb29d..43cc1ab 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1990,12 +1990,6 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 
 	mutex_lock(&state->mutex);
 
-	if (!console_suspend_enabled && uart_console(port)) {
-		/* we're going to avoid suspending serial console */
-		mutex_unlock(&state->mutex);
-		return 0;
-	}
-
 	tty_dev = device_find_child(port->dev, &match, serial_match_port);
 	if (device_may_wakeup(tty_dev)) {
 		enable_irq_wake(port->irq);
@@ -2003,20 +1997,23 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-	port->suspended = 1;
+	if (console_suspend_enabled || !uart_console(port))
+		port->suspended = 1;
 
 	if (state->info.flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
 		int tries;
 
-		state->info.flags = (state->info.flags & ~UIF_INITIALIZED)
-				     | UIF_SUSPENDED;
+		if (console_suspend_enabled || !uart_console(port)) {
+			state->info.flags = (state->info.flags & ~UIF_INITIALIZED)
+					     | UIF_SUSPENDED;
 
-		spin_lock_irq(&port->lock);
-		ops->stop_tx(port);
-		ops->set_mctrl(port, 0);
-		ops->stop_rx(port);
-		spin_unlock_irq(&port->lock);
+			spin_lock_irq(&port->lock);
+			ops->stop_tx(port);
+			ops->set_mctrl(port, 0);
+			ops->stop_rx(port);
+			spin_unlock_irq(&port->lock);
+		}
 
 		/*
 		 * Wait for the transmitter to empty.
@@ -2031,16 +2028,18 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 			       drv->dev_name,
 			       drv->tty_driver->name_base + port->line);
 
-		ops->shutdown(port);
+		if (console_suspend_enabled || !uart_console(port))
+			ops->shutdown(port);
 	}
 
 	/*
 	 * Disable the console device before suspending.
 	 */
-	if (uart_console(port))
+	if (console_suspend_enabled && uart_console(port))
 		console_stop(port->cons);
 
-	uart_change_pm(state, 3);
+	if (console_suspend_enabled || !uart_console(port))
+		uart_change_pm(state, 3);
 
 	mutex_unlock(&state->mutex);
 
@@ -2055,12 +2054,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 
 	mutex_lock(&state->mutex);
 
-	if (!console_suspend_enabled && uart_console(port)) {
-		/* no need to resume serial console, it wasn't suspended */
-		mutex_unlock(&state->mutex);
-		return 0;
-	}
-
 	tty_dev = device_find_child(port->dev, &match, serial_match_port);
 	if (!port->suspended && device_may_wakeup(tty_dev)) {
 		disable_irq_wake(port->irq);
@@ -2100,21 +2093,23 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		spin_lock_irq(&port->lock);
 		ops->set_mctrl(port, 0);
 		spin_unlock_irq(&port->lock);
-		ret = ops->startup(port);
-		if (ret == 0) {
-			uart_change_speed(state, NULL);
-			spin_lock_irq(&port->lock);
-			ops->set_mctrl(port, port->mctrl);
-			ops->start_tx(port);
-			spin_unlock_irq(&port->lock);
-			state->info.flags |= UIF_INITIALIZED;
-		} else {
-			/*
-			 * Failed to resume - maybe hardware went away?
-			 * Clear the "initialized" flag so we won't try
-			 * to call the low level drivers shutdown method.
-			 */
-			uart_shutdown(state);
+		if (console_suspend_enabled || !uart_console(port)) {
+			ret = ops->startup(port);
+			if (ret == 0) {
+				uart_change_speed(state, NULL);
+				spin_lock_irq(&port->lock);
+				ops->set_mctrl(port, port->mctrl);
+				ops->start_tx(port);
+				spin_unlock_irq(&port->lock);
+				state->info.flags |= UIF_INITIALIZED;
+			} else {
+				/*
+				 * Failed to resume - maybe hardware went away?
+				 * Clear the "initialized" flag so we won't try
+				 * to call the low level drivers shutdown method.
+				 */
+				uart_shutdown(state);
+			}
 		}
 
 		state->info.flags &= ~UIF_SUSPENDED;


-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

