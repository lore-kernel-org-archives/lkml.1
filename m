Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZHMTPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZHMTPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZHMTPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:15:32 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:59355 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZHMTPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=OtrqnPvK8r23Yd/K9wftgx+eBnFJ4LNYIeLhXcAgPW4/Ts9oVGbY6Hlx1lxjuaFLzq
         9CjwPLgDDLX1I2gkJBL/RHKgEKgS/8lgnL+7BkODv0iRZePz/18zQ7seegOb6Sk5iWLQ
         /xSIQMD5bU602+natg+8QxuofZc0Ctu3EPVdw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090813094635.GA26612@elte.hu>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
	 <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
	 <1250024143.7091.7.camel@laptop>
	 <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
	 <1250065963.10001.30.camel@twins> <20090812090234.GB14114@elte.hu>
	 <7c86c4470908120522m1eaf891bqb394df072dddc701@mail.gmail.com>
	 <20090813094635.GA26612@elte.hu>
Date: Thu, 13 Aug 2009 21:15:31 +0200
Message-ID: <7c86c4470908131215se9b81d4v18d4d881a70f1aad@mail.gmail.com>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:46 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> On Wed, Aug 12, 2009 at 11:02 AM, Ingo Molnar<mingo@elte.hu> wrote:
>>
>> > Not sure we want to change it. Mixing PID and CPU into the same
>> > space disallows the simultaneous application of both. I.e. right
>> > now we allow 3 models:
>> >
>> >  - PID-ish
>> >  - CPU-ish
>> >  - PID and CPU [say measure CPU#2 component of an inherited workload.]
>>
>> How useful is that last model, especially why only one CPU?
>
> It's somewhat useful: say on an inherited workload one could 'cut
> out' just a single CPU worth of samples.
>
> Or a tool could implement a more scalable sampling model: say on a
> quad core CPU one could have four counters in an inherited workload:
>
>  cycles:cpu0
>  cycles:cpu1
>  cycles:cpu2
>  cycles:cpu3
>

What would you be able to do with that kind of information?
How would you modify the program to improve performance?

> ... and depending on which CPU a sub-process or sub-thread is
> running on, would the according (nicely per cpu local) sampling
> buffer be used.
>
>> > Also, i dont really see the use-cases for new targets. (i've
>> > seen a few mentioned but none seemed valid) What new targets do
>> > people have in mind?
>>
>> I seem to recall people mentioned:
>>    1- CPU socket, e.g., uncore PMU
>>    2- chipset
>>    3- GPU
>>
>> I can see 1/ being indirectly achievable by specifying a CPU.
>
> Correct.
>
> ( Note, it's not just indirectly achievable as a side-effect - for
>  example the Intel uncore PMU has a target CPU irq-mask, so it
>  makes sense to allow the specification of the specific CPU we are
>  measuring on as well. The physical socket maps from the CPU. )
>
I know that because I used it to support uncore on perfmon.
Some people have argued, though, that it could be interesting to
interrupt all cores at once on uncore overflow. That's one way to know
where all cores are at the same point in time. I wonder how you could
support that.


>> [...] But the others are uncorrelated to either a CPU or thread. I
>> have already seen requests for accessing chipsets, and seems GPU
>> are around the corner now.
>>
>> Why do you think those would be invalid targets given the goal of
>> this API?
>
> No.
>
> Chipset and GPU measurements are very much possible via perfcounters
> as well - but that does not require the touching of the pid,cpu
> target parameters to sys_perf_counter_open().
>
> I think the confusion in this discussion comes from the fact that
> there are two different types of 'targets':
>
> The first type of target, the <pid,cpu> target is a _scheduling_,
> task management abstraction. Adding a chipset ID or GPU ID to that
> makes little sense! Tasks dont get scheduled on a 'chipset' - to
> each task the chipset looks like an external entity.
>
> The second type of target is the 'event source itself'. (and it's
> not really a target but a source.)
>
> A chipset or GPU should be abstracted via an _event source_
> abstraction. We've got wide possibilities to do that, and we already
> abstract a fair amount of non-CPU-sourced events that way: say we
> have irq tracepoint counters:
>
>  aldebaran:~> perf list 2>&1 | grep irq
>    irq:irq_handler_entry                      [Tracepoint event]
>
> irqs come from the chipset, so in an (unintended) way perfcounters
> already instruments the chipset today.
>
> So yes, both chipset and GPU sampling is very much possible, and it
> does not require the tweaking of the syscall target parameters -
> each CPU has a typically symmetric view on it.
>

Except there can be many GPUs, I/O devices and other pieces of
hardware with PMU-like capabilities in a single system. In that case,
you need to be able to name them: I want to measure GPUcycles on
GPU0. When you are down at that level, you don't really care about
the CPU or thread. So what would you pass for those in that case?

> Note that there's overlap: a CPU can be an event source and a
> scheduling target as well. I think some of the confusion in
> terminology comes from that.
>
> To support chipset or GPU sampling, the perf_type_id and/or the
> struct perf_counter_attr space can be extended.
>
