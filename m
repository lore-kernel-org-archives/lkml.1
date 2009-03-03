Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZCCEMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZCCEMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZCCEMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:12:32 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4898 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZCCEMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:12:31 -0500
Date: Mon, 2 Mar 2009 23:12:22 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090303041222.GA1238@hash.localnet>
References: <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226170338.GA1745@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 05:03:39PM +0000, Sitsofe Wheeler wrote:
> 
> Note that I was able to reproduce it again : )

By the way, here's the theoretical race I was alluding to.  ath5k_reset 
happens pretty frequently when scanning, and it's possible that the rx
tasklet is run on another cpu after interrupts are turned off, but
it's a small window and I couldn't trigger it with any mdelays.

[PATCH] ath5k: manipulate rxlink and descriptor address under rxbuf lock

Grabbing an ath5k_buf then dropping the lock is racy because the
referenced descriptor can be obtained in another thread and released
before the buffer is handed to the hardware.  Likewise, manipulating
sc->rxlink without the lock can lead to having multiple self-linked
hardware descriptors.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 8d4b11c..0d3adb5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1586,9 +1586,8 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
 		sc->cachelsz, sc->rxbufsize);
 
-	sc->rxlink = NULL;
-
 	spin_lock_bh(&sc->rxbuflock);
+	sc->rxlink = NULL;
 	list_for_each_entry(bf, &sc->rxbuf, list) {
 		ret = ath5k_rxbuf_setup(sc, bf);
 		if (ret != 0) {
@@ -1597,9 +1596,9 @@ ath5k_rx_start(struct ath5k_softc *sc)
 		}
 	}
 	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
+	ath5k_hw_set_rxdp(ah, bf->daddr);
 	spin_unlock_bh(&sc->rxbuflock);
 
-	ath5k_hw_set_rxdp(ah, bf->daddr);
 	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
 	ath5k_mode_setup(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
-- 
1.6.0.6



-- 
Bob Copeland %% www.bobcopeland.com

