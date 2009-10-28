Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZJ1OPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZJ1OPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZJ1OPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:15:23 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57761 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZJ1OPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WBk7nrzjmcy1ADIqfc046uIWmxkQAhcKYKqB8yX49wAPU+Yxh7SRZdjOwWqrnE7tCq
         aYLHiRPHIwMjD2gfgOWfcjlBnvkCVODolbP27/4wHpaEPPRq7ZF4QjRJM5N7mSFNvBKV
         CdWQttFAkFEzF7TXiXBPrq76VeoowHNpVbxMw=
MIME-Version: 1.0
In-Reply-To: <1256460376.15273.31.camel@Palantir>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
	 <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
	 <1256460376.15273.31.camel@Palantir>
Date: Wed, 28 Oct 2009 19:45:26 +0530
Message-ID: <e932a33e0910280715u1722b8b4k9dabda45c61151ad@mail.gmail.com>
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex, Deadline 
	Based Interrupt Handlers
From: Soumya K S <ssks.mt@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@gandalf.sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 2:16 PM, Raistlin <raistlin@linux.it> wrote:
> On Thu, 2009-10-22 at 20:12 +0530, Soumya K S wrote:
>> Hi Dario,
> Hi again,
>
How you duin...
>> we needed a deadline based scheduler for DRTL and we zeroed
>> in upon SCHED_EDF. We see that the threads here are fairly new too :-P
>>
> Yes, we are not far from the starting point as well... :-)
>
>> > Nice, from here, it seemed we were working on very similar things, and I
>> > was wondering if we could somehow collaborate... :-)
>> >
>> Sure! That would be good :)
>>
> So... I looked at the code and, even if the aim of our two projects are
> quite the same, our implementations are very different.
>
> The main difference is the bandwidth reservation thing.
> I strongly think that, on a system like Linux, it should be very
> important to have --at least as a possibility-- the following features:
> - tasks can request for a guaranteed runtime over some time interval
>  (bandwidth),

We can specify the bandwidth reservation of an RT class and we use the
reservation policy of the RT scheduling class itself. By increasing
the static priority of the EDF task, we can guarantee that EDF tasks
always get the required runtime. If the user puts all his EDF tasks in
priority 1 , only his tasks run. In that case the entire RT bandwidth
is reserved for the EDF tasks. In a way your patch also does the same
thing by placing itself above the RT scheduling class. Only thing what
we don't have in place is partitioning of RT bandwidth across RR/FIFO
and EDF, which right now, we overcome by intelligently placing the
tasks with different policies in different priority levels.
If you are asking bandwidth reservation for guaranteeing determinism,
we definitely have determinism in place, but bandwidth reservation for
other real-time scheduling policies is not in place. This is something
which we can surely work on.

> - admission test should guarantee no oversubscription

So, you are calculating the WCET online in the scheduler right? Can it
calculate the amount of CPU time with the  required preciseness? Here,
you are increasing the enqueue time by adding an O(n) calculation for
every task that you enqueue. That is the reason why for a small
system, pushing this to architect made better sense in terms of
decreased latencies where the turn around time from when the task
enters till it gets the desired result matters, e.g., reading a sensor
2 times in 1ms.

> - bandwidth enforcing must avoid reciprocal tasks interferences.
> Maybe we can make the second and third configurable/optional (already
> thought about that, and it should be quite easy), but they need to be
> there, at least to avoid extending the interface again when we'll
> realize they'll needed! :-P
>
> I don't know how much you, and other people here, are familiar with such
> idea... We implemented it using one of the many existing algorithm. I
> can give you pointers to papers and other implementations of it if
> interested.

Surely, we would like to look into this if you can provide some more pointers.

> To keep it short and practical, you can think at it as something similar
> to what MacOS-X (and I think Solaris) already have --and actively use,
> e.g., for the Jack Audio Connection Kit-- and call
> THREAD_TIME_CONSTRAINT (very poor docs, I think, but it gives the big
> picture):
> http://developer.apple.com/mac/library/documentation/Darwin/Conceptual/KernelProgramming/scheduler/scheduler.html#//apple_ref/doc/uid/TP30000905-CH211-BEHJDFCA
>
> Moreover, as Peter pointed out, coming out with an interface which is
> too much tightly tied to EDF, or to any other specific algorithm,
> wouldn't be the best idea. What would happen if somewhere in the future
> we decide to change from the EDF algorithm to some other deadline based
> one?

Hmm on a lighter note, we would rather say you would just need to
replace 3 functions then :))

> That's why we changed the name and the interface from _EDF/_edf (yep, it
> has been our first choice too! :-P) to _DEADLINE/_deadline, and that's
> why I think we should continue striving for even more
> interface-algorithm independence.
>

True, but we really think its a matter of trade-off between how much
response time you can guarantee for a real-time task v/s how much
scalable you want your design to be. The deterministic response times
that you might have achieved by having all these features might be
good enough (Not sure of your numbers here) in a soft real time
scenario, but wondering if it would meet ends otherwise.

> Obviously, also SMP has to be there! :-P
> We have it in fully partitioned right now, but I'll become global (with
> support for cpu-affinity) in very short time I hope (Juri, from ReTiS
> Lab in Pisa is already working on it).
>
> For rt-mutexes/deadline inheritance, the big issue is that, it works if
> you only have EDF, but with a "bandwidth aware scheduler", you need
> something more, which is why we don't have it yet... However, I think it
> could be a nice starting point.

Yes, we too think without a DI in place, its not a complete real-time solution.

>
> Finally, I like the idea of deadline IRQ handling and I think it would
> be worth to mind it some more. :-)
>

We found many use cases for this feature where real-time tasks have
higher priority than lower priority interrupts generated as a result
of say audio streaming, etc Being able to configure these was
extremely important to maintain the deterministic property of an EDF
task in the system.

>> > Even from the implementation point of view, I see you didn't used a new
>> > scheduling class.
>> >
>> A simple system where there a few real-time tasks and a few non-real
>> time tasks, the timelines can be architected out for each real-time
>> task in the system. In such a case, given the RT bandwidth in the
>> system, the task with the lowest deadline gets to be scheduled first
>> till it is there in the system.
>> In short, for such simple systems, we shifted the burden of admission
>> control to the architect and kept close to the existing code.
>>
> Well, I kind of agree on both, _iff_ you're target is _only_ such small
> embedded systems. However, my very humble opinion is that, on Linux, you
> need something more general and, since we are talking about real-time,
> as much predictable and analyzable as you can get... And I think a
> separate scheduling class would be better suited for this. What do you
> think?
>

Yes, the target was industrial control systems where we needed
deterministic real-time response and also the responsiveness of the
task was critical. Here, the demanding real-time tasks were not too
many (~4/5 at a given point in time) and also, there were other user
tasks which had to update the results of this real-time task remotely.
Hence, we were very vary of introducing latencies in the system.
Instead, we focused on bringing in determinism into the system without
increasing its latency! Also, the concept of a deadline miss handler
was very handy, for a task missing its deadline not to interfere with
the determinism of the other tasks. In this approach, we were able to
meet the demanding response times with determinism in place.
However, I do understand that this approach puts the system designer
in a hot spot! :)


>> > I'm right in the opposite situation, I've got SMP (partitioned for now,
>> > but we're working on migrations) and also CGROUPS support, but we are
>> > still wondering how deadline (or something more sophisticated, like
>> > bandwidth) inheritance could work in such a case...
>> >
>> That's right, we are still working on SMP and hope there are no
>> scalability issues in this patch w.r.t SMP.
>>
> Well, I don't know. I guess achieving something similar to what we
> already have now (partitioned SMP) should not be impossible even with
> your approach... But if you want something different, such has global
> (EDF) scheduling, where task can migrate among CPUs according to their
> affinity, would but a major headache!! :-O
>
>> > Do you already have any numbers or testcase? I have some (well, a few!)
>> > of them... I'll try to find the time to give it a try to your patch with
>> > them...
>> >
>> We have tested Co-operative context switch time, Pre-emptive context
>> switch time and Interrupt Latency, all of them are of ~130us for
>> OMAP3530.
>>
> Mmm... I'm not sure I see why and how your patch should affect context
> switches duration... However, do you have the testcases for such tests?
>

Well we are actually saying that it does _not_ effect the context
switch time :).
We are measuring the time when a task is entered in the system till it
gets scheduled both in preemptive and non-preemptive modes. This
figure does not change even for a loaded system which shows the
deterministic turn around time for a task in terms of scheduling
latencies.

Regards,
Shubhro
Soumya
