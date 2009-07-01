Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbZGABHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbZGABHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbZGAAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:21 -0400
Received: from kroah.org ([198.145.64.141]:60544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761514AbZGAAfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:36 2009
Message-Id: <20090701002435.938429664@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 072/108] ath9k: Fix memleak on TX DMA failure
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-memleak-on-tx-dma-failure.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit 675902ef822c114c0dac17ed10eed43eb8f5c9ec upstream.

The driver-specific region has to be freed in case
of a DMA mapping failure.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/xmit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1573,8 +1573,9 @@ static int ath_tx_setup_buffer(struct ie
 					   skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"dma_mapping_error() on TX\n");
+		kfree(tx_info_priv);
+		tx_info->rate_driver_data[0] = NULL;
+		DPRINTF(sc, ATH_DBG_FATAL, "dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 


