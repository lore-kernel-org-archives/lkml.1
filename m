Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXLKC2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXLKC2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 21:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXLKC2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 21:28:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56371 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXLKC2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 21:28:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
Date: Mon, 10 Dec 2007 19:25:43 -0700
In-Reply-To: <1197042810.24045.61.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Fri, 07 Dec 2007 15:53:30 +0000")
Message-ID: <m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> This patch implements the functionality of jumping between the kexeced
> kernel and the original kernel.
>
> To support jumping between two kernels, before jumping to (executing)
> the new kernel and jumping back to the original kernel, the devices
> are put into quiescent state, and the state of devices and CPU is
> saved. After jumping back from kexeced kernel and jumping to the new
> kernel, the state of devices and CPU are restored accordingly. The
> devices/CPU state save/restore code of software suspend is called to
> implement corresponding function.
>
> To support jumping without reserving memory. One shadow backup page
> (source page) is allocated for each page used by new (kexeced) kernel
> (destination page). When do kexec_load, the image of new kernel is
> loaded into source pages, and before executing, the destination pages
> and the source pages are swapped, so the contents of destination pages
> are backupped. Before jumping to the new (kexeced) kernel and after
> jumping back to the original kernel, the destination pages and the
> source pages are swapped too.
>
> A jump back protocol for kexec is defined and documented. It is an
> extension to ordinary function calling protocol. So, the facility
> provided by this patch can be used to call ordinary C function in real
> mode.
>
> A set of flags for sys_kexec_load are added to control which state are
> saved/restored before/after real mode code executing. For example, you
> can specify the device state and FPU state are saved/restored
> before/after real mode code executing.
>
> The states (exclude CPU state) save/restore code can be overridden
> based on the "command" parameter of kexec jump. Because more states
> need to be saved/restored by hibernating/resuming.
>

> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  Documentation/i386/jump_back_protocol.txt |  103 ++++++++++++++
>  arch/powerpc/kernel/machine_kexec.c       |    2 
>  arch/ppc/kernel/machine_kexec.c           |    2 
>  arch/sh/kernel/machine_kexec.c            |    2 
>  arch/x86/kernel/machine_kexec_32.c        |   88 +++++++++---
>  arch/x86/kernel/machine_kexec_64.c        |    2 
>  arch/x86/kernel/relocate_kernel_32.S | 214 +++++++++++++++++++++++++++---
>  include/asm-x86/kexec_32.h                |   39 ++++-
>  include/linux/kexec.h                     |   40 +++++
>  kernel/kexec.c                            |  188 ++++++++++++++++++++++++++
>  kernel/power/Kconfig                      |    2 
>  kernel/sys.c                              |   35 +++-
>  12 files changed, 648 insertions(+), 69 deletions(-)
>
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -20,6 +20,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/desc.h>
>  #include <asm/system.h>
> +#include <asm/cacheflush.h>
>  
>  #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
>  static u32 kexec_pgd[1024] PAGE_ALIGNED;
> @@ -83,10 +84,14 @@ static void load_segments(void)
>   * reboot code buffer to allow us to avoid allocations
>   * later.
>   *
> - * Currently nothing.
> + * Turn off NX bit for control page.
>   */
>  int machine_kexec_prepare(struct kimage *image)
>  {
> +	if (nx_enabled) {
> + change_page_attr(image->control_code_page, 1, PAGE_KERNEL_EXEC);
> +		global_flush_tlb();
> +	}
>  	return 0;
>  }
>  
> @@ -96,25 +101,59 @@ int machine_kexec_prepare(struct kimage 
>   */
>  void machine_kexec_cleanup(struct kimage *image)
>  {
> +	if (nx_enabled) {
> +		change_page_attr(image->control_code_page, 1, PAGE_KERNEL);
> +		global_flush_tlb();
> +	}
> +}
> +
> +void machine_kexec(struct kimage *image)
> +{
> +	machine_kexec_call(image, NULL, 0);
>  }
>  
>  /*
>   * Do not allocate memory (or fail in any way) in machine_kexec().
>   * We are past the point of no return, committed to rebooting now.
>   */
> -NORET_TYPE void machine_kexec(struct kimage *image)
> +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
> +			 unsigned int argc, va_list args)
>  {

Why do we need var arg support?
Can't we do that with a shim we load from user space?

>  	unsigned long page_list[PAGES_NR];
>  	void *control_page;
> +	asmlinkage NORET_TYPE void
> +		(*relocate_kernel_ptr)(unsigned long indirection_page,
> +				       unsigned long control_page,
> +				       unsigned long start_address,
> +				       unsigned int has_pae) ATTRIB_NORET;
>  
>  	/* Interrupts aren't acceptable while we reboot */
>  	local_irq_disable();
>  
>  	control_page = page_address(image->control_code_page);
> -	memcpy(control_page, relocate_kernel, PAGE_SIZE);
> +	memcpy(control_page, relocate_page, PAGE_SIZE/2);
> +	KCALL_MAGIC(control_page) = 0;
>  
> +	if (image->preserve_cpu) {
> +		unsigned int i;
> +		KCALL_MAGIC(control_page) = KCALL_MAGIC_NUMBER;
> +		KCALL_ARGC(control_page) = argc;
> +		for (i = 0; i < argc; i++)
> +			KCALL_ARGS(control_page)[i] = \
> +				va_arg(args, unsigned long);
> +
> +		if (kexec_call_save_cpu(control_page)) {
> +			image->start = KCALL_ENTRY(control_page);
> +			if (ret)
> +				*ret = KCALL_ARGS(control_page)[0];
> +			return 0;
> +		}
> +	}
> +
> +	relocate_kernel_ptr = control_page +
> +		((void *)relocate_kernel - (void *)relocate_page);
>  	page_list[PA_CONTROL_PAGE] = __pa(control_page);
> -	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
> +	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
>  	page_list[PA_PGD] = __pa(kexec_pgd);
>  	page_list[VA_PGD] = (unsigned long)kexec_pgd;
>  #ifdef CONFIG_X86_PAE
> @@ -127,26 +166,33 @@ NORET_TYPE void machine_kexec(struct kim
>  	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
>  	page_list[PA_PTE_1] = __pa(kexec_pte1);
>  	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
> + page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
>  
> -	/* The segment registers are funny things, they have both a
> -	 * visible and an invisible part.  Whenever the visible part is
> -	 * set to a specific selector, the invisible part is loaded
> -	 * with from a table in memory.  At no other time is the
> -	 * descriptor table in memory accessed.
> -	 *
> -	 * I take advantage of this here by force loading the
> -	 * segments, before I zap the gdt with an invalid value.
> -	 */
> -	load_segments();
> -	/* The gdt & idt are now invalid.
> -	 * If you want to load them you must set up your own idt & gdt.
> -	 */
> -	set_gdt(phys_to_virt(0),0);
> -	set_idt(phys_to_virt(0),0);
> +	if (image->preserve_cpu_ext) {
> +		/* The segment registers are funny things, they have
> +		 * both a visible and an invisible part.  Whenever the
> +		 * visible part is set to a specific selector, the
> +		 * invisible part is loaded with from a table in
> +		 * memory.  At no other time is the descriptor table
> +		 * in memory accessed.
> +		 *
> +		 * I take advantage of this here by force loading the
> +		 * segments, before I zap the gdt with an invalid
> +		 * value.
> +		 */
> +		load_segments();
> +		/* The gdt & idt are now invalid.  If you want to load
> +		 * them you must set up your own idt & gdt.
> +		 */
> +		set_gdt(phys_to_virt(0), 0);
> +		set_idt(phys_to_virt(0), 0);
> +	}

We can't keep the same idt and gdt as the pages they are on will be
overwritten/reused.  So explictily stomping on them sounds better
so they never work.  We can restore them on kernel reentry.

>  	/* now call it */
> -	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
> -			image->start, cpu_has_pae);
> +	relocate_kernel_ptr((unsigned long)image->head,
> +			    (unsigned long)page_list,
> +			    image->start, cpu_has_pae);

Why rename relocate_kernel?
Ah.  I see.  You need to make it into a pointer again.  The crazy don't
stop the pgd support strikes again.  It used to be named rnk.

More later.

Eric

