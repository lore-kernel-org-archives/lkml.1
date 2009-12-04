Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZLDLFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZLDLFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZLDLFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:05:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52922 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZLDLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:05:17 -0500
Date: Fri, 4 Dec 2009 12:05:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Shane Wang <shane.wang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>, len.brown@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity verification
Message-ID: <20091204110522.GR18989@one.firstfloor.org>
References: <4B18D26B.4040500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B18D26B.4040500@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 05:12:11PM +0800, Shane Wang wrote:
> diff -r c878d454dc8b arch/x86/kernel/entry_64.S
> --- a/arch/x86/kernel/entry_64.S	Wed Dec 02 01:06:32 2009 -0800
> +++ b/arch/x86/kernel/entry_64.S	Thu Dec 03 07:22:17 2009 -0800
> @@ -1275,6 +1275,26 @@ ENTRY(call_softirq)
>  	CFI_ENDPROC
>  END(call_softirq)
> 
> +#ifdef CONFIG_INTEL_TXT
> +/* void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp) */
> +ENTRY(tboot_switch_stack_call)

I would drop the tboot_ prefix, stack switching can be useful for other
things too.

> +	CFI_STARTPROC
> +	push %rbp
> +	CFI_ADJUST_CFA_OFFSET	8
> +	CFI_REL_OFFSET	rbp,0
> +	mov %rsp, %rbp
> +	CFI_DEF_CFA_REGISTER	rbp

Did you verify that the dwarf2 really works and gdb can backtrace through
it?

> +{
> +	BUG_ON((new_stack != NULL) || (new_stack_ptr != NULL));
> +
> +	/*
> +	 * as long as thread info is above 4G, then switch stack,
> +	 * since tboot can't access >4G stack for MACing
> +	 */
> +	if (!((PFN_PHYS(PFN_DOWN(virt_to_phys(current_thread_info())))
> +		+ (PFN_UP(THREAD_SIZE) << PAGE_SHIFT))
> +		& 0xffffffff00000000UL))
> +		return -1;

All the PFN_*s seem somewhat redundant, it would be easier to keep
everything shifted up in the first place.

> +
> +	new_stack = (char *)__get_free_pages(GFP_DMA32, IRQ_STACK_ORDER);
> +
> +	BUG_ON(new_stack == NULL);

GFP_REPEAT at least? BUG_ON is a nasty way to handle out of memory

> +	memset(new_stack, 0, IRQ_STACK_SIZE);

GFP_ZERO
> +	new_stack_ptr = new_stack + IRQ_STACK_SIZE - 64;

Why - 64?

> +
> +	return 0;
> +}
> +
> +static void tboot_post_stack_switch(void)
> +{
> +	BUG_ON((new_stack == NULL) || (new_stack_ptr == NULL));
> +
> +	free_pages((unsigned long)new_stack, IRQ_STACK_ORDER);
> +	new_stack = NULL;
> +	new_stack_ptr = NULL;
> +}
> +
> +extern void tboot_switch_stack_call(void (*target_func)(void), u64 
> new_rsp);

Typically those should be in some header.

> +	struct page *page;
> +	uint64_t paddr, rstart, rend;
> +	unsigned long pfn;
> +	uint8_t zeroed_key[VMAC_KEY_LEN];
> +
> +	if (!tfm)
> +		tfm = crypto_alloc_hash("vmac(aes)", 0, CRYPTO_ALG_ASYNC);
> +
> +	if (IS_ERR(tfm)) {
> +		tfm = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	desc.tfm = tfm;
> +	desc.flags = 0;
> +
> +	sg_init_table(sg, 1);
> +
> +	ret = crypto_hash_init(&desc);
> +	if (ret)
> +		return ret;
> +	ret = crypto_hash_setkey(desc.tfm, key, VMAC_KEY_LEN);
> +	if (ret)
> +		return ret;
> +
> +	for_each_online_pgdat(pgdat) {

No locking against memory hotplug? Even if user space is still down
doing that would be safer

> +		unsigned long flags;
> +
> +		pgdat_resize_lock(pgdat, &flags);
> +		for (i = 0, pfn = pgdat->node_start_pfn;
> +			i < pgdat->node_spanned_pages;
> +			i++, pfn = pgdat->node_start_pfn + i) {
> +
> +			if (!pfn_valid(pfn) || !page_is_ram(pfn))
> +				continue;

You probably should consider a faster way to skip holes, doing
them piece by piece might well be a performance problem on very
holey systems. Especially page_is_ram() is quite slow.

> +					|| (rend <= paddr))
> +					continue;
> +				break;
> +			}
> +
> +			if (j == tboot->num_mac_regions) {
> +				sg_set_page(sg, page, PAGE_SIZE, 0);
> +#ifdef CONFIG_DEBUG_PAGEALLOC
> +			/*
> +			 * check if the page we are going to MAC is marked as
> +			 * present in the kernel page tables.
> +			 */
> +			if (!kernel_page_present(page)) {
> +				kernel_map_pages(page, 1, 1);
> +				ret = crypto_hash_update(&desc, sg, 
> PAGE_SIZE);
> +				kernel_map_pages(page, 1, 0);

Nasty, might be racy -- better use a separate mapping in this case.

> +#ifdef CONFIG_X86_64
> +	/*
> +	 * for stack > 4G, we should MAC the stack in the kernel after 
> switch,
> +	 * for stack < 4G, the stack is MACed by tboot
> +	 */

This special case seems quite ugly, with all its ifdefs and lots
of special code. 
Can't you just MAC the stack always? Shouldn't be that expensive. 

> +	else
> +#endif
> +		add_mac_region(virt_to_phys(current_thread_info()),
> +				THREAD_SIZE); /* < 4G */
> +
> +	/* MAC userspace memory not handled by tboot */
> +	get_random_bytes(tboot->s3_key, sizeof(tboot->s3_key));

That's early in boot isn't it? It's quite doubtful you'll get
anything even vaguely random out of get_random_bytes at this point, may be not
even the time.

>  	}
> 
>  	tboot_shutdown(acpi_shutdown_map[sleep_state]);
> +}
> +
> +static void tboot_sx_resume(void)
> +{
> +	vmac_t mac;
> +
> +	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
> +		panic("tboot: vmac generation failed\n");
> +	else if (mac != mem_mac)
> +#ifdef CONFIG_DEBUG_KERNEL
> +		pr_debug("tboot: memory integrity %llx -> %llx\n",
> +				mem_mac, mac);
> +#else
> +		panic("tboot: memory integrity was lost on resume\n");
> +#endif

I don't think DEBUG_KERNEL is supposed to be used like this, better
probably a separate option if it makes sense.

Typical problem with panics at this point: is anything even visible
on the screen?

>  
> +#ifdef CONFIG_INTEL_TXT
> +/* void tboot_switch_stack_call(void (*target_func)(void), u64 new_rsp) */
> +ENTRY(tboot_switch_stack_call)

Hmm, I thought i had seen that earlier already? Is it a copy?

BTW there's no reason all of this has to be in entry*.S, that
file is already quite crowded.

The patch is duplicated here?

-Andi

