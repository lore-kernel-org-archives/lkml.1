Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0CESSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:18:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:51794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0CESSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:18:51 -0500
Message-ID: <4B914A61.20409@kernel.org>
Date: Fri, 05 Mar 2010 10:16:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Infinite loop on boot in free_early_partial due to start==end
 on tip/master
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
In-Reply-To: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> It's also possible that the presence or absence of PSE is responsible,
> since it impacts atom_size which feeds into alloc_size and has an impact
> on all these calculations.
> 
> I was able to reproduce on native 32 bit by disabling PSE and
> artificially increasing dyn_size.
> 
> (early) [    0.000000] pcpu_build_alloc_info initial max_upa/upa is 1
> (early) [    0.000000] pcpu_build_alloc_info after expansion best_upa/upa is 1
> (early) [    0.000000] reserve_early_without_check: 0x1ce3000-0x1ce4000 "BOOTMEM"
> (early) [    0.000000] pcpu_build_alloc_info unit_size 122880 == alloc_size 122880 / upa 1
> (early) [    0.000000] pcpu_embed_first_chunk size_sum = 122880
> (early) [    0.000000] pcpu_embed_first_chunk  static_size   = 91304
> (early) [    0.000000] pcpu_embed_first_chunk  reserved_size = 8192
> (early) [    0.000000] pcpu_embed_first_chunk  dyn_size      = 23384
> (early) [    0.000000] pcpu_embed_first_chunk unit_size 122880
> 
> I guess the arises from fb90ef93 "early_res: Add free_early_partial"
> since I don't see any other changes in this area recently.
> 
> Following patch fixes this specific issue and adds a warning to catch
> future potential errors of this type.
> 
> --- 
> Subject: x86: do not free zero sized per cpu areas
> 
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> 
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index ef6370b..89a3205 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
>  #ifdef CONFIG_NO_BOOTMEM
>  	u64 start = __pa(ptr);
>  	u64 end = start + size;
> -	free_early_partial(start, end);
> +	if (start < end)
> +		free_early_partial(start, end);
>  #else
>  	free_bootmem(__pa(ptr), size);
>  #endif
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 3cb2c66..fbde443 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -333,6 +333,8 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	WARN_ON(start>=end);
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)
> 

can you change to 

> @@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	if (unlikely(start>=end)) {
> +		WARN_ONCE(1, "free_early_partial get wrong start/end\n:);
> +		return;
> +	}
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)
> 

Thanks

Yinghai
