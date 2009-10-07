Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZJGHbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZJGHbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZJGHbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:31:49 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:36001 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbZJGHbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <1254893230.30157.28.camel@eenurkka-desktop>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <1254814298.31336.63.camel@eenurkka-desktop>
	 <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
	 <1254825795.31336.204.camel@eenurkka-desktop>
	 <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
	 <1254832609.31336.290.camel@eenurkka-desktop>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
Date: Wed, 7 Oct 2009 00:30:37 -0700
Message-ID: <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Steven Noonan <steven@uplinklabs.net>
To: ext-eero.nurkkala@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 10:27 PM, Eero Nurkkala
<ext-eero.nurkkala@nokia.com> wrote:
> On Wed, 2009-10-07 at 03:22 +0200, ext Steven Noonan wrote:
>> >>
>> >> Tracers may by themselves add some load into the system.
>> >>
>> >> If I were you, I'd add something like: (I have only one CPU BTW)
>> >>
>> >> static ktime_t time_prior_idle;
>> >> static int64_t idle_total;
>> >>
>> >> time_prior_idle = ktime_get();
>> >> <idle stuff>
>> >> idle_total += ktime_to_ns(ktime_sub(ktime_get(), time_prior_idle));
>> >>
>> >> and have a sysfs hook (something already present, so you can just cat
>> >> it) with a trace:
>> >>
>> >> printk("Times: %lld, %lld \n", idle_total, ktime_to_ns(ktime_get()));
>> >>
>> >> Sample output:
>> >> 374758812519, 386768249832
>> >>
>> >> So I have 386768249832 / 386768249832 = 96.9 % time spent in idle in
>> >> this case.
>> >>
>> >> (Right, this should provide somewhat descent info, hopefully ;) )
>> >>
>> >
>> > Well, I tried adding the code to cpu_idle() as suggested, but it never
>> > printed anything. Apparently cpu_idle() isn't ever being called here.
>> > Even added a 'BUG();' at the beginning of the function and it never
>> > hit it. Of course, I'm probably missing something obvious. Is there a
>> > separate cpu_idle()-esque function for SMP?
>> >
>>
>> Oh crap. Perhaps it's more insidious. I reverted the bisected commit
>> and it _DID_ hit the line I added. So cpu_idle is never entered with
>> the bisected commit. Bizarre.
>>
>> - Steven
>
> So you're saying that cpu_idle() is not ever called.. The commit in
> question - whether you got it or had it reverted - should, and must not
> be a trigger for your system to hit cpu_idle(). What if you took a look
> at init/main.c, and added traces before the first call to cpu_idle():
>
> start_kernel() ->
> rest_init() ->
> cpu_idle()

Okay, wow, I'm a moron. I misread what cpu_idle() was intended to be
for. I thought that cpu_idle() was a function that was periodically
called whenever the CPU had nothing to do, but now I see that it's
actually the main loop. I should really read the code next time.

I've moved the statistics printout code to the _inside_ of that
infinite loop and retested. I had it print every several hundred
iterations. Here's the results (note the machine was idle the whole
time, except for about the first 10-20 seconds while the machine
booted):

[    3.627716] timings[0]: 2250511125 / 3627716116
[    6.946216] timings[0]: 4780901366 / 6946213531
[   13.355182] timings[0]: 9385417604 / 13355183525
[   18.551304] timings[1]: 16300853077 / 18551301189
[   21.589039] timings[0]: 15984495433 / 21589037480
[   47.152733] timings[1]: 44386121538 / 47152731476
[   51.682630] timings[0]: 45713834076 / 51682628295
[   79.587359] timings[0]: 73524821916 / 79587356820
[   88.630110] timings[1]: 85324277596 / 88630109605
[   96.082386] timings[0]: 89691306072 / 96082384539


>
> With the patch not reverted?
>
> So I guess, that an irq may actually start your "system up" (patch
> reverted) somehow:
>
> irq_exit() ->
> tick_nohz_stop_sched_tick() ->
> tick_nohz_start_idle() ->
> sched_clock_idle_sleep_event() ?
>
> So it looks that maybe the conservative governor isn't broken after
> all ;)

Symptomatically, it is broken. But it's likely just that: a symptom of
a larger issue.

>
>
> (BTW I guess, with SMP, you may wish to have fix things to work in your
> setup
> static ktime_t time_prior_idle[2];
> static int64_t idle_total[2];
> and
> time_prior_idle[smp_processor_id()] = ktime_get();
> etc, and print out times separately).
>
> - Eero
>
>
