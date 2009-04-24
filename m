Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZDXRWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZDXRWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZDXRVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:21:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52601 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZDXRVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:21:54 -0400
Date: Fri, 24 Apr 2009 19:23:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20090424172358.GA21946@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240519774-20307-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
>  Documentation/mutex-design.txt              |    4 +-
>  arch/alpha/kernel/head.S                    |    2 +-
...
>  include/linux/linkage.h                     |    4 +-
>  include/linux/spinlock.h                    |    2 +-
>  kernel/module.c                             |    2 +-
>  scripts/mod/modpost.c                       |   12 ++++----
>  scripts/recordmcount.pl                     |    6 ++--
>  141 files changed, 356 insertions(+), 348 deletions(-)

This patch touches far too many files.
We should try to work out a method so we are in better control
of the section names, so renaming in the end is a simple patch
touching only a few files.

A few suggestions follows.

> diff --git a/arch/alpha/kernel/head.S b/arch/alpha/kernel/head.S
> index 7ac1f13..16293d4 100644
> --- a/arch/alpha/kernel/head.S
> +++ b/arch/alpha/kernel/head.S
> @@ -10,7 +10,7 @@
>  #include <asm/system.h>
>  #include <asm/asm-offsets.h>
>  
> -.section .text.head, "ax"
> +.section .text..head, "ax"

Use __HEAD (from include/linux/init.h)
Same goes for all other uses of .text.head.


>  .globl swapper_pg_dir
>  .globl _stext
>  swapper_pg_dir=SWAPPER_PGD
> diff --git a/arch/alpha/kernel/init_task.c b/arch/alpha/kernel/init_task.c
> index c2938e5..7929755 100644
> --- a/arch/alpha/kernel/init_task.c
> +++ b/arch/alpha/kernel/init_task.c
> @@ -17,5 +17,5 @@ EXPORT_SYMBOL(init_mm);
>  EXPORT_SYMBOL(init_task);
>  
>  union thread_union init_thread_union
> -	__attribute__((section(".data.init_thread")))
> +	__attribute__((section(".data..init_thread")))
>  	= { INIT_THREAD_INFO(init_task) };

1) Either wait for the consolidation of init_tast or add a:
#define SECTION_INIT_THREAD  __section(".data.init_thread")
to sched.h and use that one for all archs.


> diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
> index ef37fc1..511f8ca 100644
> --- a/arch/alpha/kernel/vmlinux.lds.S
> +++ b/arch/alpha/kernel/vmlinux.lds.S
> @@ -16,7 +16,7 @@ SECTIONS
>  
>  	_text = .;	/* Text and read-only data */
>  	.text : {
> -	*(.text.head)
> +	*(.text..head)
>  		TEXT_TEXT
>  		SCHED_TEXT
>  		LOCK_TEXT

Use HEAD_TEXT (from include/asm-generic/vmlinux.lds.h)


> @@ -93,18 +93,18 @@ SECTIONS
>  	/* Freed after init ends here */
>  
>  	/* Note 2 page alignment above.  */
> -	.data.init_thread : {
> -		*(.data.init_thread)
> +	.data..init_thread : {
> +		*(.data..init_thread)
>  	}

Add something like:
#define DATA_THREAD(aling) \
	...
to vmlinux.lds.h


>  
>  	. = ALIGN(PAGE_SIZE);
> -	.data.page_aligned : {
> -		*(.data.page_aligned)
> +	.data..page_aligned : {
> +		*(.data..page_aligned)
>  	}

Add something like:
#define DATA_PAGE_ALIGNED() \
	...
to vmlinux.lds.h


>  
>  	. = ALIGN(64);
> -	.data.cacheline_aligned : {
> -		*(.data.cacheline_aligned)
> +	.data..cacheline_aligned : {
> +		*(.data..cacheline_aligned)
>  	}

Add something like:
#define DATA_CACHE_ALIGNED() \
	...
to vmlinux.lds.h

>  
>  	_data = .;
> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
> index cc87e17..fcd93f5 100644
> --- a/arch/arm/kernel/head-nommu.S
> +++ b/arch/arm/kernel/head-nommu.S
> @@ -32,7 +32,7 @@
>   * numbers for r1.
>   *
>   */
> -	.section ".text.head", "ax"
> +	.section ".text..head", "ax"
__HEAD

>  ENTRY(stext)
>  	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
>  						@ and irqs disabled
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 21e17dc..705e759 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -74,7 +74,7 @@
>   * crap here - that's what the boot loader (or in extreme, well justified
>   * circumstances, zImage) is for.
>   */
> -	.section ".text.head", "ax"
> +	.section ".text..head", "ax"
__HEAD

>  ENTRY(stext)
>  	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
>  						@ and irqs disabled
> diff --git a/arch/arm/kernel/init_task.c b/arch/arm/kernel/init_task.c
> index e859af3..0b81b8f 100644
> --- a/arch/arm/kernel/init_task.c
> +++ b/arch/arm/kernel/init_task.c
> @@ -29,7 +29,7 @@ EXPORT_SYMBOL(init_mm);
>   * The things we do for performance..
>   */
>  union thread_union init_thread_union
> -	__attribute__((__section__(".data.init_task"))) =
> +	__attribute__((__section__(".data..init_task"))) =
>  		{ INIT_THREAD_INFO(init_task) };
>  
>  /*
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index c90f272..89c97c3 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -23,10 +23,10 @@ SECTIONS
>  #else
>  	. = PAGE_OFFSET + TEXT_OFFSET;
>  #endif
> -	.text.head : {
> +	.text..head : {
>  		_stext = .;
>  		_sinittext = .;
> -		*(.text.head)
> +		*(.text..head)

HEAD_TEXT
>  	}
>  
>  	.init : {			/* Init code and data		*/
> @@ -66,9 +66,9 @@ SECTIONS
>  		. = ALIGN(4096);
>  		__per_cpu_load = .;
>  		__per_cpu_start = .;
> -			*(.data.percpu.page_aligned)
> -			*(.data.percpu)
> -			*(.data.percpu.shared_aligned)
> +			*(.data..percpu.page_aligned)
> +			*(.data..percpu)
> +			*(.data..percpu.shared_aligned)
>  		__per_cpu_end = .;

PERCPU / PERCPU_VADDR


>  #ifndef CONFIG_XIP_KERNEL
>  		__init_begin = _stext;
> @@ -146,7 +146,7 @@ SECTIONS
>  		 * first, the init task union, aligned
>  		 * to an 8192 byte boundary.
>  		 */
> -		*(.data.init_task)
> +		*(.data..init_task)


>  
>  #ifdef CONFIG_XIP_KERNEL
>  		. = ALIGN(4096);
> @@ -158,7 +158,7 @@ SECTIONS
>  

>  		. = ALIGN(4096);
>  		__nosave_begin = .;
> -		*(.data.nosave)
> +		*(.data..nosave)
>  		. = ALIGN(4096);
>  		__nosave_end = .;

Add whole bloce to a DATA_NOSAVE(align) in vmlinux.lds.h


>  
> @@ -166,7 +166,7 @@ SECTIONS
>  		 * then the cacheline aligned data
>  		 */
>  		. = ALIGN(32);
> -		*(.data.cacheline_aligned)
> +		*(.data..cacheline_aligned)
>  
>  		/*
>  		 * The exception fixup table (might need resorting at runtime)
> diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
> index f0cc599..39d8dd1 100644
> --- a/arch/arm/mm/proc-v6.S
> +++ b/arch/arm/mm/proc-v6.S
> @@ -132,7 +132,7 @@ cpu_v6_name:
>  	.asciz	"ARMv6-compatible processor"
>  	.align
>  
> -	.section ".text.init", #alloc, #execinstr
> +	.section ".text..init", #alloc, #execinstr

Use __INIT (from init.h).


I will recommend that you do this in separate steps.
1) Is to define all the new sections to vmlinux.lds.h,
init.h and maybe other files.

To make this complete you need to go through several of the architectures.

If you have this ready soon we can push this upstream so the individual
architectures can apply their modifications.
So step 2 is to create individual patches for each architecture
and the remaining files. We can then carry this in -next until
we hit a merge window.

Until now this is pure cleanup.

The final step is to do the renaming in the few files that hold
the section definitions - it is a simple patch.
And then we can try out function-sections etc.

	Sam
