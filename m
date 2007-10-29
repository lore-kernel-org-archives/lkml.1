Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXJ2N6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXJ2N6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXJ2N6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:58:14 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57661 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbXJ2N6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:58:13 -0400
Date: Mon, 29 Oct 2007 23:00:08 +0900 (JST)
Message-Id: <20071029.230008.74389661.anemo@mba.ocn.ne.jp>
To: rmk+kernel@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 2.6.24-rc1] serial: Fix serial_txx9 console initialization
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 97d97224ff361e08777fb33e0fd193ca877dac28, serial_core
calls ->pm() on initialization even if the port was used for console.
This behaviour breaks serial_txx9 console since The serial_txx9 driver
initialize its port entirely on its ->pm() method if new state was 0.
This patch adds checking for oldstate value to fix this probelm.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 6846a6c..7ad2192 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -657,7 +657,15 @@ static void
 serial_txx9_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
-	if (state == 0)
+	/*
+	 * If oldstate was -1 this is called from
+	 * uart_configure_port().  In this case do not initialize the
+	 * port now, because the port was already initialized (for
+	 * non-console port) or should not be initialized here (for
+	 * console port).  If we initialized the port here we lose
+	 * serial console settings.
+	 */
+	if (state == 0 && oldstate != -1)
 		serial_txx9_initialize(port);
 }

