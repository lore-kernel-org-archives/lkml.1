Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbZAHX1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbZAHX1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZAHX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:26:53 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:10043 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZAHX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vLGK+JxaLGmBwZav5nez61PEcfkfnKsu+TzEIvIKM/n7qsqPZ9GrFGEzgM51rsU640
         Mcnd9SJzHSRrZq2fs4+p+fWJqbdLpCKox8+P+o/Adlo5IFtu7/kRSa/wIWLIiTezUorl
         ZZ/633dDgZTi9rNnP3WN0mzirr9QFdyqPScJ4=
Message-ID: <49668BB7.8070607@gmail.com>
Date: Thu, 08 Jan 2009 15:26:47 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: torvalds@linux-foundation.org, Pekka Paalanen <pq@iki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	<20090108221753.78648cd6@daedalus.pq.iki.fi>	<20090108125317.648397d2@infradead.org>	<49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org>
In-Reply-To: <20090108143127.437c15de@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 08 Jan 2009 14:20:38 -0800
> "Justin P. Mattock" <justinmattock@gmail.com> wrote:
>
>   
>> Arjan van de Ven wrote:
>>     
>>>>> Additional async_synchronize_full() helps and box boot to the end.
>>>>>       
>>>>>           
>>> Hi Linus,
>>>
>>> can you add the patch below to your tree? This makes the
>>> async_synchronize_full() a real absolute async barrier, rather than
>>> just synchronizing the work scheduled upto the starting point.
>>> It's a bit too much for some cases (so later on I might introduce
>>> the softer synchronization again) but it solves some real problems
>>> for people so this should go into -rc1 please...
>>>
>>> >From ca1827b142e41b54c612026b3c0b5d239f21a715 Mon Sep 17 00:00:00
>>>       
>>>> 2001
>>>>         
>>> From: Arjan van de Ven <arjan@linux.intel.com>
>>> Date: Thu, 8 Jan 2009 12:35:11 -0800
>>> Subject: [PATCH] async: make async_synchronize_full() more
>>> serializing
>>>
>>> turns out that there are real problems with allowing async
>>> tasks that are scheduled from async tasks to run after
>>> the async_synchronize_full() returns.
>>>
>>> This patch makes the _full more strict and a complete
>>> synchronization. Later I might need to add back a lighter
>>> form of synchronization for other uses.. but not right now.
>>>
>>> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>>> ---
>>>  kernel/async.c |    4 +++-
>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/async.c b/kernel/async.c
>>> index 9737338..64cc916 100644
>>> --- a/kernel/async.c
>>> +++ b/kernel/async.c
>>> @@ -206,7 +206,9 @@ EXPORT_SYMBOL_GPL(async_schedule_special);
>>>  
>>>  void async_synchronize_full(void)
>>>  {
>>> -	async_synchronize_cookie(next_cookie);
>>> +	do {
>>> +		async_synchronize_cookie(next_cookie);
>>> +	} while (!list_empty(&async_running)
>>> || !list_empty(&async_pending)); }
>>>  EXPORT_SYMBOL_GPL(async_synchronize_full);
>>>  
>>>   
>>>       
>> I have to say that ohci/firescope is nice
>> poof right up: dmesg shows up:
>> attach is the results.
>> unfortunantly nothing different than
>> what the boot screen shows.
>>     
>
> just to make clear: this is with the patch right?
> because if not... try that..
>
>   
this is without,
I'll have to give that patch a try.

regards;

Justin P. Mattock
