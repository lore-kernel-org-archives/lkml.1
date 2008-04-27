Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYD0HmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYD0HmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYD0HmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:42:08 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:35788 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYD0HmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:42:07 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 03:42:07 EDT
Date: Sun, 27 Apr 2008 09:13:51 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rl@hellgate.ch
Subject: [PATCH] via-rhine: suspend/resume bugfix
Message-ID: <20080427071351.GA20561@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in via-rhine driver - the driver don't disable
interrupts during suspend, which sometimes leads to globally
disabled interrupt line.

This patch disables interrupts (and Rx/Tx) during suspend.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

---

diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25/drivers/net/via-rhine.c linux-2.6.25-feanor/drivers/net/via-rhine.c
--- linux-2.6.25/drivers/net/via-rhine.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-feanor/drivers/net/via-rhine.c	2008-04-26 14:08:44.000000000 +0200
@@ -1886,6 +1886,15 @@ static void rhine_shutdown (struct pci_d
 	struct rhine_private *rp = netdev_priv(dev);
 	void __iomem *ioaddr = rp->base;
 
+	/* Switch to loopback mode to avoid hardware races. */
+	iowrite8(rp->tx_thresh | 0x02, ioaddr + TxConfig);
+
+	/* Disable interrupts by clearing the interrupt mask. */
+	iowrite16(0x0000, ioaddr + IntrEnable);
+
+	/* Stop the chip's Tx and Rx processes. */
+	iowrite16(CmdStop, ioaddr + ChipCmd);
+
 	if (!(rp->quirks & rqWOL))
 		return; /* Nothing to do for non-WOL adapters */
 
