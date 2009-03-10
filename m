Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZCJBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZCJBO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZCJBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:14:49 -0400
Received: from static-72-66-92-28.washdc.fios.verizon.net ([72.66.92.28]:4897
	"EHLO mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZCJBOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:14:47 -0400
X-Greylist: delayed 1839 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 21:14:47 EDT
Date: Mon, 9 Mar 2009 20:43:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090310004344.GA23466@hash.localnet>
References: <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226135938.GA12182@hash.localnet> <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B38FB7.3000002@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 10:28:23AM +0100, Jiri Slaby wrote:
>> If you want I'll cook up a patch for that too.
>
> If you like, feel free to kick it off. Remember to remove bf->flags  
> completely, so that we save another bunch of memory ;).

Ok, here's a patch, it survived a few hours of testing with 3 rx buffers.
Sitsofe, it's worth a try applying this one, even though it probably
isn't it :)

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 9 Mar 2009 11:29:34 -0400
Subject: [PATCH] ath5k: use rx hw descriptor pointer for self-linked check

This patch simplifies the code used to detect when the
self-linked DMA buffer is still in use by hardware, by
checking the hardware's rxdp register instead of looking
at the software buffer list.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   24 ++++--------------------
 drivers/net/wireless/ath5k/base.h |    1 -
 drivers/net/wireless/ath5k/dma.c  |    2 --
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1d77ee9..a4e385b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1677,7 +1677,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
 	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_buf *bf, *bf_last;
+	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
 	int hdrlen;
@@ -1688,7 +1688,6 @@ ath5k_tasklet_rx(unsigned long data)
 		ATH5K_WARN(sc, "empty rx buf pool\n");
 		goto unlock;
 	}
-	bf_last = list_entry(sc->rxbuf.prev, struct ath5k_buf, list);
 	do {
 		rxs.flag = 0;
 
@@ -1697,24 +1696,9 @@ ath5k_tasklet_rx(unsigned long data)
 		skb = bf->skb;
 		ds = bf->desc;
 
-		/*
-		 * last buffer must not be freed to ensure proper hardware
-		 * function. When the hardware finishes also a packet next to
-		 * it, we are sure, it doesn't use it anymore and we can go on.
-		 */
-		if (bf_last == bf)
-			bf->flags |= 1;
-		if (bf->flags) {
-			struct ath5k_buf *bf_next = list_entry(bf->list.next,
-					struct ath5k_buf, list);
-			ret = sc->ah->ah_proc_rx_desc(sc->ah, bf_next->desc,
-					&rs);
-			if (ret)
-				break;
-			bf->flags &= ~1;
-			/* skip the overwritten one (even status is martian) */
-			goto next;
-		}
+		/* bail if HW is still using self-linked descriptor */
+		if (ath5k_hw_get_rxdp(sc->ah) == bf->daddr)
+			break;
 
 		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);
 		if (unlikely(ret == -EINPROGRESS))
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index facc60d..ed407cc 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -56,7 +56,6 @@
 
 struct ath5k_buf {
 	struct list_head	list;
-	unsigned int		flags;	/* rx descriptor flags */
 	struct ath5k_desc	*desc;	/* virtual addr of desc */
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath5k/dma.c
index b65b4fe..941b511 100644
--- a/drivers/net/wireless/ath5k/dma.c
+++ b/drivers/net/wireless/ath5k/dma.c
@@ -80,8 +80,6 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
  * ath5k_hw_get_rxdp - Get RX Descriptor's address
  *
  * @ah: The &struct ath5k_hw
- *
- * XXX: Is RXDP read and clear ?
  */
 u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
 {
-- 
1.6.0.6


-- 
Bob Copeland %% www.bobcopeland.com

