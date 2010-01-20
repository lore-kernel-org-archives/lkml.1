Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700Ab0ATQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0ATQpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147Ab0ATQph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:45:37 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:56912 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0ATQpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:45:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nsGo60N/nT2YdFVV9F44byS/UIgEfm7qTKo9VAbiyAUifA2fJfrKmw6eT8hAjgIp1i
         z5WO8Dytj4nyeM8eEbNWyfLeD3k0hXNpxaqneEv1OvkQorKjHbkB8U6TXXWSTXeeVlzV
         iKvYfICWloQcDpshDDPRhO++x1F6qgOugCbmQ=
MIME-Version: 1.0
In-Reply-To: <20100120135202.GA20937@flint.arm.linux.org.uk>
References: <20100120135202.GA20937@flint.arm.linux.org.uk>
Date: Wed, 20 Jan 2010 17:45:34 +0100
X-Google-Sender-Auth: c02152ab99937721
Message-ID: <10f740e81001200845o7a31bcb6yea475f3aabcb5476@mail.gmail.com>
Subject: Re: [CFT] MM: Pass a PTE pointer to update_mmu_cache() rather than 
	the PTE itself
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 14:52, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On VIVT ARM, when we have multiple shared mappings of the same file
> in the same MM, we need to ensure that we have coherency across all
> copies.  We do this via make_coherent() by making the pages
> uncacheable.
>
> This used to work fine, until we allowed highmem with highpte - we
> now have a page table which is mapped as required, and is not available
> for modification via update_mmu_cache().
>
> Ralf Beache suggested getting rid of the PTE value passed to
> update_mmu_cache():
>
>  On MIPS update_mmu_cache() calls __update_tlb() which walks pagetables
>  to construct a pointer to the pte again.  Passing a pte_t * is much
>  more elegant.  Maybe we might even replace the pte argument with the
>  pte_t?
>
> Ben Herrenschmidt would also like the pte pointer for PowerPC:
>
>  Passing the ptep in there is exactly what I want.  I want that
>  -instead- of the PTE value, because I have issue on some ppc cases,
>  for I$/D$ coherency, where set_pte_at() may decide to mask out the
>  _PAGE_EXEC.
>
> So, pass in the mapped page table pointer into update_mmu_cache(), and
> remove the PTE value, updating all implementations and call sites to
> suit.

> diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
> index da42ab4..74a8b6f 100644
> --- a/Documentation/cachetlb.txt
> +++ b/Documentation/cachetlb.txt
> @@ -88,12 +88,12 @@ changes occur:
>        This is used primarily during fault processing.
>
>  5) void update_mmu_cache(struct vm_area_struct *vma,
> -                        unsigned long address, pte_t pte)
> +                        unsigned long address, pte_t *ptep)
>
>        At the end of every page fault, this routine is invoked to
>        tell the architecture specific code that a translation
> -       described by "pte" now exists at virtual address "address"
> -       for address space "vma->vm_mm", in the software page tables.
> +       now exists at virtual address "address" for address space
> +       "vma->vm_mm", in the software page tables.
>
>        A port may use this information in any way it so chooses.
>        For example, it could use this event to pre-load TLB

Now the documentation no longer mentions what the 3rd parameter is used for?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
