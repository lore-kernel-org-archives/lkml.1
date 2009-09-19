Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZISVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZISVnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZISVnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:13 -0400
Received: from kroah.org ([198.145.64.141]:40514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZISVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/79] serial: move port users helper
Date: Sat, 19 Sep 2009 14:36:59 -0700
Message-Id: <1253396244-7885-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This little helper is now tty_port specific and useful generally so move it

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |    6 ++----
 include/linux/tty.h          |    5 +++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index e16d153..3c45a8d 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -52,8 +52,6 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
-#define uart_users(state)	((state)->port.count + (state)->port.blocked_open)
-
 #ifdef CONFIG_SERIAL_CORE_CONSOLE
 #define uart_console(port)	((port)->cons && (port)->cons->index == (port)->line)
 #else
@@ -758,7 +756,7 @@ static int uart_set_info(struct uart_state *state,
 		/*
 		 * Make sure that we are the sole user of this port.
 		 */
-		if (uart_users(state) > 1)
+		if (tty_port_users(port) > 1)
 			goto exit;
 
 		/*
@@ -974,7 +972,7 @@ static int uart_do_autoconfig(struct uart_state *state)
 		return -ERESTARTSYS;
 
 	ret = -EBUSY;
-	if (uart_users(state) == 1) {
+	if (tty_port_users(port) == 1) {
 		uart_shutdown(state);
 
 		/*
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 0daa8a7..a0e0330 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -467,6 +467,11 @@ extern int tty_port_close_start(struct tty_port *port,
 extern void tty_port_close_end(struct tty_port *port, struct tty_struct *tty);
 extern void tty_port_close(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
+extern inline int tty_port_users(struct tty_port *port)
+{
+	return port->count + port->blocked_open;
+}
+
 extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_set_ldisc(struct tty_struct *tty, int ldisc);
-- 
1.6.4.2

