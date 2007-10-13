Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbXJMH3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbXJMH3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXJMH3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:29:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51029 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbXJMH26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:28:58 -0400
Date: Sat, 13 Oct 2007 08:28:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fallout from ->get_stats patches
Message-ID: <20071013072849.GG8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/macmace.c b/drivers/net/macmace.c
index 6589239..1877052 100644
--- a/drivers/net/macmace.c
+++ b/drivers/net/macmace.c
@@ -538,8 +538,9 @@ static void mace_set_multicast(struct net_device *dev)
 	local_irq_restore(flags);
 }
 
-static void mace_handle_misc_intrs(struct mace_data *mp, int intr)
+static void mace_handle_misc_intrs(struct net_device *dev, int intr)
 {
+	struct mace_data *mp = netdev_priv(dev);
 	volatile struct mace *mb = mp->mace;
 	static int mace_babbles, mace_jabbers;
 
@@ -571,7 +572,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
 	local_irq_save(flags);
 
 	intr = mb->ir; /* read interrupt register */
-	mace_handle_misc_intrs(mp, intr);
+	mace_handle_misc_intrs(dev, intr);
 
 	if (intr & XMTINT) {
 		fs = mb->xmtfs;
@@ -645,7 +646,6 @@ static void mace_tx_timeout(struct net_device *dev)
 
 static void mace_dma_rx_frame(struct net_device *dev, struct mace_frame *mf)
 {
-	struct mace_data *mp = netdev_priv(dev);
 	struct sk_buff *skb;
 	unsigned int frame_status = mf->rcvsts;
 
diff --git a/drivers/net/mvme147.c b/drivers/net/mvme147.c
index 86c9c06..06ca425 100644
--- a/drivers/net/mvme147.c
+++ b/drivers/net/mvme147.c
@@ -85,7 +85,6 @@ struct net_device * __init mvme147lance_probe(int unit)
 	dev->open = &m147lance_open;
 	dev->stop = &m147lance_close;
 	dev->hard_start_xmit = &lance_start_xmit;
-	dev->get_stats = &lance_get_stats;
 	dev->set_multicast_list = &lance_set_multicast;
 	dev->tx_timeout = &lance_tx_timeout;
 	dev->dma = 0;
