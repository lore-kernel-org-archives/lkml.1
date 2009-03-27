Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZC0K4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZC0K4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZC0K4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:56:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:12073 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbZC0K4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bBTQUDByRt4Babpitavlff+ytq3FvClgoTRyH5cDm9hZzlZyhggnkvAcNYw5+J0VJz
         7a4dBzaQ5WUU5BWPdN1hFjS0oZFcID8kg7zbwmRXUdHNpJSujc+00vFV2iVEqsEZLz1d
         J1iRpgsqdI0KMFAwmD0aDxP1uHJYO4nwT7l+U=
MIME-Version: 1.0
In-Reply-To: <1238143759.7808.2885.camel@twins>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
	 <1238143759.7808.2885.camel@twins>
Date: Fri, 27 Mar 2009 19:56:41 +0900
Message-ID: <28c262360903270356x6a9fc929m96941de8f8201fb0@mail.gmail.com>
Subject: Re: Question about PRIVATE_FUTEX
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, lkml <linux-kernel@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Perter.
Thanks for joining this thread.

My concern is page reclaimer can reclaim the user page which have
futex between get_fuex_key and get_futex_value_locked.

On Fri, Mar 27, 2009 at 5:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2009-03-27 at 11:12 +0900, Minchan Kim wrote:
>> Hi, Peter and Eric.
>>
>> I am not expert about futex.
>> I am sorry if this is dumb question.
>>
>> If we use private futex, get_futex_key don't call get_user_pages_fast
>> which pins page at page table.
>
> But also drops that page ref at the end of get_futex_key(). The whole
> and only purpose of using get_user_pages_fast() is to get at the mapping
> data without having to obtain the mmap_sem.

Thanks.
I understand. It's not only private futex.

>
>> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
>> pagefault_disable.
>>
>> Who make sure the user page is mapped at app's page table ?
>
> Nobody, all uses of get_futex_value_locked() have to deal with it
> returning -EFAULT.

Does It mean that __copy_from_user_inatomic in get_futex_value_locked
would be failed rather than sleep?
In fact, I don't make sure _copy_from_user_inatomic function's meaning.
As far as I understand, It never sleep. It just can be failed in case
of user page isn't mapped. Is right ?
Otherwise, it can be scheduled with pagefault_disable which increments
preempt_count. It is a atomic bug.
If my assume is right, it can be failed rather than sleep.
At this case, other architecture implements __copy_from_user_inatomic
with __copy_from_user which can be scheduled. It also can be bug.

Hmm, Now I am confusing.

> Most of this is legacy btw, from when futex ops were done under the
> mmap_sem. Back then we couldn't fault because that would cause mmap_sem
> recursion. Howver, now that we don't hold mmap_sem anymore we could use
> a faulting user access like get_user().
> Darren has been working on patches to clean that up, some of those are
> already merged in the -tip tree.

Thanks for good information.
It will be very desirable way to enhance kernel performance.

> HTH
>



-- 
Kinds regards,
Minchan Kim
