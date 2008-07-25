Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYGYJPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYGYJPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYGYJPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:15:21 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41466 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYGYJPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:15:20 -0400
Date: Fri, 25 Jul 2008 12:14:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PAGE_ALIGN() compile breakage
Message-ID: <20080725091455.GD19310@cs181140183.pp.htv.fi>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi> <20080725015537.564e3397.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080725015537.564e3397.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 01:55:37AM -0700, Andrew Morton wrote:
> On Fri, 25 Jul 2008 11:39:43 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Commit 27ac792ca0b0a1e7e65f20342260650516c95864
> > (PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures)
> > causes on some architectures (e.g. avr32 and mips) compile errors
> > like the following in some configurations starting with:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      init/main.o
> > In file included from 
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/utsname.h:35,
> >                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:20:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In function 'arch_pick_mmap_layout':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:2149: error: implicit declaration of function 'PAGE_ALIGN'
> > make[2]: *** [init/main.o] Error 1
> > 
> 
> pls test:
> 
> diff -puN include/linux/sched.h~a include/linux/sched.h
> --- a/include/linux/sched.h~a
> +++ a/include/linux/sched.h
> @@ -2139,16 +2139,7 @@ static inline void set_task_cpu(struct t
>  
>  #endif /* CONFIG_SMP */
>  
> -#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>  extern void arch_pick_mmap_layout(struct mm_struct *mm);
> -#else
> -static inline void arch_pick_mmap_layout(struct mm_struct *mm)
> -{
> -	mm->mmap_base = TASK_UNMAPPED_BASE;
> -	mm->get_unmapped_area = arch_get_unmapped_area;
> -	mm->unmap_area = arch_unmap_area;
> -}
> -#endif
>  
>  #ifdef CONFIG_TRACING
>  extern void
> diff -puN mm/mmap.c~a mm/mmap.c
> --- a/mm/mmap.c~a
> +++ a/mm/mmap.c
> @@ -2268,3 +2268,12 @@ int install_special_mapping(struct mm_st
>  
>  	return 0;
>  }
> +
> +#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
> +void arch_pick_mmap_layout(struct mm_struct *mm)
> +{
> +	mm->mmap_base = TASK_UNMAPPED_BASE;
> +	mm->get_unmapped_area = arch_get_unmapped_area;
> +	mm->unmap_area = arch_unmap_area;
> +}
> +#endif

Nice, this seems to fix the problem.

> > and more nasty problems follow later.
> > 
> > My suggestion is to:
> > - revert commit 27ac792ca0b0a1e7e65f20342260650516c95864 and then
> > - fix all PAGE_ALIGN() instances without moving them.
> 
> Every time this patch blew up (and it did it often), fixing it resulted
> in overall improvements.
> 
> > Unifying code is a good thing, but in this case it is not worth the 
> > trouble it causes by poking into the heart of our headers mess.
> 
> Well.   If we leave it a mess, it'll stay a mess.

An interesting question is whether the PAGE_ALIGN() move makes the mess 
bigger or smaller.

Ideally, all headers should be self-contained. IOW, they should #include 
everything they use.

But TASK_UNMAPPED_BASE in asm/processor.h on some architectures uses 
PAGE_ALIGN() that got moved from asm/page.h to linux/mm.h .

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

