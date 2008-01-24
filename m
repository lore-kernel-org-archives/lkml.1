Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYAXA0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYAXA0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYAXA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:26:34 -0500
Received: from gw.goop.org ([64.81.55.164]:56393 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYAXA0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:26:33 -0500
Message-ID: <4797DB37.5040507@goop.org>
Date: Wed, 23 Jan 2008 16:26:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick>
In-Reply-To: <1201133916.16972.124.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2008-01-23 at 16:05 -0800, Jeremy Fitzhardinge wrote:
>   
>> ===================================================================
>> --- a/arch/x86/mm/fault_32.c
>> +++ b/arch/x86/mm/fault_32.c
>> @@ -290,6 +290,53 @@ static int is_errata93(struct pt_regs *r
>>  
>>
>>  /*
>> + * Handle a spurious fault caused by a stale TLB entry.  This allows
>> + * us to lazily refresh the TLB when increasing the permissions of a
>> + * kernel page (RO -> RW or NX -> X).  Doing it eagerly is very
>> + * expensive since that implies doing a full cross-processor TLB
>> + * flush, even if no stale TLB entries exist on other processors.
>> + * There are no security implications to leaving a stale TLB when
>> + * increasing the permissions on a page.
>> + */
>> +static int spurious_fault(unsigned long address,
>> +			  unsigned long error_code)
>> +{
>> +	pgd_t *pgd;
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +
>> +	/* Reserved-bit violation or user access to kernel space? */
>> +	if (error_code & (PF_USER | PF_RSVD))
>> +		return 0;
>> +
>> +	pgd = init_mm.pgd + pgd_index(address);
>> +	if (!pgd_present(*pgd))
>> +		return 0;
>> +
>> +	pud = pud_offset(pgd, address);
>> +	if (!pud_present(*pud))
>> +		return 0;
>> +
>> +	pmd = pmd_offset(pud, address);
>> +	if (!pmd_present(*pmd))
>> +		return 0;
>> +
>> +	pte = pte_offset_kernel(pmd, address);
>> +	if (!pte_present(*pte))
>> +		return 0;
>> +	if ((error_code & 0x02) && !pte_write(*pte))
>> +		return 0;
>>     
>
> 	if ((error_code & PF_WRITE) && !pte_write(*pte))
> 		return 0;
>   

Oops, thanks.  Overlooked that one.

> How about dropping the #if and rely on the !pte_exec() test always
> being false when _PAGE_NX = 0?  The compiler should just trim this
> all away.
>
> from pgtable.h:
>
> static inline int pte_exec(pte_t pte)           { return !(pte_val(pte)
> & _PAGE_NX); }
>   

Thanks for reminding me; I thought of this the other day, but forgot to 
do it.  Will post an updated patch shortly.

    J
