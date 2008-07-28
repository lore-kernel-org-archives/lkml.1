Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYG1VhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYG1VhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYG1Vgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:36:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbYG1Vgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:36:54 -0400
Message-ID: <488E3BF4.5060306@sgi.com>
Date: Mon, 28 Jul 2008 14:36:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [rfc git pull] cpus4096 fixes, take 2
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu>
In-Reply-To: <20080728205700.GA3613@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great work, thanks to both Linus and you!  (And of course Rusty who noticed the
original failure.)

I've also tested a few more configs incl both NR_CPUS=4096 & !SMP 

Acked-by: Mike Travis <travis@sgi.com>

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>> But I'll redo the patch again.
>> Here's a trivial setup, that is even tested. It's _small_ too.
>>
>> 	/* cpu_bit_bitmap[0] is empty - so we can back into it */
>> 	#define MASK_DECLARE_1(x) [x+1][0] = 1ul << (x)
>> 	#define MASK_DECLARE_2(x) MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
>> 	#define MASK_DECLARE_4(x) MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
>> 	#define MASK_DECLARE_8(x) MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
>>
>> 	static const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
>> 		MASK_DECLARE_8(0), MASK_DECLARE_8(8),
>> 		MASK_DECLARE_8(16), MASK_DECLARE_8(24),
>> 	#if BITS_PER_LONG > 32
>> 		MASK_DECLARE_8(32), MASK_DECLARE_8(40),
>> 		MASK_DECLARE_8(48), MASK_DECLARE_8(56),
>> 	#endif
>> 	};
>>
>> 	static inline const cpumask_t *get_cpu_mask(unsigned int nr)
>> 	{
>> 		const unsigned long *p = cpu_bit_bitmap[1 + nr % BITS_PER_LONG];
>> 		p -= nr / BITS_PER_LONG;
>> 		return (const cpumask_t *)p;
>> 	}
>>
>> that should be all you need to do.
>>
>> Honesty in advertizing: my "testing" was some trivial user-space 
>> harness, maybe I had some bug in it. But at least it's not _horribly_ 
>> wrong.
> 
> Amazing! Your code, once plugged into the kernel proper, booted fine on 
> 5 different x86 testsystems, it booted fine an allyesconfig kernel with 
> MAXSMP and NR_CPUS=4096, it booted fine on allnoconfig as well (and 
> allmodconfig and on a good number of randconfigs as well).
> 
>> And yes, this has the added optimization from Viro of overlapping the 
>> cpumask_t's internally too, rather than making them twice the size. So 
>> with 4096 CPU's, this should result 32.5kB of static const data.
> 
> What do you think about the commit below?
> 
> I've put your fix into:
> 
>   # e56b3bc: cpu masks: optimize and clean up cpumask_of_cpu()
> 
> It's quoted fully below after the pull request diffstat. Have i missed 
> anything obvious?
> 
> What i'm unsure about are other architectures. (Small detail i just 
> noticed: HAVE_CPUMASK_OF_CPU_MAP is now orphaned in arch/x86/Kconfig, 
> will get rid of that in a separate change, i dont want to upset the test 
> results.)
> 
> ( And ... because v1 of your code was so frustratingly and
>   mind-blowingly stable in testing (breaking a long track record of v1 
>   patches in this area of kernel), and because the perfect patch does 
>   not exist by definition, i thought i'd mention that after a long 
>   search i found and fixed a serious showstopper bug in your code: you 
>   used "1ul" in your macros, instead of the more proper "1UL" style. The
>   ratio between the use of 1ul versus 1UL is 1:30 in the tree, so your 
>   choice of integer literals type suffix capitalization was deemed 
>   un-Linuxish, and was fixed up for good. )
> 
> 	Ingo
> 
> ---------------->
> Linus,
> 
> Please pull the latest cpus4096 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Ingo Molnar (1):
>       cpumask: export cpumask_of_cpu_map
> 
> Linus Torvalds (1):
>       cpu masks: optimize and clean up cpumask_of_cpu()
> 
> Mike Travis (3):
>       cpumask: make cpumask_of_cpu_map generic
>       cpumask: put cpumask_of_cpu_map in the initdata section
>       cpumask: change cpumask_of_cpu_ptr to use new cpumask_of_cpu
> 
> 
>  arch/x86/kernel/acpi/cstate.c                    |    3 +-
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 +---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   15 ++----
>  arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   12 ++---
>  arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    3 +-
>  arch/x86/kernel/cpu/intel_cacheinfo.c            |    3 +-
>  arch/x86/kernel/ldt.c                            |    6 +--
>  arch/x86/kernel/microcode.c                      |   17 ++----
>  arch/x86/kernel/reboot.c                         |   11 +---
>  arch/x86/kernel/setup_percpu.c                   |   21 -------
>  drivers/acpi/processor_throttling.c              |   11 +---
>  drivers/firmware/dcdbas.c                        |    3 +-
>  drivers/misc/sgi-xp/xpc_main.c                   |    3 +-
>  include/linux/cpumask.h                          |   63 ++++++++-------------
>  kernel/cpu.c                                     |   25 +++++++++
>  kernel/stop_machine.c                            |    3 +-
>  kernel/time/tick-common.c                        |    8 +--
>  kernel/trace/trace_sysprof.c                     |    4 +-
>  lib/smp_processor_id.c                           |    5 +--
>  net/sunrpc/svc.c                                 |    3 +-
>  20 files changed, 86 insertions(+), 143 deletions(-)
> 
> ---->
> 
>   # e56b3bc: cpu masks: optimize and clean up cpumask_of_cpu()
> 
>>From e56b3bc7942982ac2589c942fb345e38bc7a341a Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 28 Jul 2008 11:32:33 -0700
> Subject: [PATCH] cpu masks: optimize and clean up cpumask_of_cpu()
> 
> Clean up and optimize cpumask_of_cpu(), by sharing all the zero words.
> 
> Instead of stupidly generating all possible i=0...NR_CPUS 2^i patterns
> creating a huge array of constant bitmasks, realize that the zero words
> can be shared.
> 
> In other words, on a 64-bit architecture, we only ever need 64 of these
> arrays - with a different bit set in one single world (with enough zero
> words around it so that we can create any bitmask by just offsetting in
> that big array). And then we just put enough zeroes around it that we
> can point every single cpumask to be one of those things.
> 
> So when we have 4k CPU's, instead of having 4k arrays (of 4k bits each,
> with one bit set in each array - 2MB memory total), we have exactly 64
> arrays instead, each 8k bits in size (64kB total).
> 
> And then we just point cpumask(n) to the right position (which we can
> calculate dynamically). Once we have the right arrays, getting
> "cpumask(n)" ends up being:
> 
>   static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
>   {
>           const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
>           p -= cpu / BITS_PER_LONG;
>           return (const cpumask_t *)p;
>   }
> 
> This brings other advantages and simplifications as well:
> 
>  - we are not wasting memory that is just filled with a single bit in
>    various different places
> 
>  - we don't need all those games to re-create the arrays in some dense
>    format, because they're already going to be dense enough.
> 
> if we compile a kernel for up to 4k CPU's, "wasting" that 64kB of memory
> is a non-issue (especially since by doing this "overlapping" trick we
> probably get better cache behaviour anyway).
> 
> [ mingo@elte.hu:
> 
>   Converted Linus's mails into a commit. See:
> 
>      http://lkml.org/lkml/2008/7/27/156
>      http://lkml.org/lkml/2008/7/28/320
> 
>   Also applied a family filter - which also has the side-effect of leaving
>   out the bits where Linus calls me an idio... Oh, never mind ;-)
> ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Mike Travis <travis@sgi.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/setup_percpu.c |   23 -------
>  include/linux/cpumask.h        |   26 +++++++-
>  kernel/cpu.c                   |  128 ++++++---------------------------------
>  3 files changed, 43 insertions(+), 134 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index 1cd53df..76e305e 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -80,26 +80,6 @@ static void __init setup_per_cpu_maps(void)
>  #endif
>  }
>  
> -#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
> -/*
> - * Replace static cpumask_of_cpu_map in the initdata section,
> - * with one that's allocated sized by the possible number of cpus.
> - *
> - * (requires nr_cpu_ids to be initialized)
> - */
> -static void __init setup_cpumask_of_cpu(void)
> -{
> -	int i;
> -
> -	/* alloc_bootmem zeroes memory */
> -	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
> -	for (i = 0; i < nr_cpu_ids; i++)
> -		cpu_set(i, cpumask_of_cpu_map[i]);
> -}
> -#else
> -static inline void setup_cpumask_of_cpu(void) { }
> -#endif
> -
>  #ifdef CONFIG_X86_32
>  /*
>   * Great future not-so-futuristic plan: make i386 and x86_64 do it
> @@ -199,9 +179,6 @@ void __init setup_per_cpu_areas(void)
>  
>  	/* Setup node to cpumask map */
>  	setup_node_to_cpumask_map();
> -
> -	/* Setup cpumask_of_cpu map */
> -	setup_cpumask_of_cpu();
>  }
>  
>  #endif
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 8fa3b6d..96d0509 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -265,10 +265,30 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
>  	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
>  }
>  
> +/*
> + * Special-case data structure for "single bit set only" constant CPU masks.
> + *
> + * We pre-generate all the 64 (or 32) possible bit positions, with enough
> + * padding to the left and the right, and return the constant pointer
> + * appropriately offset.
> + */
> +extern const unsigned long
> +	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
> +
> +static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
> +{
> +	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
> +	p -= cpu / BITS_PER_LONG;
> +	return (const cpumask_t *)p;
> +}
> +
> +/*
> + * In cases where we take the address of the cpumask immediately,
> + * gcc optimizes it out (it's a constant) and there's no huge stack
> + * variable created:
> + */
> +#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
>  
> -/* cpumask_of_cpu_map[] is in kernel/cpu.c */
> -extern const cpumask_t *cpumask_of_cpu_map;
> -#define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
>  
>  #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
>  
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a35d899..06a8358 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -462,115 +462,27 @@ out:
>  
>  #endif /* CONFIG_SMP */
>  
> -/* 64 bits of zeros, for initializers. */
> -#if BITS_PER_LONG == 32
> -#define Z64 0, 0
> -#else
> -#define Z64 0
> -#endif
> +/*
> + * cpu_bit_bitmap[] is a special, "compressed" data structure that
> + * represents all NR_CPUS bits binary values of 1<<nr.
> + *
> + * It is used by cpumask_of_cpu() to get a constant address to a CPU
> + * mask value that has a single bit set only.
> + */
>  
> -/* Initializer macros. */
> -#define CMI0(n) { .bits = { 1UL << (n) } }
> -#define CMI(n, ...) { .bits = { __VA_ARGS__, 1UL << ((n) % BITS_PER_LONG) } }
> -
> -#define CMI8(n, ...)						\
> -	CMI((n), __VA_ARGS__), CMI((n)+1, __VA_ARGS__),		\
> -	CMI((n)+2, __VA_ARGS__), CMI((n)+3, __VA_ARGS__),	\
> -	CMI((n)+4, __VA_ARGS__), CMI((n)+5, __VA_ARGS__),	\
> -	CMI((n)+6, __VA_ARGS__), CMI((n)+7, __VA_ARGS__)
> -
> -#if BITS_PER_LONG == 32
> -#define CMI64(n, ...)							\
> -	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
> -	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
> -	CMI8((n)+32, 0, __VA_ARGS__), CMI8((n)+40, 0, __VA_ARGS__),	\
> -	CMI8((n)+48, 0, __VA_ARGS__), CMI8((n)+56, 0, __VA_ARGS__)
> -#else
> -#define CMI64(n, ...)							\
> -	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
> -	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
> -	CMI8((n)+32, __VA_ARGS__), CMI8((n)+40, __VA_ARGS__),	\
> -	CMI8((n)+48, __VA_ARGS__), CMI8((n)+56, __VA_ARGS__)
> -#endif
> +/* cpu_bit_bitmap[0] is empty - so we can back into it */
> +#define MASK_DECLARE_1(x)	[x+1][0] = 1UL << (x)
> +#define MASK_DECLARE_2(x)	MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
> +#define MASK_DECLARE_4(x)	MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
> +#define MASK_DECLARE_8(x)	MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
>  
> -#define CMI256(n, ...)							\
> -	CMI64((n), __VA_ARGS__), CMI64((n)+64, Z64, __VA_ARGS__),	\
> -	CMI64((n)+128, Z64, Z64, __VA_ARGS__),				\
> -	CMI64((n)+192, Z64, Z64, Z64, __VA_ARGS__)
> -#define Z256 Z64, Z64, Z64, Z64
> -
> -#define CMI1024(n, ...)					\
> -	CMI256((n), __VA_ARGS__),			\
> -	CMI256((n)+256, Z256, __VA_ARGS__),		\
> -	CMI256((n)+512, Z256, Z256, __VA_ARGS__),	\
> -	CMI256((n)+768, Z256, Z256, Z256, __VA_ARGS__)
> -#define Z1024 Z256, Z256, Z256, Z256
> -
> -/* We want this statically initialized, just to be safe.  We try not
> - * to waste too much space, either. */
> -static const cpumask_t cpumask_map[]
> -#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
> -__initdata
> -#endif
> -= {
> -	CMI0(0), CMI0(1), CMI0(2), CMI0(3),
> -#if NR_CPUS > 4
> -	CMI0(4), CMI0(5), CMI0(6), CMI0(7),
> -#endif
> -#if NR_CPUS > 8
> -	CMI0(8), CMI0(9), CMI0(10), CMI0(11),
> -	CMI0(12), CMI0(13), CMI0(14), CMI0(15),
> -#endif
> -#if NR_CPUS > 16
> -	CMI0(16), CMI0(17), CMI0(18), CMI0(19),
> -	CMI0(20), CMI0(21), CMI0(22), CMI0(23),
> -	CMI0(24), CMI0(25), CMI0(26), CMI0(27),
> -	CMI0(28), CMI0(29), CMI0(30), CMI0(31),
> -#endif
> -#if NR_CPUS > 32
> -#if BITS_PER_LONG == 32
> -	CMI(32, 0), CMI(33, 0), CMI(34, 0), CMI(35, 0),
> -	CMI(36, 0), CMI(37, 0), CMI(38, 0), CMI(39, 0),
> -	CMI(40, 0), CMI(41, 0), CMI(42, 0), CMI(43, 0),
> -	CMI(44, 0), CMI(45, 0), CMI(46, 0), CMI(47, 0),
> -	CMI(48, 0), CMI(49, 0), CMI(50, 0), CMI(51, 0),
> -	CMI(52, 0), CMI(53, 0), CMI(54, 0), CMI(55, 0),
> -	CMI(56, 0), CMI(57, 0), CMI(58, 0), CMI(59, 0),
> -	CMI(60, 0), CMI(61, 0), CMI(62, 0), CMI(63, 0),
> -#else
> -	CMI0(32), CMI0(33), CMI0(34), CMI0(35),
> -	CMI0(36), CMI0(37), CMI0(38), CMI0(39),
> -	CMI0(40), CMI0(41), CMI0(42), CMI0(43),
> -	CMI0(44), CMI0(45), CMI0(46), CMI0(47),
> -	CMI0(48), CMI0(49), CMI0(50), CMI0(51),
> -	CMI0(52), CMI0(53), CMI0(54), CMI0(55),
> -	CMI0(56), CMI0(57), CMI0(58), CMI0(59),
> -	CMI0(60), CMI0(61), CMI0(62), CMI0(63),
> -#endif /* BITS_PER_LONG == 64 */
> -#endif
> -#if NR_CPUS > 64
> -	CMI64(64, Z64),
> -#endif
> -#if NR_CPUS > 128
> -	CMI64(128, Z64, Z64), CMI64(192, Z64, Z64, Z64),
> -#endif
> -#if NR_CPUS > 256
> -	CMI256(256, Z256),
> -#endif
> -#if NR_CPUS > 512
> -	CMI256(512, Z256, Z256), CMI256(768, Z256, Z256, Z256),
> -#endif
> -#if NR_CPUS > 1024
> -	CMI1024(1024, Z1024),
> -#endif
> -#if NR_CPUS > 2048
> -	CMI1024(2048, Z1024, Z1024), CMI1024(3072, Z1024, Z1024, Z1024),
> -#endif
> -#if NR_CPUS > 4096
> -#error NR_CPUS too big.  Fix initializers or set CONFIG_HAVE_CPUMASK_OF_CPU_MAP
> +const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
> +
> +	MASK_DECLARE_8(0),	MASK_DECLARE_8(8),
> +	MASK_DECLARE_8(16),	MASK_DECLARE_8(24),
> +#if BITS_PER_LONG > 32
> +	MASK_DECLARE_8(32),	MASK_DECLARE_8(40),
> +	MASK_DECLARE_8(48),	MASK_DECLARE_8(56),
>  #endif
>  };
> -
> -const cpumask_t *cpumask_of_cpu_map = cpumask_map;
> -
> -EXPORT_SYMBOL_GPL(cpumask_of_cpu_map);
> +EXPORT_SYMBOL_GPL(cpu_bit_bitmap);

