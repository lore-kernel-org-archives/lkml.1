Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbXK1HEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbXK1HEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 02:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXK1HEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 02:04:25 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:34835 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXK1HEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 02:04:24 -0500
Message-ID: <474D100E.1000101@student.ltu.se>
Date: Wed, 28 Nov 2007 07:51:58 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
References: <474C34CC.6060509@gmail.com>
In-Reply-To: <474C34CC.6060509@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> General description: kmemcheck will trap every read and write to 
> memory that was
> allocated dynamically (ie. with kmalloc()). If a memory address is 
> read that has
> not previously been written to, a message is printed to the kernel log.
>
<snip>
> diff --git a/arch/x86/kernel/kmemcheck_32.c 
> b/arch/x86/kernel/kmemcheck_32.c
> new file mode 100644
> index 0000000..9d065b9
> --- /dev/null
> +++ b/arch/x86/kernel/kmemcheck_32.c
> @@ -0,0 +1,290 @@
> +#include <linux/kernel.h>
> +#include <linux/kallsyms.h>
> +#include <linux/mm.h>
> +#include <asm/cacheflush.h>
> +#include <asm/kmemcheck.h>
> +#include <asm/tlbflush.h>
> +
> +static int
Not 'static bool'?
> +page_is_tracked(struct page *page)
> +{
> +    struct page *head;
> +
> +    if (!page)
> +        return 0;
> +    head = compound_head(page);
> +    if (!head)
> +        return 0;
> +    if (!(head->flags & (1 << PG_slab)))
> +        return 0;
> +    if (!head->slab)
> +        return 0;
> +    if (head->slab->flags & __GFP_NOTRACK)
> +        return 0;
> +    return 1;
Why not returning 'false' and 'true'?
> +}
> +
> +static void
> +show_addr(uint32_t addr)
> +{
> +    struct page *page;
> +    pte_t *pte;
> +
> +    if (!addr)
> +        return;
> +    page = virt_to_page(addr);
> +    if (!page_is_tracked(page))
> +        return;
> +
> +    pte = lookup_address(addr);
> +    change_page_attr(page, 1, __pgprot(pte->pte_low | _PAGE_VISIBLE));
> +    __flush_tlb_one(addr);
> +}
> +
> +static void
> +hide_addr(uint32_t addr)
> +{
> +    struct page *page;
> +    pte_t *pte;
> +
> +    if (!addr)
> +        return;
> +    page = virt_to_page(addr);
> +    if (!page_is_tracked(page))
> +        return;
> +    pte = lookup_address(addr);
> +    change_page_attr(page, 1, __pgprot(pte->pte_low & ~_PAGE_VISIBLE));
> +    __flush_tlb_one(addr);
> +}
> +
> +DEFINE_PER_CPU(uint32_t, kmemcheck_read_addr);
> +DEFINE_PER_CPU(uint32_t, kmemcheck_write_addr);
> +
> +void
> +kmemcheck_show(struct pt_regs *regs)
> +{
> +    show_addr(__get_cpu_var(kmemcheck_read_addr));
> +    show_addr(__get_cpu_var(kmemcheck_write_addr));
> +    regs->eflags |= TF_MASK;
> +}
> +
> +void
> +kmemcheck_hide(struct pt_regs *regs)
> +{
> +    hide_addr(__get_cpu_var(kmemcheck_read_addr));
> +    hide_addr(__get_cpu_var(kmemcheck_write_addr));
> +    regs->eflags &= ~TF_MASK;
> +}
> +
> +void
> +kmemcheck_hide_pages(struct page *p, unsigned int n)
> +{
> +    unsigned int i;
> +
> +    for(i = 0; i < n; ++i) {
> +        unsigned long address = (unsigned long) page_address(&p[i]);
> +        pte_t *pte = lookup_address(address);
> +
> +        change_page_attr(&p[i], 1,
> +            __pgprot(pte->pte_low & ~_PAGE_VISIBLE));
> +        __flush_tlb_one(address);
> +    }
> +}
> +
> +static int
'static bool'?
> +opcode_is_prefix(uint8_t b)
> +{
> +    return
> +        /* Group 1 */
> +        b == 0xf0 || b == 0xf2 || b == 0xf3
> +        /* Group 2 */
> +        || b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
> +        || b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
> +        /* Group 3 */
> +        || b == 0x66
> +        /* Group 4 */
> +        || b == 0x67;
> +}
> +
> +/* This is a VERY crude opcode decoder. We only need to find the size 
> of the
> + * load/store that caused our #PF and this should work for all the 
> opcodes
> + * that we care about. Moreover, the ones who invented this 
> instruction set
> + * should be shot. */
> +static unsigned int
> +opcode_get_size(const uint8_t *opcode)
Are we not using 'u8' in the kernel?
> +{
> +    const uint8_t *i;
and here. Also, I find the name 'i' a bit confusing in this context, 
since it is not really a counter. What about 'cur', 'prefix_op' or 
something of the sort?
> +
> +    /* Default operand size */
> +    int operand_size_override = 32;
> +
> +    /* prefixes */
> +    for (i = opcode; opcode_is_prefix(*i); ++i) {
> +        if (*i == 0x66)
> +            operand_size_override = 16;
> +    }
> +
> +    /* escape opcode */
> +    if (*i == 0x0f) {
> +        ++i;
> +
> +        if(*i == 0xb6)
Please do, as the previous, 'if ()'. A good checker for these kind of 
things is the 'scripts/checkpatch.pl'...
> +            return operand_size_override >> 1;
> +        if(*i == 0xb7)
> +            return 16;
> +    }
> +
> +    return (*i & 1) ? operand_size_override : 8;
> +}
> +
> +static uint8_t
and here...
> +opcode_get_primary(const uint8_t *opcode)
and here..
> +{
> +    const uint8_t *i;
and here. Also, I find the name 'i' a bit confusing in this context, 
since it is not really a counter. What about 'cur', 'prim_op', 
'prefix_op' or something of the sort?
> +
> +    /* skip prefixes */
> +    for (i = opcode; opcode_is_prefix(*i); ++i);
> +    return *i;
> +}
> +
> +static void *address_get_shadow_slab(unsigned long address,
> +    struct page *head)
> +{
> +    if (!head->slab)
> +        return NULL;
> +
> +    if (head->slab->flags & __GFP_NOTRACK)
> +        return NULL;
> +
> +    return (void *) address + (PAGE_SIZE << head->slab->order);
> +}
> +
> +static void *address_get_shadow(unsigned long address)
> +{
> +    struct page *page = virt_to_page(address);
> +    struct page *head = compound_head(page);
> +
> +    if (!head)
> +        return NULL;
> +
> +    if (head->flags & (1 << PG_slab))
> +        return address_get_shadow_slab(address, head);
> +
> +    return NULL;
> +}
> +
> +static int
'static bool'?
> +test(void *shadow, unsigned int size)
> +{
> +    switch (size) {
> +    case 8:
> +        return *(uint8_t *) shadow == 0xff;
> +    case 16:
> +        return *(uint16_t *) shadow == 0xffff;
> +    case 32:
> +        return *(uint32_t *) shadow == 0xffffffff;
> +    }
> +
> +    BUG();
> +    return 0;
'return false;'?
> +}
> +
<snip>

cu
Richard Knutsson

