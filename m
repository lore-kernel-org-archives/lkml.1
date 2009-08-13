Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZHMT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZHMT7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZHMT7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:15 -0400
Received: from kroah.org ([198.145.64.141]:41630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693AbZHMT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:25 2009
Message-Id: <20090813195125.088225988@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/74] E100: work around the driver using streaming DMA mapping for RX descriptors.
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=e100-work-around-the-driver-using-streaming-dma-mapping-for-rx-descriptors.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Krzysztof Halasa <khc@pm.waw.pl>

[ Upstream commit 303d67c288319768b19ed8dbed429fef7eb7c275 ]

E100 places it's RX packet descriptors inside skb->data and uses them
with bidirectional streaming DMA mapping. Unfortunately it fails to
transfer skb->data ownership to the device after it reads the
descriptor's status, breaking on non-coherent (e.g., ARM) platforms.

This have to be converted to use coherent memory for the descriptors.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/e100.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1762,6 +1762,9 @@ static int e100_rx_indicate(struct nic *
 
 			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
+		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
+					       sizeof(struct rfd),
+					       PCI_DMA_BIDIRECTIONAL);
 		return -ENODATA;
 	}
 


