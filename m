Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZEOEK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZEOEK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZEOEKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:10:14 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1240 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZEOEKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:10:12 -0400
Date: Fri, 15 May 2009 00:09:04 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090515040904.GA32357@hash.localnet>
References: <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513214416.GA4492@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 10:44:17PM +0100, Sitsofe Wheeler wrote:
> Could you repost the patches you wanted me to test with against the
> latest kernel?

This is too ugly to live, but I'd like to know if you can reproduce
with this patch.  If it still happens, then I guess it's back to
debugging patches.  I'd love to be able to replicate this here :(

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index a08bc8a..e01da34 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1143,6 +1143,13 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 }
 
 static int
+ath5k_rxbuf_requeue(struct ath5k_softc *sc, struct ath5k_buf *bf)
+{
+	list_move_tail(&bf->list, &sc->rxbuf);
+	return ath5k_rxbuf_setup(sc, bf);
+}
+
+static int
 ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_hw *ah = sc->ah;
@@ -1751,7 +1758,7 @@ ath5k_tasklet_rx(unsigned long data)
 		goto unlock;
 	}
 	bf_last = list_entry(sc->rxbuf.prev, struct ath5k_buf, list);
-	do {
+	for (;;) {
 		rxs.flag = 0;
 
 		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
@@ -1904,13 +1911,18 @@ accept:
 		if (sc->opmode == NL80211_IFTYPE_ADHOC)
 			ath5k_check_ibss_tsf(sc, skb, &rxs);
 
-		__ieee80211_rx(sc->hw, skb, &rxs);
-
 		bf->skb = next_skb;
 		bf->skbaddr = next_skb_addr;
+		if (ath5k_rxbuf_requeue(sc, bf))
+			break;
+
+		__ieee80211_rx(sc->hw, skb, &rxs);
+		continue;
 next:
-		list_move_tail(&bf->list, &sc->rxbuf);
-	} while (ath5k_rxbuf_setup(sc, bf) == 0);
+		if (ath5k_rxbuf_requeue(sc, bf))
+			break;
+	}
+
 unlock:
 	spin_unlock(&sc->rxbuflock);
 }

-- 
Bob Copeland %% www.bobcopeland.com

