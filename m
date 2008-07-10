Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYGJCcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYGJCcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYGJCcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:32:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbYGJCcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:32:03 -0400
Date: Wed, 9 Jul 2008 19:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 25/34] AMD IOMMU: add dma_ops mapping functions for
 single mappings
Message-Id: <20080709192606.c4f0c2cf.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-26-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-26-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:28:01 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the dma_ops specific mapping functions for single mappings.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   59 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index e00a3e7..b4079f6 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -40,6 +40,11 @@ struct command {
>  static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
>  			     struct unity_map_entry *e);
>  
> +static int iommu_has_npcache(struct amd_iommu *iommu)
> +{
> +	return iommu->cap & IOMMU_CAP_NPCACHE;
> +}
> +
>  static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
>  {
>  	u32 tail, head;
> @@ -641,3 +646,57 @@ static void __unmap_single(struct amd_iommu *iommu,
>  	dma_ops_free_addresses(dma_dom, dma_addr, pages);
>  }
>  
> +static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
> +			     size_t size, int dir)
> +{
> +	unsigned long flags;
> +	struct amd_iommu *iommu;
> +	struct protection_domain *domain;
> +	u16 devid;
> +	dma_addr_t addr;
> +
> +	get_device_resources(dev, &iommu, &domain, &devid);
> +
> +	if (iommu == NULL || domain == NULL)
> +		return (dma_addr_t)paddr;

OK, a test case.  A reader of your code (ie: me) wants to find out what
this code is doing.  What is the *meaning* of iommu == NULL || domain ==
NULL here?

I go look at the (undocumented) get_device_resources() and I see that this:

       if (_bdf >= amd_iommu_last_bdf) {

happened.  I don't know what that semantically means and I gave up.

I'm not saying that the code is unmaintainable, but I would assert that it
is a heck of a lot harder to maintain than it could be, and than it should
be.

get_device_resources() has an open-coded copy of your DEVID() macro, btw.

> +	spin_lock_irqsave(&domain->lock, flags);
> +	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir);
> +	if (addr == bad_dma_address)
> +		goto out;
> +
> +	if (iommu_has_npcache(iommu))
> +		iommu_flush_pages(iommu, domain->id, addr, size);
> +
> +	if (iommu->need_sync)
> +		iommu_completion_wait(iommu);
> +
> +out:
> +	spin_unlock_irqrestore(&domain->lock, flags);
> +
> +	return addr;
> +}
> +
> +static void unmap_single(struct device *dev, dma_addr_t dma_addr,
> +			 size_t size, int dir)
> +{
> +	unsigned long flags;
> +	struct amd_iommu *iommu;
> +	struct protection_domain *domain;
> +	u16 devid;
> +
> +	if (!get_device_resources(dev, &iommu, &domain, &devid))
> +		return;
> +
> +	spin_lock_irqsave(&domain->lock, flags);
> +
> +	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
> +
> +	iommu_flush_pages(iommu, domain->id, dma_addr, size);
> +
> +	if (iommu->need_sync)
> +		iommu_completion_wait(iommu);
> +
> +	spin_unlock_irqrestore(&domain->lock, flags);
> +}

