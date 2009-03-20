Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZCTNpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZCTNpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCTNo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:44:59 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3313 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCTNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:44:59 -0400
X-Greylist: delayed 1813 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 09:44:59 EDT
Date: Fri, 20 Mar 2009 09:14:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090320131437.GA30120@hash.localnet>
References: <20090226170338.GA1745@silver.sucs.org> <20090303041222.GA1238@hash.localnet> <20090303200352.GA8343@silver.sucs.org> <20090304120759.GA6519@hash.localnet> <20090306094249.GA10236@silver.sucs.org> <20090308030928.GB14966@hash.localnet> <49B38FB7.3000002@gmail.com> <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313095213.GA14250@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 09:52:13AM +0000, Sitsofe Wheeler wrote:
> The dmesg and trace can be found on
> http://sucs.org/~sits/test/eeepc-debug/20090313/ .

Looks like the skb was reused right after it was freed by the mac80211
workqueue so that seems inline with the idea that the list is getting
corrupted somehow.  On top of the last patch, would you mind running 
this overnight?  It'll dump a lot of debug info, I'm really only 
interested in the last 5 invocations of ath5k_debug_printrxbuffs or so
before the poison.  During a scan you'll see lots of rx_start/rx_stop.

Hmm, I can think of another scenario that could break: if the hw updated
rxdp before DMA completes, then we should check next packet's status too
in case 'current' packet's status is clobbered.

Someone suggested dumping the self links and deal with RXEOL, maybe a 
good idea :)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index a4e385b..e21705c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1143,8 +1143,10 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	if (!skb) {
 		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
-		if (!skb)
+		if (!skb) {
+			printk(KERN_DEBUG "ath5k: error exit from rxbuf_setup\n");
 			return -ENOMEM;
+		}
 		bf->skb = skb;
 	}
 
@@ -1561,6 +1563,8 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	ath5k_mode_setup(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
+        printk(KERN_DEBUG "ath5k: rx_start\n");
+
 	return 0;
 err:
 	return ret;
@@ -1578,8 +1582,7 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
 	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
 
-	ath5k_debug_printrxbuffs(sc, ah);
-
+        printk(KERN_DEBUG "ath5k: rx_stop\n");
 	sc->rxlink = NULL;		/* just in case */
 }
 
@@ -1682,6 +1685,7 @@ ath5k_tasklet_rx(unsigned long data)
 	int ret;
 	int hdrlen;
 	int padsize;
+	static int foo=0;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1689,6 +1693,10 @@ ath5k_tasklet_rx(unsigned long data)
 		goto unlock;
 	}
 	do {
+		/* dump list state every 8 pkts */
+		if (!(foo++ & 7))
+			ath5k_debug_printrxbuffs(sc, sc->ah);
+
 		rxs.flag = 0;
 
 		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
@@ -2308,6 +2316,8 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	} else
 		sc->rxlink = NULL;
 
+        printk(KERN_DEBUG "ath5k: rx_stop_locked\n");
+
 	return 0;
 }
 
@@ -2430,6 +2440,8 @@ ath5k_intr(int irq, void *dev_id)
 				*     least on older hardware revs.
 				*/
 				sc->rxlink = NULL;
+                                printk(KERN_DEBUG "ath5k: RXEOL\n");
+
 			}
 			if (status & AR5K_INT_TXURN) {
 				/* bump tx trigger level */
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index ccaeb5c..c544da5 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -505,7 +505,8 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
 	struct ath5k_desc *ds = bf->desc;
 	struct ath5k_hw_all_rx_desc *rd = &ds->ud.ds_rx;
 
-	printk(KERN_DEBUG "R (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
+	printk(KERN_DEBUG "R %p (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
+                bf, 
 		ds, (unsigned long long)bf->daddr,
 		ds->ds_link, ds->ds_data,
 		rd->rx_ctl.rx_control_0, rd->rx_ctl.rx_control_1,
@@ -518,23 +519,18 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
-	struct ath5k_rx_status rs = {};
+	struct ath5k_rx_status rs;
 	int status;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
-		return;
-
 	printk(KERN_DEBUG "rx queue %x, link %p\n",
 		ath5k_hw_get_rxdp(ah), sc->rxlink);
 
-	spin_lock_bh(&sc->rxbuflock);
 	list_for_each_entry(bf, &sc->rxbuf, list) {
 		ds = bf->desc;
+                memset(&rs, 0, sizeof(struct ath5k_rx_status));
 		status = ah->ah_proc_rx_desc(ah, ds, &rs);
-		if (!status)
-			ath5k_debug_printrxbuf(bf, status == 0, &rs);
+		ath5k_debug_printrxbuf(bf, status == 0, &rs);
 	}
-	spin_unlock_bh(&sc->rxbuflock);
 }
 
 void

-- 
Bob Copeland %% www.bobcopeland.com

