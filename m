Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZAIXbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZAIXbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZAIXbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:31:08 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:57683 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345AbZAIXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version
         :content-type:from;
        b=xTr7z0eWhiiIWsL/Jp76WarQ8yn5BV9HadRxLoqELWNVa2piQiH113yhxZ+IUMFf44
         sfiIgDGdOdfCslyNNIwsQ50chZzbV+rPyXuX7fiXpb9bafEI1czEm4tLsO+qL5MEAgLK
         Pp4w4nsvK8r3URKwSxQu/yqrWmClNfklRnXwg=
Date: Fri, 9 Jan 2009 18:30:58 -0500 (EST)
X-X-Sender: parag@localhost.localdomain
To: shemminger@vyatta.com
cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix net/irda build breakage
Message-ID: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: Parag Warudkar <parag.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit af0490810cfa159b4894ddecfc5eb2e4432fb976 breaks build for net/irda -

drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member named 'stats'
make[3]: *** [drivers/net/irda/donauboe.o] Error 1
make[2]: *** [drivers/net/irda] Error 2

Fix this.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 687c2d5..5acb8b2 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -1194,13 +1194,13 @@ toshoboe_interrupt (int irq, void *dev_id)
                txp = txpc;
                txpc++;
                txpc %= TX_SLOTS;
-              self->stats.tx_packets++;
+		self->netdev->stats.tx_packets++;
                if (self->ring->tx[txpc].control & OBOE_CTL_TX_HW_OWNS)
                    self->ring->tx[txp].control &= ~OBOE_CTL_TX_RTCENTX;
              }
-          self->stats.tx_packets--;
+		self->netdev->stats.tx_packets--;
  #else
-          self->stats.tx_packets++;
+		self->netdev->stats.tx_packets++;
  #endif
            toshoboe_start_DMA(self, OBOE_CONFIG0H_ENTX);
          }
@@ -1280,7 +1280,7 @@ dumpbufs(self->rx_bufs[self->rxs],len,'<');
                        skb_put (skb, len);
                        skb_copy_to_linear_data(skb, self->rx_bufs[self->rxs],
  					      len);
-                      self->stats.rx_packets++;
+			self->netdev->stats.rx_packets++;
                        skb->dev = self->netdev;
                        skb_reset_mac_header(skb);
                        skb->protocol = htons (ETH_P_IRDA);
