Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYFUKV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYFUKV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFUKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:21:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:38422 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYFUKVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:21:44 -0400
Subject: [PATCH] e100: Do pci_dma_sync after skb_alloc for proper operation
	on ixp4xx
From: Kevin Hao <kexin.hao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, john.ronciak@intel.com, dacker@roinet.com,
       e1000-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-net@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jun 2008 18:20:35 +0800
Message-Id: <1214043635.12484.8.camel@hkx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
X-OriginalArrivalTime: 21 Jun 2008 10:20:41.0156 (UTC) FILETIME=[74F93040:01C8D388]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The E100 device can't work on current kernel (2.6.26-rc6) and will cause
kernel corruption on intel ixdp4xx. This patch fix this regression.

---
commit c1f24812b9de182a4272724a2e84ea1ae5dd4659
Author: Kevin Hao <kexin.hao@windriver.com>
Date:   Sat Jun 21 16:50:50 2008 +0800

    e100: Do pci_dma_sync after skb_alloc for proper operation on ixp4xx
    
    Do a DMA sync after we've allocated a new skb and link it with the previous
    RFD.  Otherwise the previous RFD may reference the previously freed skb
    and cause kernel corruption.
    
    Previously there was such a DMA sync at this place, but it was removed
    by commit 7734f6e6bcd7ba78b00e93e74a4ddafd9886cdea.
    Restoring this sync operation eliminates the regression.
    
    Signed-off-by: Kevin Hao <kexin.hao@windriver.com>

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index f3cba5e..1037b13 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1803,6 +1803,8 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
 		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
+		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
+			sizeof(struct rfd), PCI_DMA_TODEVICE);
 	}
 
 	return 0;
---

Best Regards,
Kevin

