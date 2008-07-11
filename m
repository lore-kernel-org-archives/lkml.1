Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYGKVlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYGKVlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYGKVkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:40:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41516 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYGKVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:40:52 -0400
Message-ID: <4877D35E.8080209@linux.vnet.ibm.com>
Date: Fri, 11 Jul 2008 16:40:46 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: SL*B: drop kmem cache argument from constructor
References: <20080710011132.GA8327@martell.zuzino.mipt.ru> <48763C60.9020805@linux.vnet.ibm.com> <20080711122228.eb40247f.akpm@linux-foundation.org>
In-Reply-To: <20080711122228.eb40247f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 10 Jul 2008 11:44:16 -0500 Jon Tollefson <kniht@linux.vnet.ibm.com> wrote:
>
>   
>> Alexey Dobriyan wrote:
>>     
>>> Kmem cache passed to constructor is only needed for constructors that are
>>> themselves multiplexeres. Nobody uses this "feature", nor does anybody uses
>>> passed kmem cache in non-trivial way, so pass only pointer to object.
>>>
>>> Non-trivial places are:
>>> 	arch/powerpc/mm/init_64.c
>>> 	arch/powerpc/mm/hugetlbpage.c
>>>   
>>>       
>> ...<snip>...
>>     
>>> --- a/arch/powerpc/mm/hugetlbpage.c
>>> +++ b/arch/powerpc/mm/hugetlbpage.c
>>> @@ -595,9 +595,9 @@ static int __init hugepage_setup_sz(char *str)
>>>  }
>>>  __setup("hugepagesz=", hugepage_setup_sz);
>>>
>>> -static void zero_ctor(struct kmem_cache *cache, void *addr)
>>> +static void zero_ctor(void *addr)
>>>  {
>>> -	memset(addr, 0, kmem_cache_size(cache));
>>> +	memset(addr, 0, HUGEPTE_TABLE_SIZE);
>>>   
>>>       
>> This isn't going to work with the multiple huge page size support.  The
>> HUGEPTE_TABLE_SIZE macro now takes a parameter with of the mmu psize
>> index to indicate the size of page.
>>
>>     
>
> hrm.  I suppose we could hold our noses and use ksize(), assuming that
> we're ready to use ksize() at this stage in the object's lifetime.
>
> Better would be to just use kmem_cache_zalloc()?
>
> --- a/arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor-fix
> +++ a/arch/powerpc/mm/hugetlbpage.c
> @@ -113,7 +113,7 @@ static inline pte_t *hugepte_offset(huge
>  static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
>  			   unsigned long address, unsigned int psize)
>  {
> -	pte_t *new = kmem_cache_alloc(huge_pgtable_cache(psize),
> +	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
>  				      GFP_KERNEL|__GFP_REPEAT);
>
>  	if (! new)
> @@ -730,11 +730,6 @@ static int __init hugepage_setup_sz(char
>  }
>  __setup("hugepagesz=", hugepage_setup_sz);
>
> -static void zero_ctor(void *addr)
> -{
> -	memset(addr, 0, HUGEPTE_TABLE_SIZE);
> -}
> -
>  static int __init hugetlbpage_init(void)
>  {
>  	unsigned int psize;
> @@ -756,7 +751,7 @@ static int __init hugetlbpage_init(void)
>  						HUGEPTE_TABLE_SIZE(psize),
>  						HUGEPTE_TABLE_SIZE(psize),
>  						0,
> -						zero_ctor);
> +						NULL);
>  			if (!huge_pgtable_cache(psize))
>  				panic("hugetlbpage_init(): could not create %s"\
>  				      "\n", HUGEPTE_CACHE_NAME(psize));
> _
>
>
> btw, Nick, what's with that dopey
>
> 	huge_pgtable_cache(psize) = kmem_cache_create(...
>
> trick?  The result of a function call is not an lvalue, and writing a
> macro which pretends to be a function and then using it in some manner
> in which a function cannot be used is seven ways silly :(
>   
That silliness came from me.
It came from my simplistic translation of the existing code to handle
multiple huge page sizes.  I would agree it would be easier to read and
more straight forward to just have the indexed array directly on the
left side instead of a macro.  I can send out a patch that makes that
change if desired.
Something such as

+#define HUGE_PGTABLE_INDEX(psize) (HUGEPTE_CACHE_NUM + psize - 1)

-huge_pgtable_cache(psize) = kmem_cache_create(...
+pgtable_cache[HUGE_PGTABLE_INDEX(psize)] = kmem_cache_create(...


or if there is a more accepted way of handling this situation I can
amend it differently.

Jon

