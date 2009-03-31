Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbZCaX1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbZCaX1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZCaXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:47 -0400
Received: from sous-sol.org ([216.99.217.87]:33192 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762286AbZCaXUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:45 -0400
Message-Id: <20090331231529.702818311@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 18/45] ath9k: fix dma mapping leak of rx buffer upon rmmod
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ath9k-fix-dma-mapping-leak-of-rx-buffer-upon-rmmod.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

upstream commit: 051b919188650fe4c93ca8701183ae88439388f6

We were claiming DMA buffers on the RX tasklet but never
upon a simple module removal.

Cc: stable@kernel.org
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/ath9k/recv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -322,8 +322,13 @@ void ath_rx_cleanup(struct ath_softc *sc
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		skb = bf->bf_mpdu;
-		if (skb)
+		if (skb) {
+			pci_unmap_single(sc->pdev,
+					 bf->bf_buf_addr,
+					 sc->rx.bufsize,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
+		}
 	}
 
 	if (sc->rx.rxdma.dd_desc_len != 0)

