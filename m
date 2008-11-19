Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbYKSBej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbYKSBej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYKSBe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:34:27 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:39193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYKSBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:34:26 -0500
Subject: Re: pull request: wireless-2.6 2008-11-18
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081119000719.GA19756@tuxdriver.com> (sfid-20081119_014629_475391_D51592F4)
References: <20081119000719.GA19756@tuxdriver.com>
	 (sfid-20081119_014629_475391_D51592F4)
Content-Type: text/plain
Date: Wed, 19 Nov 2008 02:33:38 +0100
Message-Id: <1227058418.4014.99.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and a final one fixes some mysterious DMA alignment problems
> that have been plaguing iwlwifi for some time.


> The following changes since commit 5f9021cfdc3524a4c5e3d7ae2d049eb7adcd6776:
>   Johannes Berg (1):
>         rtnetlink: propagate error from dev_change_flags in do_setlink()

heh.

>      iwlagn: fix RX skb alignment

So Luis pointed out a bug in that, it might be useful to squish in this
patch: http://marc.info/?l=linux-wireless&m=122705425425763&w=2

(also below for reference)

But we can also just add it on top, whichever way you prefer.

johannes
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-19 01:16:12.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-19 01:19:13.000000000 +0100
@@ -1229,9 +1229,11 @@ void iwl_rx_handle(struct iwl_priv *priv
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->aligned_dma_addr,
-					    priv->hw_params.rx_buf_size,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_range_for_cpu(
+				&priv->pci_dev->dev, rxb->real_dma_addr,
+				rxb->aligned_dma_addr - rxb->real_dma_addr,
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response


