Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbYBEWnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbYBEWnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762715AbYBEWmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:42:42 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:44751 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761163AbYBEWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:42:38 -0500
Date: Tue, 5 Feb 2008 14:41:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/12] GBPAGES: Add an option to disable direct mapping
 gbpages and a global variable
Message-Id: <20080205144150.32ab1069.randy.dunlap@oracle.com>
In-Reply-To: <20080201095320.4BC5B1B416F@basil.firstfloor.org>
References: <200802011053.107168490@suse.de>
	<20080201095320.4BC5B1B416F@basil.firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Feb 2008 10:53:20 +0100 (CET) Andi Kleen wrote:

> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  Documentation/x86_64/boot-options.txt |    5 +++++
>  arch/x86/mm/init_64.c                 |   16 ++++++++++++++++
>  include/asm-x86/pgtable_64.h          |    7 +++++++
>  3 files changed, 28 insertions(+)
> 
> Index: linux/arch/x86/mm/init_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_64.c
> +++ linux/arch/x86/mm/init_64.c
> @@ -53,6 +53,22 @@ static unsigned long dma_reserve __initd
>  
>  DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
>  
> +enum gbopt direct_gbpages __meminitdata = GBP_DEFAULT;
> +
> +static int __init parse_direct_gbpages(char *arg)
> +{
> +	if (!strcmp(arg, "off")) {
> +		direct_gbpages = GBP_OFF;
> +		return 0;
> +	}
> +	if (!strcmp(arg, "on")) {
> +		direct_gbpages = GBP_ON;
> +		return 0;
> +	}
> +	return -1;
> +}
> +early_param("direct_gbpages", parse_direct_gbpages);
> +
>  /*
>   * NOTE: pagetable_init alloc all the fixmap pagetables contiguous on the
>   * physical space so we can cache the place of the first one and move
> Index: linux/include/asm-x86/pgtable_64.h
> ===================================================================
> --- linux.orig/include/asm-x86/pgtable_64.h
> +++ linux/include/asm-x86/pgtable_64.h
> @@ -239,6 +239,13 @@ static inline int pud_large(pud_t pte)
>  
>  #define update_mmu_cache(vma,address,pte) do { } while (0)
>  
> +enum gbopt {
> +	GBP_OFF = -1,
> +	GBP_DEFAULT,
> +	GBP_ON
> +};
> +extern enum gbopt direct_gbpages;
> +
>  /* Encode and de-code a swap entry */
>  #define __swp_type(x)			(((x).val >> 1) & 0x3f)
>  #define __swp_offset(x)			((x).val >> 8)
> Index: linux/Documentation/x86_64/boot-options.txt
> ===================================================================
> --- linux.orig/Documentation/x86_64/boot-options.txt
> +++ linux/Documentation/x86_64/boot-options.txt
> @@ -307,3 +307,8 @@ Debugging
>  			stuck (default)
>  
>  Miscellaneous
> +
> +	direct_gbpages=off|on
> +		off: Do not use GB pages for kernel direct mapping.
> +		on: Use GB pages if hardware supports it, but some heuristic
> +		would turn them off.

s/would/could/  ?

---
~Randy
