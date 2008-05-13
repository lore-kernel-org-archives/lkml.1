Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYEMMk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYEMMk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYEMMkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:40:17 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41431 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEMMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:40:16 -0400
Message-Id: <48298C02.2080303@mxp.nes.nec.co.jp>
Date: Tue, 13 May 2008 21:39:30 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm 05/15] free swap space on swap-in/activation
References: <20080428181835.502876582@redhat.com>	 <20080428181852.620969450@redhat.com>  <4828283C.4000803@mxp.nes.nec.co.jp> <1210600296.7300.23.camel@lts-notebook>
In-Reply-To: <1210600296.7300.23.camel@lts-notebook>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/05/12 22:51 +0900, Lee Schermerhorn wrote:
> On Mon, 2008-05-12 at 20:21 +0900, Daisuke Nishimura wrote:
>> Hi.
>>
>> I have a question about the intention of this patch.
>>
>> I think all the remove_exclusive_swap_page() you have added
>> are called while the _count of the page is incremented by
>> __isolate_lru_page().
>>
>> So, IMHO, swap caches that will be freed by this patch should have
>> page counts from __isolate_lru_page() and the swap cache itself.
>>
>> They are different from, for example, those are freed by do_swap_page()
>> -> remove_exclusive_swap_page(), that is, swap caches
>> that have been just mapped and have page counts from
>> the process(only user of the page) and the swap cache itself.
>>
>> So, the intention of this patch is
>> not to free a swap space of swap cache that has already swapped in
>> and only used one process as do_swap_page() does,
>> but to free a swap space that is only used as a swap cache
>> (not used by any processes), right?
> 
> I agree.  I had noticed this when I wanted to use
> remove_exclusive_swap_page() when a page in the swap cache became
> mlocked, but I hadn't got to ask about it yet.  As you note, we hold an
> extra reference in that case.  Further more, an anonymous page, in the
> swap cache, can be shared, read-only by multiple tasks--ancestors and
> descendants.  So, I think the check could be changed to something like:
> 
> (page_count(page) - page_mapcount(page) - extra_ref) == 1  to remove, or
> '!= 1' to reject removal. 
> 
> "extra_ref" would be a new argument to remove_exclusive_swap_page() that
> would be passed as 0 in do_swap_page() and, I think, free_swap_cache()
> and swap_writepage()--current callers.  In Rik's patch and when mlocking
> a page, we'd pass extra_ref as 1 or 2 because we hold the extra ref from
> isolate_lru_page and maybe one from get_user_pages() in the mlock case.
> 
> Thoughts?
> 

I agree that the check in remove_excusive_swap_page() should be changed,
and your new check seems rational for me.

But I have one comment.

I think swap_writepage(), which is one of the current caller, should not
call remove_exclusive_swap_page() with extra_ref=0, because swap_writepage()
can be called via shrink_page_list() -> pageout(), that is, while the
page count is incremented by page isolation.
If there is a swap cache page that would be freed in current shrink_page_list()
-> pageout() -> swap_writepage() -> remove_exclusive_swap_page() sequence,
the page count of the page is 2(page isolation and swap cache).
But if you modify remove_exclusive_swap_page() and call it with extra_ref=0,
the condition isn't met.
I don't know wether swap_writepage() would be called via other sequence or not,
but it should not call remove_exclusive_swap_page() simply with extra_ref=0.


Thanks,
Daisuke Nishimura.

