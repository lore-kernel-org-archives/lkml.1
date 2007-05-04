Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbXEDNCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbXEDNCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbXEDNCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:02:07 -0400
Received: from mail.suse.de ([195.135.220.2]:59120 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbXEDNCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:02:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
Date: Fri, 4 May 2007 15:01:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070501185945.237601000@em64tdvp.jf.intel.com> <20070501190110.770881000@em64tdvp.jf.intel.com>
In-Reply-To: <20070501190110.770881000@em64tdvp.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041501.55502.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 20:59:46 Chandramouli Narayanan wrote:
> General note on EFI x86_64 support
> ----------------------------------

More review. This code unfortunately has some problems.

First this seems to be quite different from what the 32bit EFI 
support does (which i suppose is pre UEFI) Are there plans to sync this 
up eventually?

Also your howto above should be somewhere in Documentation/

> - Create a VFAT partition on the disk
> - Copy the following to the VFAT partition:
> 	elilo bootloader with x86_64 support and elilo configuration file
> 	efi64 kernel image, initrd

What format is the kernel image?

> - Boot to EFI shell and invoke elilo choosing efi64 kernel image
> - On UEFI2.0 firmware systems, pass vga=fbcon for boot messages to appear
>   on console.

They don't have a compat mode for vga anymore?

> 
> 2. With CALGARY_IOMMU=y in the kernel configuration, the Calgary detection fails
> with the message "Calgary: Unable to locate Rio Grande Table in EBDA - bailing".
> However, the legacy kernel has no such error.

Getting that message when you don't have a IBM Summit system with Calgary is expected.
It would be more worrying why the old kernel didn't give it.

> +config EFI
> +	bool "Boot from EFI support (EXPERIMENTAL)"
> +	default n

The config should be only added after the feature works -- later in the series.

Drop the default n
> +	---help---
> +
> +	This enables the the kernel to boot on EFI platforms using
> +	system configuration information passed to it from the firmware.
> +	This also enables the kernel to use any EFI runtime services that are
> +	available (such as the EFI variable services).
> +	This option is only useful on systems that have EFI firmware
> +	and will result in a kernel image that is ~8k larger. However,
> +	even with this option, the resultant kernel should continue to
> +	boot on existing non-EFI platforms.

The description should probably have a reference to the Documentation describing
how to set this up.

Mention UEFI?

> +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1b8)))
> +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
> +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
> +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
> +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
> +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))

This needs to be documented in Documentation/i386/zero-page.txt

But it might be already obsolete with the early conversion to e820 change?

> +#define EFI_ARG_NUM_GET_TIME			2
> +#define EFI_ARG_NUM_SET_TIME			1
> +#define EFI_ARG_NUM_GET_WAKEUP_TIME		3
> +#define EFI_ARG_NUM_SET_WAKEUP_TIME		2
> +#define EFI_ARG_NUM_GET_VARIABLE		5
> +#define EFI_ARG_NUM_GET_NEXT_VARIABLE		3
> +#define EFI_ARG_NUM_SET_VARIABLE		5
> +#define EFI_ARG_NUM_GET_NEXT_HIGH_MONO_COUNT	1
> +#define EFI_ARG_NUM_RESET_SYSTEM		4
> +#define EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP	4
> +
> +#define EFI_ARG_NUM_MAX 10
> +#define EFI_REG_ARG_NUM 4
> +
> +extern unsigned long efi_call_phys(void *fp, u64 arg_num, ...);
> +struct efi efi;
> +EXPORT_SYMBOL(efi);
> +struct efi efi_phys __initdata;
> +struct efi_memory_map memmap ;
> +static efi_system_table_t efi_systab __initdata;
> +
> +static unsigned long efi_rt_eflags;
> +static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;

Each lock needs a comment what it protects and if there is a locking order.

> +static pgd_t save_pgd;

That looks dubious, more comments later.

> +
> +/* Convert SysV calling convention to EFI x86_64 calling convention */
> +
> +static efi_status_t uefi_call_wrapper(void *fp, unsigned long va_num, ...)
> +{

Any reason you can't do something simple like (untested)

/* rdi, rsi, rdx, rcx, r8, r9 -> rcx,rdx,r8,r9,stack,stack
   arg1 function to call */

call_ms:
        mov %rsi,%rcx
        mov %rdx,%rdx
        mov %rcx,%r8
        mov %r8,%r9
        push %r9
        call *%rdi
        pop %r9
        ret

I assume none of the calls has more than 6 arguments.
ndiswrapper probably has already tested variants if you're lazy.
Then you also wouldn't need the defines for the number of arguments.

Also such code is better written in pure assembly; some versions off 
gcc don't like clobbering of too many registers.

> +static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> +{
> +	return uefi_call_wrapper((void*)efi.systab->runtime->get_time,
> +					EFI_ARG_NUM_GET_TIME,
> +					(u64)tm,
> +					(u64)tc

Are the casts really needed? 


> +static void efi_call_phys_prelog(void)
> +{
> +	unsigned long vaddress;
> +
> +	spin_lock(&efi_rt_lock);
> +	local_irq_save(efi_rt_eflags);
> +
> +	vaddress = (unsigned long)__va(0x0UL);	
> +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
> +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));

Who tells you the other CPUs don't use the current pgd? If it's only used in early
boot it should be __init. If not it's broken.

Most likely you need to create an own thread with special page tables.

> +	local_flush_tlb();

That won't flush the global mappings.

> +}
> +
> +static void efi_call_phys_epilog(void)
> +{
> +	/*
> +	 * After the lock is released, the original page table is restored.
> +	 */
> +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
> +	local_flush_tlb();

Same

> +	local_irq_restore(efi_rt_eflags);
> +	spin_unlock(&efi_rt_lock);
> +}
> +
> +static efi_status_t
> +phys_efi_set_virtual_address_map(unsigned long memory_map_size,
> +				 unsigned long descriptor_size,
> +				 u32 descriptor_version,
> +				 efi_memory_desc_t *virtual_map)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = efi_call_phys(efi_phys.set_virtual_address_map,
> +					EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP,
> +					(unsigned long)memory_map_size,
> +					(unsigned long)descriptor_size,
> +					(unsigned long)descriptor_version, 
> +					(unsigned long)virtual_map);
> +	efi_call_phys_epilog();
> +	return status;
> +}
> +
> +efi_status_t
> +phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> +{

Looks broken -- i think that is called later, so the pgds
can be messed up.

Ok there is suspend/resume -- if you're careful you might be able
to call this before the other CPUs are put online again. But that
is also current being changed to use frozen CPUs. You probably
need to coordinate with Rafael.

[i suspect your resume hang is somehow related to this]

> +inline int efi_set_rtc_mmss(unsigned long nowtime)

I think that can be called any time so definitely broken
regarding page tables.

> +inline unsigned long efi_get_time(void)

inline without static usually leads to wasted code because
the compiler has to generate an out of line copy.

I don't see why all these functions need to be inline anyways.
Best just drop that everywhere and let the compiler decide.

That would probably eliminate some of your 8k.

> +	if (status != EFI_SUCCESS)
> +		printk("Oops: efitime: can't read time status: 0x%lx\n",status);

This should have suitable KERN_* prefixes (missing in most printks)

> +/* Make EFI runtime code executable */

It would be better to integrate this into the standard page table setup
instead of cut'n'pasting so much code here.


> + * We need to map the EFI memory map again after paging_init().
> + */
> +void __init efi_map_memmap(void)
> +{
> +        efi_memory_desc_t *md;
> +        void *p;
> +
> +	memmap.map = __va((unsigned long) memmap.phys_map);
> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);

White space broken.


> +#if EFI_DEBUG
> +void __init print_efi_memmap(void)

The memory map should be probably always printed; it's very useful
for debugging. But if you integrate it with e820 that code can do it.

> +	/*
> +	 * Show what we know for posterity
> +	 */
> +	c16 = (efi_char16_t *) early_ioremap(efi.systab->fw_vendor, 2);
> +	if (c16) {
> +		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
> +			vendor[i] = *c16++;

Probably safer to use probe_kernel_address() here and bail out if it's broken.


> +		vendor[i] = '\0';
> +	} else
> +		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");

EFI should be in the error string


> +	if (status != EFI_SUCCESS) {
> +		printk (KERN_ALERT "You are screwed! "
> +			"Unable to switch EFI into virtual mode "
> +			"(status=%lx)\n", status);
> +		panic("EFI call to SetVirtualAddressMap() failed!");

Is the panic really needed?


> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S	2007-04-19 12:39:39.000000000 -0700
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S	2007-04-19 13:01:02.000000000 -0700
> @@ -94,12 +94,29 @@ startup_32:
>  	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
>  	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
>  	 */
> -	ljmp	$__KERNEL_CS, $(startup_64 - __START_KERNEL_map)
> +	ljmp	$__KERNEL_CS, $(long64 - __START_KERNEL_map)


What is the head.S change good for?
  
-Andi
