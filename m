Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZC0GUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZC0GUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZC0GUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:20:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:31997 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZC0GUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mHbEG8IlHdEnSS5CkuvmplHWd536LCACJHlzInoGHmWTkShLbYSj2WZSyYbHghSF21
         3SLhP6Jg7HNrlkZpyekwIoRcpc85s94SiJe+SlcRDcj9uFnTwfLyCWD9lSkM2dbKFAR4
         /o2vuBEAGDIgkP5809lARar2X+qf/Y5M1lZww=
MIME-Version: 1.0
In-Reply-To: <49CC693D.8050901@cosmosbay.com>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
	 <49CC5C7A.9070505@cosmosbay.com>
	 <28c262360903262220n7e498c5ah7ed1340887bb5a82@mail.gmail.com>
	 <49CC693D.8050901@cosmosbay.com>
Date: Fri, 27 Mar 2009 15:20:35 +0900
Message-ID: <28c262360903262320rd102645i9bef602ec16dbf63@mail.gmail.com>
Subject: Re: Question about PRIVATE_FUTEX
From: Minchan Kim <minchan.kim@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 2:50 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Minchan Kim a écrit :
>> Thanks for kind explanation.
>>
>> On Fri, Mar 27, 2009 at 1:56 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
>>> Minchan Kim a écrit :
>>>> Hi, Peter and Eric.
>>>>
>>>> I am not expert about futex.
>>>> I am sorry if this is dumb question.
>>>>
>>>> If we use private futex, get_futex_key don't call get_user_pages_fast
>>>> which pins page at page table.
>>>> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
>>>> pagefault_disable.
>>>>
>>>> Who make sure the user page is mapped at app's page table ?
>>>>
>>> Nothing makes sure user page is mapped, as we dont have to (for private futexes
>>> at least, since the 'key' is a combination of the futex virtual address (not
>>> depending on the underlying physical page) and the task mm (sort of a static
>>> offset per task)
>>> If no page is mapped, a normal error should be returned to user, since
>>> access to futex location will trigger a fault.
>>>
>>
>> I mean as follows.
>> It seems even shared futex case.
>>
>> After calling get_user_pages_fast, get_futex_key calls unlock_page and
>> put_page, too.  Then futex_wait  calls get_futex_value_locked.
>>
>> Generally, current page->count is one and nolocked.
>> I think kernel reclaimer can reclaim the page.
>>
>> Wouldn't kernel reclaim the page between get_fuex_key and
>> get_futex_value_locked ?
>> If kernel reclaimed the page, __copy_from_user_inatomic can happens
>> page fault although pagefault_disable is on.
>>
>> How do we make sure this race condition ?
>> Do I miss something ?
>>
>
> Hmmm, so your question is not about PRIVATE futexes, but shared ones.
>
> I guess if page is no more present, its not a problem since
> get_futex_value_locked() returns an error. We then take a slow
> path, calling get_user() and retrying whole futex logic.

Indeed.
I misunderstood about __copy_from_user_inatomic.
It never sleep.

> However, comment at line 1213 is misleading I guess, since
> we dont hold mmap semaphore anymore ?
>
>         * for shared futexes, we hold the mmap semaphore, so the mapping
>         * cannot have changed since we looked it up in get_futex_key.
>         */
>        ret = get_futex_value_locked(&uval, uaddr);
>
> So if page was un-mapped by another thread, and re-mapped to another physical
> page, then this thread might sleep on 'kernel futex' not anymore reachable...
>
> User error, as it is not supposed to happen in a sane program, undefined
> result...

Yes. How about removing confusing comments ?

Thanks for great explanation :)

-- 
Kinds regards,
Minchan Kim
