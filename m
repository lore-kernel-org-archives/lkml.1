Return-Path: <linux-kernel-owner+w=401wt.eu-S965272AbZLQPrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272AbZLQPrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965201AbZLQPrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:47:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965200AbZLQPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:47:35 -0500
Date: Thu, 17 Dec 2009 10:47:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: e100 REGRESSION in 2.6.32 (PATCH)
In-Reply-To: <200912171414.16846.roger.oksanen@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.44L0.0912171046070.2645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Roger Oksanen wrote:

> e100: Fix broken cbs accounting due to missing memset.
> 
> Alan Stern noticed that e100 caused slab corruption.
> commit 98468efddb101f8a29af974101c17ba513b07be1 changed
> the allocation of cbs to use dma pools that don't return zeroed memory,
> especially the cb->status field used to track which cb to clean, causing
> (the visible) double freeing of skbs and a wrong free cbs count.
> 
> Now the cbs are explicitly zeroed at allocation time.
> 
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> ---
>  drivers/net/e100.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index d269a68..29a8840 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -1815,6 +1815,7 @@ static int e100_alloc_cbs(struct nic *nic)
>  
>  	nic->cbs = pci_pool_alloc(nic->cbs_pool, GFP_KERNEL,
>  				  &nic->cbs_dma_addr);
> +	memset(nic->cbs, 0, count * sizeof(struct cb));
>  	if (!nic->cbs)
>  		return -ENOMEM;
>  
> @@ -1825,7 +1826,6 @@ static int e100_alloc_cbs(struct nic *nic)
>  		cb->dma_addr = nic->cbs_dma_addr + i * sizeof(struct cb);
>  		cb->link = cpu_to_le32(nic->cbs_dma_addr +
>  			((i+1) % count) * sizeof(struct cb));
> -		cb->skb = NULL;
>  	}
>  
>  	nic->cb_to_use = nic->cb_to_send = nic->cb_to_clean = nic->cbs;

Clearly the memset() belongs after the "if" test, not before.  Apart 
from that, I confirm that this patch fixes the problem in 2.6.32.

Tested-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

