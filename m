Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZBWET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZBWET3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZBWETU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:19:20 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:46530 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZBWETT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Kj9sl5xJvvkezIrx40AYcPyEunQnwFYpUdYMOGfeVGiuphUhX5i9VAG0SHge38rOrK
         s2wcyNZGz/sCX5b9RQl+ajmpBELFOTzch/mW9hGJVm4ny2fi/3rYyz06O85Wq4AwEBoF
         mOIRiAS+t2GG6a2QXPdLavbIb6FLt01q2TeAE=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Gardner <gardner.ben@gmail.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [patch] w1_ds2433: clear the validcrc flag after a write
Date: Sun, 22 Feb 2009 22:19:16 -0600
Message-Id: <1235362756-10119-1-git-send-email-gardner.ben@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The w1_ds2433 driver does not read from the hardware if the CRC was valid on the last read.
The validcrc flag should be cleared after a write so that the new value can be read.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- linux-2.6.28.5.orig/drivers/w1/slaves/w1_ds2433.c	2009-02-16 13:52:06.000000000 -0600
+++ linux-2.6.28.5/drivers/w1/slaves/w1_ds2433.c	2009-02-16 13:52:27.000000000 -0600
@@ -156,6 +156,9 @@
  */
 static int w1_f23_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 {
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
+	struct w1_f23_data *f23 = sl->family_data;
+#endif
 	u8 wrbuf[4];
 	u8 rdbuf[W1_PAGE_SIZE + 3];
 	u8 es = (addr + len - 1) & 0x1f;
@@ -196,7 +199,9 @@
 
 	/* Reset the bus to wake up the EEPROM (this may not be needed) */
 	w1_reset_bus(sl->master);
-
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
+	f23->validcrc &= ~(1 << (addr >> W1_PAGE_BITS));
+#endif
 	return 0;
 }
 
