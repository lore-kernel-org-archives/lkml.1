Return-Path: <linux-kernel-owner+w=401wt.eu-S935282AbXHGUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282AbXHGUrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbXHGUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:46:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51284 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498AbXHGUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:46:22 -0400
Date: Tue, 7 Aug 2007 13:42:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 05/84] Fix deadlocks in sparc serial console.
Message-ID: <20070807204253.GF23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-deadlocks-in-sparc-serial-console.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David S. Miller <davem@davemloft.net>

Subject: [2.6.22.2 review 05/84] [PATCH] [SERIAL]: Fix console write locking in sparc drivers.

Mirror the logic in 8250 for proper console write locking
when SYSRQ is triggered or an OOPS is in progress.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/sunhv.c    |   30 ++++++++++++++++++++++++++----
 drivers/serial/sunsab.c   |   19 ++++++++++++++-----
 drivers/serial/sunsu.c    |   14 ++++++++++++++
 drivers/serial/sunzilog.c |   17 ++++++++++++++---
 4 files changed, 68 insertions(+), 12 deletions(-)

--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -440,8 +440,16 @@ static void sunhv_console_write_paged(st
 {
 	struct uart_port *port = sunhv_port;
 	unsigned long flags;
+	int locked = 1;
+
+	local_irq_save(flags);
+	if (port->sysrq) {
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&port->lock);
+	} else
+		spin_lock(&port->lock);
 
-	spin_lock_irqsave(&port->lock, flags);
 	while (n > 0) {
 		unsigned long ra = __pa(con_write_page);
 		unsigned long page_bytes;
@@ -469,7 +477,10 @@ static void sunhv_console_write_paged(st
 			ra += written;
 		}
 	}
-	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (locked)
+		spin_unlock(&port->lock);
+	local_irq_restore(flags);
 }
 
 static inline void sunhv_console_putchar(struct uart_port *port, char c)
@@ -488,7 +499,15 @@ static void sunhv_console_write_bychar(s
 {
 	struct uart_port *port = sunhv_port;
 	unsigned long flags;
-	int i;
+	int i, locked = 1;
+
+	local_irq_save(flags);
+	if (port->sysrq) {
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&port->lock);
+	} else
+		spin_lock(&port->lock);
 
 	spin_lock_irqsave(&port->lock, flags);
 	for (i = 0; i < n; i++) {
@@ -496,7 +515,10 @@ static void sunhv_console_write_bychar(s
 			sunhv_console_putchar(port, '\r');
 		sunhv_console_putchar(port, *s++);
 	}
-	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (locked)
+		spin_unlock(&port->lock);
+	local_irq_restore(flags);
 }
 
 static struct console sunhv_console = {
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -860,22 +860,31 @@ static int num_channels;
 static void sunsab_console_putchar(struct uart_port *port, int c)
 {
 	struct uart_sunsab_port *up = (struct uart_sunsab_port *)port;
-	unsigned long flags;
-
-	spin_lock_irqsave(&up->port.lock, flags);
 
 	sunsab_tec_wait(up);
 	writeb(c, &up->regs->w.tic);
-
-	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static void sunsab_console_write(struct console *con, const char *s, unsigned n)
 {
 	struct uart_sunsab_port *up = &sunsab_ports[con->index];
+	unsigned long flags;
+	int locked = 1;
+
+	local_irq_save(flags);
+	if (up->port.sysrq) {
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&up->port.lock);
+	} else
+		spin_lock(&up->port.lock);
 
 	uart_console_write(&up->port, s, n, sunsab_console_putchar);
 	sunsab_tec_wait(up);
+
+	if (locked)
+		spin_unlock(&up->port.lock);
+	local_irq_restore(flags);
 }
 
 static int sunsab_console_setup(struct console *con, char *options)
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1288,7 +1288,17 @@ static void sunsu_console_write(struct c
 				unsigned int count)
 {
 	struct uart_sunsu_port *up = &sunsu_ports[co->index];
+	unsigned long flags;
 	unsigned int ier;
+	int locked = 1;
+
+	local_irq_save(flags);
+	if (up->port.sysrq) {
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&up->port.lock);
+	} else
+		spin_lock(&up->port.lock);
 
 	/*
 	 *	First save the UER then disable the interrupts
@@ -1304,6 +1314,10 @@ static void sunsu_console_write(struct c
 	 */
 	wait_for_xmitr(up);
 	serial_out(up, UART_IER, ier);
+
+	if (locked)
+		spin_unlock(&up->port.lock);
+	local_irq_restore(flags);
 }
 
 /*
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -9,7 +9,7 @@
  * C. Dost, Pete Zaitcev, Ted Ts'o and Alex Buell for their
  * work there.
  *
- *  Copyright (C) 2002, 2006 David S. Miller (davem@davemloft.net)
+ * Copyright (C) 2002, 2006, 2007 David S. Miller (davem@davemloft.net)
  */
 
 #include <linux/module.h>
@@ -1151,11 +1151,22 @@ sunzilog_console_write(struct console *c
 {
 	struct uart_sunzilog_port *up = &sunzilog_port_table[con->index];
 	unsigned long flags;
+	int locked = 1;
+
+	local_irq_save(flags);
+	if (up->port.sysrq) {
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&up->port.lock);
+	} else
+		spin_lock(&up->port.lock);
 
-	spin_lock_irqsave(&up->port.lock, flags);
 	uart_console_write(&up->port, s, count, sunzilog_putchar);
 	udelay(2);
-	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	if (locked)
+		spin_unlock(&up->port.lock);
+	local_irq_restore(flags);
 }
 
 static int __init sunzilog_console_setup(struct console *con, char *options)

-- 
