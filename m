Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZCMApz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZCMApz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbZCMApm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:45:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:55261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbZCMApl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:45:41 -0400
Message-ID: <49B9AC7F.9030302@kernel.org>
Date: Thu, 12 Mar 2009 17:44:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
References: <49B7EDF4.7060904@goop.org> <49B800B8.2040009@kernel.org> <49B9A1CD.5040704@goop.org>
In-Reply-To: <49B9A1CD.5040704@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> could have more explanation about the 1M size.
>> because initial_pg_tables will sit in it. please consider to add
>> something like
>>
>> in head_32.S
>>
>>  LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
>>  
>>  #if PTRS_PER_PMD > 1
>>  PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
>>  #else
>>  PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
>>  #endif
>>  ALLOCATOR_SLOP = 4
>>   
> 
> OK, how does this look:
> 
> The following changes since commit
> 21e8ba72daf5d7f0af33968f873499c85f96ccef:
>  Jeremy Fitzhardinge (1):
>        x86: use brk allocation for DMI
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk
> 
> Jeremy Fitzhardinge (1):
>      x86: allow extend_brk users to reserve brk space
> 
> Yinghai Lu (1):
>      x86-32: compute initial mapping size more accurately
> 
> arch/x86/include/asm/page_32_types.h |    5 +++++
> arch/x86/include/asm/setup.h         |   30 ++++++++++++++++++++++++++++++
> arch/x86/kernel/head_32.S            |    4 +++-
> arch/x86/kernel/setup.c              |    2 ++
> arch/x86/kernel/vmlinux_32.lds.S     |    4 +++-
> arch/x86/kernel/vmlinux_64.lds.S     |    4 +++-
> 6 files changed, 46 insertions(+), 3 deletions(-)
> 
> git diff 21e8ba72daf5d7f0af33968f873499c85f96ccef..push/x86/brk
> diff --git a/arch/x86/include/asm/page_32_types.h
> b/arch/x86/include/asm/page_32_types.h
> index f1e4a79..0f915ae 100644
> --- a/arch/x86/include/asm/page_32_types.h
> +++ b/arch/x86/include/asm/page_32_types.h
> @@ -39,6 +39,11 @@
> #define __VIRTUAL_MASK_SHIFT    32
> #endif    /* CONFIG_X86_PAE */
> 
> +/*
> + * Kernel image size is limited to 512 MB (see in
> arch/x86/kernel/head_32.S)
> + */
> +#define KERNEL_IMAGE_SIZE    (512 * 1024 * 1024)
> +
> #ifndef __ASSEMBLY__
> 
> /*
> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index 366d366..61b126b 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -104,6 +104,29 @@ extern struct boot_params boot_params;
> extern unsigned long _brk_end;
> void *extend_brk(size_t size, size_t align);
> 
> +/*
> + * Reserve space in the brk section.  The name must be unique within
> + * the file, and somewhat descriptive.  The size is in bytes.  Must be
> + * used at file scope.
> + *
> + * (This uses a temp function to wrap the asm so we can pass it the
> + * size parameter; otherwise we wouldn't be able to.  We can't use a
> + * "section" attribute on a normal variable because it always ends up
> + * being @progbits, which ends up allocating space in the vmlinux
> + * executable.)
> + */
> +#define RESERVE_BRK(name,sz)                        \
> +    static void __section(.discard) __used            \
> +    __brk_reservation_fn_##name##__(void) {                \
> +        asm volatile (                        \
> +            ".pushsection .brk_reservation,\"aw\",@nobits;" \
> +            "__brk_reservation_" #name "__:"        \
> +            " 1:.skip %c0;"                    \
> +            " .size __brk_reservation_" #name "__, . - 1b;"    \
> +            " .popsection"                    \
> +            : : "i" (sz));                    \
> +    }
> +
> #ifdef __i386__
> 
> void __init i386_start_kernel(void);
> @@ -115,6 +138,13 @@ void __init x86_64_start_reservations(char
> *real_mode_data);
> 
> #endif /* __i386__ */
> #endif /* _SETUP */
> +#else
> +#define RESERVE_BRK(name,sz)                \
> +    .pushsection .brk_reservation,"aw",@nobits;    \
> +__brk_reservation_##name##__:                \
> +1:    .skip sz;                    \
> +    .size __brk_reservation_##name##__,.-1b;    \
> +    .popsection
> #endif /* __ASSEMBLY__ */
> #endif  /*  __KERNEL__  */
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index d243437..80dc05e 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -54,7 +54,7 @@
>  *
>  * This should be a multiple of a page.
>  */
> -LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
> +LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
> 
> /*
>  * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
> @@ -75,6 +75,8 @@ ALLOCATOR_SLOP = 4
> 
> INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE +
> ALLOCATOR_SLOP)*PAGE_SIZE_asm

no user for INIT_MAP_BEYOND_END any more.

> 
> +RESERVE_BRK(pagetables, PAGE_TABLE_SIZE * PAGE_SIZE)
> +
> /*
>  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
>  * %esi points to the real-mode code as a 32-bit pointer.
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index b344908..d633958 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -112,6 +112,8 @@
> #define ARCH_SETUP
> #endif
> 
> +RESERVE_BRK(dmi_alloc, 65536);
> +
> unsigned int boot_cpu_id __read_mostly;
> 
> static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
> diff --git a/arch/x86/kernel/vmlinux_32.lds.S
> b/arch/x86/kernel/vmlinux_32.lds.S
> index 1063fbe..4005279 100644
> --- a/arch/x86/kernel/vmlinux_32.lds.S
> +++ b/arch/x86/kernel/vmlinux_32.lds.S
> @@ -192,7 +192,8 @@ SECTIONS
> 
>     . = ALIGN(PAGE_SIZE);
>     __brk_base = . ;
> -    . += 1024 * 1024 ;
> +     . += 64 * 1024 ;    /* 64k slop space */
> +    *(.brk_reservation)    /* areas brk users have reserved */
>     __brk_limit = . ;
> 
>       _end = . ;
> @@ -201,6 +202,7 @@ SECTIONS
>   /* Sections to be discarded */
>   /DISCARD/ : {
>     *(.exitcall.exit)
> +    *(.discard)
>     }
> 
>   STABS_DEBUG

could add 
/*
 * Build-time check on the image size:
 */
ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
        "kernel image bigger than KERNEL_IMAGE_SIZE")


for 32bit

YH

> diff --git a/arch/x86/kernel/vmlinux_64.lds.S
> b/arch/x86/kernel/vmlinux_64.lds.S
> index b8b83e4..47deee3 100644
> --- a/arch/x86/kernel/vmlinux_64.lds.S
> +++ b/arch/x86/kernel/vmlinux_64.lds.S
> @@ -250,7 +250,8 @@ SECTIONS
> 
>      . = ALIGN(PAGE_SIZE);
>      __brk_base = . ;
> -     . += 1024 * 1024 ;
> +     . += 64 * 1024 ;    /* 64k slop space */
> +    *(.brk_reservation)    /* areas brk users have reserved */
>      __brk_limit = . ;
>   }
> 
> @@ -260,6 +261,7 @@ SECTIONS
>   /DISCARD/ : {
>     *(.exitcall.exit)
>     *(.eh_frame)
> +    *(.discard)
>     }
> 
>   STABS_DEBUG
> 

