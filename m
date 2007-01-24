Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXAXHVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXAXHVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAXHVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:21:05 -0500
Received: from havoc.gtf.org ([69.61.125.42]:55407 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbXAXHVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:21:04 -0500
Date: Wed, 24 Jan 2007 02:21:02 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] net driver fix
Message-ID: <20070124072102.GA32093@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As the patch indicates, the Al Viro patch had already been merged into
my history (and another branch depending on it, making rebasing
difficult if not impossible), but since it was merged by Linus, the
actual patch isn't shown here by 'git diff'.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

to receive the following updates:

 drivers/net/mv643xx_eth.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

Al Viro (1):
      s2io bogus memset

Dale Farnsworth (1):
      mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs

diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index c41ae42..b3bf864 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -314,6 +314,13 @@ int mv643xx_eth_free_tx_descs(struct net_device *dev, int force)
 
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
@@ -332,13 +339,13 @@ int mv643xx_eth_free_tx_descs(struct net_device *dev, int force)
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
