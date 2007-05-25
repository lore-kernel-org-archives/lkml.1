Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXEYWqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXEYWqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXEYWq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:46:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:17169 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbXEYWq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,581,1170662400"; 
   d="scan'208";a="90618599"
Message-ID: <46576741.6020806@linux.intel.com>
Date: Fri, 25 May 2007 15:46:25 -0700
From: chandramouli narayanan <mouli@linux.intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com> <20070501190110.770881000@em64tdvp.jf.intel.com> <200705041501.55502.ak@suse.de>
In-Reply-To: <200705041501.55502.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 01 May 2007 20:59:46 Chandramouli Narayanan wrote:
>   
>> General note on EFI x86_64 support
>> ----------------------------------
>>     
>
> More review. This code unfortunately has some problems.
>
> First this seems to be quite different from what the 32bit EFI 
> support does (which i suppose is pre UEFI) Are there plans to sync this 
> up eventually?
>   
Consolidation of the efi support across architectures needs to be done 
at some point and this will be a bigger task. But right now my focus is 
x86_64.
> Also your howto above should be somewhere in Documentation/
>   
Will do.
>   
>> - Create a VFAT partition on the disk
>> - Copy the following to the VFAT partition:
>> 	elilo bootloader with x86_64 support and elilo configuration file
>> 	efi64 kernel image, initrd
>>     
>
> What format is the kernel image?
>   
bzImage
>   
>> - Boot to EFI shell and invoke elilo choosing efi64 kernel image
>> - On UEFI2.0 firmware systems, pass vga=fbcon for boot messages to appear
>>   on console.
>>     
>
> They don't have a compat mode for vga anymore?
>   
I'm not sure what you mean by VGA compatibility mode. There is no 
requirement in [U]EFI for VGA.
>   
>> 2. With CALGARY_IOMMU=y in the kernel configuration, the Calgary detection fails
>> with the message "Calgary: Unable to locate Rio Grande Table in EBDA - bailing".
>> However, the legacy kernel has no such error.
>>     
>
> Getting that message when you don't have a IBM Summit system with Calgary is expected.
> It would be more worrying why the old kernel didn't give it.
>   
All right. I will double-check into the older kernel.
>   
>> +config EFI
>> +	bool "Boot from EFI support (EXPERIMENTAL)"
>> +	default n
>>     
>
> The config should be only added after the feature works -- later in the series.
>
> Drop the default n
>   
To the extent I have tested, the feature works. Should this still be 'n'?
>   
>> +	---help---
>> +
>> +	This enables the the kernel to boot on EFI platforms using
>> +	system configuration information passed to it from the firmware.
>> +	This also enables the kernel to use any EFI runtime services that are
>> +	available (such as the EFI variable services).
>> +	This option is only useful on systems that have EFI firmware
>> +	and will result in a kernel image that is ~8k larger. However,
>> +	even with this option, the resultant kernel should continue to
>> +	boot on existing non-EFI platforms.
>>     
>
> The description should probably have a reference to the Documentation describing
> how to set this up.
>
> Mention UEFI?
>   
Will add to the doc.
>   
>> +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1b8)))
>> +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
>> +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
>> +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
>> +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
>> +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
>>     
>
> This needs to be documented in Documentation/i386/zero-page.txt
>
> But it might be already obsolete with the early conversion to e820 change?
>   
Not sure if this becomes obsolete with e820 change. I will look into it 
and add to the doc.
>   
>> +#define EFI_ARG_NUM_GET_TIME			2
>> +#define EFI_ARG_NUM_SET_TIME			1
>> +#define EFI_ARG_NUM_GET_WAKEUP_TIME		3
>> +#define EFI_ARG_NUM_SET_WAKEUP_TIME		2
>> +#define EFI_ARG_NUM_GET_VARIABLE		5
>> +#define EFI_ARG_NUM_GET_NEXT_VARIABLE		3
>> +#define EFI_ARG_NUM_SET_VARIABLE		5
>> +#define EFI_ARG_NUM_GET_NEXT_HIGH_MONO_COUNT	1
>> +#define EFI_ARG_NUM_RESET_SYSTEM		4
>> +#define EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP	4
>> +
>> +#define EFI_ARG_NUM_MAX 10
>> +#define EFI_REG_ARG_NUM 4
>> +
>> +extern unsigned long efi_call_phys(void *fp, u64 arg_num, ...);
>> +struct efi efi;
>> +EXPORT_SYMBOL(efi);
>> +struct efi efi_phys __initdata;
>> +struct efi_memory_map memmap ;
>> +static efi_system_table_t efi_systab __initdata;
>> +
>> +static unsigned long efi_rt_eflags;
>> +static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;
>>     
>
> Each lock needs a comment what it protects and if there is a locking order.
>
>   
I will add the comments. Ditto for i386.
>> +static pgd_t save_pgd;
>>     
>
> That looks dubious, more comments later.
>
>   
>> +
>> +/* Convert SysV calling convention to EFI x86_64 calling convention */
>> +
>> +static efi_status_t uefi_call_wrapper(void *fp, unsigned long va_num, ...)
>> +{
>>     
>
> Any reason you can't do something simple like (untested)
>
> /* rdi, rsi, rdx, rcx, r8, r9 -> rcx,rdx,r8,r9,stack,stack
>    arg1 function to call */
>
> call_ms:
>         mov %rsi,%rcx
>         mov %rdx,%rdx
>         mov %rcx,%r8
>         mov %r8,%r9
>         push %r9
>         call *%rdi
>         pop %r9
>         ret
>
> I assume none of the calls has more than 6 arguments.
> ndiswrapper probably has already tested variants if you're lazy.
> Then you also wouldn't need the defines for the number of arguments.
>
> Also such code is better written in pure assembly; some versions off 
> gcc don't like clobbering of too many registers.
>   
This wrapper code was tested and added to elilo with x86_64 support. 
There are some efi calls with > 6 args as used in elilo. So, the wrapper 
code is more elaborate to deal with those cases. Although the efi calls 
used here in the kernel do not exceed 6 args, for the sake of 
generality, the same code is being used here. So, is there a better way 
to handle more number of arguments? I tested with the LIN2WINxx macros 
from ndiswrapper code ( http://ndiswrapper.sourceforge.net/joomla/) and 
that works. The LIN2WINxx defines macros to call with a specified set of 
arguments. For instance, an efi runtime call with one argument should be 
called with LIN2WIN1() and so on. If this approach is acceptable for 
inclusion, that is a possible candidate for replacement.
I had an issue with the code snippet you provided for an efi call with 5 
args to get efi variables. I didn't investigate this further.
>   
>> +static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>> +{
>> +	return uefi_call_wrapper((void*)efi.systab->runtime->get_time,
>> +					EFI_ARG_NUM_GET_TIME,
>> +					(u64)tm,
>> +					(u64)tc
>>     
>
> Are the casts really needed? 
>   
Not needed. I fixed it.
>   
>> +static void efi_call_phys_prelog(void)
>> +{
>> +	unsigned long vaddress;
>> +
>> +	spin_lock(&efi_rt_lock);
>> +	local_irq_save(efi_rt_eflags);
>> +
>> +	vaddress = (unsigned long)__va(0x0UL);	
>> +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
>> +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
>>     
>
> Who tells you the other CPUs don't use the current pgd? If it's only used in early
> boot it should be __init. If not it's broken.
>   
This code is called during early boot. This should be __init. Ditto for 
i386 version. It too does not have __init.
> Most likely you need to create an own thread with special page tables.
>
>   
>> +	local_flush_tlb();
>>     
>
> That won't flush the global mappings.
>
>   
>> +}
>> +
>> +static void efi_call_phys_epilog(void)
>> +{
>> +	/*
>> +	 * After the lock is released, the original page table is restored.
>> +	 */
>> +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
>> +	local_flush_tlb();
>>     
>
> Same
>
>   
>> +	local_irq_restore(efi_rt_eflags);
>> +	spin_unlock(&efi_rt_lock);
>> +}
>> +
>> +static efi_status_t
>> +phys_efi_set_virtual_address_map(unsigned long memory_map_size,
>> +				 unsigned long descriptor_size,
>> +				 u32 descriptor_version,
>> +				 efi_memory_desc_t *virtual_map)
>> +{
>> +	efi_status_t status;
>> +
>> +	efi_call_phys_prelog();
>> +	status = efi_call_phys(efi_phys.set_virtual_address_map,
>> +					EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP,
>> +					(unsigned long)memory_map_size,
>> +					(unsigned long)descriptor_size,
>> +					(unsigned long)descriptor_version, 
>> +					(unsigned long)virtual_map);
>> +	efi_call_phys_epilog();
>> +	return status;
>> +}
>> +
>> +efi_status_t
>> +phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>> +{
>>     
>
> Looks broken -- i think that is called later, so the pgds
> can be messed up.
>   
I don't think so. For instance, when efi_get_time is called later, the 
virtual mode is set up and it does not
cause the physical mode call.
> Ok there is suspend/resume -- if you're careful you might be able
> to call this before the other CPUs are put online again. But that
> is also current being changed to use frozen CPUs. You probably
> need to coordinate with Rafael.
>
> [i suspect your resume hang is somehow related to this]
>
>   
I don't have a suspend/resume hang. The issue I documented was with 
regard to the behavior of the desktop with just one of the git kernels 
prior to 2.6.21 release. I tested the suspend/resume with the patch 
applied to 2.6.21. I tested by directly writing the state to 
/sys/power/state. However, powersave -U did not seem to do anything. 
This seems to me a user-mode utility issue rather than the kernel support.
>> +inline int efi_set_rtc_mmss(unsigned long nowtime)
>>     
>
> I think that can be called any time so definitely broken
> regarding page tables.
>   
efi init code sets up efi.get_time to a virtual mode function that can 
be called later. So, I don't think there is an issue here. Correct me if 
I'm wrong.
>   
>> +inline unsigned long efi_get_time(void)
>>     
>
> inline without static usually leads to wasted code because
> the compiler has to generate an out of line copy.
>
> I don't see why all these functions need to be inline anyways.
> Best just drop that everywhere and let the compiler decide.
>
> That would probably eliminate some of your 8k.
>   
Agreed. However, the function is declared extern in include/linux/efi.h. 
So, it can not be both static and inline. Ditto for the i386 code too.
>   
>> +	if (status != EFI_SUCCESS)
>> +		printk("Oops: efitime: can't read time status: 0x%lx\n",status);
>>     
>
> This should have suitable KERN_* prefixes (missing in most printks)
>
>   
Ok, I will fix this. Ditto for i386/efi code.
>> +/* Make EFI runtime code executable */
>>     
>
> It would be better to integrate this into the standard page table setup
> instead of cut'n'pasting so much code here.
>
>   
I've finally a version that is working with standard page table setup 
code. By the way, I got rid of the duplicate code. Also, I have 
integrated EFI memory map into e820 space.
>   
>> + * We need to map the EFI memory map again after paging_init().
>> + */
>> +void __init efi_map_memmap(void)
>> +{
>> +        efi_memory_desc_t *md;
>> +        void *p;
>> +
>> +	memmap.map = __va((unsigned long) memmap.phys_map);
>> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
>>     
>
> White space broken.
>   
Will fix.
>   
>> +#if EFI_DEBUG
>> +void __init print_efi_memmap(void)
>>     
>
> The memory map should be probably always printed; it's very useful
> for debugging. But if you integrate it with e820 that code can do it.
>
>   
I integrated the EFI memory map into e820 and it takes care of printing 
that. So, print_efi_memmap() can be gotten rid of.
>> +	/*
>> +	 * Show what we know for posterity
>> +	 */
>> +	c16 = (efi_char16_t *) early_ioremap(efi.systab->fw_vendor, 2);
>> +	if (c16) {
>> +		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
>> +			vendor[i] = *c16++;
>>     
>
> Probably safer to use probe_kernel_address() here and bail out if it's broken.
>
>   
I will make the needed changes.
>   
>> +		vendor[i] = '\0';
>> +	} else
>> +		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
>>     
>
> EFI should be in the error string
>   
PFX is set to EFI and that should take care.
>
>   
>> +	if (status != EFI_SUCCESS) {
>> +		printk (KERN_ALERT "You are screwed! "
>> +			"Unable to switch EFI into virtual mode "
>> +			"(status=%lx)\n", status);
>> +		panic("EFI call to SetVirtualAddressMap() failed!");
>>     
>
> Is the panic really needed?
>   
Probably not needed. This is lifted from i386 efi init code.
>   
>> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S
>> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S	2007-04-19 12:39:39.000000000 -0700
>> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S	2007-04-19 13:01:02.000000000 -0700
>> @@ -94,12 +94,29 @@ startup_32:
>>  	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
>>  	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
>>  	 */
>> -	ljmp	$__KERNEL_CS, $(startup_64 - __START_KERNEL_map)
>> +	ljmp	$__KERNEL_CS, $(long64 - __START_KERNEL_map)
>>     
>
>
> What is the head.S change good for?
>   
Sorry, this is remnant code that should _not_ have been part of the patch.
>   
> -Andi
>
>   

I'm testing next set of patches with fixes and post them for review.
thanks for feedback,
- mouli
