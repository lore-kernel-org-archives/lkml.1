Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbXITPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbXITPpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXITPpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:45:35 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58880 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXITPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:45:34 -0400
Message-ID: <46F2957F.60707@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2007 21:15:03 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1: Build failure on ppc64 drivers/ata/pata_scc.c
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070920131315.GE24105@skynet.ie> <20070920150925.0caf3aef@the-village.bc.nu>
In-Reply-To: <20070920150925.0caf3aef@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 20 Sep 2007 14:13:15 +0100
> mel@skynet.ie (Mel Gorman) wrote:
>
>   
>> PPC64 building allmodconfig fails to compile drivers/ata/pata_scc.c . It
>> doesn't show up on other arches because this driver is specific to the
>> architecture.
>>
>> drivers/ata/pata_scc.c: In function `scc_bmdma_status'
>>     
>
> Its not been updated to match the libata core changes. Try something like
> this. Whoever is maintaining it should also remove the prereset cable handling
> code and use the proper cable detect method.
>
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/ata/pata_scc.c linux-2.6.23rc6-mm1/drivers/ata/pata_scc.c
> --- linux.vanilla-2.6.23rc6-mm1/drivers/ata/pata_scc.c	2007-09-18 15:32:51.000000000 +0100
> +++ linux-2.6.23rc6-mm1/drivers/ata/pata_scc.c	2007-09-20 14:23:32.879807760 +0100
> @@ -731,7 +731,7 @@
>  	void __iomem *mmio = ap->ioaddr.bmdma_addr;
>  	u8 host_stat = in_be32(mmio + SCC_DMA_STATUS);
>  	u32 int_status = in_be32(mmio + SCC_DMA_INTST);
> -	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
> +	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
>  	static int retry = 0;
>
>  	/* return if IOS_SS is cleared */
> @@ -860,10 +860,10 @@
>   *	@deadline: deadline jiffies for the operation
>   */
>
> -static int scc_pata_prereset(struct ata_port *ap, unsigned long deadline)
> +static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
>  {
> -	ap->cbl = ATA_CBL_PATA80;
> -	return ata_std_prereset(ap, deadline);
> +	link->ap->cbl = ATA_CBL_PATA80;
> +	return ata_std_prereset(link, deadline);
>  }
>
>  /**
> @@ -874,8 +874,9 @@
>   *	Note: Original code is ata_std_postreset().
>   */
>
> -static void scc_std_postreset (struct ata_port *ap, unsigned int *classes)
> +static void scc_std_postreset (struct ata_link *link, unsigned int *classes)
>  {
>
> -	ap->cbl = ATA_CBL_PATA80;
> -	return ata_std_prereset(ap, deadline);
> +	link->ap->cbl = ATA_CBL_PATA80;
> +	return ata_std_prereset(link, deadline);
>  }
>
>  /**
> @@ -874,8 +874,9 @@
>   *	Note: Original code is ata_std_postreset().
>   */
>
> +	struct ata_port *ap = link->ap;
>  	DPRINTK("ENTER\n");
>
>  	/* is double-select really necessary? */
>
>   
Hi,

This patch solves the build failure, but with following warnings
CC drivers/ata/pata_scc.o
drivers/ata/pata_scc.c: In function ‘scc_error_handler’:
drivers/ata/pata_scc.c:909: warning: passing argument 3 of 
‘ata_bmdma_drive_eh’ from incompatible pointer type

and after that the build fails with

CC [M] drivers/net/spider_net.o
drivers/net/spider_net.c: In function ‘spider_net_release_tx_chain’:
drivers/net/spider_net.c:818: error: ‘dev’ undeclared (first use in this 
function)
drivers/net/spider_net.c:818: error: (Each undeclared identifier is 
reported only once
drivers/net/spider_net.c:818: error: for each function it appears in.)
drivers/net/spider_net.c: In function ‘spider_net_xmit’:
drivers/net/spider_net.c:922: error: ‘dev’ undeclared (first use in this 
function)
drivers/net/spider_net.c: In function ‘spider_net_pass_skb_up’:
drivers/net/spider_net.c:1018: error: ‘dev’ undeclared (first use in 
this function)
drivers/net/spider_net.c: In function ‘spider_net_decode_one_descr’:
drivers/net/spider_net.c:1215: error: ‘dev’ undeclared (first use in 
this function)
make[2]: *** [drivers/net/spider_net.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

