Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZJHFQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZJHFQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZJHFQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:16:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32978
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbZJHFQA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:16:00 -0400
Date: Wed, 07 Oct 2009 22:15:55 -0700 (PDT)
Message-Id: <20091007.221555.71697986.davem@davemloft.net>
To: vapier.adi@gmail.com
Cc: michael.hennerich@analog.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, strakh@ispras.ru,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [BUG] znet.c sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <8bd0f97a0910071144k1d0bf30bv60656181edae8af7@mail.gmail.com>
References: <200910071847.38163.strakh@ispras.ru>
	<8bd0f97a0910071144k1d0bf30bv60656181edae8af7@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 7 Oct 2009 14:44:45 -0400

> On Wed, Oct 7, 2009 at 14:47, Alexander Strakh wrote:
>>        KERNEL_VERSION: 2.6.31
>>        DESCRIBE:
>> Driver drivers/net/znet.c might sleep in atomic context, because it calls
>> free_dma under claim_dma_lock:
>>
>> .drivers/net/znet.c:
>>  168 static int znet_request_resources (struct net_device *dev)
>> ...
>>  189        flags = claim_dma_lock();
>>  190        free_dma (znet->tx_dma);
>>  191        release_dma_lock (flags);
>> ...
>>
>> Path to might_sleep macro from znet_request_resources:
>> 1. znet_request_resources calls free_dma at
>> arch/blackfin/kernel/bfin_dma_5xx.c:181
>> 2. free_dma calls arch/blackfin/kernel/bfin_dma_5xx.c:195
> 
> i dont think we need the dmalock mutex.  it's only used to protect
> read/writes to .chan_status, and that should be atomic already.
> -mike

I'm checking in the obvious fix to net-2.6, thanks for the report:

znet: Don't claim DMA lock around free_dma() calls.

It's not necessary and it's illegal too.

Reported-by: Alexander Strakh <strakh@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/znet.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/znet.c b/drivers/net/znet.c
index a0384b6..b423473 100644
--- a/drivers/net/znet.c
+++ b/drivers/net/znet.c
@@ -169,7 +169,6 @@ static void znet_tx_timeout (struct net_device *dev);
 static int znet_request_resources (struct net_device *dev)
 {
 	struct znet_private *znet = netdev_priv(dev);
-	unsigned long flags;
 
 	if (request_irq (dev->irq, &znet_interrupt, 0, "ZNet", dev))
 		goto failed;
@@ -187,13 +186,9 @@ static int znet_request_resources (struct net_device *dev)
  free_sia:
 	release_region (znet->sia_base, znet->sia_size);
  free_tx_dma:
-	flags = claim_dma_lock();
 	free_dma (znet->tx_dma);
-	release_dma_lock (flags);
  free_rx_dma:
-	flags = claim_dma_lock();
 	free_dma (znet->rx_dma);
-	release_dma_lock (flags);
  free_irq:
 	free_irq (dev->irq, dev);
  failed:
@@ -203,14 +198,11 @@ static int znet_request_resources (struct net_device *dev)
 static void znet_release_resources (struct net_device *dev)
 {
 	struct znet_private *znet = netdev_priv(dev);
-	unsigned long flags;
 
 	release_region (znet->sia_base, znet->sia_size);
 	release_region (dev->base_addr, znet->io_size);
-	flags = claim_dma_lock();
 	free_dma (znet->tx_dma);
 	free_dma (znet->rx_dma);
-	release_dma_lock (flags);
 	free_irq (dev->irq, dev);
 }
 
-- 
1.6.4.4

