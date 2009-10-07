Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbZJGIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbZJGIxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbZJGIxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:53:14 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:59343 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZJGIxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <1254905013.30157.75.camel@eenurkka-desktop>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
	 <1254901778.30157.62.camel@eenurkka-desktop>
	 <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com>
	 <1254903263.30157.69.camel@eenurkka-desktop>
	 <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>
	 <1254905013.30157.75.camel@eenurkka-desktop>
Date: Wed, 7 Oct 2009 01:52:36 -0700
Message-ID: <f488382f0910070152y1c09602by444fd9466912bbb5@mail.gmail.com>
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Steven Noonan <steven@uplinklabs.net>
To: ext-eero.nurkkala@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 1:43 AM, Eero Nurkkala
<ext-eero.nurkkala@nokia.com> wrote:
> On Wed, 2009-10-07 at 10:24 +0200, ext Steven Noonan wrote:
>> >
>> > Steven, how do the cpu loads look like without the patch?
>>
>> They're sane:
>>
>> [   40.019381] cpufreq load = 100 * (66666 - 66337) / 66666 = 0
>> [   40.019396] cpufreq load = 100 * (66666 - 66299) / 66666 = 0
>> [   73.352580] cpufreq load = 100 * (66717 - 66349) / 66717 = 0
>> [   73.352595] cpufreq load = 100 * (66634 - 63848) / 66634 = 4
>
> Thank you. Could you please try the following:
> Now, if ts->nohz_mode == NOHZ_MODE_INACTIVE, ts->inidle is not set
> and all subsequent calls from irq_exit() think we weren't idling,
> which is not true.
>
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -233,6 +233,8 @@ void tick_nohz_stop_sched_tick(int inidle)
>
>        now = tick_nohz_start_idle(ts);
>
> +       ts->inidle = 1;
> +
>        /*
>         * If this cpu is offline and it is the one which updates
>         * jiffies, then give up the assignment and let it be taken by
> @@ -248,8 +250,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>        if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
>                goto end;
>
> -       ts->inidle = 1;
> -
>        if (need_resched())
>                goto end;
>

Yeah, that fixed it. The load is now sane, my system isn't heating up,
and 'conservative' is now clocking my CPU down to the minimum as is
appropriate.

Can you explain why this only affected 'conservative', why it caused
my machine to heat up, etc?

Also, this fix should probably be passed on to Greg K. H. (so it goes
in 2.6.31-stable) as well as Ingo Molnar (so it goes into -tip, and
hopefully to Linus for 2.6.32). Both CC'd.

- Steven
