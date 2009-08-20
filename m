Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZHTWV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZHTWV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZHTWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:21:26 -0400
Received: from static-76-164-182-224.apid.com ([76.164.182.224]:41960 "EHLO
	waltsputer.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754221AbZHTWVZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:21:25 -0400
Date: Thu, 20 Aug 2009 17:21:23 -0500 (CDT)
From: Walt Holman <walt@holmansrus.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-ID: <322550336.131250806883202.JavaMail.root@mail.holmansrus.com>
In-Reply-To: <m3skfmk39q.fsf@intrepid.localdomain>
Subject: Re: Strange network timeouts w/ 2.6.30.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.0.1]
X-Mailer: Zimbra 6.0.0_RC1_1684.UBUNTU8_64 (ZimbraWebClient - [unknown] (Linux)/6.0.0_RC1_1684.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Krzysztof Halasa" <khc@pm.waw.pl> wrote:

> Walt Holman <walt@holmansrus.com> writes:
> 
> > dmesg is attached. This box does have >2GB Ram (6GB total).  The
> dmesg
> > will show e100 init'd 3 times since the first is the stock
> modprobe,
> > 2nd was forced with use_io and the 3rd modprobe was after reverting
> > the patch.
> 
> You most probably can't test without swiotlb (RAM has to be limited
> to
> 2 GB or so), can you? That would (dis)prove my theory. Alternatively
> (or
> better), a test on IOMMU-equipped system would do.

Would something like passing a mem=xx cmdline on x86_64 be sufficient to test this?

-Walt



> 
> Since swiotlb is x86-only thing (though other 64-bit archs may have
> something similar), I think the correct work around is to enable the
> "for_device" handoff on !X86.
> 
> Something like maybe:
> 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 014dfb6..b610088 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1762,9 +1762,12 @@ static int e100_rx_indicate(struct nic *nic,
> struct rx *rx,
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
> Krzysztof Halasa
