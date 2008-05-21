Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbYEUXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbYEUXOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYEUXOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:14:44 -0400
Received: from saeurebad.de ([85.214.36.134]:48440 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYEUXOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:14:43 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
References: <483467CD.90401@goop.org>
	<86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
Date: Thu, 22 May 2008 01:14:16 +0200
In-Reply-To: <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 21 May 2008 13:35:40 -0700")
Message-ID: <87lk232qt3.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Wed, May 21, 2008 at 11:19 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> I'm seeing a crash in current x86.git tip/auto-latest when booting under
>> Xen.  The crash is rather early, but it's in __alloc_bootmem_core() in the
>> final memset clear.  Apparently the allocator is returning a bad page.
>>
>> This points to changes in the setup of the bootmem allocator, and the
>> changes "x86: extend e820 ealy_res support 32bit" make to
>> arch/x86/kernel/setup_32.c:setup_bootmem_allocator() looks like the most
>> likely suspect.  Unfortunately its a rather large patch which is not easy to
>> revert, so I haven't actually confirmed this yet.
>
>
> thanks. please check the attached patch
>
> YH
>
> [PATCH] x86: bootmap size fix for 32 bit
>
> Jeremy Fitzhardinge found
> x86: extend e820 ealy_res support 32bit
> cause regression...
>
> in setup_bootmem_allocator
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index f38d840..938c7b3 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -566,17 +566,22 @@ static void __init relocate_initrd(void)
>  
>  void __init setup_bootmem_allocator(void)
>  {
> +	unsigned long bootmap_pages;
>  	unsigned long bootmap_size, bootmap;
>  	/*
>  	 * Initialize the boot-time allocator (with low memory only):
>  	 */
> -	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
> +	bootmap_pages = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;

Forgot to remove the shift?

>  	bootmap = find_e820_area(min_low_pfn<<PAGE_SHIFT,
> -				 max_low_pfn<<PAGE_SHIFT, bootmap_size,
> +				 max_low_pfn<<PAGE_SHIFT,
> +				 bootmap_pages<<PAGE_SHIFT,

Because this value is hardly sane anymore.

>  				 PAGE_SIZE);
>  	if (bootmap == -1L)
>  		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
>  	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
> +	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
> +		 bootmap, bootmap + bootmap_size - 1,
> +		 bootmap_pages);
>  	register_bootmem_low_pages(max_low_pfn);
>  	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
>  	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);

Besides, what did you want to accomplish?

	Hannes
