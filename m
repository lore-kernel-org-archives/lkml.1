Return-Path: <linux-kernel-owner+w=401wt.eu-S1767342AbXECCxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767342AbXECCxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767331AbXECCxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:53:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37699 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767342AbXECCxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:53:03 -0400
Date: Wed, 2 May 2007 19:56:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
Message-Id: <20070502195635.6fcc59d6.randy.dunlap@oracle.com>
In-Reply-To: <20070501190110.770881000@em64tdvp.jf.intel.com>
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190110.770881000@em64tdvp.jf.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 11:59:46 -0700 Chandramouli Narayanan wrote:

> EFI x86_64 build option is added to the kernel configuration.


Hi Mouli,

Can you share EFI code as much as possible among ia64, i386,
and x86_64 instead of duplicating it?


A diffstat patch summary would be Good.
(see Documentation/SubmittingPatches)


> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/Kconfig linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/Kconfig
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/Kconfig	2007-04-19 12:39:39.000000000 -0700
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/Kconfig	2007-04-19 13:01:02.000000000 -0700
> @@ -254,6 +254,20 @@ config X86_HT
>  	depends on SMP && !MK8
>  	default y
>  
> +config EFI
> +	bool "Boot from EFI support (EXPERIMENTAL)"
> +	default n
> +	---help---
> +

No blank line above.
Indent following lines by 2 spaces:  i.e., <tab><space><space>
as in Documentation/CodingStyle.

> +	This enables the the kernel to boot on EFI platforms using
> +	system configuration information passed to it from the firmware.
> +	This also enables the kernel to use any EFI runtime services that are
> +	available (such as the EFI variable services).
> +	This option is only useful on systems that have EFI firmware
> +	and will result in a kernel image that is ~8k larger. However,
> +	even with this option, the resultant kernel should continue to
> +	boot on existing non-EFI platforms.
> +
>  config MATH_EMULATION
>  	bool


> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/include/asm-x86_64/bootsetup.h linux-2.6.21rc7-git2-uefi-finaltest/include/asm-x86_64/bootsetup.h
> --- linux-2.6.21rc7-git2-orig/include/asm-x86_64/bootsetup.h	2007-04-19 12:39:40.000000000 -0700
> +++ linux-2.6.21rc7-git2-uefi-finaltest/include/asm-x86_64/bootsetup.h	2007-04-19 13:01:02.000000000 -0700
> @@ -17,6 +17,12 @@ extern char x86_boot_params[BOOT_PARAM_S
>  #define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
>  #define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
>  #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
> +#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1b8)))
> +#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
> +#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
> +#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
> +#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
> +#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
>  #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
>  #define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
>  #define SAVED_VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi.c
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi.c	2007-04-19 13:01:02.000000000 -0700
> @@ -0,0 +1,824 @@

> +extern unsigned long efi_call_phys(void *fp, u64 arg_num, ...);
> +struct efi efi;
> +EXPORT_SYMBOL(efi);
> +struct efi efi_phys __initdata;
> +struct efi_memory_map memmap ;

no space before ;

> +static efi_system_table_t efi_systab __initdata;
> +
> +static unsigned long efi_rt_eflags;
> +static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;
> +static pgd_t save_pgd;
> +
> +/* Convert SysV calling convention to EFI x86_64 calling convention */
> +
> +static efi_status_t uefi_call_wrapper(void *fp, unsigned long va_num, ...)
> +{
> +	va_list ap;
> +	int i;
> +	unsigned long args[EFI_ARG_NUM_MAX];
> +	unsigned int arg_size,stack_adjust_size;

space after comma.

> +	efi_status_t status;
> +
> +	if (va_num > EFI_ARG_NUM_MAX || va_num<0)	{

	                                va_num < 0) {

> +		return EFI_LOAD_ERROR;
> +	}
> +	if (va_num==0)

	if (va_num == 0)

> +		/* There is no need to convert arguments for void argument. */
> +		__asm__ __volatile__("call *%0;ret;"::"r"(fp));
> +
> +	/* The EFI arguments is stored in an array. Then later on it will be 
> +	 * pushed into stack or passed to registers according to MS ABI.

passed _to_ registers?  passed via or thru registers?

> +	 */
> +	va_start(ap, va_num);
> +	for (i = 0; i < va_num; i++) {
> +		args[i] = va_arg(ap, unsigned long);
> +	}
> +	va_end(ap);
> +	arg_size = va_num*8;

	arg_size = va_num * 8;

> +	stack_adjust_size = (va_num > EFI_REG_ARG_NUM? EFI_REG_ARG_NUM : va_num)*8;

	Please re-read Documentation/CodingStyle.
> +
> +	/* Starting from here, assembly code makes sure all registers used are
> +	 * under controlled by our code itself instead of by gcc.
> +	 */
> +	/* Start converting SysV calling convention to MS calling convention. */
> +	__asm__ __volatile__(
> +		/* 0. Save preserved registers. EFI call may clobbered them. */
> +		"		pushq %%rbp;pushq %%rbx;pushq %%r12;"
> +		"		pushq %%r13;pushq %%r14;pushq %%r15;"
> +		/* 1. Push arguments passed by stack into stack. */
> +		"		mov %1, %%r12;"
> +		"		mov %3, %%r13;"
> +		"		mov %1, %%rax;"
> +		"		dec %%rax;"
> +		"		mov $8, %%bl;"
> +		"		mul %%bl;"
> +		"		add %%rax, %%r13;"
> +		"lstack:"
> +		"		cmp $4, %%r12;"
> +		"		jle lregister;" 
> +		"		pushq (%%r13);"
> +		"		sub $8, %%r13;"
> +		"		dec %%r12;" 
> +		"		jmp lstack;"
> +		/* 2. Move arguments passed by registers into registers.
> +		 *    rdi->rcx, rsi->rdx, rdx->r8, rcx->r9.
> +		 */
> +		"lregister:"	
> +		"		mov %3, %%r14;"
> +		"		mov $0, %%r12;"
> +		"lloadregister:"
> +		"		cmp %1, %%r12;"
> +		"		jge lcall;"
> +		"		mov (%%r14), %%rcx;"
> +		"		inc %%r12;"
> +		"		cmp %1, %%r12;"
> +		"		jge lcall;"
> +		"		mov 8(%%r14), %%rdx;"
> +		"		inc %%r12;"
> +		"		cmp %1, %%r12;"
> +		"		jge lcall;"
> +		"		mov 0x10(%%r14), %%r8;"
> +		"		inc %%r12;"
> +		"		cmp %1, %%r12;"
> +		"		jge lcall;"
> +		"		mov 0x18(%%r14), %%r9;"
> +		/* 3. Save stack space for those register arguments. */
> +		"lcall:				"
> +		"		sub %2, %%rsp;"
> +		/* 4. Save arg_size to r12 which is preserved in EFI call. */
> +		"		mov %4, %%r12;"
> +		/* 5. Call EFI function. */
> +		"		call *%5;"
> +		"		mov %%rax, %0;"
> +		/* 6. Restore stack space reserved for those register
> +		 * arguments.
> +		 */
> +		"		add %%r12, %%rsp;"
> +		/* 7. Restore preserved registers. */
> +		"		popq %%r15;popq %%r14;popq %%r13;"
> +		"		popq %%r12;popq %%rbx;popq %%rbp;"
> +		: "=r"(status)
> +		:"r"((unsigned long)va_num),
> +		 "r"((unsigned long)stack_adjust_size),
> +		 "r"(args),
> +		 "r"((unsigned long)arg_size),
> +		 "r"(fp)
> +		:"rsp","rbx","rax","r11","r12","r13","r14","rcx","rdx","r8","r9" 
> +		);
> +	return status;
> +}
> +
> +static efi_status_t
> +_efi_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
> +                                            efi_time_t *tm)

Move 'static efi_status_t' to same line as function name.
Move formal parameters down as needed.

> +{
> +	return uefi_call_wrapper((void*)efi.systab->runtime->get_wakeup_time,
> +					EFI_ARG_NUM_GET_WAKEUP_TIME, 
> +					(u64)enabled,
> +					(u64)pending,
> +					(u64)tm); 
> +}
> +
> +static efi_status_t
> +_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
> +                                         unsigned long *data_size, void *data)

ditto

> +{
> +	return uefi_call_wrapper((void*)efi.systab->runtime->get_variable,
> +					EFI_ARG_NUM_GET_VARIABLE, 
> +					(u64)name,
> +					(u64)vendor,
> +					(u64)attr,
> +					(u64)data_size,
> +					(u64)data); 
> +}
> +
> +static efi_status_t
> +_efi_get_next_variable(unsigned long *name_size, efi_char16_t *name,
> +                                              efi_guid_t *vendor)

ditto

> +{
> +	return uefi_call_wrapper((void*)efi.systab->runtime->get_next_variable,
> +					EFI_ARG_NUM_GET_NEXT_VARIABLE, 
> +					(u64)name_size,
> +					(u64)name,
> +					(u64)vendor); 
> +}
> +
> +static efi_status_t
> +phys_efi_set_virtual_address_map(unsigned long memory_map_size,
> +				 unsigned long descriptor_size,
> +				 u32 descriptor_version,
> +				 efi_memory_desc_t *virtual_map)

ditto

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

ditto

> +{
> +
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = efi_call_phys(efi_phys.get_time,
> +					EFI_ARG_NUM_GET_TIME,
> +					(unsigned long)tm,
> +					(unsigned long)tc);
> +	efi_call_phys_epilog();
> +	return status;
> +}
> +
> +inline int efi_set_rtc_mmss(unsigned long nowtime)
> +{
> +	int real_seconds, real_minutes;
> +	efi_status_t 	status;
> +	efi_time_t 	eft;
> +	efi_time_cap_t 	cap;
> +
> +	spin_lock(&efi_rt_lock);
> +	status = efi.get_time(&eft, &cap);
> +	spin_unlock(&efi_rt_lock);
> +	if (status != EFI_SUCCESS) {
> +		printk("Ooops: efitime: can't read time!\n");

Creative spelling of Ooops.  :)
(also below)

> +		return -1;
> +	}
> +
> +}
> +/*
> + * This should only be used during kernel init and before runtime
> + * services have been remapped, therefore, we'll need to call in physical
> + * mode.  Note, this call isn't used later, so mark it __init.
> + */

Confusing comments being adjacent as they are...

> +/*
> + * This is used during kernel init before runtime
> + * services have been remapped and also during suspend, therefore,
> + * we'll need to call both in physical and virtual modes.
> + */
> +inline unsigned long efi_get_time(void)
> +{
> +	efi_status_t status;
> +	efi_time_t eft;
> +	efi_time_cap_t cap;
> +
> +	if (efi.get_time) {
> +		/* if we are in virtual mode use remapped function */
> + 		status = efi.get_time(&eft, &cap);
> +	} else {
> +		/* we are in physical mode */
> +		status = phys_efi_get_time(&eft, &cap);
> +	}
> +	if (status != EFI_SUCCESS)
> +		printk("Oops: efitime: can't read time status: 0x%lx\n",status);
> +
> +	return mktime(eft.year, eft.month, eft.day, eft.hour,
> +			eft.minute, eft.second);
> +}
> +
> +
> +/* Make EFI runtime code executable */
> +static void
> +phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)

Fix 'static void'.

> +{
> +	int i = pmd_index(address);
> +
> +	for (; i < PTRS_PER_PMD && address < end; i++, address += PMD_SIZE) {
> +		unsigned long entry;
> +		pmd_t *pmd = pmd_page + pmd_index(address);
> +
> +		entry = pmd_val(*pmd);
> +			entry &= ~_PAGE_NX;
> +		set_pmd(pmd, __pmd(entry));
> +	}
> +}
> +
> +static void
> +phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)

ditto

> +{ 
> +	int i = pud_index(addr);
> +
> +	for (; i < PTRS_PER_PUD && addr < end; i++, addr += PUD_SIZE ) {
> +		pud_t *pud = pud_page + pud_index(addr);
> +		pmd_t *pmd;
> +
> +		if (pud_val(*pud)) {
> +			pmd = pmd_offset(pud,0);
> +			phys_pmd_init(pmd, addr, end);
> +		}
> +	}
> +}
> +
> +static void change_rt_pmd(unsigned long start, unsigned long end)
> +{ 
> +	unsigned long next; 
> +
> +	start = (unsigned long)__va(start);
> +	end = (unsigned long)__va(end);
> +
> +	for (; start < end; start = next) {
> +		pgd_t *pgd = pgd_offset_k(start);
> +		pud_t *pud;
> +
> +		pud = pud_offset(pgd, start & PGDIR_MASK);
> +		next = start + PGDIR_SIZE;
> +		if (next > end) 
> +			next = end; 
> +		phys_pud_init(pud, __pa(start), __pa(next));
> +	} 
> +	__flush_tlb_all();
> +}
> +/*
> + * We need to map the EFI memory map again after paging_init().
> + */
> +void __init efi_map_memmap(void)
> +{
> +        efi_memory_desc_t *md;
> +        void *p;

Use tab(s) instead of spaces to indent.

> +
> +	memmap.map = __va((unsigned long) memmap.phys_map);
> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> +
> +	/* Make EFI runtime code executable */
> +        for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +                md = p;
> +               if (md->type == EFI_RUNTIME_SERVICES_CODE && 

Use tabs instead of spaces to indent.

> +			(__supported_pte_mask & _PAGE_NX))
> +			change_rt_pmd(md->phys_addr, md->phys_addr + 
> +					(md->num_pages << EFI_PAGE_SHIFT));
> +	}
> +}

> +/*
> + * This function will switch the EFI runtime services to virtual mode.
> + * Essentially, look through the EFI memmap and map every region that
> + * has the runtime attribute bit set in its memory descriptor and update
> + * that memory descriptor with the virtual address obtained from ioremap().
> + * This enables the runtime services to be called without having to
> + * thunk back into physical mode for every invocation.
> + */
> +void __init efi_enter_virtual_mode(void)
> +{
> +	efi_memory_desc_t *md;
> +	efi_status_t status;
> +	unsigned long end;
> +	void *p;
> +
> +	efi.systab = NULL;
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		md = p;
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (md->attribute & EFI_MEMORY_WB)
> +			md->virt_addr = (unsigned long)__va(md->phys_addr);
> +		else if (md->attribute & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> +			md->virt_addr = (unsigned long)ioremap(md->phys_addr,
> +					 md->num_pages << EFI_PAGE_SHIFT);
> +		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> +		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
> +				((unsigned long)efi_phys.systab < end))
> +			efi.systab = (efi_system_table_t *) 
> +					(md->virt_addr - md->phys_addr +
> +					(unsigned long)efi_phys.systab);
> +	}
> +
> +	if (!efi.systab)
> +		BUG();
> +
> +	status = phys_efi_set_virtual_address_map(
> +			memmap.desc_size * memmap.nr_map,
> +			memmap.desc_size,
> +			memmap.desc_version,
> +		       	memmap.phys_map);
> +
> +	if (status != EFI_SUCCESS) {
> +		printk (KERN_ALERT "You are screwed! "
> +			"Unable to switch EFI into virtual mode "
> +			"(status=%lx)\n", status);
> +		panic("EFI call to SetVirtualAddressMap() failed!");
> +	}
> +
> +	/*
> +	 * Now that EFI is in virtual mode, update the function
> +	 * pointers in the runtime service table to the new virtual addresses.
> +	 *
> +	 * Since x86_64 EFI follows MS calling convention, we can not call

	                                                      cannot

> +	 * the services directly. We put a wrapper around the real service
> +	 * calls and call the wrapper directly.
> +	 */
> +
> +}
> +
> +void __init

Wrong line.

> +efi_initialize_iomem_resources(struct resource *code_resource,
> +			       struct resource *data_resource)
> +{
> +}

> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi_stub.S linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi_stub.S
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi_stub.S	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi_stub.S	2007-04-19 13:01:02.000000000 -0700
> @@ -0,0 +1,101 @@

> +/*
> + * In gcc calling convention, EBX, ESP, EBP, ESI and EDI are all callee save.
> + * So we'd better save all of them at the beginning of this function and restore
> + * at the end no matter how many we use, because we can not assure EFI runtime

	                                               cannot

> + * service functions will comply with gcc calling convention, too.
> + */

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
