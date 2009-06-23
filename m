Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZFWOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZFWOl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbZFWOlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:41:45 -0400
Received: from email.renci.org ([152.54.4.63]:58194 "EHLO mx1.renci.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759881AbZFWOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:41:44 -0400
Message-ID: <4A40E969.9000504@renci.org>
Date: Tue, 23 Jun 2009 10:40:41 -0400
From: Rob Fowler <rjf@renci.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, eranian@gmail.com,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] IV.3 - AMD IBS
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>	 <20090622120018.GR24366@elte.hu>  <4A3F9062.6000303@renci.org> <1245737987.19816.1477.camel@twins>
In-Reply-To: <1245737987.19816.1477.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: No, Score=-1.4 required=5.0 tests=ALL_TRUSTED
X-MS-Exchange-Organization-SCL: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm up to my neck in other stuff, so this will be short.

Yes, IBS is a very different model of performance measurement that
doesn't fit well with the traditional model.  It does do what the
HW engineers need for understanding multi unit out of order processors, though.

The separation of the fetch and op monitoring is an artifact of the separation
and de-coupling of the front and back end pipelines.  The front end IBS events
deal with stuff that happens in fetching:  TLB and cache misses, mis-predictions, etc.
The back end IBS events deal with computing and data fetch/store.

There are two "conventional" counters involved: the tag-to-retire and completion-to-retire
counts.  These can be accumulated, histogrammed, etc just like any conventional event, though
you need to add the counter contents to the accumulator rather than just increment.

The rest of the bits are predicates that can be used to filter the events into bins.
With n bits, you might need 2^n bins to accumulate all possibilities.
Sections 5 and 6 of the AMD software optimization guide provide some useful boolean expressions
for defining meaningful derived events.

In an old version of Rice HPCToolkit (now disappeared from the web) we
had a tool called xprof that processed DEC DCPI/ProfileMe binary files to
produce profiles with ~20 derived events that we thought would be useful.  The cost
of collecting all of this didn't vary by the amount we collected, so you would select
the ones you wanted to view at analysis time, not at execute time.  There was also a
mechanism for specifying other events. Nathan Tallent can provide details.

The Linear and Physical Address registers are an opportunity for someone to build data profiling
tools, or a combined instructions and data tool.

The critical thing is for the kernel, driver, and library builders to not do something that will
stand in the way of this.

Peter Zijlstra wrote:
> On Mon, 2009-06-22 at 10:08 -0400, Rob Fowler wrote:
>> Ingo Molnar wrote:
>>>> 3/ AMD IBS
>>>>
>>>> How is AMD IBS going to be implemented?
>>>>
>>>> IBS has two separate sets of registers. One to capture fetch
>>>> related data and another one to capture instruction execution
>>>> data. For each, there is one config register but multiple data
>>>> registers. In each mode, there is a specific sampling period and
>>>> IBS can interrupt.
>>>>
>>>> It looks like you could define two pseudo events or event types
>>>> and then define a new record_format and read_format. That formats
>>>> would only be valid for an IBS event.
>>>>
>>>> Is that how you intend to support IBS?
>>> That is indeed one of the ways we thought of, not really nice, but
>>> then, IBS is really weird, what were those AMD engineers thinking
>>> :-)
>> Actually, IBS has roots in DEC's "ProfileMe" for Alpha EV67 and later
>> processors.   Those of us who used it there found it to be an extremely
>> powerful, low-overhead mechanism for directly collecting information about
>> how well the micro-architecture is performing.  In particular, it can tell
>> you, not only which instructions take a long time to traverse the pipe, but
>> it also tells you which instructions delay other instructions and by how much.
>> This is extremely valuable if you are either working on instruction scheduling
>> in a compiler, or are modifying a program to give the compiler the opportunity
>> to do a good job.
>>
>> A core group of engineers who worked on Alpha went on to AMD.
>>
>> An unfortunate problem with IBS on AMD is that good support isn't common in the "mainstream"
>> open source community.
> 
> The 'problem' I have with IBS is that its basically a cycle counter
> coupled with a pretty arbitrary number of output dimensions separated
> into two groups, ops and fetches.
> 
> This is a very weird configuration in that it has a miss-match with the
> traditional one value per counter thing.
> 
> The most natural way to support IBS would be to have a special sampling
> cycle counter and use that as group lead and add non sampling siblings
> to that group to get individual elements.
> 
> This is however quite cumbersome.
> 
> One thing to consider when building an IBS interface is its future
> extensibility. In which fashion would IBS be extended?, additional
> output dimensions or something else all-together?

-- 
Robert J. Fowler
Chief Domain Scientist, HPC
Renaissance Computing Institute
The University of North Carolina at Chapel Hill
100 Europa Dr, Suite 540
Chapel Hill, NC 27517
V: 919.445.9670
F: 919 445.9669
rjf@renci.org
