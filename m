Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYF0Bzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYF0Bzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 21:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYF0Bzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 21:55:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:50489 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYF0Bzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 21:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SqF3g+o5FbEtiNjZgTw6JxrpQeNLSunjn2IyReV3r9PFaxYENFMj4Uaeg0vX1854Ii
         jWlESDvTLJIMNRxHOLkzk5eXz3D1w4faZyT0XzFDjJadesYlCcUi7jhvPML16cYKrbid
         0clfrdGPxrlxRBliLCZOs4pf+Uop81XBJQSzs=
Message-ID: <a8e1da0806261855l172a1e55k8bad10aa62e92521@mail.gmail.com>
Date: Fri, 27 Jun 2008 09:55:33 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <20080626121430.GK29619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
	 <20080616080131.GC25632@elte.hu>
	 <a8e1da0806232249s36eb90c7la517a40ccfe839ea@mail.gmail.com>
	 <20080626121430.GK29619@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> I do some test about this last weekend, there's some questions, could
>> you help to fix it?
>>
>> 1. MAXMEM :
>>  (-__PAGE_OFFSET - __VMALLOC_RESERVE).
>> The space after VMALLOC_END is included as well, seting it to
>> (VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE), is it right?
>>
>> 2. VMALLOC_OFFSET is not considered in __VMALLOC_RESERVE
>> Should fixed by adding VMALLOC_OFFSET to it.
>>
>> 3. VMALLOC_START :
>>  (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) & ~(VMALLOC_OFFSET - 1))
>> So it's not always 8M, bigger than 8M possible.
>> Set it to ((unsigned long)high_memory + VMALLOC_OFFSET), is it right?
>>
>> Attached the proposed patch. please give some advice.
>
> i've ported it to tip/master, see the patch below. Yinghai, what do you
> think about this change?

Thanks. If there's no objections please add my signed-off line

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

>
>        Ingo
>
> ---
>  arch/x86/mm/pgtable_32.c     |    3 ++-
>  include/asm-x86/page_32.h    |    1 -
>  include/asm-x86/pgtable_32.h |    5 +++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
>
> Index: tip/arch/x86/mm/pgtable_32.c
> ===================================================================
> --- tip.orig/arch/x86/mm/pgtable_32.c
> +++ tip/arch/x86/mm/pgtable_32.c
> @@ -171,7 +171,8 @@ static int __init parse_vmalloc(char *ar
>        if (!arg)
>                return -EINVAL;
>
> -       __VMALLOC_RESERVE = memparse(arg, &arg);
> +       /* Add VMALLOC_OFFSET to the parsed value due to vm area guard hole*/
> +       __VMALLOC_RESERVE = memparse(arg, &arg) + VMALLOC_OFFSET;
>        return 0;
>  }
>  early_param("vmalloc", parse_vmalloc);
> Index: tip/include/asm-x86/page_32.h
> ===================================================================
> --- tip.orig/include/asm-x86/page_32.h
> +++ tip/include/asm-x86/page_32.h
> @@ -95,7 +95,6 @@ extern unsigned int __VMALLOC_RESERVE;
>  extern int sysctl_legacy_va_layout;
>
>  #define VMALLOC_RESERVE                ((unsigned long)__VMALLOC_RESERVE)
> -#define MAXMEM                 (-__PAGE_OFFSET - __VMALLOC_RESERVE)
>
>  extern void find_low_pfn_range(void);
>  extern unsigned long init_memory_mapping(unsigned long start,
> Index: tip/include/asm-x86/pgtable_32.h
> ===================================================================
> --- tip.orig/include/asm-x86/pgtable_32.h
> +++ tip/include/asm-x86/pgtable_32.h
> @@ -56,8 +56,7 @@ void paging_init(void);
>  * area for the same reason. ;)
>  */
>  #define VMALLOC_OFFSET (8 * 1024 * 1024)
> -#define VMALLOC_START  (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
> -                        & ~(VMALLOC_OFFSET - 1))
> +#define VMALLOC_START  ((unsigned long)high_memory + VMALLOC_OFFSET)
>  #ifdef CONFIG_X86_PAE
>  #define LAST_PKMAP 512
>  #else
> @@ -73,6 +72,8 @@ void paging_init(void);
>  # define VMALLOC_END   (FIXADDR_START - 2 * PAGE_SIZE)
>  #endif
>
> +#define MAXMEM (VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
> +
>  /*
>  * Define this if things work differently on an i386 and an i486:
>  * it will (on an i486) warn about kernel memory accesses that are
>
>



-- 
Regards
dave
