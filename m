Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZLQPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZLQPDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762294AbZLQPDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:03:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55167 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762315AbZLQPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:03:49 -0500
From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
To: Greg KH <gregkh@suse.de>
Subject: Re: [50/90] e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failure
Date: Thu, 17 Dec 2009 17:03:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-ironman-1; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Roger Oksanen <roger.oksanen@cs.helsinki.fi>
References: <20091217011604.483828174@mini.kroah.org>
In-Reply-To: <20091217011604.483828174@mini.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171703.02902.roger.oksanen@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 03:15:01 Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.

This commit has a problem, found in 
http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/03887.html
and while a fix is available at
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01012.html
it should probably be merged into this patch when pushing it to 31.x?
Obviously the fix should first be reviewed and pushed to Linus' tree...

> ------------------
> 
> 
> From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> 
> [ Upstream commit 98468efddb101f8a29af974101c17ba513b07be1 ]
> 
> pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some systems
> with limited memory (Bug #14265). pci_pool_alloc allows waiting with
> GFP_KERNEL.
> 
> Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/net/e100.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -156,6 +156,7 @@
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/dmapool.h>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/mii.h>
> @@ -601,6 +602,7 @@ struct nic {
>  	struct mem *mem;
>  	dma_addr_t dma_addr;
>  
> +	struct pci_pool *cbs_pool;
>  	dma_addr_t cbs_dma_addr;
>  	u8 adaptive_ifs;
>  	u8 tx_threshold;
> @@ -1779,9 +1781,7 @@ static void e100_clean_cbs(struct nic *n
>  			nic->cb_to_clean = nic->cb_to_clean->next;
>  			nic->cbs_avail++;
>  		}
> -		pci_free_consistent(nic->pdev,
> -			sizeof(struct cb) * nic->params.cbs.count,
> -			nic->cbs, nic->cbs_dma_addr);
> +		pci_pool_free(nic->cbs_pool, nic->cbs, nic->cbs_dma_addr);
>  		nic->cbs = NULL;
>  		nic->cbs_avail = 0;
>  	}
> @@ -1799,8 +1799,8 @@ static int e100_alloc_cbs(struct nic *ni
>  	nic->cb_to_use = nic->cb_to_send = nic->cb_to_clean = NULL;
>  	nic->cbs_avail = 0;
>  
> -	nic->cbs = pci_alloc_consistent(nic->pdev,
> -		sizeof(struct cb) * count, &nic->cbs_dma_addr);
> +	nic->cbs = pci_pool_alloc(nic->cbs_pool, GFP_KERNEL,
> +				  &nic->cbs_dma_addr);
>  	if (!nic->cbs)
>  		return -ENOMEM;
>  
> @@ -2827,7 +2827,11 @@ static int __devinit e100_probe(struct p
>  		DPRINTK(PROBE, ERR, "Cannot register net device, aborting.\n");
>  		goto err_out_free;
>  	}
> -
> +	nic->cbs_pool = pci_pool_create(netdev->name,
> +			   nic->pdev,
> +			   nic->params.cbs.count * sizeof(struct cb),
> +			   sizeof(u32),
> +			   0);
>  	DPRINTK(PROBE, INFO, "addr 0x%llx, irq %d, MAC addr %pM\n",
>  		(unsigned long long)pci_resource_start(pdev, use_io ? 1 : 0),
>  		pdev->irq, netdev->dev_addr);
> @@ -2857,6 +2861,7 @@ static void __devexit e100_remove(struct
>  		unregister_netdev(netdev);
>  		e100_free(nic);
>  		pci_iounmap(pdev, nic->csr);
> +		pci_pool_destroy(nic->cbs_pool);
>  		free_netdev(netdev);
>  		pci_release_regions(pdev);
>  		pci_disable_device(pdev);
> 
> 
> 

-- 
Roger Oksanen <roger.oksanen@cs.helsinki.fi>
http://www.cs.helsinki.fi/u/raoksane
+358 50 355 1990
