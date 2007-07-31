Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbXGaLf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbXGaLf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbXGaLfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:35:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:38496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXGaLft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:35:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/5] x86_64 EFI support -v3: EFI boot support
Date: Tue, 31 Jul 2007 13:35:40 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1185851576.23149.27.camel@caritas-dev.intel.com>
In-Reply-To: <1185851576.23149.27.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707311335.40235.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  static unsigned long dma_reserve __initdata;
> +/* Flag indicating EFI runtime executable code area */
> +static int efi_runtime_code_area;

We don't normally use globals to modify function behaviour.

>  
>  DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
>  
> @@ -199,7 +202,7 @@
>  static __meminit void unmap_low_page(void *adr)
>  { 
>  
> -	if (after_bootmem)
> +	if (after_bootmem || efi_runtime_code_area)
>  		return;
>  
>  	early_iounmap(adr, PAGE_SIZE);
> @@ -259,16 +262,21 @@
>  		pmd_t *pmd = pmd_page + pmd_index(address);
>  
>  		if (address >= end) {
> -			if (!after_bootmem)
> +			if (!after_bootmem && !efi_runtime_code_area)


This one seems also weird. Are you sure this doesn't remove _NX from
more than the intended area? 

>  				for (; i < PTRS_PER_PMD; i++, pmd++)
>  					set_pmd(pmd, __pmd(0));
>  			break;
>  		}
>  
> -		if (pmd_val(*pmd))
> +		if (pmd_val(*pmd) && !efi_runtime_code_area)
>  			continue;
>  
> -		entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
> +		if (efi_runtime_code_area) {
> +			entry = pmd_val(*pmd);
> +			entry &= ~_PAGE_NX;
> +		} else
> +			entry = _PAGE_NX | _PAGE_PSE | _KERNPG_TABLE | \
> +				_PAGE_GLOBAL | address;

This doesn't look correct. PSE/KERNPG/GLOBAL/address surely need to be set
for EFI areas too.

The changes to this file are quite messy.
Perhaps it would be better if you just use change_page_attr() afterwards.
This would make it using 4K pages instead of 2MB, but that wouldn't be a catastrophe.

What exactly are you trying to do here? Just remove _NX for some areas?

-Andi

