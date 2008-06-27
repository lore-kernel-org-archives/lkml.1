Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYF0FdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYF0FdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYF0Fc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:32:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56684 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYF0Fc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:32:57 -0400
Message-ID: <48647B84.3000003@garzik.org>
Date: Fri, 27 Jun 2008 01:32:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kevin Hao <kexin.hao@windriver.com>
CC: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       john.ronciak@intel.com, dacker@roinet.com,
       e1000-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-net@vger.kernel.org
Subject: Re: [PATCH] e100: Do pci_dma_sync after skb_alloc for proper operation
 on ixp4xx
References: <1214043635.12484.8.camel@hkx>
In-Reply-To: <1214043635.12484.8.camel@hkx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hao wrote:
> Hi,
> 
> The E100 device can't work on current kernel (2.6.26-rc6) and will cause
> kernel corruption on intel ixdp4xx. This patch fix this regression.
> 
> ---
> commit c1f24812b9de182a4272724a2e84ea1ae5dd4659
> Author: Kevin Hao <kexin.hao@windriver.com>
> Date:   Sat Jun 21 16:50:50 2008 +0800
> 
>     e100: Do pci_dma_sync after skb_alloc for proper operation on ixp4xx
>     
>     Do a DMA sync after we've allocated a new skb and link it with the previous
>     RFD.  Otherwise the previous RFD may reference the previously freed skb
>     and cause kernel corruption.
>     
>     Previously there was such a DMA sync at this place, but it was removed
>     by commit 7734f6e6bcd7ba78b00e93e74a4ddafd9886cdea.
>     Restoring this sync operation eliminates the regression.
>     
>     Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index f3cba5e..1037b13 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1803,6 +1803,8 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
>  	if (rx->prev->skb) {
>  		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
>  		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
> +		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
> +			sizeof(struct rfd), PCI_DMA_TODEVICE);

applied


