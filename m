Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXAWQ7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXAWQ7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 11:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXAWQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 11:59:08 -0500
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3351 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933006AbXAWQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 11:59:07 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 11:59:07 EST
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 23 Jan 2007 09:52:25 -0700
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Thibaut VARENE <T-Bone@parisc-linux.org>, Jarek Poplawski <jarkao2@o2.pl>,
       mlachwani@mvista.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs
Message-ID: <20070123165225.GA20153@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Dale Farnsworth <dale@farnsworth.org>

mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs

This bug was found and isolated by Thibaut VARENE <T-Bone@parisc-linux.org>
and Jarek Poplawski <jarkao2@o2.pl>.  This patch is a modification of their
fixes.  We acquire and release the lock for each descriptor that is freed
to minimize the time the lock is held.

---

 drivers/net/mv643xx_eth.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index c41ae42..b3bf864 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -314,6 +314,13 @@ int mv643xx_eth_free_tx_descs(struct net
 
 	while (mp->tx_desc_count > 0) {
 		spin_lock_irqsave(&mp->lock, flags);
+
+		/* tx_desc_count might have changed before acquiring the lock */
+		if (mp->tx_desc_count <= 0) {
+			spin_unlock_irqrestore(&mp->lock, flags);
+			return released;
+		}
+
 		tx_index = mp->tx_used_desc_q;
 		desc = &mp->p_tx_desc_area[tx_index];
 		cmd_sts = desc->cmd_sts;
@@ -332,13 +339,13 @@ int mv643xx_eth_free_tx_descs(struct net
 		if (skb)
 			mp->tx_skb[tx_index] = NULL;
 
-		spin_unlock_irqrestore(&mp->lock, flags);
-
 		if (cmd_sts & ETH_ERROR_SUMMARY) {
 			printk("%s: Error in TX\n", dev->name);
 			mp->stats.tx_errors++;
 		}
 
+		spin_unlock_irqrestore(&mp->lock, flags);
+
 		if (cmd_sts & ETH_TX_FIRST_DESC)
 			dma_unmap_single(NULL, addr, count, DMA_TO_DEVICE);
 		else
