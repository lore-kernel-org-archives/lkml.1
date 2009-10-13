Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbZJMXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbZJMXPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbZJMXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:15:30 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:13727 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760939AbZJMXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:15:29 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 19:15:29 EDT
Date: Wed, 14 Oct 2009 09:04:29 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>, Robin Getz <robin.getz@analog.com>
Subject: Re: [PATCH v3] NOMMU: fix malloc performance by adding
	uninitialized flag
Message-ID: <20091013230429.GA32164@securecomputing.com>
References: <3372.1255449822@redhat.com> <1255469467-17065-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1255469467-17065-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 13 Oct 2009 23:04:51.0572 (UTC) FILETIME=[91D1B340:01CA4C59]
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1
X-NAI-Spam-Version: 2.1.0.8975 : core <3383> : streams <287350> : uri <45463
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The NOMMU code currently clears all anonymous mmapped memory.  While this
> is what we want in the default case, all memory allocation from userspace
> under NOMMU has to go through this interface, including malloc() which is
> allowed to return uninitialized memory.  This can easily be a significant
> performance penalty.  So for constrained embedded systems were security is
> irrelevant, allow people to avoid clearing memory unnecessarily.
> 
> This also alters the ELF-FDPIC binfmt such that it obtains uninitialised
> memory for the brk and stack region.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Robin Getz <robin.getz@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: David McCullough <davidm@snapgear.com>

Cheers,
Davidm

> v3
> 	- tweak kconfig desc
> 
>  Documentation/nommu-mmap.txt      |   26 ++++++++++++++++++++++++++
>  fs/binfmt_elf_fdpic.c             |    3 ++-
>  include/asm-generic/mman-common.h |    5 +++++
>  init/Kconfig                      |   22 ++++++++++++++++++++++
>  mm/nommu.c                        |    8 +++++---
>  5 files changed, 60 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/nommu-mmap.txt b/Documentation/nommu-mmap.txt
> index b565e82..8e1ddec 100644
> --- a/Documentation/nommu-mmap.txt
> +++ b/Documentation/nommu-mmap.txt
> @@ -119,6 +119,32 @@ FURTHER NOTES ON NO-MMU MMAP
>       granule but will only discard the excess if appropriately configured as
>       this has an effect on fragmentation.
>  
> + (*) The memory allocated by a request for an anonymous mapping will normally
> +     be cleared by the kernel before being returned in accordance with the
> +     Linux man pages (ver 2.22 or later).
> +
> +     In the MMU case this can be achieved with reasonable performance as
> +     regions are backed by virtual pages, with the contents only being mapped
> +     to cleared physical pages when a write happens on that specific page
> +     (prior to which, the pages are effectively mapped to the global zero page
> +     from which reads can take place).  This spreads out the time it takes to
> +     initialize the contents of a page - depending on the write-usage of the
> +     mapping.
> +
> +     In the no-MMU case, however, anonymous mappings are backed by physical
> +     pages, and the entire map is cleared at allocation time.  This can cause
> +     significant delays during a userspace malloc() as the C library does an
> +     anonymous mapping and the kernel then does a memset for the entire map.
> +
> +     However, for memory that isn't required to be precleared - such as that
> +     returned by malloc() - mmap() can take a MAP_UNINITIALIZED flag to
> +     indicate to the kernel that it shouldn't bother clearing the memory before
> +     returning it.  Note that CONFIG_MMAP_ALLOW_UNINITIALIZED must be enabled
> +     to permit this, otherwise the flag will be ignored.
> +
> +     uClibc uses this to speed up malloc(), and the ELF-FDPIC binfmt uses this
> +     to allocate the brk and stack region.
> +
>   (*) A list of all the private copy and anonymous mappings on the system is
>       visible through /proc/maps in no-MMU mode.
>  
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 38502c6..79d2b1a 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -380,7 +380,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
>  	down_write(&current->mm->mmap_sem);
>  	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
>  					 PROT_READ | PROT_WRITE | PROT_EXEC,
> -					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
> +					 MAP_PRIVATE | MAP_ANONYMOUS |
> +					 MAP_UNINITIALIZED | MAP_GROWSDOWN,
>  					 0);
>  
>  	if (IS_ERR_VALUE(current->mm->start_brk)) {
> diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
> index 5ee13b2..2011126 100644
> --- a/include/asm-generic/mman-common.h
> +++ b/include/asm-generic/mman-common.h
> @@ -19,6 +19,11 @@
>  #define MAP_TYPE	0x0f		/* Mask for type of mapping */
>  #define MAP_FIXED	0x10		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x20		/* don't use a file */
> +#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
> +# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
> +#else
> +# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
> +#endif
>  
>  #define MS_ASYNC	1		/* sync memory asynchronously */
>  #define MS_INVALIDATE	2		/* invalidate the caches */
> diff --git a/init/Kconfig b/init/Kconfig
> index 09c5c64..309cd9a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1069,6 +1069,28 @@ config SLOB
>  
>  endchoice
>  
> +config MMAP_ALLOW_UNINITIALIZED
> +	bool "Allow mmapped anonymous memory to be uninitialized"
> +	depends on EMBEDDED && !MMU
> +	default n
> +	help
> +	  Normally, and according to the Linux spec, anonymous memory obtained
> +	  from mmap() has it's contents cleared before it is passed to
> +	  userspace.  Enabling this config option allows you to request that
> +	  mmap() skip that if it is given an MAP_UNINITIALIZED flag, thus
> +	  providing a huge performance boost.  If this option is not enabled,
> +	  then the flag will be ignored.
> +
> +	  This is taken advantage of by uClibc's malloc(), and also by
> +	  ELF-FDPIC binfmt's brk and stack allocator.
> +
> +	  Because of the obvious security issues, this option should only be
> +	  enabled on embedded devices where you control what is run in
> +	  userspace.  Since that isn't generally a problem on no-MMU systems,
> +	  it is normally safe to say Y here.
> +
> +	  See Documentation/nommu-mmap.txt for more information.
> +
>  config PROFILING
>  	bool "Profiling support (EXPERIMENTAL)"
>  	help
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 5189b5a..11e8231 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1143,9 +1143,6 @@ static int do_mmap_private(struct vm_area_struct *vma,
>  		if (ret < rlen)
>  			memset(base + ret, 0, rlen - ret);
>  
> -	} else {
> -		/* if it's an anonymous mapping, then just clear it */
> -		memset(base, 0, rlen);
>  	}
>  
>  	return 0;
> @@ -1343,6 +1340,11 @@ unsigned long do_mmap_pgoff(struct file *file,
>  		goto error_just_free;
>  	add_nommu_region(region);
>  
> +	/* clear anonymous mappings that don't ask for uninitialized data */
> +	if (!vma->vm_file && !(flags & MAP_UNINITIALIZED))
> +		memset((void *)region->vm_start, 0,
> +		       region->vm_end - region->vm_start);
> +
>  	/* okay... we have a mapping; now we have to register it */
>  	result = vma->vm_start;
>  
> -- 
> 1.6.5
> 
> 
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
