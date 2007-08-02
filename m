Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbXHBRok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbXHBRok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXHBRod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:44:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:14143 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbXHBRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JGRafj1WvcFJPwZ5KacAKbQsl/95/1ez8M3TVOxBWMREwboem4gPwEOcq8Z/XuNV0IhiEk9cQpsTkWKUksTerXkuhLL6areX5us5ncZOy2rHOYBj6HUHDnBryervSeyE1LHoiQqwcL+4+Ect+CTj1Wh29ieVND8Pn3wmZUeqg/g=
Message-ID: <64bb37e0708021044v5a1bd945r236f5f6c5f67e0f8@mail.gmail.com>
Date: Thu, 2 Aug 2007 19:44:30 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: 2.6.23-rc1-mm2
Cc: "Mel Gorman" <mel@skynet.ie>, "Andrew Morton" <akpm@linux-foundation.org>,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20070802140159.GA30328@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <12639.1186000208@turing-police.cc.vt.edu>
	 <20070801134055.7862b95e.akpm@linux-foundation.org>
	 <64bb37e0708011352q33053acdxa753cd198fb4233c@mail.gmail.com>
	 <20070801234059.GA29224@skynet.ie>
	 <20070802140159.GA30328@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Andy Whitcroft <apw@shadowen.org> wrote:
> vmemmap x86_64: ensure end of section memmap is initialised
>
> Similar to the generic initialisers, the x86_64 vmemmap
> initialisation may incorrectly skip the last page of a section if
> the section start is not aligned to the page.
>
> Where we have a section spanning the end of a PMD we will check the
> start of the section at A populating it.  We will then move on 1
> PMD page to C and find ourselves beyond the end of the section which
> ends at B we will complete without checking the second PMD page.
>
>         |     PMD     |     PMD     |
>                  | SECTION |
>                  A         B   C
>
> We should round ourselves to the end of the PMD as we iterate.
>
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
>  arch/x86_64/mm/init.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
> index ac49df0..5d1ed03 100644
> --- a/arch/x86_64/mm/init.c
> +++ b/arch/x86_64/mm/init.c
> @@ -792,9 +792,10 @@ int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
>                                                 unsigned long end, int node)
>  {
>         pmd_t *pmd;
> +       unsigned long next;
>
> -       for (pmd = pmd_offset(pud, addr); addr < end;
> -                                               pmd++, addr += PMD_SIZE)
> +       for (pmd = pmd_offset(pud, addr); addr < end; pmd++, addr = next) {
> +               next = pmd_addr_end(addr, end);
>                 if (pmd_none(*pmd)) {
>                         pte_t entry;
>                         void *p = vmemmap_alloc_block(PMD_SIZE, node);
> @@ -808,8 +809,8 @@ int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
>                         printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
>                                 addr, addr + PMD_SIZE - 1, p, node);
>                 } else
> -                       vmemmap_verify((pte_t *)pmd, node,
> -                                               pmd_addr_end(addr, end), end);
> +                       vmemmap_verify((pte_t *)pmd, node, next, end);
> +       }
>         return 0;
>  }
>  #endif
>

That patch applied to 2.6.23-rc1-mm2 boots.

But I still the the MP-BIOS bug, now with an additional Call Trace:
[   27.034907] ACPI: Core revision 20070126
[   27.082090] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   27.132617] WARNING: at kernel/irq/resend.c:69 check_irq_resend()
[   27.150837]
[   27.150837] Call Trace:
[   27.162621]  [<ffffffff80261c4c>] check_irq_resend+0xbc/0xd0
[   27.179558]  [<ffffffff802617c0>] enable_irq+0xf0/0x100
[   27.195177]  [<ffffffff807c6984>] setup_IO_APIC+0x6c4/0x9a0
[   27.211833]  [<ffffffff80234e74>] set_cpus_allowed+0x64/0xc0
[   27.228749]  [<ffffffff807c4e14>] smp_prepare_cpus+0x434/0x460
[   27.246183]  [<ffffffff807bc627>] kernel_init+0x67/0x350
[   27.262062]  [<ffffffff8020cac8>] child_rip+0xa/0x12
[   27.276928]  [<ffffffff803d4f80>] acpi_ds_init_one_object+0x0/0x7c
[   27.295425]  [<ffffffff807bc5c0>] kernel_init+0x0/0x350
[   27.311043]  [<ffffffff8020cabe>] child_rip+0x0/0x12
[   27.325881]
[   27.463199] Using local APIC timer interrupts.
[   27.514874] result 12500129
[   27.523240] Detected 12.500 MHz APIC timer.

It does no longer seem to matter if it was a warm or cold start.

Otherwise the system seems to be working normal.

Torsten
