Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYAJBOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYAJBOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYAJBO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:14:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYAJBO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:14:28 -0500
Date: Wed, 9 Jan 2008 20:14:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up -
	add arch_kimage
Message-ID: <20080110011423.GB23143@redhat.com>
References: <1199847467.8126.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199847467.8126.15.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:57:47AM +0800, Huang, Ying wrote:
> This patch add an architecture specific struct arch_kimage into struct
> kimage. Three pointers to page table pages used by kexec are added to
> struct arch_kimage. The page tables pages are dynamically allocated in
> machine_kexec_prepare instead of statically from BSS segment. This
> will save up to 20k memory when kexec image is not loaded.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 

There were some discussions in the past regarding static page table 
allocation vs dynamic. Can't recall it now though. Eric will know it
better.

Anyway, this allocation is taking place at load time and not kexec execute
time so as such should not be an issue for kdump.

Have you tested Xen too? Does it run into issues with this change?


> ---
>  arch/x86/kernel/machine_kexec_32.c |   68 +++++++++++++++++++++++++------------
>  include/asm-x86/kexec_32.h         |   12 ++++++
>  include/linux/kexec.h              |    4 ++
>  3 files changed, 63 insertions(+), 21 deletions(-)
> 
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -11,6 +11,7 @@
>  #include <linux/delay.h>
>  #include <linux/init.h>
>  #include <linux/numa.h>
> +#include <linux/gfp.h>
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
> @@ -21,15 +22,6 @@
>  #include <asm/desc.h>
>  #include <asm/system.h>
>  
> -#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
> -static u32 kexec_pgd[1024] PAGE_ALIGNED;
> -#ifdef CONFIG_X86_PAE
> -static u32 kexec_pmd0[1024] PAGE_ALIGNED;
> -static u32 kexec_pmd1[1024] PAGE_ALIGNED;
> -#endif
> -static u32 kexec_pte0[1024] PAGE_ALIGNED;
> -static u32 kexec_pte1[1024] PAGE_ALIGNED;
> -
>  static void set_idt(void *newidt, __u16 limit)
>  {
>  	struct Xgt_desc_struct curidt;
> @@ -72,6 +64,28 @@ static void load_segments(void)
>  #undef __STR
>  }
>  
> +static void alloc_page_tables(struct kimage *image)
> +{

This is too generic a name. How about something like
arch_alloc_kexec_page_tables()

> +	image->arch_kimage.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
> +#ifdef CONFIG_X86_PAE
> +	image->arch_kimage.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> +	image->arch_kimage.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> +#endif
> +	image->arch_kimage.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +	image->arch_kimage.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +}
> +
> +static void free_page_tables(struct kimage *image)
> +{

How about arch_free_kexec_page_tables()

> +	free_page((unsigned long)image->arch_kimage.pgd);
> +#ifdef CONFIG_X86_PAE
> +	free_page((unsigned long)image->arch_kimage.pmd0);
> +	free_page((unsigned long)image->arch_kimage.pmd1);
> +#endif
> +	free_page((unsigned long)image->arch_kimage.pte0);
> +	free_page((unsigned long)image->arch_kimage.pte1);
> +}
> +
>  /*
>   * A architecture hook called to validate the
>   * proposed image and prepare the control pages
> @@ -83,10 +97,21 @@ static void load_segments(void)
>   * reboot code buffer to allow us to avoid allocations
>   * later.
>   *
> - * Currently nothing.
> + * - Allocate page tables
>   */
>  int machine_kexec_prepare(struct kimage *image)
>  {
> +	alloc_page_tables(image);
> +	if (!image->arch_kimage.pgd ||
> +#ifdef CONFIG_X86_PAE
> +	    !image->arch_kimage.pmd0 ||
> +	    !image->arch_kimage.pmd1 ||
> +#endif
> +	    !image->arch_kimage.pte0 ||
> +	    !image->arch_kimage.pte1) {
> +		free_page_tables(image);
> +		return -ENOMEM;

I think this error handling can be done in alloc_page_tables() itself and
following will look neater.

  if (!alloc_page_tables)
	return -ENOMEM.

Thanks
Vivek
