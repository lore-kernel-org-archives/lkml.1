Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbXCGPda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbXCGPda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCGPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:33:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751961AbXCGPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:33:29 -0500
Date: Wed, 7 Mar 2007 16:37:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] z85230: Fix FIFO handling
Message-ID: <20070307163738.44284ad7@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We must exit immediately on a FIFO fill not take the end of packet path
otherwise each underrun in PIO transmit mode causes a runt packet and the
data is lost.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/drivers/net/wan/z85230.c linux-2.6.21-rc2-mm2/drivers/net/wan/z85230.c
--- linux.vanilla-2.6.21-rc2-mm2/drivers/net/wan/z85230.c	2007-03-06 23:06:16.000000000 +0000
+++ linux-2.6.21-rc2-mm2/drivers/net/wan/z85230.c	2007-03-06 16:59:50.000000000 +0000
@@ -407,7 +407,7 @@
 	while(c->txcount) {
 		/* FIFO full ? */
 		if(!(read_zsreg(c, R0)&4))
-			break;
+			return;
 		c->txcount--;
 		/*
 		 *	Shovel out the byte
