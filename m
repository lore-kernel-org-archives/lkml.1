Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXCPL6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXCPL6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXCPL6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:58:09 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:13538 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbXCPL6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:58:07 -0400
Message-ID: <45FA8681.2030801@sw.ru>
Date: Fri, 16 Mar 2007 14:58:57 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
References: <45F7A4B3.5040005@sw.ru> <20070314153341.GA770@tv-sign.ru> <45FA7823.2040104@sw.ru> <200703161237.48014.dada1@cosmosbay.com>
In-Reply-To: <200703161237.48014.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Friday 16 March 2007 11:57, Pavel Emelianov wrote:
>> Oleg Nesterov wrote:
>>> On 03/14, Eric W. Biederman wrote:
>>>> Pavel Emelianov <xemul@sw.ru> writes:
>>>>> Hi.
>>>>>
>>>>> I'm looking at how alloc_pid() works and can't understand
>>>>> one (simple/stupid) thing.
>>>>>
>>>>> It first kmem_cache_alloc()-s a strct pid, then calls
>>>>> alloc_pidmap() and at the end it taks a global pidmap_lock()
>>>>> to add new pid to hash.
>>> We need some global lock. pidmap_lock is already here, and it is
>>> only used to protect pidmap->page allocation. Iow, it is almost
>>> unused. So it was very natural to re-use it while implementing
>>> pidrefs.
>>>
>>>>> The question is - why does alloc_pidmap() use at least
>>>>> two atomic ops and potentially loop to find a zero bit
>>>>> in pidmap? Why not call alloc_pidmap() under pidmap_lock
>>>>> and find zero pid in pidmap w/o any loops and atomics?
>>> Currently we search for zero bit lockless, why do you want
>>> to do it under spin_lock ?
>> Search isn't lockless. Look:
>>
>> while (1) {
>>    if (!test_and_set_bit(...)) {
>>        atomic_dec(&nr_free);
>>        return pid;
>>    }
>>    ...
>> }
>>
>> we use two atomic operations to find and set a bit in a map.
> 
> The finding of the zero bit is done without lock. (Search/lookup)
> 
> Then , the reservation of the found bit (test_and_set_bit) is done, and 
> decrement of nr_free. It may fail because the search was done lockless.

:\ I do understand how this algorithm works. What I don't
understand is why it is done so, if we take a global lock anyway.

> Finding a zero bit in a 4096 bytes array may consume about 6000 cycles on 
> modern hardware. Much more on SMP/NUMA machines, or on machines where 
> PAGE_SIZE is 64K instead of 4K :)
> 
> You don't want to hold pidmad_lock for so long period.

OK, thanks. That's explanations looks good.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

