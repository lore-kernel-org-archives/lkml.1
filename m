Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZKDKwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZKDKwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 05:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZKDKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 05:52:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZKDKwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 05:52:11 -0500
Date: Wed, 4 Nov 2009 11:51:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add missing free_memtype if get_vm_area_caller
	failed
Message-ID: <20091104105149.GC13194@elte.hu>
References: <1257317289-21951-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257317289-21951-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Xiaotian Feng <dfeng@redhat.com> wrote:

> When __ioremap_caller goes into get_vm_area, kernel already reserved
> memtype. so if get_vm_area fails, we need to free it before return.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/mm/ioremap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 334e63c..7859f77 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -196,8 +196,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  	 * Ok, go for it..
>  	 */
>  	area = get_vm_area_caller(size, VM_IOREMAP, caller);
> -	if (!area)
> +	if (!area) {
> +		free_memtype(phys_addr, phys_addr + size);
>  		return NULL;
> +	}
>  	area->phys_addr = phys_addr;
>  	vaddr = (unsigned long) area->addr;

Nice one!

Mind structuring this fix in a bit different way please?

The main cause of this bug is the following unclean resource-teardown 
pattern in __ioremap_caller():

	area = get_vm_area_caller(size, VM_IOREMAP, caller);
	if (!area)
		return NULL;
	area->phys_addr = phys_addr;
	vaddr = (unsigned long) area->addr;

	if (kernel_map_sync_memtype(phys_addr, size, prot_val)) {
		free_memtype(phys_addr, phys_addr + size);
		free_vm_area(area);
		return NULL;
	}

	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
		free_memtype(phys_addr, phys_addr + size);
		free_vm_area(area);
		return NULL;
	}

see how repetitive it is, and how the return sequence is duplicated?

The way we do this is to add an error path to the tail of the function:

err_free_area:
	free_vm_area(area);
err_free_memtype:
	free_memtype(phys_addr, phys_addr + size);
	return NULL;

and changing the failure branches to:

	if (!area)
		goto err_free_memtype;
	...

	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
		goto err_free_area;

etc.

Ok?
	
	Ingo
