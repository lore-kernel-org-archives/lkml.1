Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYGHOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYGHOws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYGHOwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:52:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYGHOwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:52:40 -0400
Date: Tue, 8 Jul 2008 10:50:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080708145051.GA14745@redhat.com>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215401122.4660.4.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
> This patch provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Backup/restore memory used by the original kernel before/after
>   kexec.
> 
> - Save/restore CPU state before/after kexec.
> 

Hi Huang,

In general this patch set looks good enough to live in -mm and
get some testing going.

To me, adding capability to return back to original kernel looks
like a logical extension to kexec functionality.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Few minor comments inline.

[..]
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -22,6 +22,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/desc.h>
>  #include <asm/system.h>
> +#include <asm/cacheflush.h>
>  
>  #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
>  static u32 kexec_pgd[1024] PAGE_ALIGNED;
> @@ -85,10 +86,12 @@ static void load_segments(void)
>   * reboot code buffer to allow us to avoid allocations
>   * later.
>   *
> - * Currently nothing.
> + * Make control page executable.
>   */
>  int machine_kexec_prepare(struct kimage *image)
>  {
> +	if (nx_enabled)
> +		set_pages_x(image->control_code_page, 1);
>  	return 0;
>  }
>  
> @@ -98,16 +101,24 @@ int machine_kexec_prepare(struct kimage 
>   */
>  void machine_kexec_cleanup(struct kimage *image)
>  {
> +	if (nx_enabled)
> +		set_pages_nx(image->control_code_page, 1);
>  }
>  
>  /*
>   * Do not allocate memory (or fail in any way) in machine_kexec().
>   * We are past the point of no return, committed to rebooting now.
>   */
> -NORET_TYPE void machine_kexec(struct kimage *image)
> +void machine_kexec(struct kimage *image)
>  {
>  	unsigned long page_list[PAGES_NR];
>  	void *control_page;
> +	asmlinkage unsigned long
> +		(*relocate_kernel_ptr)(unsigned long indirection_page,
> +				       unsigned long control_page,
> +				       unsigned long start_address,
> +				       unsigned int has_pae,
> +				       unsigned int preserve_context);
>  
>  	tracer_disable();
>  
> @@ -115,10 +126,11 @@ NORET_TYPE void machine_kexec(struct kim
>  	local_irq_disable();
>  
>  	control_page = page_address(image->control_code_page);
> -	memcpy(control_page, relocate_kernel, PAGE_SIZE);
> +	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
>  

Is it possible to add either a compile time or run time check
somewhere to make sure code in relocate_kernel.S does not exceed
PAGE_SIZE/2.

[..]
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -24,6 +24,8 @@
>  #include <linux/utsrelease.h>
>  #include <linux/utsname.h>
>  #include <linux/numa.h>
> +#include <linux/suspend.h>
> +#include <linux/device.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -242,6 +244,12 @@ static int kimage_normal_alloc(struct ki
>  		goto out;
>  	}
>  
> +	image->swap_page = kimage_alloc_control_pages(image, 0);
> +	if (!image->swap_page) {
> +		printk(KERN_ERR "Could not allocate swap buffer\n");
> +		goto out;
> +	}
> +
>  	result = 0;
>   out:
>  	if (result == 0)
> @@ -986,6 +994,8 @@ asmlinkage long sys_kexec_load(unsigned 
>  		if (result)
>  			goto out;
>  
> +		if (flags & KEXEC_PRESERVE_CONTEXT)
> +			image->preserve_context = 1;
>  		result = machine_kexec_prepare(image);
>  		if (result)
>  			goto out;
> @@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
>  }
>  
>  module_init(crash_save_vmcoreinfo_init)
> +
> +/**
> + *	kernel_kexec - reboot the system
> + *
> + *	Move into place and start executing a preloaded standalone
> + *	executable.  If nothing was preloaded return an error.
> + */
> +int kernel_kexec(void)
> +{
> +	int error = 0;
> +
> +	if (xchg(&kexec_lock, 1))
> +		return -EBUSY;
> +	if (!kexec_image) {
> +		error = -EINVAL;
> +		goto Unlock;
> +	}
> +
> +	if (kexec_image->preserve_context) {
> +#ifdef CONFIG_KEXEC_JUMP
> +		local_irq_disable();
> +		save_processor_state();
> +#endif
> +	} else {
> +		blocking_notifier_call_chain(&reboot_notifier_list,
> +					     SYS_RESTART, NULL);
> +		system_state = SYSTEM_RESTART;
> +		device_shutdown();
> +		sysdev_shutdown();
> +		printk(KERN_EMERG "Starting new kernel\n");
> +		machine_shutdown();

All the above code was part of kernel_restart_prepare(), can't we just
make that function non-static and use that?

[..]
> --- a/arch/x86/kernel/relocate_kernel_32.S
> +++ b/arch/x86/kernel/relocate_kernel_32.S
> @@ -20,11 +20,44 @@
>  #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
>  #define PAE_PGD_ATTR (_PAGE_PRESENT)
>  
> +/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
> + * used to save some data for jumping back
> + */
> +#define DATA(offset)		(PAGE_SIZE/2+(offset))
> +
> +/* Minimal CPU state */
> +#define ESP			DATA(0x0)
> +#define CR0			DATA(0x4)
> +#define CR3			DATA(0x8)
> +#define CR4			DATA(0xc)
> +
> +/* other data */
> +#define CP_VA_CONTROL_PAGE	DATA(0x10)
> +#define CP_PA_PGD		DATA(0x14)
> +#define CP_PA_SWAP_PAGE		DATA(0x18)
> +#define CP_PA_BACKUP_PAGES_MAP	DATA(0x1c)
> +

In general, this assembly piece of code is getting bigger and its
difficult to read it now. I think we should at-least pull out the page
table setup code into C. Somebody had posted a patch to do that. Don't
know what happened to that. Anyway, this is a separate issue and is on
wish list.

Thanks
Vivek
