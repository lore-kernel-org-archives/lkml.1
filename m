Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZHZWXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZHZWXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZHZWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:23:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbZHZWXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:23:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #14057] Strange network timeouts w/ e100
Date: Thu, 27 Aug 2009 00:23:51 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: walt@holmansrus.com, kernel-testers@vger.kernel.org, khc@pm.waw.pl,
       linux-kernel@vger.kernel.org
References: <828279661.71251246859811.JavaMail.root@mail.holmansrus.com> <200908262312.04000.rjw@sisk.pl> <20090826.151153.169388217.davem@davemloft.net>
In-Reply-To: <20090826.151153.169388217.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908270023.51710.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Wed, 26 Aug 2009 23:12:03 +0200
> 
> >> Krzysztof has a patch which has corrected this issue for me.  Thanks,
> > 
> > Thanks for the update.
> > 
> > Do you have a pointer to the patch, please?
> 
> commit 6ff9c2e7fa8ca63a575792534b63c5092099c286
> Author: Krzysztof Hałasa <khc@pm.waw.pl>
> Date:   Sun Aug 23 19:02:13 2009 -0700
> 
>     E100: fix interaction with swiotlb on X86.
>     
>     E100 places it's RX packet descriptors inside skb->data and uses them
>     with bidirectional streaming DMA mapping. Data in descriptors is
>     accessed simultaneously by the chip (writing status and size when
>     a packet is received) and CPU (reading to check if the packet was
>     received). This isn't a valid usage of PCI DMA API, which requires use
>     of the coherent (consistent) memory for such purpose. Unfortunately e100
>     chips working in "simplified" RX mode have to store received data
>     directly after the descriptor. Fixing the driver to conform to the API
>     would require using unsupported "flexible" RX mode or receiving data
>     into a coherent memory and using CPU to copy it to network buffers.
>     
>     This patch, while not yet making the driver conform to the PCI DMA API,
>     allows it to work correctly on X86 with swiotlb (while not breaking
>     other architectures).
>     
>     Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 41b648a..3a6735d 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1899,7 +1899,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
>  				nic->ru_running = RU_SUSPENDED;
>  		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
>  					       sizeof(struct rfd),
> -					       PCI_DMA_BIDIRECTIONAL);
> +					       PCI_DMA_FROMDEVICE);
>  		return -ENODATA;
>  	}

Thanks a lot, bug closed.

Rafael
