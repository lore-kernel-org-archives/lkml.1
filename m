Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab0BZWM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 17:12:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:61116 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494Ab0BZWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 17:12:55 -0500
Message-ID: <4B884757.2070205@windriver.com>
Date: Fri, 26 Feb 2010 17:12:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Martyn Welch <martyn.welch@ge.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net
Subject: Re: Gianfar driver failing on MPC8641D based board
References: <20100225174935.GA32370@oksana.dev.rtsoft.ru> <7d1d9c251002251653n6473f01ex2d43933ec6aa010b@mail.gmail.com> <20100226031452.GA11319@oksana.dev.rtsoft.ru> <4B87B937.6010204@ge.com> <20100226143532.GA31622@oksana.dev.rtsoft.ru> <4B87E01E.4070704@windriver.com> <4B87E662.3080106@ge.com> <4B87E9EF.3010604@ge.com> <20100226161058.GA22954@oksana.dev.rtsoft.ru> <4B87F67E.5070601@windriver.com> <20100226213825.GA32363@oksana.dev.rtsoft.ru>
In-Reply-To: <20100226213825.GA32363@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2010 22:12:40.0418 (UTC) FILETIME=[CFAF8420:01CAB730]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-02-26 04:38 PM, Anton Vorontsov wrote:

> OK, I think I found what's happening in gianfar.
> 
> Some background...
> 
> start_xmit() prepares new skb for transmitting, generally it does
> three things:
> 
> 1. sets up all BDs (marks them ready to send), except the first one.
> 2. stores skb into tx_queue->tx_skbuff so that clean_tx_ring()
>     would cleanup it later.
> 3. sets up the first BD, i.e. marks it ready.
> 
> Here is what clean_tx_ring() does:
> 
> 1. reads skbs from tx_queue->tx_skbuff
> 2. Checks if the *last* BD is ready. If it's still ready [to send]
>     then it it isn't transmitted, so clean_tx_ring() returns.
>     Otherwise it actually cleanups BDs. All is OK.
> 
> Now, if there is just one BD, code flow:
> 
> - start_xmit(): stores skb into tx_skbuff. Note that the first BD
>    (which is also the last one) isn't marked as ready, yet.
> - clean_tx_ring(): sees that skb is not null, *and* its lstatus
>    says that it is NOT ready (like if BD was sent), so it cleans
>    it up (bad!)
> - start_xmit(): marks BD as ready [to send], but it's too late.
> 
> We can fix this simply by reordering lstatus/tx_skbuff writes.
> 
> It works flawlessly on my p2020, please try it.

I've skipped right to the test part (I'll think about the description
more later) and it passed 5 out of 5 boot tests on NFSroot sbc8641d.
Looks like you've got a solution.

Paul.

> 
> Thanks!
> 
> 
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index 8bd3c9f..cccb409 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -2021,7 +2021,6 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	}
> 
>   	/* setup the TxBD length and buffer pointer for the first BD */
> -	tx_queue->tx_skbuff[tx_queue->skb_curtx] = skb;
>   	txbdp_start->bufPtr = dma_map_single(&priv->ofdev->dev, skb->data,
>   			skb_headlen(skb), DMA_TO_DEVICE);
> 
> @@ -2053,6 +2052,10 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
> 
>   	txbdp_start->lstatus = lstatus;
> 
> +	eieio(); /* force lstatus write before tx_skbuff */
> +
> +	tx_queue->tx_skbuff[tx_queue->skb_curtx] = skb;
> +
>   	/* Update the current skb pointer to the next entry we will use
>   	 * (wrapping if necessary) */
>   	tx_queue->skb_curtx = (tx_queue->skb_curtx + 1)&

