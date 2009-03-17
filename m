Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbZCQAgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbZCQAgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZCQAgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:36:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:60762 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbZCQAgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:36:37 -0400
Date: Tue, 17 Mar 2009 09:35:45 +0900
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Mar 2009 09:35:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 12:15:37 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> I've run into "PCI-DMA: Out of IOMMU space" messages after loading and
> unloading a module 30 times. The interesting thing is this only
> happens if I have > 4 GB of memory. The box this occurs has AMD Phenom
> quad core CPU so I take it a harware IOMMU is being used. Below are
> example relevant messages with > 4 GB and then < 4 GB of memory. The
> driver I tested this with was ath9k. It could be an issue perhaps with
> ath9k but I am unable to find an issue in our probe/removal.
> 
> Could this be an issue with the AMD IOMMU used? Or is it more likely a
> driver issue?

ath9k wants DMA_32BIT_MASK, right? If so, GART IOMMU does nothing on a
system with < 4GB memory since ath9k can access to all the memory
addresses directly. With >4GB memory, GART needs to remap an address
higher than 4GB because ath9k wants DMA_32BIT_MASK.

>From a quick look, ath9k doesn't call pci_unmap_single for rx
buffers. Though I might be wrong because I don't know anything about
the driver.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ath9k: fix dma mapping leak of rx buffer

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/net/wireless/ath9k/recv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 462e08c..cd2a1f6 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -322,8 +322,11 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		skb = bf->bf_mpdu;
-		if (skb)
+		if (skb) {
+			pci_unmap_single(sc->pdev, bf->bf_buf_addr,
+					 sc->rx.bufsize, PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(skb);
+		}
 	}
 
 	if (sc->rx.rxdma.dd_desc_len != 0)
-- 
1.6.0.6


