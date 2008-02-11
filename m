Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbYBKUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbYBKUIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYBKUH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:07:58 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:26683 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBKUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:07:57 -0500
Message-ID: <47B0AB0B.806@chelsio.com>
Date: Mon, 11 Feb 2008 12:07:39 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver updates
References: <20080211170516.GA13872@havoc.gtf.org>
In-Reply-To: <20080211170516.GA13872@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2008 20:06:40.0015 (UTC) FILETIME=[9D2C11F0:01C86CE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mostly fixes, a few cleanups (generally assisting fixes), and an
> exception for PS3 wireless because it had been posted, reviewed and
> acked for a while, just not committed.
>
> Please pull from 'upstream-davem' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-davem
>
> to receive the following updates:
>
>  
>  drivers/net/cxgb3/sge.c          |   35 +-
>   
>  
> diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
> index 9ca8c66..979f3fc 100644
> --- a/drivers/net/cxgb3/sge.c
> +++ b/drivers/net/cxgb3/sge.c
> @@ -1059,6 +1059,14 @@ static void write_tx_pkt_wr(struct adapter *adap, struct sk_buff *skb,
>  			 htonl(V_WR_TID(q->token)));
>  }
>  
> +static inline void t3_stop_queue(struct net_device *dev, struct sge_qset *qs,
> +				 struct sge_txq *q)
> +{
> +	netif_stop_queue(dev);
> +	set_bit(TXQ_ETH, &qs->txq_stopped);
> +	q->stops++;
> +}
> +
>  /**
>   *	eth_xmit - add a packet to the Ethernet Tx queue
>   *	@skb: the packet
> @@ -1090,31 +1098,18 @@ int t3_eth_xmit(struct sk_buff *skb, struct net_device *dev)
>  	ndesc = calc_tx_descs(skb);
>  
>  	if (unlikely(credits < ndesc)) {
> -		if (!netif_queue_stopped(dev)) {
> -			netif_stop_queue(dev);
> -			set_bit(TXQ_ETH, &qs->txq_stopped);
> -			q->stops++;
> -			dev_err(&adap->pdev->dev,
> -				"%s: Tx ring %u full while queue awake!\n",
> -				dev->name, q->cntxt_id & 7);
> -		}
> +		t3_stop_queue(dev, qs, q);
> +		dev_err(&adap->pdev->dev,
> +			"%s: Tx ring %u full while queue awake!\n",
> +			dev->name, q->cntxt_id & 7);
>  		spin_unlock(&q->lock);
>  		return NETDEV_TX_BUSY;
>  	}
>  
>  	q->in_use += ndesc;
> -	if (unlikely(credits - ndesc < q->stop_thres)) {
> -		q->stops++;
> -		netif_stop_queue(dev);
> -		set_bit(TXQ_ETH, &qs->txq_stopped);
> -#if !USE_GTS
> -		if (should_restart_tx(q) &&
> -		    test_and_clear_bit(TXQ_ETH, &qs->txq_stopped)) {
> -			q->restarts++;
> -			netif_wake_queue(dev);
> -		}
> -#endif
> -	}
> +	if (unlikely(credits - ndesc < q->stop_thres))
> +		if (USE_GTS || !should_restart_tx(q))
> +			t3_stop_queue(dev, qs, q);
>  
>  	gen = q->gen;
>  	q->unacked += ndesc;
>   
Hi Jeff,

I thought I had NAK'ed the patch modifying sge.c from Krishna Kumar.
Looking back at my answer at the time, I was obviously unclear.
Can you please revert the drivers/net/cxgb3sge.c change ?

Cheers,
Divy

