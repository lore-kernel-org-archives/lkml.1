Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZA2J1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZA2J1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2J04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:26:56 -0500
Received: from gw.goop.org ([64.81.55.164]:51117 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZA2J0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:26:55 -0500
Message-ID: <4981765D.8040508@goop.org>
Date: Thu, 29 Jan 2009 01:26:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 2 of 7] x86/pvops: add a paravirt_ident functions to allow
 special patching
References: <patchbomb.1233182100@abulafia.goop.org> <79ff4280c71ffeba69d2.1233182102@abulafia.goop.org> <200901291835.49251.rusty@rustcorp.com.au>
In-Reply-To: <200901291835.49251.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 29 January 2009 09:05:02 Jeremy Fitzhardinge wrote:
>   
>>  void _paravirt_nop(void);
>> +u32 _paravirt_ident_32(u32);
>> +u64 _paravirt_ident_64(u64);
>> +
>>  #define paravirt_nop	((void *)_paravirt_nop)
>>     
>
> So, we used a void * cast for the paravirt_nop case, but you decided to use explicit types for the ident cases?
>   

Yes.  Partly because any nop function is going to be basically 
equivalent to (void (*)(void)), but the concrete types for the ident 
function will vary (pointer, scalar, structure, etc).

>>  	if (opfunc == NULL)
>>  		/* If there's no function, patch it with a ud2a (BUG) */
>>  		ret = paravirt_patch_insns(insnbuf, len, ud2a, ud2a+sizeof(ud2a));
>> -	else if (opfunc == paravirt_nop)
>> +	else if (opfunc == _paravirt_nop)
>>  		/* If the operation is a nop, then nop the callsite */
>>  		ret = paravirt_patch_nop();
>>     
>
> Gratuitous change?
>   

To make it consistent with the newly added lines following.  And its 
slightly more correct.

>   
>> +typedef pte_t make_pte_t(pteval_t);
>> +typedef pmd_t make_pmd_t(pmdval_t);
>> +typedef pud_t make_pud_t(pudval_t);
>> +typedef pgd_t make_pgd_t(pgdval_t);
>> +
>> +typedef pteval_t pte_val_t(pte_t);
>> +typedef pmdval_t pmd_val_t(pmd_t);
>> +typedef pudval_t pud_val_t(pud_t);
>> +typedef pgdval_t pgd_val_t(pgd_t);
>> +
>> +
>> +#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
>> +/* 32-bit pagetable entries */
>> +#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_32
>> +#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_32
>> +
>> +#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_32
>> +#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_32
>> +
>> +#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_32
>> +#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_32
>> +
>> +#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_32
>> +#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_32
>> +#else
>> +/* 64-bit pagetable entries */
>> +#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_64
>> +#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_64
>> +
>> +#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_64
>> +#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_64
>> +
>> +#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_64
>> +#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_64
>> +
>> +#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_64
>> +#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_64
>> +#endif
>>     
>
> I think I prefer:
>
> /* make_pte etc and pgd_val etc are identity functions. */
> #define paravirt_native_page_op \
> 	(sizeof(pte_t) == sizeof(u64) ? paravirt_ident_64 : paravirt_ident_32)
>
> Then use that everywhere rather than these defines?
>   

They disappear later in the series anyway.

> But it's a minor point; the code seems perfectly sound.
>   

Great, thanks for reviewing.

    J
