Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXK0KET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXK0KET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXK0KEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:04:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXK0KEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:04:04 -0500
Date: Tue, 27 Nov 2007 02:02:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4 -v6] x86_64 EFI runtime service support: EFI
 basic runtime service support
Message-Id: <20071127020235.47e75293.akpm@linux-foundation.org>
In-Reply-To: <1196065421.14142.15.camel@caritas-dev.intel.com>
References: <1196065421.14142.15.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 16:23:41 +0800 "Huang, Ying" <ying.huang@intel.com> wrote:

> This patch adds basic runtime services support for EFI x86_64
> system. The main file of the patch is the addition of efi_64.c for
> x86_64. This file is modeled after the EFI IA32 avatar. EFI runtime
> services initialization are implemented in efi_64.c. Some x86_64
> specifics are worth noting here. On x86_64, parameters passed to EFI
> firmware services need to follow the EFI calling convention. For this
> purpose, a set of functions named efi_call<x> (<x> is the number of
> parameters) are implemented. EFI function calls are wrapped before
> calling the firmware service. The duplicated code between efi_32.c and
> efi_64.c is placed in efi.c to remove them from efi_32.c.
> 
> ...
>
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/bootmem.h>
> +#include <linux/ioport.h>
> +#include <linux/module.h>
> +#include <linux/efi.h>
> +#include <linux/uaccess.h>
> +#include <linux/io.h>
> +#include <linux/reboot.h>
> +
> +#include <asm/setup.h>
> +#include <asm/page.h>
> +#include <asm/e820.h>
> +#include <asm/pgtable.h>
> +#include <asm/tlbflush.h>
> +#include <asm/cacheflush.h>
> +#include <asm/proto.h>
> +#include <asm/efi.h>
> +
> +static pgd_t save_pgd __initdata;
> +static unsigned long efi_flags __initdata;
> +/* efi_lock protects efi physical mode call */
> +static __initdata DEFINE_SPINLOCK(efi_lock);

It's peculiar to have a spinlock in __initdata.  Often there just isn't any
code path by which multiple threads/CPUs can access the same data that
early in boot.

> +static int __init setup_noefi(char *arg)
> +{
> +	efi_enabled = 0;
> +	return 0;
> +}
> +early_param("noefi", setup_noefi);
> +
> +static void __init early_mapping_set_exec(unsigned long start,
> +					  unsigned long end,
> +					  int executable)
> +{
> +	pte_t *kpte;
> +
> +	while (start < end) {
> +		kpte = lookup_address((unsigned long)__va(start));
> +		BUG_ON(!kpte);
> +		if (executable)
> +			set_pte(kpte, pte_mkexec(*kpte));
> +		else
> +			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
> +					    __supported_pte_mask));
> +		if (pte_huge(*kpte))
> +			start = (start + PMD_SIZE) & PMD_MASK;
> +		else
> +			start = (start + PAGE_SIZE) & PAGE_MASK;
> +	}
> +}
> +
> +static void __init early_runtime_code_mapping_set_exec(int executable)
> +{
> +	efi_memory_desc_t *md;
> +	void *p;
> +
> +	/* Make EFI runtime service code area executable */
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		md = p;
> +		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
> +			unsigned long end;
> +			end = md->phys_addr + (md->num_pages << PAGE_SHIFT);
> +			early_mapping_set_exec(md->phys_addr, end, executable);
> +		}
> +	}
> +}
> +
> +void __init efi_call_phys_prelog(void) __acquires(efi_lock)
> +{
> +	unsigned long vaddress;
> +
> +	/*
> +	 * Lock sequence is different from normal case because
> +	 * efi_flags is global
> +	 */
> +	spin_lock(&efi_lock);
> +	local_irq_save(efi_flags);

I think we discussed this before, but I forget the result.  It really
should be described better in the comments here, because this code leaps out
and shouts "wrong".

a) Why not use spin_lock_irqsave()?

b) If this is an open-coded spin_lock_irqsave() then it gets the two
operations in the wrong order and is hence deadlockable.

c) it isn't obvious to the reader that this locking is even needed in
initial bootup.

Now I _think_ all these issuses were addressed in discussion.  But unless
the code comment knocks them all on the head (it doesn't) then it will all
come up again.

> +	early_runtime_code_mapping_set_exec(1);
> +	vaddress = (unsigned long)__va(0x0UL);
> +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
> +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
> +	global_flush_tlb();
> +}
> +
> +void __init efi_call_phys_epilog(void) __releases(efi_lock)
> +{
> +	/*
> +	 * After the lock is released, the original page table is restored.
> +	 */
> +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
> +	early_runtime_code_mapping_set_exec(0);
> +	global_flush_tlb();
> +	local_irq_restore(efi_flags);
> +	spin_unlock(&efi_lock);
> +}
> +
>
> ...
>
> +void __init runtime_code_page_mkexec(void)
> +{
> +	efi_memory_desc_t *md;

I thought we were going to use `struct efi_memory_desc'?

> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/efi.h>
> +#include <linux/bootmem.h>
> +#include <linux/spinlock.h>
> +#include <linux/uaccess.h>
> +#include <linux/time.h>
> +#include <linux/io.h>
> +#include <linux/reboot.h>
> +#include <linux/bcd.h>
> +
> +#include <asm/setup.h>
> +#include <asm/efi.h>
> +#include <asm/time.h>
> +
> +#define EFI_DEBUG	0

I suspect you really want to turn on debug mode during initial public
testing.  Verify that it generates sufficient information for you to be
able to fix problems if/when people report them.

> +int efi_enabled;
> +EXPORT_SYMBOL(efi_enabled);
> +
> +struct efi efi;
> +EXPORT_SYMBOL(efi);
> +
> +struct efi_memory_map memmap;
> +
> +struct efi efi_phys __initdata;
> +static efi_system_table_t efi_systab __initdata;
> +
> +void __init efi_init(void)
> +{
> +	efi_config_table_t *config_tables;
> +	efi_runtime_services_t *runtime;
> +	efi_char16_t *c16;
> +	char vendor[100] = "unknown";
> +	int i = 0;
> +	void *tmp;
> +
> +	memset(&efi, 0, sizeof(efi));
> +	memset(&efi_phys, 0, sizeof(efi_phys));

These were already zeroed by the compiler (I have a feeling I said that a
couple of months back)

> +#ifdef CONFIG_X86_32

Strictly this isn't needed until [patch 4/4] but that's a very minor point.

> +	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
> +	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
> +#else
> +	efi_phys.systab = (efi_system_table_t *)
> +		(boot_params.efi_info.efi_systab |
> +		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> +	memmap.phys_map = (void *)
> +		(boot_params.efi_info.efi_memmap |
> +		 ((__u64)boot_params.efi_info.efi_memmap_hi<<32));
> +#endif
> +	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
> +		boot_params.efi_info.efi_memdesc_size;
> +	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
> +	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
> +
> +	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
> +				       sizeof(efi_system_table_t));
> +	if (efi.systab == NULL)
> +		printk(KERN_ERR "Woah! Couldn't map the EFI systema table.\n");

s/systema/system/.

I'd be inclined to s/Woah! //, too.  Sorry, I'm boring.

> +	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
> +	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
> +	efi.systab = &efi_systab;
> +
> +	/*
> +	 * Verify the EFI Table
> +	 */
> +	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> +		printk(KERN_ERR "Woah! EFI system table "
> +		       "signature incorrect\n");
> +	if ((efi.systab->hdr.revision >> 16) == 0)
> +		printk(KERN_ERR "Warning: EFI system table version "
> +		       "%d.%02d, expected 1.00 or greater\n",
> +		       efi.systab->hdr.revision >> 16,
> +		       efi.systab->hdr.revision & 0xffff);
> +
> +	/*
> +	 * Show what we know for posterity
> +	 */
> +	c16 = tmp = efi_early_ioremap(efi.systab->fw_vendor, 2);
> +	if (c16) {
> +		for (i = 0; i < sizeof(vendor) && *c16; ++i)
> +			vendor[i] = *c16++;
> +		vendor[i] = '\0';
> +	} else
> +		printk(KERN_ERR "Could not map the firmware vendor!\n");

That would be a very confusing error message to any poor soul who received
it.  Please consider prefixing all such things with (say) "efi: ".

> +	efi_early_iounmap(tmp, 2);
> +
> +	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
> +	       efi.systab->hdr.revision >> 16,
> +	       efi.systab->hdr.revision & 0xffff, vendor);
> +
> +	/*
> +	 * Let's see what config tables the firmware passed to us.
> +	 */
> +	config_tables = efi_early_ioremap(
> +		efi.systab->tables,
> +		efi.systab->nr_tables * sizeof(efi_config_table_t));
> +	if (config_tables == NULL)
> +		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
> +
> +	printk(KERN_INFO);
> +	for (i = 0; i < efi.systab->nr_tables; i++) {
> +		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
> +			efi.mps = config_tables[i].table;
> +			printk(" MPS=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
> +					ACPI_20_TABLE_GUID)) {
> +			efi.acpi20 = config_tables[i].table;
> +			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
> +					ACPI_TABLE_GUID)) {
> +			efi.acpi = config_tables[i].table;
> +			printk(" ACPI=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
> +					SMBIOS_TABLE_GUID)) {
> +			efi.smbios = config_tables[i].table;
> +			printk(" SMBIOS=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
> +					HCDP_TABLE_GUID)) {
> +			efi.hcdp = config_tables[i].table;
> +			printk(" HCDP=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
> +					UGA_IO_PROTOCOL_GUID)) {
> +			efi.uga = config_tables[i].table;
> +			printk(" UGA=0x%lx ", config_tables[i].table);
> +		}
> +	}
> +	printk("\n");
> +	efi_early_iounmap(config_tables,
> +			  efi.systab->nr_tables * sizeof(efi_config_table_t));
> +
> +	/*
> +	 * Check out the runtime services table. We need to map
> +	 * the runtime services table so that we can grab the physical
> +	 * address of several of the EFI runtime functions, needed to
> +	 * set the firmware into virtual mode.
> +	 */
> +	runtime = efi_early_ioremap((unsigned long)efi.systab->runtime,
> +				    sizeof(efi_runtime_services_t));
> +	if (runtime != NULL) {
> +		/*
> +		 * We will only need *early* access to the following
> +		 * two EFI runtime services before set_virtual_address_map
> +		 * is invoked.
> +		 */
> +		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
> +		efi_phys.set_virtual_address_map =
> +			(efi_set_virtual_address_map_t *)
> +			runtime->set_virtual_address_map;
> +		/*
> +		 * Make efi_get_time can be called before entering
> +		 * virtual mode.
> +		 */
> +		efi.get_time = phys_efi_get_time;
> +	} else
> +		printk(KERN_ERR "Could not map the EFI runtime service "
> +		       "table!\n");
> +	efi_early_iounmap(runtime, sizeof(efi_runtime_services_t));
> +
> +	/* Map the EFI memory map */
> +	memmap.map = efi_early_ioremap((unsigned long)memmap.phys_map,
> +				       memmap.nr_map * memmap.desc_size);
> +	if (memmap.map == NULL)
> +		printk(KERN_ERR "Could not map the EFI memory map!\n");
> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> +	if (memmap.desc_size != sizeof(efi_memory_desc_t))
> +		printk(KERN_WARNING "Kernel-defined memdesc"
> +		       "doesn't match the one from EFI!\n");
> +
> +#ifdef CONFIG_X86_64
> +	/* Setup for EFI runtime service */
> +	reboot_type = BOOT_EFI;
> +
> +#endif
> +#if EFI_DEBUG
> +	print_efi_memmap();
> +#endif
> +}
> +
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
> +		if ((md->attribute & EFI_MEMORY_WB) &&
> +		    (((md->phys_addr + (md->num_pages<<EFI_PAGE_SHIFT)) >>
> +		      PAGE_SHIFT) < end_pfn_map))
> +			md->virt_addr = (unsigned long)__va(md->phys_addr);
> +		else
> +			md->virt_addr = (unsigned long)
> +				efi_ioremap(md->phys_addr,
> +					    md->num_pages << EFI_PAGE_SHIFT);
> +		if (!md->virt_addr)
> +			printk(KERN_ERR "ioremap of 0x%llX failed!\n",
> +			       (unsigned long long)md->phys_addr);
> +		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> +		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
> +		    ((unsigned long)efi_phys.systab < end))
> +			efi.systab = (efi_system_table_t *)(unsigned long)
> +				(md->virt_addr - md->phys_addr +
> +				 (unsigned long)efi_phys.systab);
> +	}
> +
> +	BUG_ON(!efi.systab);
> +
> +	status = phys_efi_set_virtual_address_map(
> +		memmap.desc_size * memmap.nr_map,
> +		memmap.desc_size,
> +		memmap.desc_version,
> +		memmap.phys_map);
> +
> +	if (status != EFI_SUCCESS) {
> +		printk(KERN_ALERT "You are screwed! "

This came over when you copied the original file.  This patchset would be a
decent opportunity to de-stupid these messages.  Frankly.

> +		       "Unable to switch EFI into virtual mode "
> +		       "(status=%lx)\n", status);
> +		panic("EFI call to SetVirtualAddressMap() failed!");
> +	}
> +
> +	/*
> +	 * Now that EFI is in virtual mode, update the function
> +	 * pointers in the runtime service table to the new virtual addresses.
> +	 *
> +	 * Call EFI services through wrapper functions.
> +	 */
> +	efi.get_time = virt_efi_get_time;
> +	efi.set_time = virt_efi_set_time;
> +	efi.get_wakeup_time = virt_efi_get_wakeup_time;
> +	efi.set_wakeup_time = virt_efi_set_wakeup_time;
> +	efi.get_variable = virt_efi_get_variable;
> +	efi.get_next_variable = virt_efi_get_next_variable;
> +	efi.set_variable = virt_efi_set_variable;
> +	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
> +	efi.reset_system = virt_efi_reset_system;
> +	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
> +#ifdef CONFIG_X86_64
> +	runtime_code_page_mkexec();
> +#endif
> +}

