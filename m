Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZKJOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZKJOJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZKJOJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:09:24 -0500
Received: from mail-px0-f173.google.com ([209.85.216.173]:64005 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJOJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:09:22 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 09:09:22 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JbIDl1zSRElXMpF+8sSz5ggkdSM2GcQhYOPYGZXa63klfV6kYiFrDwsOolimhbM1WV
         wVdrLh3/N5O14DxpnAXPnIj2bhj8crk6YxHn/UNIhZSLditibP3fsOgGud31+SEuW9wx
         HVhzX2Weba6OiXby2WflEo0Xm9bernrpXhbNA=
MIME-Version: 1.0
In-Reply-To: <1256747090.25821.367.camel@Palantir>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <1256198088.6700.76.camel@Palantir>
	 <e932a33e0910220742v5d99adbere9fc9c31f72b6b95@mail.gmail.com>
	 <1256460376.15273.31.camel@Palantir>
	 <e932a33e0910280715u1722b8b4k9dabda45c61151ad@mail.gmail.com>
	 <1256747090.25821.367.camel@Palantir>
Date: Tue, 10 Nov 2009 19:33:14 +0530
Message-ID: <e932a33e0911100603i43684c8apd68d3ee5b6e635a0@mail.gmail.com>
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

On Wed, Oct 28, 2009 at 9:54 PM, Raistlin <raistlin@linux.it> wrote:
> On Wed, 2009-10-28 at 19:45 +0530, Soumya K S wrote:
>> > The main difference is the bandwidth reservation thing.
>> > I strongly think that, on a system like Linux, it should be very
>> > important to have --at least as a possibility-- the following features:
>> > - tasks can request for a guaranteed runtime over some time interval
>> >  (bandwidth),
>>
>> We can specify the bandwidth reservation of an RT class and we use the
>> reservation policy of the RT scheduling class itself.
>>
> Yes, and all that you can specify is how much bandwidth all the
> EDF+FIFO tasks in the system will get. I was talking about something
> very different... :-(
>
>> By increasing
>> the static priority of the EDF task, we can guarantee that EDF tasks
>> always get the required runtime.
>>
> Which is not enforced to stay below any kind of value of
> deterministic/stochastic worst case execution time nor any kind of
> budget which is guaranteed to not being overrun. This means that you
> have no way to analyze the system and that you can make no assumptions
> about your tasks meeting their deadline or not, about who's going to
> miss it, by how far, etc.

We now agree that bandwidth reservation comes in very handy. But we
still feel that making use of RT bandwidth itself and reserving some
for EDF is sufficient. We are working on getting this up. Having said
this, further, let us know if we are missing anything here or we
understood it wrong. According to our understanding, we see that the
Bandwidth reservation + 'budgeting' in your patch has the following
impact on the system:

1. Admission Control made configurable
2. DOMINO effect
3. System analysis
4. Replenishment of deadlines to the task missing their deadlines.

1. Admission Control made configurable

You take in something called as a "budget" and "deadline" from the
user and these parameters decide the sanity of the entire real-time
system.

How does the user provide "budget" ?
- If the budget of a task is its WCET, then admission control works
just fine here.
- If the budget of a task is less than its WCET, admission control
does not have much meaning, right?

So, what we have different in our designs w.r.t how user sees it?

- We depend on user to provide meaningful deadlines. You depend on
user to provide meaningful deadlines + meaningful budget.

- We depend on user / system architect to decide the schedulability of
a task set. You take in the numbers from the user, but calculate it
yourself. OK, that way you have some configurabality!

2. DOMINO effect

You prevent Domino effect by checking the available bandwidth against
the budget, when you see that the task will not finish in the
remaining bandwidth, you push  the task out. you replenish the budget
and the deadline for the task for the next execution cycle. And now, I
guess you are sending a signal to the user.

We prevent this by sending a signal to the user and the default
handler kills the task, thus not affecting the deadlines of the other
tasks.

3. System Analysis

You can analyse the system about your tasks meeting their deadline or
not, about who's going to miss it, by how far "a priori". Also, This
is fair only if your budgeting is done well.

Agree, we cannot do any analysis "prior" to missing its deadline. I
cant yet figure a use case where system analysis is absolutely
required in a real-time scenario while execution, but while trial and
error, this might definitely come in handy. For me, task either misses
a deadline, or successfully completes in-time, probably only
sufficient while in runtime.

4. Replenish deadline of the deadline missed task

Hmm, cant yet understand a good use case of this. If user "wants" to
do this, he can do it from the signal handler itself in our case. But
we still feel doing that yourself without the user knowing it is
changing the very "meaning" of a task deadline!

I guess this comes in use for a periodic task?? Correct me if I am
wrong, but "replenishment of a task deadline" for a non-periodic task
---- doesnt make any sense for its very meaning of a deadline is
lost...

If this is for a periodic task, and "postponing" a given user
_deadline_ is _tolerable_ in the system, why do you need EDF for this?
Wont an FP scheduler take better care in such case??


>
> You can have an EDF task A executing for more than what you expected (if
> you expected something, and you _should_ expect something if you want to
> analyze the system at some level, don't you?) and maybe missing its
> deadline.

When user specifies a deadline, the task should finish within its
deadline, thats his expectation!! About missing its deadline, thats
where the fault handler comes into picture where user also specifes
the time before deadline when the handler is fired..

>
> Much more worse, you can have task A executing for more than what you
> expected and making task B and/or C and/or WHATEVER missing _their_
> deadline, even if they "behave well"... This is far from real-time
> guaranteed behaviour, at least in my opinion. :-(

If task 'A' is getting executed, that means, task A has the earliest
deadline, task B and C cannot miss their deadline just because task
'A' is getting executed -- it 'cant' get executed for more than what
is expected in the system unless user specifies so, remember?
According to my expectation task A should finish within the deadline.
If it does not, it depends upon the user what to do with the task like
increase the deadline, or terminate it. We send a signal to the
process intimating the same. And if every task behaves well and all
the task parameters are "respected during actual execution" I don't
see any reason why other tasks would miss their deadline if the task
set is proper in the system.
>
>> If the user puts all his EDF tasks in
>> priority 1 , only his tasks run. In that case the entire RT bandwidth
>> is reserved for the EDF tasks. In a way your patch also does the same
>> thing by placing itself above the RT scheduling class.
>>
> Agree on this, never said something different. :-)
>
> At least it is well known that deadline tasks have higher priority than
> FIFO/RR tasks that have higher priority than OTHER tasks. This, together
> with reservation based scheduling at the task (or at least task-group)
> level is what make the system analyzable and predictable.
>

ya ya.. analysable is something we lack here !! totally agreed..... :)

>> Only thing what
>> we don't have in place is partitioning of RT bandwidth across RR/FIFO
>> and EDF, which right now, we overcome by intelligently placing the
>> tasks with different policies in different priority levels.
>>
> I'm not finding the 'intelligent placing' in the patch, so I guess this
> is up to the userspace. Providing the userspace with a flexible solution
> is something very useful... Relying on userspace to do things
> 'intelligently' is something I'm not sure I would do, especially in a so
> much general purpose OS like Linux, used in so much different contexts.
> But, again, that's only my opinion. :-)

Hmm I guess you too are "totally" dependent on user giving you the
right parameters _intelligently_ (deadline / budget)... I guess we are
not too different there expecting the users to be _aware_ ..!

>
> If I understood the code well (somme comments here and there would have
> helped! :-P) one (or more) EDF task(s) can starve FIFO/RR tasks, which
> may happen to me as well. However, it also may happen that one (or more)
> FIFO/RR task(s) starve EDF tasks!
>
> Thus, there always could be someone which might be starved and you can't
> even say who it will be... Again, this seems lack of determinism to me.

Right, but now that we agree on Bandwidth reservation with RT class,
this will be thankfully, resolved.

>
>> If you are asking bandwidth reservation for guaranteeing determinism,
>> we definitely have determinism in place, but bandwidth reservation for
>> other real-time scheduling policies is not in place.
>>
> See? World is so beautiful because there are so much different possible
> opinions and interpretations of the same concepts! :-D :-D
>

Differences in Language and communication makes it even more beautiful!!!! ;-)

>> > - admission test should guarantee no oversubscription
>>
>> So, you are calculating the WCET online in the scheduler right?
>>
> No, I don't... Did you looked at the code?
>
>> Can it
>> calculate the amount of CPU time with the  required preciseness? Here,
>> you are increasing the enqueue time by adding an O(n) calculation for
>> every task that you enqueue.
>>
> No, I don't... Did you looked at the code? :-P
>
>> That is the reason why for a small
>> system, pushing this to architect made better sense in terms of
>> decreased latencies where the turn around time from when the task
>> enters till it gets the desired result matters, e.g., reading a sensor
>> 2 times in 1ms.
>>
> Given the fact that I do not have anything in the scheduler that
> increase latencies and enqueue/dequeue overhead, it sure depends on
> you're target, as already said.
>
> You keep saying that for a small system it is up to the system architect
> to check if the configuration will be schedulable or not, which may be
> reasonable.
> What I'm wondering is how this poor guy might do that and hope to have
> this enforced by a scheduling policy which allows a task to interfere
> with all the other ones to the point of making them missing their
> deadlines... And this could happen in your code, since you only have
> deadline miss based checks, which may be not enough to prevent it.
>

Well, this in your case depends on the sanity of the 'budget" the user
provides, the same way it depends on the sanity of the "deadline" the
user provides. And, _NO_, a task missing its deadline _cannot_ make
other tasks miss their deadline too if the deadlines given are sane.

>> > That's why we changed the name and the interface from _EDF/_edf (yep, it
>> > has been our first choice too! :-P) to _DEADLINE/_deadline, and that's
>> > why I think we should continue striving for even more
>> > interface-algorithm independence.
>> >
>> True, but we really think its a matter of trade-off between how much
>> response time you can guarantee for a real-time task v/s how much
>> scalable you want your design to be.
>>
> Well, I'm not seeing how trying to have a better interface/algorithm
> separation would affect the response time that much... For example, I
> don't expect that putting your code in a separate scheduling class would
> make you miss some deadline...
>
>> The deterministic response times
>> that you might have achieved by having all these features might be
>> good enough (Not sure of your numbers here) in a soft real time
>> scenario, but wondering if it would meet ends otherwise.
>>
> The response time I can achieve with all these features is exactly the
> same you can achieve with the current FIFO/RR task, which have more or
> less the same features. Actually, the scheduling overhead is even
> smaller than in rt tasks since we are still able to enforce bandwidth
> without the need of hierarchical scheduling and accounting...
>
> The added feature of being able to asking the scheduler that you don't
> want you're task response time, latency and ability to meet its deadline
> to be affected by some other task which is running away comes with no
> price in therms of response time.
>
> By the way, what numbers do you miss here? Just ask and I'll do my best
> to provide them to you...
>
>> Yes, the target was industrial control systems where we needed
>> deterministic real-time response and also the responsiveness of the
>> task was critical. Here, the demanding real-time tasks were not too
>> many (~4/5 at a given point in time) and also, there were other user
>> tasks which had to update the results of this real-time task remotely.
>> Hence, we were very vary of introducing latencies in the system.
>> Instead, we focused on bringing in determinism into the system without
>> increasing its latency!
>>
> Hey, 'the system' already has a scheduling policy called SCHED_FIFO
> which already have _a_lot_ of determinism... and EDF is **not** more
> deterministic than fix-priority! There are people that like more EDF
> than FP, there are people that like more FP than EDF, they both have
> advantages and drawbacks, but implementing EDF can't be claimed as
> 'bringing determinism'...
>
> So, now I'm curious :-D.
>
> You say you need EDF in that application scenario, which might be more
> than true, but the reason can't be 'lack of determinism' since FP
> scheduling is as much deterministic as you want/are able to configure it
> using the correct priorities... So what was your problem with it?
>
>> Also, the concept of a deadline miss handler
>> was very handy, for a task missing its deadline not to interfere with
>> the determinism of the other tasks.
>>
> Oh, ok. But I think we can agree that you can have a task that, as said
> above, not miss its own deadline --and thus you don't catch it-- but
> makes all the other tasks in the system to miss their own ones!
>
> How your definition of determinism applies on this situation? :-O

If the task deadlines are proper and "respected" during actual
execution, and user supplies correct deadlines to the tasks I donot
see any reason why the system is not deterministic!!
>
>> > Mmm... I'm not sure I see why and how your patch should affect context
>> > switches duration... However, do you have the testcases for such tests?
>> >
>>
>> Well we are actually saying that it does _not_ effect the context
>> switch time :).
>>
> Which was expectable...
>
>> We are measuring the time when a task is entered in the system till it
>> gets scheduled both in preemptive and non-preemptive modes. This
>> figure does not change even for a loaded system which shows the
>> deterministic turn around time for a task in terms of scheduling
>> latencies.
>>
> ... Ok, it seems I need to be more explicit here: do you have the code
> of the tests, so that someone else can reproduce them?
>
It measures the time from the dequeue of the previous task to the
scheduling of the next task in the queue. Just variables to catch
times in the kernel and the user app would do..

Regards,
Shubhro
Soumya
