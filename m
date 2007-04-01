Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXDAXU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXDAXU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 19:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXDAXU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 19:20:57 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:43143 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXDAXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 19:20:57 -0400
Date: Sun, 01 Apr 2007 16:20:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [KJ][PATCH] ROUND_UP macro cleanup in drivers/net/e1000
In-reply-to: <20070401183144.GA10566@arun.site>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, e1000-devel@lists.sourceforge.net,
       linux.nics@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com
Message-id: <46103E4C.2060604@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070401183144.GA10566@arun.site>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary wrote:
> E1000_ROUNDUP macro cleanup, use ALIGN
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

we were actually looking at this last week. I'll take it for a spin and if it's 
good I'll push it through upstream.

Thanks!

Auke


> ---
> 
>  e1000.h         |    3 ---
>  e1000_ethtool.c |    6 +++---
>  e1000_main.c    |   10 +++++-----
>  e1000_param.c   |    4 ++--
>  4 files changed, 10 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/drivers/net/e1000/e1000.h b/drivers/net/e1000/e1000.h
> index dd4b728..a9ea67e 100644
> --- a/drivers/net/e1000/e1000.h
> +++ b/drivers/net/e1000/e1000.h
> @@ -155,9 +155,6 @@ struct e1000_adapter;
>  /* Number of packet split data buffers (not including the header buffer) */
>  #define PS_PAGE_BUFFERS MAX_PS_BUFFERS-1
>  
> -/* only works for sizes that are powers of 2 */
> -#define E1000_ROUNDUP(i, size) ((i) = (((i) + (size) - 1) & ~((size) - 1)))
> -
>  /* wrapper around a pointer to a socket buffer,
>   * so a DMA handle can be stored along with the buffer */
>  struct e1000_buffer {
> diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
> index 6777887..0fbd873 100644
> --- a/drivers/net/e1000/e1000_ethtool.c
> +++ b/drivers/net/e1000/e1000_ethtool.c
> @@ -686,12 +686,12 @@ e1000_set_ringparam(struct net_device *netdev,
>  	rxdr->count = max(ring->rx_pending,(uint32_t)E1000_MIN_RXD);
>  	rxdr->count = min(rxdr->count,(uint32_t)(mac_type < e1000_82544 ?
>  		E1000_MAX_RXD : E1000_MAX_82544_RXD));
> -	E1000_ROUNDUP(rxdr->count, REQ_RX_DESCRIPTOR_MULTIPLE);
> +	rxdr->count = ALIGN(rxdr->count, REQ_RX_DESCRIPTOR_MULTIPLE);
>  
>  	txdr->count = max(ring->tx_pending,(uint32_t)E1000_MIN_TXD);
>  	txdr->count = min(txdr->count,(uint32_t)(mac_type < e1000_82544 ?
>  		E1000_MAX_TXD : E1000_MAX_82544_TXD));
> -	E1000_ROUNDUP(txdr->count, REQ_TX_DESCRIPTOR_MULTIPLE);
> +	txdr->count = ALIGN(txdr->count, REQ_TX_DESCRIPTOR_MULTIPLE);
>  
>  	for (i = 0; i < adapter->num_tx_queues; i++)
>  		txdr[i].count = txdr->count;
> @@ -1068,7 +1068,7 @@ e1000_setup_desc_rings(struct e1000_adapter *adapter)
>  	memset(txdr->buffer_info, 0, size);
>  
>  	txdr->size = txdr->count * sizeof(struct e1000_tx_desc);
> -	E1000_ROUNDUP(txdr->size, 4096);
> +	txdr->size = ALIGN(txdr->size, 4096);
>  	if (!(txdr->desc = pci_alloc_consistent(pdev, txdr->size, &txdr->dma))) {
>  		ret_val = 2;
>  		goto err_nomem;
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index 1d08e93..d0af100 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -750,9 +750,9 @@ e1000_reset(struct e1000_adapter *adapter)
>  		               VLAN_TAG_SIZE;
>  		min_tx_space = min_rx_space;
>  		min_tx_space *= 2;
> -		E1000_ROUNDUP(min_tx_space, 1024);
> +		min_tx_space = ALIGN(min_tx_space, 1024);
>  		min_tx_space >>= 10;
> -		E1000_ROUNDUP(min_rx_space, 1024);
> +		min_rx_space = ALIGN(min_rx_space, 1024);
>  		min_rx_space >>= 10;
>  
>  		/* If current Tx allocation is less than the min Tx FIFO size,
> @@ -1545,7 +1545,7 @@ e1000_setup_tx_resources(struct e1000_adapter *adapter,
>  	/* round up to nearest 4K */
>  
>  	txdr->size = txdr->count * sizeof(struct e1000_tx_desc);
> -	E1000_ROUNDUP(txdr->size, 4096);
> +	txdr->size = ALIGN(txdr->size, 4096);
>  
>  	txdr->desc = pci_alloc_consistent(pdev, txdr->size, &txdr->dma);
>  	if (!txdr->desc) {
> @@ -1788,7 +1788,7 @@ e1000_setup_rx_resources(struct e1000_adapter *adapter,
>  	/* Round up to nearest 4K */
>  
>  	rxdr->size = rxdr->count * desc_len;
> -	E1000_ROUNDUP(rxdr->size, 4096);
> +	rxdr->size = ALIGN(rxdr->size, 4096);
>  
>  	rxdr->desc = pci_alloc_consistent(pdev, rxdr->size, &rxdr->dma);
>  
> @@ -3162,7 +3162,7 @@ e1000_82547_fifo_workaround(struct e1000_adapter *adapter, struct sk_buff *skb)
>  	uint32_t fifo_space = adapter->tx_fifo_size - adapter->tx_fifo_head;
>  	uint32_t skb_fifo_len = skb->len + E1000_FIFO_HDR;
>  
> -	E1000_ROUNDUP(skb_fifo_len, E1000_FIFO_HDR);
> +	skb_fifo_len = ALIGN(skb_fifo_len, E1000_FIFO_HDR);
>  
>  	if (adapter->link_duplex != HALF_DUPLEX)
>  		goto no_fifo_stall_required;
> diff --git a/drivers/net/e1000/e1000_param.c b/drivers/net/e1000/e1000_param.c
> index f8862e2..f485874 100644
> --- a/drivers/net/e1000/e1000_param.c
> +++ b/drivers/net/e1000/e1000_param.c
> @@ -305,7 +305,7 @@ e1000_check_options(struct e1000_adapter *adapter)
>  		if (num_TxDescriptors > bd) {
>  			tx_ring->count = TxDescriptors[bd];
>  			e1000_validate_option(&tx_ring->count, &opt, adapter);
> -			E1000_ROUNDUP(tx_ring->count,
> +			tx_ring->count = ALIGN(tx_ring->count,
>  						REQ_TX_DESCRIPTOR_MULTIPLE);
>  		} else {
>  			tx_ring->count = opt.def;
> @@ -331,7 +331,7 @@ e1000_check_options(struct e1000_adapter *adapter)
>  		if (num_RxDescriptors > bd) {
>  			rx_ring->count = RxDescriptors[bd];
>  			e1000_validate_option(&rx_ring->count, &opt, adapter);
> -			E1000_ROUNDUP(rx_ring->count,
> +			rx_ring->count = ALIGN(rx_ring->count,
>  						REQ_RX_DESCRIPTOR_MULTIPLE);
>  		} else {
>  			rx_ring->count = opt.def;
> 

