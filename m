Return-Path: <linux-kernel-owner+w=401wt.eu-S935946AbZLQB31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946AbZLQB31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763665AbZLQBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:49 -0500
Received: from kroah.org ([198.145.64.141]:48092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763661AbZLQBUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.338794179@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [64/90] sunsu: Use sunserial_console_termios() in sunsu_console_setup().
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit be24656a5e2d68bfd0744f0742c4aceef2cf44b5 ]

Be like the other Sun serial drivers otherwise the special handling of
OpenFirmware options and hard-coded overrides for LOM/RSC consoles
will not be handled.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/sunsu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1329,11 +1329,9 @@ static void sunsu_console_write(struct c
  */
 static int __init sunsu_console_setup(struct console *co, char *options)
 {
+	static struct ktermios dummy;
+	struct ktermios termios;
 	struct uart_port *port;
-	int baud = 9600;
-	int bits = 8;
-	int parity = 'n';
-	int flow = 'n';
 
 	printk("Console: ttyS%d (SU)\n",
 	       (sunsu_reg.minor - 64) + co->index);
@@ -1352,10 +1350,15 @@ static int __init sunsu_console_setup(st
 	 */
 	spin_lock_init(&port->lock);
 
-	if (options)
-		uart_parse_options(options, &baud, &parity, &bits, &flow);
+	/* Get firmware console settings.  */
+	sunserial_console_termios(co, to_of_device(port->dev)->node);
 
-	return uart_set_options(port, co, baud, parity, bits, flow);
+	memset(&termios, 0, sizeof(struct ktermios));
+	termios.c_cflag = co->cflag;
+	port->mctrl |= TIOCM_DTR;
+	port->ops->set_termios(port, &termios, &dummy);
+
+	return 0;
 }
 
 static struct console sunsu_console = {


