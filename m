Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZCaHZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZCaHZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZCaHZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:25:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59978 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZCaHZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:25:05 -0400
Message-ID: <49D1C544.7020403@linux.vnet.ibm.com>
Date: Tue, 31 Mar 2009 00:24:52 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
References: <20090330170701.856843742@chello.nl> <20090330171024.254266860@chello.nl> <18897.46177.528910.51044@cargo.ozlabs.ibm.com> <1238481552.28248.1384.camel@twins>
In-Reply-To: <1238481552.28248.1384.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-03-31 at 17:12 +1100, Paul Mackerras wrote:
>> Peter Zijlstra writes:
>>
>>>  				include_tid    :  1, /* include the tid       */
>>>  				mmap           :  1, /* include mmap data     */
>>>  				munmap         :  1, /* include munmap data   */
>>> +				callchain      :  1, /* add callchain data    */
>> Interesting, I would have put callchain (and include_tid, also) in
>> hw_event.record_type rather than as individual 1-bit fields.  The
>> present arrangement where some selection of what goes into the ring
>> buffer is in record_type and some is in individual bits seems a bit
>> awkward.  Plus, with the current arrangement I can't get both the IP
>> and the values of the other group members, which I might reasonable
>> want.
>>
>> I think either we make record_type bit-significant, or we define
>> individual bits in hw_event for recording the IP and other group
>> members.
>>
>> There are a couple of other things I want to be able to record on an
>> event - we have registers on powerpc that give information about the
>> event that caused the interrupt, and it would be nice to be able to
>> record them.  (These registers include instruction and data addresses
>> associated with the event; the instruction address can be further on
>> from where the interrupt was taken because of out-of-order instruction
>> execution and because interrupts might be hard-disabled at the point
>> where the interrupt becomes pending.)
>>
>> Those registers would need bits in record_type or in the hw_event to
>> indicate that we want them recorded.
> 
> Sure, I'm fine with moving them to record_type and making that a bit
> field. I've also considered merging the group and 'simple' output to
> enable what you say.

Originally, the record_type field was used to determine what would be 
read if you read from the fd.  However, now it seems to be what you get 
from the mmap buffer (only), that there is no longer a way to read the 
record stream from the fd anymore. Is this true?  If so, I like this 
idea because it simplifies the ABI: there is one way to read the current 
value of counters and another way to read sample records (via mmap), 
both of these operations use a single fd.

If this is the case, what is the exact meaning of PERF_COUNTER_SIMPLE 
now? and PERF_COUNTER_GROUP?  One simplification would be that reading 
the fd of a group leader would always read up all of the counters in the 
group (along with their enabled and running times if those bits are 
set), and that reading a single counter's fd would yield only that 
counter's values and times (if enabled).  In effect, these two values, 
PERF_COUNTER_GROUP and PERF_COUNTER_SIMPLE would no longer be necessary 
at all.  Other bits would be used to determine what's in the mmap'd samples.

- Corey


