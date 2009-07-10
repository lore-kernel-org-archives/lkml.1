Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZGJGht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZGJGht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZGJGhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:37:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZGJGhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:37:40 -0400
Date: Fri, 10 Jul 2009 08:37:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 07/12] SFI: add x86 support
Message-ID: <20090710063726.GF22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <4676b1fee4cae65c678754fbdecae626ac161b81.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676b1fee4cae65c678754fbdecae626ac161b81.1247025117.git.len.brown@intel.com>
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


* Len Brown <lenb@kernel.org> wrote:

> From: Feng Tang <feng.tang@intel.com>
> 
> arch/x86/kernel/sfi.c serves the dual-purpose of supporting the
> SFI core with arch specific code, as well as a home for the
> arch-specific code that uses SFI.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/kernel/Makefile |    1 +
>  arch/x86/kernel/sfi.c    |  284 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/sfi/sfi_core.c   |    2 +-
>  3 files changed, 286 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/kernel/sfi.c
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 6c327b8..e430123 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -53,6 +53,7 @@ obj-y				+= step.o
>  obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
>  obj-y				+= cpu/
>  obj-y				+= acpi/
> +obj-$(CONFIG_SFI)		+= sfi.o
>  obj-y				+= reboot.o
>  obj-$(CONFIG_MCA)		+= mca_32.o
>  obj-$(CONFIG_X86_MSR)		+= msr.o
> diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
> new file mode 100644
> index 0000000..a96ea0f
> --- /dev/null
> +++ b/arch/x86/kernel/sfi.c
> @@ -0,0 +1,284 @@
> +/*
> + *  sfi.c - SFI Boot Support (refer acpi/boot.c)
> + *
> + *  Copyright (C) 2008-2009	Intel Corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +
> +#define KMSG_COMPONENT "SFI"
> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> +
> +#include <linux/bootmem.h>
> +#include <linux/cpumask.h>
> +#include <linux/module.h>
> +#include <linux/acpi.h>
> +#include <linux/init.h>
> +#include <linux/efi.h>
> +#include <linux/irq.h>
> +#include <linux/sfi.h>
> +#include <linux/io.h>
> +
> +#include <asm/io_apic.h>
> +#include <asm/pgtable.h>
> +#include <asm/mpspec.h>
> +#include <asm/setup.h>
> +#include <asm/apic.h>
> +#include <asm/e820.h>
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> +#endif
> +
> +#ifdef CONFIG_X86_IO_APIC
> +static struct mp_ioapic_routing {
> +	int	gsi_base;
> +	int	gsi_end;
> +} mp_ioapic_routing[MAX_IO_APICS];
> +#endif
> +
> +static __init struct sfi_table_simple *sfi_early_find_syst(void)
> +{
> +	unsigned long i;
> +	char *pchar = (char *)SFI_SYST_SEARCH_BEGIN;
> +
> +	/* SFI spec defines the SYST starts at a 16-byte boundary */
> +	for (i = 0; SFI_SYST_SEARCH_BEGIN + i < SFI_SYST_SEARCH_END; i += 16) {
> +		if (!strncmp(SFI_SIG_SYST, pchar, SFI_SIGNATURE_SIZE))
> +			return (struct sfi_table_simple *)
> +					(SFI_SYST_SEARCH_BEGIN + i);
> +
> +		pchar += 16;
> +	}

Hm, this loop seems a bit confused about how it wants to iterate 
over a range of addresses.

SFI_SYST_SEARCH_BEGIN and END should probably have a void * basic 
type, which would allow a _much_ cleaner loop like this:

static __init struct sfi_table_simple *sfi_early_find_syst(void)
{
	/* SFI spec defines the SYST starts at a 16-byte boundary */
	for (p = SFI_SYST_SEARCH_BEGIN; p < SFI_SYST_SEARCH_END, p += 16) {
		if (!strncmp(SFI_SIG_SYST, p, SFI_SIGNATURE_SIZE))
			return p;
	}
	return NULL;
}

And this is a general observation for the other patches as well: if 
you anywhere do a C type cast please double check whether you really 
need to do it. In 90% of the cases it's a sign of some badness, in 
99% of the cases it's a source of fragility, and in 99.9% of the 
cases it can be avoided by restructuring the code.

I saw a handful of other cases where it's really avoidable.

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

Nit: s/syst/SYST in the comment text - to stay in line with how we 
refer to these firmware tables.

> +	syst = sfi_early_find_syst();
> +	if (!syst)
> +		return -1;
> +
> +	tbl_cnt = (syst->header.length - sizeof(struct sfi_table_header)) /
> +			sizeof(u64);

We have a helper for this, SFI_GET_NUM_ENTRIES(), please use it as 
SFI_GET_NUM_ENTRIES(syst, u64) or so.

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

This loop does a double type cast - which already shows that we do 
something weird here. Firstly, this will trigger a warning on 64-bit 
builds. Secondly, it's cast twice - to different target types.

Thirdly, the double cast itself discards the high 32 bits of the 
value. This is pretty bad as it allows the firmware to pass in some 
bogus value there and we could build a dependency on it.

> +	if (!mmapt) {
> +		pr_warning("could not find a valid memory map table\n");
> +		return -1;
> +	}
> +
> +	/* refer copy_e820_memory() */
> +	num = SFI_GET_NUM_ENTRIES(mmapt, struct sfi_mem_entry);
> +	mentry = (struct sfi_mem_entry *)mmapt->pentry;
> +	for (i = 0; i < num; i++) {
> +		start = mentry->phy_start;
> +		size = mentry->pages << PAGE_SHIFT;
> +		end = start + size;
> +
> +		if (start > end)
> +			return -1;
> +
> +		pr_debug("start = 0x%08x end = 0x%08x type = %d\n",
> +			(u32)start, (u32)end, mentry->type);

DEBUG is not defined at the top of the file so this is dead code.

> +		/* translate SFI mmap type to E820 map type */
> +		switch (mentry->type) {
> +		case EFI_CONVENTIONAL_MEMORY:
> +			type = E820_RAM;
> +			break;
> +		case EFI_UNUSABLE_MEMORY:
> +			type = E820_UNUSABLE;
> +			break;
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
> +void __init mp_sfi_register_lapic_address(unsigned long address)
> +{
> +	mp_lapic_addr = address;
> +	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);

Please put newlines after local variable definition blocks.

> +
> +	if (boot_cpu_physical_apicid == -1U)
> +		boot_cpu_physical_apicid = read_apic_id();
> +
> +	pr_debug("Boot CPU = %d\n", boot_cpu_physical_apicid);
> +}
> +
> +/* All CPUs enumerated by SFI must be present and enabled */
> +void __cpuinit mp_sfi_register_lapic(u8 id)
> +{
> +	int boot_cpu = 0;
> +
> +	if (MAX_APICS - id <= 0) {
> +		pr_warning("Processor #%d invalid (max %d)\n",
> +			id, MAX_APICS);
> +		return;
> +	}
> +
> +	if (id == boot_cpu_physical_apicid)
> +		boot_cpu = 1;
> +	pr_info("registering lapic[%d]\n", id);
> +
> +	generic_processor_info(id, GET_APIC_VERSION(apic_read(APIC_LVR)));
> +}
> +
> +static int __init sfi_parse_cpus(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_cpu_table_entry *pentry;
> +	int i;
> +	int cpu_num;
> +
> +	sb = (struct sfi_table_simple *)table;
> +	cpu_num = SFI_GET_NUM_ENTRIES(sb, struct sfi_cpu_table_entry);
> +	pentry = (struct sfi_cpu_table_entry *)sb->pentry;
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

(stray tab.)

> +void __init mp_sfi_register_ioapic(u8 id, u32 paddr)
> +{
> +	int idx = 0;
> +	int tmpid;
> +	static u32 gsi_base;

I think this static variable should be outside of this function - so 
that it's apparent at a glance that it persists.

> +
> +	if (nr_ioapics >= MAX_IO_APICS) {
> +		pr_err("ERROR: Max # of I/O APICs (%d) exceeded "
> +			"(found %d)\n", MAX_IO_APICS, nr_ioapics);
> +		panic("Recompile kernel with bigger MAX_IO_APICS!\n");

We should fail more gracefully here i think - print a warning and 
continue. The system might not boot ... or it might, with a few 
devices not operational.

> +	}
> +	if (!paddr) {
> +		pr_warning("WARNING: Bogus (zero) I/O APIC address"
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

Why is this define needed? io_apic_get_version() exists on 64-bit as 
well.

> +
> +	/*
> +	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
> +	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
> +	 */
> +	mp_ioapic_routing[idx].gsi_base = gsi_base;
> +	mp_ioapic_routing[idx].gsi_end = gsi_base +
> +		io_apic_get_redir_entries(idx);
> +	gsi_base = mp_ioapic_routing[idx].gsi_end + 1;
> +
> +	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
> +		"GSI %d-%d\n",
> +		idx, mp_ioapics[idx].apicid,
> +		mp_ioapics[idx].apicver, (u32)mp_ioapics[idx].apicaddr,
> +		mp_ioapic_routing[idx].gsi_base,
> +		mp_ioapic_routing[idx].gsi_end);
> +
> +	nr_ioapics++;
> +}
> +
> +static int __init sfi_parse_ioapic(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_apic_table_entry *pentry;
> +	int i, num;
> +
> +	sb = (struct sfi_table_simple *)table;
> +	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_apic_table_entry);
> +	pentry = (struct sfi_apic_table_entry *)sb->pentry;
> +
> +	for (i = 0; i < num; i++) {
> +		mp_sfi_register_ioapic(i, pentry->phy_addr);
> +		pentry++;
> +	}
> +
> +	WARN(pic_mode, KERN_WARNING
> +		"SFI: pic_mod shouldn't be 1 when IOAPIC table is present\n");
> +	pic_mode = 0;
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
> +	sfi_table_parse(SFI_SIG_APIC, NULL, NULL, 0, sfi_parse_ioapic);

General comment: sfi_table_parse() has these pointless NULL, NULL, 0 
portions 90% of the uses i've seen. They are the 'any match' key for 
table parsing.

Combined with the struct table_key suggestion i made in the other 
reply, we could have this define:

#define SFI_ANY_KEY { .signature = NULL, .oem_id = NULL, .oem_table_id = 0 }

and write those 'any match' lines as:

	sfi_table_parse(SFI_SIG_CPUS, SFI_ANY_KEY, sfi_parse_cpus);

which is _far_ more readable and more extensible as well. (it is 
trivial to extend such a design with a new key field - while with 
the current open-coded structure it's far more invasive to do such a 
change.)

Thanks,

	Ingo
