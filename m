Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbXIUC7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbXIUC7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXIUC65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:58:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35778 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbXIUC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:58:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
Date: Thu, 20 Sep 2007 20:55:43 -0600
In-Reply-To: <1190266447.21818.17.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 20 Sep 2007 13:34:07 +0800")
Message-ID: <m1fy18sp5c.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> This patch implements the functionality of jumping between the kexeced
> kernel and the original kernel.
>
> A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
> trigger the jumping to (executing) the new kernel and jumping back to
> the original kernel.
>
> To support jumping between two kernels, before jumping to (executing)
> the new kernel and jumping back to the original kernel, the devices
> are put into quiescent state (to be fully implemented),

Well this we have an implementation of (it's called shutdown) or does
that method not do enough to meet the requirements of hibernation.
If at all possible I would like to keep reboot, kexec and kexec+return
all using the same device driver methods.

> and the state of devices and CPU is saved. 

Makes a reasonable amount of sense.  We do need to save whatever
state we cannot recover just be reprogramming the hardware.
As long as the drivers are built so this is a good place for a
hot remove to happen we should be in good shape.

> After jumping back from kexeced kernel
> and jumping to the new kernel, the state of devices and CPU are
> restored accordingly. The devices/CPU state save/restore code of
> software suspend is called to implement corresponding function.

At least for now that sounds like a reasonable work around.

I don't think we want to merge this code until we have agreed upon
how the new device_detach and device_reattach (or whatever we call the
device methods for hibernate) are to be implemented.

> To support jumping without preserving memory. One shadow backup page
> is allocated for each page used by new (kexeced) kernel. 

That does not sound correct.  The current implementation of kexec_load
does allocate a source page and give it a destination page and usually
those two pages are different.  But if our memory allocations happen
to return a destination page there we use it directly, making no
copy necessary.

I think we are talking about the same thing but I'm not certain
you have thought about the case where your shadow backup page happens
to be the same as current page.

> When do
> kexec_load, the image of new kernel is loaded into shadow pages, 

Ok.  This sounds like the existing implementation.  Except it
depending on your destination it may force the address.

> and
> before executing, the original pages and the shadow pages are swapped,
> so the contents of original pages are backuped.

Yes.  Unless we happen to have everything allocated on the same page.
Does your code handle that case?  I know the generic kexec code will
pass lists like that in the proper circumstances.  Especially for
the kexec on panic case.

> Before jumping to the
> new (kexeced) kernel and after jumping back to the original kernel,
> the original pages and the shadow pages are swapped too.

Yes.   That sounds right.

> A jump back protocol is defined and documented.

Bleh.  We do need to document the requirements but we don't need a
versioned monster.  And we don't need to be exposing implementation
details in that documentation.

In the kexec world /sbin/kexec or another user space caller is
responsible for passing information to our callers.

To be polite we need to document more but the jump back protocol
really should be as if the entry point kexec handed control to did
a subroutine return.

> Known issues
>
> - A field is added to Linux kernel real-mode header. This is
>   temporary, and should be replaced after the 32-bit boot protocol and
>   setup data patches are accepted.

It shouldn't be needed.

> - The suspend method of device is used to put device in quiescent
>   state. But if the ACPI is enabled this will also put devices into
>   low power state, which prevent the new kernel from booting. So, the
>   ACPI must be disabled both in original kernel and kexeced
>   kernel. This is planed to be resolved after the suspend method and
>   hibernate method is separated for device as proposed earlier in the
>   LKML.

Reasonable.

> - The NX (none executable) bit should be turned off for the control
>   page if available.

Why don't we have a problem with this in the normal kexec case?


More comments below.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>
>  Documentation/i386/jump_back_protocol.txt |   81 ++++++++++++
>  arch/i386/Kconfig                         |    7 +
>  arch/i386/boot/header.S                   |    2 
>  arch/i386/kernel/machine_kexec.c          |   77 +++++++++---
>  arch/i386/kernel/relocate_kernel.S | 187 ++++++++++++++++++++++++++----
>  arch/i386/kernel/setup.c                  |    3 
>  include/asm-i386/bootparam.h              |    3 
>  include/asm-i386/kexec.h                  |   48 ++++++-
>  include/linux/kexec.h                     |    9 +
>  include/linux/reboot.h                    |    2 
>  kernel/kexec.c                            |   59 +++++++++
>  kernel/ksysfs.c                           |   17 ++
>  kernel/power/Kconfig                      |    2 
>  kernel/sys.c                              |    8 +
>  14 files changed, 463 insertions(+), 42 deletions(-)
>
> Index: linux-2.6.23-rc6/arch/i386/kernel/machine_kexec.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/arch/i386/kernel/machine_kexec.c 2007-09-20
> 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/arch/i386/kernel/machine_kexec.c 2007-09-20
> 11:24:31.000000000 +0800
> @@ -20,6 +20,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/desc.h>
>  #include <asm/system.h>
> +#include <asm/setup.h>

Please remove the unnecessary and incorrect include.

>  #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
>  static u32 kexec_pgd[1024] PAGE_ALIGNED;
> @@ -98,23 +99,23 @@
>  {
>  }
>  
> -/*
> - * Do not allocate memory (or fail in any way) in machine_kexec().
> - * We are past the point of no return, committed to rebooting now.
> - */
> -NORET_TYPE void machine_kexec(struct kimage *image)
> +static NORET_TYPE void __machine_kexec(struct kimage *image,
> +				       void *control_page) ATTRIB_NORET;
> +
> +static NORET_TYPE void __machine_kexec(struct kimage *image,
> +				       void *control_page)
>  {

It looks like we are doing swap_pages unconditionally so I don't
see why we need to versions of this function.

And it looks like the NORET_TYPE is no longer an accurate description.

>  	unsigned long page_list[PAGES_NR];
> -	void *control_page;
> -
> -	/* Interrupts aren't acceptable while we reboot */
> -	local_irq_disable();
> -
> -	control_page = page_address(image->control_code_page);
> -	memcpy(control_page, relocate_kernel, PAGE_SIZE);
> +	asmlinkage NORET_TYPE void
> +		(*relocate_kernel_ptr)(unsigned long indirection_page,
> +				       unsigned long control_page,
> +				       unsigned long start_address,
> +				       unsigned int has_pae) ATTRIB_NORET;
>  
> +	relocate_kernel_ptr = control_page +
> +		((void *)relocate_kernel - (void *)relocate_page);
>  	page_list[PA_CONTROL_PAGE] = __pa(control_page);
> -	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
> +	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
>  	page_list[PA_PGD] = __pa(kexec_pgd);
>  	page_list[VA_PGD] = (unsigned long)kexec_pgd;
>  #ifdef CONFIG_X86_PAE
> @@ -127,6 +128,7 @@
>  	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
>  	page_list[PA_PTE_1] = __pa(kexec_pte1);
>  	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
> + page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
>  
>  	/* The segment registers are funny things, they have both a
>  	 * visible and an invisible part.  Whenever the visible part is
> @@ -145,8 +147,26 @@
>  	set_idt(phys_to_virt(0),0);
>  
>  	/* now call it */
> -	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
> -			image->start, cpu_has_pae);
> +	relocate_kernel_ptr((unsigned long)image->head,
> +			    (unsigned long)page_list,
> +			    image->start, cpu_has_pae);
> +}
> +
> +/*
> + * Do not allocate memory (or fail in any way) in machine_kexec().
> + * We are past the point of no return, committed to rebooting now.
> + */
> +NORET_TYPE void machine_kexec(struct kimage *image)
> +{
> +	void *control_page;
> +
> +	/* Interrupts aren't acceptable while we reboot */
> +	local_irq_disable();
> +
> +	control_page = page_address(image->control_code_page);
> +	memcpy(control_page, relocate_page, PAGE_SIZE);
> +
> +	__machine_kexec(image, control_page);
>  }
>  
>  /* crashkernel=size@addr specifies the location to reserve for
> @@ -182,3 +202,30 @@
>  #endif
>  }
>  
> +#ifdef CONFIG_KEXEC_JUMP
> +int machine_kexec_jump(struct kimage *image)
> +{
> +	void *control_page;
> +	unsigned long pa_control_page;

> +
> +	control_page = page_address(image->control_code_page);
> +	memcpy(control_page, relocate_page, PAGE_SIZE/2);
> +	pa_control_page = __pa(control_page);
> +	memcpy(control_page + 1, &pa_control_page, sizeof(pa_control_page));
> +
> +	KJUMP_MAGIC(control_page) = KJUMP_MAGIC_NUMBER;
> +	KJUMP_VERSION(control_page) = KJUMP_VERSION_NUMBER;

This bit really looks wrong.  It is for /sbin/kexec to provide this
kind of interface.

> +
> +	if (!kexec_jump_save_cpu(control_page))
> +		__machine_kexec(image, control_page);
> +
> +	kexec_jump_back_entry = KJUMP_ENTRY(control_page);
> +	image->start = kexec_jump_back_entry;
> +	return 0;
> +}
> +
> +void __init parse_kexec_jump_back_entry(void)
> +{
> +	kexec_jump_back_entry = boot_params.hdr.jump_back_entry;
> +}
> +#endif /* CONFIG_KEXEC_JUMP */
> Index: linux-2.6.23-rc6/include/asm-i386/kexec.h
> ===================================================================
> --- linux-2.6.23-rc6.orig/include/asm-i386/kexec.h 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/include/asm-i386/kexec.h 2007-09-20 11:24:31.000000000
> +0800
> @@ -9,16 +9,42 @@
>  #define VA_PTE_0         5
>  #define PA_PTE_1         6
>  #define VA_PTE_1         7
> +#define PA_SWAP_PAGE     8
>  #ifdef CONFIG_X86_PAE
> -#define PA_PMD_0         8
> -#define VA_PMD_0         9
> -#define PA_PMD_1         10
> -#define VA_PMD_1         11
> -#define PAGES_NR         12
> +#define PA_PMD_0         9
> +#define VA_PMD_0         10
> +#define PA_PMD_1         11
> +#define VA_PMD_1         12
> +#define PAGES_NR         13
>  #else
> -#define PAGES_NR         8
> +#define PAGES_NR         9
>  #endif
>  
> +#define KJUMP_DATA_BASE		0x800
> +
> +#define KJUMP_MAGIC_NUMBER	0x626a
> +#define KJUMP_VERSION_NUMBER	0x0100
> +
> +#define KJUMP_DATA(buf) ((unsigned char *)(buf)+KJUMP_DATA_BASE)
> +#define KJUMP_OFF(off)		(KJUMP_DATA_BASE+(off))
> +
> +#define KJUMP_MAGIC_OFF		KJUMP_OFF(0x0)
> +#define KJUMP_MAGIC(buf)	(*(unsigned short *)(KJUMP_DATA(buf)+0x0))
> +#define KJUMP_VERSION(buf)	(*(unsigned short *)(KJUMP_DATA(buf)+0x2))
> +#define KJUMP_BACKUP_PAGES_MAP_OFF \
> +				KJUMP_OFF(0x4)
> +#define KJUMP_BACKUP_PAGES_MAP(buf) \
> +				(*(unsigned long *)(KJUMP_DATA(buf)+0x4))
> +
> +/*
> + * The following are not a part of jump back protocol, for internal
> + * use only
> + */
> +#define KJUMP_ENTRY_OFF		KJUMP_OFF(0x20)
> +#define KJUMP_ENTRY(buf)	(*(unsigned long *)(KJUMP_DATA(buf)+0x20))
> +/* Other internal data fields base */
> +#define KJUMP_OTHER_OFF		KJUMP_OFF(0x24)
> +
>  #ifndef __ASSEMBLY__
>  
>  #include <asm/ptrace.h>
> @@ -94,6 +120,16 @@
>  		unsigned long start_address,
>  		unsigned int has_pae) ATTRIB_NORET;
>  
> +extern char relocate_page[PAGE_SIZE];
> +
> +extern asmlinkage int kexec_jump_save_cpu(void *buf);
> +
> +#ifdef CONFIG_KEXEC_JUMP
> +void parse_kexec_jump_back_entry(void);
> +#else
> +static inline void parse_kexec_jump_back_entry(void) { }
> +#endif
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* _I386_KEXEC_H */
> Index: linux-2.6.23-rc6/include/linux/kexec.h
> ===================================================================
> --- linux-2.6.23-rc6.orig/include/linux/kexec.h 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/include/linux/kexec.h 2007-09-20 11:26:03.000000000 +0800
> @@ -83,6 +83,7 @@
>  
>  	unsigned long start;
>  	struct page *control_code_page;
> +	struct page *swap_page;

Ok.  This looks reasonable.  So we can reorder the pages in a non-destructive
way.

>  	unsigned long nr_segments;
>  	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
> @@ -194,4 +195,12 @@
>  static inline void crash_kexec(struct pt_regs *regs) { }
>  static inline int kexec_should_crash(struct task_struct *p) { return 0; }
>  #endif /* CONFIG_KEXEC */
> +
> +#ifdef CONFIG_KEXEC_JUMP
> +extern int machine_kexec_jump(struct kimage *image);
> +extern unsigned long kexec_jump_back_entry;
> +extern int kexec_jump(void);
> +#else /* !CONFIG_KEXEC_JUMP */
> +static inline int kexec_jump(void) { return 0; }
> +#endif /* CONFIG_KEXEC_JUMP */
>  #endif /* LINUX_KEXEC_H */
> Index: linux-2.6.23-rc6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/kernel/kexec.c 2007-09-20 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/kernel/kexec.c	2007-09-20 11:24:31.000000000 +0800
> @@ -24,6 +24,10 @@
>  #include <linux/utsrelease.h>
>  #include <linux/utsname.h>
>  #include <linux/numa.h>
> +#include <linux/suspend.h>
> +#include <linux/pm.h>
> +#include <linux/cpu.h>
> +#include <linux/console.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -243,6 +247,12 @@
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
> @@ -1246,3 +1256,52 @@
>  }
>  
>  module_init(crash_save_vmcoreinfo_init)
> +
> +#ifdef CONFIG_KEXEC_JUMP
> +unsigned long kexec_jump_back_entry;
> +
> +int kexec_jump(void)
> +{
> +	int error;
> +
> +	if (!kexec_image)
> +		return -EINVAL;
> +
> +	pm_prepare_console();
> +	suspend_console();
> +	error = device_suspend(PMSG_FREEZE);
> +	if (error)
> +		goto Resume_console;
> +	error = disable_nonboot_cpus();
> +	if (error)
> +		goto Resume_devices;
> +	local_irq_disable();
> +	/* At this point, device_suspend() has been called, but *not*
> +	 * device_power_down(). We *must* device_power_down() now.
> +	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
> +	 * become desynchronized with the actual state of the hardware
> +	 * at resume time, and evil weirdness ensues.
> +	 */
> +	error = device_power_down(PMSG_FREEZE);
> +	if (error)
> +		goto Enable_irqs;
> +
> +	save_processor_state();
> +	error = machine_kexec_jump(kexec_image);
> +	restore_processor_state();
> +
> +	/* NOTE:  device_power_up() is just a resume() for devices
> +	 * that suspended with irqs off ... no overall powerup.
> +	 */
> +	device_power_up();
> + Enable_irqs:
> +	local_irq_enable();
> +	enable_nonboot_cpus();
> + Resume_devices:
> +	device_resume();
> + Resume_console:
> +	resume_console();
> +	pm_restore_console();
> +	return error;
> +}
> +#endif /* CONFIG_KEXEC_JUMP */
> Index: linux-2.6.23-rc6/kernel/ksysfs.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/kernel/ksysfs.c 2007-09-20 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/kernel/ksysfs.c	2007-09-20 11:24:31.000000000 +0800
> @@ -69,6 +69,20 @@
>  }
>  KERNEL_ATTR_RO(vmcoreinfo);
>  
> +#ifdef CONFIG_KEXEC_JUMP
> +static ssize_t kexec_jump_back_entry_show(struct kset *kset, char *page)
> +{
> +	return sprintf(page, "0x%lx\n", kexec_jump_back_entry);
> +}
> +static ssize_t kexec_jump_back_entry_store(struct kset *kset, const char *page,
> +					   size_t count)
> +{
> +	kexec_jump_back_entry = simple_strtoul(page, NULL, 0);
> +	return count;
> +}
> +
> +KERNEL_ATTR_RW(kexec_jump_back_entry);
> +#endif /* CONFIG_KEXEC_JUMP */
>  #endif /* CONFIG_KEXEC */
>  
>  /*
> @@ -105,6 +119,9 @@
>  	&kexec_loaded_attr.attr,
>  	&kexec_crash_loaded_attr.attr,
>  	&vmcoreinfo_attr.attr,
> +#ifdef CONFIG_KEXEC_JUMP
> +	&kexec_jump_back_entry_attr.attr,
> +#endif
We should not need this.
>  #endif
>  	NULL
>  };
> Index: linux-2.6.23-rc6/kernel/sys.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/kernel/sys.c	2007-09-20 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/kernel/sys.c	2007-09-20 11:24:31.000000000 +0800
> @@ -424,6 +424,14 @@
>  		unlock_kernel();
>  		return -EINVAL;
>  
> +	case LINUX_REBOOT_CMD_KEXEC_JUMP:
> +		{
> +			int ret;
> +			ret = kexec_jump();
> +			unlock_kernel();
> +			return ret;
> +		}
> +
>  #ifdef CONFIG_HIBERNATION
>  	case LINUX_REBOOT_CMD_SW_SUSPEND:
>  		{
> Index: linux-2.6.23-rc6/include/linux/reboot.h
> ===================================================================
> --- linux-2.6.23-rc6.orig/include/linux/reboot.h 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/include/linux/reboot.h 2007-09-20 11:24:31.000000000 +0800
> @@ -23,6 +23,7 @@
>   * RESTART2    Restart system using given command string.
>   * SW_SUSPEND  Suspend system using software suspend if compiled in.
>   * KEXEC       Restart system using a previously loaded Linux kernel
> + * KEXEC_JUMP  Jump between original kernel and kexeced kernel.
>   */
>  
>  #define	LINUX_REBOOT_CMD_RESTART	0x01234567
> @@ -33,6 +34,7 @@
>  #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
>  #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
>  #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
> +#define	LINUX_REBOOT_CMD_KEXEC_JUMP	0x3928A5FD

I'm still not quite convinced that we need a separate entry point for this.
But until we split out the hibernation methods, it seems reasonable.

>  
>  #ifdef __KERNEL__
> Index: linux-2.6.23-rc6/arch/i386/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/arch/i386/Kconfig 2007-09-20 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/arch/i386/Kconfig	2007-09-20 11:24:31.000000000 +0800
> @@ -830,6 +830,13 @@
>  	  (CONFIG_RELOCATABLE=y).
>  	  For more details see Documentation/kdump/kdump.txt
>  
> +config KEXEC_JUMP
> +	bool "kexec jump (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL
> +	depends on PM && X86_32 && KEXEC
> +	---help---
> +	  Jump between the kexeced kernel and the orignal kernel.
> +
>  config PHYSICAL_START
>  	hex "Physical address where the kernel is loaded" if (EMBEDDED ||
> CRASH_DUMP)
>  	default "0x1000000" if X86_NUMAQ
> Index: linux-2.6.23-rc6/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/kernel/power/Kconfig 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/kernel/power/Kconfig 2007-09-20 11:24:31.000000000 +0800
> @@ -70,7 +70,7 @@
>  
>  config PM_SLEEP
>  	bool
> -	depends on SUSPEND || HIBERNATION
> +	depends on SUSPEND || HIBERNATION || KEXEC_JUMP
>  	default y
>  
>  config SUSPEND_UP_POSSIBLE
> Index: linux-2.6.23-rc6/arch/i386/kernel/relocate_kernel.S
> ===================================================================
> --- linux-2.6.23-rc6.orig/arch/i386/kernel/relocate_kernel.S 2007-09-20
> 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/arch/i386/kernel/relocate_kernel.S 2007-09-20
> 11:24:31.000000000 +0800
> @@ -19,8 +19,87 @@
>  #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
>  #define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
>  
> +#define STACK_TOP		0x1000
> +
> +#define DATA(offset)		(KJUMP_OTHER_OFF+(offset))
> +
> +/* Minimal CPU stat */
> +#define EBX			DATA(0x0)
> +#define ESI			DATA(0x4)
> +#define EDI			DATA(0x8)
> +#define EBP			DATA(0xc)
> +#define ESP			DATA(0x10)
> +#define CR0			DATA(0x14)
> +#define CR3			DATA(0x18)
> +#define CR4			DATA(0x1c)
> +#define FLAG			DATA(0x20)
> +#define RET			DATA(0x24)
> +
> +/* some information saved in control page (CP) for jumping back */
> +#define CP_VA_CONTROL_PAGE	DATA(0x30)
> +#define CP_PA_PGD		DATA(0x34)
> +#define CP_PA_SWAP_PAGE		DATA(0x38)
> +
>  	.text
>  	.align PAGE_ALIGNED
> +	.globl relocate_page
> +relocate_page:
> +
> +/*
> + * Entry point for jumping back from kexeced kernel, the paging is
> + * turned off, the information needed is at relocate_page +
> + * PAGE_SIZE/2
> + */
> +kexec_jump_back_entry:
> +	movl	$relocate_page, %ebx
> +	movl	%edi, KJUMP_ENTRY_OFF(%ebx)
> +	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
> +
> +	lea	STACK_TOP(%ebx), %esp
> +
> +	movl	CP_PA_SWAP_PAGE(%ebx), %eax
> +	movl	KJUMP_BACKUP_PAGES_MAP_OFF(%ebx), %edx
> +	pushl	%eax
> +	pushl	%edx
> +	call	swap_pages
> +	addl	$8, %esp
> +
> +	movl	CP_PA_PGD(%ebx), %eax
> +	movl	%eax, %cr3
> +
> +	movl	%cr0, %eax
> +	orl	$(1<<31), %eax
> +	movl	%eax, %cr0
> +
> +	movl	%edi, %esp
> +	addl	$STACK_TOP, %esp
> +
> +	movl	%edi, %eax
> +	addl	$(virtual_mapped - relocate_page), %eax
> +	pushl	%eax
> +	ret
> +
> +virtual_mapped:
> +	movl	%edi, %edx
> +	movl	EBX(%edx), %ebx
> +	movl	ESI(%edx), %esi
> +	movl	EDI(%edx), %edi
> +	movl	EBP(%edx), %ebp
> +	movl	FLAG(%edx), %eax
> +	pushl	%eax
> +	popf
> +	movl	ESP(%edx), %esp
> +	movl	CR4(%edx), %eax
> +	movl	%eax, %cr4
> +	movl	CR3(%edx), %eax
> +	movl	%eax, %cr3
> +	movl	CR0(%edx), %eax
> +	movl	%eax, %cr0
> +	movl	RET(%edx), %eax
> +	movl	%eax, (%esp)
> +	mov	$1, %eax
> +	ret
> +
>  	.globl relocate_kernel
>  relocate_kernel:
>  	movl	8(%esp), %ebp /* list of pages */
> @@ -146,6 +225,15 @@
>  	pushl $0
>  	popfl
>  
> +	/* save some information for jumping back */
> +	movl	PTR(VA_CONTROL_PAGE)(%ebp), %edi
> +	movl	%edi, CP_VA_CONTROL_PAGE(%edi)
> +	movl	PTR(PA_PGD)(%ebp), %eax
> +	movl	%eax, CP_PA_PGD(%edi)
> +	movl	PTR(PA_SWAP_PAGE)(%ebp), %eax
> +	movl	%eax, CP_PA_SWAP_PAGE(%edi)
> +	movl	%ebx, KJUMP_BACKUP_PAGES_MAP_OFF(%edi)
> +
>  	/* get physical address of control page now */
>  	/* this is impossible after page table switch */
>  	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edi
> @@ -155,11 +243,11 @@
>  	movl	%eax, %cr3
>  
>  	/* setup a new stack at the end of the physical control page */
> -	lea	4096(%edi), %esp
> +	lea	STACK_TOP(%edi), %esp
>  
>  	/* jump to identity mapped page */
>  	movl    %edi, %eax
> -	addl    $(identity_mapped - relocate_kernel), %eax
> +	addl    $(identity_mapped - relocate_page), %eax
>  	pushl   %eax
>  	ret
>  
> @@ -197,8 +285,44 @@
>  	xorl	%eax, %eax
>  	movl	%eax, %cr3
>  
> +	movl	CP_PA_SWAP_PAGE(%edi), %eax
> +	pushl	%eax
> +	pushl	%ebx
> +	call	swap_pages
> +	addl	$8, %esp
> +
> +	/* To be certain of avoiding problems with self-modifying code
> +	 * I need to execute a serializing instruction here.
> +	 * So I flush the TLB, it's handy, and not processor dependent.
> +	 */
> +	xorl	%eax, %eax
> +	movl	%eax, %cr3
> +
> +	/* set all of the registers to known values */
> +	/* leave %esp alone */
> +
> +	movw	KJUMP_MAGIC_OFF(%edi), %ax
> +	cmpw	$KJUMP_MAGIC_NUMBER, %ax
> +	jz 1f
> +	xorl	%edi, %edi
> +1:
> +	xorl	%eax, %eax
> +	xorl	%ebx, %ebx
> +	xorl    %ecx, %ecx
> +	xorl    %edx, %edx
> +	xorl    %esi, %esi
> +	xorl    %ebp, %ebp
> +	ret
> +
>  	/* Do the copies */
> -	movl	%ebx, %ecx
> +swap_pages:
> +	movl	8(%esp), %edx
> +	movl	4(%esp), %ecx
> +	pushl	%ebp
> +	pushl	%ebx
> +	pushl	%edi
> +	pushl	%esi
> +	movl	%ecx, %ebx
>  	jmp	1f
>  
>  0:	/* top, read another word from the indirection page */
> @@ -226,27 +350,50 @@
>  	movl    %ecx,   %esi /* For every source page do a copy */
>  	andl    $0xfffff000, %esi
>  
> +	movl	%edi, %eax
> +	movl	%esi, %ebp
> +
> +	movl	%edx, %edi
>  	movl    $1024, %ecx
>  	rep ; movsl
> -	jmp     0b
>  
> -3:
> +	movl	%ebp, %edi
> +	movl	%eax, %esi
> +	movl	$1024, %ecx
> +	rep ; movsl
>  
> -	/* To be certain of avoiding problems with self-modifying code
> -	 * I need to execute a serializing instruction here.
> -	 * So I flush the TLB, it's handy, and not processor dependent.
> -	 */
> -	xorl	%eax, %eax
> -	movl	%eax, %cr3
> +	movl	%eax, %edi
> +	movl	%edx, %esi
> +	movl	$1024, %ecx
> +	rep ; movsl
>  
> -	/* set all of the registers to known values */
> -	/* leave %esp alone */
> +	lea	4096(%ebp), %esi
> +	jmp     0b
> +3:
> +	popl	%esi
> +	popl	%edi
> +	popl	%ebx
> +	popl	%ebp
> +	ret
>  
> -	xorl	%eax, %eax
> -	xorl	%ebx, %ebx
> -	xorl    %ecx, %ecx
> -	xorl    %edx, %edx
> -	xorl    %esi, %esi
> -	xorl    %edi, %edi
> -	xorl    %ebp, %ebp
> +	.globl kexec_jump_save_cpu
> +kexec_jump_save_cpu:
> +	movl	4(%esp), %edx
> +	movl	%ebx, EBX(%edx)
> +	movl	%esi, ESI(%edx)
> +	movl	%edi, EDI(%edx)
> +	movl	%ebp, EBP(%edx)
> +	movl	%esp, ESP(%edx)
> +	movl	%cr0, %eax
> +	movl	%eax, CR0(%edx)
> +	movl	%cr3, %eax
> +	movl	%eax, CR3(%edx)
> +	movl	%cr4, %eax
> +	movl	%eax, CR4(%edx)
> +	pushf
> +	popl	%eax
> +	movl	%eax, FLAG(%edx)
> +	movl	(%esp), %eax
> +	movl	%eax, RET(%edx)
> +	mov	$0, %eax
>  	ret
> Index: linux-2.6.23-rc6/include/asm-i386/bootparam.h
> ===================================================================
> --- linux-2.6.23-rc6.orig/include/asm-i386/bootparam.h 2007-09-20
> 11:24:25.000000000 +0800
> +++ linux-2.6.23-rc6/include/asm-i386/bootparam.h 2007-09-20 11:24:31.000000000
> +0800
> @@ -41,6 +41,9 @@
>  	u32	initrd_addr_max;
>  	u32	kernel_alignment;
>  	u8	relocatable_kernel;
> +	u8	_pad2[3];
> +	u32	cmdline_size;
> +	u32	jump_back_entry;
>  } __attribute__((packed));
>  
>  struct sys_desc_table {
> Index: linux-2.6.23-rc6/arch/i386/boot/header.S
> ===================================================================
> --- linux-2.6.23-rc6.orig/arch/i386/boot/header.S 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/arch/i386/boot/header.S 2007-09-20 11:24:31.000000000 +0800
> @@ -214,6 +214,8 @@
>                                                  #added with boot protocol
>                                                  #version 2.06
>  
> +jump_back_entry:	.long 0			#jump back entry point

Please no.
> +
>  # End of setup header #####################################################
>  
>  	.section ".inittext", "ax"
> Index: linux-2.6.23-rc6/arch/i386/kernel/setup.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/arch/i386/kernel/setup.c 2007-09-20 11:24:25.000000000
> +0800
> +++ linux-2.6.23-rc6/arch/i386/kernel/setup.c 2007-09-20 13:14:19.000000000
> +0800
> @@ -60,6 +60,7 @@
>  #include <asm/ist.h>
>  #include <asm/io.h>
>  #include <asm/vmi.h>
> +#include <asm/kexec.h>
>  #include <setup_arch.h>
>  #include <bios_ebda.h>
>  
> @@ -566,6 +567,8 @@
>  	data_resource.start = virt_to_phys(_etext);
>  	data_resource.end = virt_to_phys(_edata)-1;
>  
> +	parse_kexec_jump_back_entry();
> +

Why do we need to touch setup.c?

>  	parse_early_param();
>  
>  	if (user_defined_memmap) {
> Index: linux-2.6.23-rc6/Documentation/i386/jump_back_protocol.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.23-rc6/Documentation/i386/jump_back_protocol.txt 2007-09-20
> 11:24:31.000000000 +0800
> @@ -0,0 +1,81 @@
> +		THE LINUX/I386 JUMP BACK PROTOCOL
> +		---------------------------------
> +
> +		Huang Ying <ying.huang@intel.com>
> +		    Last update 2007-09-19
> +
> +Currently, the following versions of the jump back protocol exist.
> +
> +Protocol 1.00:	Jumping between original kernel and kexeced kernel
> +		support.
> +
> +
> +**** LOAD THE JUMP BACK IMAGE
> +
> +Jump back image is an ordinary ELF 64 executable file, it can be
> +loaded just as other ELF64 image. That is, the PT_LOAD segments should
> +be loaded into their physical address.
> +
> +Before loading all segments of jump back image, the jump back header
> +should be checked. Jump back header can be loaded from the 4K page at
> +the jump back entry in jump back image.
> +
> +The header looks like:
> +
> +Offset	Proto	Name		Meaning
> +/Size
> +
> +C00/2	1.00+	magic		Magic number: 0x626A
> +C02/2	1.00+	version		Jump back protocol version
> +C04/4	1.00+	backup_pages_map Map from target page to backup page
> +
> +Note: unlike ordinary ELF 64 file, the jump back image may occupy most
> +memory pages, so it is important for loader to verify there is no
> +conflict between pages of loaded image and pages used by loader
> +itself.
> +
> +
> +**** DETAILS OF JUMP BACK HEADER
> +
> +For each field, some are information from the jump back image to
> +loader ("read"), some are expected to be filled out by the loader
> +("write"), and some are expected to be read and modified by the loader
> +("modify").
> +
> +All general purpose boot loaders should write the fields marked
> +(obligatory).
> +
> +The byte order of all fields is little endian.
> +
> +Field name:	magic
> +Type:		read
> +Offset/size:	0xc00/2
> +Protocol:	1.00+
> +
> +  Contains the magic number "jb" (0x626A)
> +
> +Field name:	version
> +Type:		read
> +Offset/size:	0xc02/2
> +Protocol:	1.00+
> +
> +  Contains the version number, in (major << 8)+minor format,
> +  e.g. 0x0100 for version 1.00.
> +
> +Field name:	backup_pages_map
> +Type:		read
> +Offset/size:	0xc04/4
> +Protocol:	1.00+
> +
> +  The map from target address to backup address, it is kimage->head in
> +  fact.
> +  TODO: detailed description

This is an implementation detail that we should not need to export.
I do think having a specification of the requirements for returning to
the kexec kernel makes sense.  I don't however believe that we need to
pass any information.  The map of the pages that matter is simply 
the memory the kernel is using from /proc/iomem  - the memory that
your image you are loading with kexec is using.

All of that information we can pass in /sbin/kexec and should not
need to do directly from the kernel.

The following piece of code should be always be a valid kexec on
jump user and test case.

test_kexec_jump_payload:
	ret

A standard subroutine call return on whichever architecture we are
working on should be sufficient.

For the registers and the segments we should define which ones
should be hard coded, and which ones should be saved.

Hard coded:
%ss, %cs, %ds (4G flat with 0 base)

Callee save:
%esp
%edi
(And whichever ones we care about)

It does make some sense to use the standard kernel argument passing sequence
for bootloaders and what not.  But the wrapper in /sbin/kexec should do that
not the kernel itself.


> +
> +**** JUMP BACK TO THE JUMP BACK IMAGE
> +
> +To jump back to the jump back image, just jump to the jump back
> +entry. At entry, the CPU must be in 32-bit protected mode with paging
> +disabled; the CS, DS and SS must be 4G flat segments; if jumping back
> +to loader is supported, %edi should be the jump back entry of loader,
> +otherwise it should be zero.

Eric
