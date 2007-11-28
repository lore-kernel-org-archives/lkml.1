Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXK1Gro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXK1Gro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 01:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXK1Grd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 01:47:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:9277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbXK1Grc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 01:47:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,222,1194249600"; 
   d="scan'208";a="281503866"
Subject: Re: [PATCH -mm 1/4 -v6] x86_64 EFI runtime service support: EFI
	basic runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071127020235.47e75293.akpm@linux-foundation.org>
References: <1196065421.14142.15.camel@caritas-dev.intel.com>
	 <20071127020235.47e75293.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Nov 2007 14:51:19 +0800
Message-Id: <1196232679.18833.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 28 Nov 2007 06:47:04.0352 (UTC) FILETIME=[7C779A00:01C8318A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-27 at 02:02 -0800, Andrew Morton wrote:
> > +
> > +static pgd_t save_pgd __initdata;
> > +static unsigned long efi_flags __initdata;
> > +/* efi_lock protects efi physical mode call */
> > +static __initdata DEFINE_SPINLOCK(efi_lock);
> 
> It's peculiar to have a spinlock in __initdata.  Often there just isn't any
> code path by which multiple threads/CPUs can access the same data that
> early in boot.

Yes. This spinlock is used only before efi_enter_virtual_mode, which is
far before smp_init, so this spinlock is unnecessary, I will remove it.

> > +void __init efi_call_phys_prelog(void) __acquires(efi_lock)
> > +{
> > +	unsigned long vaddress;
> > +
> > +	/*
> > +	 * Lock sequence is different from normal case because
> > +	 * efi_flags is global
> > +	 */
> > +	spin_lock(&efi_lock);
> > +	local_irq_save(efi_flags);
> 
> I think we discussed this before, but I forget the result.  It really
> should be described better in the comments here, because this code leaps out
> and shouts "wrong".
> 
> a) Why not use spin_lock_irqsave()?
> 
> b) If this is an open-coded spin_lock_irqsave() then it gets the two
> operations in the wrong order and is hence deadlockable.
> 
> c) it isn't obvious to the reader that this locking is even needed in
> initial bootup.
> 
> Now I _think_ all these issuses were addressed in discussion.  But unless
> the code comment knocks them all on the head (it doesn't) then it will all
> come up again.

Because the efi_lock will removed, so this will be no longer a problem.

> > +	early_runtime_code_mapping_set_exec(1);
> > +	vaddress = (unsigned long)__va(0x0UL);
> > +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
> > +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
> > +	global_flush_tlb();
> > +}
> > +
> > +void __init efi_call_phys_epilog(void) __releases(efi_lock)
> > +{
> > +	/*
> > +	 * After the lock is released, the original page table is restored.
> > +	 */
> > +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
> > +	early_runtime_code_mapping_set_exec(0);
> > +	global_flush_tlb();
> > +	local_irq_restore(efi_flags);
> > +	spin_unlock(&efi_lock);
> > +}
> > +
> >
> > ...
> >
> > +void __init runtime_code_page_mkexec(void)
> > +{
> > +	efi_memory_desc_t *md;
> 
> I thought we were going to use `struct efi_memory_desc'?

There is even no struct efi_memory_desc definition in
include/linux/efi.h. I can fix all such coding style problem across all
platforms if desired in another patchset.

> > +#include <asm/setup.h>
> > +#include <asm/efi.h>
> > +#include <asm/time.h>
> > +
> > +#define EFI_DEBUG	0
> 
> I suspect you really want to turn on debug mode during initial public
> testing.  Verify that it generates sufficient information for you to be
> able to fix problems if/when people report them.

OK, I will do it.

> > +void __init efi_init(void)
> > +{
> > +	efi_config_table_t *config_tables;
> > +	efi_runtime_services_t *runtime;
> > +	efi_char16_t *c16;
> > +	char vendor[100] = "unknown";
> > +	int i = 0;
> > +	void *tmp;
> > +
> > +	memset(&efi, 0, sizeof(efi));
> > +	memset(&efi_phys, 0, sizeof(efi_phys));
> 
> These were already zeroed by the compiler (I have a feeling I said that a
> couple of months back)

I will fix it.

> > +#ifdef CONFIG_X86_32
> 
> Strictly this isn't needed until [patch 4/4] but that's a very minor point.
> 
> > +	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
> > +	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
> > +#else
> > +	efi_phys.systab = (efi_system_table_t *)
> > +		(boot_params.efi_info.efi_systab |
> > +		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
> > +	memmap.phys_map = (void *)
> > +		(boot_params.efi_info.efi_memmap |
> > +		 ((__u64)boot_params.efi_info.efi_memmap_hi<<32));
> > +#endif
> > +	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
> > +		boot_params.efi_info.efi_memdesc_size;
> > +	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
> > +	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
> > +
> > +	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
> > +				       sizeof(efi_system_table_t));
> > +	if (efi.systab == NULL)
> > +		printk(KERN_ERR "Woah! Couldn't map the EFI systema table.\n");
> 
> s/systema/system/.
> 
> I'd be inclined to s/Woah! //, too.  Sorry, I'm boring.

I will fix it.

> > +	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
> > +	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
> > +	efi.systab = &efi_systab;
> > +
> > +	/*
> > +	 * Verify the EFI Table
> > +	 */
> > +	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> > +		printk(KERN_ERR "Woah! EFI system table "
> > +		       "signature incorrect\n");
> > +	if ((efi.systab->hdr.revision >> 16) == 0)
> > +		printk(KERN_ERR "Warning: EFI system table version "
> > +		       "%d.%02d, expected 1.00 or greater\n",
> > +		       efi.systab->hdr.revision >> 16,
> > +		       efi.systab->hdr.revision & 0xffff);
> > +
> > +	/*
> > +	 * Show what we know for posterity
> > +	 */
> > +	c16 = tmp = efi_early_ioremap(efi.systab->fw_vendor, 2);
> > +	if (c16) {
> > +		for (i = 0; i < sizeof(vendor) && *c16; ++i)
> > +			vendor[i] = *c16++;
> > +		vendor[i] = '\0';
> > +	} else
> > +		printk(KERN_ERR "Could not map the firmware vendor!\n");
> 
> That would be a very confusing error message to any poor soul who received
> it.  Please consider prefixing all such things with (say) "efi: ".

I will do it.

> > +/*
> > + * This function will switch the EFI runtime services to virtual mode.
> > + * Essentially, look through the EFI memmap and map every region that
> > + * has the runtime attribute bit set in its memory descriptor and update
> > + * that memory descriptor with the virtual address obtained from ioremap().
> > + * This enables the runtime services to be called without having to
> > + * thunk back into physical mode for every invocation.
> > + */
> > +void __init efi_enter_virtual_mode(void)
> > +{
> > +	efi_memory_desc_t *md;
> > +	efi_status_t status;
> > +	unsigned long end;
> > +	void *p;
> > +
> > +	efi.systab = NULL;
> > +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> > +		md = p;
> > +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> > +			continue;
> > +		if ((md->attribute & EFI_MEMORY_WB) &&
> > +		    (((md->phys_addr + (md->num_pages<<EFI_PAGE_SHIFT)) >>
> > +		      PAGE_SHIFT) < end_pfn_map))
> > +			md->virt_addr = (unsigned long)__va(md->phys_addr);
> > +		else
> > +			md->virt_addr = (unsigned long)
> > +				efi_ioremap(md->phys_addr,
> > +					    md->num_pages << EFI_PAGE_SHIFT);
> > +		if (!md->virt_addr)
> > +			printk(KERN_ERR "ioremap of 0x%llX failed!\n",
> > +			       (unsigned long long)md->phys_addr);
> > +		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> > +		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
> > +		    ((unsigned long)efi_phys.systab < end))
> > +			efi.systab = (efi_system_table_t *)(unsigned long)
> > +				(md->virt_addr - md->phys_addr +
> > +				 (unsigned long)efi_phys.systab);
> > +	}
> > +
> > +	BUG_ON(!efi.systab);
> > +
> > +	status = phys_efi_set_virtual_address_map(
> > +		memmap.desc_size * memmap.nr_map,
> > +		memmap.desc_size,
> > +		memmap.desc_version,
> > +		memmap.phys_map);
> > +
> > +	if (status != EFI_SUCCESS) {
> > +		printk(KERN_ALERT "You are screwed! "
> 
> This came over when you copied the original file.  This patchset would be a
> decent opportunity to de-stupid these messages.  Frankly.

I will do it. And I will recheck all messages.

Best Regards,
Huang Ying
