Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYBOUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYBOUll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBOUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:41:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:41567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYBOUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wdxXX8/E2EQIM7UcsL7qJqqjAUHpDKXxtAYins3tOCcU+3YWYoTfviehxq75R8Qf1p1cq/BOw0GX//Uo89ku6wIHTuFuIG/uwAgU6Y4Mqd9GgRJS2RnM5G1yyth1/c2F1Xp03cyL1P0ae+SVB3RWt+sXoXmNqsemNdC6r4Jm1VU=
Message-ID: <6101e8c40802151241o6c1e29a9y5c3e591a227e4eb2@mail.gmail.com>
Date: Fri, 15 Feb 2008 21:41:28 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 1/3] x86_64: CPA, fix cache attribute inconsistency bug, v2.6.22 backport
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080215195821.GA15432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215195508.GA12405@elte.hu> <20080215195821.GA15432@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,

thx add to http://repo.or.cz/w/linux-2.6.22.y-op.git testing ;)


On 2/15/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> fix CPA cache attribute bug in v2.6.23. When phys_base is nonzero
> (when CONFIG_RELOCATABLE=y) then change_page_attr_addr() miscalculates
> the secondary alias address by -14 MB (depending on the configured
> offset).
>
> The default 64-bit kernels of Fedora and Ubuntu are affected:
>
> $ grep RELOCA /boot/config-2.6.23.9-85.fc8
> CONFIG_RELOCATABLE=y
>
> $ grep RELOC /boot/config-2.6.22-14-generic
> CONFIG_RELOCATABLE=y
>
> and probably on many other distros as well.
>
> the bug affects all pages in the first 40 MB of physical RAM that
> are allocated by some subsystem that does ioremap_nocache() on them:
>
> if (__pa(address) < KERNEL_TEXT_SIZE) {
>
> Hence we might leave page table entries with inconsistent cache
> attributes around (pages mapped at both UnCacheable and Write-Back),
> and we can also set the wrong kernel text pages to UnCacheable.
>
> the effects of this bug can be random slowdowns and other misbehavior.
> If for example AGP allocates its aperture pages into the first 40 MB
> of physical RAM, then the -14 MB bug might mark random kernel texto
> pages as uncacheable, slowing down a random portion of the 64-bit
> kernel until the AGP driver is unloaded.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> arch/x86_64/mm/pageattr.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-tmp/arch/x86_64/mm/pageattr.c
> ===================================================================
> --- linux-tmp.orig/arch/x86_64/mm/pageattr.c
> +++ linux-tmp/arch/x86_64/mm/pageattr.c
> @@ -204,7 +204,7 @@ int change_page_attr_addr(unsigned long
> if (__pa(address) < KERNEL_TEXT_SIZE) {
> unsigned long addr2;
> pgprot_t prot2;
> -	addr2 = __START_KERNEL_map + __pa(address);
> +	addr2 = __START_KERNEL_map + __pa(address) - phys_base;
> /* Make sure the kernel mappings stay executable */
> prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
> err = __change_page_attr(addr2, pfn, prot2,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
--
Thanks,
Oliver
