Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0CKT7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:59:12 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3990 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0CKT7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:59:08 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
From: "Michael Chan" <mchan@broadcom.com>
To: "Brian Haley" <brian.haley@hp.com>
cc: "David Miller" <davem@davemloft.net>,
       "bonbons@linux-vserver.org" <bonbons@linux-vserver.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B994714.2040108@hp.com>
References: <1268263973.9775.95.camel@nseg_linux_HP1.broadcom.com>
 <4B9850DC.9060703@hp.com>
 <1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com>
 <20100311.100519.124285161.davem@davemloft.net>
 <1268332738.9775.133.camel@nseg_linux_HP1.broadcom.com>
 <4B994714.2040108@hp.com>
Date: Thu, 11 Mar 2010 11:47:28 -0800
Message-ID: <1268336848.9775.154.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6787940E31G56778043-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-03-11 at 11:40 -0800, Brian Haley wrote:
> I can only reproduce this on one system out of many, so it's either a
> race condition or bad hardware.  The only thing I can confirm at the
> moment is that it's the code at the bottom of bnx2_set_coalesce()
> that's causing it, I'm trying to go through all those codepaths now.
> 

The NETDEV WATCHDOG is caused by stopping the TX queues with
->trans_start older than dev->watchdog_timeo which is set to 5 seconds
in bnx2.  Please try this patch below to update the ->trans_start first
before stopping the TX queues:

diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index d3f739a..c0f4aa7 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -656,7 +656,6 @@ bnx2_netif_stop(struct bnx2 *bp)
 		int i;
 
 		bnx2_napi_disable(bp);
-		netif_tx_disable(bp->dev);
 		/* prevent tx timeout */
 		for (i = 0; i <  bp->dev->num_tx_queues; i++) {
 			struct netdev_queue *txq;
@@ -664,6 +663,7 @@ bnx2_netif_stop(struct bnx2 *bp)
 			txq = netdev_get_tx_queue(bp->dev, i);
 			txq->trans_start = jiffies;
 		}
+		netif_tx_disable(bp->dev);
 	}
 	bnx2_disable_int_sync(bp);
 }



