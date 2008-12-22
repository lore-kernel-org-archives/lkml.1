Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYLVJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYLVJAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYLVJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:00:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:65390 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYLVJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HDO3/T0Ou76F6DdWu7sch3oRD74BJaq8Fa3M+dEh5S2LDvbYnV0MWuRnqXSK0hV+np
         NgnTmMx5hEYFkUdW/Krrrzt7wOiQFW9tf5ths4Eq4bSlcd7IuuxxqPQd3jtAb+CfUszn
         6knKDje45NpyZtDVHGfwfiRgfquNsUqswXn6w=
Message-ID: <c62985530812220100m775c2e5ek5889f7891e4c1f4d@mail.gmail.com>
Date: Mon, 22 Dec 2008 10:00:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while interrupt hanging
Cc: "Frans Pop" <elendil@planet.nl>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081222070044.GC29160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl>
	 <20081222070044.GC29160@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Frans,

2008/12/22 Ingo Molnar <mingo@elte.hu>:
>
> * Frans Pop <elendil@planet.nl> wrote:
>
>> > Impact: avoid hanging on slow systems
>> >
>> > While using the function graph tracer on a virtualized system, the
>> > hrtimer_interrupt can hang the system on an infinite loop. This can be
>> > caused on several situation where something intrusive is slowing the
>> > system (ie: tracing) and the next clock events to program are always
>> > before the current time. This patch implements a reasonable
>> > compromise. If such a situation is detected, we share the CPUs time in
>> > 1/4 to process the hrtimer interrupts. This is enough to let the
>> > system running without serious starvation.
>>
>> Should there maybe also be a mechanism to allow the system to
>> automatically "recover" to higher (the original?) clockfrequencies, for
>> example if the danger of loops has passed after tracing has been
>> disabled?
>
> I dont think that's necessary - tick_dev_program_event() already includes
> a gradual approach that increases the 'min delta' interval step by step -
> so we should find the 'system is limping along' compromise pretty
> accurately.


When you force the clock reprogramming to tick_dev_program_event(),
clockevents_program_event()
will fail a first time (like before because of tracing or whatever)
and then it will rebuild the next event:

now = ktime_get();
expires = ktime_add_ns(now, dev->min_delta_ns);

This one never failed on my tests.
So the above tricks which increases the min delta:

dev->min_delta_ns += dev->min_delta_ns >> 1

...is never reached.

But this is not enough. If I leave the things as is, the system
will success to reprogram the clock but in a delay which can be really too low.
It's almost worst: the system will not lock up anymore but will run in
an infinite and huge starvation
The effect is the same: a hang-up but without a soft lock-up warning
this time (it's worst).

That's why I'm dynamically adapting the min_delta along the time spent
to process
the hrtimer interrupt to reserve 1/4 to the latter.
This way, it is able (in theory) to solve the problem whatever the
frequency or the amount of slowness.

Note that I could have changed the things directly inside
tick_dev_program_event(), but there are multiple call
sites to this function and I couldn't be sure I'm not breaking something else.

> A system can get "magically faster" later on (if we turn off tracing or
> other kernel features that impact the cost of the timer tick), and we
> might not need those safety measures anymore - but here the real solution
> will be to make the virtualizer faster. Taking milliseconds to process a
> timer tick (be that under tracing or not) is rather slow. So the kernel
> has applied the brakes and has printed a warning about it - we should do
> no more.
>
>> > +static int force_clock_reprogram;
>>
>> Shouldn't this be initialized to 0?
>
> no - global or static scope variables are initialized to zero in C.
>
>> > @@ -1239,7 +1267,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>> >         /* Reprogramming necessary ? */
>> >         if (expires_next.tv64 != KTIME_MAX) {
>> > -               if (tick_program_event(expires_next, 0))
>> > +               if (tick_program_event(expires_next, force_clock_reprogram))
>> >                     goto retry;
>> >         }
>> >  }
>>
>> Shouldn't force_clock_reprogram be reset to 0 after it has fired and
>> been handled?
>
> hm, that would be interesting to see - in theory the system should become
> stable after a few iterations of increasing min_delta. Frederic, is the
> system still workable if you try what Frans has suggested?


No, if you don't force the clock reprogramming, and the usual case
continue to build
a clock event before the current time, the min delta will not be used
and you will get
a -ETIME error.

> Also, there's min_delta doubling in tick_dev_program_event() itself too -
> that interacts with the irq-overload logic:
>
> +       dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
>
>        Ingo
>

That's what I explained above, the doubling of min delta in
tick_dev_program_event() is never reached in
my case. And moreover I'm not sure it is ever reached whatever the
call sites of tick_dev_program_event()
unless min delta has a very low value...
