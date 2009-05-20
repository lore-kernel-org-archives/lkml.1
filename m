Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZETVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZETVom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZETVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:44:35 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:36839 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZETVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:44:34 -0400
Date: Wed, 20 May 2009 23:47:34 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Michael Guntsche <mike@it-loops.com>, afleming@freescale.com
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       davem@davemloft.net
Subject: Re: [BUG] 2.6.30-rc4: Kernel BUG under network load with gianfar
Message-ID: <20090520214734.GA11277@mail.wantstofly.org>
References: <50F164E7-D247-4FD6-B41B-BDAA8681166B@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F164E7-D247-4FD6-B41B-BDAA8681166B@it-loops.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 03:36:27PM +0200, Michael Guntsche wrote:

> I recently tried 2.6.30-rc4 on a routerboard currently running 2.6.29  
> (it is running stable with this kernel).
> 
> This board is used as a gateway and under load I see the following BUG  
> with 2.6.30-rc4.
> 
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:126!
> Oops: Exception in kernel mode, sig: 5 [#1]
> MikroTik RouterBOARD 600 series
> Modules linked in: nf_nat_rtsp nf_conntrack_rtsp
> NIP: c01abc68 LR: c01abc68 CTR: c015559c
> REGS: c7aa7b20 TRAP: 0700   Not tainted  (2.6.30-rc4)
> MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24002424  XER: 20000000
> TASK = c7855bc0[588] 'pptpgw' THREAD: c7aa6000
> GPR00: c01abc68 c7aa7bd0 c7855bc0 00000085 0000295e ffffffff c0152b68  
> 00000030
> GPR08: c03848d4 c0350000 0000295e c0380398 84002422 10029614 100de49c  
> 100e0000
> GPR16: 100b45a0 00000040 c02f6260 c02f628c c7846380 c7aa6000 c7957800  
> 00000000
> GPR24: 00000002 0000003e c7a12480 c7957a00 c7846000 000005e6 c7956240  
> c7a8b880
> NIP [c01abc68] skb_over_panic+0x48/0x5c
> LR [c01abc68] skb_over_panic+0x48/0x5c
> Call Trace:
> [c7aa7bd0] [c01abc68] skb_over_panic+0x48/0x5c (unreliable)
> [c7aa7be0] [c01ad468] skb_put+0x5c/0x60

gianfar puts skbuffs that are in the rx ring back onto the recycle
list if there was a receive error, but this breaks the following
invariant: that all skbuffs on the recycle list have skb->data =
skb->head + NET_SKB_PAD (NET_SKB_PAD being 32 for you).

In this case, the skb's ->data will be skb->head + RXBUF_ALIGNMENT
(where RXBUF_ALIGNMENT is 64) when it is put onto the recycle list.
And when gfar_new_skb() picks this skb off the recycle list again,
it'll do:

        alignamount = RXBUF_ALIGNMENT -
                (((unsigned long) skb->data) & (RXBUF_ALIGNMENT - 1));

        /* We need the data buffer to be aligned properly.  We will reserve
         * as many bytes as needed to align the data properly
         */
        skb_reserve(skb, alignamount);

So now skb->data will be skb->head + 128, and there won't be enough
space between skb->head and skb->end to hold a full-sized packet.

Something like the patch below would fix it.

(Or, one could change the RXBUF_ALIGNMENT code to be idempotent (i.e.
do nothing if skb->data is already aligned), that'd fix it too -- but
you'll want to stick a big fat comment a la "this is subtle" somewhere
in that case.)


diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index b2c4967..85883c7 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1886,7 +1886,7 @@ int gfar_clean_rx_ring(struct net_device *dev, int rx_work_limit)
 			if (unlikely(!newskb))
 				newskb = skb;
 			else if (skb)
-				__skb_queue_head(&priv->rx_recycle, skb);
+				dev_kfree_skb_any(skb);
 		} else {
 			/* Increment the number of packets */
 			dev->stats.rx_packets++;
