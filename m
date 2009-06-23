Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZFWH51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZFWH51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZFWH5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:57:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZFWH5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:57:16 -0400
Date: Tue, 23 Jun 2009 09:56:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090623075643.GC6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- /dev/null
> +++ b/arch/x86/kernel/sfi.c

> +#include <linux/init.h>
> +#include <linux/efi.h>
> +#include <linux/cpumask.h>
> +#include <linux/module.h>
> +#include <linux/irq.h>
> +#include <linux/bootmem.h>
> +#include <linux/io.h>
> +#include <linux/acpi.h>
> +#include <linux/efi.h>
> +#include <linux/sfi.h>
> +
> +#include <asm/pgtable.h>
> +#include <asm/io_apic.h>
> +#include <asm/apic.h>
> +#include <asm/mpspec.h>
> +
> +#include <asm/e820.h>
> +#include <asm/setup.h>

Please try to use the include files style in arch/x86/mm/fault.c. It 
is minimalistic and deterministically ordered as well, so it will 
look in a pleasant way long-term too .

> +#undef PREFIX

Why undefine it? No header should set 'PREFIX' - if it does it needs 
fixing.

> +#define PREFIX "SFI: "
>
> +#ifdef CONFIG_X86_LOCAL_APIC
> +static u64 sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> +#endif

if SFI adds a 'depends on X86_LOCAL_APIC' the ugly #ifdef can be 
dropped.

> +
> +extern int __init sfi_parse_xsdt(struct sfi_table_header *table);
> +static int __init sfi_parse_cpus(struct sfi_table_header *table);
> +static int __init sfi_parse_apic(struct sfi_table_header *table);

These should be in a header i guess.

> +
> +void __init __iomem *
> +arch_early_ioremap(unsigned long phys, unsigned long size)
> +{
> +	return early_ioremap(phys, size);
> +}
> +
> +void __init arch_early_iounmap(void __iomem *virt, unsigned long size)
> +{
> +	early_iounmap(virt, size);
> +}

Should be in a separate series and not added to sfi.c but to core 
x86.

> +
> +static ulong __init sfi_early_find_syst(void)

Please use C types such as 'unsigned long'.

> +{
> +	unsigned long i;

... like here.

> +	char *pchar = (char *)SFI_SYST_SEARCH_BEGIN;
> +
> +	for (i = 0; SFI_SYST_SEARCH_BEGIN + i < SFI_SYST_SEARCH_END; i += 16, pchar += 16) {

What does the magic constant '16' mean here?

> +		if (!strncmp(SFI_SIG_SYST, pchar, SFI_SIGNATURE_SIZE))
> +			return SFI_SYST_SEARCH_BEGIN + i;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * called in a early boot phase before the paging table is created,
> + * setup a mmap table in e820 format
> + */
> +int __init sfi_init_memory_map(void)
> +{
> +	struct sfi_table_simple *syst, *mmapt;
> +	struct sfi_mem_entry *mentry;
> +	unsigned long long start, end, size;
> +	int i, num, type, tbl_cnt;
> +	u64 *pentry;
> +
> +	if (sfi_disabled)
> +		return -1;
> +
> +	/* first search the syst table */
> +	syst = (struct sfi_table_simple *)sfi_early_find_syst();

why doesnt sfi_early_find_syst() return the proper type?

> +	if (!syst)
> +		return -1;
> +
> +	tbl_cnt = (syst->header.length - sizeof(struct sfi_table_header)) / sizeof(u64);
> +	pentry = syst->pentry;
> +
> +	/* walk through the syst to search the mmap table */
> +	mmapt = NULL;
> +	for (i = 0; i < tbl_cnt; i++) {
> +		if (!strncmp(SFI_SIG_MMAP, (char *)(u32)*pentry, 4)) {
> +			mmapt = (struct sfi_table_simple *)(u32)*pentry;
> +			break;
> +		}
> +		pentry++;
> +	}
> +	if (!mmapt)
> +		return -1;
> +
> +	/* refer copy_e820_memory() */
> +	num = SFI_GET_ENTRY_NUM(mmapt, sfi_mem_entry);
> +	mentry = (struct sfi_mem_entry *)mmapt->pentry;
> +	for (i = 0; i < num; i++) {
> +		start = mentry->phy_start;
> +		size = mentry->pages << PAGE_SHIFT;
> +		end = start + size;
> +
> +		if (start > end)
> +			return -1;
> +
> +		pr_debug(PREFIX "start = 0x%08x end = 0x%08x type = %d\n",
> +			(u32)start, (u32)end, mentry->type);
> +
> +		/* translate SFI mmap type to E820 map type */
> +		switch (mentry->type) {
> +		case EFI_CONVENTIONAL_MEMORY:
> +			type = E820_RAM;
> +			break;
> +		case EFI_MEMORY_MAPPED_IO:
> +		case EFI_UNUSABLE_MEMORY:
> +		case EFI_RUNTIME_SERVICES_DATA:
> +			mentry++;
> +			continue;
> +		default:
> +			type = E820_RESERVED;
> +		}
> +
> +		e820_add_region(start, size, type);
> +		mentry++;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +void __init mp_sfi_register_lapic_address(u64 address)
> +{
> +	mp_lapic_addr = (unsigned long) address;

mp_lapic_addr should have the proper type i guess.

> +
> +	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
> +
> +	if (boot_cpu_physical_apicid == -1U)
> +		boot_cpu_physical_apicid = read_apic_id();
> +
> +	pr_info(PREFIX "Boot CPU = %d\n", boot_cpu_physical_apicid);

Should be pr_debug() i guess - we know the boot CPU from a number of 
other places already.

> +}
> +
> +/* All CPUs enumerated by SFI must be present and enabled */
> +void __cpuinit mp_sfi_register_lapic(u8 id)
> +{
> +	struct mpc_cpu cpu;
> +	int boot_cpu = 0;
> +
> +	if (MAX_APICS - id <= 0) {
> +		printk(KERN_WARNING "Processor #%d invalid (max %d)\n",
> +			id, MAX_APICS);
> +		return;
> +	}
> +
> +	if (id == boot_cpu_physical_apicid)
> +		boot_cpu = 1;
> +
> +	cpu.type = MP_PROCESSOR;
> +	cpu.apicid = id;
> +	cpu.apicver = GET_APIC_VERSION(apic_read(APIC_LVR));
> +	cpu.cpuflag = CPU_ENABLED;
> +	cpu.cpuflag |= (boot_cpu ? CPU_BOOTPROCESSOR : 0);
> +	cpu.cpufeature = (boot_cpu_data.x86 << 8) |
> +		(boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
> +	cpu.featureflag = boot_cpu_data.x86_capability[0];
> +	cpu.reserved[0] = 0;
> +	cpu.reserved[1] = 0;

Nice trick - MP-spec is still useful after all.

> +
> +	generic_processor_info(id, cpu.apicver);
> +}
> +
> +static int __init sfi_parse_cpus(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_cpu_table_entry *pentry;
> +	int i;
> +	int cpu_num;
> +
> +	BUG_ON(!table);

Can this happen? If yes, is a boot crash the best answer?

> +	sb = (struct sfi_table_simple *)table;
> +
> +	cpu_num = SFI_GET_ENTRY_NUM(sb, sfi_cpu_table_entry);
> +	pentry = (struct sfi_cpu_table_entry *) sb->pentry;

(unneeded space character)

> +
> +	for (i = 0; i < cpu_num; i++) {
> +		mp_sfi_register_lapic(pentry->apicid);
> +		pentry++;
> +	}
> +
> +	smp_found_config = 1;
> +	return 0;
> +}
> +#endif /* CONFIG_X86_LOCAL_APIC */
> +
> +#ifdef	CONFIG_X86_IO_APIC

Should SFI add 'depends on X86_IO_APIC' perhaps? (or do you 
anticipate IO-APIC-less implementations?)


> +static struct mp_ioapic_routing {
> +	int			apic_id;
> +	int			gsi_base;
> +	int			gsi_end;
> +	u32			pin_programmed[4];
> +} mp_ioapic_routing[MAX_IO_APICS];

Data structures should be defined at the top of the .c file, not 
hidden in the middle.

> +
> +/* refer acpi/boot.c */
> +static u8 __init uniq_ioapic_id(u8 id)
> +{
> +#ifdef CONFIG_X86_32
> +	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
> +	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
> +		return io_apic_get_unique_id(nr_ioapics, id);
> +	else
> +		return id;
> +#else
> +	int i;
> +	DECLARE_BITMAP(used, 256);
> +	bitmap_zero(used, 256);

Newline needed after local variabe definition blocks.

> +	for (i = 0; i < nr_ioapics; i++) {
> +		struct mpc_ioapic *ia = &mp_ioapics[i];
> +		__set_bit(ia->apicid, used);
> +	}
> +	if (!test_bit(id, used))
> +		return id;
> +	return find_first_zero_bit(used, 256);
> +#endif
> +}

Why is the 32-bit and 64-bit version so different? Please unify 
first before adding new functionality.

> +
> +
> +void __init mp_sfi_register_ioapic(u8 id, u32 paddr)
> +{
> +	int idx = 0;
> +	int tmpid;
> +	static u32 gsi_base;
> +
> +	if (nr_ioapics >= MAX_IO_APICS) {
> +		printk(KERN_ERR "ERROR: Max # of I/O APICs (%d) exceeded "
> +			"(found %d)\n", MAX_IO_APICS, nr_ioapics);
> +		panic("Recompile kernel with bigger MAX_IO_APICS!\n");
> +	}
> +	if (!paddr) {
> +		printk(KERN_ERR "WARNING: Bogus (zero) I/O APIC address"
> +			" found in MADT table, skipping!\n");
> +		return;
> +	}
> +
> +	idx = nr_ioapics;
> +
> +	mp_ioapics[idx].type = MP_IOAPIC;
> +	mp_ioapics[idx].flags = MPC_APIC_USABLE;
> +	mp_ioapics[idx].apicaddr = paddr;
> +
> +	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, paddr);
> +	tmpid = uniq_ioapic_id(id);
> +	if (tmpid == -1)
> +		return;
> +
> +	mp_ioapics[idx].apicid = tmpid;
> +#ifdef CONFIG_X86_32
> +	mp_ioapics[idx].apicver = io_apic_get_version(idx);
> +#else
> +	mp_ioapics[idx].apicver = 0;
> +#endif

Could this #ifdef be eliminated?

> +
> +	pr_info(PREFIX "IOAPIC[%d]: apic_id %d, version %d, address 0x%x\n",
> +		idx, mp_ioapics[idx].apicid,
> +		mp_ioapics[idx].apicver, (u32)mp_ioapics[idx].apicaddr);
> +	/*
> +	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
> +	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
> +	 */
> +	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
> +	mp_ioapic_routing[idx].gsi_base = gsi_base;
> +	mp_ioapic_routing[idx].gsi_end = gsi_base +
> +		io_apic_get_redir_entries(idx);
> +	gsi_base = mp_ioapic_routing[idx].gsi_end + 1;
> +	pr_info(PREFIX "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
> +	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
> +	       mp_ioapics[idx].apicver, (u32)mp_ioapics[idx].apicaddr,
> +	       mp_ioapic_routing[idx].gsi_base,
> +	       mp_ioapic_routing[idx].gsi_end);
> +
> +	nr_ioapics++;
> +}
> +
> +static int __init sfi_parse_apic(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_apic_table_entry *pentry;
> +	int i, num;
> +
> +	BUG_ON(!table);

Same as comment above - is this case anticipated? If yes, is a crash 
the best answer?

> +	sb = (struct sfi_table_simple *)table;
> +
> +	num = SFI_GET_ENTRY_NUM(sb, sfi_apic_table_entry);
> +	pentry = (struct sfi_apic_table_entry *) sb->pentry;
> +	for (i = 0; i < num; i++) {
> +		mp_sfi_register_ioapic(i, pentry->phy_addr);
> +		pentry++;
> +	}
> +
> +	WARN_ON(pic_mode);
> +	pic_mode = 0;

If this warning can occor, please use WARN() instead with a 
user-parseable message.

> +	return 0;
> +}
> +#endif /* CONFIG_X86_IO_APIC */
> +
> +/*
> + * sfi_platform_init(): register lapics & io-apics
> + */
> +int __init sfi_platform_init(void)
> +{
> +#ifdef CONFIG_X86_LOCAL_APIC
> +	mp_sfi_register_lapic_address(sfi_lapic_addr);
> +	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, 0, sfi_parse_cpus);
> +#endif
> +#ifdef CONFIG_X86_IO_APIC
> +	sfi_table_parse(SFI_SIG_APIC, NULL, NULL, 0, sfi_parse_apic);
> +#endif

Both of these #ifdefs would go away with the 'depends on' 
suggestions i made above.

Also, sfi_parse_apic() should be named sfr_parse_ioapic() ?

> +	return 0;
> +}
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 1266ead..c3e39b5 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
>  obj-y				+= video/
>  obj-$(CONFIG_ACPI)		+= acpi/
> +obj-$(CONFIG_SFI)		+= sfi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
>  # was used and do nothing if so
>  obj-$(CONFIG_PNP)		+= pnp/
> diff --git a/drivers/sfi/Makefile b/drivers/sfi/Makefile
> new file mode 100644
> index 0000000..f176470
> --- /dev/null
> +++ b/drivers/sfi/Makefile
> @@ -0,0 +1 @@
> +obj-y	+= sfi_core.o
> diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
> new file mode 100644
> index 0000000..0a9b72d
> --- /dev/null
> +++ b/drivers/sfi/sfi_core.c
> @@ -0,0 +1,403 @@
> +/* sfi_core.c Simple Firmware Interface - core internals */
> +
> +/*
> + * Copyright (C) 2009, Intel Corp.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> + *    substantially similar to the "NO WARRANTY" disclaimer below
> + *    ("Disclaimer") and any redistribution must be conditioned upon
> + *    including a substantially similar Disclaimer requirement for further
> + *    binary redistribution.
> + * 3. Neither the names of the above-listed copyright holders nor the names
> + *    of any contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2 as published by the Free
> + * Software Foundation.
> + *
> + * NO WARRANTY
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> + * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + * POSSIBILITY OF SUCH DAMAGES.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/smp.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/irq.h>
> +#include <linux/errno.h>
> +#include <linux/sfi.h>
> +#include <linux/bootmem.h>
> +#include <linux/module.h>
> +#include <asm/pgtable.h>
> +#include "sfi_core.h"
> +
> +#undef PREFIX
> +#define PREFIX	"SFI: "
> +
> +int sfi_disabled;

Should be __read_mostly? (other read-mostly variables below too i 
guess)

> +EXPORT_SYMBOL(sfi_disabled);
> +
> +#define SFI_MAX_TABLES		64

Kernels we release will live 5-10 years easily - new hw is never 
expected to have more than 64 tables?

> +struct sfi_internal_syst sfi_tblist;
> +static struct sfi_table_desc sfi_initial_tables[SFI_MAX_TABLES] __initdata;
> +
> +/*
> + * flag for whether using ioremap() to map the sfi tables, if yes
> + * each table only need be mapped once, otherwise each arch's
> + * early_ioremap  and early_iounmap should be used each time a
> + * table is visited
> + */
> +static u32 sfi_tbl_permanant_mapped;
> +
> +static void __iomem *sfi_map_memory(u32 phys, u32 size)
> +{
> +	if (!phys || !size)
> +		return NULL;
> +
> +	if (sfi_tbl_permanant_mapped)
> +		return ioremap((unsigned long)phys, size);
> +	else
> +		return arch_early_ioremap((unsigned long)phys, size);
> +}
> +
> +static void sfi_unmap_memory(void __iomem *virt, u32 size)
> +{
> +	if (!virt || !size)
> +		return;
> +
> +	if (sfi_tbl_permanant_mapped)
> +		iounmap(virt);
> +	else
> +		arch_early_iounmap(virt, size);
> +}
> +

That's a disgusting facility. Should be separated out ...

> +static void sfi_print_table_header(u32 address,
> +			struct sfi_table_header *header)
> +{
> +	pr_info(PREFIX
> +		"%4.4s %08lX, %04X (r%d %6.6s %8.8s)\n",
> +		header->signature, (unsigned long)address,
> +		header->length, header->revision, header->oem_id,
> +		header->oem_table_id);
> +}

Why do we need the type cast above?

> +
> +static u8 sfi_checksum_table(u8 *buffer, u32 length)
> +{
> +	u8 sum = 0;
> +
> +	while (length--)
> +		sum += *buffer++;
> +	return sum;
> +}
> +
> +/* Verifies if the table checksums is zero */
> +static int sfi_tb_verify_checksum(struct sfi_table_header *table, u32 length)
> +{
> +	u8 checksum;
> +
> +	checksum = sfi_checksum_table((u8 *)table, length);

Why not declare sfi_checksum_table() with a void * input type 
instead and lose the cast above? That way a potential source of bugs 
gets found. (say accidentally passing in an 'address' to the 
function instead of a table pointer)

> +	if (checksum) {
> +		pr_warning(PREFIX
> +			"Incorrect checksum in table [%4.4s] -  %2.2X,"
> +			" should be %2.2X\n", table->signature,
> +			table->checksum, (u8)(table->checksum - checksum));
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> + /* find the right table based on signaure, return the mapped table */
> +int sfi_get_table(char *signature, char *oem_id, char *oem_table_id,
> +	unsigned int flags, struct sfi_table_header **out_table)
> +{
> +	struct sfi_table_desc *tdesc;
> +	struct sfi_table_header *th;
> +	u32 i;
> +
> +	if (!signature || !out_table)
> +		return -1;
> +
> +	/* Walk the global SFI table list */
> +	for (i = 0; i < sfi_tblist.count; i++) {
> +		tdesc = &sfi_tblist.tables[i];
> +		th = &tdesc->header;
> +
> +		if ((flags & SFI_ACPI_TABLE) != (tdesc->flags & SFI_ACPI_TABLE))
> +			continue;
> +
> +		if (strncmp(th->signature, signature, SFI_SIGNATURE_SIZE))
> +			continue;
> +
> +		if (oem_id && strncmp(th->oem_id, oem_id, SFI_OEM_ID_SIZE))
> +			continue;
> +
> +		if (oem_table_id && strncmp(th->oem_table_id, oem_table_id,
> +			SFI_OEM_TABLE_ID_SIZE))
> +			continue;
> +
> +		if (!tdesc->pointer) {
> +			tdesc->pointer = sfi_map_memory(tdesc->address,
> +							th->length);
> +			if (!tdesc->pointer)
> +				return -ENOMEM;
> +		}
> +		*out_table = tdesc->pointer;
> +
> +		if (!sfi_tbl_permanant_mapped)
> +			tdesc->pointer = NULL;
> +
> +		return 0;
> +	}
> +
> +	return -1;
> +}
> +
> +void sfi_put_table(struct sfi_table_header *table)
> +{
> +	if (!sfi_tbl_permanant_mapped)
> +		sfi_unmap_memory(table, table->length);
> +}
> +
> +/* find table with signature, run handler on it */
> +int sfi_table_parse(char *signature, char *oem_id, char* oem_table_id,
> +	unsigned int flags, sfi_table_handler handler)
> +{
> +	int ret = 0;
> +	struct sfi_table_header *table = NULL;
> +
> +	if (!handler)
> +		return -EINVAL;
> +
> +	sfi_get_table(signature, oem_id, oem_table_id, flags, &table);
> +	if (!table)
> +		return -1;

the error return is a bit unclean here. First we use -EINVAL, then 
-1 - which is -EPERM which doesnt make sense. I'd suggest to return 
-EINVAL or -ENOTFOUND instead of -1 - not mix the return codes like 
that.

> +
> +	ret = handler(table);
> +	sfi_put_table(table);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sfi_table_parse);
> +
> +void sfi_tb_install_table(u64 addr, u32 flags)
> +{
> +	struct sfi_table_header *table;
> +	u32 length;
> +
> +	/* only map table header before knowing actual length */
> +	table = sfi_map_memory(addr, sizeof(struct sfi_table_header));
> +	if (!table)
> +		return;
> +
> +	length = table->length;
> +	sfi_unmap_memory(table, sizeof(struct sfi_table_header));
> +
> +	table = sfi_map_memory(addr, length);
> +	if (!table)
> +		return;
> +
> +	if (sfi_tb_verify_checksum(table, length))
> +		goto unmap_and_exit;
> +
> +	/* Initialize sfi_tblist entry */
> +	sfi_tblist.tables[sfi_tblist.count].flags = flags;
> +	sfi_tblist.tables[sfi_tblist.count].address = addr;
> +	sfi_tblist.tables[sfi_tblist.count].pointer = NULL;
> +	memcpy(&sfi_tblist.tables[sfi_tblist.count].header,
> +		table, sizeof(struct sfi_table_header));
> +
> +	sfi_print_table_header(addr, table);
> +	sfi_tblist.count++;
> +
> +unmap_and_exit:
> +	sfi_unmap_memory(table, length);
> +	return;
> +}
> +
> +/*
> + * Copy system table and associated table headers to internal format
> + */
> +static int __init
> +sfi_tb_parse_syst(unsigned long syst_addr)
> +{
> +	struct sfi_table_simple *syst;
> +	struct sfi_table_header *table;
> +	u64 *paddr;
> +	u32 length, tbl_cnt;
> +	int status;
> +	int i;
> +
> +	/* 1. map and get the total length of SYST */
> +	syst = sfi_map_memory(syst_addr, sizeof(struct sfi_table_simple));
> +	if (!syst)
> +		return -ENOMEM;
> +
> +	sfi_print_table_header(syst_addr, (struct sfi_table_header *)syst);
> +	table = (struct sfi_table_header *)syst;
> +	length = table->length;
> +	sfi_unmap_memory(syst, sizeof(struct sfi_table_simple));
> +
> +	/* 2. remap/verify the SYST and parse the number of entry */
> +	syst = sfi_map_memory(syst_addr, length);
> +	if (!syst)
> +		return -ENOMEM;
> +
> +	table = (struct sfi_table_header *)syst;
> +	status = sfi_tb_verify_checksum(table, length);
> +	if (status) {
> +		pr_err(PREFIX "SYST checksum error!!\n");
> +		sfi_unmap_memory(table, length);
> +		return status;
> +	}
> +
> +	/* Calculate the number of tables */
> +	tbl_cnt = (length - sizeof(struct sfi_table_header)) / sizeof(u64);
> +	paddr = (u64 *) syst->pentry;
> +
> +	sfi_tblist.count = 1;
> +	sfi_tblist.tables[0].address = syst_addr;
> +	sfi_tblist.tables[0].pointer = NULL;
> +	memcpy(&sfi_tblist.tables[0].header,
> +		syst, sizeof(struct sfi_table_header));
> +
> +	/* 3. save all tables info to the global sfi_tblist structure */
> +	for (i = 1; i <= tbl_cnt; i++)
> +		sfi_tb_install_table(*paddr++, 0);
> +
> +	sfi_unmap_memory(syst, length);
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * The OS finds the System Table by searching 16-byte boundaries between physical
> + * address 0x000E0000 and 0x000FFFFF. The OS shall search this region starting at the
> + * low address and shall stop searching when the 1st valid SFI System Table is found.

(Way-) overlong lines here.

> + */
> +static __init unsigned long sfi_find_syst(void)
> +{
> +	unsigned long offset, len;
> +	void *start;
> +
> +	len = SFI_SYST_SEARCH_END - SFI_SYST_SEARCH_BEGIN;
> +	start = sfi_map_memory(SFI_SYST_SEARCH_BEGIN, len);
> +	if (!start)
> +		return 0;
> +
> +	for (offset = 0; offset < len; offset += 16) {
> +		struct sfi_table_header *syst;
> +
> +		syst = (struct sfi_table_header *)(start + offset);

No need for the cast here - void pointers are unitype.

> +
> +		if (strncmp(syst->signature, SFI_SIG_SYST, SFI_SIGNATURE_SIZE))
> +				continue;

(one too many tabs)

> +
> +		if (!sfi_tb_verify_checksum(syst, syst->length)) {
> +			sfi_unmap_memory(start, len);
> +			return SFI_SYST_SEARCH_BEGIN + offset;
> +		}
> +	}
> +
> +	sfi_unmap_memory(start, len);
> +	return 0;
> +}
> +
> +int __init sfi_table_init(void)
> +{
> +	unsigned long syst_paddr;
> +	int status;
> +
> +	/* set up the SFI table array */
> +	sfi_tblist.tables = sfi_initial_tables;
> +	sfi_tblist.size = SFI_MAX_TABLES;
> +
> +	syst_paddr = sfi_find_syst();
> +	if (!syst_paddr) {
> +		pr_warning(PREFIX "No system table\n");
> +		goto err_exit;
> +	}
> +
> +	status = sfi_tb_parse_syst(syst_paddr);
> +	if (status)
> +		goto err_exit;
> +
> +	return 0;
> +err_exit:
> +	disable_sfi();
> +	return -1;
> +}
> +
> +static void sfi_realloc_tblist(void)
> +{
> +	int size;
> +	struct sfi_table_desc *table;
> +
> +	size = (sfi_tblist.count + 8) * sizeof(struct sfi_table_desc);

magic, unexplained 8.

> +	table = kzalloc(size, GFP_KERNEL);
> +	if (!table) {
> +		disable_sfi();
> +		return;
> +	}
> +
> +	memcpy(table, sfi_tblist.tables,
> +		sfi_tblist.count * sizeof(struct sfi_table_desc));
> +	sfi_tblist.tables = table;
> +	return;
> +}
> +
> +int __init sfi_init(void)
> +{
> +	if(!acpi_disabled){
> +		disable_sfi();
> +		return -1;
> +	}
> +
> +	if(sfi_disabled)
> +		return -1;

Coding style problems.

> +
> +	pr_info(PREFIX "Simple Firmware Interface v0.5\n");
> +
> +	if (sfi_table_init())
> +		return -1;
> +
> +	return sfi_platform_init();
> +}
> +/* after most of the system is up, abandon the static array */
> +void __init sfi_init_late(void)
> +{
> +	if (sfi_disabled)
> +		return;
> +	sfi_tbl_permanant_mapped = 1;
> +	sfi_realloc_tblist();
> +}
> +
> +static int __init sfi_parse_cmdline(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	if (!strcmp(arg, "off"))
> +		sfi_disabled = 1;
> +
> +	return 0;
> +}
> +early_param("sfi", sfi_parse_cmdline);
> diff --git a/drivers/sfi/sfi_core.h b/drivers/sfi/sfi_core.h
> new file mode 100644
> index 0000000..36703b0
> --- /dev/null
> +++ b/drivers/sfi/sfi_core.h
> @@ -0,0 +1,63 @@
> +/* sfi_core.h Simple Firmware Interface, internal header */
> +
> +/*
> + * Copyright (C) 2009, Intel Corp.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> + *    substantially similar to the "NO WARRANTY" disclaimer below
> + *    ("Disclaimer") and any redistribution must be conditioned upon
> + *    including a substantially similar Disclaimer requirement for further
> + *    binary redistribution.
> + * 3. Neither the names of the above-listed copyright holders nor the names
> + *    of any contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") version 2 as published by the Free
> + * Software Foundation.
> + *
> + * NO WARRANTY
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> + * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> + * POSSIBILITY OF SUCH DAMAGES.
> + */
> +
> +struct sfi_table_desc {
> +	struct sfi_table_header header;	/* copy of the headef info */

s/headef/header

> +	struct sfi_table_header *pointer;
> +	u64 address;
> +	u32 flags;
> +};
> +
> +/* SFI internal root SYSTem table */
> +struct sfi_internal_syst {
> +	struct sfi_table_desc *tables;
> +	u32 count;
> +	u32 size;
> +};

i'd suggest using the structure definition style you use in 
arch/x86/kernel/sfi.c:

> +struct sfi_table_desc {
> +	struct sfi_table_header		header;	/* copy of the headef info */
> +	struct sfi_table_header		*pointer;
> +	u64				address;
> +	u32				flags;
> +};


> +
> +extern int sfi_get_table(char *signature, char *oem_id, char *oem_table_id,
> +	uint flags, struct sfi_table_header **out_table);
> +extern void sfi_put_table(struct sfi_table_header *table);
> +
> +extern int sfi_acpi_init(void);
> +extern struct sfi_internal_syst sfi_tblist;
> +void sfi_tb_install_table(u64 address, u32 flags);
> +
> +#define SFI_ACPI_TABLE	1

In general, nice stuff - basically SFI is cleanly implemented ACPI 
tables without any of the run-code-in-acpi-tables complications, 
right?

	Ingo
