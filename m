Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZB0U1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZB0U1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZB0U1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:27:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:35272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZB0U1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:27:04 -0500
Message-ID: <49A84C5A.3020304@kernel.org>
Date: Fri, 27 Feb 2009 12:26:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org>
In-Reply-To: <49A829CE.9020509@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> [
> I'd like to add a mechanism like this so I can dynamically allocate some
> Xen-related structures, rather than statically allocating them in the bss,
> both so that Xen has less overhead when it isn't being used, and so I can
> scale better to things like memory size.
> 
> I think this is more widely useful; it would supplant dmi_alloc_data[], for
> example, and I'm sure there's other cases.
> 
> This is fundimentally the same as head_32.S's extension of the bss to build
> the initial kernel mapping, but 64-bit doesn't currently do anything
> analogous
> to this.
> 
> Unfortunately when I use this code as-is I'm getting crashes when the slab
> allocator starts up.  I think this is all correct, but I'm wondering if
> there's something I'm overlooking which is broken in principle.
> 
> So, what am I missing?
> 
> Thanks,
>     J
> ]
> 
> 
> Add a brk()-like allocator which effectively extends the bss
> in order to allow very early code to do dynamic allocations.
> This is better than using statically allocated arrays for
> data in subsystems which may never get used.
> 
> The amount of space available depends on how much the initial
> kernel mappings have covered, and so is fairly limited.
> 
> Not-Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index 66801cb..e6b754b 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -99,6 +99,11 @@ extern struct boot_params boot_params;
>  */
> #define LOWMEMSIZE()    (0x9f000)
> 
> +/* exceedingly early brk-like allocator */
> +extern unsigned long _brk_start, _brk_end;
> +void init_brk(unsigned long start);
> +void *extend_brk(size_t size, size_t align);
> +
> #ifdef __i386__
> 
> void __init i386_start_kernel(void);
> diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
> index ac108d1..fa9ae31 100644
> --- a/arch/x86/kernel/head32.c
> +++ b/arch/x86/kernel/head32.c
> @@ -34,6 +34,8 @@ void __init i386_start_kernel(void)
> 
>     reserve_ebda_region();
> 
> +    init_brk((unsigned long)__va(init_pg_tables_end));
> +
>     /*
>      * At this point everything still needed from the boot loader
>      * or BIOS or kernel text should be early reserved or marked not
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index f5b2722..4b29802 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -91,6 +91,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
>     if (console_loglevel == 10)
>         early_printk("Kernel alive\n");
> 
> +    init_brk((unsigned long)&_end);
> +
>     x86_64_start_reservations(real_mode_data);
> }
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 0d051b4..8899cfa 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -113,6 +113,7 @@
> #endif
> 
> unsigned int boot_cpu_id __read_mostly;
> +__initdata unsigned long _brk_start, _brk_end;
> 
> #ifdef CONFIG_X86_64
> int default_cpu_present_to_apicid(int mps_cpu)
> @@ -335,6 +336,26 @@ static void __init relocate_initrd(void)
> }
> #endif
> 
> +void __init init_brk(unsigned long brk)
> +{
> +    _brk_start = _brk_end = brk;
> +}
> +
> +void * __init extend_brk(size_t size, size_t align)
> +{
> +    size_t mask = align - 1;
> +    void *ret;
> +
> +    BUG_ON(align & mask);
> +
> +    _brk_end = (_brk_end + mask) & ~mask;
> +
> +    ret = (void *)_brk_end;
> +    _brk_end += size;
> +
> +    return ret;
> +}
> +
> static void __init reserve_initrd(void)
> {
>     u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> @@ -727,11 +748,7 @@ void __init setup_arch(char **cmdline_p)
>     init_mm.start_code = (unsigned long) _text;
>     init_mm.end_code = (unsigned long) _etext;
>     init_mm.end_data = (unsigned long) _edata;
> -#ifdef CONFIG_X86_32
> -    init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
> -#else
> -    init_mm.brk = (unsigned long) &_end;
> -#endif
> +    init_mm.brk = _brk_end;
> 
>     code_resource.start = virt_to_phys(_text);
>     code_resource.end = virt_to_phys(_etext)-1;
> @@ -897,6 +914,9 @@ void __init setup_arch(char **cmdline_p)
>     acpi_numa_init();
> #endif
> 
> +    if (_brk_end > _brk_start)
> +        reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
> +
>     initmem_init(0, max_pfn);

it seems reserve _brk_end is some late?

init_memory_mapping(0,...) could get some for direct mapping page table. and it could start from _end...

YH

