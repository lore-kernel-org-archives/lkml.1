Return-Path: <linux-kernel-owner+w=401wt.eu-S936010AbZLQBcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936010AbZLQBcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935952AbZLQBbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:31:21 -0500
Received: from kroah.org ([198.145.64.141]:48074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763671AbZLQBUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.083503274@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [62/90] serial: suncore: Fix RSC/LOM handling in sunserial_console_termios().
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 457931de3b0925dc2eb941bc7d611a509be36dff ]

RSC and LOM devices have fixed speed settings.

We already had some code to match and handle "rsc" named devices on
E250 systems, but we also have to handle 'rsc-console', 'rsc-control',
and 'lom-console'.

Also, in order to get this right regardless of what 'output-device'
happens to be, explicitly pass the UART device node pointer to this
routine.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/suncore.c  |   18 ++++++++++--------
 drivers/serial/suncore.h  |    3 ++-
 drivers/serial/sunhv.c    |    2 +-
 drivers/serial/sunsab.c   |    2 +-
 drivers/serial/sunzilog.c |    2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/serial/suncore.c
+++ b/drivers/serial/suncore.c
@@ -77,23 +77,24 @@ int sunserial_console_match(struct conso
 }
 EXPORT_SYMBOL(sunserial_console_match);
 
-void
-sunserial_console_termios(struct console *con)
+void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
 {
-	struct device_node *dp;
-	const char *od, *mode, *s;
+	const char *mode, *s;
 	char mode_prop[] = "ttyX-mode";
 	int baud, bits, stop, cflag;
 	char parity;
 
-	dp = of_find_node_by_path("/options");
-	od = of_get_property(dp, "output-device", NULL);
-	if (!strcmp(od, "rsc")) {
-		mode = of_get_property(of_console_device,
+	if (!strcmp(uart_dp->name, "rsc") ||
+	    !strcmp(uart_dp->name, "rsc-console") ||
+	    !strcmp(uart_dp->name, "rsc-control")) {
+		mode = of_get_property(uart_dp,
 				       "ssp-console-modes", NULL);
 		if (!mode)
 			mode = "115200,8,n,1,-";
+	} else if (!strcmp(uart_dp->name, "lom-console")) {
+		mode = "9600,8,n,1,-";
 	} else {
+		struct device_node *dp;
 		char c;
 
 		c = 'a';
@@ -102,6 +103,7 @@ sunserial_console_termios(struct console
 
 		mode_prop[3] = c;
 
+		dp = of_find_node_by_path("/options");
 		mode = of_get_property(dp, mode_prop, NULL);
 		if (!mode)
 			mode = "9600,8,n,1,-";
--- a/drivers/serial/suncore.h
+++ b/drivers/serial/suncore.h
@@ -27,6 +27,7 @@ extern void sunserial_unregister_minors(
 
 extern int sunserial_console_match(struct console *, struct device_node *,
 				   struct uart_driver *, int, bool);
-extern void sunserial_console_termios(struct console *);
+extern void sunserial_console_termios(struct console *,
+				      struct device_node *);
 
 #endif /* !(_SERIAL_SUN_H) */
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -566,7 +566,7 @@ static int __devinit hv_probe(struct of_
 		goto out_free_con_read_page;
 
 	sunserial_console_match(&sunhv_console, op->node,
-				&sunhv_reg, port->line);
+				&sunhv_reg, port->line, false);
 
 	err = uart_add_one_port(&sunhv_reg, port);
 	if (err)
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -883,7 +883,7 @@ static int sunsab_console_setup(struct c
 	printk("Console: ttyS%d (SAB82532)\n",
 	       (sunsab_reg.minor - 64) + con->index);
 
-	sunserial_console_termios(con);
+	sunserial_console_termios(con, to_of_device(up->port.dev)->node);
 
 	switch (con->cflag & CBAUD) {
 	case B150: baud = 150; break;
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1180,7 +1180,7 @@ static int __init sunzilog_console_setup
 	       (sunzilog_reg.minor - 64) + con->index, con->index);
 
 	/* Get firmware console settings.  */
-	sunserial_console_termios(con);
+	sunserial_console_termios(con, to_of_device(up->port.dev)->node);
 
 	/* Firmware console speed is limited to 150-->38400 baud so
 	 * this hackish cflag thing is OK.


