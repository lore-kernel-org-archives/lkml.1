Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZIWNWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZIWNWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZIWNWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:22:10 -0400
Received: from ms01.sssup.it ([193.205.80.99]:51000 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbZIWNWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:22:09 -0400
Message-ID: <4ABA20FF.4020601@evidence.eu.com>
Date: Wed, 23 Sep 2009 15:22:07 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir> <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
In-Reply-To: <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Walleij ha scritto:
> Hi Raistlin,
> 
> it's great fun to see this scheduler materialize, I was present at the
> workshop in Kaiserslautern and waited for the code since. What I'm
> interested in getting a briefing on right now is what practical use EDF
> schedulers have, since I think this is what many people will ask for.
> 
> I think actually the answers are the same as when I asked at Meld
> (of all places) what HRtimers are actually for. And I I got the non-all
> inclusive answer that they're for Flight simulators.
> Which is obviously in the domain of automatic control.
> http://en.wikipedia.org/wiki/Automatic_control
> 
> So one application of HRTimers has been to trigger events in
> userspace programs, especially when your dealing with issues
> related to automatic control. Automatic control is also
> mentioned throughout this patch. (Yes, I know HRtimers
> have other great uses also, especially in-kernel, those will
> remain.)
> 
> I am very interested in if you or someone else
> could elaborate on the relation between HRtimers and deadline
> scheduling. To my untrained mind it looks like HRtimers will
> fire events to your task in a very precise manner, but
> you cannot currently guarantee that they will then proceed to
> process their target task in time (meet a deadline).

Yes. With HRT you have timing measures with a higher resolution than 
using normal timers. This means that everything in the system runs more 
precisely, and latencies are reduced.

However, "how" it runs, depends on the scheduling algorithm, which is 
the part of the kernel that at any instant chooses which task must be 
executed. Our scheduling class introduces the chance of ordering tasks 
execution in a further manner, that is according to the Earliest 
Deadline First (EDF) algorithm. Therefore, after the patch is applied, a 
new scheduling policy is available for scheduling tasks. Consider that 
old policies (sched_fair and sched_rt) still remain, and you are not 
forced to use EDF ordering. This way, if you don't use EDF tasks, the 
system still behaves as without our patch.

> I'm under the impression that some people currently use
> some periodic HRtimers (through either the timerfd_create system
> call I guess, or POSIX timer_create(CLOCK_REALTIME_HR...)
> timers combined with some SHED_FIFO or so to achieve the same
> thing a deadline scheduler would do, but since SCHED_FIFO cannot
> really guarantee that this will work, you simply underutilize
> the system a bit, add the CONFIG_PREEMPT_RT patch so the
> timers are not blocked by things like slow interrupthandlers or
> starvation (priority inversion) and then hope for the best. It turns
> out to work. You measure on the system and it has the desired
> "hard realtime" characteristics.

Let's take a step back. The problem in real-time scheduling is to find 
an order of scheduling tasks so that each of them meets its deadlines. 
This way, you get determinism and predictability (i.e., you can trust 
that your tasks will be executed at the "right" instant of time).
Several scheduling algorithms exist to generate different orders of 
execution that ensure this property.

In particular, several differences exist between fixed priority and 
dynamic priority algorithms (like SCHED_EDF). In my opinion, the most 
relevant is the following one.

Suppose you have a single processor and a set composed by periodic 
real-time tasks, each one characterized by an amount of execution time 
("budget") that must be executed every "period". This way, the deadline 
for each task is equal to the end of its current period.

The sum of (budget/period) of all tasks is usually called "bandwidth".

Using fixed priority schedulers, you need a quite complicated equation 
to understand if it is possible to guarantee the deadlines of every 
task. This equation must be re-computed each time you change a budget or 
period of some task.
Even worse, depending on the task set, it may happen that the bandwidth 
must be lower than 100% (sometimes as low as 69%), otherwise you cannot 
be sure that all tasks will meet their deadline (they might, but you 
cannot trust).

With EDF, instead, the test is much easier: if the bandwidth is less 
than 100%, then you are sure that the deadlines will be met. In other 
words, you can fully exploit processor bandwidth up to 100% being sure 
that timing constraints of EDF tasks will be guaranteed.

> Do people do such things? I haven't seen those applications,
> they all tend to be closed-source really. I would assume the
> vxWorks/pSOS/etc compatibility wrapper libraries do things
> like this, do they not?

Well, ACTORS is an example of an industrial application which needs an 
EDF scheduler on Linux, isn't it ?

But I've also seen a couple of multimedia applications which needed an 
EDF scheduler to meet deadlines of periodic tasks and, at the same time, 
exploit CPU utilization up to 100%.

Regards,

             Claudio
