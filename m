Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbZCQHka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbZCQHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZCQHkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:40:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23356 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZCQHkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:40:16 -0400
Message-Id: <49BF621E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 17 Mar 2009 07:41:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: create a non-zero sized bm_pte only when
	 needed
References: <49B91826.76E4.0078.0@novell.com> <49BED400.6040605@goop.org>
In-Reply-To: <49BED400.6040605@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.03.09 23:34 >>>
>Jan Beulich wrote:
>> Impact: kernel image size reduction
>>
>> Since in most configurations the pmd page needed maps the same range of
>> virtual addresses which is also mapped by the earlier inserted one for
>> covering FIX_DBGP_BASE, that page (and its insertion in the page
>> tables) can be avoided altogether by detecting the condition at compile
>> time.
>>   
>
>Does this depend on CONFIG_EARLY_PRINTK_DBGP being set?  And what's so 
>special about FIX_DBGP_BASE, that we should hard-code it in here?  Is it 
>just that its the first non-arch-dependent fixmap slot?  Or something 
>else?  Will it break if we move FIX_DBGP_BASE?

No, it is indeed tied to that one fixmap entry, as this is what the 'early
initialization of the fixmap area' (commented such in head_32.S, and
uncommented equivalent exists in head_64.S) is about, albeit without
explicit tying to the respective fixmap entry (which makes this code
even more fragile than my change might seem).

>Is the space saving here just the 1 page for bm_pte[]?

Yes.

>Wouldn't we do as well by making it initdata?

No, because the table may be retained past boot.

>I'm picking on this change because its breaking Xen PV booting...

Hmm, I don't think there's anything that should make it break. Any
details?

>>  static __initdata int after_paging_init;
>> -static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
>> +#define __FIXADDR_TOP (-PAGE_SIZE)
>>   
>
>Will this break in a 32-bit PV kernel where FIXADDR_TOP is shifted?

Not as long as the shifting happens in 2Mb steps (and when I wrote the
patch [which was a while back] I checked that there are other assumptions
about the shift only happening in 2Mb increments).

>This seriously needs a good inline comment.

Why only is it always me who is asked for extensive inline comments, when
other code in the same area is happily being accepted without even being
self-commenting (which, if you read the construct carefully, I believe my
change is)? As noted above, the dependency on which page table slot
need early initialization is completely hidden behind hardcoded literal numbers
at least for x86-64. This is what indeed would need a comment (or better
yet, replacing of the hardcoded numbers by proper symbolics, in which
case I would think a comment would quickly become redundant).

>> @@ -505,6 +510,8 @@ static inline pmd_t * __init early_iorem
>>  
>>  static inline pte_t * __init early_ioremap_pte(unsigned long addr)
>>  {
>> +	if (!sizeof(bm_pte))
>> +		return &bm_ptep[pte_index(addr)];
>>  	return &bm_pte[pte_index(addr)];
>>   
>
>Why not just assign bm_ptep = bm_pte if we're using the array?

Could be done - I favored this approach because it results in either
the bm_pte or the bm_ptep symbol getting completely eliminated by
the compiler. But with bm_ptep being __initdata that may not be a
good tradeoff...

Jan

