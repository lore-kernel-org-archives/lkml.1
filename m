Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZAKSTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZAKSTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZAKSTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:19:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZAKSTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:19:46 -0500
Date: Sun, 11 Jan 2009 19:19:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc1
Message-ID: <20090111181933.GB9568@elte.hu>
References: <200901111740.01991.schmto@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901111740.01991.schmto@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de> wrote:

> Hello,
> 
> On Sat, 10 Jan 2009 16:13:02 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > The merge window is over, and while it is quite possible that I missed a 
> > few merge requests in the crazy week that is behind us, apart from those 
> > we should now have most of the bulk of 2.6.29 merged up. And now it's
> > just a small matter of making sure it's all stable and ready to go.
> > 
> 
> I've got a compiler error in 'drivers/net/irda/donauboe.c':
> 
> drivers/net/irda/donauboe.c: In function ‘toshoboe_interrupt’:
> drivers/net/irda/donauboe.c:1197: error: ‘struct toshoboe_cb’ has no member 
> named ‘stats’
> drivers/net/irda/donauboe.c:1201: error: ‘struct toshoboe_cb’ has no member 
> named ‘stats’
> drivers/net/irda/donauboe.c:1283: error: ‘struct toshoboe_cb’ has no member 
> named ‘stats’
> make[3]: *** [drivers/net/irda/donauboe.o] Error 1
> make[2]: *** [drivers/net/irda] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

known issue fixed in the networking tree - the (different commit ID) fix 
i'm using is the one below.

	Ingo

------------->
>From a5532d29c1ade8b4576f449d4e40678490b96594 Mon Sep 17 00:00:00 2001
From: Parag Warudkar <parag.lkml@gmail.com>
Date: Fri, 9 Jan 2009 18:30:58 -0500
Subject: [PATCH] Fix net/irda build breakage

commit af0490810cfa159b4894ddecfc5eb2e4432fb976 breaks build for net/irda -

drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member named 'stats'
make[3]: *** [drivers/net/irda/donauboe.o] Error 1
make[2]: *** [drivers/net/irda] Error 2

Fix this.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: davem@davemloft.net
Cc: shemminger@vyatta.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/donauboe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 687c2d5..6f3e7f7 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -1194,13 +1194,13 @@ toshoboe_interrupt (int irq, void *dev_id)
               txp = txpc;
               txpc++;
               txpc %= TX_SLOTS;
-              self->stats.tx_packets++;
+              self->netdev->stats.tx_packets++;
               if (self->ring->tx[txpc].control & OBOE_CTL_TX_HW_OWNS)
                   self->ring->tx[txp].control &= ~OBOE_CTL_TX_RTCENTX;
             }
-          self->stats.tx_packets--;
+          self->netdev->stats.tx_packets--;
 #else
-          self->stats.tx_packets++;
+          self->netdev->stats.tx_packets++;
 #endif
           toshoboe_start_DMA(self, OBOE_CONFIG0H_ENTX);
         }
@@ -1280,7 +1280,7 @@ dumpbufs(self->rx_bufs[self->rxs],len,'<');
                       skb_put (skb, len);
                       skb_copy_to_linear_data(skb, self->rx_bufs[self->rxs],
 					      len);
-                      self->stats.rx_packets++;
+                      self->netdev->stats.rx_packets++;
                       skb->dev = self->netdev;
                       skb_reset_mac_header(skb);
                       skb->protocol = htons (ETH_P_IRDA);
