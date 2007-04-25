Return-Path: <linux-kernel-owner+w=401wt.eu-S2992812AbXDYQXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992812AbXDYQXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992826AbXDYQXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:23:23 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:43163 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992828AbXDYQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:23:17 -0400
Date: Wed, 25 Apr 2007 17:23:13 +0100
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       y-goto@jp.fujitsu.com, apw@shadowen.org
Subject: Re: + handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch added to -mm tree
Message-ID: <20070425162313.GA30246@skynet.ie>
References: <200704242104.l3OL4SV3019236@shell0.pdx.osdl.net> <20070425080846.3b03299c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070425080846.3b03299c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/04/07 08:08), Randy Dunlap didst pronounce:
> On Tue, 24 Apr 2007 14:04:28 -0700 akpm@linux-foundation.org wrote:
> 
> > 
> > The patch titled
> >      Handle kernelcore= boot parameter in common code to avoid boot problem on IA64
> > has been added to the -mm tree.  Its filename is
> >      handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > ------------------------------------------------------
> > Subject: Handle kernelcore= boot parameter in common code to avoid boot problem on IA64
> > From: Yasunori Goto <y-goto@jp.fujitsu.com>
> > 
> > When "kernelcore" boot option is specified, kernel can't boot up on ia64
> > because of an infinite loop.  In addition, the parsing code can be handled
> > in an architecture-independent manner.
> 
> Is this boot option documented anywhere in the kernel source tree?
> 

Documentation/kernel-parameters.txt

> 
> > This patch patches uses common code to handle the kernelcore= parameter. 
> > It is only available to architectures that support arch-independent
> > zone-sizing (i.e.  define CONFIG_ARCH_POPULATES_NODE_MAP).  Other
> > architectures will ignore the boot parameter.
> > 
> > This effectively removes the following arch-specific patches;
> > 
> > ia64-specify-amount-of-kernel-memory-at-boot-time.patch
> > ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
> > x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
> > x86-specify-amount-of-kernel-memory-at-boot-time.patch
> > 
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Acked-by: Andy Whitcroft <apw@shadowen.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  arch/i386/kernel/setup.c   |    1 -
> >  arch/ia64/kernel/efi.c     |    2 --
> >  arch/powerpc/kernel/prom.c |    1 -
> >  arch/ppc/mm/init.c         |    2 --
> >  arch/x86_64/kernel/e820.c  |    1 -
> >  include/linux/mm.h         |    1 -
> >  mm/page_alloc.c            |    3 +++
> >  7 files changed, 3 insertions(+), 8 deletions(-)
> > 
> > diff -puN arch/i386/kernel/setup.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 arch/i386/kernel/setup.c
> > --- a/arch/i386/kernel/setup.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/arch/i386/kernel/setup.c
> > @@ -195,7 +195,6 @@ static int __init parse_mem(char *arg)
> >  	return 0;
> >  }
> >  early_param("mem", parse_mem);
> > -early_param("kernelcore", cmdline_parse_kernelcore);
> >  
> >  #ifdef CONFIG_PROC_VMCORE
> >  /* elfcorehdr= specifies the location of elf core header
> > diff -puN arch/ia64/kernel/efi.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 arch/ia64/kernel/efi.c
> > --- a/arch/ia64/kernel/efi.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/arch/ia64/kernel/efi.c
> > @@ -423,8 +423,6 @@ efi_init (void)
> >  			mem_limit = memparse(cp + 4, &cp);
> >  		} else if (memcmp(cp, "max_addr=", 9) == 0) {
> >  			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
> > -		} else if (memcmp(cp, "kernelcore=",11) == 0) {
> > -			cmdline_parse_kernelcore(cp+11);
> >  		} else if (memcmp(cp, "min_addr=", 9) == 0) {
> >  			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
> >  		} else {
> > diff -puN arch/powerpc/kernel/prom.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 arch/powerpc/kernel/prom.c
> > --- a/arch/powerpc/kernel/prom.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/arch/powerpc/kernel/prom.c
> > @@ -432,7 +432,6 @@ static int __init early_parse_mem(char *
> >  	return 0;
> >  }
> >  early_param("mem", early_parse_mem);
> > -early_param("kernelcore", cmdline_parse_kernelcore);
> >  
> >  /*
> >   * The device tree may be allocated below our memory limit, or inside the
> > diff -puN arch/ppc/mm/init.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 arch/ppc/mm/init.c
> > --- a/arch/ppc/mm/init.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/arch/ppc/mm/init.c
> > @@ -214,8 +214,6 @@ void MMU_setup(void)
> >  	}
> >  }
> >  
> > -early_param("kernelcore", cmdline_parse_kernelcore);
> > -
> >  /*
> >   * MMU_init sets up the basic memory mappings for the kernel,
> >   * including both RAM and possibly some I/O regions,
> > diff -puN arch/x86_64/kernel/e820.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 arch/x86_64/kernel/e820.c
> > --- a/arch/x86_64/kernel/e820.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/arch/x86_64/kernel/e820.c
> > @@ -618,7 +618,6 @@ static int __init parse_memopt(char *p)
> >  	return 0;
> >  } 
> >  early_param("mem", parse_memopt);
> > -early_param("kernelcore", cmdline_parse_kernelcore);
> >  
> >  static int userdef __initdata;
> >  
> > diff -puN include/linux/mm.h~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 include/linux/mm.h
> > --- a/include/linux/mm.h~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/include/linux/mm.h
> > @@ -988,7 +988,6 @@ extern unsigned long find_max_pfn_with_a
> >  extern void free_bootmem_with_active_regions(int nid,
> >  						unsigned long max_low_pfn);
> >  extern void sparse_memory_present_with_active_regions(int nid);
> > -extern int cmdline_parse_kernelcore(char *p);
> >  #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> >  extern int early_pfn_to_nid(unsigned long pfn);
> >  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> > diff -puN mm/page_alloc.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64 mm/page_alloc.c
> > --- a/mm/page_alloc.c~handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64
> > +++ a/mm/page_alloc.c
> > @@ -3542,6 +3542,9 @@ int __init cmdline_parse_kernelcore(char
> >  
> >  	return 0;
> >  }
> > +
> > +early_param("kernelcore", cmdline_parse_kernelcore);
> > +
> >  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
> >  
> >  /**
> > _
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
