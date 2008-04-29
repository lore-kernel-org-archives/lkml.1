Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYD2NZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYD2NZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYD2NZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:25:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52945 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbYD2NY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:24:59 -0400
Date: Tue, 29 Apr 2008 14:17:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isicom: Fix buffer allocation
Message-ID: <20080429141733.607a2306@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the rather strange buffer management on open that turned up while
auditing for BKL dependancies

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/isicom.c linux-2.6.25-mm1/drivers/char/isicom.c
--- linux.vanilla-2.6.25-mm1/drivers/char/isicom.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/isicom.c	2008-04-14 10:56:25.000000000 +0100
@@ -813,15 +813,13 @@
 		return 0;
 	if (!port->xmit_buf) {
 		/* Relies on BKL */
-		void *xmit_buf = (void *)get_zeroed_page(GFP_KERNEL);
-
-		if (xmit_buf == NULL)
+		unsigned long page  = get_zeroed_page(GFP_KERNEL);
+		if (page == 0)
 			return -ENOMEM;
-		if (port->xmit_buf) {
-			free_page((unsigned long)xmit_buf);
-			return -ERESTARTSYS;
-		}
-		port->xmit_buf = xmit_buf;
+		if (port->xmit_buf)
+			free_page(page);
+		else
+			port->xmit_buf = (unsigned char *) page;
 	}
 
 	spin_lock_irqsave(&card->card_lock, flags);
