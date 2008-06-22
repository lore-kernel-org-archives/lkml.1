Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYFVB5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYFVB5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 21:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYFVB5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 21:57:38 -0400
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:57622
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYFVB5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 21:57:37 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jun 2008 21:57:36 EDT
Message-ID: <485DB008.30405@roinet.com>
Date: Sat, 21 Jun 2008 21:51:04 -0400
From: David Acker <dacker@roinet.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080502)
MIME-Version: 1.0
To: Kevin Hao <kexin.hao@windriver.com>
CC: linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-net@vger.kernel.org,
       grfstrm@users.sourceforge.net
Subject: Re: [PATCH] e100: Do pci_dma_sync after skb_alloc for proper operation
 on ixp4xx
References: <1214043635.12484.8.camel@hkx>
In-Reply-To: <1214043635.12484.8.camel@hkx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hao wrote:
> Hi,
> 
> The E100 device can't work on current kernel (2.6.26-rc6) and will cause
> kernel corruption on intel ixdp4xx. This patch fix this regression.
> 
Hello, this is pretty much the same patch that Anders Grafström sent on 
6/18.  I think it looks good; I am sorry I missed this.  I think this 
can be ok'ed if folks can test it on a few different ARM platforms and 
of course x86.

I am getting sinus surgery this Monday but I should be back in the 
office within a week.  I will give it a try then.  I will test it on an 
ixp425 board and an PXA255 board.  Just so you know, I found the 
in-kernel packet generator to be a good test.  I also found using the 
board as a router between wired and wireless devices to catch issues 
that led me to posting patches for this driver in the first place.

-ack

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
>  	}
>  
>  	return 0;
> ---
> 
> Best Regards,
> Kevin
> 

