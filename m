Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbZHWTSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbZHWTSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 15:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933763AbZHWTSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 15:18:16 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59665 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbZHWTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lWJ7EKqKcSKQ1JzCSfIwycROOfu9CRkHMvCh6C5VPFWt3GClhqWhZh6WEyBbD2pqGH
         T5dgW3gaAS3PGfeOUOzYUs4PhogRYgDovCpIvOgvRDakm5DsSLHR0GVrqRWBMead2lpJ
         gOlTFdm59JmqAfFR783NK6fv9RqgLD/UzKc3U=
Date: Sun, 23 Aug 2009 22:18:08 +0300
From: Aviv Greenberg <avivgnet@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Walt Holman <walt@holmansrus.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
Message-ID: <20090823191808.GA29972@linux-gec2.site>
References: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com> <m3skfmk39q.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3skfmk39q.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:45:21PM +0200, Krzysztof Halasa wrote:
 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 014dfb6..b610088 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1762,9 +1762,12 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
>  
>  			if (ioread8(&nic->csr->scb.status) & rus_no_res)
>  				nic->ru_running = RU_SUSPENDED;
> +#ifndef CONFIG_X86
> +		/* FIXME interferes with swiotlb. */
>  		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
>  					       sizeof(struct rfd),
>  					       PCI_DMA_BIDIRECTIONAL);
> +#endif
>  		return -ENODATA;
>  	}
>  
> -- 

Why do you use PCI_DMA_BIDIRECTIONAL? From what i get, the device writes and the
cpu reads - so the direction should be PCI_DMA_FROMDEVICE. Maybe just maybe the 
bi-directionality bites you in the swiotlb case.

> Krzysztof Halasa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
