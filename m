Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYLIVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYLIVXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYLIVXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:23:31 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:58020 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYLIVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=EuT0YUyekjrgvxfk0dKgDqfSDKmZUVYCxvcD4/BNRXo7ud9BfhxIrHYBeeYNJxtKw4
         6XbcQYR/nIyR7SFZLCO/RwJMHHc5FEOfsKOGr2kjrCHqMsaqbH5CIwctUIxL34UqX2Yq
         g4V0W+FtRsbUhTsfR3Q2oBIScZFNE0q3iMfnc=
Message-ID: <7c86c4470812091316g18989277m475f974e404eb311@mail.gmail.com>
Date: Tue, 9 Dec 2008 22:16:04 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v2
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "David Miller" <davem@davemloft.net>,
       "Paul Mackerras" <paulus@samba.org>,
       "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <20081209134636.GA1926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081208012211.GA23106@elte.hu>
	 <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
	 <20081209134636.GA1926@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 9, 2008 at 2:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> > There's a new "counter group record" facility that is a
>> > straightforward extension of the existing "irq record" notification
>> > type. This record type can be set on a 'master' counter, and if the
>> > master counter triggers an IRQ or an NMI, all the 'secondary'
>> > counters are read out atomically and are put into the counter-group
>> > record. The result can then be read() out by userspace via a single
>> > system call. (Based on extensive feedback from Paul Mackerras and
>> > David Miller, thanks guys!)
>>
>> That is unfortunately not generic enough. You need a bit more
>> flexibility than master/secondaries, I am afraid.  What tools want is
>> to be able to express:
>>
>>    - when event X overflows, record values of events  J, K
>>    - when event Y overflows, record values of events  Z, J
>
> hm, the new group code in perfcounters-v2 can already do this. Have you
> tried to use it and it didnt work? If so then that's a bug. Nothing in
> the design prevents that kind of group readout.
>
> [ We could (and probably will) enhance the grouping relationship some
>  more, but group readouts are a fundamentally inferior mode of
>  profiling. (see below for the explanation) ]
>
>> I am not making this up. I know tools that do just that, i.e., that is
>> collecting two distinct profiles in a single run. This is how, for
>> instance, you can collect a flat profile and the call graph in one run,
>> very much like gprof.
>
> yeah, but it's still the fundamentally wrong thing to do.
>
That's not for you to say. This is decision for the tool writers.

There is absolutely nothing wrong with this. In fact, people do this
kind of measurements all the time. Your horizon seems a bit too
limited, maybe.

Certain PMU features do not count events, they capture information about
where they occur, so they are more like buffers. Sometimes, they are hosted
in registers. For instance, Itanium has long been able to capture where
cache misses occur. The data is stored in a couple of PMU registers and only
one cache miss at a time. There is a PMU event that counts how many misses
are captured. So you program that event into a counter and when it overflows
you want to read out the pair of data registers containing the last captured
cache miss. Thus, when event X overflows, you capture values in registers Z, Y.
There is nothing wrong with this. You do the same thing when you want to
sample on a branch trace buffer, like X86 LBR. Again nothing wrong with this.
In fact you can collect both at the same time and in independent manner.


> Being able to extract high-quality performance information from the
> system is the cornerstone of our design, and chosing the right sampling
> model permeates the whole issue of single-counter versus group-readout.
>
> I dont think finer design aspects of kernel support for performance
> counters can be argued without being on the same page about this, so
> please let me outline our view on these things, in (boringly) verbose
> detail - spiked with examples and code as well.
>
> Firstly, sampling "at 1msec intervals" or any fixed period is a _very_
> wrong mindset - and cross-sampling counters is a similarly wrong mindset.
>
> When there are two (or more) hw metrics to profile, the ideally best
> (i.e. the statistically most stable and most relevant) sampling for the
> two statistical variables (say of l2_misses versus l2_accesses) is to
> sample them independently, via their own metric. Not via a static 1khz
> rate - or via picking one of the variables to generate samples.
>

Did I talk about static sampling period?

> [ Sidenote: as long as the hw supports such sort of independent sampling
>  - lets assume so for the sake of argument - not all CPUs are capable of
>  that - most modern CPUs do though. ]
>
> Static frequency [time] sampling has a number of disadvantages that
> drastically reduce its precision and reduce its utility, and 'group'
> sampling where one counter controls the events has similar problems:
>
> - It under-samples rare events such as cachemisses.
>
>  An example: say we have a workload that executes 1 billion instructions
>  a second, of which 5000 generate a cachemiss. Only one in 200,000
>  instructions generates a cachemiss. The chance for a static sampling
>  IRQ to hit exactly an instruction that causes the cachemiss is 1:200
>  (0.5%) in every second. That is very low probability, and the profile
>  would not be very helpful - even though it samples at a seemingly
>  adequate frequency of 1000 events per second!
>
Who talked about periods expressed as events per second?

I did not talk about that. If you had looked at the perfmon API, you would
have noticed that it does not know anything about sampling periods. It
only sees register values. Tools are free to pick whatever value they like.
And the value, by definition. is defined as the number of occurrences of
the event, not the number of occurrences per seconds. You can say:
every 2000 cache miss, take a sample, just program that counter
with -2000.

>  With per event counters and per event sampling that KernelTop uses, we
>  get an event next to the instruction that causes a cachemiss with a

You have no guarantee on how close the RIP is compared to where the cache
miss occurred. It can be several of instructions away (NMI or not by the way).
There is nothing software can do about it, neither my inferior design nor
your superior design.

>
> And note that once you accept that the highest quality approach is to
> sample the hw events independently, all the "group readout" approaches
> become a second-tier mechanism. KernelTop uses that model and works just
> fine without any group readout and it is making razor sharp profiles,
> down to the instruction level.
>

And you think you cannot do independent sampling with perfmon3?

As for 'razor sharp', that is your interpretation. As far as I know a
RIP is always
pointing to an instruction anyway. What you seem to be ignoring here
is the fact that
the RIP is as good as the hardware can give you. And it just happens that
on ALL processor architectures it is off compared to where the event actually
occurred. It can be several cycles away actually: skid. Your superior design
does not improve that precision whatsoever. It has to be handled at the
hardware level. Why do you think AMD added IBS, why Intel added PEBS on
X86 and why Intel added IP-EAR on Itanium2? Even PEBS is not solving that
issue completely. As far I know the quality of your profiles are as
good as Oprofile,
VTUNE, or perfmon.


> [ Note that there's special-cases where group-sampling can limp along
>  with acceptable results: if one of the two counters has so many events
>  that sampling by time or sampling by the rare event type gives relevant
>  context info. But the moment both event sources are rare, the group

>  model breaks down completely and produces meaningless results. It's
>  just a fundamentally wrong kind of abstraction to mix together
>  unrelated statistical variables. And that's one of the fundamental
>  design problems i see with perfmon-v3. ]
>

Again an unfounded statement, perfmon3 does not mandate what is recorded
on overflow. It does not mandate how many events you can sample on at the same
time. It does not know about sampling periods, it only knows about data register
values and reset values on overflow. For each counters, you can freely specify
what you want recorded using a simple bitmask.

Are we on the same page, then?
