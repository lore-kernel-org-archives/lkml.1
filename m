Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZDTVr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZDTVr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZDTVru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:47:50 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:61699 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbZDTVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:47:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukFANuH7ElMQW1W/2dsb2JhbACBTtArg30G
Date: Mon, 20 Apr 2009 17:47:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090420214746.GB12986@Krystal>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org> <20090418065331.GA1942@Krystal> <49EBB654.9020405@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49EBB654.9020405@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:39:51 up 51 days, 18:06,  2 users,  load average: 1.07, 0.43,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>>   
>>> Ingo Molnar wrote:
>>>     
>>>> I meant to suggest to Jeremy to measure the effect of this   
>>>> out-of-lining, in terms of instruction count in the hotpath.
>>>>         
>>> OK, here's a comparison for trace_sched_switch, comparing inline and 
>>> out  of line tracing functions, with CONFIG_PREEMPT enabled:
>>>
>>> The inline __DO_TRACE version of trace_sched_switch inserts 20   
>>> instructions, assembling to 114 bytes of code in the hot path:
>>>
>>>     
>>
>> [...]
>>
>>   
>>> __do_trace_sched_switch is a fair bit larger, mostly due to function  
>>> preamble frame and reg save/restore, and some unfortunate and   
>>> unnecessary register thrashing (why not keep rdi,rsi,rdx where they   
>>> are?).  But it isn't that much larger than the inline version: 34   
>>> instructions, 118 bytes.  This code will also be shared among all   
>>> instances of the tracepoint (not in this case, because sched_switch 
>>> is  unique, but other tracepoints have multiple users).
>>>
>>>     
>>
>> [...]
>>
>>   
>>> So, conclusion: putting the tracepoint code out of line significantly 
>>>  reduces the hot-path code size at each tracepoint (114 bytes down to 
>>> 31  in this case, 27% the size).  This should reduce the overhead of 
>>> having  tracing configured but not enabled.  The saving won't be as 
>>> large for  tracepoints with fewer arguments or without 
>>> CONFIG_PREEMPT, but I chose  this example because it is realistic and 
>>> undeniably a hot path.  And  when doing pvops tracing, 80 new events 
>>> with hundreds of callsites  around the kernel, this is really going 
>>> to add up.
>>>
>>> The tradeoff is that the actual tracing function is a little larger, 
>>> but  not dramatically so.  I would expect some performance hit when 
>>> the  tracepoint is actually enabled.  This may be mitigated increased 
>>> icache  hits when a tracepoint has multiple sites.
>>>
>>> (BTW, I realized that we don't need to pass &__tracepoint_FOO to   
>>> __do_trace_FOO(), since its always going to be the same; this 
>>> simplifies  the calling convention at the callsite, and it also makes 
>>> void  tracepoints work again.)
>>>
>>>    J
>>>     
>>
>> Yep, keeping "void" working is a niceness I would like to keep. So about
>> this supposed "near-zero function call impact", I decided to take LTTng
>> for a little test. I compare tracing the "core set" of Google
>> tracepoints with the tracepoints inline and out-of line. Here is the
>> result :
>>
>> tbench test
>>
>> kernel : 2.6.30-rc1
>>
>> running on a 8-cores x86_64, localhost server
>>
>> tracepoints inactive :
>>
>> 2051.20 MB/sec
>>
>> "google" tracepoints activated, flight recorder mode (overwrite) tracing
>>
>> inline tracepoints
>>
>> 1704.70 MB/sec (16.9 % slower than baseline)
>>
>> out-of-line tracepoints
>>
>> 1635.14 MB/sec (20.3 % slower than baseline)
>>
>> So the overall tracer impact is 20 % bigger just by making the
>> tracepoints out-of-line. This is going to add up quickly if we add as
>> much function calls as we currently find in the event tracer fast path,
>> but LTTng, OTOH, has been designed to minimize the number of such
>> function calls, and you see a good example of why it's been such an
>> important design goal above.
>>   
>
> Yes, that is a surprising amount.  I fully expect to see some amount of  
> cost associated with it, but 20% is surprising.
>
> However, for me, the performance question is secondary.  The main issue  
> is that I can't use the tracing infrastructure with inline tracepoints  
> because of the #include dependency issue.  I think this may be solvable  
> in the long term by restructuring all the headers to make it work out,  
> but I'm still concerned that the result will be brittle and hard to  
> maintain.

Hrm, I'm not that sure about that. Once we get the thread_info headers
right, we just have to provide the build tests required so the
kernel autobuilders detect any inconsistency due to circular header
addition. If this is not enough, we can also add a comment at the
beginning of thread_info.h and other required headers saying that only
type headers should be included.

>
> Putting the tracing code out of line and making tracepoint.h have  
> trivial #include dependencies is "obviously correct" from a maintenance  
> and correctness point of view, and will remain robust in the face of  
> ongoing changes.  It allows the tracing machinery to be used in the  
> deepest, darkest corners of the kernel without having to worry about new  
> header interactions.

The other way around is to do a tiny, self-contained, "trace-rcu"
implementation specially for tracing. :-D But I really doubt there is
any gain in not using something as simple as the thread_info structure
and the rcu read-side, really.

>
> But I completely understand your concerns about performance.  Existing  
> tracepoints which have no problem with the existing header dependencies  
> are, apparently, faster with the inline tracing code.  And there's no  
> real reason to penalize them.
>
> So the compromise is this: we add (yet another) #ifdef so that a  
> particular set of tracepoints can be emitted with either inline or  
> out-of-line code, by defining two variants of __DO_TRACE: one inline,  
> and one out of line?  trace/events/pvops.h could select the out of line  
> variant, and everyone else could leave it as-is.  I don't think that  
> would add very much additional complexity to tracepoint.h, but it means  
> we can both get the outcomes we need.
>
> (I haven't tried to prototype this, so maybe it all falls apart in the  
> details, but I'll give it a go tomorrow.)
>

Hrm, my opinion is that _this_ would be a worse maintenance burden (two
tracepoint flavors instead of one) than trying to keep already thin
headers as thin as they should be. This might also bring very
interesting corner-cases with __builtin_return_address and friends in
the tracepoint probes.

Mathieu

>> About cache-line usage, I agree that in some cases gcc does not seem
>> intelligent enough to move those code paths away from the fast path.
>> What we would really whant there is -freorder-blocks-and-partition, but
>> I doubt we want this for the whole kernel, as it makes some jumps
>> slightly larger. One thing we should maybe look into is to add some kind
>> of "very unlikely" builtin expect to gcc that would teach it to really
>> put the branch in a cache-cold location, no matter what.
>>   
>
> I wonder if -fno-guess-branch-probabilities would help?  The  
> documentation says that the interaction between __builtin_expect() and  
> its normal branch probability heuristics is complex, and it might be  
> interfereing here.  But I think that in the general case we don't want  
> to either 1) require external branch probability data, or 2) annotate  
> every single branch with an expect, so we want gcc to be trying to guess  
> for us.  The __cold annotation on functions is more useful anyway, I  
> think (so gcc knows that any code path which results in calling a cold  
> function is unlikely, without needing explicit annotations on every  
> conditional).
>
>    J

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
