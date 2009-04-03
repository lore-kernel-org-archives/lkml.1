Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbZDCHZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbZDCHZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZDCHZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:25:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51396 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZDCHZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:25:39 -0400
Message-ID: <49D5B9E7.1020400@linux.vnet.ibm.com>
Date: Fri, 03 Apr 2009 00:25:27 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf_counter: request for three more sample data options
References: <49D56A7E.80908@linux.vnet.ibm.com> <1238742064.798.8.camel@twins>
In-Reply-To: <1238742064.798.8.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply, Peter.

Peter Zijlstra wrote:
> On Thu, 2009-04-02 at 18:46 -0700, Corey Ashford wrote:
>> Currently, perf_counter has the ability to record the following on event 
>> counter overflow:
>>
>> Instruction Pointer
>> Call chain
>> Group counter values
>> Thread id
>>
>> To give perf_counter similar capabilities to perfmon2's default sampling 
>>   module, I'd like the following additional sample data to be added.
>>
>> Time stamp
> 
> Rather hard actually, to provide a decent timestamp from NMI context.
> 
>> CPU number
> 
> Could do I guess.
> 
>> Thread Group Id
> 
> As in the process id? PERF_RECORD_TID already provides that.
> 
>> I'd suggest the following
>>
>> enum perf_counter_record_format {
>>          PERF_RECORD_IP          = 1U << 0,
>>          PERF_RECORD_TID         = 1U << 1,
>>          PERF_RECORD_TGID        = 1U << 2,
>> -        PERF_RECORD_GROUP       = 1U << 2,
>> +        PERF_RECORD_GROUP       = 1U << 3,
>> -        PERF_RECORD_CALLCHAIN   = 1U << 3,
>> +        PERF_RECORD_CALLCHAIN   = 1U << 4,
>> +        PERF_RECORD_CPU_ID      = 1U << 5,
>> +        PERF_RECORD_TIMESTAMP   = 1U << 6,
>> };
>>
>> And of course the obvious changes to perf_event_type.
>>
>> I would expect that CPU ID would be 32 bits, and the timestamp to be the 
>> 64-bit current time.  TGID is the same size as TID.
> 
> Right, so PREF_RECORD_TID provides:
> 
>  { u32 pid, tid; }

Ah, I didn't know that.  Ok, that's only two things I want then :)

> 
> PERF_RECORD_TIMESTAMP would provide something like:
> 
>  { u64 time; }

Yep.

> 
> and per our u64 alignment rule, PERF_RECORD_CPU would provide
> 
>  { u64 cpuid; }
> 
> unless you can think of anything else to stuff in there?

We could leave the upper 32-bits reserved for now.  Perhaps someone 
later will come up with some nice info to put there.

> 
>> I am guessing the only difficult thing here would be obtaining the 
>> current time from an IRQ, especially NMI handler.  Is this difficult?
> 
> Yes, quite :-) I'll have to see what we can do there -- we could do a
> best effort thing with little to no guarantees I think.
> 

Best effort would be fine, I think.  I would assume that means that 
99.9% of the time, you'll get a correct timestamp, and the rest are 
rubbish?  Or would there be a way to detect when you're not able to give 
a correct timestamp and in that case replace the timestamp field with a 
special sentinel, like all hex f's?

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

