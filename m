Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZGSP3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZGSP3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZGSP3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:29:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38746 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZGSP3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:29:39 -0400
Date: Sun, 19 Jul 2009 17:29:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: pfg@sgi.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/10] drivers/serial: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907191729140.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  BUG_ON (E == NULL);
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/ioc3_serial.c |    3 ++-
 drivers/serial/ioc4_serial.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
index ae3699d..6d5c91b 100644
--- a/drivers/serial/ioc3_serial.c
+++ b/drivers/serial/ioc3_serial.c
@@ -1117,13 +1117,14 @@ static inline int do_read(struct uart_port *the_port, char *buf, int len)
 	struct ioc3_port *port = get_ioc3_port(the_port);
 	struct ring *inring;
 	struct ring_entry *entry;
-	struct port_hooks *hooks = port->ip_hooks;
+	struct port_hooks *hooks;
 	int byte_num;
 	char *sc;
 	int loop_counter;
 
 	BUG_ON(!(len >= 0));
 	BUG_ON(!port);
+	hooks = port->ip_hooks;
 
 	/* There is a nasty timing issue in the IOC3. When the rx_timer
 	 * expires or the rx_high condition arises, we take an interrupt.
diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
index 6bab63c..aeca2f8 100644
--- a/drivers/serial/ioc4_serial.c
+++ b/drivers/serial/ioc4_serial.c
@@ -2067,13 +2067,14 @@ static inline int do_read(struct uart_port *the_port, unsigned char *buf,
 	struct ioc4_port *port = get_ioc4_port(the_port, 0);
 	struct ring *inring;
 	struct ring_entry *entry;
-	struct hooks *hooks = port->ip_hooks;
+	struct hooks *hooks;
 	int byte_num;
 	char *sc;
 	int loop_counter;
 
 	BUG_ON(!(len >= 0));
 	BUG_ON(!port);
+	hooks = port->ip_hooks;
 
 	/* There is a nasty timing issue in the IOC4. When the rx_timer
 	 * expires or the rx_high condition arises, we take an interrupt.
