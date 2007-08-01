Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXHAJBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXHAJBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbXHAJBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:01:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:14211 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbXHAJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:01:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,207,1183359600"; 
   d="scan'208";a="112108771"
Subject: Re: [PATCH 2/5] x86_64 EFI support -v3: EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707311335.40235.ak@suse.de>
References: <1185851576.23149.27.camel@caritas-dev.intel.com>
	 <200707311335.40235.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 16:59:08 +0800
Message-Id: <1185958748.1363.40.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 01 Aug 2007 09:01:08.0123 (UTC) FILETIME=[7FC566B0:01C7D41A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 13:35 +0200, Andi Kleen wrote:
> >  static unsigned long dma_reserve __initdata;
> > +/* Flag indicating EFI runtime executable code area */
> > +static int efi_runtime_code_area;
> 
> We don't normally use globals to modify function behaviour.
> 
> >  
> >  DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> >  
> > @@ -199,7 +202,7 @@
> >  static __meminit void unmap_low_page(void *adr)
> >  { 
> >  
> > -	if (after_bootmem)
> > +	if (after_bootmem || efi_runtime_code_area)
> >  		return;
> >  
> >  	early_iounmap(adr, PAGE_SIZE);
> > @@ -259,16 +262,21 @@
> >  		pmd_t *pmd = pmd_page + pmd_index(address);
> >  
> >  		if (address >= end) {
> > -			if (!after_bootmem)
> > +			if (!after_bootmem && !efi_runtime_code_area)
> 
> 
> This one seems also weird. Are you sure this doesn't remove _NX from
> more than the intended area? 
> 
> >  				for (; i < PTRS_PER_PMD; i++, pmd++)
> >  					set_pmd(pmd, __pmd(0));
> >  			break;
> >  		}
> >  
> > -		if (pmd_val(*pmd))
> > +		if (pmd_val(*pmd) && !efi_runtime_code_area)
> >  			continue;
> >  
> > -		entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
> > +		if (efi_runtime_code_area) {
> > +			entry = pmd_val(*pmd);
> > +			entry &= ~_PAGE_NX;
> > +		} else
> > +			entry = _PAGE_NX | _PAGE_PSE | _KERNPG_TABLE | \
> > +				_PAGE_GLOBAL | address;
> 
> This doesn't look correct. PSE/KERNPG/GLOBAL/address surely need to be set
> for EFI areas too.
> 
> The changes to this file are quite messy.
> Perhaps it would be better if you just use change_page_attr() afterwards.
> This would make it using 4K pages instead of 2MB, but that wouldn't be a catastrophe.

The memory area mapping must be changed before time_init, where the
first EFI runtime serivce (efi_get_time) is called. But
"change_page_attr" can not be used there, because "alloc_pages" is used
by "change_page_attr".

Should I change "change_page_attr" to make it work before "mem_init"? Or
Should I change "init_memory_mapping" to make it can be used to change
mapping attributes? Which one is better?

> What exactly are you trying to do here? Just remove _NX for some areas?

Yes. I just want to remove _NX for some areas.

Best Regards,
Huang Ying
