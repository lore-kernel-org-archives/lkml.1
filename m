Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZFWMdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZFWMdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZFWMcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:32:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35195 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZFWMcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:32:54 -0400
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
From: Andi Kleen <andi@firstfloor.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
Date: Tue, 23 Jun 2009 14:32:56 +0200
In-Reply-To: <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com> (Len Brown's message of "Tue, 23 Jun 2009 03:14:01 -0400")
Message-ID: <87iqin166f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> +static ulong __init sfi_early_find_syst(void)
> +{
> +	unsigned long i;
> +	char *pchar = (char *)SFI_SYST_SEARCH_BEGIN;
> +
> +	for (i = 0; SFI_SYST_SEARCH_BEGIN + i < SFI_SYST_SEARCH_END; i += 16, pchar += 16) {
> +		if (!strncmp(SFI_SIG_SYST, pchar, SFI_SIGNATURE_SIZE))
> +			return SFI_SYST_SEARCH_BEGIN + i;


Such additional memory scans are always a bit risky, e.g. if there's
stray hardware there. Has it been verified that existing kernels
already scan this area?



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

printk here?

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


Surely UNUSTABLE and RUNTIME_SERVICES should be added somewhere to the resources,
otherwise MMIO allocation might put something there.

> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +void __init mp_sfi_register_lapic_address(u64 address)
> +{
> +	mp_lapic_addr = (unsigned long) address;
> +
> +	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
> +
> +	if (boot_cpu_physical_apicid == -1U)
> +		boot_cpu_physical_apicid = read_apic_id();
> +
> +	pr_info(PREFIX "Boot CPU = %d\n", boot_cpu_physical_apicid);

That's the same what ACPI does, isn't it? Some code sharing
would be good.

> +static int __init sfi_parse_cpus(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb;
> +	struct sfi_cpu_table_entry *pentry;
> +	int i;
> +	int cpu_num;
> +
> +	BUG_ON(!table);

Another useless BUG_ON. Some more below too.

> +	sb = (struct sfi_table_simple *)table;
> +
> +	cpu_num = SFI_GET_ENTRY_NUM(sb, sfi_cpu_table_entry);
> +	pentry = (struct sfi_cpu_table_entry *) sb->pentry;
> +
> +	for (i = 0; i < cpu_num; i++) {
> +		mp_sfi_register_lapic(pentry->apicid);
> +		pentry++;
> +	}

Array overflow checking?


> +	mp_ioapics[idx].apicver = 0;
> +#endif
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

That printk should be dependent on the runtime apic verbosity level?

> +
> +/*
> + * flag for whether using ioremap() to map the sfi tables, if yes
> + * each table only need be mapped once, otherwise each arch's
> + * early_ioremap  and early_iounmap should be used each time a
> + * table is visited
> + */
> +static u32 sfi_tbl_permanant_mapped;

permanant is a typo?

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

imho it would be cleaner if the callers just called these functions
directly. Are the !phys !size checks really needed?


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


Since the mappings are always 4K you would only need to remap
if the size is > PAGE_SIZE

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

To be honest I'm not sure why this list exists at all.
Is it that difficult to just rewalk the firmware supplied
table as needed? 


-andi
-- 
ak@linux.intel.com -- Speaking for myself only.
