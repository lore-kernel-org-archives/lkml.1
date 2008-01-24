Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYAXASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYAXASb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYAXASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:18:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:22273 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYAXASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nc10ilVtGYexrAxjxqwizHLA22r8RF3WA0Ujg9PPemx1PoE4R6mUeqzVybeJlKLxkRdTGpN/hMcSm9gDgDcaGKtudrdKRNPwXb60tMInG2qCf4axBBFxBucEdINMnZ57fvSsNvEpfV2dn9hzlaevNLHybcs1W9m5vFTjFZEQfUs=
Subject: Re: [PATCH] x86: ignore spurious faults
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <4797D64D.1060105@goop.org>
References: <4797D64D.1060105@goop.org>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 16:18:36 -0800
Message-Id: <1201133916.16972.124.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 16:05 -0800, Jeremy Fitzhardinge wrote:
> ===================================================================
> --- a/arch/x86/mm/fault_32.c
> +++ b/arch/x86/mm/fault_32.c
> @@ -290,6 +290,53 @@ static int is_errata93(struct pt_regs *r
>  
> 
>  /*
> + * Handle a spurious fault caused by a stale TLB entry.  This allows
> + * us to lazily refresh the TLB when increasing the permissions of a
> + * kernel page (RO -> RW or NX -> X).  Doing it eagerly is very
> + * expensive since that implies doing a full cross-processor TLB
> + * flush, even if no stale TLB entries exist on other processors.
> + * There are no security implications to leaving a stale TLB when
> + * increasing the permissions on a page.
> + */
> +static int spurious_fault(unsigned long address,
> +			  unsigned long error_code)
> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	/* Reserved-bit violation or user access to kernel space? */
> +	if (error_code & (PF_USER | PF_RSVD))
> +		return 0;
> +
> +	pgd = init_mm.pgd + pgd_index(address);
> +	if (!pgd_present(*pgd))
> +		return 0;
> +
> +	pud = pud_offset(pgd, address);
> +	if (!pud_present(*pud))
> +		return 0;
> +
> +	pmd = pmd_offset(pud, address);
> +	if (!pmd_present(*pmd))
> +		return 0;
> +
> +	pte = pte_offset_kernel(pmd, address);
> +	if (!pte_present(*pte))
> +		return 0;
> +	if ((error_code & 0x02) && !pte_write(*pte))
> +		return 0;

	if ((error_code & PF_WRITE) && !pte_write(*pte))
		return 0;

> +
> +#if _PAGE_NX
> +	if ((error_code & PF_INSTR) && !pte_exec(*pte))
> +		return 0;
> +#endif
> +

How about dropping the #if and rely on the !pte_exec() test always
being false when _PAGE_NX = 0?  The compiler should just trim this
all away.

from pgtable.h:

static inline int pte_exec(pte_t pte)           { return !(pte_val(pte)
& _PAGE_NX); }

Cheers,

Harvey

