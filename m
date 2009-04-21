Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbZDUKb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbZDUKb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbZDUKbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:31:37 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:49933 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbZDUKbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:31:35 -0400
Message-ID: <49EDA040.5040600@cosmosbay.com>
Date: Tue, 21 Apr 2009 12:30:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Amos Kong <jianjun@zeuux.org>
CC: David Miller <davem@davemloft.net>, jon.lin@vatics.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
References: <0E04AEADD178614A86F3017CC5FA693B4959924809@MS.vivotek.tw> <20090421.015235.23457775.davem@davemloft.net> <20090421094825.GA6752@ubuntu>
In-Reply-To: <20090421094825.GA6752@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 21 Apr 2009 12:30:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong a écrit :
> ...
>>> Unfortunately, this address is used by Linux kernel. So kernel panics.
>>> This patch fix it by setting up DMA buffer address before RX enabled and everything is fine even under broadcast packets attack.
>>>
>>> Signed-off-by: Jonathan Lin <jon.lin@vatics.com>
>> This patch does not apply, it was corrupted by your email client.
>>
>> I even think it has MS-DOS style newlines in it :-(
> 
> Another new patch :)
> 
> 
>  While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
>  In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before setting up the DMA
>  buffer address. In this interval where RX was enabled and DMA buffer address is not yet set
>  up, any incoming broadcast packet would be send to a strange physical address:
>  0x003e8800 which is the default value of DMA buffer address.
>  Unfortunately, this address is used by Linux kernel. So kernel panics.
>  This patch fix it by setting up DMA buffer address before RX enabled and everything is fine
>  even under broadcast packets attack.
> 
> Signed-off-by: Jonathan Lin <jon.lin@vatics.com>
> Signed-off-by: Amos Kong <jianjun@zeuux.org>

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Thanks Amos and Jonathan

> 
> ---
>  drivers/net/8139too.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
> index 29df398..1fc4543 100644
> --- a/drivers/net/8139too.c
> +++ b/drivers/net/8139too.c
> @@ -1383,6 +1383,11 @@ static void rtl8139_hw_start (struct net_device *dev)
>  	RTL_W32_F (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
>  	RTL_W32_F (MAC0 + 4, le16_to_cpu (*(__le16 *) (dev->dev_addr + 4)));
>  
> +	tp->cur_rx = 0;
> +
> +	/* init Rx ring buffer DMA address */
> +	RTL_W32_F (RxBuf, tp->rx_ring_dma);
> +
>  	/* Must enable Tx/Rx before setting transfer thresholds! */
>  	RTL_W8 (ChipCmd, CmdRxEnb | CmdTxEnb);
>  
> @@ -1390,8 +1395,6 @@ static void rtl8139_hw_start (struct net_device *dev)
>  	RTL_W32 (RxConfig, tp->rx_config);
>  	RTL_W32 (TxConfig, rtl8139_tx_config);
>  
> -	tp->cur_rx = 0;
> -
>  	rtl_check_media (dev, 1);
>  
>  	if (tp->chipset >= CH_8139B) {
> @@ -1406,9 +1409,6 @@ static void rtl8139_hw_start (struct net_device *dev)
>  	/* Lock Config[01234] and BMCR register writes */
>  	RTL_W8 (Cfg9346, Cfg9346_Lock);
>  
> -	/* init Rx ring buffer DMA address */
> -	RTL_W32_F (RxBuf, tp->rx_ring_dma);
> -
>  	/* init Tx buffer DMA addresses */
>  	for (i = 0; i < NUM_TX_DESC; i++)
>  		RTL_W32_F (TxAddr0 + (i * 4), tp->tx_bufs_dma + (tp->tx_buf[i] - tp->tx_bufs));


