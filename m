Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYKNQV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYKNQV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYKNQVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:21:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYKNQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:21:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix an uninitialised variable warning in the 8250 driver
To: linux-serial@vger.kernel.org, akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 14 Nov 2008 16:20:38 +0000
Message-ID: <20081114162038.23016.20581.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an uninitialised variable warning in the 8250 driver:

  CC      drivers/serial/8250.o
drivers/serial/8250.c: In function 'serial8250_shutdown':
drivers/serial/8250.c:1612: warning: 'i' may be used uninitialized in this function

This has the added advantage of removing a conditional test from the main path
as the BUG_ON() that indicated the loop dropped off the end is now bypassed in
the event of a successful search.  Indeed that BUG_ON() can now be a BUG() as
the only way to reach it automatically makes its condition true.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/serial/8250.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..62cf7e5 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1620,10 +1620,11 @@ static void serial_unlink_irq_chain(struct uart_8250_port *up)
 	hlist_for_each(n, h) {
 		i = hlist_entry(n, struct irq_info, node);
 		if (i->irq == up->port.irq)
-			break;
+			goto found;
 	}
+	BUG();
 
-	BUG_ON(n == NULL);
+found:
 	BUG_ON(i->head == NULL);
 
 	if (list_empty(i->head))

