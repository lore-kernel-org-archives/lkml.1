Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZELVL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZELVL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZELVLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:11:18 -0400
Received: from plexity.net ([206.123.115.38]:41392 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbZELVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:11:17 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 17:11:17 EDT
Date: Tue, 12 May 2009 21:00:16 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] 8250: Don't restore NS16550 mode when console suspend is
	disabled
Message-ID: <20090512210015.GA25540@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC 
XO laptop. Basically what happens is that upon returning from resume, 
serial8250_resume_port() will reconfigure the port for high speed
mode and all console output will be garbled, making debug of the 
resume path painful. This patch modifies serial8250_resume_port() to 
not touch the port in the case where it is the console port and console 
suspend is disabled.

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

---
The OLPC tree has been carrying a workaround for about two years but
this patch is not the version we've been using. That one can be
found at http://dev.laptop.org/~dsaxena/patches/console_suspend_old.patch.
I prefer the approach of handling this in the 8250 driver itself.

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b4b3981..d4b6373 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2887,7 +2887,8 @@ void serial8250_resume_port(int line)
 {
 	struct uart_8250_port *up = &serial8250_ports[line];
 
-	if (up->capabilities & UART_NATSEMI) {
+	if ((up->capabilities & UART_NATSEMI) && 
+	     (!uart_console(&up->port) && console_suspend_enabled)) {
 		unsigned char tmp;
 
 		/* Ensure it's still in high speed mode */
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index b0bb29d..05fd868 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -54,12 +54,6 @@ static struct lock_class_key port_lock_key;
 
 #define uart_users(state)	((state)->count + (state)->info.port.blocked_open)
 
-#ifdef CONFIG_SERIAL_CORE_CONSOLE
-#define uart_console(port)	((port)->cons && (port)->cons->index == (port)->line)
-#else
-#define uart_console(port)	(0)
-#endif
-
 static void uart_change_speed(struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 57a97e5..9fba77a 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -427,6 +427,12 @@ struct tty_driver *uart_console_device(struct console *co, int *index);
 void uart_console_write(struct uart_port *port, const char *s,
 			unsigned int count,
 			void (*putchar)(struct uart_port *, int));
+#ifdef CONFIG_SERIAL_CORE_CONSOLE
+#define uart_console(port)	((port)->cons && (port)->cons->index == (port)->line)
+#else
+#define uart_console(port)	(0)
+#endif
+
 
 /*
  * Port/driver registration/removal



-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

