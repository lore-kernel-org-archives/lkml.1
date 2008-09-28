Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYI1OWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYI1OWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 10:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYI1OWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 10:22:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:32864 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYI1OWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 10:22:37 -0400
Date: Sun, 28 Sep 2008 23:21:23 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1222107681-8185-10-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
	<1222107681-8185-10-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080928231211X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 20:21:21 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch enables stackable dma_ops on x86. To do this, it also enables
> the per-device dma_ops on i386.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-dma.c     |   26 ++++++++++++++++++++++++++
>  include/asm-x86/device.h      |    6 +++---
>  include/asm-x86/dma-mapping.h |   14 +++++++-------
>  3 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index b990fb6..2e517c2 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -82,6 +82,32 @@ void x86_register_dma_ops(struct dma_mapping_ops *ops,
>  	write_unlock_irqrestore(&dma_ops_list_lock, flags);
>  }
>  
> +struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev)
> +{
> +	int i;
> +	unsigned long flags;
> +	struct dma_mapping_ops *entry, *ops = NULL;
> +
> +	read_lock_irqsave(&dma_ops_list_lock, flags);
> +
> +	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
> +		list_for_each_entry(entry, &dma_ops_list[i], list) {
> +			if (!entry->device_supported)
> +				continue;
> +			if (entry->device_supported(dev)) {
> +				ops = entry;
> +				goto out;
> +			}
> +		}
> +out:
> +	read_unlock_irqrestore(&dma_ops_list_lock, flags);

Hmm, every time we call dma_sg/map_single, we call
read_lock_irqsave(&dma_ops_list_lock, flags). It's likely that we see
notable performance drop?
