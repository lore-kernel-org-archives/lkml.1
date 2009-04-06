Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZDFUQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZDFUQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZDFUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:16:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38861 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZDFUQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:16:36 -0400
Message-ID: <49DA6324.9080801@linux.vnet.ibm.com>
Date: Mon, 06 Apr 2009 13:16:36 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins> <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins> <1239016035.798.4254.camel@twins>  <49DA4FA0.6090902@linux.vnet.ibm.com> <1239044818.798.4775.camel@twins>
In-Reply-To: <1239044818.798.4775.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-04-06 at 11:53 -0700, Corey Ashford wrote:
>> Peter Zijlstra wrote:
>>> On Mon, 2009-04-06 at 13:01 +0200, Peter Zijlstra wrote:
>>>> On Fri, 2009-04-03 at 11:25 -0700, Corey Ashford wrote:
>>>>> Peter Zijlstra wrote:
>>>>>> On Thu, 2009-04-02 at 11:12 +0200, Peter Zijlstra wrote:
>>>>>>> plain text document attachment (perf_counter_callchain_context.patch)
>>>>>>> Put in counts to tell which ips belong to what context.
>>>>>>>
>>>>>>>   -----
>>>>>>>    | |  hv
>>>>>>>    | --
>>>>>>> nr | |  kernel
>>>>>>>    | --
>>>>>>>    | |  user
>>>>>>>   -----
>>>>>> Right, just realized that PERF_RECORD_IP needs something similar if one
>>>>>> if not able to derive the context from the IP itself..
>>>>>>
>>>>> Three individual bits would suffice, or you could use a two-bit code -
>>>>> 00 = user
>>>>> 01 = kernel
>>>>> 10 = hypervisor
>>>>> 11 = reserved (or perhaps unknown)
>>>>>
>>>>> Unfortunately, because of alignment, it would need to take up another 64 
>>>>> bit word, wouldn't it?  Too bad you cannot sneak the bits into the IP in 
>>>>> a machine independent way.
>>>>>
>>>>> And since you probably need a separate word, that effectively doubles 
>>>>> the amount of space taken up by IP samples (if we add a "no event 
>>>>> header" option).  Should we add another bit in the record_type field - 
>>>>> PERF_RECORD_IP_LEVEL (or similar) so that user-space apps don't have to 
>>>>> get this if they don't need it?
>>>> If we limit the event size to 64k (surely enough, right? :-), then we
>>>> have 16 more bits to play with in the header, and we could do something
>>>> like the below.
>>>>
>>>> A further possibility would also be to add an overflow bit in there,
>>>> making the full 32bit PERF_RECORD space available to output events as
>>>> well.
>>>>
>>>> Index: linux-2.6/include/linux/perf_counter.h
>>>> ===================================================================
>>>> --- linux-2.6.orig/include/linux/perf_counter.h
>>>> +++ linux-2.6/include/linux/perf_counter.h
>>>> @@ -201,9 +201,17 @@ struct perf_counter_mmap_page {
>>>>  	__u32   data_head;		/* head in the data section */
>>>>  };
>>>>  
>>>> +enum {
>>>> +	PERF_EVENT_LEVEL_HV	= 0,
>>>> +	PERF_EVENT_LEVEL_KERNEL = 1,
>>>> +	PERF_EVENT_LEVEL_USER	= 2,
>>>> +};
>>>> +
>>>>  struct perf_event_header {
>>>>  	__u32	type;
>>>> -	__u32	size;
>>>> +	__u16	level		:  2,
>>>> +		__reserved	: 14;
>>>> +	__u16	size;
>>>>  };
>>> Except we should probably use masks again instead of bitfields so that
>>> the thing is portable when streamed to disk, such as would be common
>>> with splice().
>> One downside of this approach is that you if you specify "no header" 
>> (currently not possible, but maybe later?), you will not be able to get 
>> the level bits.
> 
> Would this be desirable? I know we've mentioned it before, but it would
> mean one cannot mix various event types (currently that means !mmap and
> callchain with difficulty).

I think it would.  For one use case I'm working on right now, simple 
profiling, all I need are ip's.  If I could omit the header, that would 
reduce the frequency of sigio's by a factor of three, and make it faster 
to read up the ip's when the SIGIO's occur.

I realize that it makes it impossible to mix record types with the 
header removed, and skipping over the call chain data a bit more 
difficult (but not rocket science).

It could be made an error for the caller to specify both "no header" and 
perf_coiunter_hw_event.mmap|munmap


> 
> As long as we mandate this header, we can have 16 misc bits.
> 

True.

- Corey

