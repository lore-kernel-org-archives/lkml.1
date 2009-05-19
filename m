Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZESORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZESORN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZESORH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:17:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:44516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZESORG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,215,1241420400"; 
   d="scan'208";a="413788054"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>
CC: "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Date: Tue, 19 May 2009 22:15:56 +0800
Subject: RE: [PATCH v2 1/2] Intel-IOMMU, intr-remap: set the whole 128bits
	of irte when modify/free it
Thread-Topic: [PATCH v2 1/2] Intel-IOMMU, intr-remap: set the whole 128bits
	of irte when modify/free it
Thread-Index: AcnYe1yXlJJPaTKXTDOEX8+FcCyhKQAENARQ
Message-ID: <715D42877B251141A38726ABF5CABF2C054568FD33@pdsmsx503.ccr.corp.intel.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
 <1242757912-6041-2-git-send-email-weidong.han@intel.com>
 <20090519121413.GC14305@elte.hu>
In-Reply-To: <20090519121413.GC14305@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Weidong Han <weidong.han@intel.com> wrote:
> 
>> Interrupt remapping table entry is 128bits. Currently, it only sets
>> low 64bits of irte in modify_irte and free_irte. This ignores high
>> 64bits setting of irte, that means source-id setting will be
>> ignored. This patch sets the whole 128bits of irte when modify/free
>> it. Following source-id checking patch depends on this.
>> 
>> Signed-off-by: Weidong Han <weidong.han@intel.com>
>> ---
>>  drivers/pci/intr_remapping.c |   10 +++++++---
>>  1 files changed, 7 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/pci/intr_remapping.c
>> b/drivers/pci/intr_remapping.c index f5e0ea7..946e170 100644 ---
>> a/drivers/pci/intr_remapping.c +++ b/drivers/pci/intr_remapping.c
>> @@ -309,7 +309,8 @@ int modify_irte(int irq, struct irte
>>  	*irte_modified) index = irq_iommu->irte_index +
>>  	irq_iommu->sub_handle; irte = &iommu->ir_table->base[index];
>> 
>> -	set_64bit((unsigned long *)irte, irte_modified->low);
>> +	set_64bit((unsigned long *)&irte->low, irte_modified->low);
>> +	set_64bit((unsigned long *)&irte->high, irte_modified->high);
>> 
>>  	__iommu_flush_cache(iommu, irte, sizeof(*irte));
>> 
>>  	rc = qi_flush_iec(iommu, index, 0);
>> @@ -386,8 +387,11 @@ int free_irte(int irq)
>>  	irte = &iommu->ir_table->base[index];
>> 
>>  	if (!irq_iommu->sub_handle) {
>> -		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
>> -			set_64bit((unsigned long *)(irte + i), 0);
>> +		for (i = 0; i < (1 << irq_iommu->irte_mask); i++) {
>> +			set_64bit((unsigned long *)&irte->low, 0);
>> +			set_64bit((unsigned long *)&irte->high, 0);
>> +			irte++;
>> +		}
> 
> The loop is a bit unclean. It has a side-effect on 'irte' - and
> other patterns in the driver usually treat 'irte' as a generally
> available variable.
> 
> So the above code, while correct, opens up the possibility of later
> code added to this function relying on 'irte', thinking that it's
> set to "&iommu->ir_table->base[index]", and then breaking because
> 'irte' has been iterated to the end of it in certain circumstances.
> 
> It's better to factor out the whole loop into a helper function,
> which does something like:
> 
> int flush_entries(struct irq_2_iommu *irq_iommu)
> {
> 	struct irte *start, *entry, *end;
> 	struct intel_iommu *iommu;
> 	int index;
> 
>  	if (irq_iommu->sub_handle)
> 		return 0;
> 
> 	iommu = irq_iommu->iommu;
> 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
> 
> 	start = iommu->ir_table->base + index;
> 	end = start + (1 << irq_iommu->irte_mask);
> 
> 	for (entry = start; entry < end; entry++) {
> 		set_64bit((unsigned long *)&entry->low,  0);
> 		set_64bit((unsigned long *)&entry->high, 0);
> 	}
> 
> 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
> }
> 
> Note how clearer this is - the new method has one purpose and
> 'entry' is a clear iterator.
> 
> ( And note how much clearer the flow of 'rc' has become as well as a
>   side-effect: it is clear now that it's set to 0 when
>   irq_iommu->sub_handle is still present. )
> 
> Thanks,
> 
> 	Ingo

Yes, more clearer. will update it in next version. Thanks.

Regards,
Weidong