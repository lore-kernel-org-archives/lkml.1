Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYJHAwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYJHAwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYJHAwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:52:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:52:44 -0400
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
From: Andi Kleen <andi@firstfloor.org>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com>
Date: Wed, 08 Oct 2008 02:52:41 +0200
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> (Joseph Cihula's message of "Tue, 7 Oct 2008 13:34:57 -0700")
Message-ID: <87myhflxgm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Cihula, Joseph" <joseph.cihula@intel.com> writes:

Quick review, not very deep (as in just Linux interfaces not design)

> @@ -0,0 +1,258 @@
> +/*
> + * tboot.c: main implementation of helper functions used by kernel for
> + *          runtime support

This description is not very helpful for someone who doesn't know
what tboot is.

There should be at least a short paragraph here describing what it is
Better more.

> +	extern struct boot_params boot_params;

That should be in some include

> +	printk(KERN_INFO "TBOOT: found shared page at phys addr 0x%lx:\n",
> +	       (unsigned long)boot_params.hdr.tboot_shared_addr);
> +	printk(KERN_DEBUG "  version: %d\n", tboot_shared->version);
> +	printk(KERN_DEBUG "  log_addr: 0x%08x\n", tboot_shared->log_addr);
> +	printk(KERN_DEBUG "  shutdown_entry32: 0x%08x\n",
> +	       tboot_shared->shutdown_entry32);
> +	printk(KERN_DEBUG "  shutdown_entry64: 0x%08x\n",
> +	       tboot_shared->shutdown_entry64);
> +	printk(KERN_DEBUG "  shutdown_type: %d\n", tboot_shared->shutdown_type);
> +	printk(KERN_DEBUG "  s3_tb_wakeup_entry: 0x%08x\n",
> +	       tboot_shared->s3_tb_wakeup_entry);
> +	printk(KERN_DEBUG "  s3_k_wakeup_entry: 0x%08x\n",
> +	       tboot_shared->s3_k_wakeup_entry);
> +	printk(KERN_DEBUG "  &acpi_sinfo: 0x%p\n", &tboot_shared->acpi_sinfo);
> +	printk(KERN_DEBUG "  tboot_base: 0x%08x\n", tboot_shared->tboot_base);
> +	printk(KERN_DEBUG "  tboot_size: 0x%x\n", tboot_shared->tboot_size);

Having that much debug output by default is not nice.

> +}
> +
> +static pgd_t *tboot_pg_dir;
> +static inline void switch_to_tboot_pt(void)
> +{
> +	native_write_cr3(__pa(tboot_pg_dir));
> +}
> +
> +struct tboot_pgt_struct {
> +	unsigned long ptr;
> +	struct tboot_pgt_struct *next;
> +};
> +static struct tboot_pgt_struct *tboot_pgt;
> +
> +/* Allocate (and save for later release) a page */
> +static unsigned long alloc_tboot_page(void)

Passing pointers around as unsigned long is not nice.

> +{
> +	unsigned long ptr;
> +	struct tboot_pgt_struct *pgt;
> +
> +	ptr = get_zeroed_page(GFP_ATOMIC);

In general GFP_ATOMIC is nasty and should be avoided if possible.

> +	if (ptr) {
> +		pgt = kmalloc(sizeof(*pgt), GFP_ATOMIC);
> +		if (!pgt) {
> +			free_page(ptr);
> +			return 0;
> +		}
> +		pgt->ptr = ptr;
> +		pgt->next = tboot_pgt;
> +		tboot_pgt = pgt;

Instead of allocating something here you could just use
the list_head in struct page

> +	pgd = tboot_pg_dir + pgd_index(vaddr);
> +#ifdef __x86_64__

Is there any reason you cannot use the generic pgalloc.h allocators?
Is it only for tracking the pages? Why not track it using 
the page tables? Or insert it into the list (if you really
need one, i'm not sure what the list is actually good for) 
based on the page tables after the fact.

That would avoid the ifdefery and clean this function up
greatly.
> +
> +	/* Create identity map for tboot shutdown code. */
> +	if (tboot_shared->version >= 0x02) {
> +		map_base = PFN_DOWN(tboot_shared->tboot_base);
> +		map_size = PFN_UP(tboot_shared->tboot_size);
> +	} else {
> +		map_base = 0;
> +		map_size = PFN_UP(0xa0000);

Avoid magic numbers like this.

> +	}
> +
> +	if (map_pages_for_tboot(map_base << PAGE_SHIFT, map_base, map_size)) {
> +		printk(KERN_DEBUG "error mapping tboot pages "
> +				  "(mfns) @ 0x%x, 0x%x\n", map_base, map_size);
> +		clean_up_tboot_mapping();
> +		return;
> +	}
> +
> +	switch_to_tboot_pt();
> +
> +#ifdef __x86_64__
> +	asm volatile ("jmp *%%rdi" : : "D" (tboot_shared->shutdown_entry64));
> +#else
> +	asm volatile ("jmp *%%edi" : : "D" (tboot_shared->shutdown_entry32));
> +#endif

Why not just use a C indirect function call?

> +#ifdef CONFIG_TXT
> +static void tboot_sleep(u8 sleep_state)
> +{
> +	uint32_t shutdown_type;
> +
> +	switch (sleep_state) {
> +	case ACPI_STATE_S3:
> +		shutdown_type = TB_SHUTDOWN_S3;
> +		break;
> +	case ACPI_STATE_S4:
> +		shutdown_type = TB_SHUTDOWN_S4;
> +		break;
> +	case ACPI_STATE_S5:
> +		shutdown_type = TB_SHUTDOWN_S5;
> +		break;

This could be much shorter with just an array lookup

> +	default:
> +		return;
> +	}
> +
> +	tboot_shutdown(shutdown_type);
> +}
> +#endif
> +
>  /*******************************************************************************
>   *
>   * FUNCTION:    acpi_enter_sleep_state
> @@ -361,6 +392,20 @@ acpi_status asmlinkage acpi_enter_sleep_
>  
>  	PM1Acontrol |= sleep_enable_reg_info->access_bit_mask;
>  	PM1Bcontrol |= sleep_enable_reg_info->access_bit_mask;
> +
> +#ifdef CONFIG_TXT
> +	if (tboot_in_measured_env()) {
> +		tboot_shared->acpi_sinfo.pm1a_cnt =
> +			(uint16_t)acpi_gbl_FADT.xpm1a_control_block.address;
> +		tboot_shared->acpi_sinfo.pm1b_cnt =
> +			(uint16_t)acpi_gbl_FADT.xpm1b_control_block.address;

Why are the addresses truncated to 16bit?

> +		tboot_shared->acpi_sinfo.pm1a_cnt_val = PM1Acontrol;
> +		tboot_shared->acpi_sinfo.pm1b_cnt_val = PM1Bcontrol;
> +		tboot_sleep(sleep_state);
> +		printk(KERN_DEBUG "TBOOT failed entering s3 state\n");

That should not be KERN_DEBUG

> +
> +#define TB_SHUTDOWN_REBOOT      0
> +#define TB_SHUTDOWN_S5          1
> +#define TB_SHUTDOWN_S4          2
> +#define TB_SHUTDOWN_S3          3
> +#define TB_SHUTDOWN_HALT        4

If you use the same values as ACPI you perhaps
don't even need a lookup table above.


> +/* {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} */
> +#define TBOOT_SHARED_UUID     \
> +		((struct tboot_uuid){ 0x663c8dff, 0xe8b3, 0x4b82, 0xaabf,   \
> +				{ 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8 } })

Some comment where this magic number comes from?


-Andi
-- 
ak@linux.intel.com
