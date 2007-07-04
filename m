Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXGDNlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXGDNlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbXGDNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:41:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:29767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbXGDNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,497,1175497200"; 
   d="scan'208";a="262190194"
Subject: Re: [PATCH 2.6.21 1/3] x86_64 EFI64 support Try #2
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de
In-Reply-To: <20070703162545.1f626fa1.akpm@linux-foundation.org>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
	 <20070702170707.688670000@em64tdvp.jf.intel.com>
	 <20070703162545.1f626fa1.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2007 21:40:37 +0000
Message-Id: <1183585237.16719.28.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 04 Jul 2007 13:41:27.0845 (UTC) FILETIME=[058A4D50:01C7BE41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comment. Because my colleague Mouli has left for
sabbatical, I will continue work on the X86_64 UEFI support kernel
patch.
 
On Tue, 2007-07-03 at 16:25 -0700, Andrew Morton wrote:
> On Mon, 02 Jul 2007 10:06:15 -0700
> Chandramouli Narayanan <mouli@linux.intel.com> wrote:
> >
> 
> You just sent three patches, all with the same name.  Please take care to
> choose different and good Subject:s for each patch. 
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt covers this a bit.
> 

We will do as that in the next version.

> > 
> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> 
> All the above text tells us the differences between.  v2 and v3.  It all
> will be of minimal interest for the final got commit and hence it will be
> removed (by me, typically).
> 
> That will leave us with no cvhangelog for this patch.
> 
> Please provide a changelog with this patch.  The above-linked-to document
> has some guidelines.
> 

Will do.

> Please feed these patches through the latest version of
> scripts/checkpatch.pl and consider addressing the resulting warnings.  Many
> are generated.

Ok, we will check the patch with scripts/checkpatch.pl before sending
next time.

> > +extern efi_status_t LIN2WIN0(void *fp);
> > +extern efi_status_t LIN2WIN1(void *fp, u64 arg1);
> > +extern efi_status_t LIN2WIN2(void *fp, u64 arg1, u64 arg2);
> > +extern efi_status_t LIN2WIN3(void *fp, u64 arg1, u64 arg2, u64 arg3);
> > +extern efi_status_t LIN2WIN4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
> > +extern efi_status_t LIN2WIN5(
> > +	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5);
> > +extern efi_status_t LIN2WIN6(
> > +	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5, u64 arg6);
> 
> Why are these all-upper-case?  That convention is conventionally used for
> macros.

We will change them to lower case in next version.

> > +#define EFI_DEBUG	0
> > +#define PFX 		"EFI: "
> > +
> > +struct efi efi;
> > +EXPORT_SYMBOL(efi);
> 
> Why is this exported?
> 

Because the EFI Variable driver in drivers/firmware/efivars.c uses "efi"
to call EFI variable services and read EFI information. Which may be a
module.

> > +static void __init efi_call_phys_prelog(void) __acquires(efi_rt_lock)
> > +{
> > +	unsigned long vaddress;
> > +
> > +	spin_lock(&efi_rt_lock);
> > +	local_irq_save(efi_rt_eflags);
> 
> I suspect the above two statements are in the wrong order.
> 

Because it is intended to disable interrupt between efi_call_phys_prelog
and efi_call_phys_epilog, the efi_rt_eflags is made a global variable.
So the spin lock should be locked firstly to protect efi_rt_eflags from
accessed from different CPU.

> > +
> > +inline int efi_set_rtc_mmss(unsigned long nowtime)
> 
> Remove `inline'.
> 

Will do.

> > +{
> > +	int real_seconds, real_minutes;
> > +	efi_status_t 	status;
> > +	efi_time_t 	eft;
> > +	efi_time_cap_t 	cap;
> > +
> > +	spin_lock(&efi_rt_lock);
> > +	status = efi.get_time(&eft, &cap);
> > +	spin_unlock(&efi_rt_lock);
> 
> It is very unusual for any time-related low-level lock to be taken in a
> non-irq-safe fashion.  Is this code correct?

The efi_set_rtc_mmss has the same assumption as set_rtc_mmss. That is,
the function will be called in timer interrupt. So spin_lock_irq is not
needed. But the whole function may be needed to be enclosed by spin_lock
and spin_unlock.

> > +	if (status != EFI_SUCCESS) {
> > +		printk(KERN_ERR PFX "Oops: efitime: can't read time!\n");
> > +		return -1;
> > +	}
> > +
> > +	real_seconds = nowtime % 60;
> > +	real_minutes = nowtime / 60;
> > +	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
> > +		real_minutes += 30;
> > +	real_minutes %= 60;
> > +	eft.minute = real_minutes;
> > +	eft.second = real_seconds;
> > +
> > +	spin_lock(&efi_rt_lock);
> > +	status = efi.set_time(&eft);
> > +	spin_unlock(&efi_rt_lock);
> > +	if (status != EFI_SUCCESS) {
> > +		printk(KERN_ERR PFX "Oops: efitime: can't write time!\n");
> > +		return -1;
> > +	}
> > +	return 0;
> > +}
> > +/*
> 
> Missing newline.

Sorry, will fix in next version.

> > + * This is used during kernel init before runtime
> > + * services have been remapped and also during suspend, therefore,
> > + * we'll need to call both in physical and virtual modes.
> > + */
> > +inline unsigned long efi_get_time(void)
> 
> Remove inline

Will do.

> > +{
> > +	efi_status_t status;
> > +	efi_time_t eft;
> > +	efi_time_cap_t cap;
> > +
> > +	if (efi.get_time) {
> > +		/* if we are in virtual mode use remapped function */
> > + 		status = efi.get_time(&eft, &cap);
> > +	} else {
> > +		/* we are in physical mode */
> > +		status = phys_efi_get_time(&eft, &cap);
> > +	}
> > +	if (status != EFI_SUCCESS)
> > +		printk(KERN_ERR PFX "Oops: efitime: can't read time status: 0x%lx\n",status);
> 
> Missing space, line too long (checkpatch will point these out)

Will add space and checkpatch.pl for all patches.

> > +
> > +	return mktime(eft.year, eft.month, eft.day, eft.hour,
> > +			eft.minute, eft.second);
> > +}
> > +
> > +/*
> > + * We need to map the EFI memory map again after paging_init().
> > + */
> > +void __init efi_map_memmap(void)
> > +{
> > +	int i;
> > +
> > +	memmap.map = __va((unsigned long)memmap.phys_map);
> > +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> > +
> > +	/* Make EFI runtime code area executable */
> > +	for (i = 0; i < e820.nr_map; i++) {
> > +		switch (e820.map[i].type) {
> > +		case E820_RUNTIME_CODE:
> > +			init_memory_mapping(
> > +				e820.map[i].addr,
> > +				e820.map[i].addr + e820.map[i].size);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +}
> > +
> > +/* Override function for emergency restart on EFI enabled systems */
> > +static void efi_emergency_restart(void)
> > +{
> > +	/* If EFI enabled, reset system through EFI protocol. */
> > +	efi.reset_system(EFI_RESET_WARM, EFI_SUCCESS, 0, NULL);
> > +	return;
> > +}
> > +
> > +void __init efi_init(void)
> > +{
> > +	efi_config_table_t *config_tables;
> > +	efi_runtime_services_t *runtime;
> > +	efi_char16_t *c16;
> > +	char vendor[100] = "unknown";
> > +	int i = 0;
> > +
> > +	memset(&efi, 0, sizeof(efi) );
> 
> Rendom extra space

Will remove it, and check with checkpatch.pl

> > +	memset(&efi_phys, 0, sizeof(efi_phys));
> > +
> > +	efi_phys.systab = (efi_system_table_t *)EFI_SYSTAB;
> > +	memmap.phys_map = (void*)EFI_MEMMAP;
> > +	memmap.nr_map = EFI_MEMMAP_SIZE/EFI_MEMDESC_SIZE;
> > +	memmap.desc_version = EFI_MEMDESC_VERSION;
> > +	memmap.desc_size = EFI_MEMDESC_SIZE;
> > +
> > +	efi.systab = (efi_system_table_t *) early_ioremap(
> > +						(unsigned long)efi_phys.systab,
> > +						sizeof(efi_system_table_t));
> 
> early_ioremap() returns void*: unneeded cast.

Will do.

> > +	if (!probe_kernel_address(c16, i)) {
> > +		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
> > +			vendor[i] = *c16++;
> > +		vendor[i] = '\0';
> > +	}
> > +
> > +	printk(KERN_INFO PFX "EFI v%u.%.02u by %s \n",
> > +	       efi.systab->hdr.revision >> 16,
> > +	       efi.systab->hdr.revision & 0xffff, vendor);
> > +
> > +	/*
> > +	 * Let's see what config tables the firmware passed to us.
> > +	 */
> > +	config_tables = (efi_config_table_t *)early_ioremap( efi.systab->tables,
> > +			        efi.systab->nr_tables * sizeof(efi_config_table_t));
> > +	if (config_tables == NULL)
> > +		printk(KERN_ERR PFX "Could not map EFI Configuration Table!\n");
> > +
> > +	for (i = 0; i < efi.systab->nr_tables; i++) {
> > +		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
> > +			efi.mps = config_tables[i].table;
> > +			printk(KERN_INFO " MPS=0x%lx ", config_tables[i].table);
> > +		} else
> > +		    if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
> > +			efi.acpi20 = config_tables[i].table;
> > +			printk(KERN_INFO " ACPI 2.0=0x%lx ", config_tables[i].table);
> > +		} else
> > +		    if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
> > +			efi.acpi = config_tables[i].table;
> > +			printk(KERN_INFO " ACPI=0x%lx ", config_tables[i].table);
> > +		} else
> > +		    if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
> > +			efi.smbios = config_tables[i].table;
> > +			printk(KERN_INFO " SMBIOS=0x%lx ", config_tables[i].table);
> > +		} else
> > +		    if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
> > +			efi.hcdp = config_tables[i].table;
> > +			printk(KERN_INFO " HCDP=0x%lx ", config_tables[i].table);
> > +		} else
> > +		    if (efi_guidcmp(config_tables[i].guid, UGA_IO_PROTOCOL_GUID) == 0) {
> > +			efi.uga = config_tables[i].table;
> > +			printk(KERN_INFO " UGA=0x%lx ", config_tables[i].table);
> > +		}
> > +	}
> > +	printk(KERN_INFO "\n");
> 
> The KERN_* is only meaningful at the start of the output line, and this one
> is being emitted at the end of the input line.  Usually..

Will do.

> > +	/*
> > +	 * Check out the runtime services table. We need to map
> > +	 * the runtime services table so that we can grab the physical
> > +	 * address of several of the EFI runtime functions, needed to
> > +	 * set the firmware into virtual mode.
> > +	 */
> > +	runtime = (efi_runtime_services_t *) early_ioremap((unsigned long)
> > +						efi.systab->runtime,
> > +				      		sizeof(efi_runtime_services_t));
> 
> Unneeded cast (please check all patches)

Ok, we will check all patches for early_ioremap.

> > +	efi.systab = NULL;
> > +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> > +		md = p;
> > +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> > +			continue;
> > +		if (md->attribute & EFI_MEMORY_WB)
> > +			md->virt_addr = (unsigned long)__va(md->phys_addr);
> > +		else if (md->attribute & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> > +			md->virt_addr = (unsigned long)ioremap(md->phys_addr,
> > +					 md->num_pages << EFI_PAGE_SHIFT);
> > +		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> > +		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
> > +				((unsigned long)efi_phys.systab < end))
> > +			efi.systab = (efi_system_table_t *) 
> > +					(md->virt_addr - md->phys_addr +
> > +					(unsigned long)efi_phys.systab);
> > +	}
> > +
> > +	if (!efi.systab)
> > +		BUG();
> 
> BUG_ON()

Will do.

> > +
> > +efi_status_t LIN2WIN1(void *func, u64 arg1)
> > +{
> > +	u64 ret, dummy;
> > +	register u64 r8 __asm__("r8");
> > +	register u64 r9 __asm__("r9");
> > +	register u64 r10 __asm__("r10");
> > +	register u64 r11 __asm__("r11");
> > +	__asm__ __volatile__(
> > +		alloc_win_stack_frame(4)
> > +		"call *%[fptr]\n\t"
> > +		free_win_stack_frame(4)	
> > +		: "=a" (ret), "=c" (dummy), "=d" (dummy),
> > +		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
> > +		: "c" (arg1),
> > +		  [fptr] "r" (func));
> > +	return ret;
> > +}
> > +
> > +efi_status_t LIN2WIN2(void *func, u64 arg1, u64 arg2)
> > +{
> > +	u64 ret, dummy;
> > +	register u64 r8 __asm__("r8");
> > +	register u64 r9 __asm__("r9");
> > +	register u64 r10 __asm__("r10");
> > +	register u64 r11 __asm__("r11");
> > +	__asm__ __volatile__(
> > +		alloc_win_stack_frame(4)
> > +		"call *%[fptr]\n\t"
> > +		free_win_stack_frame(4)
> > +		: "=a" (ret), "=c" (dummy), "=d" (dummy),
> > +		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
> > +		: "c" (arg1), "d" (arg2),
> > +		  [fptr] "r" (func));
> > +	return ret;
> > +}
> 
> Maybe all these should have been coded in assembler.

We will try to implement it in assembler.

> > +EXPORT_SYMBOL_GPL(LIN2WIN0);
> > +EXPORT_SYMBOL_GPL(LIN2WIN1);
> > +EXPORT_SYMBOL_GPL(LIN2WIN2);
> > +EXPORT_SYMBOL_GPL(LIN2WIN3);
> > +EXPORT_SYMBOL_GPL(LIN2WIN4);
> > +EXPORT_SYMBOL_GPL(LIN2WIN5);
> > +EXPORT_SYMBOL_GPL(LIN2WIN6);
> 
> efi was exported non-gpl, these are exported gpl.  How come?

Need same synchronization, :)

> Are these exports needed?  For what?
> 

If it is intended to call EFI runtime service outside of efi.c directly,
such as that of current EFI Variable driver, these are needed. But the
better method maybe provide the calling wrapper in efi.c. And export the
wrapper instead.

Best Regards,
Huang Ying
