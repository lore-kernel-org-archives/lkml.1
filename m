Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYGGPxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYGGPxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYGGPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:53:42 -0400
Received: from gw.goop.org ([64.81.55.164]:60620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYGGPxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:53:41 -0400
Message-ID: <48723BFB.9000702@goop.org>
Date: Mon, 07 Jul 2008 08:53:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <1214254730.11254.34.camel@twins> <48630420.1090102@goop.org> <200807072150.39571.nickpiggin@yahoo.com.au>
In-Reply-To: <200807072150.39571.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 26 June 2008 12:51, Jeremy Fitzhardinge wrote:
>   
>> Peter Zijlstra wrote:
>>     
>>> On Mon, 2008-06-23 at 13:45 -0700, Christoph Lameter wrote:
>>>       
>>>> On Mon, 23 Jun 2008, Peter Zijlstra wrote:
>>>>         
>>>>>> It is good that the locks are build with _trylock and _can_lock
>>>>>> because then we can reenable interrupts while spinning.
>>>>>>             
>>>>> Well, good and bad, the turn side is that fairness schemes like ticket
>>>>> locks are utterly defeated.
>>>>>           
>>>> True. But maybe we can make these fairness schemes more generic so that
>>>> they can go into core code?
>>>>         
>>> The trouble with ticket locks is that they can't handle waiters going
>>> away - or in this case getting preempted by irq handlers. The one who
>>> took the ticket must pass it on, so if you're preempted it just sits
>>> there being idle, until you get back to deal with the lock.
>>>
>>> But yeah, perhaps another fairness scheme might work in the generic
>>> code..
>>>       
>> Thomas Friebel presented results at the Xen Summit this week showing
>> that ticket locks are an absolute disaster for scalability in a virtual
>> environment, for a similar reason.  It's a bit irritating if the lock
>> holder vcpu gets preempted by the hypervisor, but its much worse when
>> they release the lock: unless the vcpu scheduler gives a cpu to the vcpu
>> with the next ticket, it can waste up to N timeslices spinning.
>>     
>
> I didn't realise it is good practice to run multiple "virtual CPUs"
> of the same guest on a single physical CPU on the host...
>   

It isn't.  It makes no sense at all to give a guest more vcpus than 
physical cpus, so that kind of contention won't happen in general.  But 
the bad locking scenario happens when there's any system-wide 
contention, so it could happen if some other virtual machine preempts a 
vcpu holding a lock.  And once a lock ends up being (effectively) held 
for 30ms rather than 30us, the likelihood of going into contention goes 
way up, and you can enter the catastrophic N^2 unlock->relock state.

My measurements show that reverting to the old lock-byte algorithm 
avoids the worst case, and just results in a bit of excessive spinning.  
Replacing it with a smarter spin-then-block-vcpu algorithm doesn't 
really benefit the specific guest VM very much (kernbench elapsed time 
is only slightly improved), but its consumption of physical cpu time can 
go down by ~10%.

>> I'm experimenting with adding pvops hook to allow you to put in new
>> spinlock implementations on the fly.  If nothing else, it will be useful
>> for experimenting with different algorithms.  But it definitely seems
>> like the old unfair lock algorithm played much better with a virtual
>> environment, because the next cpu to get the lock is the next one the
>> scheduler gives time, rather than dictating an order - and the scheduler
>> should mitigate the unfairness that ticket locks were designed to solve.
>>     
>
> ... if it is good practice, then, virtualizing spinlocks I guess is
> reasonable. If not, then "don't do that". Considering that probably
> many bare metal systems will run pv kernels, every little cost adds
> up

I'm aware of that.  In my current implementation the overhead amounts to 
an extra direct call in the lock/unlock path, but that can be eliminated 
with a small amount of restructuring (by making spin_lock/unlock() 
inline functions, and having the call to raw_spin_lock/unlock within 
it).  The pvops patching machinery removes any indirect calls or jumps.

    J
