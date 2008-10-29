Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYJ2AcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYJ2AcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJ2AcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:32:14 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:39906 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbYJ2AcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:32:14 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Naveen Gupta <ngupta@google.com>
Date: Wed, 29 Oct 2008 11:31:35 +1100
Message-ID: <4907AEE7.5030508@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.17 (X11/20081027)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com, david@fromorbit.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
References: <20081027190131.070061000@elf.corp.google.com>	 <20081027190139.838646000@elf.corp.google.com>	 <20081028002024.GM4985@disturbed>	 <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>	 <20081028214443.GX4985@disturbed>	 <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>	 <20081028233101.GD17077@disturbed> <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>
In-Reply-To: <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen Gupta wrote:
> 2008/10/28 Dave Chinner <david@fromorbit.com>:
>> On Tue, Oct 28, 2008 at 03:48:44PM -0700, Naveen Gupta wrote:
>>> I/O from RT class in CFQ can still see a bubble with this new latency
>>> class. An easy way to check this would be to submit ios at multiple
>>> levels both in CFQ and AS and check max latency of the highest levels.
>>> I will let Jens or Satoshi comment on exact algorithm for RT class.
>> You're missing my point entirely.
>>
>> You're defining a new class that has the exact same meaning as
>> the current RT class definition, then mapping the BE class over
>> the top of that, hence changing what that means for everyone.
>>
>> The fact that the *implementation* of AS and CFQ is different is
>> irrelevant; if you use the RT class then on CFQ you get the current
>> RT behaviour, if you use the RT class on AS you should get your new
>> priority dispatch mechanism. We don't need a new API just because
>> the implementations are different.
>>
> 
> There is nothing "real-time" about the current RT class anyways. It is

Yes, this is stupid.  IMO the real time class should be strict priorities
within the class, and within the same priority level, round robin.  As it
stands, RT seems to be just like a second BE class.

> basically these small *implementation* differences that defines these
> classes in current scheme of things, precise definitions of which
> would be very hard to find if one started looking around.
>
> The current implementation of AS is basically a flat structure with
> multiple priority levels. Initially I planned them to be different
> levels of best-effort class, which is exactly what we are doing
> "best-effort" from the scheduler/software point of view. So, the
> question is what you do with other classes for which you don't have a
> significantly different behavior: to keep things simple you map them
> to existing flat structure. And, I mapped RT (all levels to BE 0),
> idle (all levels to BE 7).

Even compared to CFQs broken RT handling, this is wrong, because now
any old BE0 process is equal in priority to any RT process.

> This leaves these RT and IDLE classes open for future implementations,
> where one could use hardware priorities (may be in NCQ) to implement
> RT class or other improvisations in software other than schedulers to
> map to RT class.
> 
> Now the initial feedback was since this *implementation* is different
> from anything we have in CFQ which is our current *standard* way of
> thinking and comparing (that is the only thing that exists) why not
> make them into a new class :). And somehow map others so that they
> make some sense till we get something for those classes as well.
> 
>>>>> So, in some sense it kind of implements absolute priority and
>>>>> is best used for jobs which are latency sensitive.  Since the
>>>>> priorities can be and are mapped internally in anticipatory
>>>>> scheduler, BEST_EFFORT class is mapped one-one with the LATENCY
>>>>> class.
>>>> So you map the BE class to something with the same semantics as
>>>> the RT class? What mapping do you do when an application uses
>>>> the RT class?
>>>>
>>> Yes I could have used RT class but it was used in CFQ to implement
>>> it's time-sliced based highest priority class.  If an application
>>> uses RT class, AS maps all levels of RT class to BE class level 0
>>> (i.e. to the highest priority available)
>> Which means you are throwing away all the RT priority levels and
>> so an application using the RT class would be subtly broken on AS....
>>
> 
> As I said earlier the organization of the AS levels is flat, so we
> could use any class (RT, BE, LATENCY) and fold the remaining ones. The
> other way which you would probably like is to increase number of
> levels and map different classes so that they are not folded.

As I said in my reply to the initial posting of this, I think there are
only two sensible ways of handling this:

  1) Maintain the full number of I/O priorities (1 IDLE, 8 BE, 8 RT);
  2) Collapse the levels and only deal with the classes;

Any other mapping seems arbitrary and likely to confuse.

>>>>> A filesystem can use best-effort class using similar interface
>>>>> as for cfq.
>>>> The folk using the RT priority classes greatly objected to using
>>>> the RT class for journal I/O precisely because it would then
>>>> preempt their application's RT I/O and introduce unpredictable
>>>> latencies.
>>>>
>>>> Journal I/O will typically use the highest priority BE class so
>>>> that it is promoted above BE I/O but does not preempt RT I/O.
>>>> With your mapping of BE classes to this new "absolute priority
>>>> latency" class, this configuration will give journal I/O the
>>>> highest priority in the scheduler. This will cause preemption of
>>>> your latency sensitive I/O and so those latencies you are trying
>>>> to avoid won't go away....
>>>>
>>> I see your problem, we could make the LATENCY class different from
>>> and above BE class (instead of one-one mapping).
>> Like the RT class is currently defined to be? ;)
>>
> 
> I agree with you and we could use RT (though you and I know that
> basically it is best effort). LATENCY was invented due to a previous
> suggestion.

Maybe what you want to do is make RT really real-time, and then use this
latency class to differentiate latency-sensitive BE traffic from regular
BE traffic.  Not necessarily ``higher'' priority, just a different kind of
best-effort.  One way of implementing this in CFQ might be to have smaller
but more frequent dispatches.


Also from the original posting, I think the weights are still broken
(especially in the context of RT) but I won't repeat that here.


    -- Aaron

