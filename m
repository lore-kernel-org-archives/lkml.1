Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZIKAdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZIKAdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZIKAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:33:38 -0400
Received: from kroah.org ([198.145.64.141]:38026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZIKA25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:28:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.235687801@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/22] E100: fix interaction with swiotlb on X86.
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=e100-fix-interaction-with-swiotlb-on-x86.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Krzysztof Hałasa <khc@pm.waw.pl>

[ Upstream commit 6ff9c2e7fa8ca63a575792534b63c5092099c286 ]

E100 places it's RX packet descriptors inside skb->data and uses them
with bidirectional streaming DMA mapping. Data in descriptors is
accessed simultaneously by the chip (writing status and size when
a packet is received) and CPU (reading to check if the packet was
received). This isn't a valid usage of PCI DMA API, which requires use
of the coherent (consistent) memory for such purpose. Unfortunately e100
chips working in "simplified" RX mode have to store received data
directly after the descriptor. Fixing the driver to conform to the API
would require using unsupported "flexible" RX mode or receiving data
into a coherent memory and using CPU to copy it to network buffers.

This patch, while not yet making the driver conform to the PCI DMA API,
allows it to work correctly on X86 with swiotlb (while not breaking
other architectures).

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/e100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1764,7 +1764,7 @@ static int e100_rx_indicate(struct nic *
 				nic->ru_running = RU_SUSPENDED;
 		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
 					       sizeof(struct rfd),
-					       PCI_DMA_BIDIRECTIONAL);
+					       PCI_DMA_FROMDEVICE);
 		return -ENODATA;
 	}
 


