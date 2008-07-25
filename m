Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYGYJ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYGYJ2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYGYJ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:28:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42032 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYGYJ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:28:12 -0400
Date: Fri, 25 Jul 2008 12:27:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PAGE_ALIGN() compile breakage
Message-ID: <20080725092748.GF19310@cs181140183.pp.htv.fi>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi> <20080725015537.564e3397.akpm@linux-foundation.org> <20080725091455.GD19310@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080725091455.GD19310@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 12:14:55PM +0300, Adrian Bunk wrote:
> On Fri, Jul 25, 2008 at 01:55:37AM -0700, Andrew Morton wrote:
>...
> > pls test:
> > 
> > diff -puN include/linux/sched.h~a include/linux/sched.h
> > --- a/include/linux/sched.h~a
> > +++ a/include/linux/sched.h
> > @@ -2139,16 +2139,7 @@ static inline void set_task_cpu(struct t
> >  
> >  #endif /* CONFIG_SMP */
> >  
> > -#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
> >  extern void arch_pick_mmap_layout(struct mm_struct *mm);
> > -#else
> > -static inline void arch_pick_mmap_layout(struct mm_struct *mm)
> > -{
> > -	mm->mmap_base = TASK_UNMAPPED_BASE;
> > -	mm->get_unmapped_area = arch_get_unmapped_area;
> > -	mm->unmap_area = arch_unmap_area;
> > -}
> > -#endif
> >  
> >  #ifdef CONFIG_TRACING
> >  extern void
> > diff -puN mm/mmap.c~a mm/mmap.c
> > --- a/mm/mmap.c~a
> > +++ a/mm/mmap.c
> > @@ -2268,3 +2268,12 @@ int install_special_mapping(struct mm_st
> >  
> >  	return 0;
> >  }
> > +
> > +#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
> > +void arch_pick_mmap_layout(struct mm_struct *mm)
> > +{
> > +	mm->mmap_base = TASK_UNMAPPED_BASE;
> > +	mm->get_unmapped_area = arch_get_unmapped_area;
> > +	mm->unmap_area = arch_unmap_area;
> > +}
> > +#endif
> 
> Nice, this seems to fix the problem.
>...

Further testing revealed that you should choose a file that also gets 
compiled on MMU-less architectures:

<--  snip  -->

...
  LD      vmlinux
fs/built-in.o: In function `flush_old_exec':
(.text+0x6ae8): undefined reference to `arch_pick_mmap_layout'
fs/built-in.o: In function `flush_old_exec':
(.text+0x6cf0): undefined reference to `arch_pick_mmap_layout'
make[1]: *** [vmlinux] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

