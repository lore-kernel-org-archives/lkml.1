Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYHTUO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYHTUO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYHTUOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:14:18 -0400
Received: from gw.goop.org ([64.81.55.164]:40894 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbYHTUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:14:17 -0400
Message-ID: <48AC7B0E.1060100@goop.org>
Date: Wed, 20 Aug 2008 13:14:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, jens.axboe@oracle.com, a.p.zijlstra@chello.nl,
       cborntra@de.ibm.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking
 waiting
References: <48A70185.2020600@goop.org>	<20080819232108.c03660fa.akpm@linux-foundation.org>	<48AC6593.80505@goop.org> <20080820122546.6022d91d.akpm@linux-foundation.org>
In-Reply-To: <20080820122546.6022d91d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 20 Aug 2008 11:42:27 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> On Sat, 16 Aug 2008 09:34:13 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>   
>>>       
>>>> There are various places in the kernel which wish to wait for a
>>>> condition to come true while in a non-blocking context.  Existing
>>>> examples of this are stop_machine() and smp_call_function_mask().
>>>> (No doubt there are other instances of this pattern in the tree.)
>>>>
>>>> Thus far, the only way to achieve this is by spinning with a
>>>> cpu_relax() loop.  This is fine if the condition becomes true very
>>>> quickly, but it is not ideal:
>>>>
>>>>  - There's little opportunity to put the CPUs into a low-power state.
>>>>    cpu_relax() may do this to some extent, but if the wait is
>>>>    relatively long, then we can probably do better.
>>>>     
>>>>         
>>> If this change saves a significant amount of power then we should fix
>>> the offending callsites.
>>>   
>>>       
>> Fix them how?  In general we're talking about contexts where we can't
>> block, and where the wait time is limited by some property of the
>> platform, such as IPI time or interrupt latency (though doing a
>> cross-cpu call of a long-running function would be something we could fix).
>>     
>
> ah, OK, I'd failed to note that you had identified two specific culprits.
>
> Are either of these operations executed frequently enough for there to
> be significant energy savings here?
>   

The energy savings are more gravy, and not really my focus.  Arjan tells
me that monitor/mwait are unusably slow in current implementations
anyway.  My interest is in the virtual machine case, where bad
interactions with the vcpu scheduler can cause things to spin for 30
milliseconds or more (sometimes much more) in causes that would only be
microseconds running native.

The s390 people have reported similar things, so this is definitely not
Xen or x86 specific.

>>>>  - In a virtual environment, spinning virtual CPUs just waste CPU
>>>>    resources, and may steal CPU time from vCPUs which need it to make
>>>>    progress.  The trigger API allows the vCPUs to give up their CPU
>>>>    entirely.  The s390 people observed a problem with stop_machine
>>>>    taking a very long time (seconds) when there are more vcpus than
>>>>    available cpus.
>>>>     
>>>>         
>>> If this change saves a significant amount of virtual-cpu-time then we
>>> should fix the offending callsites.
>>>   
>>>       
>> This case isn't particularly about saving vcpu time, but making timely
>> progress.  stop_machine() gets all the cpus into a spinloop, where they
>> spin waiting for an event to tell them to go to their next state-machine
>> state.  By definition this can't be a blocking operation (since the
>> whole point is that they're high priority threads that prevent anything
>> else from running).  But in the virtual case, the fact that they're all
>> spinning means that the underlying hypervisor has no idea who's just
>> spinning, and who's trying to do some work needed to make overall
>> progress, so the whole thing gets bogged down.
>>     
>
> hm.  I'm surprised that stop_machine() is executed frequently enough
> for you to care.  What's causing it?
>   

The big user is module load/unload, which have been observed to take
multiple seconds in stop_machine with some pathological overload
conditions.  It's a pretty major hiccup if you hit it.  (It's not
something that you'd deliberate set up except for testing, but it means
that something which might otherwise be a brief transient overload could
turn into a very brittle state with wildly varying performance
characteristics.)

Also Xen suspend/migrate uses stop_machine, and that's actually fairly
latency-sensitive.  A live migrate can only have a few 10s ms of
downtime for the virtual machine, so having stop_machine() with
latencies of a similar or longer scale is noticeable.

>> Now perhaps we could solve stop_machine by modifying the scheduler in
>> some way, where you can block the run queue so that you sit in the idle
>> loop even though there's runnable processes waiting.  But even then,
>> stop_machine requires that interrupts be disabled, which means the we're
>> pretty much limited to spinning.
>>     
>
> If stop_machine() is the _only_ problematic callsite and we reasonably
> expect that no new ones will pop up then sure, a
> stop_machine()-specific fix might be appropriate.
>
> Otherwise, sure, we'd need to loko at something more general.
>   

Well smp_call_function() does a spin wait, waiting for the other cpu(s)
to finish running the function.  If it's a long-running function, then
that spinning could be arbitrarily long - not that it's a good idea to
call something long-running in interrupt context like that, but you
could see it as a quality of implementation issue.

And again, in a virtual environment, all that spinning competes with
cpus trying to do real work, so even a "short" spin could be arbitrarily
long if it's preventing the event it is waiting for from occurring.

I'm pretty sure there are other places in the kernel which can make use
of a more general facility.  There are ~300 non-arch uses of cpu_relax()
in ~100 files, which are all (roughly) waiting for something to become
true.  Some are polling on hardware state, and some are waiting for
states set by uncooperative subsystems, but I'd be surprised if a
significant number couldn't be converted to use a higher-level
trigger/spinpletion mechanism.

And the fact that there are so many existing instances in the kernel
suggests that new ones will appear, and they could be encouraged to use
a high-level mechanism from the outset.

    J
