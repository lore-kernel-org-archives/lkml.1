Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYAJIPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYAJIPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYAJIPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:15:42 -0500
Received: from koto.vergenet.net ([210.128.90.7]:33577 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYAJIPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:15:41 -0500
Date: Thu, 10 Jan 2008 17:15:37 +0900
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>,
       Ian Campbell <ian.campbell@xensource.com>
Subject: Re: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up -
	add arch_kimage
Message-ID: <20080110081535.GA30505@verge.net.au>
References: <1199847467.8126.15.camel@caritas-dev.intel.com> <20080110011423.GB23143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110011423.GB23143@redhat.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCing Magnus Damm and Ian Campbell ]

On Wed, Jan 09, 2008 at 08:14:23PM -0500, Vivek Goyal wrote:
> On Wed, Jan 09, 2008 at 10:57:47AM +0800, Huang, Ying wrote:
> > This patch add an architecture specific struct arch_kimage into struct
> > kimage. Three pointers to page table pages used by kexec are added to
> > struct arch_kimage. The page tables pages are dynamically allocated in
> > machine_kexec_prepare instead of statically from BSS segment. This
> > will save up to 20k memory when kexec image is not loaded.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> 
> There were some discussions in the past regarding static page table 
> allocation vs dynamic. Can't recall it now though. Eric will know it
> better.
> 
> Anyway, this allocation is taking place at load time and not kexec execute
> time so as such should not be an issue for kdump.

IIRC correctly the previous dynamic page table patches were
posted by Magnus and the discussion mainly revolved around issues of
taste. For what it is worth, I am completely in favour of this change
as not everyone (actually probably very few people) use kexec,
and this is a saving for them - assuming the code bloat is less than 20k.

> Have you tested Xen too? Does it run into issues with this change?

Xen will need to be updated for this change but it shouldn't be a big
deal. Basically right now it calls __ma() (which is kind of like __pa())
on kexec_pgd and friends. Updating the arguments to __ma() to use
the new arch_kimage pointers should be easy enough.

N.B: As this is Dom0 code (not DomU) it is maintained in the xen
repository and has been merged into Linux.

See machine_kexec_setup_load_arg() in
http://xenbits.xensource.com/linux-2.6.18-xen.hg?file/353802ec1caf/arch/i386/kernel/machine_kexec.c

> > ---
> >  arch/x86/kernel/machine_kexec_32.c |   68 +++++++++++++++++++++++++------------
> >  include/asm-x86/kexec_32.h         |   12 ++++++
> >  include/linux/kexec.h              |    4 ++
> >  3 files changed, 63 insertions(+), 21 deletions(-)
> > 
> > --- a/arch/x86/kernel/machine_kexec_32.c
> > +++ b/arch/x86/kernel/machine_kexec_32.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/init.h>
> >  #include <linux/numa.h>
> > +#include <linux/gfp.h>
> >  #include <asm/pgtable.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/tlbflush.h>
> > @@ -21,15 +22,6 @@
> >  #include <asm/desc.h>
> >  #include <asm/system.h>
> >  
> > -#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
> > -static u32 kexec_pgd[1024] PAGE_ALIGNED;
> > -#ifdef CONFIG_X86_PAE
> > -static u32 kexec_pmd0[1024] PAGE_ALIGNED;
> > -static u32 kexec_pmd1[1024] PAGE_ALIGNED;
> > -#endif
> > -static u32 kexec_pte0[1024] PAGE_ALIGNED;
> > -static u32 kexec_pte1[1024] PAGE_ALIGNED;
> > -
> >  static void set_idt(void *newidt, __u16 limit)
> >  {
> >  	struct Xgt_desc_struct curidt;
> > @@ -72,6 +64,28 @@ static void load_segments(void)
> >  #undef __STR
> >  }
> >  
> > +static void alloc_page_tables(struct kimage *image)
> > +{
> 
> This is too generic a name. How about something like
> arch_alloc_kexec_page_tables()
> 
> > +	image->arch_kimage.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
> > +#ifdef CONFIG_X86_PAE
> > +	image->arch_kimage.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +	image->arch_kimage.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +#endif
> > +	image->arch_kimage.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +	image->arch_kimage.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +}
> > +
> > +static void free_page_tables(struct kimage *image)
> > +{
> 
> How about arch_free_kexec_page_tables()
> 
> > +	free_page((unsigned long)image->arch_kimage.pgd);
> > +#ifdef CONFIG_X86_PAE
> > +	free_page((unsigned long)image->arch_kimage.pmd0);
> > +	free_page((unsigned long)image->arch_kimage.pmd1);
> > +#endif
> > +	free_page((unsigned long)image->arch_kimage.pte0);
> > +	free_page((unsigned long)image->arch_kimage.pte1);
> > +}
> > +
> >  /*
> >   * A architecture hook called to validate the
> >   * proposed image and prepare the control pages
> > @@ -83,10 +97,21 @@ static void load_segments(void)
> >   * reboot code buffer to allow us to avoid allocations
> >   * later.
> >   *
> > - * Currently nothing.
> > + * - Allocate page tables
> >   */
> >  int machine_kexec_prepare(struct kimage *image)
> >  {
> > +	alloc_page_tables(image);
> > +	if (!image->arch_kimage.pgd ||
> > +#ifdef CONFIG_X86_PAE
> > +	    !image->arch_kimage.pmd0 ||
> > +	    !image->arch_kimage.pmd1 ||
> > +#endif
> > +	    !image->arch_kimage.pte0 ||
> > +	    !image->arch_kimage.pte1) {
> > +		free_page_tables(image);
> > +		return -ENOMEM;
> 
> I think this error handling can be done in alloc_page_tables() itself and
> following will look neater.
> 
>   if (!alloc_page_tables)
> 	return -ENOMEM.
> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Horms

