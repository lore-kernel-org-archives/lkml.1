Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbZC0FU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbZC0FU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbZC0FUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:20:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:15774 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZC0FUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ISa1tlXQuY79gsLpvSzQ4ngxSnxwayWnqOuLz4bg3tLQixgu95q+ChzP49N/SB4B3b
         DfKdXkdd6/0U5JktADPWqkUpREoeiJMxBOa0pVWa2baibf/x5grWSkTty6rzM3R5KWwr
         WDTj5+0uprtxFGJ976Br+rS9+2/O/OTdwmGHY=
MIME-Version: 1.0
In-Reply-To: <49CC5C7A.9070505@cosmosbay.com>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
	 <49CC5C7A.9070505@cosmosbay.com>
Date: Fri, 27 Mar 2009 14:20:12 +0900
Message-ID: <28c262360903262220n7e498c5ah7ed1340887bb5a82@mail.gmail.com>
Subject: Re: Question about PRIVATE_FUTEX
From: Minchan Kim <minchan.kim@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for kind explanation.

On Fri, Mar 27, 2009 at 1:56 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Minchan Kim a écrit :
>> Hi, Peter and Eric.
>>
>> I am not expert about futex.
>> I am sorry if this is dumb question.
>>
>> If we use private futex, get_futex_key don't call get_user_pages_fast
>> which pins page at page table.
>> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
>> pagefault_disable.
>>
>> Who make sure the user page is mapped at app's page table ?
>>
>
> Nothing makes sure user page is mapped, as we dont have to (for private futexes
> at least, since the 'key' is a combination of the futex virtual address (not
> depending on the underlying physical page) and the task mm (sort of a static
> offset per task)
> If no page is mapped, a normal error should be returned to user, since
> access to futex location will trigger a fault.
>

I mean as follows.
It seems even shared futex case.

After calling get_user_pages_fast, get_futex_key calls unlock_page and
put_page, too.  Then futex_wait  calls get_futex_value_locked.

Generally, current page->count is one and nolocked.
I think kernel reclaimer can reclaim the page.

Wouldn't kernel reclaim the page between get_fuex_key and
get_futex_value_locked ?
If kernel reclaimed the page, __copy_from_user_inatomic can happens
page fault although pagefault_disable is on.

How do we make sure this race condition ?
Do I miss something ?

-- 
Kinds regards,
Minchan Kim
