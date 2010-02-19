Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0BSRD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:03:58 -0500
Received: from kroah.org ([198.145.64.141]:57847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab0BSRBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:17 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:55 2010
Message-Id: <20100219163255.411592876@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [88/93] ath9k: Fix sequence numbers for PAE frames
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit 6c8afef551fef87a3bf24f8a74c69a7f2f72fc82 upstream.

Currently, PAE frames are not assigned proper sequence numbers.
Since sending PAE frames as part of aggregates breaks
crupto with several APs, they are sent as normal MPDUs.
Fix the seqeuence number issue by updating the frame with the
internal sequence number.

Tested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1563,7 +1563,7 @@ static int ath_tx_setup_buffer(struct ie
 
 	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-	if (conf_is_ht(&sc->hw->conf) && !is_pae(skb))
+	if (conf_is_ht(&sc->hw->conf))
 		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
@@ -1648,7 +1648,7 @@ static void ath_tx_start_dma(struct ath_
 			goto tx_done;
 		}
 
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && !is_pae(skb)) {
 			/*
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.


