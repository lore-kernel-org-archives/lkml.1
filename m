Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZC0Fv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZC0Fv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZC0FvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:51:18 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:58600 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZC0FvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:51:17 -0400
Message-ID: <49CC693D.8050901@cosmosbay.com>
Date: Fri, 27 Mar 2009 06:50:53 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question about PRIVATE_FUTEX
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>	 <49CC5C7A.9070505@cosmosbay.com> <28c262360903262220n7e498c5ah7ed1340887bb5a82@mail.gmail.com>
In-Reply-To: <28c262360903262220n7e498c5ah7ed1340887bb5a82@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 27 Mar 2009 06:50:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim a écrit :
> Thanks for kind explanation.
> 
> On Fri, Mar 27, 2009 at 1:56 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> Minchan Kim a écrit :
>>> Hi, Peter and Eric.
>>>
>>> I am not expert about futex.
>>> I am sorry if this is dumb question.
>>>
>>> If we use private futex, get_futex_key don't call get_user_pages_fast
>>> which pins page at page table.
>>> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
>>> pagefault_disable.
>>>
>>> Who make sure the user page is mapped at app's page table ?
>>>
>> Nothing makes sure user page is mapped, as we dont have to (for private futexes
>> at least, since the 'key' is a combination of the futex virtual address (not
>> depending on the underlying physical page) and the task mm (sort of a static
>> offset per task)
>> If no page is mapped, a normal error should be returned to user, since
>> access to futex location will trigger a fault.
>>
> 
> I mean as follows.
> It seems even shared futex case.
> 
> After calling get_user_pages_fast, get_futex_key calls unlock_page and
> put_page, too.  Then futex_wait  calls get_futex_value_locked.
> 
> Generally, current page->count is one and nolocked.
> I think kernel reclaimer can reclaim the page.
> 
> Wouldn't kernel reclaim the page between get_fuex_key and
> get_futex_value_locked ?
> If kernel reclaimed the page, __copy_from_user_inatomic can happens
> page fault although pagefault_disable is on.
> 
> How do we make sure this race condition ?
> Do I miss something ?
> 

Hmmm, so your question is not about PRIVATE futexes, but shared ones.

I guess if page is no more present, its not a problem since
get_futex_value_locked() returns an error. We then take a slow
path, calling get_user() and retrying whole futex logic.

However, comment at line 1213 is misleading I guess, since
we dont hold mmap semaphore anymore ?

         * for shared futexes, we hold the mmap semaphore, so the mapping
         * cannot have changed since we looked it up in get_futex_key.
         */
        ret = get_futex_value_locked(&uval, uaddr);

So if page was un-mapped by another thread, and re-mapped to another physical
page, then this thread might sleep on 'kernel futex' not anymore reachable...

User error, as it is not supposed to happen in a sane program, undefined
result...



