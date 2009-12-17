Return-Path: <linux-kernel-owner+w=401wt.eu-S935510AbZLQBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510AbZLQBc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935320AbZLQBcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:32:32 -0500
Received: from kroah.org ([198.145.64.141]:48077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763668AbZLQBUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011605.938263178@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [61/90] serial: suncore: Add ignore_line argument to sunserial_console_match().
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 4e3533d05b6e5e66d1cda27f6671251c99c62894 ]

This tells the logic to ignore the line match when deciding whether the
device is the OpenFirmware specified console device or not.

This is going to be used in the SU driver for rsc-console detection.

There is probably a better way to handle this, but this is the least
intrusive solution for now which we can validate won't break any other
cases.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/suncore.c  |   19 ++++++++++---------
 drivers/serial/suncore.h  |    2 +-
 drivers/serial/sunsab.c   |    6 ++++--
 drivers/serial/sunsu.c    |    3 ++-
 drivers/serial/sunzilog.c |    6 ++++--
 5 files changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/serial/suncore.c
+++ b/drivers/serial/suncore.c
@@ -53,20 +53,21 @@ void sunserial_unregister_minors(struct 
 EXPORT_SYMBOL(sunserial_unregister_minors);
 
 int sunserial_console_match(struct console *con, struct device_node *dp,
-			    struct uart_driver *drv, int line)
+			    struct uart_driver *drv, int line, bool ignore_line)
 {
-	int off;
-
 	if (!con || of_console_device != dp)
 		return 0;
 
-	off = 0;
-	if (of_console_options &&
-	    *of_console_options == 'b')
-		off = 1;
+	if (!ignore_line) {
+		int off = 0;
 
-	if ((line & 1) != off)
-		return 0;
+		if (of_console_options &&
+		    *of_console_options == 'b')
+			off = 1;
+
+		if ((line & 1) != off)
+			return 0;
+	}
 
 	con->index = line;
 	drv->cons = con;
--- a/drivers/serial/suncore.h
+++ b/drivers/serial/suncore.h
@@ -26,7 +26,7 @@ extern int sunserial_register_minors(str
 extern void sunserial_unregister_minors(struct uart_driver *, int);
 
 extern int sunserial_console_match(struct console *, struct device_node *,
-				   struct uart_driver *, int);
+				   struct uart_driver *, int, bool);
 extern void sunserial_console_termios(struct console *);
 
 #endif /* !(_SERIAL_SUN_H) */
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -1027,10 +1027,12 @@ static int __devinit sab_probe(struct of
 		goto out1;
 
 	sunserial_console_match(SUNSAB_CONSOLE(), op->node,
-				&sunsab_reg, up[0].port.line);
+				&sunsab_reg, up[0].port.line,
+				false);
 
 	sunserial_console_match(SUNSAB_CONSOLE(), op->node,
-				&sunsab_reg, up[1].port.line);
+				&sunsab_reg, up[1].port.line,
+				false);
 
 	err = uart_add_one_port(&sunsab_reg, &up[0].port);
 	if (err)
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1468,7 +1468,8 @@ static int __devinit su_probe(struct of_
 	up->port.ops = &sunsu_pops;
 
 	sunserial_console_match(SUNSU_CONSOLE(), dp,
-				&sunsu_reg, up->port.line);
+				&sunsu_reg, up->port.line,
+				false);
 	err = uart_add_one_port(&sunsu_reg, &up->port);
 	if (err)
 		goto out_unmap;
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1416,7 +1416,8 @@ static int __devinit zs_probe(struct of_
 
 	if (!keyboard_mouse) {
 		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->node,
-					    &sunzilog_reg, up[0].port.line))
+					    &sunzilog_reg, up[0].port.line,
+					    false))
 			up->flags |= SUNZILOG_FLAG_IS_CONS;
 		err = uart_add_one_port(&sunzilog_reg, &up[0].port);
 		if (err) {
@@ -1425,7 +1426,8 @@ static int __devinit zs_probe(struct of_
 			return err;
 		}
 		if (sunserial_console_match(SUNZILOG_CONSOLE(), op->node,
-					    &sunzilog_reg, up[1].port.line))
+					    &sunzilog_reg, up[1].port.line,
+					    false))
 			up->flags |= SUNZILOG_FLAG_IS_CONS;
 		err = uart_add_one_port(&sunzilog_reg, &up[1].port);
 		if (err) {


