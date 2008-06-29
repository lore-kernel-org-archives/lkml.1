Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbYF2PMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbYF2PMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760826AbYF2PMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:12:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:57062 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760792AbYF2PLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:11:55 -0400
Date: Mon, 30 Jun 2008 00:07:16 +0900
To: joerg.roedel@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 26/34] AMD IOMMU: add mapping functions for scatter
 gather lists
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1214508490-29683-27-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-27-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080630000023F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:28:02 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the dma_ops functions for mapping and unmapping scatter gather
> lists.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   98 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 98 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index b4079f6..f4747fe 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -700,3 +700,101 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
>  	spin_unlock_irqrestore(&domain->lock, flags);
>  }
>  
> +static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
> +			   int nelems, int dir)
> +{
> +	struct scatterlist *s;
> +	int i;
> +
> +	for_each_sg(sglist, s, nelems, i) {
> +		s->dma_address = (dma_addr_t)sg_phys(s);
> +		s->dma_length  = s->length;
> +	}
> +
> +	return nelems;
> +}
> +
> +static int map_sg(struct device *dev, struct scatterlist *sglist,
> +		  int nelems, int dir)
> +{
> +	unsigned long flags;
> +	struct amd_iommu *iommu;
> +	struct protection_domain *domain;
> +	u16 devid;
> +	int i;
> +	struct scatterlist *s;
> +	phys_addr_t paddr;
> +	int mapped_elems = 0;
> +
> +	get_device_resources(dev, &iommu, &domain, &devid);
> +
> +	if (!iommu || !domain)
> +		return map_sg_no_iommu(dev, sglist, nelems, dir);

VT-d put a pointer in struct dev_archdata to store IOMMU info per
device. Is is useful for you too?
