Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZL2Sij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZL2Sij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZL2Sii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:38:38 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:52613 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZL2Sih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:38:37 -0500
Date: Tue, 29 Dec 2009 13:38:02 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
In-reply-to: <20091229093023.3ad24786@nehalam>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Message-id: <4B3A4C8A.6080001@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B300A2A.8040305@gmail.com> <4B300E30.9090707@majjas.com>
 <4B3114E3.1070602@majjas.com> <4B329FA3.9090904@majjas.com>
 <20091223230102.4bb0100e.akpm@linux-foundation.org>
 <4B34E847.8010809@majjas.com> <20091225152200.1cf11dfe@nehalam>
 <4B3581C7.8000702@majjas.com> <20091226095723.7ac82b18@nehalam>
 <4B367409.5060202@majjas.com> <4B379378.4000102@majjas.com>
 <20091227102238.0df149f9@nehalam> <4B37B7E2.5070307@majjas.com>
 <20091229093023.3ad24786@nehalam>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency of the errors is reduced, but in place I'm seeing a large 
number of DHCPINFORM/DHCPACK to/from the system from which I'm 
generating load.

It appears that it's now taking a higher throughput to cause the 
interrupt status errors than without this patch, but they're still 
occurring. Just for fun, I'll try without this patch and with VT-D 
disabled later today.


On 12/29/2009 12:30 PM, Stephen Hemminger wrote:
> There could be DMA problems, either because chip isn't remembering
> upper address, or because of lack of wires from chip to memory controller;
> there have been problems on motherboards where I/O devices couldn't access
> all of memory.
>
> Try this, it forces each transmit to have full 64 bit address. It drops an
> optimization that was done to reduce the number of transmit descriptors
> used.
>
> --- a/drivers/net/sky2.c	2009-12-29 09:23:37.114074275 -0800
> +++ b/drivers/net/sky2.c	2009-12-29 09:26:38.699912035 -0800
> @@ -1038,10 +1038,11 @@ static void tx_init(struct sky2_port *sk
>   	sky2->tx_tcpsum = 0;
>   	sky2->tx_last_mss = 0;
>
> -	le = get_tx_le(sky2,&sky2->tx_prod);
> -	le->addr = 0;
> -	le->opcode = OP_ADDR64 | HW_OWNER;
> -	sky2->tx_last_upper = 0;
> +	if (sizeof(dma_addr_t) == sizeof(u32)) {
> +		le = get_tx_le(sky2,&sky2->tx_prod);
> +		le->addr = 0;
> +		le->opcode = OP_ADDR64 | HW_OWNER;
> +	}
>   }
>
>   /* Update chip's next pointer */
> @@ -1669,10 +1670,9 @@ static netdev_tx_t sky2_xmit_frame(struc
>
>   	/* Send high bits if needed */
>   	upper = upper_32_bits(mapping);
> -	if (upper != sky2->tx_last_upper) {
> +	if (sizeof(mapping)>  sizeof(u32)) {
>   		le = get_tx_le(sky2,&slot);
>   		le->addr = cpu_to_le32(upper);
> -		sky2->tx_last_upper = upper;
>   		le->opcode = OP_ADDR64 | HW_OWNER;
>   	}
>
> @@ -1762,10 +1762,9 @@ static netdev_tx_t sky2_xmit_frame(struc
>   			goto mapping_unwind;
>
>   		upper = upper_32_bits(mapping);
> -		if (upper != sky2->tx_last_upper) {
> +		if (sizeof(mapping)>  sizeof(u32)) {
>   			le = get_tx_le(sky2,&slot);
>   			le->addr = cpu_to_le32(upper);
> -			sky2->tx_last_upper = upper;
>   			le->opcode = OP_ADDR64 | HW_OWNER;
>   		}
>
> --- a/drivers/net/sky2.h	2009-12-29 09:23:37.164072886 -0800
> +++ b/drivers/net/sky2.h	2009-12-29 09:25:15.302197993 -0800
> @@ -2191,7 +2191,6 @@ struct sky2_port {
>
>   	u16		     tx_pending;
>   	u16		     tx_last_mss;
> -	u32		     tx_last_upper;
>   	u32		     tx_tcpsum;
>
>   	struct rx_ring_info  *rx_ring ____cacheline_aligned_in_smp;
>    

