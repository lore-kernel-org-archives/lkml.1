Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXFALiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXFALiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbXFALih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:38:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:41978 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXFALig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PZRd1kMLgGkxzykbk1DWN79gf1bkUvbcoOTQdPu9lIXJ/J+S5SFjldQl8es10bU93uo9tXmp65DqNhW/TW7yNfo3/XfpvsDehZ/w6oV8799TRKKRQVRFrhmkuMimetRfGzVtK+zGjvrCheKVN3o8ls3o0957e4hL4PIMLFejyz8=
Message-ID: <46600521.8050005@gmail.com>
Date: Fri, 01 Jun 2007 19:38:09 +0800
From: "bibo,mao" <bibo.mao@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: change early_ioremap to static
References: <200705311143.32171.yinghai.lu@sun.com>
In-Reply-To: <200705311143.32171.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi yinghai,
   early_ioremap is useful for early firmware access such as efi
memory map table which does not reside at low memory address. efi patch
patch will use this function, initial efi patch has posted.

thanks
bibo,mao

Yinghai Lu wrote:
> [PATCH] x86_64: change early_ioremap to static
> 
> only dmi_scan_machine==>dmi_present==>dmi_table==>dmi_ioremap uses
> early_ioremap outside of mm/init.c
> dmi_scan_machine is called after init_memory_mappings, and could use
> ioremap instead.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
> index 1336da8..8e3d14c 100644
> --- a/arch/x86_64/mm/init.c
> +++ b/arch/x86_64/mm/init.c
> @@ -174,37 +174,7 @@ __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
>  
>  unsigned long __meminitdata table_start, table_end;
>  
> -static __meminit void *alloc_low_page(unsigned long *phys)
> -{ 
> -	unsigned long pfn = table_end++;
> -	void *adr;
> -
> -	if (after_bootmem) {
> -		adr = (void *)get_zeroed_page(GFP_ATOMIC);
> -		*phys = __pa(adr);
> -		return adr;
> -	}
> -
> -	if (pfn >= end_pfn) 
> -		panic("alloc_low_page: ran out of memory"); 
> -
> -	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
> -	memset(adr, 0, PAGE_SIZE);
> -	*phys  = pfn * PAGE_SIZE;
> -	return adr;
> -}
> -
> -static __meminit void unmap_low_page(void *adr)
> -{ 
> -
> -	if (after_bootmem)
> -		return;
> -
> -	early_iounmap(adr, PAGE_SIZE);
> -} 
> -
> -/* Must run before zap_low_mappings */
> -__meminit void *early_ioremap(unsigned long addr, unsigned long size)
> +static __meminit void *early_ioremap(unsigned long addr, unsigned long size)
>  {
>  	unsigned long vaddr;
>  	pmd_t *pmd, *last_pmd;
> @@ -233,7 +203,7 @@ __meminit void *early_ioremap(unsigned long addr, unsigned long size)
>  }
>  
>  /* To avoid virtual aliases later */
> -__meminit void early_iounmap(void *addr, unsigned long size)
> +static __meminit void early_iounmap(void *addr, unsigned long size)
>  {
>  	unsigned long vaddr;
>  	pmd_t *pmd;
> @@ -247,6 +217,35 @@ __meminit void early_iounmap(void *addr, unsigned long size)
>  	__flush_tlb();
>  }
>  
> +static __meminit void *alloc_low_page(unsigned long *phys)
> +{
> +	unsigned long pfn = table_end++;
> +	void *adr;
> +
> +	if (after_bootmem) {
> +		adr = (void *)get_zeroed_page(GFP_ATOMIC);
> +		*phys = __pa(adr);
> +		return adr;
> +	}
> +
> +	if (pfn >= end_pfn)
> +		panic("alloc_low_page: ran out of memory");
> +
> +	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
> +	memset(adr, 0, PAGE_SIZE);
> +	*phys  = pfn * PAGE_SIZE;
> +	return adr;
> +}
> +
> +static __meminit void unmap_low_page(void *adr)
> +{
> +
> +	if (after_bootmem)
> +		return;
> +
> +	early_iounmap(adr, PAGE_SIZE);
> +}
> +
>  static void __meminit
>  phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
>  {
> diff --git a/include/asm-x86_64/dmi.h b/include/asm-x86_64/dmi.h
> index 93b2b15..fc7b576 100644
> --- a/include/asm-x86_64/dmi.h
> +++ b/include/asm-x86_64/dmi.h
> @@ -3,15 +3,12 @@
>  
>  #include <asm/io.h>
>  
> -extern void *dmi_ioremap(unsigned long addr, unsigned long size);
> -extern void dmi_iounmap(void *addr, unsigned long size);
> -
>  #define DMI_MAX_DATA 2048
>  
>  extern int dmi_alloc_index;
>  extern char dmi_alloc_data[DMI_MAX_DATA];
>  
> -/* This is so early that there is no good way to allocate dynamic memory. 
> +/* This is so early that there is no good way to allocate dynamic memory.
>     Allocate data in an BSS array. */
>  static inline void *dmi_alloc(unsigned len)
>  {
> @@ -21,7 +18,7 @@ static inline void *dmi_alloc(unsigned len)
>  	return dmi_alloc_data + idx;
>  }
>  
> -#define dmi_ioremap early_ioremap
> -#define dmi_iounmap early_iounmap
> +#define dmi_ioremap ioremap
> +#define dmi_iounmap(x,l) iounmap(x)
>  
>  #endif
> diff --git a/include/asm-x86_64/io.h b/include/asm-x86_64/io.h
> index de2cd9a..0898bdc 100644
> --- a/include/asm-x86_64/io.h
> +++ b/include/asm-x86_64/io.h
> @@ -134,9 +134,6 @@ static inline void __iomem * ioremap (unsigned long offset, unsigned long size)
>  	return __ioremap(offset, size, 0);
>  }
>  
> -extern void *early_ioremap(unsigned long addr, unsigned long size);
> -extern void early_iounmap(void *addr, unsigned long size);
> -
>  /*
>   * This one maps high address device memory and turns off caching for that area.
>   * it's useful if some control registers are in such an area and write combining
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

