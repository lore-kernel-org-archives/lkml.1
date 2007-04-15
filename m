Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXDOJAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXDOJAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXDOJAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:00:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58284 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXDOJAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:00:31 -0400
Date: Sun, 15 Apr 2007 11:01:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALPHA: support graphics on non-zero PCI domains (take 2)
Message-ID: <20070415090115.GA18103@uranus.ravnborg.org>
References: <20070415111937.A12310@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415111937.A12310@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_VGA_HOSE
>  	/*
> -	 * Adjust the addr.
> +	 * Adjust the address and hose, if necessary.
>  	 */ 
> -#ifdef CONFIG_VGA_HOSE
> -	if (pci_vga_hose && __titan_is_mem_vga(addr)) {
> +	if (pci_vga_hose && __is_mem_vga(addr)) {
>  		h = pci_vga_hose->index;

This code snippet is used in two places.
A better approach would be to define a small inline function
that is empty in the NON HOSe case to avod the ifdefs in the
code logic.


> +tsunami_ioremap(unsigned long addr, unsigned long size)
> +{
> +	FIXUP_MEMADDR_VGA(addr);
> +	return (void __iomem *)(addr + TSUNAMI_MEM_BIAS);
> +}
> +
> +#ifndef CONFIG_ALPHA_GENERIC
> +EXPORT_SYMBOL(tsunami_ioportmap);
> +EXPORT_SYMBOL(tsunami_ioremap);
> +#endif

It looks strange that the function is always defined but conditionally exported.
Also usual style is to place EXPORT right after closing brace of function -
(with no empty lines in-between).

> +
> +static void __init
> +tsunami_init_vga_hose(void)
> +{
> +#ifdef CONFIG_VGA_HOSE
> +	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
> +
> +	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
> +		struct pci_controller *hose;
> +		int h = (pu64[30] >> 24) & 0xff;	/* console hose # */
> +
> +		/*
> +		 * Our hose numbering does NOT match the console's, so find
> +		 * the right one...
> +		 */
> +		for (hose = hose_head; hose; hose = hose->next) {
> +			if (hose->index == h) break;
> +		}
> +
> +		if (hose) {
> +			printk("Console graphics on hose %d\n", h);
> +			pci_vga_hose = hose;
> +		}
> +	}
> +#endif /* CONFIG_VGA_HOSE */
> +}

Again - avoid ifdef in code.
Surround whole function with ifdef and then provide an empty inline for the NON hose case.

> +/* console.c */
> +#ifdef CONFIG_VGA_HOSE
> +extern void locate_and_init_vga(void *(*)(void *, void *));
> +#else
> +#define locate_and_init_vga()	do { } while (0)
> +#endif
static inline would give you a limited type check of arguments.

>  
> +config VGA_HOSE
> +	bool "VGA on arbitrary hose"
> +	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL || ALPHA_TSUNAMI
> +	default y

Please always include help entry for visible symbols.
You have it mostly written up in the changelog so it should be trivial to add.

	Sam
