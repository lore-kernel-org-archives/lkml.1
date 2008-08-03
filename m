Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYHCEQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYHCEQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYHCEQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:16:29 -0400
Received: from saeurebad.de ([85.214.36.134]:60061 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYHCEQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:16:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/25] x86: alloc dyn_array all alltogether
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
Date: Sun, 03 Aug 2008 06:16:04 +0200
In-Reply-To: <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
	(Yinghai Lu's message of "Sat, 2 Aug 2008 19:59:05 -0700")
Message-ID: <87wsiy20or.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> @@ -544,45 +548,78 @@ void __init __weak thread_info_cache_init(void)
>  void pre_alloc_dyn_array(void)
>  {
>  #ifdef CONFIG_HAVE_DYN_ARRAY
> -	unsigned long size, phys = 0;
> +	unsigned long total_size = 0, size, phys;
> +	unsigned long max_align = 1;
>  	struct dyn_array **daa;
> +	char *ptr;
>  
> +	/* get the total size at first */
>  	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
>  		struct dyn_array *da = *daa;
>  
>  		size = da->size * (*da->nr);
> -		print_fn_descriptor_symbol("dyna_array %s ", da->name);
> -		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
> +		print_fn_descriptor_symbol("dyn_array %s ", da->name);

Is this a correction of a typo you introduced two pages earlier?

> +		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
>  			da->size, *da->nr, da->align);
> -		*da->name = __alloc_bootmem_nopanic(size, da->align, phys);
> -		phys = virt_to_phys(*da->name);
> +		total_size += roundup(size, da->align);
> +		if (da->align > max_align)
> +			max_align = da->align;
> +	}
> +	if (total_size)
> +		printk(KERN_DEBUG "dyn_array total_size: %#lx\n",
> +			 total_size);
> +	else
> +		return;
> +
> +	/* allocate them all together */
> +	max_align = max_t(unsigned long, max_align, PAGE_SIZE);
> +	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
> +	if (!ptr)
> +		panic("Can not alloc dyn_alloc\n");

Uhm... :)

> +
> +	phys = virt_to_phys(ptr);
> +	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
> +		struct dyn_array *da = *daa;
> +
> +		size = da->size * (*da->nr);
> +		print_fn_descriptor_symbol("dyn_array %s ", da->name);
> +
> +		phys = roundup(phys, da->align);
> +		*da->name = phys_to_virt(phys);
>  		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
>  
> +		phys += size;
> +
>  		if (da->init_work)
>  			da->init_work(da);
>  	}
>  #endif
>  }
>  
> -unsigned long per_cpu_dyn_array_size(void)
> +unsigned long per_cpu_dyn_array_size(unsigned long *align)
>  {
>  	unsigned long total_size = 0;
>  #ifdef CONFIG_HAVE_DYN_ARRAY
>  	unsigned long size;
>  	struct dyn_array **daa;
> +	unsigned max_align = 1;
>  
>  	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
>  		struct dyn_array *da = *daa;
>  
>  		size = da->size * (*da->nr);
> -		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
> +		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);
>  		printk(KERN_CONT "size:%#lx nr:%d align:%#lx\n",
>  			da->size, *da->nr, da->align);
>  		total_size += roundup(size, da->align);
> +		if (da->align > max_align)
> +			max_align = da->align;
>  	}
> -	if (total_size)
> -		printk(KERN_DEBUG "per_cpu_dyna_array total_size: %#lx\n",
> +	if (total_size) {
> +		printk(KERN_DEBUG "per_cpu_dyn_array total_size: %#lx\n",
>  			 total_size);

...

> +		*align = max_align;
> +	}
>  #endif
>  	return total_size;
>  }
> @@ -596,14 +633,11 @@ void per_cpu_alloc_dyn_array(int cpu, char *ptr)
>  	void **array;
>  
>  	phys = virt_to_phys(ptr);
> -
>  	for (daa = __per_cpu_dyn_array_start ; daa < __per_cpu_dyn_array_end; daa++) {
>  		struct dyn_array *da = *daa;
>  
>  		size = da->size * (*da->nr);
> -		print_fn_descriptor_symbol("per_cpu_dyna_array %s ", da->name);
> -		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
> -			da->size, *da->nr, da->align);
> +		print_fn_descriptor_symbol("per_cpu_dyn_array %s ", da->name);

...

	Hannes
