Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZESMOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZESMOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZESMOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:14:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZESMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:14:33 -0400
Date: Tue, 19 May 2009 14:14:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Weidong Han <weidong.han@intel.com>
Cc: dwmw2@infradead.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Intel-IOMMU, intr-remap: set the whole 128bits
	of irte when modify/free it
Message-ID: <20090519121413.GC14305@elte.hu>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com> <1242757912-6041-2-git-send-email-weidong.han@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242757912-6041-2-git-send-email-weidong.han@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Weidong Han <weidong.han@intel.com> wrote:

> Interrupt remapping table entry is 128bits. Currently, it only sets low
> 64bits of irte in modify_irte and free_irte. This ignores high 64bits
> setting of irte, that means source-id setting will be ignored. This patch
> sets the whole 128bits of irte when modify/free it. Following source-id
> checking patch depends on this.
> 
> Signed-off-by: Weidong Han <weidong.han@intel.com>
> ---
>  drivers/pci/intr_remapping.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
> index f5e0ea7..946e170 100644
> --- a/drivers/pci/intr_remapping.c
> +++ b/drivers/pci/intr_remapping.c
> @@ -309,7 +309,8 @@ int modify_irte(int irq, struct irte *irte_modified)
>  	index = irq_iommu->irte_index + irq_iommu->sub_handle;
>  	irte = &iommu->ir_table->base[index];
>  
> -	set_64bit((unsigned long *)irte, irte_modified->low);
> +	set_64bit((unsigned long *)&irte->low, irte_modified->low);
> +	set_64bit((unsigned long *)&irte->high, irte_modified->high);
>
>  	__iommu_flush_cache(iommu, irte, sizeof(*irte));
>  
>  	rc = qi_flush_iec(iommu, index, 0);
> @@ -386,8 +387,11 @@ int free_irte(int irq)
>  	irte = &iommu->ir_table->base[index];
>  
>  	if (!irq_iommu->sub_handle) {
> -		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
> -			set_64bit((unsigned long *)(irte + i), 0);
> +		for (i = 0; i < (1 << irq_iommu->irte_mask); i++) {
> +			set_64bit((unsigned long *)&irte->low, 0);
> +			set_64bit((unsigned long *)&irte->high, 0);
> +			irte++;
> +		}

The loop is a bit unclean. It has a side-effect on 'irte' - and 
other patterns in the driver usually treat 'irte' as a generally 
available variable.

So the above code, while correct, opens up the possibility of later 
code added to this function relying on 'irte', thinking that it's 
set to "&iommu->ir_table->base[index]", and then breaking because 
'irte' has been iterated to the end of it in certain circumstances.

It's better to factor out the whole loop into a helper function, 
which does something like:

int flush_entries(struct irq_2_iommu *irq_iommu)
{
	struct irte *start, *entry, *end;
	struct intel_iommu *iommu;
	int index;

 	if (irq_iommu->sub_handle)
		return 0;

	iommu = irq_iommu->iommu;
	index = irq_iommu->irte_index + irq_iommu->sub_handle;

	start = iommu->ir_table->base + index;
	end = start + (1 << irq_iommu->irte_mask);

	for (entry = start; entry < end; entry++) {
		set_64bit((unsigned long *)&entry->low,  0);
		set_64bit((unsigned long *)&entry->high, 0);
	}

	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
}

Note how clearer this is - the new method has one purpose and 
'entry' is a clear iterator.

( And note how much clearer the flow of 'rc' has become as well as a 
  side-effect: it is clear now that it's set to 0 when 
  irq_iommu->sub_handle is still present. )

Thanks,

	Ingo
