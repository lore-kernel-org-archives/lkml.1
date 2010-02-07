Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0BGNtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0BGNtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:49:12 -0500
Message-ID: <4B6EC472.4010502@redhat.com>
Date: Sun, 07 Feb 2010 15:47:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <4B56D027.3010808@redhat.com> <1263981472.4283.843.camel@laptop> <4B56F588.2060109@redhat.com> <20100127082440.GA16640@elte.hu> <4B5FFADB.5090209@redhat.com> <20100127090824.GA23570@elte.hu> <4B60067B.4060708@redhat.com> <20100127102311.GA973@elte.hu>
In-Reply-To: <20100127102311.GA973@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 12:23 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>    

(back from vacation)

>>> If so then you ignore the obvious solution to _that_ problem: dont use
>>> INT3 at all, but rebuild (or re-JIT) your program with explicit callbacks.
>>> It's _MUCH_ faster than _any_ breakpoint based solution - literally just
>>> the cost of a function call (or not even that - i've written very fast
>>> inlined tracers - they do rock when it comes to performance). Problem
>>> solved and none of the INT3 details matters at all.
>>>        
>> However did I not think of that?  Yes, and let's rip off kprobes tracing
>> from the kernel, we can always rebuild it.
>>
>> Well, I'm observing an issue in a production system now.  I may not want to
>> take it down, or if I take it down I may not be able to observe it again as
>> the problem takes a couple of days to show up, or I may not have the full
>> source, or it takes 10 minutes to build and so an iterative edit/build/run
>> cycle can stretch for hours.
>>      
> You have somewhat misconstrued my argument. What i said above is that _if_ you
> need extreme levels of performance you always have the option to go even
> faster via specialized tracing solutions. I did not promote it as a
> replacement solution. Specialization obviously brings in a new set of
> problems: infexibility and non-transparency, an example of what you gave
> above.
>
> Your proposed solution brings in precisely such kinds of issues, on a
> different level, just to improve performance at the cost of transparency and
> at the cost of features and robustness.
>    

We just disagree on the intrusiveness, then.  IMO it will be a very rare 
application that really suffers from a vma injection, since most apps 
don't manage their vmas directly but leave it to the kernel and ld.so.

> It's btw rather ironic as your arguments are somewhat similar to the Xen vs.
> KVM argument just turned around: KVM started out slower by relying on hardware
> implementation for virtualization while Xen relied on a clever but limiting
> hack. With each CPU generation the hardware got faster, while the various
> design limitations of Xen are hurting it and KVM is winning that race.
>
> A (partially) similar situation exists here: INT3 into ring 0 and handling it
> there in a protected environment might be more expensive, but _if_ it matters
> to performance it sure could be made faster in hardware (and in fact it will
> become faster with every new generation of hardware).
>    

Not at all.  For kvm hardware eliminates exits completely where pv Xen 
tries to reduce their cost, but an INT3 will be forever much more 
expensive than a jump.

You are right however that we should favour hardware support where 
available, and for high bandwidth tracing, it is available: branch trace 
store.  With that, it is easy to know how many times the processor 
passed through some code point as well as to reconstruct the entire call 
chain, basically what the function tracer does for the kernel.

Do we have facilities for exposing that to userspace?  It can also be 
very useful for the kernel.

It will still be slower if we only trace a few points, and it can't 
trace register and memory values, but it's a good tool to have IMO.

> Both Peter and me are telling you that we are considering your solution too
> specialized, at the cost of flexibility, features and robustness.
>    

We'll agree to disagree on that then.

-- 
error compiling committee.c: too many arguments to function

